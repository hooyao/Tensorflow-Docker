#!/bin/sh

[ -z "$IMG_TAG" ] && echo "Need to set IMG_TAG" && exit 1;
export CUR_DIR=$(pwd)
docker-compose -f compose--jupyter.yml up -d
sleep 5s
google-chrome 127.0.0.1:8888
