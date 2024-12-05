#!/bin/bash
set -e

wget https://github.com/KarypisLab/METIS/archive/refs/tags/v5.2.1.tar.gz
tar xvf v5.2.1.tar.gz
cd METIS-5.2.1
make config i64=1 r64=1 prefix=$(realpath ../metis) shared=1 cc=$CC cxx=$CXX
make install