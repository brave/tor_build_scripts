#!/bin/sh -eu

GPG_VERSION=2.4.7
GPG_HASH=7b24706e4da7e0e3b06ca068231027401f238102c41c909631349dcc3b85eb46

curl --proto '=https' --tlsv1.2 -fsSL -o "gnupg-$GPG_VERSION.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2"
echo "$GPG_HASH  gnupg-$GPG_VERSION.tar.bz2" | shasum -a 256 -c -
tar -xjf "gnupg-$GPG_VERSION.tar.bz2"
cd "gnupg-$GPG_VERSION/"
./configure
make && make check && sudo make install
