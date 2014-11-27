downloadSource(){
 echo "======================================================"
 echo "= Downloading Linux Kernel Sources + Busybox Sources ="
 echo "======================================================"
 wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.17.2.tar.xz
 tar xC ../../ -f linux-3.17.2.tar.xz
 rm linux-3.17.2.tar.xz
 wget http://busybox.net/downloads/busybox-1.22.1.tar.bz2
 tar xC ../../ -f busybox-1.22.1.tar.bz2
 rm busybox-1.22.1.tar.bz2;
}

patchSources(){
	echo "======================================================"
	echo "= 				Patching Kernel                    ="
	echo "======================================================"
	cd ../../linux-3.17.2/
	patch -p1 -i ../syso/V3/linux-smsc95xx_allow_mac_setting.patch
	patch -p1 -i ../syso/V3/linux-fix-gpio-enumeration.patch
	cd ../syso/V3/;
}

copyGitlabSources(){
	echo "======================================================"
	echo "= 				Copying Gitlab Sources             ="
	echo "======================================================"
	cp ./busybox.config ../../busybox-1.22.1/.config
	cp ./part1.config ../../linux-3.17.2/.config;
	cp -r ./systemx86 ../../linux-3.17.2;
}

compile(){
 echo "============================="
 echo "= Compiling Busybox for ARM ="
 echo "============================="
 cd ../../busybox-1.22.1
 ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make
 cp ./busybox ../syso/V3/systemx86/bin

 cd ../syso/V3
 cp -r ./systemx86 ../../linux-3.17.2

 echo "=========================="
 echo "= Compiling Linux Kernel ="
 echo "=========================="

 cd ../../linux-3.17.2
 make clean
 ARCH=arm CROSS_COMPILE=/opt/toolchains/arm-buildroot-linux-uclibcgnueabihf-4.9.1/bin/arm-buildroot-linux-uclibcgnueabihf- make -j 4
 cd ../syso/V3;
}

bootKernel(){
 echo "=============================" 
 echo "= Starting Kernel with Qemu ="
 echo "============================="
 cd ../../linux-3.17.2
 qemu-system-arm -kernel arch/arm/boot/zImage -dtb arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -machine vexpress-a9  -net nic,macaddr=00:11:25:23:42:55 -net vde,sock=/tmp/vde2-tap0.ctl -append "console=ttyAMA0";
}


while :; do
  case $1 in
    -all)
      	downloadSource
      	patchSources
      	copyGitlabSources
      	compile
      	bootKernel
      	;;

    -dn)
      	downloadSource
     	 ;;
   
    -pa)
	  	patchSources
	  	;;

	-cp)
	  	copyGitlabSources
	  	;;

    -co)
      	compile
      	;;

    -qe)
     	bootKernel
     	;;

    -h|-help)
		echo "Parameters:"
		echo "-dn: Download Quellen (falls nicht schon vorhanden, also z.B. bei wiederholten Aufruf)"
		echo "-pa: Patchen von Quellen"
		echo "-cp: Kopieren Ihrer GitLab Sourcen"
		echo "-co: Compilieren der Quellen"
		echo "-qe: Qemu starten + Fenster mit Terminal zur seriellen Schnittstelle"
		echo "je nach Kombination der Parameter führt das Skript mehrere Aufgabenteile aus"
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

