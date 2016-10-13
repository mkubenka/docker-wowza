FROM sameersbn/ubuntu:14.04.20160727
MAINTAINER sameer@damagehead.com

ENV WOWZA_VERSION=4.5.0 \
    WOWZA_DATA_DIR=/var/lib/wowza \
    WOWZA_LOG_DIR=/var/log/wowza

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y wget supervisor openjdk-7-jre expect \
 && rm -rf /var/lib/apt/lists/*

COPY prepare.sh interaction.exp /app/
RUN /app/prepare.sh

RUN mkdir /opt/jolokia \
    && wget -O /opt/jolokia/jolokia-jvm-1.3.5-agent.jar http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.5/jolokia-jvm-1.3.5-agent.jar

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 1935/tcp 8086/tcp 8087/tcp 8088/tcp 8778/tcp
VOLUME ["${WOWZA_DATA_DIR}", "${WOWZA_LOG_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
