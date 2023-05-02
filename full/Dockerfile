FROM tuwienspaceteam/sts1-cobc:latest-linux-x86

RUN apt-get update -qq && apt-get install -y sudo -qq

# Install toolchain
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz -nv \
&& wget https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc -nv \
&& sha256sum --check arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc \
&& if [ $? -eq 0 ]; then echo "Checksum OK"; else echo "Checksum verification failed!"; exit 1; fi \
&& tar -xvf arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz -C /opt \
&& rm arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz.sha256asc

ENV PATH="/opt/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi/bin:${PATH}"

RUN GCC_VERSION=$(gcc -dumpfullversion | awk -F. '{print $1}') \
&& ARM_GCC_VERSION=$(arm-none-eabi-gcc -dumpfullversion | awk -F. '{print $1}') \
&& if [ "$GCC_VERSION" -eq "$ARM_GCC_VERSION" ]; \
    then \
        echo "Versions match: gcc $GCC_VERSION and arm-none-eabi-gcc $ARM_GCC_VERSION"; \
    else \
        echo "Error: gcc version is $GCC_VERSION but arm-none-eabi-gcc version is $ARM_GCC_VERSION"; \
        exit 1; \
    fi


WORKDIR $HOME
ADD stm32f411.cmake .

COPY install.sh /install.sh
COPY libraries.txt /libraries.txt

RUN chmod +x /install.sh

# Run the script inside the Docker image
RUN /install.sh cobc /usr/local/stm32f411
