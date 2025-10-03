#!/bin/sh -eu

BUILD_CPU=arm64
BUILD_HOST=arm-apple-darwin

echo "running build_darwin_$BUILD_CPU.sh..."

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

rm -rf $BUILD_CPU && mkdir $BUILD_CPU

tar -xvzf "zlib-$ZLIB_VERSION.tar.gz" -C $BUILD_CPU
cd "$BUILD_CPU/zlib-$ZLIB_VERSION"
CFLAGS="-target $BUILD_CPU-apple-macos11" LDFLAGS="-target $BUILD_CPU-apple-macos11" ./configure --prefix="$PWD/root"
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../

tar -xvzf "openssl-$OPENSSL_VERSION.tar.gz" -C $BUILD_CPU
cd "$BUILD_CPU/openssl-$OPENSSL_VERSION"
./Configure --prefix="$PWD/root" \
  darwin64-$BUILD_CPU-cc \
  no-apps \
  no-cmp \
  no-cms \
  no-comp \
  no-ct \
  no-dgram \
  no-docs \
  no-dso \
  no-ec2m \
  no-engine \
  no-http \
  no-legacy \
  no-module \
  no-nextprotoneg \
  no-ocsp \
  no-padlockeng \
  no-psk \
  no-quic \
  no-rfc3779 \
  no-shared \
  no-srp \
  no-srtp \
  no-ssl-trace \
  no-static-engine \
  no-ts \
  no-ui-console \
  no-uplink
make ${jobs:+-j${jobs}} && make test && make install
cd ../../

#Apple messed up getentropy and clock_gettimesymbols when they added two functions in Sierra: 
#they forgot to decorate them with appropriate AVAILABLE_MAC_OS_VERSION checks. 
#So we have to explicitly disable them for binaries to work on MacOS 10.11.

tar -zxvf "libevent-$LIBEVENT_VERSION.tar.gz" -C $BUILD_CPU
cd "$BUILD_CPU/libevent-$LIBEVENT_VERSION"
patch -p0 < ../../patch/libevent/regress.c.patch
patch -p0 < ../../patch/libevent/regress_http.c.patch
./configure \
  LDFLAGS="-L$PWD/../openssl-$OPENSSL_VERSION/root/lib --target=$BUILD_CPU-apple-macos11" \
  CPPFLAGS="-I$PWD/../openssl-$OPENSSL_VERSION/include --target=$BUILD_CPU-apple-macos11" \
  --prefix="$PWD/install" \
  --disable-openssl \
  --disable-shared \
  --enable-static \
  --host=$BUILD_HOST \
  --disable-clock-gettime \
  --with-pic
make ${jobs:+-j${jobs}} && make ${jobs:+-j${jobs}} check && make install
cd ../../

tar -xvzf "tor-$TOR_VERSION.tar.gz" -C $BUILD_CPU
cd "$BUILD_CPU/tor-$TOR_VERSION"
patch -p0 < ../../patch/tor/test_slow.c.patch
./configure \
  LDFLAGS="--target=$BUILD_CPU-apple-macos11 -L$XCODE_LIB" \
  CPPFLAGS="--target=$BUILD_CPU-apple-macos11 -I$XCODE_INCLUDE" \
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
  --host=$BUILD_HOST \
  --disable-tool-name-check \
  ac_cv_func_getentropy=no \
  ac_cv_func_clock_gettime=no
make ${jobs:+-j${jobs}} && make install
cd ../../
