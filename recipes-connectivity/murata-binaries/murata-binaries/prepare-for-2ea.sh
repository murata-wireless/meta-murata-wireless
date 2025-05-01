#!/bin/sh

if [ ! -d "/home/root/updates" ]; then
   mv $(find /lib/modules -iname updates) /home/root
   mv $(find /lib/modules -iname btbcm.ko) /home/root
   mv $(find /lib/modules -iname hci_uart.ko) /home/root
fi
