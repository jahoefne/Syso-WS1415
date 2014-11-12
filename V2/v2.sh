 
downloadLinuxSource(){
 echo "======================================================"
 echo "= Downloading Linux Kernel Sources + Busybox Sources ="
 echo "======================================================"
 wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.1.tar.xz > /dev/null 2>&1
 tar xC ../../ -f linux-3.17.1.tar.xz
 rm linux-3.17.1.tar.xz
 wget http://busybox.net/downloads/busybox-1.22.1.tar.bz2 > /dev/null 2>&1
 tar xC ../../ -f busybox-1.22.1.tar.bz2
 rm busybox-1.22.1.tar.bz2;
}

compileBusyBox(){
 echo "============================="
 echo "= Compiling Busybox for ARM ="
 echo "============================="
 cp busybox.config ../../busybox-1.22.1/.config
 cd ../../busybox-1.22.1
 ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make
 cp ./busybox ../syso/V2/systemx86/bin
 cd ../syso/V2;
}

compileKernel(){
 echo "=========================="
 echo "= Compiling Linux Kernel ="
 echo "=========================="
 echo " => Copying Initramfs-folder to Source Folder"
 cp -r ./systemx86 ../../linux-3.17.1
 
 echo " => Copying .config to Source Folder"
 cp ./config.config ../../linux-3.17.1/.config
 
 echo " => Compiling Linux Kernel"
 cd ../../linux-3.17.1
  make clean
 ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make -j 4
 cd ../syso/V2;
}

bootKernel(){
 echo "=============================" 
 echo "= Starting Kernel with Qemu ="
 echo "============================="
 cd ../../linux-3.17.1
 qemu-system-arm -kernel arch/arm/boot/zImage -nographic -machine vexpress-a9  -net nic,macaddr=00:11:25:23:42:55 -net vde,sock=/tmp/vde2-tap0.ctl -append "console=ttyAMA0";
}

while :; do
  case $1 in
    -all)
      downloadLinuxSource
      compileBusyBox
      compileKernel
      bootKernel
      ;;
    -dl)
      downloadLinuxSource
      ;;
    -buildbb)
      compileBusyBox
      ;;
    -buildlinux)
      compileKernel
      ;;
    -boot)
     bootKernel
     ;;

    -h|-help)echo "Parameters:"
      echo "-all Do all tasks"
      echo "-dl Download Linux/Busybox Source"
      echo "-buildbb Build BusyBox"
      echo "-buildlinux Build the Linux Source"
      echo "-boot boot the Kernel"
     ;;

    --)
       shift
       break
       ;;

    *)
     break;;

  esac
  shift
done
