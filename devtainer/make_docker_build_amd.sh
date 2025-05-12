#!/bin/bash


docker run --rm -it --init --entrypoint make \
       -v $(pwd):$(pwd) -u $(id -u):$(id -g) -w $(pwd)/build_docker_hip \
       -v /home/kjetil/projects/opm-tobias/sources/dune/include/dune:/usr/include/dune \
       kjetilly/opmreleases:2024.10_amd \
       -j16 $1
