#!/bin/sh

# Needed to support writes to otherwise read only memory

VERSION="1.0"

function current() {
  echo ""
  echo "Current setup:"
  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    echo "  Found depmod helper file for NXP"
  fi
  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    echo "  Found modprobe helper file for NXP"
  fi
#  echo "  wpa_supplicant@mlan0 is `systemctl is-enabled wpa_supplicant@mlan0`"
#  echo "  wpa_supplicant@wlan0 is `systemctl is-enabled wpa_supplicant@wlan0`"
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
}

function prepare_for_nxp_sdio() {
  clean_up

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
#  handle_services true false
}

function prepare_for_nxp_ds_sdio() {
  clean_up

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
#  handle_services true false
}


function prepare_for_nxp_1xk_sdio() {
  clean_up

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
alias sdio:c*v02DFd9159 moal

# Specify arguments to pass when loading the moal module
options moal mod_para=nxp/wifi_mod_para.conf 
EOT

  depmod -a
}


function prepare_for_nxp_ym_sdio() {
  clean_up

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
#  handle_services true false
}


function prepare_for_nxp_ym_pcie() {
  clean_up

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
alias pci:v00001B4Bd00002B42sv*sd*bc02sc00i* pcie8997

# Specify arguments to pass when loading the pcie8997 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
#  handle_services true false
}

function prepare_for_nxp_xl_pcie() {
  clean_up

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

# Specify arguments to pass when loading the pcie8997 module
options moal mod_para=nxp/wifi_mod_para.conf
EOT

  depmod -a

  # Disable Cypress service and enable NXP service
#  handle_services true false
}

function off() {
  # Disable both NXP and Cypress services
  handle_services false false
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_sdio
  echo ""
  echo "Setup complete."
  echo "Please reboot."
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_ym_sdio
  echo ""
  echo "Setup complete."
  echo "Please reboot."
}

function switch_to_nxp_1xk_sdio() {
  echo ""
  echo "Setting up for 1XK"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_1xk_sdio
  echo ""
  echo "Setup complete."
  echo "Please reboot."
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_ym_pcie
  echo ""
  echo "Setup complete."
  echo "Please reboot."
}

function switch_to_nxp_xl_pcie() {
  echo ""
  echo "Setting up for 1XL (NXP - PCIe)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_xl_pcie
  echo ""
  echo "Setup complete."
  echo "Please reboot."
}

function switch_to_nxp_ds_sdio() {
  echo ""
  echo "Setting up for 2DS (NXP - SDIO)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_ds_sdio
  echo "Setup complete."
  echo "Please reboot."
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
  echo "  <module> is one of :"
  echo "     1zm, 1ym-sdio, 1ym-pcie, 1xk, 1xl, 2ds"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

case ${1^^} in
  ZM|1ZM)
    switch_to_nxp_sdio
    ;;
  DS|2DS)
    switch_to_nxp_ds_sdio
    ;;
  1YM|YM-SDIO|1YM-SDIO)
    switch_to_nxp_ym_sdio
    ;;
  1XK)
    switch_to_nxp_1xk_sdio
    ;;
  YM-PCIE|1YM-PCIE)
    switch_to_nxp_ym_pcie
    ;;
  XL-PCIE|1XL-PCIE)
    switch_to_nxp_xl_pcie
    ;;
  *)
    current
    usage
    ;;
esac
