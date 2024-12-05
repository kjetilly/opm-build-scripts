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

for repo in COMMON MODELS GRID SIMULATORS UPSCALING
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


for build_type in "Release" "Debug" "RelWithDebInfo";
do
    set -e
    build_type_lower=$(echo $build_type|awk '{print tolower($0)}')
    build_folder="build_${build_type_lower}"
    mkdir -p ${build_folder}
    cd ${build_folder}
    omp_string=""
    if [[ "$OSTYPE" == "darwin"* ]]
    then
        omp_string="-DOpenMP_ROOT=/opt/homebrew/opt/libomp  -DCMAKE_C_FLAGS='-isystem /opt/homebrew/opt/libomp/include' -DCMAKE_CXX_FLAGS='-isystem /opt/homebrew/opt/libomp/include'"
    fi
    cat > "../run_cmake_opm_${build_type_lower}.sh" <<- _EOL_
cmake .. \
  -DCMAKE_PREFIX_PATH="$(realpath ${OPM_DEPENDENCIES_DIR}/dune);$(realpath ${OPM_DEPENDENCIES_DIR}/zoltan);$(realpath ${OPM_DEPENDENCIES_DIR}/fmt)" \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_C_COMPILER=$CC \
  -Dfmt_DIR=$(realpath ${OPM_DEPENDENCIES_DIR}/fmt/lib/cmake/fmt) \
  -GNinja \
  -DCMAKE_BUILD_TYPE=${build_type} \
  -DMETIS_ROOT=$(realpath ${OPM_DEPENDENCIES_DIR}/metis) \
  ${omp_string} \
  -DCMAKE_CXX_COMPILER_LAUNCHER=$(which ccache) \
  -DCMAKE_CUDA_COMPILER_LAUNCHER=$(which ccache) \
  -DCMAKE_C_COMPILER_LAUNCHER=$(which ccache)
_EOL_
    cd ..
done