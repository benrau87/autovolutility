#!/bin/bash
cd /etc/VolUtility/
bash createallyararules.sh
python manage.py runserver 0.0.0.0:80

