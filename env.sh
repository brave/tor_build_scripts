#!/bin/sh
# shellcheck disable=SC2155

export MACOSX_DEPLOYMENT_TARGET=10.15

# Reset version number to zero everytime TOR_VERSION changes.
export BRAVE_TOR_VERSION="0"

export TOR_VERSION="0.4.9.12"

export ZLIB_VERSION="1.3.2"
export LIBEVENT_VERSION="2.1.13-stable"
export OPENSSL_VERSION="4.0.2"

export ZLIB_HASH="bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
export LIBEVENT_HASH="f7e9383b8c0baa81b687e5b5eecc01beefaf1b19b64151d95ed61647fe7a315c"
export OPENSSL_HASH="736b467530f916737b7031310ccb21d8218c6229e61e8e160cd1d3458cd543a8"
export TOR_HASH="c0d307c9dcdaee4848a8ca53e9d6c4ec92823e4f30be12790b0fbddfc6515f5b"

export DOCKER="$(command -v docker || command -v podman)"
