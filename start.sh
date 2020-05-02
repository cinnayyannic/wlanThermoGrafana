#!/bin/bash

# deploy config files to shared volumes
#mkdir -p /var/lib/grafana/dashboards/
#mv /deploy/grafana/wlanthermo.json /var/lib/grafana/dashboards/
#mkdir -p /var/lib/mosquitto/
#mv /deploy/mosquitto/mosquitto.passwd /var/lib/mosquitto/

exec /usr/bin/supervisord