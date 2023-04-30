FROM tuwienspaceteam/sts1-cobc:latest-linux-x86

# Install toolchain
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz \
&& tar -xvf arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt \
&& rm arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz
ENV PATH="/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"

WORKDIR $HOME
ADD stm32f411.cmake .

COPY install.sh /install.sh
COPY librairies.txt /librairies.txt

# Make the script executable
RUN chmod +x /install.sh

RUN echo "resetting cache"
# Run the script inside the Docker image
RUN /install.sh full /usr/local/stm32f411
