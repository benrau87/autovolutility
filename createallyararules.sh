#!/bin /bash
#use to create an index to include all yara rules in the /etc/VolUtility/yararules/   path
cd /etc/VolUtility/

while [ ! -f /etc/VolUtility/yararules/allrules.yar ]
do
  rm /etc/VolUtility/yararules/allrules.yar
done

git clone https://github.com/VirusTotal/yara.git
rm etc/VolUtility/rules/Android* 
rm etc/VolUtility/rules/vmdetect.yar  
rm etc/VolUtility/rules/antidebug_antivm.yar  
rm etc/VolUtility/rules/MALW_AdGholas.yar  
rm etc/VolUtility/rules/APT_Shamoon*.yar  
rm etc/VolUtility/rules/peid.yar 
cp rules/**/*.yar /etc/VolUtility/yararules/ &>> $logfile
touch allrules.yar
ls /etc/VolUtility/yararules >allrules.yar
sed -i -e 's/^/include "/' allrules.yar
sed -i -e 's/$/"/' allrules.yar
mv allrules.yar /etc/VolUtility/yararules/allrules.yar

