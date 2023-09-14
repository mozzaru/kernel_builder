#!/bin/bash

maindir="$(pwd)"
outside="${maindir}/.."

GCC64="${outside}/EvaGCC/gcc-arm64"
GCC="${outside}/EvaGCC/gcc-arm"

case $1 in
    "setup" )
        # Clone compiler
        if [[ ! -d "${GCC64}" ]]; then
            git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 "${GCC64}"
        fi
        if [[ ! -d "${GCC}" ]]; then
            git clone --depth=1 https://github.com/mvaisakh/gcc-arm "${GCC}"
        fi
    ;;

    "build" )
        export PATH="${GCC64}/bin:${GCC}/bin:/usr/bin:${PATH}"
        make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
        make -j$(nproc --all) O=out \
            CROSS_COMPILE=aarch64-elf- \
            CROSS_COMPILE_ARM32=arm-eabi- \
            CROSS_COMPILE_COMPAT=arm-eabi- \
            AR=aarch64-elf-ar \
            NM=llvm-nm \
            LD=ld.lld \
            OBCOPY=llvm-objcopy \
            OBJDUMP=aarch64-elf-objdump \
            STRIP=aarch64-elf-strip \
            2>&1 | tee ${CUR_TOOLCHAIN}.log
    ;;
esac
