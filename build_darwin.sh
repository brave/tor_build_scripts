#!/bin/sh
set -eu

curl -fsSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o openssl-$OPENSSL_VERSION.tar.gz && \
echo "$OPENSSL_HASH  openssl-$OPENSSL_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz && \
cd openssl-$OPENSSL_VERSION && \
./config --prefix=$PWD/install no-shared no-dso && \
make

cd ..

curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz" -o libevent-$LIBEVENT_VERSION.tar.gz && \
curl -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz.asc" -o libevent-$LIBEVENT_VERSION.tar.gz.asc && \

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

gpg --keyserver "$KEYSERVER" --recv-keys $LIBEVENT_KEY && \
gpg libevent-$LIBEVENT_VERSION.tar.gz.asc && \
echo "$LIBEVENT_HASH  libevent-$LIBEVENT_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -zxvf libevent-$LIBEVENT_VERSION.tar.gz && \
cd libevent-$LIBEVENT_VERSION && \
./configure \
            LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION" \
            CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include" \
            --prefix=$PWD/install \
            --disable-shared \
            --enable-static \
            --disable-clock-gettime \
            --with-pic && \
make && make check && make install

cd ..

curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz" -o tor-$TOR_VERSION.tar.gz
curl -fsSL "https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz.asc" -o tor-$TOR_VERSION.tar.gz.asc

gpg --keyserver "$KEYSERVER" --recv-keys $TOR_KEY
gpg tor-$TOR_VERSION.tar.gz.asc
echo "$TOR_HASH  tor-$TOR_VERSION.tar.gz" | shasum -a 256 -c - && \
tar -xvzf tor-$TOR_VERSION.tar.gz
cd tor-$TOR_VERSION && \
./configure --prefix=$PWD/install \
            --enable-static-libevent \
            --enable-static-openssl  \
            --with-libevent-dir=$PWD/../libevent-$LIBEVENT_VERSION/install \
            --with-openssl-dir=$PWD/../openssl-$OPENSSL_VERSION/install \
            --disable-asciidoc \
            ac_cv_func_getentropy=no \
            ac_cv_func_clock_gettime=no && \
make && make check && make install
cd ..

cp tor-$TOR_VERSION/install/bin/tor tor-$TOR_VERSION-darwin-brave-$BRAVE_TOR_VERSION
