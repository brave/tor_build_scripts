#!/bin/sh
set -eu

rm -rf Tor/
rm -rf Data/

curl -fsSL "https://dist.torproject.org/torbrowser/7.5.4/tor-win32-$TOR_VERSION.zip" -o tor-win32-$TOR_VERSION.zip
curl -fsSL "https://dist.torproject.org/torbrowser/7.5.4/tor-win32-$TOR_VERSION.zip.asc" -o tor-win32-$TOR_VERSION.zip.asc

gpg --keyserver pool.sks-keyservers.net/ --recv-keys $TOR_KEY
gpg tor-win32-$TOR_VERSION.zip.asc

unzip tor-win32-$TOR_VERION.zip
cd Tor
zip -r tor-$TOR_VERSION-win32-brave-$BRAVE_TOR_VERSION.zip .
cd .. 
mv Tor/tor-$TOR_VERSION-win32-brave-$BRAVE_TOR_VERSION.zip .
