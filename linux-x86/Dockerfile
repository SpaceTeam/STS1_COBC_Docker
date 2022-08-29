FROM ubuntu:latest

ENV HOME /

RUN apt-get update && apt-get install -y \
    build-essential \
    clang-tidy-12 \
    cmake \
    cppcheck \
    g++-multilib \
    gcc-multilib \
    git \
    lcov \
    wget \
&& rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-12 12

RUN git clone https://github.com/ETLCPP/etl.git \
&& git clone https://github.com/foonathan/type_safe.git \
&& git clone https://github.com/foonathan/debug_assert.git \
&& git clone https://github.com/catchorg/Catch2.git \
&& git clone --branch st_develop https://github.com/SpaceTeam/rodos.git

WORKDIR rodos
RUN find . -name linux-x86.cmake | xargs cp -t $HOME -v \
&& cmake --toolchain cmake/port/linux-x86.cmake -S . -B build \
&& cmake --build build \
&& cmake --install build
WORKDIR $HOME

WORKDIR etl
RUN git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50 \
&& cmake -S . -B build \
&& cmake --install build
WORKDIR $HOME

WORKDIR debug_assert
RUN git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0 \
&& cmake -S . -B build \
&& cmake --install build
WORKDIR $HOME

WORKDIR type_safe
RUN git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9 \
&& cmake -S . -B build \
&& cmake --install build
WORKDIR $HOME

WORKDIR Catch2
RUN git checkout v3.1.0 \
&& cmake --toolchain /linux-x86.cmake -S . -B build -DBUILD_TESTING=OFF \
&& cmake --build build --target install
WORKDIR $HOME
