#!/bin/bash

SCRIPT_REPO="https://github.com/fraunhoferhhi/vvenc"

ffbuild_enabled() {
    return 0
}

fixarm64=()

ffbuild_dockerbuild() {

    mkdir build && cd build

    
    if [[ $TARGET == *arm64 ]]; then
    fixarm64=(
        -DVVENC_ENABLE_ARM_SIMD=ON
    )
    fi

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DVVENC_ENABLE_LINK_TIME_OPT=OFF -DEXTRALIBS="-lstdc++" "${fixarm64[@]}" ..
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libvvenc
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 700 )) || return 0
    echo --disable-libvvenc
}
