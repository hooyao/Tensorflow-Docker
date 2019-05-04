#!/bin/sh

export CUR_DIR=$(pwd)
docker-compose -f compose--jupyter.yml down