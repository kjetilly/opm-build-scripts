#!/bin/bash
set -e
install_dir=$(realpath $1)
wget https://www.mpfr.org/mpfr-current/mpfr-4.2.2.tar.xz
tar xvf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2
./configure --prefix=${install_dir} --with-gmp=${install_dir}
make install
