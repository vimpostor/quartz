#!/usr/bin/env bash

set -e

cd examples/demo

cmake -B build-appimage -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build-appimage
DESTDIR=AppDir cmake --install build-appimage

# install placeholder icon
mkdir -p AppDir/usr/share/icons/hicolor/scalable/apps
touch AppDir/usr/share/icons/hicolor/scalable/apps/demo.svg

QML_SOURCES_PATHS="$PWD/src/qml" linuxdeploy --appdir AppDir --plugin qt --output appimage
mv ./*-x86_64.AppImage ../../
