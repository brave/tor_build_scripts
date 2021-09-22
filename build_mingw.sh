#!/bin/sh
set -eu

cleanup () {
  echo "cleaning up docker containers/images"
  docker rm -f tor-brave-mingw || true
  docker rmi tor-brave-mingw || true
}

cleanup
docker build --no-cache -t tor-brave-mingw -f Dockerfile-mingw \
    --build-arg "tor_version=$TOR_VERSION" \
    --build-arg "zlib_version=$ZLIB_VERSION" \
    --build-arg "libevent_version=$LIBEVENT_VERSION" \
    --build-arg "openssl_version=$OPENSSL_VERSION" \
    --build-arg "zlib_hash=$ZLIB_HASH" \
    --build-arg "libevent_hash=$LIBEVENT_HASH" \
    --build-arg "openssl_hash=$OPENSSL_HASH" \
    --build-arg "tor_hash=$TOR_HASH" \
    ${1+"$@"} .
docker run --rm --name tor-brave-mingw -d tor-brave-mingw
docker cp "tor-brave-mingw:/tor-$TOR_VERSION/install/bin/tor.exe" "tor-$TOR_VERSION-win32-brave-$BRAVE_TOR_VERSION.exe"

trap cleanup EXIT
