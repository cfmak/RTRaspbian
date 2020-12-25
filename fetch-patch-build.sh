set -eux

KERNEL_VERSION="5.4.82"
RT_VERSION="46"

LINUX="linux"
PATCH="patch-${KERNEL_VERSION}-rt${RT_VERSION}"

#wget https://www.kernel.org/pub/linux/kernel/v5.x/${LINUX}.tar.xz
git clone https://github.com/raspberrypi/linux.git --depth 1 --branch rpi-5.4.y
wget https://www.kernel.org/pub/linux/kernel/projects/rt/5.4/older/${PATCH}.patch.xz

xz -cd ${LINUX}.tar.xz | tar xvf -
cd ${LINUX}
xzcat ../${PATCH}.patch.xz | patch -p1

#wget https://raw.githubusercontent.com/raspberrypi/linux/rpi-5.4.y/arch/arm/configs/bcm2711_defconfig
#echo "CONFIG_PREEMPT_RT_FULL=y" >> bcm2711_defconfig
#mv bcm2711_defconfig arch/arm64/configs/.
KERNEL=kernel8
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
