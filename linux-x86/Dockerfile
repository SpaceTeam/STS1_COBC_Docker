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

RUN git clone --branch st_develop https://github.com/SpaceTeam/rodos.git \
&& cd rodos \
&& find . -name linux-x86.cmake | xargs cp -t $HOME -v \ 
&& cmake --toolchain cmake/port/linux-x86.cmake -S . -B build \
&& cmake --build build \
&& cmake --install build \ 
&& cd / && rm -r rodos

RUN git clone https://github.com/ETLCPP/etl.git \
&& cd etl \
&& git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50 \
&& cmake -S . -B build  \
&& cmake --install build \
&& cd / && rm -r etl

RUN git clone https://github.com/foonathan/debug_assert.git \
&& cd debug_assert \
&& git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0 \
&& cmake -S . -B build \
&& cmake --install build \
&& cd / && rm -r debug_assert

RUN git clone https://github.com/foonathan/type_safe.git \
&& cd type_safe \
&& git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9 \
&& cmake -S . -B build \
&& cmake --install build \
&& cd / && rm -r type_safe

RUN git clone https://github.com/catchorg/Catch2.git \
&& cd Catch2 \
&& git checkout v3.1.0 \
&& cmake --toolchain /linux-x86.cmake -S . -B build -DBUILD_TESTING=OFF \
&& cmake --build build/ --target install \
&& cd / && rm -r Catch2
