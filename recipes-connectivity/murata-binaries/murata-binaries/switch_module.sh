#!/bin/sh

# Needed to support writes to otherwise read only memory
#. /etc/profile.d/fw_unlock_mmc.sh 

VERSION="1.0"

function current() {
  echo ""
  echo "Current setup:"
  fw_printenv image
  fw_printenv fdt_file
  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.cyw" ]; then
    echo "Link is to Cypress binary"
  fi
  if [ "/usr/sbin/wpa_supplicant" -ef "/usr/sbin/wpa_supplicant.nxp" ]; then
    echo "Link is to NXP binary"
  fi
  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    echo "Found depmod helper file for NXP"
  fi
  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    echo "Found modprobe helper file for NXP"
  fi
  echo ""
}

function prepare_for_nxp_sdio() {
  if [ -e /usr/sbin/wpa_supplicant ]; then
    rm /usr/sbin/wpa_supplicant
  fi
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

# Alias for the NXP modules
alias sdio:c*v02DFd9149 moal

# Specify arguments to pass when loading the moal module
options moal mod_para=nxp/wifi_mod_para_sd8987.conf
EOT

  depmod -a
}

function prepare_for_nxp_ym_sdio_and_pcie() {
  if [ -e /usr/sbin/wpa_supplicant ]; then
    rm /usr/sbin/wpa_supplicant
  fi
  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant

  # Remove nxp_depmod.conf and nxp_modules.conf as we
  # are creating it for PCIe version.

  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    rm /etc/depmod.d/nxp_depmod.conf
  fi
  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    rm /etc/modprobe.d/nxp_modules.conf
  fi

  cat <<EOT > /etc/depmod.d/nxp_depmod.conf
# Force modprobe to search kernel/net/wireless (where the NXP
# version of cfg80211.ko is placed) before looking in updates/net/wireless/
# (where the Cypress version is)
override cfg80211 * kernel/net/wireless
EOT

  cat <<EOT > /etc/modprobe.d/nxp_modules.conf
# Prevent the Cypress version of cfg80211.ko from being loaded.
blacklist cfg80211
EOT

  depmod -a
}


function prepare_for_cypress() {
  if [ -e /usr/sbin/wpa_supplicant ]; then
    rm /usr/sbin/wpa_supplicant
  fi
  ln -s /usr/sbin/wpa_supplicant.cyw /usr/sbin/wpa_supplicant

  if [ -e /etc/depmod.d/nxp_depmod.conf ]; then
    rm /etc/depmod.d/nxp_depmod.conf
  fi
  if [ -e /etc/modprobe.d/nxp_modules.conf ]; then
    rm /etc/modprobe.d/nxp_modules.conf
  fi

  depmod -a
}

function switch_to_brcm_sdio() {
  echo ""
  echo "Setting up for 1DX, 1LV, 1MW, 1WZ (Cypress - SDIO)"
#  fw_setenv fdt_file imx7dea-com-kit_v2.dtb
  prepare_for_cypress
  echo ""
}

function switch_to_brcm_pcie() {
  echo ""
  echo "Setting up for 1CX, 1VA (Cypress - PCIe)"
#  fw_setenv fdt_file imx7dea-com-kit_v2-pcie.dtb
  prepare_for_cypress
  echo ""
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
#  fw_setenv fdt_file imx7dea-com-kit_v2.dtb
  prepare_for_nxp_sdio
  echo ""
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
#  fw_setenv fdt_file imx7dea-com-kit_v2.dtb
  prepare_for_nxp_ym_sdio_and_pcie
  echo ""
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
#  fw_setenv fdt_file imx7dea-com-kit_v2-pcie.dtb
  prepare_for_nxp_ym_sdio_and_pcie
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
  echo "  <module> is one of CYW-SDIO, CYW-PCIe, 1ZM, 1YM-SDIO, 1YM-PCIe, or current"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

case $1 in
  CYW-PCIE|CYW-PCIe|cyw-pcie)
    switch_to_brcm_pcie
    ;;
  CYW-SDIO|cyw-sdio)
    switch_to_brcm_sdio
    ;;
  zm|1zm|1ZM)
    switch_to_nxp_sdio
    ;;
  ym|1ym|1YM|ym-sdio|1ym-sdio|1YM-SDIO)
    switch_to_nxp_ym_sdio
    ;;
  ym-pcie|1ym-pcie|1YM-PCIe|1YM-PCIE)
    switch_to_nxp_ym_pcie
    ;;
  current|CURRENT)
    current
    ;;
  *)
    current
    usage
    ;;
esac
