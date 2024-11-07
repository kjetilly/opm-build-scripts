#!/bin/bash
set -e
install_dir=$(realpath $1)
wget https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.8.3.tar.gz
tar xvf v7.8.3.tar.gz
cd SuiteSparse-7.8.3
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$install_dir -DCMAKE_PREFIX_PATH=$install_dir
make -j4 install
