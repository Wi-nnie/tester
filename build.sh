#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

# Edited for Tecno Pop 2 Power

MANIFEST="https://gitlab.com/OrangeFox/Manifest.git -b fox_9.0"
DEVICE=B1p
DT_LINK="https://github.com/Wi-nnie/B1p-Twrp-Device-Tree"
DT_PATH=device/tecno/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
apt install openjdk-8-jdk -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Syncing Recovery Sources +++==="
git config --global http.postBuffer 524288000
repo init --depth=1 -u $MANIFEST
repo sync
git clone https://gitlab.com/OrangeFox/misc/theme.git bootable/recovery/gui/theme
echo " ===+++ Cloning Device Tree +++==="
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export TW_THEME=portrait_hdpi
export BOARD_HAS_NO_REAL_SDCARD=true
export BOARD_RECOVERYIMAGE_PARTITION_SIZE=16384000
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1
export LC_ALL="C"
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka recoveryimage || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv recovery.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

curl -T $OUTFILE https://oshi.at
