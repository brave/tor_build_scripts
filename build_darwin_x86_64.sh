#!/bin/sh -eu

echo "running build_darwin_x86_64.sh..."

SDK_PATH=$(xcrun --show-sdk-path)
XCODE_LIB="$SDK_PATH/usr/lib/"
XCODE_INCLUDE="$SDK_PATH/usr/include/"

if [ $# -eq 1 ]; then
  re='^[0-9]+$'
  if ! echo "$1" | grep -Eq "$re" ; then
    echo "Invalid number of cores" >&2; exit 1
  fi
  jobs=$1
else
  jobs=$(sysctl -n hw.logicalcpu_max)
fi

rm -rf x86_64 && mkdir x86_64

tar -xvzf "zlib-$ZLIB_VERSION.tar.gz" -C x86_64
cd "x86_64/zlib-$ZLIB_VERSION"
./configure --prefix="$PWD/root"
make ${jobs:+-j${jobs}} && make ${jobs:+-j$jobs} check && make install
cd ../../

tar -xvzf "openssl-$OPENSSL_VERSION.tar.gz" -C x86_64
cd "x86_64/openssl-$OPENSSL_VERSION"
./Configure --prefix="$PWD/root" darwin64-x86_64-cc no-shared no-dso
make ${jobs:+-j${jobs}} && make test && make install
cd ../../

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

tar -zxvf "libevent-$LIBEVENT_VERSION.tar.gz" -C x86_64
cd "x86_64/libevent-$LIBEVENT_VERSION"
patch -p0 < ../../patch/libevent/regress.c.patch
./configure \
            LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION/root/lib" \
            CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include" \
            --prefix="$PWD/install" \
            --disable-openssl \
            --disable-shared \
            --enable-static \
            --disable-clock-gettime \
            --with-pic
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../

tar -xvzf "tor-$TOR_VERSION.tar.gz" -C x86_64
cd "x86_64/tor-$TOR_VERSION"
./configure \
            LDFLAGS="-L$XCODE_LIB" \
            CPPFLAGS="-I$XCODE_INCLUDE" \
            --prefix="$PWD/root" \
            --enable-static-libevent \
            --enable-static-openssl  \
            --enable-static-zlib  \
            --with-libevent-dir="$PWD/../libevent-$LIBEVENT_VERSION/install" \
            --with-openssl-dir="$PWD/../openssl-$OPENSSL_VERSION/root" \
            --with-zlib-dir="$PWD/../zlib-$ZLIB_VERSION/root" \
            --disable-asciidoc \
            --disable-html-manual \
            --disable-lzma \
            --disable-manpage \
            --disable-zstd \
            --disable-module-relay \
            --disable-module-dirauth \
            ac_cv_func_getentropy=no \
            ac_cv_func_clock_gettime=no
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../
