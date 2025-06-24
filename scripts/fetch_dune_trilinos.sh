#!/bin/bash
set -e

location=`pwd`
parallel_build_tasks=16
trilinos_version=13-4-1
install_prefix=$location"/zoltan"
mkdir -p $install_prefix
install_prefix=$(realpath $install_prefix)

if [[ ! -d Trilinos ]]; then
    # git clone https://github.com/trilinos/Trilinos.git
    wget https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-${trilinos_version}.zip
    unzip trilinos-release-${trilinos_version}.zip
    mv Trilinos-trilinos-release-${trilinos_version} Trilinos
fi

cd Trilinos
if [[ ! -d build ]]; then
    mkdir build
fi
cd build
cat > ../build_zoltan.sh <<- _EOL_
#!/bin/bash
set -e

cmake \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_INSTALL_PREFIX=$install_prefix \
    -DCMAKE_PREFIX_PATH=$extra_prefix \
    -D TPL_ENABLE_MPI:BOOL=ON \
    -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
    -D Trilinos_ENABLE_Zoltan:BOOL=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
    -Wno-dev \
    ../
make -j $parallel_build_tasks
make install
_EOL_

cd $location

dune_version='v2.9.1'
parallel_build_tasks=2

cd $location
install_prefix=$location/dune
mkdir -p $install_prefix
install_prefix=$(realpath $install_prefix)
for repo in dune-common dune-geometry dune-grid dune-istl
do
    echo "=== Cloning and building module: $repo"
    if [[ ! -d $repo ]]; then
        if [[ "$repo" == "dune-common" ]]
        then
            git clone git@github.com:kjetilly/dune-common.git -b gpufixing
        else
            git clone https://gitlab.dune-project.org/core/$repo.git
        fi
	
    fi
    cd $repo
    if [[ "$repo" != "dune-common" ]]
    then
        git checkout ${dune_version}
    fi
    rm -rf build
    if [[ ! -d build ]]; then
        mkdir build
    fi
    cd build
    cat > ../build_dune_${repo}.sh <<- _EOL_
#!/bin/bash
set -e

cmake -DCMAKE_BUILD_TYPE=Release  \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_PREFIX_PATH="$install_prefix;$extra_prefix" \
    -DCMAKE_INSTALL_PREFIX=$install_prefix \
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
    -DCMAKE_CXX_COMPILER=$CXX \
    ..
make -j $parallel_build_tasks
make install
_EOL_
    cd $location
done
