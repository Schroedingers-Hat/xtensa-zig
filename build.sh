#!/bin/sh

set -e

if [ $# != 1 ]; then
    echo "Usage: build -jN"
    echo "Where N is number of jobs to use (probably number of cpu cores)."
    exit
fi

JOBS="$1"
TARGET="x86_64-linux-musl" # Example: riscv64-linux-gnu
MCPU="native" # Examples: `baseline`, `native`, `generic+v7a`, or `arm1176jzf_s`

ROOTDIR="$(pwd)"

TARGET_OS_AND_ABI=${TARGET#*-} # Example: linux-gnu
TARGET_OS_LOWER=${TARGET_OS_AND_ABI%-*} # Example: linux
TARGET_OS_CMAKE=$(echo "$TARGET_OS_LOWER" | cut -c1 | tr a-z A-Z)$(echo "$TARGET_OS_LOWER" | cut -c2-) # Example: Linux

# First build the libraries for Zig to link against, as well as native `llvm-tblgen`.
mkdir -p "$ROOTDIR/out/build-llvm"
cd "$ROOTDIR/out/build-llvm"
cmake "$ROOTDIR/llvm-project/llvm" \
  -DLLVM_ENABLE_PROJECTS="lld;clang" \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DCMAKE_INSTALL_PREFIX="$ROOTDIR/out" \
  -DCMAKE_PREFIX_PATH="$ROOTDIR/out" \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_BENCHMARKS=OFF \
  -DLLVM_ENABLE_BINDINGS=OFF \
  -DLLVM_ENABLE_OCAMLDOC=OFF \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="Xtensa;AVR"\
  -DLLVM_ENABLE_Z3_SOLVER=OFF \
  -DCLANG_BUILD_TOOLS=OFF \
  -DCMAKE_BUILD_TYPE=Release
make "$JOBS" install

# Now we build Zig, still with system C/C++ compiler, linking against LLVM,
# Clang, LLD we just built from source.
mkdir -p "$ROOTDIR/out/build-zig"
cd "$ROOTDIR/out/build-zig"
cmake "$ROOTDIR/zig" -DCMAKE_INSTALL_PREFIX="$ROOTDIR/out" -DCMAKE_PREFIX_PATH="$ROOTDIR/out" -DCMAKE_BUILD_TYPE=Release
make "$JOBS" install

