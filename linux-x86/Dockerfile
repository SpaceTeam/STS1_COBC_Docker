FROM ubuntu:latest

ENV HOME /

RUN apt-get update -qq && apt-get install -y -qq \
    ca-certificates \
    clang-tidy-12 \
    cmake \
    cppcheck \
    gcc-12 \
    gcc-12-multilib \
    git \
    g++-12 \
    g++-12-multilib \
    lcov \
    libc6-dev \
    make \
    sudo \
    wget \
    xz-utils \
&& rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-12 12

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 12

COPY install.sh /install.sh
COPY libraries.txt /libraries.txt

RUN chmod +x /install.sh

# Run the script inside the Docker image
RUN /install.sh linux
