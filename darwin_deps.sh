#!/bin/sh -eu

GPG_VERSION=2.4.3
GPG_HASH=a271ae6d732f6f4d80c258ad9ee88dd9c94c8fdc33c3e45328c4d7c126bd219d

curl --proto '=https' --tlsv1.2 -fsSL -o "gnupg-$GPG_VERSION.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2"
echo "$GPG_HASH  gnupg-$GPG_VERSION.tar.bz2" | shasum -a 256 -c -
tar -xjf "gnupg-$GPG_VERSION.tar.bz2"
cd "gnupg-$GPG_VERSION/"
./configure
make && make check && sudo make install
