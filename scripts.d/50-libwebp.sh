#!/bin/bash

SCRIPT_REPO="https://chromium.googlesource.com/webm/libwebp"
SCRIPT_COMMIT="eba03acb05383c4cd8ff9a3d18a213fbdcda865d"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --enable-libwebpmux
        --disable-libwebpextras
        --disable-libwebpdemux
        --disable-sdl
        --disable-gl
        --disable-png
        --disable-jpeg
        --disable-tiff
        --disable-gif
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libwebp
}

ffbuild_unconfigure() {
    echo --disable-libwebp
}
