#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.8.13"

export ZLIB_VERSION="1.3.1"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="3.4.0"

export ZLIB_HASH="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH="e15dda82fe2fe8139dc2ac21a36d4ca01d5313c75f99f46c4e8a27709b7294bf"
export TOR_HASH="9baf26c387a2820b3942da572146e6eb77c2bc66862af6297cd02a074e6fba28"

export DOCKER="$(command -v docker || command -v podman)"
