#!/bin/sh


if [ -d /sys/class/gpio/gpio18 ]
then
	echo "Content-type: text/html"
	echo ""
	echo "0"
fi
