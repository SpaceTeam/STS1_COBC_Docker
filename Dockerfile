From ubuntu:latest

RUN apt-get update -yq \
&& apt-get install cmake git curl build-essential -yq \
&& apt-get install gcc-multilib g++-multilib -yq

ENV HOME /

RUN git clone https://github.com/ETLCPP/etl.git \
&& git clone https://github.com/foonathan/type_safe.git \
&& git clone https://github.com/foonathan/debug_assert.git \
&& git clone https://github.com/catchorg/Catch2.git \
&& git clone --branch st_develop https://github.com/SpaceTeam/rodos.git 

WORKDIR rodos
RUN git status
RUN find . -name linux-x86.cmake | xargs cp -t $HOME -v
RUN cmake --toolchain /linux-x86.cmake -S . -B build 
RUN cmake --build build
RUN cmake --install build
WORKDIR $HOME

WORKDIR etl
RUN git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50
RUN cmake -S . -B build
RUN cmake --install build
WORKDIR $HOME

WORKDIR debug_assert
RUN git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0
RUN cmake -S . -B build
RUN cmake --install build
WORKDIR $HOME

WORKDIR type_safe
RUN git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9
RUN cmake -S . -B build
RUN cmake --install build
WORKDIR $HOME

WORKDIR Catch2
RUN git checkout v3.1.0
RUN cmake --toolchain /linux-x86.cmake -S . -Bbuild -H.  -DBUILD_TESTING=OFF
RUN cmake --build build/ --target install
WORKDIR $HOME
