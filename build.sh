#!/bin/bash

sudo umount /mnt

version=0.5
img_name=rhel_builder

path=$1

if [ -z "$path" ]; then
    echo "Need full path to rhel iso"
    exit 1
fi

if [ -f "$path" ]; then

    sudo mount $path /mnt
else
    echo "full path does not exist"
    exit 1
fi

docker build --pull -t ${img_name}:$version -t ${img_name}:latest .
docker run --rm -v /mnt:/mnt -v `pwd`/output:/output ${img_name}

sudo chown -R $LOGNAME:$LOGNAME output

