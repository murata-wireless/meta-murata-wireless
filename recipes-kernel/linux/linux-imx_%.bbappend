# Copyright (C) 2016 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0001-patch-indrik-fmac-6-1-36.patch \
		   file://0002-murata-dts.patch \
		   file://0005-murata-disable-cfg-regdb.patch \
		   file://0006-disable-dma-hciuart-kernel-crash.patch \
"



addtask copy_defconfig_after_patch after do_patch before do_configure
do_copy_defconfig_after_patch () {
    # copy latest imx_v7_defconfig to use
    cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/../defconfig
}
