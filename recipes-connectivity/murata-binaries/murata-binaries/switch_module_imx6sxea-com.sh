#!/bin/sh

# Needed to support writes to otherwise read only memory
. /etc/profile.d/fw_unlock_mmc.sh 

VERSION="1.0"

function current() {
  echo ""
  echo "Current setup:"
  fw_printenv fdt_file
  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.cyw" ]; then
    echo "  Link is to Cypress binary"
  fi
  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.nxp" ]; then
    echo "  Link is to NXP binary"
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

function handle_services() {
  enable_mlan0=$1
  enable_wlan0=$2

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
}

function clean_up() {
  if [ -e /usr/sbin/wpa_supplicant ]; then
    rm /usr/sbin/wpa_supplicant
  fi

  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    rm /etc/depmod.d/nxp_depmod.conf
  fi

  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    rm /etc/modprobe.d/nxp_modules.conf
  fi

  if [ -L /lib/modules/$(uname -r)/extra/mlan.ko ]; then
    rm /lib/modules/$(uname -r)/extra/mlan.ko
  fi
  
  if [ -L /lib/modules/$(uname -r)/extra/sd8997.ko ]; then
    rm /lib/modules/$(uname -r)/extra/sd8997.ko
  fi
  
  if [ -L /lib/modules/$(uname -r)/extra/pcie8997.ko ]; then
    rm /lib/modules/$(uname -r)/extra/pcie8997.ko
  fi  
}



function prepare_for_nxp_sdio() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant

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
options moal mod_para=nxp/wifi_mod_para_sd8987.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_nxp_ym_sdio() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/share/nxp_wireless/bin_sd8997/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  ln -s /usr/share/nxp_wireless/bin_sd8997/sd8997.ko /lib/modules/$(uname -r)/extra/sd8997.ko

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

# Force modprobe to search "extra" (where the NXP
# version of mlan.ko for SD8997 is placed) before looking in mxmwiflex
# (where the 1ZM-SD8987 version is)
override mlan * extra
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the NXP modules(1YM-SDIO)
alias sdio:c*v02DFd9141* sd8997

# Specify arguments to pass when loading the sd8997 module
options sd8997 fw_name=nxp/sdsd8997_combo_v4.bin cal_data_cfg=nxp/WlanCalData_ext_DB_W8997_1YM_ES2_Rev_C.conf cfg80211_wext=0xf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}


function prepare_for_nxp_ym_pcie() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant
  ln -s /usr/share/nxp_wireless/bin_pcie8997/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  ln -s /usr/share/nxp_wireless/bin_pcie8997/pcie8997.ko /lib/modules/$(uname -r)/extra/pcie8997.ko

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless

# Force modprobe to search "extra" (where the NXP
# version of mlan.ko for PCIe-8997 is placed) before looking in mxmwiflex
# (where the 1ZM-SD8987 version is)
override mlan * extra
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211

# Alias for the 1YM-PCIe M.2 module
alias pci:v00001B4Bd00002B42sv*sd*bc02sc00i* pcie8997

# Specify arguments to pass when loading the pcie8997 module
options pcie8997 drv_mode=3 ps_mode=2 auto_ds=2 cfg80211_wext=0xf fw_name=nxp/pcieuart8997_combo_v4.bin cal_data_cfg=nxp/WlanCalData_ext_DB_W8997_1YM_ES2_Rev_C.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
  handle_services true false
}

function prepare_for_cypress() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.cyw /usr/sbin/wpa_supplicant

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
  echo "Setting up for 1DX, 1LV, 1MW, 1WZ (Cypress - SDIO)"
  fw_setenv fdt_file imx6sxea-com-kit_v2.dtb
  fw_setenv bt_hint cypress
  prepare_for_cypress
  echo ""
}

function switch_to_cypress_pcie() {
  echo ""
  echo "Setting up for 1CX, 1VA, 1XA (Cypress - PCIe)"
  fw_setenv fdt_file imx6sxea-com-kit_v2-pcie.dtb
  fw_setenv bt_hint cypress
  prepare_for_cypress
  echo ""
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
  fw_setenv fdt_file imx6sxea-com-kit_v2.dtb
  fw_setenv bt_hint nxp
  prepare_for_nxp_sdio
  echo ""
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
  fw_setenv fdt_file imx6sxea-com-kit_v2.dtb
  fw_setenv bt_hint nxp_1ym_sdio
  prepare_for_nxp_ym_sdio
  echo ""
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
  fw_setenv fdt_file imx6sxea-com-kit_v2-pcie.dtb
  fw_setenv bt_hint nxp_1ym_pcie
  prepare_for_nxp_ym_pcie
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
  echo "     CYW-SDIO, CYW-PCIe, 1CX, 1DX, 1LV, 1MW, 1XA, 1ZM, 1WZ"
  echo "     1YM-SDIO, 1YM-PCIe, CURRENT or OFF"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

case ${1^^} in
  CYW-PCIE|CX|1CX|XA|1XA)
    switch_to_cypress_pcie
    ;;
  CYW-SDIO|LV|1LV|DX|1DX|MW|1MW|WZ|1WZ)
    switch_to_cypress_sdio
    ;;
  ZM|1ZM)
    switch_to_nxp_sdio
    ;;
  YM-SDIO|1YM-SDIO)
    switch_to_nxp_ym_sdio
    ;;
  YM-PCIE|1YM-PCIE)
    switch_to_nxp_ym_pcie
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
