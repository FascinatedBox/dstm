cd "$(dirname "$0")"
BUILD_TARGET=""
BUILD_BITS=""

if [ "$1" = "x11" ]; then
    BUILD_TARGET="x11"
elif [ "$1" = "xcb" ]; then
    BUILD_TARGET="xcb"
else
    echo "Usage: build-dstm.sh <x11|xcb> <64|32>"
    exit 1
fi

shift

if [ "$1" = "64" ]; then
    BUILD_BITS="64"
elif [ "$1" = "32" ]; then
    BUILD_BITS="32"
else
    echo "Usage: build-dstm.sh <x11|xcb> <64|32>"
    exit 1
fi

if [ ! -d "${BUILD_TARGET}-64" ]; then
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/lib/lib${BUILD_TARGET} ${BUILD_TARGET}-64

    cp -R ${BUILD_TARGET}-64 ${BUILD_TARGET}-32
fi

cd ${BUILD_TARGET}-${BUILD_BITS}

# Don't apply a patch if one has already been applied.
# There's probably a clever way to do this in git, but this works ok.
if [ ! -e ".patched" ]; then
    git am < ../patches/dstm-${BUILD_TARGET}.patch
    touch .patched
fi

# Assume gcc is installed and explicitly specify a bit size.
./autogen.sh CC="gcc -m${BUILD_BITS}"

# Use all cores when compiling.
make -j `nproc`

echo "Installing ${BUILD_BITS} version of ${BUILD_TARGET} to ~/.config/dstm."

if [ "${BUILD_TARGET}" = "x11" ]; then
    cp src/.libs/libX11.so ~/.config/dstm/libdstmX11-${BUILD_BITS}.so
else
    cp src/.libs/libxcb.so ~/.config/dstm/libdstmxcb-${BUILD_BITS}.so
fi
