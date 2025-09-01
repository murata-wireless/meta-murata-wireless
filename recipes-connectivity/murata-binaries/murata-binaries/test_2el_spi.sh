#!/bin/sh
VERSION="1.0"

function usage() {
  echo ""
  echo "Version: $VERSION"
  echo ""
  echo "Usage:"
  echo "  $0 [on/off]"
  echo "     on: Download firmware (default)"
  echo "     off: Skip Downloading firmware"
}

function get_devkit() {
  local devkit=""
  model=$(tr -d '\0' </proc/device-tree/model)
  if [[ $model == *'i.MX8MM SOM'* ]]; then
    devkit="8mmsom"
  elif [[ $model == *'i.MX8MM'* ]]; then
    devkit="8mm"
  elif [[ $model == *'i.MX8M Nano'* ]]; then
    devkit="8mn"
  elif [[ $model == *'i.MX93'* ]]; then
    devkit="93"
  else
    devkit=$model
  fi
  echo $devkit
}


#echo "DEBUG:: $#"
#echo "DEBUG:: $1"

if [[ $# -eq 1 ]]; then
  if [[ "$1" == "on" ]]; then
    fw_download=true
  elif [[ "$1" == "off" ]]; then
    fw_download=false
  else
    usage
    exit 1
  fi
elif [[ $# -ne 0 ]]; then
  usage
  exit 1
else
  fw_download=true
fi

devkit=$(get_devkit)

echo ""
echo "-------------------------------------------------"
echo "Testing SPI on 2EL:"
if [[ $devkit == "8mm" || $devkit == "8mn" ]]; then
  btuart="/dev/ttymxc0"
  bitrate=1000000
  gpio_reset_device="5"
  gpio_reset_line="14"
  gpio_int_device="0"
  gpio_int_line="7"
elif [[ $devkit == "8mmsom" ]]; then
  btuart="/dev/ttymxc0"
  bitrate=1000000  # can go up to 4000000

  # USER_LED_RED on PCAL6524_u6
  gpio_reset_device="5"
  gpio_reset_line="18"

  # M2E_ALERT on PCAL6524_u5
  gpio_int_device="5"
  gpio_int_line="9"
elif [[ $devkit == "93" ]]; then
  btuart="/dev/ttyLP4"
  bitrate=1000000
  gpio_reset_device="4"
  gpio_reset_line="14"
  gpio_int_device="5"
  gpio_int_line="4"
else
  echo "Unknown model $devkit"
  exit 2
fi

if ($fw_download); then
    fw_loader_imx_lnx $btuart 115200 0 /lib/firmware/nxp/uartspi_n61x_v1.bin.se 3000000
fi

i2cset -y 1 0x20 0x03 0xfe
i2cset -y 1 0x20 0x01 0x01
ot-daemon "spinel+spi:///dev/spidev0.0?gpio-reset-device=/dev/gpiochip${gpio_reset_device}&gpio-int-device=/dev/gpiochip${gpio_int_device}&gpio-int-line=${gpio_int_line}&gpio-reset-line=${gpio_reset_line}&spi-mode=0&spi-speed=${bitrate}&spi-reset-delay=500" -d 5 > ot.log 2>&1 &
sleep 2
ot-ctl version
