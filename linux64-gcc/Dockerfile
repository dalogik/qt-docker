ARG QT_VERSION=6.10.0

FROM ubuntu:24.04 AS build-img
ARG QT_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install pipx for aqt installation
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends pipx \
    && rm -rf /var/lib/apt/lists/*

# Install aqt
ENV PIPX_BIN_DIR=/pipx

RUN pipx install aqtinstall

ENV PATH="$PATH:/pipx"

# Install QT with all modules except debug_info
RUN export ALL_MODULES=$(aqt list-qt linux desktop --modules ${QT_VERSION} linux_gcc_64 | tr ' ' '\n' | grep -v "debug_info" | paste -sd " " -) \
    && aqt install-qt -O /opt/qt linux desktop ${QT_VERSION} linux_gcc_64 -m ${ALL_MODULES}

FROM ubuntu:24.04
ARG QT_VERSION

LABEL org.opencontainers.image.title="Qt GCC Builder" \
      org.opencontainers.image.description="Ubuntu-based builder with Qt ${QT_VERSION} and the latest GCC" \
      org.opencontainers.image.authors="Dmitriy Alexandrov <d.alexandrov@dalogik.com>" \
      org.opencontainers.image.source="https://github.com/dalogik/qt-docker" \
      org.opencontainers.image.version="${QT_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

# Download standard license texts
ADD https://www.gnu.org/licenses/lgpl-3.0.txt /usr/share/licenses/qt/LGPLv3.txt
ADD https://www.gnu.org/licenses/gpl-3.0.txt /usr/share/licenses/qt/GPLv3.txt

COPY --chmod=444 <<\EOF /usr/share/licenses/qt/README
This image contains Qt. Source available at https://download.qt.io
EOF

# Copy installed applications
COPY --from=build-img /opt /opt

# Install locale
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install required build tools
# build-essential and libgl1-mesa-dev are required for Qt 6
# https://doc.qt.io/qt-6/linux.html
# https://doc.qt.io/qt-6/linux-requirements.html
RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
    build-essential libgl1-mesa-dev \
    cmake ninja-build \
    libfontconfig1-dev \
    libfreetype-dev \
    libgtk-3-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-cursor-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-shm0-dev \
    libxcb-sync-dev \
    libxcb-util-dev \
    libxcb-xfixes0-dev \
    libxcb-xkb-dev \
    libxcb1-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Qt path to the environment
ENV PATH="/opt/qt/${QT_VERSION}/gcc_64/bin:${PATH}"
# Add Qt path for all users
RUN sed -i "s|^PATH=\"|PATH=\"/opt/qt/${QT_VERSION}/gcc_64/bin:|" /etc/environment
