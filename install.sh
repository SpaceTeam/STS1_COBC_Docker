#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Error: missing arguments. Usage: $0 [linux|cobc] [prefix]"
  exit 1
fi

if [[ $1 != "linux" && $1 != "cobc" ]]; then
  echo "Error: first argument must be either 'linux' or 'cobc'"
  exit 1
fi

if [[ $1 == "cobc" && $# -lt 2 ]]; then
  echo "Error: missing prefix argument for 'cobc' option"
  exit 1
fi

echo "Arguments provided: $1 $2"

if [ -f /.dockerenv ]; then
    DOCKER_BUILD=true
else
    DOCKER_BUILD=false
fi

PARAM_FILE="libraries.txt"

while IFS=, read -r name reference repo_url; do
  echo "Cloning $name at reference $reference from $repo_url"
  git clone "$repo_url"
  cd "$name"
  git checkout -q "$reference"
  cd ..
done < "$PARAM_FILE"


cd rodos
# We will need it later, so just copy it to the top-level directory
find . -name linux-x86.cmake | xargs cp -t ../ -v
if [[ $1 == "linux" ]]; then
  cmake --toolchain cmake/port/linux-x86.cmake -S . -B build/linux-x86
  cmake --build build/linux-x86
  sudo cmake --install build/linux-x86
else
  cmake --toolchain cmake/port/cobc.cmake -S . -B build/cobc
  cmake --build build/cobc
  sudo cmake --install build/cobc --prefix "$2"
fi
cd ..

if [[ $1 == "linux" ]]; then
  cd Catch2
  cmake --toolchain ../linux-x86.cmake -S . -B build -DBUILD_TESTING=OFF
  sudo cmake --build build/ --target install
  cd ..
fi

cd etl
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  sudo cmake --install build
else
  sudo cmake --install build --prefix "$2"
fi
cd ..

cd debug_assert
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  sudo cmake --install build
else
  sudo cmake --install build --prefix "$2"
fi
cd ..

cd NamedType
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  sudo cmake --install build
else
  sudo cmake --install build --prefix "$2"
fi
cd ..

cd littlefs
if [[ $1 == "linux" ]]; then
  cmake --toolchain ../linux-x86.cmake -DLFS_THREADSAFE=ON -DLFS_NO_MALLOC=ON -S . -B build/linux-x86
  cmake --build build/linux-x86
  sudo cmake --install build/linux-x86
else
  cmake --toolchain ../stm32f411.cmake -DLFS_THREADSAFE=ON -DLFS_NO_MALLOC=ON -S . -B build/cobc
  cmake --build ./build/cobc
  sudo cmake --install build/cobc --prefix "$2"
fi
cd ..

if [[ $1 == "linux" ]]; then
  cd include-what-you-use
  cmake -S . -B build -G "Ninja" -DCMAKE_PREFIX_PATH=/usr/lib/llvm-15
  cmake --build build
  sudo cmake --install build
  cd ..
fi

# Remove cloned repositories to save space in docker image
if [ "$DOCKER_BUILD" = true ]; then
  echo "Removing repositories"
  rm -r rodos
  rm -r Catch2
  rm -r littlefs
  rm -r etl
  rm -r debug_assert
  rm -r type_safe
fi
