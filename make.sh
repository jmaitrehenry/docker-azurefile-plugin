#!/bin/bash
version=latest
if [ ! -z $1 ]; then
  version=$1
fi

sudo rm -rf .docker/plugin/rootfs
mkdir .docker/plugin/rootfs

GOOS=linux GOARCH=amd64 go build -o .docker/plugin/azurefile-driver

docker build -t rootfsimage .docker/plugin
id=`docker create rootfsimage true`

docker export $id | sudo tar -x -C .docker/plugin/rootfs

docker plugin rm jmaitrehenry/azurefile:$version
sudo docker plugin create jmaitrehenry/azurefile:$version .docker/plugin
docker plugin push jmaitrehenry/azurefile:$version
