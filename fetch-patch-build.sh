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

#make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
