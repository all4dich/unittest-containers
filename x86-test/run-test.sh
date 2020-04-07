#!/bin/bash
sudo rm -rf build
sudo mkdir build
sudo chown `id -u` build
pushd build
/tools/set-run-test-env.sh
git clone ssh://wall.lge.com/starfish/build-starfish build-webos
pushd build-webos
dirs
BUILD_LAYER=""
if [ -n "$BUILD_NUMBER" ] && [ -n "$BRANCH" ]; then
        BUILD_LAYER=builds/${BRANCH:1}/$BUILD_NUMBER
else
        BUILD_LAYER=$BRANCH
fi
echo $BUILD_LAYER
CHANGE_COUNT=`git ls-remote --refs  origin $BUILD_LAYER|wc -l`
if [ $CHANGE_COUNT -ne 1 ]; then
echo "ERROR: You set wrong build layer chagne information"
echo "ERROR: BANCH = $BRANCH"
echo "ERROR: BUILD_NUMBER  = $BUILD_NUMBER"
echo "ERROR: BUILD_LAYER = $BUILD_LAYER"
exit 1
fi
git checkout $BUILD_LAYER
./mcf --clean -b 64 -p 32 --premirror=file:///starfish/starfish/jcl/downloads --sstatemirror=file:///starfish/starfish/jcl/sstate-cache --enable-generate-mirror-tarballs --disable-icecc $CHIP
. oe-init-build-env
bitbake lib32-starfish-atsc-flash
