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
./configure --enable-static-libevent \
            --enable-static-openssl  \
            --with-libevent-dir=$PWD/../libevent-$LIBEVENT_VERSION/install \
            --with-openssl-dir=$PWD/../openssl-$OPENSSL_VERSION/install \
            --disable-asciidoc && \
make && make check
cd ..

cp tor-$TOR_VERSION/src/or/tor tor-darwin-$TOR_VERSION-brave-$BRAVE_TOR_VERSION
