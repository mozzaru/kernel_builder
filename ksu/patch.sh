#!/bin/bash
#
# hdjsjfjjwufbeizihfjejzf

source env

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
KSU_GIT_VERSION=$(cd KernelSU && git rev-list --count HEAD)
KERNELSU_VERSION=$(($KSU_GIT_VERSION + 10000 + 200))

sed -i "s/\(CONFIG_LOCALVERSION=\)\(.*\)/\1\"-${kernel_name}-KSU-$KERNELSU_VERSION\"/" "${defconfig_file}"

echo "$(grep 'CONFIG_LOCALVERSION=' ${defconfig_file})"

echo "includes KernelSU $KERNELSU_VERSION" >> banner_append

for patch_file in ${outside}/ksu/patches/*.patch ; do
  patch -p1 --no-backup-if-mismatch < "$patch_file"
done
