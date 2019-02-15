#!/bin/sh
set -eu
if [ $# -eq 1 ]; then
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "Invalid number of cores" >&2; exit 1
  fi
  jobs=$1
else
  jobs=$(sysctl -n hw.logicalcpu_max)
fi

curl -fsSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl-$OPENSSL_VERSION.tar.gz && \
echo "$OPENSSL_HASH  openssl-$OPENSSL_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz && \
cd openssl-$OPENSSL_VERSION && \
./Configure --prefix=$PWD/root darwin64-x86_64-cc no-shared no-dso && \
make ${jobs:+-j${jobs}}

cd ..

curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz" -o libevent-$LIBEVENT_VERSION.tar.gz && \
curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz.asc" -o libevent-$LIBEVENT_VERSION.tar.gz.asc && \

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

# Using test/regress.c from a local repo because make check hangs in libevent
# See: https://github.com/libevent/libevent/issues/747 for more details
# Updated test/regress.cc disables: del_wait | immediatesignal | 
# signal_switchbase | signal_while_processing tests

gpg --import gpg-keys/libevent.gpg && \
gpg libevent-$LIBEVENT_VERSION.tar.gz.asc && \
echo "$LIBEVENT_HASH  libevent-$LIBEVENT_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -zxvf libevent-$LIBEVENT_VERSION.tar.gz && \
cp patch/libevent/test/regress.c libevent-$LIBEVENT_VERSION/test/regress.c && \
cd libevent-$LIBEVENT_VERSION && \
./configure \
            LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION/root" \
            CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include" \
            --prefix=$PWD/install \
            --disable-shared \
            --enable-static \
            --disable-clock-gettime \
            --with-pic && \
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make ${jobs:+-j${jobs}} install

cd ..

curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz" -o tor-$TOR_VERSION.tar.gz
curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz.asc" -o tor-$TOR_VERSION.tar.gz.asc

gpg --import gpg-keys/tor.gpg
gpg tor-$TOR_VERSION.tar.gz.asc
echo "$TOR_HASH  tor-$TOR_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf tor-$TOR_VERSION.tar.gz
cd tor-$TOR_VERSION && \
./configure --prefix=$PWD/root \
            --enable-static-libevent \
            --enable-static-openssl  \
            --with-libevent-dir=$PWD/../libevent-$LIBEVENT_VERSION/install \
            --with-openssl-dir=$PWD/../openssl-$OPENSSL_VERSION/root \
            --disable-asciidoc \
            ac_cv_func_getentropy=no \
            ac_cv_func_clock_gettime=no && \
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ..

cp tor-$TOR_VERSION/root/bin/tor tor-$TOR_VERSION-darwin-brave-$BRAVE_TOR_VERSION
