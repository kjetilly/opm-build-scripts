#!/bin/bash

set -e 
mkdir -p build
cd build
cmake .. \
    -DCMAKE_PREFIX_PATH="$(realpath ../../dune);$(realpath ../../zoltan)" \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_C_COMPILER=$CC \
    -GNinja \
    -DCMAKE_CXX_COMPILER_LAUNCHER=$(which ccache) \
    -DCMAKE_CUDA_COMPILER_LAUNCHER=$(which ccache) \
    -DCMAKE_C_COMPILER_LAUNCHER=$(which ccache) 
    
ninja -j4
    
