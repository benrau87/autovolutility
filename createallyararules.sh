#!/bin /bash
#use to create an index to include all yara rules in the /etc/VolUtility/yararules/   path
cd /etc/VolUtility/
#check for existing rule directory and update
if [ -d /etc/VolUtility/rules ]; then
    cd /etc/VolUtility/rules
    git pull
else
  git clone https://github.com/VirusTotal/yara.git
fi
#Remove non working rules
#Copy over rules 
cp rules/**/*.yar yararules/
rm yararules/Android* 
rm yararules/vmdetect.yar  
rm yararules/antidebug_antivm.yar  
rm yararules/MALW_AdGholas.yar  
rm yararules/APT_Shamoon*.yar  
rm yararules/peid.yar 
rm yararules/allrules.yar
#Create allrule.yar index
touch allrules.yar
ls /etc/VolUtility/yararules > allrules.yar
sed -i -e 's/^/include "/' allrules.yar
sed -i -e 's/$/"/' allrules.yar
mv allrules.yar /etc/VolUtility/yararules/allrules.yar

