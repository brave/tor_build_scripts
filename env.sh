#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.9.13"

export ZLIB_VERSION="1.3.2"
export LIBEVENT_VERSION="2.1.13-stable"
export OPENSSL_VERSION="4.0.3"

export ZLIB_HASH="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
export LIBEVENT_HASH="f7e9383b8c0baa81b687e5b5eecc01beefaf1b19b64151d95ed61647fe7a315c"
export OPENSSL_HASH="325b5c806167c13b40b1ffeadfe0248197c00eccc4cf123ec1e28d2d2fd216d9"
export TOR_HASH="5e748d3272cdf44a7d7741173f371c8def3d96eecb77e93c89c50663ce9cc792"

export DOCKER="$(command -v docker || command -v podman)"
