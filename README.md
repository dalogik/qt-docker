# Qt Docker Build Environments

This repository contains Dockerfiles to build Ubuntu-based images with official
Qt releases. These images are designed to build Qt applications out-of-the-box
without requiring further configuration.

Currently, this repository provides a build environment for Windows OS x64
using the MinGW compiler and a build environment for Linux OS x64 using gcc
compiler.

## Linux GCC Image

The MinGW image includes an official Qt release with all available plugins.

### Download the Image

You can download pre-built images from Docker Hub:
[hub.docker.com/r/dalogik/qt-docker](https://hub.docker.com/r/dalogik/qt-docker)

Look for tags in the format: `qtXX-linux64-gcc-XXXX`.

### Build the Image Locally

If you prefer to build the Docker image yourself, you must specify the Qt
version.

**Note:** [aqtinstall](https://aqtinstall.readthedocs.io/en/latest/index.html)
is used to download tools, so the MinGW version must match the format used by
`aqt`.

Run the following command from the `linux64-gcc` directory:

```bash
docker buildx build \
  --build-arg QT_VERSION=6.10.0 \
  . -t <desired tag>
```

### Compile an Application

The Docker image includes a Wine emulator to run native Windows build tools.
To simplify the process, wrappers around `CMake`, `QMake`, and `mingw32-make`
are provided.

To compile a CMake project, mount your source directory to the container and
run the build commands:

```bash
# Example: Running the build inside the container
cmake -G Ninja -B <build_dir> <source_dir>
cmake --build <build_dir>
```

## Windows MinGW Image

The MinGW image includes an official Qt release with all available plugins.

### Download the Image

You can download pre-built images from Docker Hub:
[hub.docker.com/r/dalogik/qt-docker](https://hub.docker.com/r/dalogik/qt-docker)

Look for tags in the format: `qtXX-win64-mingw-XXXX`.

### Build the Image Locally

If you prefer to build the Docker image yourself, you must specify the Qt
version and the corresponding MinGW version.

**Note:** [aqtinstall](https://aqtinstall.readthedocs.io/en/latest/index.html)
is used to download tools, so the MinGW version must match the format used by
`aqt`.

Run the following command from the `win64-mingw` directory:

```bash
docker buildx build \
  --build-arg QT_VERSION=6.10.0 \
  --build-arg MINGW_VERSION=1310 \
  . -t <desired tag>
```

### Compile an Application

The Docker image includes a Wine emulator to run native Windows build tools.
To simplify the process, wrappers around `CMake`, `QMake`, and `mingw32-make`
are provided.

> **Important:** Only the **Ninja** build system is supported.
> You must set it as the generator.

To compile a CMake project, mount your source directory to the container and
run the build commands:

```bash
# Example: Running the build inside the container
cmake -G Ninja -B <build_dir> <source_dir>
cmake --build <build_dir>
```

# Licensing

The code in this repository (Dockerfile, shell scripts, etc.) is licensed under
the **MIT License**.

## Note on Qt Licensing
This project installs the Qt SDK. Qt is a registered trademark of The Qt
Company Ltd. and is used here pursuant to the terms of the GNU Lesser General
Public License (LGPL).

Users of this Docker image are responsible for ensuring their usage of Qt
complies with the Qt licensing terms (LGPLv3 or Commercial). This repository
does not distribute Qt binaries directly; it downloads them during the build
process.
