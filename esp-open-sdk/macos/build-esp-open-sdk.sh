#!/bin/bash
######
PROJECT_NAME='esp-open-sdk'
VERSION='1.1.2'
BUILD_NUMBER='1'
BUILD_DIR=$(pwd)
PLATFORM="macos"
ARCH="x86_64"

FILENAME="${PROJECT_NAME}-${VERSION}-${PLATFORM}-${ARCH}.tar.gz"


if ! [ -d /Volumes/case-sensitive ]; then
  echo "Can't find /Volumes/case-sensitive"
  exit 1
fi

cd /Volumes/case-sensitive 

echo "Cleaning up old build"
rm -rf *


##### Build ESP Toolchain
git clone https://github.com/pfalcon/esp-open-sdk
cd $PROJECT_NAME
make STANDALONE=y VENDOR_SDK=$VERSION

echo "Cleanup unnessesary files"
cd $BUILD_DIR
mkdir -p $BUILD_DIR/$PROJECT_NAME
rm -rf /Volumes/case-sensitive/$PROJECT_NAME/esp_iot_sdk*.tar.gz
cd /Volumes/case-sensitive/$PROJECT_NAME/

echo "Creating $FILENAME"
tar -zcf $BUILD_DIR/$FILENAME ./esp_iot_sdk_v*/ ./esptool* ./sdk ./xtensa-lx106-elf

echo "Pushing to bintray"
curl -T $BUILD_DIR/$FILENAME -ukireevco:$1 https://api.bintray.com/content/kireevco/generic/$PROJECT_NAME/$VERSION/$FILENAME