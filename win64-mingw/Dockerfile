ARG QT_VERSION=6.10.0
ARG MINGW_VERSION=1310

FROM ubuntu:24.04 AS build-img
ARG QT_VERSION
ARG MINGW_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install pipx for aqt installation
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    pipx \
    && rm -rf /var/lib/apt/lists/*

# Install aqt
ENV PIPX_BIN_DIR=/pipx

RUN pipx install aqtinstall

ENV PATH="$PATH:/pipx"

# Install QT with all modules except debug_ingo
RUN export ALL_MODULES=$(aqt list-qt windows desktop --modules ${QT_VERSION} win64_mingw | tr ' ' '\n' | grep -v "debug_info" | paste -sd " " -) \
    && aqt install-qt -O /opt/qt windows desktop ${QT_VERSION} win64_mingw -m ${ALL_MODULES} \
    && aqt install-tool -O /opt windows desktop tools_mingw${MINGW_VERSION} \
    && aqt install-tool -O /opt windows desktop tools_cmake \
    && aqt install-tool -O /opt windows desktop tools_ninja

FROM ubuntu:24.04
ARG QT_VERSION
ARG MINGW_VERSION

LABEL org.opencontainers.image.title="Qt MinGW Builder" \
      org.opencontainers.image.description="Ubuntu-based builder with Qt ${QT_VERSION} and MinGW ${MINGW_VERSION}" \
      org.opencontainers.image.authors="Dmitriy Alexandrov <d.alexandrov@dalogik.com>" \
      org.opencontainers.image.source="https://github.com/dalogik/qt-docker" \
      org.opencontainers.image.version="${QT_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

# Add README with a link to qt
COPY --chmod=444 <<\EOF /usr/share/licenses/qt/README
This image contains Qt. Source available at https://download.qt.io
EOF

# Copy installed applications
COPY --from=build-img /opt /opt

# Add CMake wrapper
COPY --chmod=755 <<\EOF /usr/bin/cmake
#!/bin/sh
# Add to Wine PATH all bin directories
export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ";" -);Z:/opt/Tools/Ninja"
# Disable Wine debug
export WINEDEBUG="-all"
# Use tmp directory for Wine files
export WINEPREFIX="/tmp/wine-$(whoami)"
wine /opt/Tools/CMake_64/bin/cmake.exe "\$@"
EOF

# Add qmake wrapper
COPY --chmod=755 <<\EOF /usr/bin/qmake
#!/bin/sh
# Add to Wine PATH all bin directories
export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ";" -);Z:/opt/Tools/Ninja"
# Disable Wine debug
export WINEDEBUG="-all"
# Use tmp directory for Wine files
export WINEPREFIX="/tmp/wine-$(whoami)"
wine /opt/qt/${QT_VERSION}/mingw_64/bin/qmake.exe "\$@"
EOF

# Add qt-cmake wrapper
COPY --chmod=755 <<\EOF /usr/bin/qt-cmake
#!/bin/sh
# Add to Wine PATH all bin directories
export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ";" -);Z:/opt/Tools/Ninja"
# Disable Wine debug
export WINEDEBUG="-all"
# Use tmp directory for Wine files
export WINEPREFIX="/tmp/wine-$(whoami)"
wine /opt/qt/${QT_VERSION}/mingw_64/bin/qt-cmake.exe "\$@"
EOF

# Add windeployqt wrapper
COPY --chmod=755 <<\EOF /usr/bin/windeployqt
#!/bin/sh
# Add to Wine PATH all bin directories
export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ";" -);Z:/opt/Tools/Ninja"
# Disable Wine debug
export WINEDEBUG="-all"
# Use tmp directory for Wine files
export WINEPREFIX="/tmp/wine-$(whoami)"
wine /opt/qt/${QT_VERSION}/mingw_64/bin/windeployqt.exe "\$@"
EOF

# Add mingw32-make wrapper
COPY --chmod=755 <<\EOF /usr/bin/mingw32-make
#!/bin/sh
# Add to Wine PATH all bin directories
export WINEPATH="$(find /opt -name bin -type d | sed 's/^/Z:/' | paste -sd ";" -);Z:/opt/Tools/Ninja"
# Disable Wine debug
export WINEDEBUG="-all"
# Use tmp directory for Wine files
export WINEPREFIX="/tmp/wine-$(whoami)"
wine /opt/Tools/mingw${MINGW_VERSION}_64/bin/mingw32-make.exe "\$@"
EOF

# Install locale
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install wine
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    wine \
    && rm -rf /var/lib/apt/lists/*

# Install usefull for CI packages
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    ca-certificates git git-lfs \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8
