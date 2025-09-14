FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine3.22

ARG SOURCE_CHANNEL
ARG VERSION

# renovate: datasource=repology depName=alpine_3_22/curl versioning=loose
ENV CURL_VERSION=8.14.1-r1
# renovate: datasource=repology depName=alpine_3_22/sqlite-libs versioning=loose
ENV SQLITE_LIBS_VERSION=3.49.2-r1

RUN apk add --no-cache --update \
        curl="${CURL_VERSION}" \
        sqlite-libs="${SQLITE_LIBS_VERSION}" && \
    addgroup -g 1000 radarr && \
    adduser -D -G radarr -h /opt/radarr -H -s /bin/sh -u 1000 radarr && \
    mkdir /config /downloads /movies /opt/radarr && \
    curl --location --output /tmp/radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${VERSION}/Radarr.${SOURCE_CHANNEL}.${VERSION}.linux-musl-core-x64.tar.gz" && \
    tar xzf /tmp/radarr.tar.gz --directory=/opt/radarr --strip-components=1 && \
    chown --recursive 1000:1000 /config /downloads /movies /opt/radarr && \
    rm /tmp/radarr.tar.gz

USER 1000
VOLUME /config /downloads /movies
WORKDIR /opt/radarr

EXPOSE 7878
ENTRYPOINT ["/opt/radarr/Radarr"]
CMD ["-data=/config", "-nobrowser"]
