#!/bin/bash
echo "Hello from build_devtainer.sh"

mkdir -p build_docker_hip && cd build_docker_hip
cmake \
        -DUSE_OPENCL=OFF \
        -DUSE_BDA_BRIDGE=OFF \
        -DUSE_GPU_BRIDGE=OFF \
        -DCONVERT_CUDA_TO_HIP=ON \
        -DCMAKE_HIP_PLATFORM=amd \
	-DCMAKE_BUILD_TYPE=Debug \
        -DUSE_HIP=1 \
        -DCMAKE_PREFIX_PATH="/opt/rocm/" \
        -DCMAKE_HIP_ARCHITECTURES="gfx1100,gfx942,gfx90a,gfx908,gfx906,gfx1101" \
        ..
make -j10 test_gpuflowproblem #NOTE: Adjust number of procs as needed. OPM uses a lot of memory compiling per proc (O(2GB))
