#!/bin/sh
set -eu

rm -rf Tor/
rm -rf Data/

curl -fsSL "https://dist.torproject.org/torbrowser/7.5.4/tor-win32-0.3.2.10.zip" -o tor-win32-0.3.2.10.zip
curl -fsSL "https://dist.torproject.org/torbrowser/7.5.4/tor-win32-0.3.2.10.zip.asc" -o tor-win32-0.3.2.10.zip.asc

gpg --keyserver pgp.mit.edu/ --recv D1483FA6C3C07136
gpg tor-win32-0.3.2.10.zip.asc

unzip tor-win32-0.3.2.10.zip
cd Tor
zip -r tor-win32-$TOR_VERSION-brave-$BRAVE_TOR_VERSION.zip .
cd .. 
mv Tor/tor-win32-$TOR_VERSION-brave-$BRAVE_TOR_VERSION.zip .
