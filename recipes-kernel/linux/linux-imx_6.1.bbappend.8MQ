# Copyright (C) 2016 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0003-defconfig-imx8.patch \
		   file://0004-murata-dts-imx8.patch \
		   file://0005-murata-disable-cfg-regdb.patch \
		   file://0006-disable-dma-hciuart-kernel-crash.patch \
"

addtask copy_defconfig_after_patch after do_patch before do_configure
do_copy_defconfig_after_patch () {
    # copy latest imx_v8_defconfig to use
    cp ${S}/arch/arm64/configs/imx_v8_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_defconfig ${B}/../defconfig
}
