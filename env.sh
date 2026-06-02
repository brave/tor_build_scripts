#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.9.9"

export ZLIB_VERSION="1.3.2"
export LIBEVENT_VERSION="2.1.12-stable"
export OPENSSL_VERSION="4.0.0"

export ZLIB_HASH="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
export LIBEVENT_HASH=92e6de1be9ec176428fd2367677e61ceffc2ee1cb119035037a27d346b0403bb
export OPENSSL_HASH="c32cf49a959c4f345f9606982dd36e7d28f7c58b19c2e25d75624d2b3d2f79ac"
export TOR_HASH="bd75ba7fd68f607c7806fcf70156a300aa926e9ad69a5e56a8e6414f5227e833"

export DOCKER="$(command -v docker || command -v podman)"
