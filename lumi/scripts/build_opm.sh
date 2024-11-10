#!/bin/bash
location=$(pwd)
for build_type in "Release" "Debug" "RelWithDebInfo";
do
    set -e
    build_type_lower=$(echo $build_type|awk '{print tolower($0)}')
    build_folder="build_${build_type_lower}"
    mkdir -p ${build_folder}
    cd ${build_folder}
    bash ../run_cmake_opm_${build_type_lower}.sh
    ninja
    cd ${location}
done
