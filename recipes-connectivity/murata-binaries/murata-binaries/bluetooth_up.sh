#!/bin/sh

# Load btbcm.ko and hci_uart.ko for 2EA Bluetooth bring-up

if [ -e /usr/share/murata_wireless/hci_uart.ko ]; then
#    rmmod btbcm
#    rmmod hci_uart
    echo "7" > /proc/sys/kernel/printk
    insmod /usr/share/murata_wireless/btbcm.ko
    insmod /usr/share/murata_wireless/hci_uart.ko
fi
