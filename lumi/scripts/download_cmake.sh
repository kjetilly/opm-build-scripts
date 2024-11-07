#!/bin/bash
set -e
install_dir=$(realpath $1)
wget https://github.com/Kitware/CMake/releases/download/v3.31.0-rc3/cmake-3.31.0-rc3-linux-x86_64.tar.gz
tar xvf cmake-3.31.0-rc3-linux-x86_64.tar.gz
mkdir -p ${install_dir}
mv cmake-3.31.0-rc3-linux-x86_64/* ${install_dir}/
