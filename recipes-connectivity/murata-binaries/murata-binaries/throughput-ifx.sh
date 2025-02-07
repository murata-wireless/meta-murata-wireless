#!/bin/sh

# Throughput test.

VERSION="1.0"

echo "Performing Throughput Test: "
# Enable Debug
echo "7" > /proc/sys/kernel/printk
sleep 1
ifconfig wlan0 up
sleep 2
iw dev wlan0 connect "murata_5"
sleep 5
udhcpc -i wlan0
sleep 3
wl mpc 0
sleep 1
wl PM 0
sleep 1
wl frameburst 1
sleep 1
wl scansuppress 1
sleep 1
killall wpa_supplicant
sleep 1
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
sleep 1
cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
sleep 1
cat /sys/kernel/debug/mmc1/ios
sleep 2

#iperf3 -c 192.168.1.4 -i 1 -P 4 -t 60
#iperf3 -c 192.168.1.23 -i 1 -P 4 -t 60 -R
#iperf3 -s -i1
