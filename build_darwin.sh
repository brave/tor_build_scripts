#!/bin/sh
set -eu

BRAVE_TOR_VERSION="1"
TOR_VERSION="0.3.2.10"

curl -fsSL "https://www.torproject.org/dist/tor-0.3.2.10.tar.gz" -o tor-0.3.2.10.tar.gz
curl -fsSL "https://www.torproject.org/dist/tor-0.3.2.10.tar.gz.asc" -o tor-0.3.2.10.tar.gz.asc

gpg --keyserver pgp.mit.edu/ --recv 9E92B601
gpg tor-0.3.2.10.tar.gz.asc

tar -xvzf tor-0.3.2.10.tar.gz
cd tor-0.3.2.10
./configure && make && make install

cp tor-0.3.2.10/src/or/tor tor-darwin-$TOR_VERSION-brave-$BRAVE_TOR_VERSION
