FROM mono:6.8.0.96-slim

ARG VERSION

RUN apt update && \
    apt-get install mediainfo && \
    groupadd -g 1000 radarr && \
    useradd -d /home/radarr -g 1000 -m -s /bin/bash -u 1000 radarr && \
    curl -Lo /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.develop.${VERSION}.linux.tar.gz" && \
    tar xvzf /tmp/radarr.tar.gz -C /opt && \
    mkdir /config /downloads /movies && \
    chown -R 1000:1000 /config /downloads /movies /opt/Radarr

USER 1000
VOLUME /config /downloads /movies
WORKDIR /home/radarr

EXPOSE 7878
ENTRYPOINT ["mono", "/opt/Radarr/Radarr.exe", "-data=/config", "-nobrowser"]
