#!/bin/sh

# Switch between 2BC (default) and 2AE.

VERSION="1.0"

cyw_module="none"

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
}


function switch_to_cypress() {
  echo ""
  prepare_for_cypress
}



function usage() {
  echo ""
  echo "Version: $VERSION"
  echo "Purpose: Sets corresponding NVRAM, CLM_BLOB and Firmware for the specified module (2AE / 2BC)."
  echo ""
  echo "Usage:"
  echo "  $0  <module>"
  echo ""
  echo "Where:"
  echo "  <module> is one of :"
  echo "     2AE, 2BC"
  echo ""
}

if [[ $# -eq 0 ]]; then
  current
  usage
  exit 1
fi

cyw_module=${1^^}

case ${1^^} in
  2AE|2BC)
    switch_to_cypress
    ;;
  *)
    current
    usage
    ;;
esac
