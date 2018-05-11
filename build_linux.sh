#!/bin/sh
set -eu

BRAVE_TOR_VERSION="1"
TOR_VERSION="0.3.2.10"

docker rm -fv tor-brave || true
docker build -t tor-brave -f Dockerfile-linux .
docker run --name tor-brave -d tor-brave
docker cp tor-brave:/tor-0.3.2.10/src/or/tor tor-linux-$TOR_VERSION-brave-$BRAVE_TOR_VERSION
