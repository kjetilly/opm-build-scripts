#!/bin/bash

docker run --rm -it --init --entrypoint bash \
       -v $(pwd):$(pwd) -u $(id -u):$(id -g) -w $(pwd) \
       -v /home/kjetil/projects/opm-tobias/sources/dune/include/dune:/usr/include/dune \
       kjetilly/opmreleases:2024.10_nvidia \
       build_devtainer_nvidia.sh
