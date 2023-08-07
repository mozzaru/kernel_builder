#!/usr/bin/bash

apt-get update
apt-get install llvm lld bc bison ca-certificates curl flex gcc git libc6-dev \
  libssl-dev openssl python3 python2 zip zstd make clang gcc-arm-linux-gnueabi \
  software-properties-common device-tree-compiler libxml2 libarchive-tools \
  libelf-dev libssl-dev libtfm-dev wget xz-utils -y
ln -sf "/usr/bin/python3" /usr/bin/python

bash tg_utils.sh msg "gh $RUN_NUM: cloning kernel source, repo: $REPO"
git clone --depth=1 https://github.com/$REPO -b $KERNEL_BRANCH kernel

bash tg_utils.sh msg "gh $RUN_NUM: running compilation script(s): $COMPILERS"

cd kernel
bash ../build.sh "$COMPILERS"

ZIP=$(echo *.zip)
if [[ -e $ZIP ]]; then
  for file in $(find . -name '*.zip' -maxdepth 1); do
    bash ../tg_utils.sh up "${file}" ""
  done
else
  bash ../tg_utils.sh up "out/error.log" ""
fi

