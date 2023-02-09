#!/bin/sh -eu

IMAGE_NAME="tor-brave-arm64"
DOCKERFILE="Dockerfile-linux-arm64"

cleanup () {
  echo "cleaning up docker containers/images"
  docker rm -f "$IMAGE_NAME" || true
  docker rmi -f "$IMAGE_NAME" || true
}

cleanup
docker build --no-cache -t "$IMAGE_NAME" -f "$DOCKERFILE" \
    --build-arg "tor_version=$TOR_VERSION" \
    --build-arg "zlib_version=$ZLIB_VERSION" \
    --build-arg "libevent_version=$LIBEVENT_VERSION" \
    --build-arg "openssl_version=$OPENSSL_VERSION" \
    --build-arg "zlib_hash=$ZLIB_HASH" \
    --build-arg "libevent_hash=$LIBEVENT_HASH" \
    --build-arg "openssl_hash=$OPENSSL_HASH" \
    --build-arg "tor_hash=$TOR_HASH" \
    ${1+"$@"} .
docker run --init --rm --name "$IMAGE_NAME" -d "$IMAGE_NAME"
docker cp "$IMAGE_NAME:/tor-$TOR_VERSION/install/bin/tor" "tor-$TOR_VERSION-linux-arm64-brave-$BRAVE_TOR_VERSION"

if ! ldd "tor-$TOR_VERSION-linux-arm64-brave-$BRAVE_TOR_VERSION" 2>&1 \
       | grep -F -q 'not a dynamic executable'; then
  printf >&2 'failed to make a statically linked tor executable'
  exit 1
fi
