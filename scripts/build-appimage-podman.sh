#!/usr/bin/env bash

set -e

podman build -t quartz .
podman run -v "$PWD:/output" quartz
