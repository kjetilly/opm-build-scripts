#!/bin/bash

set -e 
mkdir -p build
cd build
cmake .. \
    -DCMAKE_PREFIX_PATH="$(realpath ../../dune);$(realpath ../../zoltan)" \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_C_COMPILER=$CC
make -j4
    
