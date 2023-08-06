cd /github/workspace

bash tg_utils.sh msg "gh $RUN_NUM: initializing environment for kernel compilation"
sudo apt-get update
sudo apt-get install llvm lld bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python3 zip zstd make clang gcc-arm-linux-gnueabi software-properties-common -y

bash tg_utils.sh msg "gh $RUN_NUM: cloning kernel source, repo: $REPO"
git clone --depth=1 https://github.com/$REPO -b $KERNEL_BRANCH kernel

bash tg_utils.sh msg "gh $RUN_NUM: running compilation script(s): $SCRIPTS"

cd kernel
bash ../build.sh "$SCRIPTS"

ZIP=$(echo *.zip)
if [ -e $ZIP ]; then
    bash ../tg_utils.sh up "$ZIP" ""
else
    bash ../tg_utils.sh up "out/error.log" ""
fi

