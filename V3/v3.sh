
copyBuildrootConfig(){
	cp ./buildroot.config /group/SYSO_WS1415_12/buildroot/.config
}

makeSource(){
 echo "======================================================"
 echo "= 			Buildroot make Source 					="
 echo "======================================================"
 cd /group/SYSO_WS1415_12/buildroot
 make clean
 make source
 cd /home/jahoefen/syso/V3
}

make(){
 echo "============================="
 echo "= Make ="
 echo "============================="
  cd /group/SYSO_WS1415_12/buildroot
 make
 cd /home/jahoefen/syso/V3
}

while :; do
  case $1 in
    -all)
      copyBuildrootConfig
      makeSource
      make
      ;;
    -source)
      makeSource
      ;;
    -make)
      make
      ;;
    -h|-help)echo "Parameters:"
      echo "-all Do all tasks"
      echo "-source make source buildroot"
      echo "-make make buildroot"
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
