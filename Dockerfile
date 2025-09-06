FROM mcr.microsoft.com/dotnet/runtime:9.0

ARG SOURCE_CHANNEL
ARG VERSION

# renovate: release=bookworm depName=curl
ENV CURL_VERSION=7.88.1-10+deb12u12
# renovate: release=bookworm depName=libsqlite3-0
ENV LIBSQLITE_VERSION=3.40.1-2+deb12u2
# renovate: release=bookworm depName=mediainfo
ENV MEDIAINFO_VERSION=23.04-1

RUN apt-get update && \
    apt-get --assume-yes --quiet install \
        curl="${CURL_VERSION}" \
        libsqlite3-0="${LIBSQLITE_VERSION}" \
        mediainfo="${MEDIAINFO_VERSION}" && \
    groupadd --gid=1000 radarr && \
    useradd --gid=1000 --home-dir=/opt/radarr --no-create-home --shell /bin/bash --uid 1000 radarr && \
    mkdir /config /downloads /movies /opt/radarr && \
    curl --location --output /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.${SOURCE_CHANNEL}.${VERSION}.linux-core-x64.tar.gz" && \
    tar xzf /tmp/radarr.tar.gz --directory=/opt/radarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /movies /opt/radarr && \
    rm /tmp/radarr.tar.gz

USER 1000
VOLUME /config /downloads /movies
WORKDIR /opt/radarr

EXPOSE 7878
ENTRYPOINT ["/opt/radarr/Radarr"]
CMD ["-data=/config", "-nobrowser"]
