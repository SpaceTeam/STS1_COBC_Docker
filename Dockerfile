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
RUN cmake -S . -B build && \
cmake --install build
WORKDIR $HOME

WORKDIR debug_assert
RUN cmake --toolchain /linux-x86.cmake -S . -B build && \
cmake --install build
WORKDIR $HOME

WORKDIR type_safe
RUN cmake --toolchain /linux-x86.cmake -S . -B build && \
cmake --install build
WORKDIR $HOME

WORKDIR Catch2
RUN git checkout v3.1.0
RUN cmake --toolchain /linux-x86.cmake -S . -Bbuild -H.  -DBUILD_TESTING=OFF
RUN cmake --build build/ --target install
WORKDIR $HOME
