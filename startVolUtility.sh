#!/bin/bash

bash /etc/VolUtility/createyararules.sh
python /etc/VolUtility/manage.py runserver 0.0.0.0:80

