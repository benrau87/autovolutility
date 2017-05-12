#!/bin /bash
#use to create an index to include all yara rules in the /etc/VolUtility/yararules/   path
cd /etc/VolUtility/
#check for exisiting rule file and remove
while [ ! -f /etc/VolUtility/yararules/allrules.yar ]
do
  rm /etc/VolUtility/yararules/allrules.yar
done
#check for existing rule directory and update
if [ -d /etc/VolUtility/rules ]; then
    cd /etc/VolUtility/rules
    git pull
else
  git clone https://github.com/VirusTotal/yara.git
fi
#Remove non working rules
cd /etc/VolUtility/
rm rules/Android* 
rm rules/vmdetect.yar  
rm rules/antidebug_antivm.yar  
rm rules/MALW_AdGholas.yar  
rm rules/APT_Shamoon*.yar  
rm rules/peid.yar 
#Copy over rule 
cp rules/**/*.yar /etc/VolUtility/yararules/
#Create allrule.yar index
touch allrules.yar
ls /etc/VolUtility/yararules >allrules.yar
sed -i -e 's/^/include "/' allrules.yar
sed -i -e 's/$/"/' allrules.yar
mv allrules.yar /etc/VolUtility/yararules/allrules.yar

