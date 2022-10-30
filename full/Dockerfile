FROM tuwienspaceteam/sts1-cobc:latest-linux-x86

# Install toolchain
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz \
&& tar -xvf arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt \
&& rm arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz
ENV PATH="/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"

WORKDIR $HOME
ADD stm32f411.cmake .

# We are already on branch st-develop, no need to checkout here
RUN git clone --branch st_develop https://github.com/SpaceTeam/rodos.git \
&& cd rodos \
&& cmake --toolchain cmake/port/cobc.cmake -S . -B build/cobc \
&& cmake --build build/cobc \
&& cmake --install build/cobc --prefix /usr/local/stm32f411 \
&& cd / && rm -r rodos

RUN git clone https://github.com/ETLCPP/etl.git \
&& cd etl \
&& git checkout cceb5038664a4fa363e79709bc08bd0bb356ae50 \
&& cmake -S . -B build \
&& cmake --install build --prefix /usr/local/stm32f411 \
&& cd / && rm -r etl

RUN git clone https://github.com/foonathan/debug_assert.git \
&& cd debug_assert \
&& git checkout c0b325e9023cc021bce0d23c8b4211f8e5b071d0 \
&& cmake -S . -B build \
&& cmake --install build --prefix /usr/local/stm32f411 \
&& cd / && rm -r debug_assert

RUN git clone https://github.com/foonathan/type_safe.git \
&& cd type_safe \
&& git checkout b9138d8a26ea9bbab965f87ee925f53fde025fd9 \
&& cmake -S . -B build \
&& cmake --install build --prefix /usr/local/stm32f411 \
&& cd / && rm -r type_safe

RUN git clone https://github.com/SpaceTeam/littlefs.git \
&& cd littlefs \
&& git checkout cmake \
&& cmake --toolchain /stm32f411.cmake -S . -B build \
&& cmake --install build --prefix /usr/local/stm32f411 \
&& cd / && rm -r littlefs
