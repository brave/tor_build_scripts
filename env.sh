#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.8.21"

export ZLIB_VERSION="1.3.1"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="3.6.1"

export ZLIB_HASH="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH="b1bfedcd5b289ff22aee87c9d600f515767ebf45f77168cb6d64f231f518a82e"
export TOR_HASH="eaf6f5b73091b95576945eade98816ddff7cd005befe4d94718a6f766b840903"

export DOCKER="$(command -v docker || command -v podman)"
