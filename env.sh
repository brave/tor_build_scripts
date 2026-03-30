#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.9.6"

export ZLIB_VERSION="1.3.2"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="3.6.1"

export ZLIB_HASH="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH="b1bfedcd5b289ff22aee87c9d600f515767ebf45f77168cb6d64f231f518a82e"
export TOR_HASH="a89aba97052e9963a654b40df2d46be07e8a6b6e24e5437917fd81acd90a7017"

export DOCKER="$(command -v docker || command -v podman)"
