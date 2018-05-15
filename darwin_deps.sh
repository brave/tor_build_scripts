#!/bin/sh
set -eu

curl -o gnupg-2.2.7.tar.bz2 https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.7.tar.bz2
curl -o gnupg-2.2.7.tar.bz2.sig https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.7.tar.bz2.sig
echo "e222cda63409a86992369df8976f6c7511e10ea0  gnupg-2.2.7.tar.bz2" | shasum -a 256 -c -
tar -xvjf gnupg-2.2.7.tar.bz2
cd gnupg-2.2.7/
./configure
make && make check && sudo make install
