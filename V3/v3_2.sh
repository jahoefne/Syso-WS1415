compile(){
    cd /group/SYSO_WS1415_12/buildroot
    make
    fakeroot
    cp output/images/* /srv/tftp/rpi/19
    echo "Deployed compiled images to RaspberryPi tftp location";
}

makeSource(){
  cd /group/SYSO_WS1415_12/buildroot
  make source;
}

while :; do
  case $1 in
    -run)
      	makeSource
     	 ;;

	   -cp)
	  	echo "Nothing to do here"
	  	;;

    -co)
      	compile
      	;;

    -h|-help)
    		echo "Parameters:"
    		echo "-run"
    		echo "-cp: Kopieren Ihrer GitLab Sourcen"
    		echo "-co: Compilieren der Quellen"
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

