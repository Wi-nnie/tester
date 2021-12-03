#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

# Edited for Tecno Pop 2 Power

MANIFEST="git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-6.0"
DEVICE=B1p
DT_LINK="https://github.com/Wi-nnie/B1p-Twrp-Device-Tree -b pbrp"
DT_PATH=device/tecno/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
apt install openjdk-8-jdk -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
echo " ===+++ Cloning Device Tree +++==="
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export TW_THEME=portrait_hdpi
export BOARD_RECOVERYIMAGE_PARTITION_SIZE=16384000
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka recoveryimage || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
cd /root/twrp/out/target/product/B1p/
curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
