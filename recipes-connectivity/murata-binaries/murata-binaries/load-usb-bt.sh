#!/bin/sh

su
sleep 1
modprobe btusb
hciconfig hci0 up
hciconfig -a
brcm_patchram_plus_usb_64bit -d -patchram /lib/firmware/brcm/murata-master/_CYW4373A0_001.001.025.0119.0000.2AE.USB_FCC.hcd hci0
hciconfig hci0 up
lsusb
hcitool scan
