#!/bin/sh
set -eu

GPG_VERSION=2.3.4
GPG_HASH=f3468ecafb1d7f9ad7b51fd1db7aebf17ceb89d2efa8a05cf2f39b4d405402ae

curl --proto '=https' --tlsv1.2 -fsSL -o "gnupg-$GPG_VERSION.tar.bz2" "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GPG_VERSION.tar.bz2"
echo "$GPG_HASH  gnupg-$GPG_VERSION.tar.bz2" | shasum -a 256 -c -
tar -xjf "gnupg-$GPG_VERSION.tar.bz2"
cd "gnupg-$GPG_VERSION/"
./configure
make && make check && sudo make install
