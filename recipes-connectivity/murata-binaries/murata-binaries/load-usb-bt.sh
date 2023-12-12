#!/bin/sh

# Load btusb 2AE & 2BC USB Bluetooth bring-up

modprobe btusb
echo "04b4 640c" > /sys/bus/usb/drivers/btusb/new_id
hciconfig hci0 up
brcm_patchram_plus_usb64 -d –patchram /lib/firmware/brcm/BCM4373A0.2AE.hcd hci0
hciconfig hci0 up
hciconfig hci0 -a
