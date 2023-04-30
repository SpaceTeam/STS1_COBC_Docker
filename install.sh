#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Error: missing arguments. Usage: $0 [linux|full] [prefix]"
  exit 1
fi

if [[ $1 != "linux" && $1 != "full" ]]; then
  echo "Error: first argument must be either 'linux' or 'full'"
  exit 1
fi

if [[ $1 == "full" && $# -lt 2 ]]; then
  echo "Error: missing prefix argument for 'full' option"
  exit 1
fi

echo "Arguments provided: $1 $2"

if [ -f /.dockerenv ]; then
    DOCKER_BUILD=true
    HOME=/
else
    DOCKER_BUILD=false
fi

PARAM_FILE="librairies.txt"

while IFS=, read -r name commit repo_url; do
  echo "Cloning $name at commit $commit from $repo_url"
  git clone "$repo_url"
  cd "$name"
  git checkout -q "$commit"
  cd ..
done < "$PARAM_FILE"


cd rodos
find . -name linux-x86.cmake | xargs cp -t $HOME -v
if [[ $1 == "linux" ]]; then
  cmake --toolchain cmake/port/linux-x86.cmake -S . -B build
  cmake --build build
  cmake --install build
fi
if [[ $1 == "full" ]]; then
  cmake --toolchain cmake/port/cobc.cmake -S . -B build/cobc
  cmake --build build/cobc
  cmake --install build/cobc --prefix "$2"
fi
cd ..

cd etl
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  cmake --install build
else
  cmake --install build --prefix "$2"
fi
cd ..

cd debug_assert
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  cmake --install build
else
  cmake --install build --prefix "$2"
fi

cd ..

cd type_safe
cmake -S . -B build
if [[ $1 == "linux" ]]; then
  cmake --install build
else
  cmake --install build --prefix "$2"
fi
cd ..

if [[ $1 == "full" ]]; then
  cd littlefs
  cmake --toolchain /stm32f411.cmake -S . -B build/cobc
  cmake --build ./build/cobc
  cmake --install build --prefix "$2"
  cd .. && rm -r littlefs
fi

# Remove cloned repositories to save space in docker image
if [ "$DOCKER_BUILD" = true ]; then
  echo "Removing repositories"
  rm -r rodos
  rm -r etl
  rm -r debug_assert
  rm -r type_safe
  rm -r Catch2
fi
