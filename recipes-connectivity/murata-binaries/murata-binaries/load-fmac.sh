#!/bin/sh
rmmod compat
rmmod cfg80211
insmod /home/root/updates/compat/compat.ko
insmod /home/root/updates/net/wireless/cfg80211.ko
insmod /home/root/updates/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko
insmod /home/root/updates/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko
wl ver

insmod $(find /home/root -iname btbcm.ko)
insmod $(find /home/root -iname hci_uart.ko)
