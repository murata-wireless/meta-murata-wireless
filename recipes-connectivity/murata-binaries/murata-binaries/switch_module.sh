#!/bin/sh

# Switch between 2BC (default) and 2AE.

VERSION="1.0"

cyw_module="none"


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


function current() {
  echo ""
  echo "Current setup:"

  if [ "/lib/firmware/cypress/cyfmac4373-sdio.bin" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2AE.bin" ]; then
    echo "  Link is to 2AE Firmware file"
  fi
  if [ "/lib/firmware/cypress/cyfmac4373-sdio.txt" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2AE.txt" ]; then
    echo "  Link is to 2AE NVRAM file"
  fi
  if [ "/lib/firmware/cypress/cyfmac4373-sdio.clm_blob" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob" ]; then
    echo "  Link is to 2AE CLM_BLOB file"
  fi


  if [ "/lib/firmware/cypress/cyfmac4373-sdio.bin" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2BC.bin" ]; then
    echo "  Link is to 2BC Firmware file"
  fi
  if [ "/lib/firmware/cypress/cyfmac4373-sdio.txt" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2BC.txt" ]; then
    echo "  Link is to 2BC NVRAM file"
  fi
  if [ "/lib/firmware/cypress/cyfmac4373-sdio.clm_blob" -ef "/lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob" ]; then
    echo "  Link is to 2BC CLM_BLOB file"
  fi


  echo ""
}

function prepare_for_cypress() {
#  echo "IFX module : $cyw_module"

  if [ -e /lib/firmware/cypress/cyfmac4373-sdio.bin ]; then
        rm /lib/firmware/cypress/cyfmac4373-sdio.bin
        rm /lib/firmware/cypress/cyfmac4373-sdio.txt
        rm /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
  fi

  if [ $cyw_module == "2AE" ]; then
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2AE.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2AE.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob	
        echo "Setting up of 2AE is complete:"
  fi

  if [ $cyw_module == "2BC" ]; then
#	Defaults point to 2BC
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2BC.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2BC.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
        ln -s /lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
        echo "Setting up of 2BC is complete:"
  fi

  if [ $cyw_module == "2EA" ]; then
#	Defaults point to 2EA
        cp /lib/firmware/brcm/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd /lib/firmware/brcm/BCM.hcd
        echo "Setting up of 2EA is complete:"
  fi

  if [ $cyw_module == "2FY" ]; then
        cp /lib/firmware/brcm/CYW55500A1_001.002.032.0040.0033.2GF.hcd /lib/firmware/brcm/BCM.hcd
        echo "Setting up of 2FY is complete:"
  fi


  # Check for the presence of hci_uart.ko and btbcm.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
  move_ko

}


function switch_to_cypress() {
  echo ""
  prepare_for_cypress
}

function usage() {
  echo ""
  echo "Version: $VERSION"
  echo ""
  echo "Usage:"
  echo "  $0  <module>"
  echo ""
  echo "Where:"
  echo "  <module> is one of :"
  echo "     1DX,1YN,1LV,1XA,2AE,2BA,2BC,2BZ,2EA,2FY"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

cyw_module=${1^^}

case ${1^^} in
  1DX|1YN|1LV|1XA|2AE|2BA|2BC|2BZ|2EA|2FY)
    switch_to_cypress
    ;;
  *)
    current
    usage
    ;;
esac
