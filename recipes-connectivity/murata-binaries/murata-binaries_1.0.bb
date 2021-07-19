SUMMARY = "Murata Binaries"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"
IMX_FIRMWARE_SRC ?= "git://github.com/NXP/imx-firmware.git;protocol=https"

SRC_URI = " \
	git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=master;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
        git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=baragon;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=baragon;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=zeus-baragon;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=baragon;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=baragon;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
	git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git;protocol=http;branch=master \
	file://switch_module_imx6dlea-com.sh \
	file://switch_module_imx6qea-com.sh \
	file://switch_module_imx6sxea-com.sh \
	file://switch_module_imx6ulea-com.sh \
	file://switch_module_imx7dea-com.sh \
	file://switch_module_imx7dea-ucom.sh \
	file://switch_module_imx7ulpea-ucom.sh \
	file://switch_module_imx8mmea-ucom.sh \
	file://switch_module_imx8mnea-ucom.sh \
	file://switch_module_imx8mqea-com.sh \
	file://BCM43439.hcd \
	file://BCM4373.hcd \
	file://cyfmac43439-sdio.clm_blob \
	file://cyfmac43439-sdio.txt \
	file://cyfmac4373-sdio.clm_blob \
	file://cyfmac4373-sdio.txt \
"
SRC_URI += " \
           ${IMX_FIRMWARE_SRC};branch=master;destsuffix=imx-firmware;name=imx-firmware \
"
SRCREV_imx-firmware = "685ace656284167376241c804827f046b984ce25"

SRCREV_nxp-linux-calibration="6167ece880230ef0dbe26ac796e00360b9a40fa8"
SRCREV_cyw-fmac-fw="749e60c523bc7618bd5ecfa30182431a978d756b"
SRCREV_cyw-fmac-nvram="8710e74e79470f666912c3ccadf1e354d6fb209c"
SRCREV_cyw-bt-patch="4d7aef0c959e8a5c8ad88cd13b4b14b858041d31"
SRCREV_cyw-fmac-utils-imx32="e248804b6ba386fedcd462ddd9394f42f73a17af"
SRCREV_cyw-fmac-utils-imx64="1bc78d68f9609290b2f6578516011c57691f7815"

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
        install -m 444 ${S}/cyw-bt-patch/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/BCM4335C0.ZP.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4345C0_003.001.025.0172.0344.1MW.hcd ${D}${sysconfdir}/firmware/BCM4345C0_003.001.025.0172.0344.1MW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43012C0_003.001.015.0230.0237.1LV.sAnt.hcd ${D}${sysconfdir}/firmware/BCM43012C0_003.001.015.0230.0237.1LV.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/BCM43341B0.1BW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4343A1_001.002.009.0153.0520.1DX.hcd ${D}${sysconfdir}/firmware/BCM4343A1_001.002.009.0153.0520.1DX.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4350C0.1BB.hcd ${D}${sysconfdir}/firmware/BCM4350C0.1BB.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd ${D}${sysconfdir}/firmware/BCM4356A2_001.003.015.0112.0410.1CX.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0223.0231.1XA.sAnt.hcd ${D}${sysconfdir}/firmware/BCM4359D0_004.001.016.0223.0231.1XA.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}${sysconfdir}/firmware

#       install -m 444 ${D}${sysconfdir}/firmware/*.hcd       ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${S}/cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}${sysconfdir}/firmware/murata-master/_BCM4335C0.ZP.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4345C0_003.001.025.0172.0344.1MW.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4345C0_003.001.025.0172.0344.1MW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43012C0_003.001.015.0230.0237.1LV.sAnt.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43012C0_003.001.015.0230.0237.1LV.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43341B0.1BW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4343A1_001.002.009.0153.0520.1DX.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM4343A1_001.002.009.0153.0520.1DX.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4350C0.1BB.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4356A2_001.003.015.0112.0410.1CX.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0223.0231.1XA.sAnt.hcd ${D}${sysconfdir}/firmware/murata-master/_BCM4359D0_004.001.016.0223.0231.1XA.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}${sysconfdir}/firmware/murata-master


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

#	install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob
	
#	Using the one shared by Scott
	install -m 755 ${S}/cyfmac4373-sdio.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.txt
	install -m 755 ${S}/cyfmac4373-sdio.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob
	install -m 755 ${S}/cyfmac43439-sdio.txt ${D}/lib/firmware/cypress/cyfmac43439-sdio.txt
	install -m 755 ${S}/cyfmac43439-sdio.clm_blob ${D}/lib/firmware/cypress/cyfmac43439-sdio.clm_blob

	install -m 444 ${S}/cyw-fmac-fw/README_CLM_BLOB.txt ${D}/lib/firmware/cypress/README_CLM_BLOB.txt
	install -m 444 ${S}/cyw-fmac-fw/README_FW.txt ${D}/lib/firmware/cypress/README_FW.txt

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
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac54591-pcie.1XA.txt ${D}/lib/firmware/cypress/cyfmac54591-pcie.txt

	install -m 444 ${S}/cyw-fmac-nvram/README_NVRAM.txt ${D}/lib/firmware/cypress

	# Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules
	# Added by vkjb
	install -d ${D}/lib/firmware/nxp

