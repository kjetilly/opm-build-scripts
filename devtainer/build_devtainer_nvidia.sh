#!/bin/bash
echo "Hello from build_devtainer.sh"

mkdir -p build_docker_nvidia && cd build_docker_nvidia
cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DUSE_OPENCL=OFF \
    -DUSE_GPU_BRIDGE=OFF \
    ..
make -j16 test_gpuflowproblem #NOTE: Adjust number of procs as needed. OPM uses a lot of memory compiling per proc (O(2GB))
