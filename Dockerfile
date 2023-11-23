FROM docker.io/vimpostor/appimage-qt6

ADD . /build
WORKDIR /build
RUN scripts/build-appimage.sh
CMD cp *-x86_64.AppImage /output
