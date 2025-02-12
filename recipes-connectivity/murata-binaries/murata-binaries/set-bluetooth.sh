#!/bin/sh

# Pulls in hci_uart.ko from /lib/modules/${uname -a}.

VERSION="1.0"

cyw_module="none"

function current() {
  echo ""
  echo "Current setup:"
  echo ""
}

function move_ko() {
     # Check for the presence of hci_uart.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
     if [ -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
        echo "DEBUG::store() Found hci_uart.ko. Moving it murata_wireless"
        mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko /usr/share/murata_wireless
     fi

     if [ -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko ]; then
        echo "DEBUG::store() Found btbcm.ko. Moving it murata_wireless"
        mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko /usr/share/murata_wireless
     fi

}

function restore_ko {
     # Check for the presence of hci_uart.ko in murata_wireless
     if [ ! -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
        echo "DEBUG::restore() Not Found hci_uart.ko. Copying it to Kernel"
        cp /usr/share/murata_wireless/hci_uart.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko
     fi

     if [ ! -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko ]; then
        echo "DEBUG::restore() Not Found hci_uart.ko. Copying it to Kernel"
        cp /usr/share/murata_wireless/btbcm.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko
     fi

}

function prepare_for_cypress() {
#  echo "IFX module : $cyw_module"

  if [ $cyw_module == "IFX" ]; then
     # Check for the presence of hci_uart.ko and btbcm.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
     move_ko
     echo "Setting up of Bluetooth for IFX is complete:"
  else
     restore_ko
  fi
}


function switch_to_cypress() {
  echo ""
  prepare_for_cypress
}



function usage() {
  echo ""
  echo "Version: $VERSION"
  echo "Purpose: "
  echo "1. Sets bluetooth module for IFX."
  echo ""
  echo "Usage:"
  echo "  $0  <module>"
  echo ""
  echo "Where:"
  echo "  <module> is one of :"
  echo "     IFX"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

cyw_module=${1^^}

case ${1^^} in
  IFX)
    switch_to_cypress
    ;;
  *)
    current
    usage
    ;;
esac
