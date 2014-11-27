#!/bin/sh


if [ -e /sys/class/gpio/gpio17/ ] && [ $(cat /sys/class/gpio/gpio17/value) -eq "0" ]
then
	echo "Content-type: text/html"
	echo ""
	echo "0"
fi
