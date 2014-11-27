
LedOn(){
  echo "18" > /sys/class/gpio/export;
  echo "out" > /sys/class/gpio/gpio18/direction;
  echo "0" > /sys/class/gpio/gpio18/value;
}

LedOff(){
  echo "18" > /sys/class/gpio/unexport;
}


while :; do
 LedOn;
 sleep 1;
 LedOff;
 sleep 1;
done


