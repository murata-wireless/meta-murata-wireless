#!/bin/sh

# Needed to support writes to otherwise read only memory

VERSION="1.0"

function current() {
  echo ""
  echo "Current setup:"
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

  # Take a backup of mlan.ko and moal.ko
  if [ -e /lib/modules/$(uname -r)/extra/mlan.ko ]; then
     rm /lib/modules/$(uname -r)/extra/mlan.ko
  fi
  
  if [ -e /lib/modules/$(uname -r)/extra/moal.ko ]; then
     rm /lib/modules/$(uname -r)/extra/moal.ko
  fi

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
  
  if [ -L /lib/modules/$(uname -r)/extra/moal.ko ]; then
    rm /lib/modules/$(uname -r)/extra/moal.ko
  fi

# clean up nxp regulatory files
  if [ -e /lib/firmware/nxp/txpower_CA.bin ]; then
    rm /lib/firmware/nxp/txpower_CA.bin
  fi

  if [ -e /lib/firmware/nxp/txpower_EU.bin ]; then
    rm /lib/firmware/nxp/txpower_EU.bin
  fi

  if [ -e /lib/firmware/nxp/txpower_JP.bin ]; then
    rm /lib/firmware/nxp/txpower_JP.bin
  fi

  if [ -e /lib/firmware/nxp/txpower_US.bin ]; then
    rm /lib/firmware/nxp/txpower_US.bin
  fi

  if [ -e /lib/firmware/nxp/db.txt ]; then
    rm /lib/firmware/nxp/db.txt
  fi

  if [ -e /lib/firmware/nxp/ed_mac.bin ]; then
    rm /lib/firmware/nxp/ed_mac.bin
  fi

  if [ -e /lib/firmware/nxp/bt_power_config_1.sh ]; then
    rm /lib/firmware/nxp/bt_power_config_1.sh
  fi
}



