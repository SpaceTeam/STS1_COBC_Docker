FROM ubuntu:22.10

ENV HOME /

RUN apt-get update -qq && apt-get install -y -qq \
    ca-certificates \
    clang-format-15 \
    clang-tidy-15 \
    clangd-15 \
    cmake=3.24.* \
    cppcheck \
    g++-12 \
    g++-12-multilib \
    gcc-12 \
    gcc-12-multilib \
    git \
    lcov \
    make \
    make \
    python3-pip \
    sudo \
    wget \
    xz-utils \
&& rm -rf /var/lib/apt/lists/*

# Setup tools versions
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 15
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-15 15
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 12
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12

# Check for possible mismatch between g++ and gcov versions
RUN GCC_VERSION=$(g++ -dumpfullversion) \
&& GCOV_VERSION=$( gcov --version | head -n 1 | grep -oP "\b\d{1,2}\.\d{1,2}\.\d{1,2}\b" | head -n 1) \
&& if [ "$GCC_VERSION" = "$GCOV_VERSION" ]; \
    then \
        echo "Versions match: gcov $GCOV_VERSION and g++ $GCC_VERSION"; \
    else \
        echo "Error: g++ version is $GCC_VERSION but gcov version is $GCOV_VERSION"; \
        exit 1; \
    fi

# Install cmake-format
RUN pip3 install cmake-format

# Install posh-git-sh
RUN git clone https://github.com/lyze/posh-git-sh.git
RUN echo 'source /posh-git-sh/git-prompt.sh' >> /.bashrc
RUN echo "PROMPT_COMMAND='__posh_git_ps1 \"\\u@\\h:\\w \" \"\\\$ \";'$PROMPT_COMMAND" >> .bashrc
RUN git config --global bash.enableStashStatus false

# Install libraries
COPY install.sh /install.sh
COPY libraries.txt /libraries.txt
RUN chmod +x /install.sh && ./install.sh linux

# Define entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
