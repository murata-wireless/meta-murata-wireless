SUMMARY = "Murata Binaries"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"
IMX_FIRMWARE_SRC ?= "git://github.com/NXP/imx-firmware.git;protocol=https"

SRC_URI = " \
	git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=zigra;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
	git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=zigra;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
	git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=zeus-zigra;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
	git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=zigra;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
	git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=zigra;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
	git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git;protocol=http;branch=master \
	file://WlanCalData_ext_DB_W8997_1YM_ES2_Rev_C.conf \
	file://fw_unlock_mmc.sh \
	file://switch_module_imx6ull14x14evk.sh \
	file://switch_module_imx6ulevk.sh \
	file://switch_module_imx6sxsabresd.sh \
	file://switch_module_imx6qsabresd.sh \
	file://switch_module_imx6dlsabresd.sh \
	file://switch_module_imx8mmevk.sh \
	file://switch_module_imx8mnevk.sh \
	file://switch_module_imx8mqevk.sh \
	file://switch_module.sh \
"
SRC_URI += " \
           ${IMX_FIRMWARE_SRC};branch=master;destsuffix=imx-firmware;name=imx-firmware \
"
SRCREV_imx-firmware = "685ace656284167376241c804827f046b984ce25"


SRCREV_cyw-fmac-fw="52174a18134c7ef4a674ecd9fb68fc6e2bced969"
SRCREV_cyw-fmac-nvram="45fe43ad51ad47a0c57ad307db3e87da766bf61e"
SRCREV_cyw-bt-patch="c5f1b13697d4ac8eec2cb6f21636085fbb55acd1"
SRCREV_cyw-fmac-utils-imx32="864ccb4529dc02d28d15fa2ace594fa7023e78d7"
SRCREV_cyw-fmac-utils-imx64="ae90650692a93c87b4c38e09780987be101359a8"

SRCREV_default = "${AUTOREV}"


S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " libnl wpa-supplicant cyw-supplicant linux-firmware"

do_compile () {
	echo "Compiling: "
        echo "Testing Make        Display:: ${MAKE}"
        echo "Testing bindir      Display:: ${bindir}"
        echo "Testing base_libdir Display:: ${base_libdir}"
        echo "Testing sysconfdir  Display:: ${sysconfdir}"
        echo "Testing S  Display:: ${S}"
        echo "Testing B  Display:: ${B}"
        echo "Testing D  Display:: ${D}"
        echo "WORK_DIR :: ${WORKDIR}"
	echo "MACHINE TYPE :: ${MACHINE}"
        echo "PWD :: "
        pwd
}

PACKAGES_prepend = "murata-binaries-wlarm "
FILES_murata-binaries-wlarm = "${bindir}/wlarm"

DO_INSTALL_64BIT_BINARIES = "no"
DO_INSTALL_64BIT_BINARIES_mx6 = "no"
DO_INSTALL_64BIT_BINARIES_mx7 = "no"
DO_INSTALL_64BIT_BINARIES_mx8 = "yes"

