#!/bin/sh

# Needed to support writes to otherwise read only memory
. /etc/profile.d/fw_unlock_mmc.sh 

VERSION="1.0"

cyw_module="none"

function current() {
  echo ""
  echo "Current setup:"
  fw_printenv fdt_file 2>/dev/null

  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.cyw" ]; then
    echo "  Link is to Cypress WPA Supplicant binary"
  fi
  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.nxp" ]; then
    echo "  Link is to NXP WPA Supplicant binary"
  fi

  if [ "/usr/sbin/hostapd" -ef "/usr/sbin/hostapd.cyw" ]; then
    echo "  Link is to Cypress Hostapd binary"
  fi
  if [ "/usr/sbin/hostapd" -ef "/usr/sbin/hostapd.nxp" ]; then
    echo "  Link is to NXP Hostapd binary"
  fi

  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    echo "  Found depmod helper file for NXP"
  fi
  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    echo "  Found modprobe helper file for NXP"
  fi
  echo "  wpa_supplicant@mlan0 is `systemctl is-enabled wpa_supplicant@mlan0`"
  echo "  wpa_supplicant@wlan0 is `systemctl is-enabled wpa_supplicant@wlan0`"
  echo ""
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
     # Check for the presence of hci_uart.ko in Kernel, if it is then move/store it to /usr/share/murata_wireless dir
     if [ -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
        echo "DEBUG::store() Found hci_uart.ko. Moving it murata_wireless"
        mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko /usr/share/murata_wireless
     fi
}

function restore_ko {
     # Check for the presence of hci_uart.ko in murata_wireless
     if [ ! -e /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko ]; then
        echo "DEBUG::restore() Not Found hci_uart.ko. Copying it to Kernel"
        cp /usr/share/murata_wireless/hci_uart.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko
     fi
}

function handle_services() {
  enable_mlan0=$1
  enable_wlan0=$2

  disable_systemd_prints
  if ($enable_mlan0); then
    echo "Enabling mlan0"
    systemctl enable wpa_supplicant@mlan0
  else
    echo "Disabling mlan0"
    systemctl disable wpa_supplicant@mlan0
  fi
  if ($enable_wlan0); then
    echo "Enabling wlan0"
    systemctl enable wpa_supplicant@wlan0
  else
    echo "Disabling wlan0"
    systemctl disable wpa_supplicant@wlan0
  fi
  enable_systemd_prints
}

function clean_up() {
  if [ -e /lib/firmware/regulatory.db ]; then
    rm /lib/firmware/regulatory.db
  fi

  if [ -e /lib/firmware/regulatory.db.p7s ]; then
    rm /lib/firmware/regulatory.db.p7s
  fi

  if [ -e /usr/sbin/wpa_supplicant ]; then
    rm /usr/sbin/wpa_supplicant
    rm /usr/sbin/wpa_cli
  fi

  if [ -e /usr/sbin/hostapd ]; then
    rm /usr/sbin/hostapd
    rm /usr/sbin/hostapd_cli
  fi

  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    rm /etc/depmod.d/nxp_depmod.conf
  fi

  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    rm /etc/modprobe.d/nxp_modules.conf
  fi

  if [ -e /etc/udev/rules.d/regulatory.rules ]; then
    rm /etc/udev/rules.d/regulatory.rules
  fi

  # check for the existence of folder, "crda"
  if [ -d "/usr/lib/crda" ]; then
    rm -rf /usr/lib/crda
  fi

  if [ -e /etc/systemd/system/start_country.service ]; then
    disable_systemd_prints
    systemctl stop start_country.service
    # Disable country code service
    systemctl disable start_country.service
    # Remove the file
    rm /etc/systemd/system/start_country.service
    enable_systemd_prints
  fi

  if [ -e /usr/sbin/startup_setcountry.sh ]; then
    rm /usr/sbin/startup_setcountry.sh
  fi

  # Take a backup of hci_uart.ko to murata_wireless
  if [ ! -e /usr/share/murata_wireless/hci_uart.ko ]; then
      cp /lib/modules/$(uname -r)/kernel/drivers/bluetooth/hci_uart.ko /usr/share/murata_wireless/hci_uart.ko 
  fi
}

function prepare_for_nxp_bt() {
  UNAME=$(uname -r)
  FILE="/lib/modules/${UNAME}/kernel/drivers/bluetooth/btnxpuart.ko"
  if [ -f "${FILE}" ]; then
    mv "${FILE}" /usr/share/murata_wireless/
  fi
}

function prepare_for_nxp_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP module(1ZM)
alias sdio:c*v02DFd9149 moal

# Specify arguments to pass when loading the moal module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_xk_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP module(1XK)
alias sdio:c*v02DFd9159 moal

# Specify arguments to pass when loading the moal module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_ds_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP module(2DS)
alias sdio:c*v02DFd9139 moal

# Specify arguments to pass when loading the moal module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_ym_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP modules(1YM-SDIO)
alias sdio:c*v02DFd9141* moal

# Specify arguments to pass when loading the sd8997 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}


function prepare_for_nxp_ym_pcie() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the 1YM-PCIe M.2 module
alias pci:v00001B4Bd00002B42sv*sd*bc02sc00i* moal

# Specify arguments to pass when loading the pcie8997 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_xl_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP modules
alias sdio:c*v02DFd914* moal

# Specify arguments to pass when loading the sd9098 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_xl_pcie() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli
  
  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the 1XL-PCIe M.2 module
alias pci:v00001B4Bd00002B43sv*sd*bc02sc00i* moal
alias pci:v00001B4Bd00002B44sv*sd*bc02sc00i* moal

# Specify arguments to pass when loading the pcie9098 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_el_sdio() {
  clean_up
  prepare_for_nxp_bt
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.nxp /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.nxp /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.nxp /usr/sbin/hostapd_cli
  
  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP modules
alias sdio:c*v0471d0205* moal

# Specify arguments to pass when loading the iw612 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_cypress() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.cyw /usr/sbin/wpa_supplicant
  ln -s /usr/sbin/wpa_cli.cyw /usr/sbin/wpa_cli
  ln -s /usr/sbin/hostapd.cyw /usr/sbin/hostapd
  ln -s /usr/sbin/hostapd_cli.cyw /usr/sbin/hostapd_cli

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
  CX|1CX)
     cp /lib/firmware/brcm/BCM4356A2_001.003.015.0112.0410.1CX.hcd /lib/firmware/brcm/BCM.hcd
    ;;
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
     cp /lib/firmware/brcm/CYW4343A2_001.003.016.0031.0000.1YN.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2AE|AE)
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
     cp /lib/firmware/brcm/BCM4373A0.2AE.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2BC|BC)
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
     cp /lib/firmware/brcm/BCM4373A0.2BC.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  XA|1XA)
     cp /lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  BZ|2BZ)
     cp /lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd /lib/firmware/brcm/BCM.hcd
    ;;
  2EA-SDIO|2EA-PCIE)
     cp /lib/firmware/brcm/CYW55560A1_001.002.087.0159.0010.hcd /lib/firmware/brcm/BCM.hcd
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
  echo "Setting up for 1DX, 1LV, 1MW, 1WZ, 1YN, 2AE, 2BC, 2BZ, 2EA (Cypress - SDIO)"

  if [ $cyw_module == "2EA-SDIO" ]; then
     fw_setenv fdt_file imx93-ea-ucom-kit-2ea.dtb 2>/dev/null
     fw_setenv bt_hint cypress_2ea
     fw_setenv cmd_custom
     move_ko
  else
     fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
     fw_setenv bt_hint cypress
     fw_setenv cmd_custom
     restore_ko
  fi

  prepare_for_cypress
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_ae_usb() {
  echo ""
  echo "Setting up for 2AE (Cypress - USB)"

  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint cypress
  fw_setenv cmd_custom
  restore_ko

  prepare_for_cypress
  prepare_for_cypress_ae_usb
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_bc_usb() {
  echo ""
  echo "Setting up for 2BC (Cypress - USB)"

  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint cypress
  fw_setenv cmd_custom
  restore_ko

  prepare_for_cypress
  prepare_for_cypress_bc_usb
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_pcie() {
  echo ""
  echo "Setting up for 1CX, 1XA, 2EA (Cypress - PCIe)"

  if [ $cyw_module == "2EA-PCIE" ]; then
     fw_setenv fdt_file imx93-ea-ucom-kit-pcie-2ea.dtb 2>/dev/null
     fw_setenv bt_hint cypress_2ea
     fw_setenv cmd_custom
     move_ko
  else
     fw_setenv fdt_file imx93-ea-ucom-kit-pcie.dtb 2>/dev/null
     fw_setenv bt_hint cypress
     fw_setenv cmd_custom
     restore_ko
  fi

  prepare_for_cypress
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt"
  prepare_for_nxp_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_xl_sdio() {
  echo ""
  echo "Setting up for 1XL, 2XS (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt; fdt set serial4/bluetooth fw-init-baudrate  <115200>"
  prepare_for_nxp_xl_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_el_sdio() {
  echo ""
  echo "Setting up for 2EL, 2DL (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt"
  prepare_for_nxp_el_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_xk_sdio() {
  echo ""
  echo "Setting up for 1XK, 2XK (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt"
  prepare_for_nxp_xk_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_ds_sdio() {
  echo ""
  echo "Setting up for 2DS (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt"
  prepare_for_nxp_ds_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit.dtb 2>/dev/null
  fw_setenv bt_hint nxp_1ym_sdio
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8997-bt"
  prepare_for_nxp_ym_sdio
  echo "Setup complete."
  echo ""
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit-pcie.dtb 2>/dev/null
  fw_setenv bt_hint nxp_1ym_pcie
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8997-bt"
  prepare_for_nxp_ym_pcie
  echo "Setup complete."
  echo ""
}


function switch_to_nxp_xl_pcie() {
  echo ""
  echo "Setting up for 1XL, 2XS (NXP - PCIe)"
  restore_ko
  fw_setenv fdt_file imx93-ea-ucom-kit-pcie.dtb 2>/dev/null
  fw_setenv bt_hint nxp_1xl_pcie
  fw_setenv cmd_custom "fdt mknod serial4 bluetooth; fdt set serial4/bluetooth compatible nxp,88w8987-bt"
  prepare_for_nxp_xl_pcie
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
  echo "     CYW-SDIO, CYW-PCIe, 1CX, 1DX, 1LV, 1MW, 1YN, 2AE, 2AE-USB, 2BC, 2BC-USB, 1XA, 2BZ, 2EA-SDIO, 2EA-PCIe"
  echo "     1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 2XK, 1XL-SDIO, 1XL-PCIe, 2XS-SDIO, 2XS-PCIe, 2EL, 2DL, 2DS, CURRENT or OFF"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

cyw_module=${1^^}

case ${1^^} in
  CYW-PCIE|CX|1CX|XA|1XA|2EA-PCIE)
    switch_to_cypress_pcie
    ;;
  CYW-SDIO|LV|1LV|DX|1DX|MW|1MW|YN|1YN|2AE|2BC|2EA-SDIO|BZ|2BZ)
    switch_to_cypress_sdio
    ;;
  AE-USB|2AE-USB)
    switch_to_cypress_ae_usb
    ;;
  BC-USB|2BC-USB)
    switch_to_cypress_bc_usb
    ;;
  ZM|1ZM)
    switch_to_nxp_sdio
    ;;
  XK|1XK|2XK)
    switch_to_nxp_xk_sdio
    ;;
  DS|2DS)
    switch_to_nxp_ds_sdio
    ;;
  YM-SDIO|1YM-SDIO)
    switch_to_nxp_ym_sdio
    ;;
  YM-PCIE|1YM-PCIE)
    switch_to_nxp_ym_pcie
    ;;
  XL-SDIO|1XL-SDIO|XS-SDIO|2XS-SDIO)
    switch_to_nxp_xl_sdio
    ;;
  XL-PCIE|1XL-PCIE|XS-PCIE|2XS-PCIE)
    switch_to_nxp_xl_pcie
    ;;
  2EL|2DL)
    switch_to_nxp_el_sdio
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
