build_type=Release
build_threads=8
installdir=$1
# Build and install Umpire
git clone --recursive https://github.com/LLNL/Umpire.git
cd Umpire
cmake -S . -B build \
        -DUMPIRE_ENABLE_C=ON \
        -DUMPIRE_ENABLE_TOOLS=OFF \
        -DENABLE_CUDA=OFF \
        -DENABLE_HIP=ON \
        -DENABLE_SYCL=OFF \
        -DENABLE_BENCHMARKS=OFF \
        -DENABLE_EXAMPLES=OFF \
        -DENABLE_DOCS=OFF \
        -DENABLE_TESTS=OFF \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_INSTALL_PREFIX=${installdir} \
        -DCMAKE_PREFIX_PATH="${installdir};/opt/rocm;/usr/local" \
        -DCMAKE_HIP_ARCHITECTURES="${AMDGPU_TARGETS}"
cmake --build build -j ${build_threads}
cmake --install build


# Build and install hypre
git clone https://github.com/hypre-space/hypre
cd hypre
git checkout origin/auto-umpire
sed -i 's/hypre_printf(" | %13s | %13s", "UmpPSize (GiB)", "UmpPPeak (GiB)")/&;/' /hypre/src/utilities/memory.c
cmake -S src -B build \
        -DCMAKE_BUILD_TYPE=${build_type} \
        -DCMAKE_INSTALL_PREFIX=${installdir} \
        -DHYPRE_INSTALL_PREFIX=${installdir} \
        -DBUILD_SHARED_LIBS=ON \
        -DHYPRE_ENABLE_HIP=ON \
        -DHYPRE_USING_GPU=ON \
        -DHYPRE_USING_DEVICE_MEMORY=ON \
        -DHYPRE_BUILD_UMPIRE=ON \
        -DHYPRE_ENABLE_UMPIRE_HOST=OFF \
        -DHYPRE_ENABLE_UMPIRE_DEVICE=ON \
        -DHYPRE_ENABLE_UMPIRE_PINNED=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DCMAKE_PREFIX_PATH="${installdir};/opt/rocm;/usr/local" \
        -DCMAKE_HIP_ARCHITECTURES="${AMDGPU_TARGETS}"
cmake --build build -j${build_threads}
cmake --install build