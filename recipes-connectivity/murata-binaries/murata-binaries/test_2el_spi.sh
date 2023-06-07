#!/bin/sh

echo ""
echo "-------------------------------------------------"
echo "Testing SPI on 2EL:"
fw_loader_imx_lnx /dev/ttyLP4 115200 0 /lib/firmware/nxp/uartspi_n61x_v1.bin.se 3000000
i2cset -y 1 0x20 0x03 0xfe
i2cset -y 1 0x20 0x01 0x01
ot-daemon "spinel+spi:///dev/spidev0.0?gpio-reset-device=/dev/gpiochip4&gpio-int-device=/dev/gpiochip5&gpio-int-line=4&gpio-reset-line=14&spi-mode=0&spi-speed=1000000&spi-reset-delay=500" -d 5 > ot.log 2>&1 &
sleep 2
ot-ctl version
