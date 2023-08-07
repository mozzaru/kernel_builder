#!/bin/bash

maindir="$(pwd)"
outside="${maindir}/.."

dir="${outside}/ZyCClang"

case $1 in
    "setup" )
        # Clone compiler
        if [[ ! -d "${dir}" ]]; then
          mkdir ${dir} && cd ${dir}
	  curl -Lo a.tar.gz "$(curl https://raw.githubusercontent.com/ZyCromerZ/Clang/main/Clang-main-link.txt)"
	  tar -zxf a.tar.gz
        fi
    ;;

    "build" )
        make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
        make -j$(nproc --all) O=out \
            PATH="${dir}/bin:/usr/bin:${PATH}" \
            CROSS_COMPILE="aarch64-linux-gnu-" \
            CROSS_COMPILE_ARM32="arm-linux-gnueabi-" \
            CROSS_COMPILE_COMPAT="arm-linux-gnueabi-" \
            CC=clang \
            LD=ld.lld \
            NM=llvm-nm \
            AR=llvm-ar \
            STRIP=llvm-strip \
            OBJCOPY=llvm-objcopy \
            OBJDUMP=llvm-objdump \
            READELF=llvm-readelf \
            LLVM_IAS=1 \
            HOSTCC=clang \
            HOSTCXX=clang++ \
            HOSTLD=ld.lld \
            HOSTAR=llvm-ar \
            2>&1 | tee out/error.log
    ;;
esac
