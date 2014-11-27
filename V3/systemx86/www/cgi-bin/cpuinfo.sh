#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "CpuInfo:"
echo "$(cat /proc/cpuinfo)"