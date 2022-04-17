FROM busybox AS BUILD

ARG VERSION=1.6.1
ARG JAR=https://github.com/Pugmatt/BedrockConnect/releases/download/$VERSION/BedrockConnect-1.0-SNAPSHOT.jar

RUN wget $JAR -O /tmp/BedrockConnect.jar 

FROM adoptopenjdk/openjdk11:alpine-jre

RUN mkdir -p /opt/brc /config

COPY --from=BUILD /tmp/BedrockConnect.jar /opt/brc
COPY servers.json ./config/

WORKDIR /opt/brc

VOLUME /config

EXPOSE 19132/udp

ENTRYPOINT ["java", "-Xms1G", "-Xmx1G", "-jar", "BedrockConnect.jar", "nodb=true", "custom_servers=/config/servers.json"]