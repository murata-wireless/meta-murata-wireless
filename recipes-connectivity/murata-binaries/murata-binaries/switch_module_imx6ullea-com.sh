#!/bin/sh

# Needed to support writes to otherwise read only memory
. /etc/profile.d/fw_unlock_mmc.sh 

VERSION="1.0"

# Detect if a v2 or v3 Carrier Board is used. This will determine dtb file name.
found=`i2cdetect -y 1 0x21 0x21|grep "^20:"`
if [[ $found == *" UU"* ]] || [[ $found == *" 21"* ]]; then
  DTB_VER="v3"
else
  DTB_VER="v2"
fi

echo "DTB_VER is ${DTB_VER}"

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
  if [  -d "/usr/lib/crda" ]; then
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
}

function prepare_for_nxp_sdio() {
  clean_up
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

#  echo "IFX module : $cyw_module"

  if [ $cyw_module == "2AE" ]; then
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
  fi

  if [ $cyw_module == "2BC" ]; then
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.bin /lib/firmware/cypress/cyfmac4373-sdio.bin
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.txt /lib/firmware/cypress/cyfmac4373-sdio.txt
     cp /lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob /lib/firmware/cypress/cyfmac4373-sdio.clm_blob
  fi

# For 2BZ, enabling only in-band interrupt and no OOB
  if [ $cyw_module == "2BZ" ]; then
     fw_setenv cmd_custom "fdt list mmc0/bcrmf@1\; fdt rm mmc0/bcrmf@1 interrupt-parent\; fdt rm mmc0/bcrmf@1 interrupts\; fdt rm mmc0/bcrmf@1 interrupt-names\; fdt list mmc0/bcrmf@1"
  else
     fw_setenv cmd_custom
  fi

  depmod -a

  # Disable NXP service and enable Cypress service
  handle_services false true
}

function off() {
  # Disable both NXP and Cypress services
  handle_services false false
}

function switch_to_cypress_sdio() {
  echo ""
  echo "Setting up for 1DX, 1LV, 1MW, 1WZ, 1YN, 2AE, 2BC, 2BZ, 2EA (Cypress - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  fw_setenv cmd_custom
  fw_setenv bt_hint cypress
  prepare_for_cypress
  echo "Setup complete."
  echo ""
}

function switch_to_cypress_pcie() {
  echo ""
  echo "Setting up for 1CX, 1XA, 2EA (Cypress - PCIe)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}-pcie.dtb 2>/dev/null
  fw_setenv cmd_custom
  fw_setenv bt_hint cypress
  prepare_for_cypress
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp
  prepare_for_nxp_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_xl_sdio() {
  echo ""
  echo "Setting up for 1XL, 2XS (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp
  prepare_for_nxp_xl_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_el_sdio() {
  echo ""
  echo "Setting up for 2EL, 2DL (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp
  prepare_for_nxp_el_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_xk_sdio() {
  echo ""
  echo "Setting up for 1XK, 2XK (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp
  prepare_for_nxp_xk_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_ds_sdio() {
  echo ""
  echo "Setting up for 2DS (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp
  prepare_for_nxp_ds_sdio
  echo "Setup complete."
  echo ""
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}.dtb 2>/dev/null
  # Limiting SDIO frequency to 50MHz
  fw_setenv cmd_custom "fdt set mmc0 max-frequency <50000000>"
  fw_setenv bt_hint nxp_1ym_sdio
  prepare_for_nxp_ym_sdio
  echo "Setup complete."
  echo ""
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}-pcie.dtb 2>/dev/null
  fw_setenv cmd_custom
  fw_setenv bt_hint nxp_1ym_pcie
  prepare_for_nxp_ym_pcie
  echo "Setup complete."
  echo ""
}


function switch_to_nxp_xl_pcie() {
  echo ""
  echo "Setting up for 1XL, 2XS (NXP - PCIe)"
  echo "Please wait for 15 seconds (one-time only)..."
  fw_setenv fdt_file imx6ullea-com-kit_${DTB_VER}-pcie.dtb 2>/dev/null
  fw_setenv bt_hint nxp_1xl_pcie
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
  echo "     CYW-SDIO, CYW-PCIe, 1CX, 1DX, 1LV, 1MW, 1YN, 2AE, 2BC, 1XA, 2BZ, 2EA-SDIO, 2EA-PCIe"
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
