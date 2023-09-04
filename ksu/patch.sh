source env

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
KSU_GIT_VERSION=$(cd KernelSU && git rev-list --count HEAD)
KERNELSU_VERSION=$(($KSU_GIT_VERSION + 10000 + 200))

defconfig="selene_defconfig"
defconfig_file="${maindir}/arch/arm64/configs/${defconfig}"

KERNEL_NAME=$(cat "${defconfig_file}" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
sed -i "s/\(CONFIG_LOCALVERSION=\)\(.*\)/\1\"-$KERNEL_NAME-KSU-$KERNELSU_VERSION\"/" "${defconfig_file}"

echo "$(grep 'CONFIG_LOCALVERSION=' ${defconfig_file})"

echo "includes KernelSU $KERNELSU_VERSION" >> banner_append

for patch_file in ${outside}/ksu/patches/*.patch ; do
  patch -p1 --no-backup-if-mismatch < "$patch_file"
done
