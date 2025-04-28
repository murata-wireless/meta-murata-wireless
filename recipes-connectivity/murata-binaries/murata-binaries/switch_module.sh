#!/bin/sh


VERSION="1.0"


cyw_module="none"

function current() {
  echo ""
  echo "Current setup:"
}

function disable_systemd_prints() {
  # Temporarily mutes the prints to dmesg to avoid getting spammed
  # with "systemd-sysv-generator[469]: SysV service..."
  # prints when enabling/disabling systemd services
  echo 1 > /proc/sys/kernel/printk
}

function enable_systemd_prints() {
  # Enables the dmesg prints again
  echo 7 > /proc/sys/kernel/printk
}

function move_ko() {
     # Check for the presence of btbcm.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
     if [ -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko ]; then
#        echo "DEBUG::store() Found btbcm.ko. Moving it murata_wireless"
        mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko /usr/share/murata_wireless
     fi

     # Check for the presence of hci_uart.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
     if [ -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
#        echo "DEBUG::store() Found hci_uart.ko. Moving it murata_wireless"
        mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko /usr/share/murata_wireless
     fi
}

function restore_ko {
     # Check for the presence of btbcm.ko in murata_wireless
     if [ ! -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko ]; then
        echo "DEBUG::restore() Not Found btbcm.ko. Copying it to Kernel"
        cp /usr/share/murata_wireless/btbcm.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko
     fi


     # Check for the presence of hci_uart.ko in murata_wireless
     if [ ! -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
        echo "DEBUG::restore() Not Found hci_uart.ko. Copying it to Kernel"
        cp /usr/share/murata_wireless/hci_uart.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko
     fi
}

function handle_services() {
#  enable_mlan0=$1
#  enable_wlan0=$2

#  disable_systemd_prints
#  if ($enable_mlan0); then
#    echo "Enabling mlan0"
#    systemctl enable wpa_supplicant@mlan0
#  else
#    echo "Disabling mlan0"
#    systemctl disable wpa_supplicant@mlan0
#  fi
#  if ($enable_wlan0); then
#    echo "Enabling wlan0"
#    systemctl enable wpa_supplicant@wlan0
#  else
#    echo "Disabling wlan0"
#    systemctl disable wpa_supplicant@wlan0
#  fi
  enable_systemd_prints
}

function clean_up() {
  # Take a backup of hci_uart.ko to murata_wireless
  if [ ! -e /usr/share/murata_wireless/hci_uart.ko ]; then
      cp /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko /usr/share/murata_wireless/hci_uart.ko 
  fi

  # Take a backup of btbcm.ko to murata_wireless
  if [ ! -e /usr/share/murata_wireless/btbcm.ko ]; then
      cp /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btbcm.ko /usr/share/murata_wireless/btbcm.ko 
  fi

  # Delete the special file created for 2FY
  if [ -e /etc/modprobe.d/2fy_m2.conf ]; then
    rm /etc/modprobe.d/2fy_m2.conf
  fi
}


function prepare_for_cypress() {
  clean_up

# echo "IFX module : $cyw_module"

  #check for the presence of /usr/share/murata_wireless/cypress
  #If there isn't cypress folder, then create one and take a backup
  if [ ! -d "/usr/share/murata_wireless/cypress" ]; then
     mkdir -p /usr/share/murata_wireless/cypress
     cp -rfp /lib/firmware/cypress/* /usr/share/murata_wireless/cypress/
  fi

  # By default copy all the files back to /lib/firmware/cypress
  cp -rfp /usr/share/murata_wireless/cypress/* /lib/firmware/cypress

  # Starting from 6.1.x, "hciattach" is deprecated and will use "btbcm.ko and hci_uart.ko"
  # It needs <module.hcd> to be renamed as "BCM.hcd" and placed in /lib/firmware/brcm

  case $cyw_module in
  DX|1DX)
     cp /lib/firmware/brcm/BCM43430A1_001.002.009.0159.0528.1DX.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  LV|1LV)
     cp /lib/firmware/brcm/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  MW|1MW)
     cp /lib/firmware/brcm/BCM4345C0_003.001.025.0187.0366.1MW.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  YN|1YN)
     cp /lib/firmware/brcm/CYW4343A2_001.003.016.0071.0017.1YN.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2AE-USB|AE-USB|2BC-USB|BC-USB)
     cp /lib/firmware/brcm/murata-master/_CYW4373A0_001.001.025.0119.0000.2AE.USB_FCC.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2AE|AE)
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
     cp /lib/firmware/brcm/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2BC|BC)
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
     cp /lib/firmware/brcm/BCM4373A0_001.001.025.0103.0155.FCC.CE.2BC.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  XA|1XA)
     cp /lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  BZ|2BZ)
     cp /lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2EA-SDIO|2EA-PCIE)
     cp /lib/firmware/brcm/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2FY|FY|2GY|GY)
     cp /lib/firmware/brcm/CYW55500A1_001.002.032.0040.0033.2FY.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  esac

  depmod -a

  # Disable NXP service and enable Cypress service
  handle_services false true
}

function prepare_for_cypress_ae_usb() {
  rm -rf /lib/firmware/cypress/*
  cp /usr/share/murata_wireless/cypress/cyfmac4373-usb.2AE.bin /lib/firmware/cypress/cyfmac4373.bin
  cp /usr/share/murata_wireless/cypress/cyfmac4373-sdio.2AE.clm_blob /lib/firmware/cypress/cyfmac4373.clm_blob
}

function prepare_for_cypress_bc_usb() {
  rm -rf /lib/firmware/cypress/*
  cp /usr/share/murata_wireless/cypress/cyfmac4373-usb.2BC.bin /lib/firmware/cypress/cyfmac4373.bin
  cp /usr/share/murata_wireless/cypress/cyfmac4373-sdio.2BC.clm_blob /lib/firmware/cypress/cyfmac4373.clm_blob
}

function off() {
  # Disable both NXP and Cypress services
  handle_services false false
}

function switch_to_cypress_sdio() {
  echo ""
  echo "Setting up for 1DX, 1LV, 1MW, 1WZ, 1YN, 2AE, 2BC, 2BZ, 2EA, 2GF, 2FY (Cypress - SDIO)"

#  if [ $cyw_module == "2EA-SDIO" ] || [ $cyw_module == "2FY" ]; then
#     echofw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}-2ea.dtb 2>/dev/null
#     fw_setenv bt_hint cypress_2ea
#     fw_setenv cmd_custom
     move_ko
#  else
#     fw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}.dtb 2>/dev/null
#     fw_setenv bt_hint cypress
#     fw_setenv cmd_custom
#     restore_ko
#  fi

  # Set sdio_idleclk_disable=1 parameter when loading brcmfmac for 2FY.
  # The file created here is deleted in clean_up function above.
  if [ $cyw_module == "2FY" ] || [ $cyw_module == "2GY" ]; then
     echo "options brcmfmac sdio_idleclk_disable=1" > /etc/modprobe.d/2fy_m2.conf
  fi

  prepare_for_cypress
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_ae_usb() {
  echo ""
  echo "Setting up for 2AE (Cypress - USB)"

#  fw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}.dtb 2>/dev/null
#  fw_setenv bt_hint cypress
#  fw_setenv cmd_custom
  restore_ko

  prepare_for_cypress
  prepare_for_cypress_ae_usb
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_bc_usb() {
  echo ""
  echo "Setting up for 2BC (Cypress - USB)"

#  fw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}.dtb 2>/dev/null
#  fw_setenv bt_hint cypress
#  fw_setenv cmd_custom
#  restore_ko

  prepare_for_cypress
  prepare_for_cypress_bc_usb
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_pcie() {
  echo ""
  echo "Setting up for 1CX, 1XA, 2EA (Cypress - PCIe)"

#  if [ $cyw_module == "2EA-PCIE" ]; then
#     fw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}-pcie-2ea.dtb 2>/dev/null
#     fw_setenv bt_hint cypress_2ea
#     fw_setenv cmd_custom
#     move_ko
#  else
#     fw_setenv fdt_file imx8mm-ea-ucom-kit_${DTB_VER}-pcie.dtb 2>/dev/null
#     fw_setenv bt_hint cypress
#     fw_setenv cmd_custom
#     restore_ko
#  fi

  prepare_for_cypress
  echo "Setup complete."
  echo ""
}



function usage() {
  echo ""
  echo "Version: $VERSION"
  echo ""
  echo "Usage:"
  echo "  $0  <module>"
  echo ""
  echo "Where:"
  echo "  <module> is one of (case insensitive):"
  echo "     1DX, 1LV, 1MW, 1YN, 2AE, 2AE-USB, 2BC, 2BC-USB, 1XA, 2BZ, 2GF, 2FY, 2EA-SDIO, 2EA-PCIe"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

cyw_module=${1^^}
 
case ${1^^} in
  CYW-PCIE|XA|1XA|2EA-PCIE)
    switch_to_cypress_pcie
    ;;
  CYW-SDIO|LV|1LV|DX|1DX|MW|1MW|YN|1YN|2AE|2BC|2EA-SDIO|BZ|2BZ|GF|2GF|FY|2FY)
    switch_to_cypress_sdio
    ;;
  AE-USB|2AE-USB)
    switch_to_cypress_ae_usb
    ;;
  BC-USB|2BC-USB)
    switch_to_cypress_bc_usb
    ;;
  CURRENT)
    current
    ;;
  OFF)
    off
    ;;
  *)
    current
    usage
    ;;
esac