function prepare_for_nxp_sdio() {

  clean_up

  # revert from backup to default
  cp /usr/share/nxp_wireless/default/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  cp /usr/share/nxp_wireless/default/moal.ko /lib/modules/$(uname -r)/extra/moal.ko

  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant

  cp /lib/firmware/nxp/1ZM/db.txt.1zm 		/lib/firmware/nxp/db.txt
  cp /lib/firmware/nxp/1ZM/ed_mac.bin.1zm 	/lib/firmware/nxp/ed_mac.bin
  cp /lib/firmware/nxp/1ZM/bt_power_config_1.sh.1zm  /lib/firmware/nxp/bt_power_config_1.sh
  cp /lib/firmware/nxp/1ZM/txpower_CA.bin.1zm	/lib/firmware/nxp/txpower_CA.bin
  cp /lib/firmware/nxp/1ZM/txpower_EU.bin.1zm 	/lib/firmware/nxp/txpower_EU.bin
  cp /lib/firmware/nxp/1ZM/txpower_JP.bin.1zm 	/lib/firmware/nxp/txpower_JP.bin
  cp /lib/firmware/nxp/1ZM/txpower_US.bin.1zm 	/lib/firmware/nxp/txpower_US.bin


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

function prepare_for_nxp_1xk_sdio() {
  clean_up

  # copy from bin_sdio_1xk to original
  cp /usr/share/nxp_wireless/bin_sdio_1xk/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  cp /usr/share/nxp_wireless/bin_sdio_1xk/moal.ko /lib/modules/$(uname -r)/extra/moal.ko

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
options moal fw_name=nxp/sdiouart8978_combo_v0.bin cfg80211_wext=0xf drv_mode=7 cal_data_cfg=none 
EOT

  depmod -a
}


function prepare_for_nxp_ym_sdio() {
  clean_up

  # revert from backup to default
  cp /usr/share/nxp_wireless/default/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  cp /usr/share/nxp_wireless/default/moal.ko /lib/modules/$(uname -r)/extra/moal.ko

  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant

  cp /lib/firmware/nxp/1YM/db.txt.1ym 		/lib/firmware/nxp/db.txt
  cp /lib/firmware/nxp/1YM/ed_mac.bin.1ym 	/lib/firmware/nxp/ed_mac.bin
  cp /lib/firmware/nxp/1YM/bt_power_config_1.sh.1ym  /lib/firmware/nxp/bt_power_config_1.sh
  cp /lib/firmware/nxp/1YM/txpower_CA.bin.1ym	/lib/firmware/nxp/txpower_CA.bin
  cp /lib/firmware/nxp/1YM/txpower_EU.bin.1ym 	/lib/firmware/nxp/txpower_EU.bin
  cp /lib/firmware/nxp/1YM/txpower_JP.bin.1ym 	/lib/firmware/nxp/txpower_JP.bin
  cp /lib/firmware/nxp/1YM/txpower_US.bin.1ym 	/lib/firmware/nxp/txpower_US.bin

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

  # revert from backup to default
  cp /usr/share/nxp_wireless/default/mlan.ko /lib/modules/$(uname -r)/extra/mlan.ko
  cp /usr/share/nxp_wireless/default/moal.ko /lib/modules/$(uname -r)/extra/moal.ko

  ln -s /usr/sbin/wpa_supplicant.nxp /usr/sbin/wpa_supplicant

  cp /lib/firmware/nxp/1YM/db.txt.1ym 		/lib/firmware/nxp/db.txt
  cp /lib/firmware/nxp/1YM/ed_mac.bin.1ym 	/lib/firmware/nxp/ed_mac.bin
  cp /lib/firmware/nxp/1YM/bt_power_config_1.sh.1ym  /lib/firmware/nxp/bt_power_config_1.sh
  cp /lib/firmware/nxp/1YM/txpower_CA.bin.1ym	/lib/firmware/nxp/txpower_CA.bin
  cp /lib/firmware/nxp/1YM/txpower_EU.bin.1ym 	/lib/firmware/nxp/txpower_EU.bin
  cp /lib/firmware/nxp/1YM/txpower_JP.bin.1ym 	/lib/firmware/nxp/txpower_JP.bin
  cp /lib/firmware/nxp/1YM/txpower_US.bin.1ym 	/lib/firmware/nxp/txpower_US.bin

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

function prepare_for_cypress() {
  clean_up
  ln -s /usr/sbin/wpa_supplicant.cyw /usr/sbin/wpa_supplicant

  depmod -a

  # Disable NXP service and enable Cypress service
#  handle_services false true
}

function off() {
  # Disable both NXP and Cypress services
  handle_services false false
}

function switch_to_cypress() {
  echo ""
  echo "Setting up for Cypress"
  echo "Please wait for 30 sec..."
  prepare_for_cypress
  echo "Setup complete"
}

function switch_to_nxp_sdio() {
  echo ""
  echo "Setting up for 1ZM (NXP - SDIO)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_sdio
  echo ""
  echo "Setup complete"
}

function switch_to_nxp_ym_sdio() {
  echo ""
  echo "Setting up for 1YM (NXP - SDIO)"
  prepare_for_nxp_ym_sdio
  echo ""
  echo "Setup complete"
}

function switch_to_nxp_1xk_sdio() {
  echo ""
  echo "Setting up for 1XK"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_1xk_sdio
  echo ""
  echo "Setup complete"
}


function switch_to_nxp_ym_pcie() {
  echo ""
  echo "Setting up for 1YM (NXP - PCIe)"
  echo "Please wait for 30 sec..."
  prepare_for_nxp_ym_pcie
  echo ""
  echo "Setup complete"
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
  echo "     cyw, 1zm, 1ym-sdio, 1ym-pcie, 1xk"
  echo ""
}

# ONE-TIME Only
#check for the presence of default driver
#if not , create and store default (mlan.ko and moal.ko)
# check for the existence of folder, "default"
if [ ! -d "/usr/share/nxp_wireless/default" ]
then
#	echo "Directory /usr/share/nxp_wireless/default does not exist."
#	echo "Creating default in /usr/share/nxp_wireless/"
	mkdir /usr/share/nxp_wireless/default
	# Copy mlan.ko and moal.ko
	cp /lib/modules/$(uname -r)/extra/mlan.ko /usr/share/nxp_wireless/default
	cp /lib/modules/$(uname -r)/extra/moal.ko /usr/share/nxp_wireless/default
fi


if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

case ${1^^} in
  CYW)
    switch_to_cypress
    ;;
  ZM|1ZM)
    switch_to_nxp_sdio
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
  *)
    current
    usage
    ;;
esac
