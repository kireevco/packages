#!/bin/bash
PROJECT_NAME='debian-chroot'
VERSION='wheezy'
BUILD_NUMBER='1'
BUILD_DIR=$(pwd)
ARCH="mips"
######

FILENAME="${PROJECT_NAME}-${VERSION}-${ARCH}.tar.gz"

echo "Cleaning up old files"
rm -rf $BUILD_DIR/debian/*
rm -rf $BUILD_DIR/*.tar.gz

mkdir -p $BUILD_DIR/debian/

echo "Generate chroot"
debootstrap --foreign --arch $ARCH $VERSION $BUILD_DIR/debian/ http://http.debian.net/debian/

echo "Preparing chroot image"

cd $BUILD_DIR/debian/
rm -rf debootstrap

mkdir -p {media,opt,srv}

mklink run /var/run




cd $BUILD_DIR
echo "Creating $FILENAME"
tar -zcf $BUILD_DIR/$FILENAME ./debian/*


echo "Pushing to bintray"
curl -T $BUILD_DIR/$FILENAME -ukireevco:$1 https://api.bintray.com/content/kireevco/generic/$PROJECT_NAME/$VERSION/$FILENAME