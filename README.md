# Radarr

Simple docker image for Radarr without any bloat, built on the official mono image. Radarr runs as user `radarr` with `uid` and `gid` 1000.

## Usage

```sh
docker run --rm ghudiczius/radarr:<VERSION> \
  -p 7878:7878 \
  -v path/to/config:/config \
  -v path/to/downloads:/downloads \
  -v path/to/movies:/movies
```
