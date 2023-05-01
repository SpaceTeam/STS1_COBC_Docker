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
    sudo \
    wget \
&& rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-12 12

COPY install.sh /install.sh
COPY libraries.txt /libraries.txt

RUN chmod +x /install.sh

# Run the script inside the Docker image
RUN /install.sh linux
