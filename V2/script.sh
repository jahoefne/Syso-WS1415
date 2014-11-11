# download kernel-src
# wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.1.tar.xz
# tar -xf linux-3.17.1.tar.gz ../
# rm linux-3.17.1.tar.gz

cp -r ./systemx86 ../../linux-3.17.1

# move our config file to the downloaded kernel
cp ./config.config ../../linux-3.17.1/
mv ../../linux-3.17.1/config.config ../../linux-3.17.1/.config

# compile busybox for arm
cp busybox.config ../../busybox-1.22.1/.config
cd ../../busybox-1.22.1
ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make
cp ./busybox ../syso/V2/systemx86/bin

cd ../linux-3.17.1
#make clean
ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make -j 4
qemu-system-arm -kernel arch/arm/boot/zImage -machine vexpress-a9 -append "console=tty1"




