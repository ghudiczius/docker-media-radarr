FROM mono:6.8.0.96

ARG VERSION

RUN apt-get update && \
    apt-get --assume-yes install mediainfo && \
    groupadd --gid=1000 radarr && \
    useradd --gid=1000 --home-dir=/opt/radarr --no-create-home --shell /bin/bash --uid 1000 radarr && \
    curl --location --output /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.develop.${VERSION}.linux.tar.gz" && \
    tar xzf /tmp/radarr.tar.gz --directory=/opt/radarr --strip-components=1 && \
    mkdir /config /downloads /movies && \
    chown --recursive 1000:1000 /config /downloads /movies /opt/radarr

USER 1000
VOLUME /config /downloads /movies
WORKDIR /opt/radarr

EXPOSE 7878
ENTRYPOINT ["mono", "/opt/radarr/Radarr.exe", "-data=/config", "-nobrowser"]
