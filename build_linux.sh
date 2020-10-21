#!/bin/sh
set -eu

docker rm -fv tor-brave 2>/dev/null || true
docker build -t tor-brave -f Dockerfile-linux \
    --build-arg tor_version=$TOR_VERSION \
    --build-arg zlib_version=$ZLIB_VERSION \
    --build-arg libevent_version=$LIBEVENT_VERSION \
    --build-arg openssl_version=$OPENSSL_VERSION \
    --build-arg zlib_hash=$ZLIB_HASH \
    --build-arg libevent_hash=$LIBEVENT_HASH \
    --build-arg openssl_hash=$OPENSSL_HASH \
    --build-arg tor_hash=$TOR_HASH \
    ${1+"$@"} .
docker run --name tor-brave -d tor-brave
docker cp tor-brave:/tor-$TOR_VERSION/install/bin/tor tor-$TOR_VERSION-linux-brave-$BRAVE_TOR_VERSION

if ! ldd tor-$TOR_VERSION-linux-brave-$BRAVE_TOR_VERSION 2>&1 \
       | egrep -q 'not a dynamic executable'; then
  printf >&2 'failed to make a statically linked tor executable'
  exit 1
fi
