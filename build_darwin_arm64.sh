#!/bin/sh -eu

echo "running build_darwin_arm64.sh..."

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

rm -rf arm64 && mkdir arm64

tar -xvzf "zlib-$ZLIB_VERSION.tar.gz" -C arm64
cd "arm64/zlib-$ZLIB_VERSION"
CFLAGS="-target arm64-apple-macos11" LDFLAGS="-target arm64-apple-macos11" ./configure --prefix="$PWD/root"
make ${jobs:+-j${jobs}} && make install
cd ../../

tar -xvzf "openssl-$OPENSSL_VERSION.tar.gz" -C arm64
cd "arm64/openssl-$OPENSSL_VERSION"
./Configure --prefix="$PWD/root" darwin64-arm64-cc no-shared no-dso
make ${jobs:+-j${jobs}} && make install
cd ../../

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

tar -zxvf "libevent-$LIBEVENT_VERSION.tar.gz" -C arm64
cd "arm64/libevent-$LIBEVENT_VERSION"
patch -p0 < ../../patch/libevent/regress.c.patch
./configure \
	    LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION/root/lib --target=arm64-apple-macos11" \
	    CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include --target=arm64-apple-macos11" \
	    --prefix="$PWD/install" \
	    --disable-openssl \
	    --disable-shared \
	    --enable-static \
            --host=arm-apple-darwin \
	    --disable-clock-gettime \
	    --with-pic
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../

tar -xvzf "tor-$TOR_VERSION.tar.gz" -C arm64
cd "arm64/tor-$TOR_VERSION"
./configure \
	    LDFLAGS="--target=arm64-apple-macos11 -L$XCODE_LIB" \
	    CPPFLAGS="--target=arm64-apple-macos11 -I$XCODE_INCLUDE" \
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
            --host=arm-apple-darwin \
            --disable-tool-name-check \
	    ac_cv_func_getentropy=no \
	    ac_cv_func_clock_gettime=no
make ${jobs:+-j${jobs}} && make install
cd ../../
