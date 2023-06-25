FROM ubuntu:22.04

WORKDIR /app

RUN apt update && apt upgrade \
    && apt install libboost-dev \
    libboost-system-dev \
    build-essential \
    libboost-chrono-dev \
    libboost-random-dev \
    libssl-dev \
    libgeoip-dev \
    git \
    pkg-config \
    automake \
    libtool \
    zlib1g-dev \
    qtbase5-dev \
    qttools5-dev-tools \
    python3 \
    geoip-database

ADD https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_14/libtorrent-rasterbar-1.1.14.tar.gz ./release/libtorrent-rasterbar-1.1.14.tar.gz
ADD https://sourceforge.net/projects/qbittorrent/files/qbittorrent/qbittorrent-4.1.9.1/qbittorrent-4.1.9.1.tar.gz/download ./release/qbittorrent-4.1.9.1.tar.gz

RUN tar -zxf ./release/libtorrent-rasterbar-1.1.14.tar.gz -C . \
    && tar -zxf ./release/qbittorrent-4.1.9.1.tar.gz -C .

# 编译libtorrent-rasterbar-1.1.14
RUN cd libtorrent-rasterbar-1.1.14 \
    && ./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++11 \
    && make && make install \
    && ldconfig

RUN cd qbittorrent-4.1.9.1 \
    && ./configure --prefix=/usr --disable-gui CXXFLAGS=-std=c++11  \
    && make && make install \
    && ldconfig

RUN apt autoremove && rm -rf ./* && mkdir scripts



CMD ["echo","y","|","qbittorrent-nox"]
