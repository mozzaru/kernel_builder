#!/bin/bash
#
# hdjsjfjjwufbeizihfjejzf

source env

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
KSU_git_ver=$(cd KernelSU && git rev-list --count HEAD)
KSU_ver=$(($KSU_git_ver + 10000 + 200))

sed -i "s/\(CONFIG_LOCALVERSION=\)\(.*\)/\1\"-${kernel_name}-KSU${KSU_ver}\"/" "${defconfig_file}"

echo "$(grep 'CONFIG_LOCALVERSION=' ${defconfig_file})"

echo "includes KernelSU ${KSU_ver}" >> banner_append

for patch_file in ${outside}/ksu/patches/*.patch ; do
  patch -p1 < "$patch_file"
done
