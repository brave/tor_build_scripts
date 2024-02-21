#!/bin/sh

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.8.10"

export ZLIB_VERSION="1.3.1"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="1.1.1w"

export ZLIB_HASH="9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH=cf3098950cb4d853ad95c0841f1f9c6d3dc102dccfcacd521d93925208b76ac8
export TOR_HASH="e628b4fab70edb4727715b23cf2931375a9f7685ac08f2c59ea498a178463a86"

export DOCKER="$(command -v docker || command -v podman)"