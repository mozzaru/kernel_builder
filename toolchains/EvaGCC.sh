#!/bin/sh

# Defined path
maindir="$(pwd)"
GCC64="$maindir/../EvaGCC64"
GCC="$maindir/../EvaGCC"

case $1 in
    "setup" )
        # Clone compiler
        if [ ! -d $GCC64 ]; then
            git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 $GCC64
        fi
        if [ ! -d $GCC ]; then
            git clone --depth=1 https://github.com/mvaisakh/gcc-arm $GCC
        fi
    ;;

    "build" )
        make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
        make -j$(nproc --all) O=out \
            PATH=$GCC64/bin:$GCC/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=aarch64-elf- \
            CROSS_COMPILE_ARM32=arm-eabi- \
            AR=aarch64-elf-ar \
            NM=llvm-nm \
            LD=ld.lld \
            OBCOPY=llvm-objcopy \
            OBJDUMP=aarch64-elf-objdump \
            STRIP=aarch64-elf-strip \
            2>&1 | tee out/error.log
    ;;
esac
