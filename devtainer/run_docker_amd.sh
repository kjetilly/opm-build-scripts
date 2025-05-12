#!/bin/bash

cmd=$1
docker run -it --init --rm -w $(pwd) -v $(pwd):$(pwd) -u $(id -u):$(id -g) \
    -v /etc/group:/etc/group:ro \
     --device /dev/dri \
    --device /dev/kfd \
    --group-add video \
    --group-add $(getent group render | cut -d: -f3) \
    --security-opt seccomp=unconfined \
    --entrypoint ${cmd} \
    openporousmedia/opmreleases:2024.10_amd \
    "${@:2}"