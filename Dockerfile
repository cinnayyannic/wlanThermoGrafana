FROM ubuntu:18.04

MAINTAINER Yannic Wilkening

EXPOSE 3003
EXPOSE 1883

# Tools
ENV INFLUXDB_VERSION=1.7.10
ENV GRAFANA_VERSION=6.5.3
ENV WLANTHERMOGRAFANABRIDGE_VERSION=v1.0.1

RUN apt-get update && apt-get install -y \
	git \
	nano \
	wget \
	curl \
	mosquitto \
	python3 \
	python3-pip \
	supervisor \
	libfontconfig
	
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	rm influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb && \
    dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && \
	rm grafana_${GRAFANA_VERSION}_amd64.deb

RUN git clone https://github.com/cinnayyannic/wlanThermoGrafanaBridge.git && \
	cd wlanThermoGrafanaBridge && \
	git fetch && git fetch --tags && \
	git checkout ${WLANTHERMOGRAFANABRIDGE_VERSION} && \
	pip3 install -r ./requirements.txt && \
	mv wlanThermoGrafanaBridge.py /usr/sbin && \
	cd .. && rm -rf wlanThermoGrafanaBridge

# Supervisord configuration file
COPY conf/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Influxdb configuration file
COPY conf/influxdb/influxdb.conf /etc/influxdb/influxdb.conf

# Mosquitto configuration file
COPY conf/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf
# Username: wlanthermo Passowrd: 5G=o7&d83@&dU&4c
COPY conf/mosquitto/mosquitto.passwd /var/lib/mosquitto/mosquitto.passwd

# Grafana configuration file
COPY conf/grafana/grafana.ini /etc/grafana/grafana.ini
COPY conf/grafana/wlanthermo.json /var/lib/grafana/dashboards/wlanthermo.json
COPY conf/grafana/provisioning/datasource.yaml /etc/grafana/provisioning/datasources/datasource.yaml
COPY conf/grafana/provisioning/dashboard.yaml /etc/grafana/provisioning/dashboards/dashboard.yaml

ADD start.sh /
RUN chmod +x ./start.sh

CMD ["./start.sh"]