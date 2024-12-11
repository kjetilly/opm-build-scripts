#!/bin/bash
set -e

# By default we will just pull the master version of each repository
OPM_COMMON_REPO="https://github.com/opm/opm-common"
OPM_COMMON_BRANCH="master"
OPM_COMMON_COMMIT="HEAD"
OPM_MODELS_REPO="https://github.com/opm/opm-models"
OPM_MODELS_BRANCH="master"
OPM_MODELS_COMMIT="HEAD"
OPM_GRID_REPO="https://github.com/opm/opm-grid"
OPM_GRID_BRANCH="master"
OPM_GRID_COMMIT="HEAD"
OPM_SIMULATORS_REPO="https://github.com/opm/opm-simulators"
OPM_SIMULATORS_BRANCH="master"
OPM_SIMULATORS_COMMIT="HEAD"
OPM_UPSCALING_REPO="https://github.com/opm/opm-upscaling"
OPM_UPSCALING_BRANCH="master"
OPM_UPSCALING_COMMIT="HEAD"

if [ ! -z ${OPM_REPOS} ]
then
    if [ -f ${OPM_REPOS} ]
    then
        echo "Getting extra repo configuration from ${OPM_REPOS}."
        source ${OPM_REPOS}
    fi
fi

for repo in COMMON GRID SIMULATORS UPSCALING
do
    urlvarname="OPM_${repo}_REPO"
    branchvarname="OPM_${repo}_BRANCH"
    commitvarname="OPM_${repo}_COMMIT"
    repolower=$(echo "$repo" | tr '[:upper:]' '[:lower:]')
    git clone ${!urlvarname} -b ${!branchvarname}
    cd "opm-$repolower"
    git checkout ${!commitvarname}
    cd ..
done 

wget https://raw.githubusercontent.com/OPM/opm-utilities/master/opm-super/CMakeLists.txt
head -n -2 CMakeLists.txt > tmp.txt
mv tmp.txt CMakeLists.txt

for build_type in "Release" "Debug" "RelWithDebInfo";
do
    set -e
    build_type_lower=$(echo $build_type|awk '{print tolower($0)}')
    build_folder="build_${build_type_lower}"
    mkdir -p ${build_folder}
    cd ${build_folder}
    
    cat > "../run_cmake_opm_${build_type_lower}.sh" <<- _EOL_
cmake .. \
  -DCMAKE_PREFIX_PATH="$(realpath ../../dune);$(realpath ../../zoltan);$(realpath ../../fmt)" \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_C_COMPILER=$CC \
  -Dfmt_DIR=$(realpath ../../fmt/lib/cmake/fmt) \
  -DCMAKE_BUILD_TYPE=${build_type} \
  -DSuiteSparse_LIBRARIES=$(realpath ../../zoltan/lib64/libsuitesparseconfig.a) \
  -DHAVE_SUITESPARSE_UMFPACK=1 \
  -DSuiteSparse_INCLUDE_DIRS=$(realpath ../../zoltan/include) \
  -DCONVERT_CUDA_TO_HIP=ON \
  -DUSE_HIP=1 \
  -DUSE_BDA_BRIDGE=OFF \
  -DHAVE_CUDA=1 \
  -DCMAKE_HIP_ARCHITECTURES=gfx90a \
  -DLAPACK_LIBRARIES="$(realpath ../../zoltan/lib64/liblapack.a)" 
_EOL_
    cd ..
done
