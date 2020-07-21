# xtensa-zig

The purpose of this project is to get Zig to build against the xtensa patches on LLVM until they get upstreamed.
As of July 2020, the patches are only available for LLVM-9 so Zig 0.5 is built against them.

Note that LLD is not currently supported on xtensa, so you cannot use `build-exe`.

## Version information

    * LLVM 9.0.1
    * Clang 9.0.1
    * Zig 0.5.0


## Download

Building LLVM takes much time and RAM. So there is a compiled version that may work for you on linux here:
https://github.com/Schroedingers-Hat/xtensa-zig/releases/download/0.5.0/zig.tgz

## Build instructions

```
# If you've already cloned, don't do this, I believe it's 'git submodule update --init'
git clone --recurse-submodules git://github.com/Schroedingers-Hat/xtensa-zig.git

# Replace -j4 with the number of jobs you want to run (probably # cpu cores).
build -j4
```

If it succeeds, output will be in out/build-zig/zig.

You may also want to get the espressif idf if you do not have it.

```
git clone https://github.com/espressif/esp-idf.git
```

## Example

Building an actual app or ELF is a work-in-progress, but with just this you can link and run zig code.

```
# Source file, just adds the newly created zig to your path and then runs esp-idf/export.sh
# No promises that it will work on anything other than bash.
. /export.sh
cd examples
cd all_your_microcontrollers/main

# Some combination of esp-idf and the llvm fork has trouble with clf. So debug builds may have problems.
xtensa-zig build-lib fib.zig -target xtensa-freestanding-none --release-small
cd ..

idf.py flash monitor
```
