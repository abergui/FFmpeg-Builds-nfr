#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xevd"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {

    if [ ! -f "version.txt" ]; then
    echo v0.4.1 >> version.txt
    else
    :
    fi
    
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" ..
    make -j$(nproc)
    make install

    if [[ $TARGET == win* ]]; then
        rm -r "$FFBUILD_PREFIX"/bin "$FFBUILD_PREFIX"/lib/libxevd.dll.a
        mv "$FFBUILD_PREFIX"/lib/xevd/libxevd.a "$FFBUILD_PREFIX"/lib/libxevd.a
    elif [[ $TARGET == linux* ]]; then
        rm -r "$FFBUILD_PREFIX"/bin "$FFBUILD_PREFIX"/lib/*.so*
        mv "$FFBUILD_PREFIX"/lib/xevd/libxevd.a "$FFBUILD_PREFIX"/lib/libxevd.a
    else
        echo "Unknown target"
        return -1
    fi
}

ffbuild_configure() {
    echo --enable-libxevd
}

ffbuild_unconfigure() {
    echo --disable-libxevd
}
