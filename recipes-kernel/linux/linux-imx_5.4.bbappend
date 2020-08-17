# Copyright (C) 2016 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI_append = " file://0002-murata-dts-3.3v.patch \
		   file://0008-kernel_change_for_fmac_log_string.patch \
		   file://0006.patch \
		   file://0009.patch \
		   file://0014.patch \
		   file://0015.patch \
		   file://0016.patch \
		   file://0017.patch \
		   file://0018.patch \
		   file://0019.patch \
		   file://0020.patch \
		   file://0021.patch \
		   file://0022.patch \
		   file://0023.patch \
		   file://0024.patch \
		   file://0025.patch \
		   file://0026.patch \
		   file://0027.patch \
		   file://0029.patch \
		   file://0031.patch \
		   file://0033.patch \
		   file://0035.patch \
		   file://0036.patch \
		   file://0037.patch \
		   file://0038.patch \
		   file://0039.patch \
		   file://0040.patch \
		   file://0041.patch \
		   file://0042.patch \
		   file://0043.patch \
		   file://0044.patch \
		   file://0045.patch \
		   file://0047.patch \
		   file://0048.patch \
		   file://0049.patch \
		   file://0050.patch \
		   file://0051.patch \
		   file://0052.patch \
		   file://0053.patch \
		   file://0054.patch \
		   file://0055.patch \
		   file://0056.patch \
		   file://0057.patch \
		   file://0058.patch \
		   file://0059.patch \
		   file://0060.patch \
		   file://0061.patch \
		   file://0062.patch \
		   file://0063.patch \
		   file://0064.patch \
		   file://0065.patch \
		   file://0066.patch \
		   file://0067.patch \
		   file://0068.patch \
		   file://0069.patch \
		   file://0070.patch \
		   file://0071.patch \
		   file://0072.patch \
		   file://0073.patch \
		   file://0074.patch \
		   file://0075.patch \
		   file://0076.patch \
		   file://0077.patch \
		   file://0078.patch \
		   file://0079.patch \
		   file://0080.patch \
		   file://0081.patch \
		   file://0082.patch \
		   file://0083.patch \
		   file://0084.patch \
		   file://0086.patch \
		   file://0087.patch \
		   file://0088.patch \
		   file://0089.patch \
		   file://0090.patch \
		   file://0091.patch \
		   file://0092.patch \
		   file://0093.patch \
		   file://0094.patch \
		   file://0095.patch \
		   file://0096.patch \
		   file://0097.patch \
		   file://0098.patch \
		   file://0099.patch \
		   file://0100.patch \
		   file://0101.patch \
		   file://0102_include_the_header_for_version.patch "



# addtask copy_defconfig_after_patch after do_patch before do_configure
# do_copy_defconfig_after_patch () {
    # copy latest imx_v7_defconfig to use
    # cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/.config
    # cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/../defconfig
# }
