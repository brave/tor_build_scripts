#!/bin/sh
set -eu

docker rm -fv tor-brave || true
docker build -t tor-brave -f Dockerfile-linux --build-arg tor_version=$TOR_VERSION --build-arg zlib_version=$ZLIB_VERSION --build-arg libevent_version=$LIBEVENT_VERSION --build-arg openssl_version=$OPENSSL_VERSION .
docker run --name tor-brave -d tor-brave
docker cp tor-brave:/tor-$TOR_VERSION/src/or/tor tor-linux-$TOR_VERSION-brave-$BRAVE_TOR_VERSION
