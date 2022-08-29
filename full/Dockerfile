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

# Install toolchain
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz \
&& tar -xvf arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt \
&& rm arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz
ENV PATH="/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"

WORKDIR $HOME
ADD stm32f411.cmake .

# We are already on branch st-develop, no need to checkout here
WORKDIR rodos
RUN find . -name linux-x86.cmake | xargs cp -t $HOME -v
# Installation for linux-x86
RUN cmake --toolchain cmake/port/linux-x86.cmake -S . -B build \
&& cmake --build build \
&& cmake --install build
# Installation for cobc
RUN cmake --toolchain cmake/port/cobc.cmake -S . -B build/cobc \
&& cmake --build build/cobc \
&& cmake --install build/cobc --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR etl
RUN git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50 \
&& cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR debug_assert
RUN git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0 \
&& cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR type_safe
RUN git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9 \
&& cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR Catch2
RUN git checkout v3.1.0 \
&& cmake --toolchain /linux-x86.cmake -S . -B build -DBUILD_TESTING=OFF \
&& cmake --build build --target install
WORKDIR $HOME
