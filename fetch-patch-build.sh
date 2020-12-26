set -eux

KERNEL_VERSION="5.4.82"
RT_VERSION="46"

LINUX="linux"
PATCH="patch-${KERNEL_VERSION}-rt${RT_VERSION}"

git clone https://github.com/raspberrypi/linux.git --depth 1 --branch rpi-5.4.y ${LINUX}
wget https://www.kernel.org/pub/linux/kernel/projects/rt/5.4/older/${PATCH}.patch.xz

cd ${LINUX}
xzcat ../${PATCH}.patch.xz | patch -p1

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig

cat ../config.patch | patch .config

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs

FAT32_TARGET=../target/mnt/fat32
EXT4_TARGET=../target/mnt/ext4
mkdir -p ${FAT32_TARGET}
mkdir -p ${FAT32_TARGET}/overlays
mkdir -p ${EXT4_TARGET}

sudo env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=${EXT4_TARGET} modules_install

KERNEL=kernel8
sudo cp arch/arm64/boot/Image ${FAT32_TARGET}/$KERNEL.img
sudo cp arch/arm64/boot/dts/broadcom/*.dtb ${FAT32_TARGET}
sudo cp arch/arm64/boot/dts/overlays/*.dtb* ${FAT32_TARGET}/overlays/
sudo cp arch/arm64/boot/dts/overlays/README ${FAT32_TARGET}/overlays/
