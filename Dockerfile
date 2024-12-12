FROM mcr.microsoft.com/dotnet/runtime:5.0

ARG VERSION=5.12.2.9335

# renovate: release=bullseye depName=curl
ENV CURL_VERSION=7.88.1-10+deb12u8
# renovate: release=bullseye depName=libsqlite3-0
ENV LIBSQLITE3_VERSION=3.40.1-2+deb12u1
# renovate: release=bullseye depName=mediainfo
ENV MEDIAINFO_VERSION=18.12-2

RUN apt-get update && \
    apt-get --assume-yes install \
        curl="${CURL_VERSION}" \
        libsqlite3-0="${LIBSQLITE3_VERSION}" \
        mediainfo="${MEDIAINFO_VERSION}" && \
    groupadd --gid=1000 radarr && \
    useradd --gid=1000 --home-dir=/opt/radarr --no-create-home --shell /bin/bash --uid 1000 radarr && \
    mkdir /config /downloads /movies /opt/radarr && \
    curl --location --output /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.master.${VERSION}.linux-core-x64.tar.gz" && \
    tar xzf /tmp/radarr.tar.gz --directory=/opt/radarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /movies /opt/radarr && \
    rm /tmp/radarr.tar.gz

USER 1000
VOLUME /config /downloads /movies
WORKDIR /opt/radarr

EXPOSE 7878
CMD ["/opt/radarr/Radarr", "-data=/config", "-nobrowser"]