#       Copying wl tool binary to /usr/sbin
	if [ ${DO_INSTALL_64BIT_BINARIES} = "yes" ]; then
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

#	Install nxp linux calibration files
	install -d ${D}/lib/firmware/nxp/1ZM
	install -d ${D}/lib/firmware/nxp/1YM

	install -m 444 ${S}/nxp-linux-calibration/1ZM/bt_power_config_1.sh ${D}/lib/firmware/nxp/1ZM/bt_power_config_1.sh.1zm
	install -m 444 ${S}/nxp-linux-calibration/1ZM/db.txt               ${D}/lib/firmware/nxp/1ZM/db.txt.1zm
	install -m 444 ${S}/nxp-linux-calibration/1ZM/ed_mac.bin           ${D}/lib/firmware/nxp/1ZM/ed_mac.bin.1zm
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_CA.bin       ${D}/lib/firmware/nxp/1ZM/txpower_CA.bin.1zm
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_EU.bin       ${D}/lib/firmware/nxp/1ZM/txpower_EU.bin.1zm     
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_JP.bin       ${D}/lib/firmware/nxp/1ZM/txpower_JP.bin.1zm  
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_US.bin       ${D}/lib/firmware/nxp/1ZM/txpower_US.bin.1zm

	install -m 444 ${S}/nxp-linux-calibration/1YM/bt_power_config_1.sh ${D}/lib/firmware/nxp/1YM/bt_power_config_1.sh.1ym
	install -m 444 ${S}/nxp-linux-calibration/1YM/db.txt               ${D}/lib/firmware/nxp/1YM/db.txt.1ym
	install -m 444 ${S}/nxp-linux-calibration/1YM/ed_mac.bin           ${D}/lib/firmware/nxp/1YM/ed_mac.bin.1ym
	install -m 444 ${S}/nxp-linux-calibration/1YM/txpower_CA.bin       ${D}/lib/firmware/nxp/1YM/txpower_CA.bin.1ym
	install -m 444 ${S}/nxp-linux-calibration/1YM/txpower_EU.bin       ${D}/lib/firmware/nxp/1YM/txpower_EU.bin.1ym     
	install -m 444 ${S}/nxp-linux-calibration/1YM/txpower_JP.bin       ${D}/lib/firmware/nxp/1YM/txpower_JP.bin.1ym  
	install -m 444 ${S}/nxp-linux-calibration/1YM/txpower_US.bin       ${D}/lib/firmware/nxp/1YM/txpower_US.bin.1ym

# 	Default regulatory files points to 1ZM
	install -m 444 ${S}/nxp-linux-calibration/1ZM/bt_power_config_1.sh ${D}/lib/firmware/nxp/bt_power_config_1.sh
	install -m 444 ${S}/nxp-linux-calibration/1ZM/db.txt               ${D}/lib/firmware/nxp/db.txt
	install -m 444 ${S}/nxp-linux-calibration/1ZM/ed_mac.bin           ${D}/lib/firmware/nxp/ed_mac.bin
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_CA.bin       ${D}/lib/firmware/nxp/txpower_CA.bin
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_EU.bin       ${D}/lib/firmware/nxp/txpower_EU.bin
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_JP.bin       ${D}/lib/firmware/nxp/txpower_JP.bin
	install -m 444 ${S}/nxp-linux-calibration/1ZM/txpower_US.bin       ${D}/lib/firmware/nxp/txpower_US.bin

#	Based on MACHINE type
	echo "DEBUG:: MACHINE TYPE :: ${MACHINE}"
	case ${MACHINE} in
	  imx6dlea-com)
		install -m 755 ${S}/switch_module_imx6dlea-com.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx6qea-com)
		install -m 755 ${S}/switch_module_imx6qea-com.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx6sxea-com)
		install -m 755 ${S}/switch_module_imx6sxea-com.sh ${D}/usr/sbin/switch_module.sh
		;;
 	  imx6ulea-com)
		install -m 755 ${S}/switch_module_imx6ulea-com.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx7dea-com)
		install -m 755 ${S}/switch_module_imx7dea-com.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx7dea-ucom)
		install -m 755 ${S}/switch_module_imx7dea-ucom.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx7ulpea-ucom)
		install -m 755 ${S}/switch_module_imx7ulpea-ucom.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mmea-ucom)
		install -m 755 ${S}/switch_module_imx8mmea-ucom.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mnea-ucom)
		install -m 755 ${S}/switch_module_imx8mnea-ucom.sh ${D}/usr/sbin/switch_module.sh
		;;
	  imx8mqea-com)
		install -m 755 ${S}/switch_module_imx8mqea-com.sh ${D}/usr/sbin/switch_module.sh
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

