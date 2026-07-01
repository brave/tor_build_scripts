#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="1"

export TOR_VERSION="0.4.9.11"

export ZLIB_VERSION="1.3.2"
export LIBEVENT_VERSION="2.1.13-stable"
export OPENSSL_VERSION="4.0.1"

export ZLIB_HASH="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
export LIBEVENT_HASH="sha256:f7e9383b8c0baa81b687e5b5eecc01beefaf1b19b64151d95ed61647fe7a315c"
export OPENSSL_HASH="2db3f3a0d6ea4b59e1f094ace2c8cd536dffb87cdc39084c5afa1e6f7f37dd09"
export TOR_HASH="2e6c1720118c812acf0079fd47cf91b6bfaba5d766c321c4d3d2a28d6a11a8ed"

export DOCKER="$(command -v docker || command -v podman)"
