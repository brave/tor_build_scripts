#!/bin/sh
set -eu

curl -fsSL "https://www.torproject.org/dist/tor-0.3.2.10.tar.gz" -o tor-0.3.2.10.tar.gz
curl -fsSL "https://www.torproject.org/dist/tor-0.3.2.10.tar.gz.asc" -o tor-0.3.2.10.tar.gz.asc

gpg --keyserver pgp.mit.edu/ --recv FE43009C4607B1FB
gpg tor-0.3.2.10.tar.gz.asc

tar -xvzf tor-0.3.2.10.tar.gz
cd tor-0.3.2.10
./configure && make && make install
cd ..

cp tor-0.3.2.10/src/or/tor tor-darwin-$TOR_VERSION-brave-$BRAVE_TOR_VERSION
