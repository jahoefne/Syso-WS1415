# download kernel-src
# wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.1.tar.xz
# tar -xf linux-3.17.1.tar.gz ../
# rm linux-3.17.1.tar.gz

# move our config file to the downloaded kernel
cp ./config.config ../../linux-3.17.1/
mv ../../linux-3.17.1/config.config ../../linux-3.17.1/.config


cd ../../linux-3.17.1
#make clean
ARCH=i386 make -j 4
qemu-system-i386 -kernel arch/x86/boot/bzImage -m 30



