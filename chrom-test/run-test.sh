#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ${HOME}/.local/depot_tools
chmod +x ${HOME}/.local/depot_tools/*
export PATH="$PATH:${HOME}/.local/depot_tools"
if [ -d build ]; then
echo "A directory './build' exists. Delete it before triggering run-test.sh"
exit 1
fi
/tools/set-run-test-env.sh
sudo mkdir build
sudo chown run-test:staff build
pushd build
git clone -b @1.jcl4tv ssh://gpro.lge.com/webos-pro/chromium79 
cd chromium79/src
./build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
git clone -b @chromium79 ssh://gpro.lge.com/webosose/chromium-v8 v8
git clone ssh://wall.lge.com:29448/app/com.webos.app.crow crow
gn gen out/Default --args="enable_crow = true use_cbe = true use_v8_context_snapshot = true is_webos = false use_neva_appruntime = false use_neva_media = false use_webos_tv_media = false enable_hbbtv = false enable_inettv = false enable_hybridcast = false enable_dcsjp = false enable_dmost = false treat_warnings_as_errors = false enable_nacl = false enable_remoting = false use_lld = false is_debug = false"
autoninja -C out/Default crow_unittests
./out/Default/crow_unittests

#git clone ssh://wall.lge.com/starfish/build-starfish build-webos
#pushd build-webos
#dirs
#BUILD_LAYER=""
#if [ -n "$BUILD_NUMBER" ] && [ -n "$BRANCH" ]; then
#        BUILD_LAYER=builds/${BRANCH:1}/$BUILD_NUMBER
#else
#        BUILD_LAYER=$BRANCH
#fi
#echo $BUILD_LAYER
#CHANGE_COUNT=`git ls-remote --refs  origin $BUILD_LAYER|wc -l`
#if [ $CHANGE_COUNT -ne 1 ]; then
#echo "ERROR: You set wrong build layer chagne information"
#echo "ERROR: BANCH = $BRANCH"
#echo "ERROR: BUILD_NUMBER  = $BUILD_NUMBER"
#echo "ERROR: BUILD_LAYER = $BUILD_LAYER"
#exit 1
#fi
#git checkout $BUILD_LAYER
#./mcf --clean -b 64 -p 32 --premirror=file:///starfish/starfish/jcl/downloads --sstatemirror=file:///starfish/starfish/jcl/sstate-cache --enable-generate-mirror-tarballs --disable-icecc $CHIP
#. oe-init-build-env
#bitbake lib32-starfish-atsc-flash
