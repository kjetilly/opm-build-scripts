#!/bin/bash
set -e
install_dir=$(realpath $1)
wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
tar xvf gmp-6.3.0.tar.xz
cd gmp-6.3.0
./configure --prefix=${install_dir}
make install
