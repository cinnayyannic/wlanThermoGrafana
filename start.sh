#!/bin/bash

mv /deploy/grafana/wlanthermo.json /var/lib/grafana/dashboards/
mv /deploy/mosquitto/mosquitto.passwd /var/lib/mosquitto/

exec /usr/bin/supervisord