#!/bin/bash
set -e
location=$(pwd)
install_dir=$(realpath $1)
wget http://www.netlib.org/blas/blas-3.12.0.tgz
tar -xvf blas-3.12.0.tgz  # unzip the blas source files
cd BLAS-3.12.0/ 
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${install_dir}
make install
cd ${location}
wget https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz
tar xvf v3.12.0.tar.gz
cd lapack-3.12.0
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${install_dir} -DBUILD_SHARED_LIBS=OFF -DCBLAS=ON
make install
