#!/bin/bash
set -e
mkdir -p fmt
wget https://github.com/fmtlib/fmt/releases/download/10.2.1/fmt-10.2.1.zip
unzip fmt-10.2.1.zip
cd fmt-10.2.1
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$(realpath ../../fmt)
make install
cd ../..