do_install () {
	echo "Installing: "
	install -d ${D}/lib/firmware/cypress
	install -d ${D}/lib/firmware/cypress/murata-master
	install -d ${D}/etc/firmware
	install -d ${D}/etc/firmware/murata-master
	install -d ${D}/usr/sbin
	install -d ${D}/etc/udev/rules.d

#       Copying *.HCD files to etc/firmware and etc/firmware/murata-master
        install -m 444 ${S}//cyw-bt-patch/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/BCM4335C0.ZP.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4345C0_003.001.025.0144.0266.1MW.hcd ${D}${sysconfdir}/firmware/BCM4345C0_003.001.025.0144.0266.1MW.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM43012C0_003.001.015.0102.0141.1LV.hcd ${D}${sysconfdir}/firmware/BCM43012C0_003.001.015.0102.0141.1LV.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/BCM43341B0.1BW.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4343A1_001.002.009.0093.0395.1DX.hcd ${D}${sysconfdir}/firmware/BCM43430A1_001.002.009.0093.0395.1DX.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4350C0.1BB.hcd ${D}${sysconfdir}/firmware/BCM4350C0.1BB.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4356A2_001.003.015.0106.0403.1CX.hcd ${D}${sysconfdir}/firmware/BCM4354A2_001.003.015.0106.0403.1CX.hcd
	install -m 444 ${S}//cyw-bt-patch/README_BT_PATCHFILE ${D}${sysconfdir}/firmware

#	install -m 444 ${D}${sysconfdir}/firmware/*.hcd       ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${S}//cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}${sysconfdir}/firmware/murata-master/_BCM4335C0.ZP.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4345C0_003.001.025.0144.0266.1MW.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4345C0_003.001.025.0144.0266.1MW.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM43012C0_003.001.015.0102.0141.1LV.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43012C0_003.001.015.0102.0141.1LV.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43341B0.1BW.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4343A1_001.002.009.0093.0395.1DX.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM4343A1_001.002.009.0093.0395.1DX.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4350C0.1BB.hcd
        install -m 444 ${S}//cyw-bt-patch/BCM4356A2_001.003.015.0106.0403.1CX.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4356A2_001.003.015.0106.0403.1CX.hcd
	install -m 444 ${S}//cyw-bt-patch/README_BT_PATCHFILE ${D}${sysconfdir}/firmware/murata-master

#       Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/cypress folder
	install -m 444 ${S}/cyw-fmac-fw/*.bin ${D}/lib/firmware/cypress

#       Rename clm blob files accordingly
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4354-sdio.1BB.clm_blob ${D}/lib/firmware/cypress/cyfmac4354-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4356-pcie.1CX.clm_blob ${D}/lib/firmware/cypress/cyfmac4356-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43012-sdio.1LV.clm_blob ${D}/lib/firmware/cypress/cyfmac43012-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43430-sdio.1DX.clm_blob ${D}/lib/firmware/cypress/cyfmac43430-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43455-sdio.1MW.clm_blob ${D}/lib/firmware/cypress/cyfmac43455-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4359-sdio.clm_blob ${D}/lib/firmware/cypress/cyfmac4359-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4359-sdio.clm_blob ${D}/lib/firmware/cypress/cyfmac4359-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac54591-pcie.clm_blob ${D}/lib/firmware/cypress/cyfmac54591-pcie.clm_blob

#       Copying NVRAM files (*.txt) to lib/firmware/cypress and lib/firmware/cypress/murata-master
	install -m 444 ${S}/cyw-fmac-nvram/*.txt ${D}/lib/firmware/cypress/murata-master

	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4339-sdio.ZP.txt ${D}/lib/firmware/cypress/cyfmac4339-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4354-sdio.1BB.txt ${D}/lib/firmware/cypress/cyfmac4354-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4356-pcie.1CX.txt ${D}/lib/firmware/cypress/cyfmac4356-pcie.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43012-sdio.1LV.txt ${D}/lib/firmware/cypress/cyfmac43012-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43340-sdio.1BW.txt ${D}/lib/firmware/cypress/cyfmac43340-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43362-sdio.SN8000.txt ${D}/lib/firmware/cypress/cyfmac43362-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43430-sdio.1DX.txt ${D}/lib/firmware/cypress/cyfmac43430-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43455-sdio.1MW.txt ${D}/lib/firmware/cypress/cyfmac43455-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/README_NVRAM ${D}/lib/firmware/cypress

	# Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules
	# Added by vkjb
	install -d ${D}/lib/firmware/nxp
    	install -m 0644 ${S}/WlanCalData_ext_DB_W8997_1YM_ES2_Rev_C.conf ${D}/lib/firmware/nxp

#       Copying wl tool binary based on 32-bit/64-bit arch to /usr/sbin
	if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${S}/cyw-fmac-utils-imx64/wl ${D}/usr/sbin/wl
	else
		install -m 755 ${S}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
	fi

	# Added Script file for switching between CYW and NXP
#	install -m 755 ${S}/switch_module_v1.2.sh ${D}/usr/sbin/switch_module_v1.2.sh

	ln -sf /usr/sbin/wpa_supplicant.cyw ${D}${sbindir}/wpa_supplicant

#	Installing 8997 Firmware files
	install -m 0644 ${S}/imx-firmware/nxp/FwImage_8997/pcie8997_wlan_v4.bin ${D}/lib/firmware/nxp
	install -m 0644 ${S}/imx-firmware/nxp/FwImage_8997/pcieuart8997_combo_v4.bin ${D}/lib/firmware/nxp
	install -m 0644 ${S}/git/mrvl/pcieusb8997_combo_v4.bin ${D}/lib/firmware/nxp
	install -m 0644 ${S}/imx-firmware/nxp/FwImage_8997/helper_uart_3000000.bin ${D}/lib/firmware/nxp
	install -m 0644 ${S}/imx-firmware/nxp/FwImage_8997/uart8997_bt_v4.bin ${D}/lib/firmware/nxp

	install -Dm 0644 ${S}/fw_unlock_mmc.sh  ${D}${sysconfdir}/profile.d/fw_unlock_mmc.sh

#	Based on MACHINE type
	echo "DEBUG:: MACHINE TYPE :: ${MACHINE}"
	case ${MACHINE} in
	  imx6ull14x14evk)
		install -m 755 ${S}/switch_module_imx6ull14x14evk.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx6ulevk)
		install -m 755 ${S}/switch_module_imx6ulevk.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx6sxsabresd)
		install -m 755 ${S}/switch_module_imx6sxsabresd.sh ${D}/usr/sbin/switch_module.sh
		;;
 	  imx6qsabresd)
		install -m 755 ${S}/switch_module_imx6qsabresd.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx6dlsabresd)
		install -m 755 ${S}/switch_module_imx6dlsabresd.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mmevk)
		install -m 755 ${S}/switch_module_imx8mmevk.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mnevk)
		install -m 755 ${S}/switch_module_imx8mnevk.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mqevk)
		install -m 755 ${S}/switch_module_imx8mqevk.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx7dsabresd|imx7ulpevk|imx6qpsabresd|imx6slevk|imx8mmddr4evk)
		install -m 755 ${S}/switch_module.sh ${D}/usr/sbin/switch_module.sh
		;;
	esac
}

PACKAGES =+ "${PN}-mfgtest"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
FILES_${PN} += "${bindir}"
FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"
FILES_${PN} += "{sysconfdir}/firmware/nxp"
#FILES_${PN} += "/usr/sbin/wpa_supplicant"

FILES_${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP_${PN} += "build-deps"
INSANE_SKIP_${PN} += "file-rdeps"

