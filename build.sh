#!/bin/bash
#
# idk lmao

maindir="$(pwd)"
outside="${maindir}/.."
zipper="${outside}/zipper"

zipper_repo=fukiame/AnyKernel3-niigo
zipper_branch=selene-old

defconfig="selene_defconfig"

out_image="${maindir}/out/arch/arm64/boot/Image.gz-dtb"
out_dtb="${maindir}/out/arch/arm64/boot/dts/mediatek/mt6768.dtb"
out_dtbo="${maindir}/out/arch/arm64/boot/dtbo.img"

pack() {
  if [[ ! -d ${zipper} ]]; then
    git clone https://github.com/${zipper_repo} -b ${zipper_branch} "${zipper}"
    cd "${zipper}"
  else
    cd "${zipper}"
    git reset --hard
    git checkout ${zipper_branch}
    git fetch origin ${zipper_branch}
    git reset --hard origin/${zipper_branch}
  fi
  cp -af "${out_image}" "${zipper}"
  cp -af "${out_dtb}" "${zipper}/dtb"
  cp -af "${out_dtbo}" "${zipper}/dtbo.img"
  zip -r9 "$1" ./* -x .git README.md ./*placeholder
  cd "${maindir}"
}

# config
commit="$(git log --pretty=format:'%h' -1)"
export ARCH="arm64"
export SUBARCH="arm64"
export KBUILD_BUILD_USER="nijuugo-ji"
export KBUILD_BUILD_HOST="telegram-de"
KERNEL_NAME=$(cat "${maindir}/arch/arm64/configs/${defconfig}" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
ZIP_KERNEL_VERSION="4.14.$(cat "${maindir}/Makefile" | grep "SUBLEVEL =" | sed 's/SUBLEVEL = *//g')"
TIME=$(date +"%y%m%d-%H%M")

# build
for toolchain in $1; do
  rm -rf out

  bash "${outside}/toolchains/${toolchain}.sh" setup

  BUILD_START=$(date +"%s")
  export CUR_TOOLCHAIN="${toolchain}"

  bash "${outside}/toolchains/${toolchain}.sh" build ${defconfig}

  if [ -e "${out_image}" ]; then
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    zip_name="${maindir}/${KERNEL_NAME}-legacy-${TIME}-${commit}-${toolchain}-${ZIP_KERNEL_VERSION}.zip"
    pack ${zip_name}
    echo "build succeeded in $((DIFF / 60))m, $((DIFF % 60))s" >> "${zip_name}.info"
    echo "md5: $(md5sum "${zip_name}" | cut -d' ' -f1)" >> "${zip_name}.info"
  else
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    echo "build failed in $((DIFF / 60))m, $((DIFF % 60))s" >> "error_${toolchain}.log.info"
    echo "compiler: ${toolchain}" >> "error_${toolchain}.log.info"
  fi
done
