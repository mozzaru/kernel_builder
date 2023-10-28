#!/bin/bash

maindir="$(pwd)"
outside="${maindir}/.."

dir="${outside}/NeutronClang11032023"

case $1 in
    "setup" )
        # Clone compiler
        if [[ ! -d "${dir}" ]]; then
          mkdir ${dir} && cd ${dir}
          curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
          if ! bash antman -S=11032023 &>/dev/null; then
              exit 1
          fi
        fi
    ;;

    "info" )
        return $(clang -v 2>&1 | cat)
    ;;

    "build" )
        export PATH="${dir}/bin:/usr/bin:${PATH}"
        make -j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 $2
        make -j$(nproc --all) O=out \
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
            2>&1 | tee ${CUR_TOOLCHAIN}.log
    ;;
esac
