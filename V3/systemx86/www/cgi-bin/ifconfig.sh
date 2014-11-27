#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "Ifconfig:"
echo ""
echo "$(ifconfig | sed -i 's/$/<br>/')"
