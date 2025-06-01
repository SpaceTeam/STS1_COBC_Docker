FROM ubuntu:24.04

ENV HOME="/"

# Add the LLVM APT repository for more up-to-date packages
RUN apt-get update -qq && apt-get install -y -qq wget gpg
RUN wget -O /usr/share/keyrings/llvm-snapshot.gpg https://apt.llvm.org/llvm-snapshot.gpg.key \
    && gpg --no-tty --batch --yes --dearmor -o /usr/share/keyrings/llvm-snapshot.gpg /usr/share/keyrings/llvm-snapshot.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-snapshot.gpg] http://apt.llvm.org/noble/ llvm-toolchain-noble main" > /etc/apt/sources.list.d/llvm-sources.list \
    && echo "deb-src [signed-by=/usr/share/keyrings/llvm-snapshot.gpg] http://apt.llvm.org/noble/ llvm-toolchain-noble main" >> /etc/apt/sources.list.d/llvm-sources.list

RUN dpkg --add-architecture i386 && apt-get update -qq && apt-get install -y -qq \
    ca-certificates \
    ccache \
    clang-format-19 \
    clang-tidy-19 \
    clangd-19 \
    cppcheck \
    g++-13 \
    g++-13-multilib \
    gcc-13 \
    gcc-13-multilib \
    gdb \
    git \
    lcov \
    libc6-dbg:i386 \
    libclang-19-dev \
    make \
    ninja-build \
    pipx \
    python3-pip \
    sudo \
    valgrind \
    vim \
    wget \
    xz-utils \
&& rm -rf /var/lib/apt/lists/*

# Setup tools versions
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-19 19
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-19 19
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-19 19
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 13
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 13
RUN update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 13

# Install CMake 3.31.7
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.7/cmake-3.31.7-linux-x86_64.tar.gz -q
RUN sudo tar xz -f /cmake-3.31.7-linux-x86_64.tar.gz -C /opt
# Setting PATH for both normal and sudo users
ENV PATH="/.local/bin:/opt/cmake-3.31.7-linux-x86_64/bin:$PATH"
RUN echo "Defaults        secure_path=\"/opt/cmake-3.31.7-linux-x86_64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"" >> /etc/sudoers
RUN cmake --version
RUN sudo cmake --version

# Install clang-tidy-cache
ENV CTCACHE_DIR="/.cache/clang-tidy"
ENV CTCACHE_SAVE_OUTPUT=1
RUN mkdir -p ${CTCACHE_DIR}

RUN wget https://raw.githubusercontent.com/matus-chochlik/ctcache/main/src/ctcache/clang_tidy_cache.py -O /usr/local/bin/clang-tidy-cache && chmod +x /usr/local/bin/clang-tidy-cache

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

# Install cmake-format and codespell
RUN pipx install cmakelang # contains cmake-format
RUN pipx install codespell

# Enable tab completion for git
RUN echo 'source /usr/share/bash-completion/completions/git' >> /.bashrc

# Install posh-git-sh
RUN git clone https://github.com/lyze/posh-git-sh.git
RUN echo 'source /posh-git-sh/git-prompt.sh' >> /.bashrc
RUN echo "PROMPT_COMMAND='__posh_git_ps1 \"\\u@\\h:\\w \" \"\\\$ \";'$PROMPT_COMMAND" >> .bashrc

# Install libraries
COPY install.sh /install.sh
COPY libraries.txt /libraries.txt
RUN chmod +x /install.sh && ./install.sh linux

# Install standalone outcome experimental single-header library
RUN cd /usr/local/include && wget https://github.com/ned14/outcome/raw/master/single-header/outcome-experimental.hpp

# Define entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
