#!/bin/sh

# Defined path
MainPath="$(pwd)"

# Make flashable zip
MakeZip() {
    if [ ! -d $Any ]; then
        git clone https://github.com/TeraaBytee/AnyKernel3 -b master $Any
        cd $Any
    else
        cd $Any
        git reset --hard
        git checkout master
        git fetch origin master
        git reset --hard origin/master
    fi
    cp -af $MainPath/out/arch/arm64/boot/Image.gz-dtb $Any
    sed -i "s/kernel.string=.*/kernel.string=$KERNEL_NAME-$HeadCommit test by $KBUILD_BUILD_USER/g" anykernel.sh
    zip -r9 $MainPath/"$Compiler-$ZIP_KERNEL_VERSION-$KERNEL_NAME-$TIME.zip" * -x .git README.md *placeholder
    cd $MainPath
}

# config
HeadCommit="$(git log --pretty=format:'%h' -1)"
export ARCH="arm64"
export SUBARCH="arm64"
export KBUILD_BUILD_USER="TeraaBytee"
export KBUILD_BUILD_HOST="GithubServer"
Defconfig="begonia_user_defconfig"
KERNEL_NAME=$(cat "$MainPath/arch/arm64/configs/$Defconfig" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
ZIP_KERNEL_VERSION="4.14.$(cat "$MainPath/Makefile" | grep "SUBLEVEL =" | sed 's/SUBLEVEL = *//g')$(cat "$(pwd)/Makefile" | grep "EXTRAVERSION =" | sed 's/EXTRAVERSION = *//g')"
TIME=$(date +"%m%d%H%M")

# build
for toolchain in $1
do
    rm -rf out

    bash toolchains/$toolchain.sh setup

    Compiler=$toolchain
    BUILD_START=$(date +"%s")

    bash toolchains/$toolchain.sh build $Defconfig

    if [ -e $MainPath/out/arch/arm64/boot/Image.gz-dtb ]; then
        BUILD_END=$(date +"%s")
        DIFF=$((BUILD_END - BUILD_START))
        MakeZip
        echo "build succeed in $((DIFF / 60))m, $((DIFF % 60))s"
    else
        BUILD_END=$(date +"%s")
        DIFF=$((BUILD_END - BUILD_START))
        echo "build failed in $((DIFF / 60))m, $((DIFF % 60))s"
    fi
done
