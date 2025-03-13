#!/bin/bash
location=$(pwd)
for build_type in "Release";
do
    set -e
    build_type_lower=$(echo $build_type|awk '{print tolower($0)}')
    build_folder="build_${build_type_lower}"
    mkdir -p ${build_folder}
    cd ${build_folder}
    bash ../run_cmake_opm_${build_type_lower}.sh
    make -j12 install
    cd ${location}
done
