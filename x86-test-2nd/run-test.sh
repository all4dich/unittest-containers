#!/bin/bash
# Go to $BUILD_BUILD_DIR and prepare environments for running 'bitbake' command
pushd ${BUILD_BUILD_DIR}
/tools/set-run-test-env.sh
. oe-init-build-env

# Set '/work' directory as a module's source directory
MODULE_NAME=webos-preload-manager
echo INHERIT += \"externalsrc\" >> webos-local.conf
echo EXTERNALSRC_pn-$MODULE_NAME = \"/work\" >> webos-local.conf
echo PR_append_pn-$MODULE_NAME = \".local0\" >> webos-local.conf

# build
bitbake lib32-$MODULE_NAME qemu-native

# run unittest
export PATH=$PATH:$PWD/BUILD/sysroots-components/x86_64/qemu-native/usr/bin/
qemu-arm -L /work/$MODULE_NAME/oe-workdir/lib32-recipe-sysroot/ /work/$MODULE_NAME/oe-workdir/$MODULE_NAME*/tests/gtest_$MODULE_NAME
RETURN_CODE=$?
sudo chown -R "root:root" /work
echo "INFO: Final exit code: ${RETURN_CODE}"
exit $RETURN_CODE
