#!/bin /bash
#use to create an index to include all yara rules in the /etc/VolUtility/yararules/   path
cd /etc/VolUtility/
rm /etc/VolUtility/yararules/allrules.yar
git clone https://github.com/VirusTotal/yara.git
cp rules/**/*.yar /etc/VolUtility/yararules/ &>> $logfile
touch allrules.yar
ls /etc/VolUtility/yararules >allrules.yar
sed -i -e 's/^/include "/' allrules.yar
sed -i -e 's/$/"/' allrules.yar
mv allrules.yar /etc/VolUtility/yararules/allrules.yar

