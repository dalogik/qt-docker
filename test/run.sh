#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print the version of CMake
qt-cmake --version

# Print the version of QMake and Qt
qmake --version

# Build and run dummy Qt application
qt-cmake -G Ninja -B "$SCRIPT_DIR/dummy_app/build" "$SCRIPT_DIR/dummy_app"
cmake --build "$SCRIPT_DIR/dummy_app/build"

BINARY="$SCRIPT_DIR/dummy_app/build/dummy_app"

if [ -f "${BINARY}.exe" ]; then
    # win64-mingw
    export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ';' -)"
    export WINEDEBUG=-all
    export WINEPREFIX=/tmp/wine-test

    wine "${BINARY}.exe"
else
    # linux64-gcc
    "${BINARY}"
fi
