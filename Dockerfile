# Build with: podman build -t quartz .
# Run with: podman run -v "$PWD:/output" quartz
FROM docker.io/vimpostor/appimage-qt6

ADD . /build
WORKDIR /build
RUN scripts/build-appimage.sh
CMD cp *-x86_64.AppImage /output
