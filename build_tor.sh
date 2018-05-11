#!/bin/sh
set -eu
docker build -t tor-brave -f Dockerfile-linux .
docker run -d tor-brave --name tor-brave
docker cp tor-brave:/tor-0.3.2.10/src/or/tor tor-linux
