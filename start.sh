#!/bin/bash

# deploy config files to shared volumes
mkdir -p /var/lib/mosquitto/
mv /deploy/mosquitto/mosquitto.passwd /var/lib/mosquitto/

exec /usr/bin/supervisord