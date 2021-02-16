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

rm -rf x86_64 && mkdir x86_64

curl -fsSL "https://zlib.net/zlib-$ZLIB_VERSION.tar.gz" -o zlib-$ZLIB_VERSION.tar.gz
shasum -a 256 zlib-$ZLIB_VERSION.tar.gz && \
echo "$ZLIB_HASH  zlib-$ZLIB_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf zlib-$ZLIB_VERSION.tar.gz -C x86_64 && \
cd x86_64/zlib-$ZLIB_VERSION && \
./configure --prefix=$PWD/root && \
make ${jobs:+-j${jobs}} && make ${jobs:+-j$jobs} check && make install && \
cd ../../

curl -fsSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl-$OPENSSL_VERSION.tar.gz && \
echo "$OPENSSL_HASH  openssl-$OPENSSL_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz -C x86_64 && \
cd x86_64/openssl-$OPENSSL_VERSION && \
./Configure --prefix=$PWD/root darwin64-x86_64-cc no-shared no-dso && \
make ${jobs:+-j${jobs}} && make test && make install && \
cd ../../

curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz" -o libevent-$LIBEVENT_VERSION.tar.gz && \
curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz.asc" -o libevent-$LIBEVENT_VERSION.tar.gz.asc && \

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

# Updated test/regress_bufferevent.c disables: test_bufferevent_pair_release_lock

gpg --import gpg-keys/libevent.gpg && \
gpg libevent-$LIBEVENT_VERSION.tar.gz.asc && \
echo "$LIBEVENT_HASH  libevent-$LIBEVENT_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -zxvf libevent-$LIBEVENT_VERSION.tar.gz -C x86_64 && \
cp patch/libevent/test/regress_bufferevent.c x86_64/libevent-$LIBEVENT_VERSION/test/regress_bufferevent.c && \
cd x86_64/libevent-$LIBEVENT_VERSION && \
./configure \
            LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION/root" \
            CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include" \
            --prefix=$PWD/install \
            --disable-shared \
            --enable-static \
            --disable-clock-gettime \
            --with-pic && \
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install && \
cd ../../

curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz" -o tor-$TOR_VERSION.tar.gz
curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz.asc" -o tor-$TOR_VERSION.tar.gz.asc

gpg --import gpg-keys/tor.gpg && \
gpg tor-$TOR_VERSION.tar.gz.asc && \
echo "$TOR_HASH  tor-$TOR_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf tor-$TOR_VERSION.tar.gz -C x86_64 && \
cd x86_64/tor-$TOR_VERSION && \
./configure --prefix=$PWD/root \
            --enable-static-libevent \
            --enable-static-openssl  \
            --enable-static-zlib  \
            --with-libevent-dir=$PWD/../libevent-$LIBEVENT_VERSION/install \
            --with-openssl-dir=$PWD/../openssl-$OPENSSL_VERSION/root \
            --with-zlib-dir=$PWD/../zlib-$ZLIB_VERSION/root \
            --disable-asciidoc \
            --disable-lzma \
            ac_cv_func_getentropy=no \
            ac_cv_func_clock_gettime=no && \
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../
