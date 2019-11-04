#!/bin/bash
set -e

git submodule update
cp -f defconfigs/sakaki/config defconfigs/sakaki_defconfig

export DEFCONFIG=sakaki_defconfig
docker-compose -p rpikernelbuild build
docker-compose -p rpikernelbuild run builder
docker-compose -p rpikernelbuild down
