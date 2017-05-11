#!/bin/bash
####################################################################################################################

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
gitdir=$PWD

##Logging setup
logfile=/var/log/volutility_install.log
mkfifo ${logfile}.pipe
tee < ${logfile}.pipe $logfile &
exec &> ${logfile}.pipe
rm ${logfile}.pipe

##Functions
function print_status ()
{
    echo -e "\x1B[01;34m[*]\x1B[0m $1"
}

function print_good ()
{
    echo -e "\x1B[01;32m[*]\x1B[0m $1"
}

function print_error ()
{
    echo -e "\x1B[01;31m[*]\x1B[0m $1"
}

function print_notification ()
{
	echo -e "\x1B[01;33m[*]\x1B[0m $1"
}

function error_check
{

if [ $? -eq 0 ]; then
	print_good "$1 successfully."
else
	print_error "$1 failed. Please check $logfile for more details."
exit 1
fi

}

function install_packages()
{

apt-get update &>> $logfile && apt-get install -y --allow-unauthenticated ${@} &>> $logfile
error_check 'Package installation completed'

}

function dir_check()
{

if [ ! -d $1 ]; then
	print_notification "$1 does not exist. Creating.."
	mkdir -p $1
else
	print_notification "$1 already exists. (No problem, We'll use it anyhow)"
fi

}
########################################
##BEGIN MAIN SCRIPT##
##Mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 &>> $logfile
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list &>> $logfile
error_check 'Mongodb repo added'

print_status "${YELLOW}Waiting for dpkg process to free up...${NC}"
print_status "${YELLOW}If this takes too long try running ${RED}sudo rm -f /var/lib/dpkg/lock${YELLOW} in another terminal window.${NC}"
while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
   sleep 1
done

##Update
print_status "${YELLOW}Performing apt-get update and upgrade (May take a while if this is a fresh install)..${NC}"
apt-get update &>> $logfile && apt-get -y dist-upgrade &>> $logfile
error_check 'Updated system'

##Main Packages
print_status "${YELLOW}Downloading and installing depos${NC}"
apt-get install -y build-essential checkinstall libjansson-dev python-dev python-pip pcregrep libpcre++-dev automake libtool gcc unzip libssl-dev mongodb-org &>> $logfile

##Start mongodb 
print_status "${YELLOW}Setting up MongoDB${NC}"
chmod 755 $gitdir/mongodb.service &>> $logfile
cp $gitdir/mongodb.service /etc/systemd/system/ &>> $logfile
systemctl start mongodb &>> $logfile
systemctl enable mongodb &>> $logfile
error_check 'MongoDB Setup'

##PIP packages
print_status "${YELLOW}Setting up PIP${NC}"
pip install --upgrade pip &>> $logfile
pip install distorm3 pycrypto pillow ujson  &>> $logfile
error_check 'PIP ready'
##Yara
cd $gitdir
print_status "${YELLOW}Downloading Yara${NC}"
#wget https://github.com/VirusTotal/yara/archive/v3.5.0.tar.gz &>> $logfile
git clone https://github.com/VirusTotal/yara.git &>> $logfile
error_check 'Yara downloaded'
#tar -zxf v3.5.0.tar.gz &>> $logfile
print_status "${YELLOW}Building and compiling Yara${NC}"
#cd yara-3.5.0
cd yara/
./bootstrap.sh &>> $logfile
./configure --with-crypto --enable-cuckoo --enable-magic &>> $logfile
error_check 'Yara compiled and built'
print_status "${YELLOW}Installing Yara${NC}"
make &>> $logfile
make install &>> $logfile
make check &>> $logfile
error_check 'Yara installed'

##Volatility
cd $gitdir
print_status "${YELLOW}Setting up Volatility${NC}"
wget https://github.com/volatilityfoundation/volatility/archive/2.6.zip &>> $logfile
error_check 'Volatility downloaded'
unzip 2.6.zip &>> $logfile
cd volatility-2.6 &>> $logfile
python setup.py build &>> $logfile
python setup.py install &>> $logfile
error_check 'Volatility installed'

##Volutility
cd $gitdir
print_status "${YELLOW}Setting up Volutility${NC}"
git clone https://github.com/kevthehermit/VolUtility &>> $logfile
cd VolUtility
pip install -r requirements.txt
