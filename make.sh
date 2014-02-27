#!/bin/bash

BASE_COLOR_VER="ahlan-v3.0.1"
export LOCALVERSION="-"`echo $BASE_COLOR_VER`
export CROSS_COMPILE=~/toolchain/gcc-linaro-arm-linux-gnueabihf-4.8-2014.01_linux/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=soorajj
export KBUILD_BUILD_HOST="me.com"
echo 
echo "Making mako_defconfig"
DATE_START=$(date +"%s")
DATE=$(date +"%Y.%m.%d.%S.%N")
ARCHIVE_FILE="$BASE_COLOR_VER-$DATE"

make "mako_defconfig"

echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH

make -j16 > /dev/null

echo "Build completed."
echo "Copying zImage to flashable zip."
cp arch/arm/boot/zImage ~/kernel_flashable/kernel
find . -name '*ko' -exec cp '{}' ~/kernel_flashable/system/lib/modules/ \;
cd ~/kernel_flashable
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
find . -name '*zip' -exec rm '{}' \;
zip -r `echo $ARCHIVE_FILE`.zip *
echo "Flashable zip made."
echo "cleaning."
find . -name '*ko' -exec rm '{}' \;
find . -name 'zImage' -exec rm '{}' \;
cd ~/work/m
make "clean"
make "mrproper"
echo "everything completed."
