#!/bin/sh
set -e
sh build_darwin_arm64.sh
sh build_darwin_x86_64.sh

lipo -create -output "tor-$TOR_VERSION-darwin-brave-$BRAVE_TOR_VERSION" "arm64/tor-$TOR_VERSION/root/bin/tor" "x86_64/tor-$TOR_VERSION/root/bin/tor"
