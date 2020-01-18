FROM mono:6.6.0.161

ARG VERSION

RUN groupadd -g 1000 radarr
RUN useradd -d /home/radarr -g 1000 -m -s /bin/bash -u 1000 radarr
RUN curl -Lo /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.develop.${VERSION}.linux.tar.gz"
RUN tar xvzf /tmp/radarr.tar.gz -C /opt
RUN mkdir /config /downloads /movies
RUN chown -R 1000:1000 /config /downloads /movies /opt/Radarr

USER 1000
VOLUME /config /downloads /movies
WORKDIR /home/radarr

EXPOSE 7878
ENTRYPOINT ["mono", "/opt/Radarr/Radarr.exe", "-data=/config", "-nobrowser"]
