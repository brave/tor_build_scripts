#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.9.16"

export ZLIB_VERSION="1.4"
export LIBEVENT_VERSION="2.1.13-stable"
export OPENSSL_VERSION="4.0.3"

export ZLIB_HASH="02dd159783677a749c04adbdd02b55b8a2bcc7e054f51b76b549199a916ad584"
export LIBEVENT_HASH="f7e9383b8c0baa81b687e5b5eecc01beefaf1b19b64151d95ed61647fe7a315c"
export OPENSSL_HASH="325b5c806167c13b40b1ffeadfe0248197c00eccc4cf123ec1e28d2d2fd216d9"
export TOR_HASH="6180e193152f4525bdca5475168419b2a2035b963c3c60162a187f86e6160e48"

export DOCKER="$(command -v docker || command -v podman)"
