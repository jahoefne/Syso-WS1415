download=dl
copyinitramfs=ci
moveconfig=mc
compilebusybox=cb
compilekernel=ck
bootqemu=bq
parameter=$1

#if [ -z $parameter ] || [ $parameter = $download ]; then
# download kernel-src
# wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.1.tar.xz
# tar -xf linux-3.17.1.tar.gz ../
# rm linux-3.17.1.tar.gz
#fi

if [ -z $parameter ] || [ $parameter = $copyinitramfs ]; then
# copy initramfs folder
cp -r ./systemx86 ../../linux-3.17.1
fi

if [ -z $parameter ] || [ $parameter = $moveconfig ]; then
# move our config file to the downloaded kernel
cp ./config.config ../../linux-3.17.1/.config
fi

if [ -z $parameter ] || [ $parameter = $compilebusybox ]; then
# compile busybox for arm
cp busybox.config ../../busybox-1.22.1/.config
cd ../../busybox-1.22.1
ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make
cp ./busybox ../syso/V2/systemx86/bin
fi

if [ -z $parameter ] || [ $parameter = $compilekernel ]; then
# compile kernel
cd ../linux-3.17.1

# make clean
ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make -j 4
fi

if [ $parameter = $bootqemu ]
then
cd ../../linux-3.17.1
fi

if [ -z $parameter ] || [ $parameter = $bootqemu ]; then
# boot kernel with qemu
qemu-system-arm -kernel arch/arm/boot/zImage -nographic -machine vexpress-a9  -net nic,macaddr=00:11:25:23:42:55 -net vde,sock=/tmp/vde2-tap0.ctl -append "console=ttyAMA0"
fi
