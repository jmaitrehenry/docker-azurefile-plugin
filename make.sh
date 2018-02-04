#!/bin/bash
if [ -z $VERSION ]; then
  VERSION=dev
fi

sudo rm -rf .docker/plugin/rootfs
mkdir .docker/plugin/rootfs

GOOS=linux GOARCH=amd64 go build -o .docker/plugin/azurefile-driver

docker build -t rootfsimage .docker/plugin
id=`docker create rootfsimage true`

docker export $id | sudo tar -x -C .docker/plugin/rootfs

docker plugin rm jmaitrehenry/azurefile:$VERSION || true
sudo docker plugin create jmaitrehenry/azurefile:$VERSION .docker/plugin
docker plugin push jmaitrehenry/azurefile:$VERSION
