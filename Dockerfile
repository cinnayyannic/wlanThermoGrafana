FROM ubuntu:18.04

MAINTAINER Yannic Wilkening

EXPOSE 3003
EXPOSE 8086

# Default versions
ENV INFLUXDB_VERSION=1.7.10
ENV GRAFANA_VERSION=6.5.3

RUN usermod -a -G dialout root

RUN apt-get update && apt-get install -y \
	git \
	nano \
	build-essential \
	wget \
	python \
	supervisor
	
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	rm influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb && \
    dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && \
	rm grafana_${GRAFANA_VERSION}_amd64.deb

#RUN git clone https://github.com/dresden-elektronik/deconz-rest-plugin.git && \
#	cd deconz-rest-plugin && \
#	git checkout -b mybranch V2_04_77 && \
#	qmake && \
#	make -j2 && \
#	cp ../libde_rest_plugin.so /usr/share/deCONZ/plugins

# Supervisord configuration file
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Influxdb configuration file
COPY conf/influxdb.conf /etc/influxdb/influxdb.conf

# Grafana configuration file
COPY conf/grafana.ini /etc/grafana/grafana.ini

ADD start.sh /
RUN chmod +x ./start.sh

CMD ["./start.sh"]