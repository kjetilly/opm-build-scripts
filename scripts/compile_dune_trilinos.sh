#!/bin/bash
set -e

location=`pwd`
cd Trilinos
cd build
bash ../build_zoltan.sh
cd $location
rm -rf Trilinos


for repo in dune-common dune-geometry dune-grid dune-istl
do
    cd $repo
    cd build
    bash ../build_dune_${repo}.sh
    cd $location
done