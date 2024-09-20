#!/bin/bash

for build_type in "Release" "Debug";
do
    set -e
    build_type_lower=$(echo $build_type|awk '{print tolower($0)}')
    build_folder="build_${build_type_lower}"
    mkdir -p ${build_folder}
    cd ${build_folder}
    cmake .. \
	  -DCMAKE_PREFIX_PATH="$(realpath ../../dune);$(realpath ../../zoltan);$(realpath ../../fmt)" \
	  -DCMAKE_CXX_COMPILER=$CXX \
	  -DCMAKE_C_COMPILER=$CC \
      -Dfmt_DIR=$(realpath ../../fmt/lib/cmake/fmt) \
	  -GNinja \
	  -DCMAKE_BUILD_TYPE=${build_type} \
	  -DCMAKE_CXX_COMPILER_LAUNCHER=$(which ccache) \
	  -DCMAKE_CUDA_COMPILER_LAUNCHER=$(which ccache) \
	  -DCMAKE_C_COMPILER_LAUNCHER=$(which ccache) 
    
    ninja -j4
    cd ..
done
