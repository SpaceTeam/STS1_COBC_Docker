From ubuntu:latest

ENV HOME /

RUN apt-get update -yq \
&& apt-get install cmake git curl build-essential -yq \
&& apt-get install gcc-multilib g++-multilib -yq \
&& apt-get install clang-tidy-12 cppcheck -yq

RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-12 12

RUN git clone https://github.com/ETLCPP/etl.git \
&& git clone https://github.com/foonathan/type_safe.git \
&& git clone https://github.com/foonathan/debug_assert.git \
&& git clone https://github.com/catchorg/Catch2.git \
&& git clone --branch st_develop https://github.com/SpaceTeam/rodos.git 

# Install toolchain
RUN apt-get install wget
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz
RUN tar -xvf arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt
ENV PATH="/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"
# Checking that everything is ok
RUN echo $PATH && arm-none-eabi-g++ --version && arm-none-eabi-gcc --version

WORKDIR rodos
RUN git switch st_develop
RUN find . -name linux-x86.cmake | xargs cp -t $HOME -v
# Installation for linux-x86
RUN cmake --toolchain cmake/port/linux-x86.cmake -S . -B build 
RUN cmake --build build
RUN cmake --install build
# Installation for cobc
RUN ls cmake/port/.
RUN cmake --toolchain cmake/port/cobc.cmake -S . -B build/cobc
RUN cmake --build build/cobc
RUN cmake --install build/cobc --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR etl
RUN git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50
RUN cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR debug_assert
RUN git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0
RUN cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR type_safe
RUN git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9
RUN cmake -S . -B build \
&& cmake --install build \
&& cmake --install build --prefix /usr/local/stm32f411
WORKDIR $HOME

WORKDIR Catch2
RUN git checkout v3.1.0
RUN cmake --toolchain /linux-x86.cmake -S . -Bbuild -H.  -DBUILD_TESTING=OFF
RUN cmake --build build/ --target install
WORKDIR $HOME
