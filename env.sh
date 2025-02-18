#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.8.14"

export ZLIB_VERSION="1.3.1"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="3.4.1"

export ZLIB_HASH="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH="002a2d6b30b58bf4bea46c43bdd96365aaf8daa6c428782aa4feee06da197df3"
export TOR_HASH="5047e1ded12d9aac4eb858f7634a627714dd58ce99053d517691a4b304a66d10"

export DOCKER="$(command -v docker || command -v podman)"
