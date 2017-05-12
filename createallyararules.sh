#!/bin /bash
#use to create an index to include all yara rules in the /etc/VolUtility/yararules/   path

rm /etc/VolUtility/yararules/allrules.yar
touch allrules.yar
ls /etc/VolUtility/yararules >allrules.yar
sed -i -e 's/^/include "/' allrules.yar
sed -i -e 's/$/"/' allrules.yar
mv allrules.yar /etc/VolUtility/yararules/allrules.yar

