#!/bin/sh

# Load btbcm.ko and hci_uart.ko for 2EA Bluetooth bring-up

if [ -e /usr/share/murata_wireless/hci_uart.ko ]; then
    rmmod btbcm
    rmmod hci_uart
    insmod /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko
    insmod /usr/share/murata_wireless/hci_uart.ko
fi
