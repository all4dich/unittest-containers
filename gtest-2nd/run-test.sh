#!/bin/bash
BUILD_BUILD_DIR="build-lgtv"
sudo chown -R `id -u` .
/tools/set-run-test-env.sh
sudo rm -rf ${BUILD_BUILD_DIR}
git clone ssh://wall.lge.com/starfish/build-starfish ${BUILD_BUILD_DIR}
dirs
pushd ${BUILD_BUILD_DIR}
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
#bitbake lib32-starfish-atsc-flash

# make webos-local.conf
MODULE_NAME=webos-preload-manager
echo INHERIT += \"externalsrc\" >> webos-local.conf
#echo EXTERNALSRC_pn-$MODULE_NAME = \"/work/$MODULE_NAME\" >> webos-local.conf
echo EXTERNALSRC_pn-$MODULE_NAME = \"/work\" >> webos-local.conf
echo PR_append_pn-$MODULE_NAME = \".local0\" >> webos-local.conf

# change owner of module folder
# TODO In gerrit, is it needded?
sudo chown -R `id -u` /work/$MODULE_NAME

# build
bitbake lib32-$MODULE_NAME qemu-native

# run unittest
export PATH=$PATH:$PWD/BUILD/sysroots-components/x86_64/qemu-native/usr/bin/
qemu-arm -L /work/$MODULE_NAME/oe-workdir/lib32-recipe-sysroot/ /work/$MODULE_NAME/oe-workdir/$MODULE_NAME*/tests/gtest_$MODULE_NAME

# remove work folder
sudo rm -rf /work/${BUILD_BUILD_DIR}
sudo chown -R "root:root" /work
#sudo rm -rf /work/$MODULE_NAME
