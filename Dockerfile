FROM ubuntu:20.04

WORKDIR /root/
ENV HOME /root

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DISPLAY :0

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends \
        software-properties-common apt-utils supervisor wget tar gpg-agent bbe netcat-openbsd net-tools \
		xvfb x11vnc fluxbox socat unzip libxtst6 libxrender1 libxi6 \
        git python python3 python3-setuptools python3-numpy python3-pip python3-tz \
        python3-psycopg2 python3-dateutil python3-sqlalchemy python3-pandas &&\
    # Cleaning up.
    apt-get autoremove -y --purge && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q -O - https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.2.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
RUN wget -q -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify

# Set env vars for IBG/IBC
ENV IBG_VERSION=984-latest \
	IBC_VERSION=3.8.7 \
	IBC_INI=/opt/ibc/config.ini \
	IBC_PATH=/opt/ibc \
	TWS_PATH=/root/Jts \
	TWS_CONFIG_PATH=/root/Jts \
	LOG_PATH=/opt/ibc/logs \
	TWS_PORT=4001

# Install IBG
RUN wget -q -O /tmp/ibgateway-standalone-linux-x64.sh https://s3.amazonaws.com/ib-gateway/ibgateway-${IBG_VERSION}-standalone-linux-x64.sh && \
	chmod u+x /tmp/ibgateway-standalone-linux-x64.sh && \
	echo '\n\r' | sh /tmp/ibgateway-standalone-linux-x64.sh -c && \ 
	rm -f /tmp/ibgateway-standalone-linux-x64.sh

# Install IBC
RUN wget -q -O /tmp/IBC.zip https://github.com/ibcalpha/ibc/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip && \
	unzip /tmp/IBC.zip -d ${IBC_PATH} && \
	chmod -R u+x ${IBC_PATH}/*.sh && \
	chmod -R u+x ${IBC_PATH}/scripts/*.sh && \
	apt-get remove -y unzip && \
	rm -f /tmp/IBC.zip

# Install ib_insync
RUN pip3 install ib_insync
	
ADD config.ini /opt/ibc/config.ini
ADD jts.ini /opt/ibc/jts.ini
ADD is_ibgw_running.py /root/is_ibgw_running.py
ADD updateConfig.py /root/updateConfig.py
ADD ibc_start.py /root/ibc_start.py

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
