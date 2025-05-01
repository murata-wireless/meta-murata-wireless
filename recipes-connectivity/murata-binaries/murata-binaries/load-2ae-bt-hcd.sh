#!/bin/sh

#For 8m-mini, port is ttymxc2
hciattach /dev/ttymxc2 bcm43xx 115200 flow -t 20
sleep 15
echo " "
echo " "
 
su
sleep 1
modprobe btusb
sleep 2
hciconfig hci0 up
sleep 2
hciconfig -a
sleep 2 
brcm_patchram_plus_usb_64bit -d -patchram /lib/firmware/brcm/murata-master/_CYW4373A0_001.001.025.0119.0000.2AE.USB_FCC.hcd hci0
hciconfig hci0 up

lsusb

hcitool scan
