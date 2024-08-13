SUMMARY = "Murata Binaries"
LICENSE = "BSD-3-Clause"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

SRC_URI = " \
	git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=imx-5-15-32;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
        git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=indrik;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=indrik;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=master;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
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
	file://WlanCalData_ext_2ANT_Dedicated_BT_1XK.conf \
	file://cyfmac55572-pcie.txt \
        file://cyfmac55572-sdio.txt \
        file://cyfmac55572-sdio-ifx-demo.txt \
        file://cyfmac55572-sdio_v2.4.3.txt \
        file://cyfmac55572-sdio_v2.5.1.txt \
        file://cyfmac55572-sdio-ifx-demo.txt \
	file://CYW55560A1_001.002.087.0108.0000.sLNA.hcd \
        file://CYW55560A1_001.002.087.0159.0010_wlcsp_iPA_sLNA_ANT0_Murata_Type2EA_FCC_max.hcd \
	file://uartspi_n61x_v1.bin.se \
	file://sduart_nw61x_v1.bin.se \
	file://ot-daemon.64-bit \
	file://ot-ctl.64-bit \
	file://fw_loader_imx_lnx.64-bit \
	file://ot-daemon.32-bit \
	file://ot-ctl.32-bit \
	file://WlanCalData_ext.conf \
"

SRCREV_nxp-linux-calibration="a33c54c01be8ec8bef7ffbdb61459fbdc2486b0a"
SRCREV_cyw-fmac-fw="d6cd8b50b5f71ca3ba26fd88177676a688aac85b"
SRCREV_cyw-fmac-nvram="61b41349b5aa95227b4d2562e0d0a06ca97a6959"
SRCREV_cyw-bt-patch="2587983777342ed18e6389aa30546bb5fe3aee59"
SRCREV_cyw-fmac-utils-imx32="fcdd231e9bb23db3c93c10e5dff43a1182f220c5"
SRCREV_cyw-fmac-utils-imx64="52cc4cc6be8629781014505aa276b67e18cf6e8d"

SRCREV_default = "${AUTOREV}"

S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " libnl wpa-supplicant cyw-supplicant"

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

PACKAGES:prepend = "murata-binaries-wlarm "
FILES:murata-binaries-wlarm = "${bindir}/wlarm"

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

        # Install /lib/firmware/nxp folder
        install -d ${D}/lib/firmware/nxp
        install -d ${D}/lib/firmware/nxp/murata
        install -d ${D}/lib/firmware/nxp/murata/files
	install -d ${D}/lib/firmware/nxp/murata/files/1XK
        install -d ${D}/lib/firmware/nxp/murata/files/1ZM
        install -d ${D}/lib/firmware/nxp/murata/files/1YM
        install -d ${D}/lib/firmware/nxp/murata/files/2DS
        install -d ${D}/lib/firmware/nxp/murata/files/32_bit
        install -d ${D}/lib/firmware/nxp/murata/files/64_bit


#       Copying *.HCD files to etc/firmware and etc/firmware/murata-master (using "_" before the name of the file in murata-master)
        install -m 444 ${S}/cyw-bt-patch/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/BCM4335C0.ZP.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd ${D}${sysconfdir}/firmware/BCM4345C0_003.001.025.0187.0366.1MW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd ${D}${sysconfdir}/firmware/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
        install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43012C1_003.002.024.0034.0004.2GF.hcd ${D}/${base_libdir}/firmware/brcm/CYW43012C1_003.002.024.0034.0004.2GF.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/BCM43341B0.1BW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd ${D}${sysconfdir}/firmware/BCM43430A1_001.002.009.0159.0528.1DX.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4350C0.1BB.hcd ${D}${sysconfdir}/firmware/BCM4350C0.1BB.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd ${D}${sysconfdir}/firmware/BCM4356A2_001.003.015.0112.0410.1CX.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}${sysconfdir}/firmware/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4373A0.2AE.hcd ${D}${sysconfdir}/firmware/BCM4373A0.2AE.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4373A0.2AE.hcd ${D}${sysconfdir}/firmware/BCM4373A0.2BC.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}${sysconfdir}/firmware/CYW4343A2_001.003.016.0031.0000.1YN.hcd
        install -m 444 ${S}/CYW55560A1_001.002.087.0108.0000.sLNA.hcd ${D}${sysconfdir}/firmware/CYW55560A1_001.002.087.0108.0000.sLNA.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}${sysconfdir}/firmware/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}${sysconfdir}/firmware

#       install -m 444 ${D}${sysconfdir}/firmware/*.hcd       ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${S}/cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}${sysconfdir}/firmware/murata-master/_BCM4335C0.ZP.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4345C0_003.001.025.0187.0366.1MW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd ${D}${sysconfdir}/firmware/murata-master/_BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd
        install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43012C1_003.002.024.0034.0004.2GF.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_CYW43012C1_003.002.024.0034.0004.2GF.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43341B0.1BW.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43430A1_001.002.009.0159.0528.1DX.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4350C0.1BB.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4356A2_001.003.015.0112.0410.1CX.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}${sysconfdir}/firmware/murata-master/_BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
	install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd ${D}${sysconfdir}/firmware/murata-master/_BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4373A0.2AE.hcd ${D}${sysconfdir}/firmware/_BCM4373A0.2AE.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4373A0.2BC.hcd ${D}${sysconfdir}/firmware/_BCM4373A0.2BC.hcd
        install -m 444 ${S}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}${sysconfdir}/firmware/_CYW4343A2_001.003.016.0031.0000.1YN.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}${sysconfdir}/firmware/_BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
        install -m 444 ${S}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd ${D}${sysconfdir}/firmware/_BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd

#	Temporary from MMW
	install -m 444 ${S}/CYW55560A1_001.002.087.0108.0000.sLNA.hcd ${D}${sysconfdir}/firmware/_CYW55560A1_001.002.087.0108.0000.sLNA.hcd
        install -m 444 ${S}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}${sysconfdir}/firmware/murata-master


#       Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/cypress folder
	install -m 444 ${S}/cyw-fmac-fw/*.bin ${D}/lib/firmware/cypress
	install -m 444 ${S}/cyw-fmac-fw/cyfmac55572-pcie.trxse ${D}/lib/firmware/cypress
        install -m 444 ${S}/cyw-fmac-fw/cyfmac55572-sdio.trxse ${D}/lib/firmware/cypress
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2AE.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.bin
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.bin

#       Rename clm blob files accordingly
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4354-sdio.1BB.clm_blob ${D}/lib/firmware/cypress/cyfmac4354-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4356-pcie.1CX.clm_blob ${D}/lib/firmware/cypress/cyfmac4356-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43012-sdio.1LV.clm_blob ${D}/lib/firmware/cypress/cyfmac43012-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43022-sdio.2GF.STA.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac43022-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43430-sdio.1DX.clm_blob ${D}/lib/firmware/cypress/cyfmac43430-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43455-sdio.1MW.clm_blob ${D}/lib/firmware/cypress/cyfmac43455-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4359-sdio.1WZ.clm_blob ${D}/lib/firmware/cypress/cyfmac4359-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac54591-pcie.1XA.clm_blob ${D}/lib/firmware/cypress/cyfmac54591-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac54591-sdio.2BZ.clm_blob ${D}/lib/firmware/cypress/cyfmac54591-sdio.clm_blob

# 	For 2AE and 1YN
	install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/cyfmac43439-sdio.1YN.clm_blob  ${D}/lib/firmware/cypress/cyfmac43439-sdio.clm_blob 

#       For 2EA
        install -m 444 ${S}/cyw-fmac-fw/cyfmac55572-sdio.2EA.clm_blob  ${D}/lib/firmware/cypress/cyfmac55572-sdio.clm_blob
        install -m 444 ${S}/cyw-fmac-fw/cyfmac55572-pcie.2EA.clm_blob  ${D}/lib/firmware/cypress/cyfmac55572-pcie.clm_blob

	install -m 444 ${S}/cyw-fmac-fw/README_CLM_BLOB.txt ${D}/lib/firmware/cypress/README_CLM_BLOB.txt
	install -m 444 ${S}/cyw-fmac-fw/README_FW.txt ${D}/lib/firmware/cypress/README_FW.txt

#       Copying NVRAM files (*.txt) to lib/firmware/cypress and lib/firmware/cypress/murata-master
	install -m 444 ${S}/cyw-fmac-nvram/*.txt ${D}/lib/firmware/cypress/murata-master

	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4339-sdio.ZP.txt ${D}/lib/firmware/cypress/cyfmac4339-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4354-sdio.1BB.txt ${D}/lib/firmware/cypress/cyfmac4354-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4356-pcie.1CX.txt ${D}/lib/firmware/cypress/cyfmac4356-pcie.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43012-sdio.1LV.txt ${D}/lib/firmware/cypress/cyfmac43012-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43022-sdio.2GF.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43022-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43340-sdio.1BW.txt ${D}/lib/firmware/cypress/cyfmac43340-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43362-sdio.SN8000.txt ${D}/lib/firmware/cypress/cyfmac43362-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43430-sdio.1DX.txt ${D}/lib/firmware/cypress/cyfmac43430-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43455-sdio.1MW.txt ${D}/lib/firmware/cypress/cyfmac43455-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac54591-pcie.1XA.txt ${D}/lib/firmware/cypress/cyfmac54591-pcie.txt

#	For 2AE, 2BC, and 1YN
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac43439-sdio.1YN.txt ${D}/lib/firmware/cypress/cyfmac43439-sdio.txt

	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4373-sdio.2BC.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.txt
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac4373-sdio.2AE.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.txt

        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.bin
        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2AE.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.bin

        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2BC.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob
        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob


        install -m 444 ${S}/cyw-fmac-nvram/cyfmac4373-sdio.2BC.txt      ${D}/lib/firmware/cypress/cyfmac4373-sdio.txt
        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin         ${D}/lib/firmware/cypress/cyfmac4373-sdio.bin
        install -m 444 ${S}/cyw-fmac-fw/cyfmac4373-sdio.2BC.clm_blob    ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob

#	For 2EA 
	install -m 444 ${S}/cyfmac55572-pcie.txt ${D}/lib/firmware/cypress
        install -m 444 ${S}/cyfmac55572-sdio.txt ${D}/lib/firmware/cypress
        install -m 444 ${WORKDIR}/cyfmac55572-sdio-ifx-demo.txt ${D}/lib/firmware/cypress/murata-master
        install -m 444 ${WORKDIR}/cyfmac55572-sdio_v2.4.3.txt ${D}/lib/firmware/cypress/murata-master
        install -m 444 ${WORKDIR}/cyfmac55572-sdio_v2.5.1.txt ${D}/lib/firmware/cypress/murata-master

#       For 2BZ
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac54591-sdio.2ant.2BZ.txt ${D}/lib/firmware/cypress/cyfmac54591-sdio.txt

	install -m 444 ${S}/cyw-fmac-nvram/README_NVRAM.txt ${D}/lib/firmware/cypress

	# Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules

	install -d ${D}/lib/firmware/nxp

#       Copying wl tool binary to /usr/sbin
        if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx64/wl ${D}/usr/sbin/wl
		install -m 755 ${WORKDIR}/ot-ctl.64-bit ${D}/usr/sbin/ot-ctl
		install -m 755 ${WORKDIR}/ot-daemon.64-bit ${D}/usr/sbin/ot-daemon
		install -m 755 ${WORKDIR}/fw_loader_imx_lnx.64-bit ${D}/usr/sbin/fw_loader_imx_lnx
	else
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
		install -m 755 ${WORKDIR}/ot-ctl.32-bit ${D}/usr/sbin/ot-ctl
		install -m 755 ${WORKDIR}/ot-daemon.32-bit ${D}/usr/sbin/ot-daemon
	fi
	
#	Points default to NXP
	ln -sf /usr/sbin/wpa_supplicant.nxp ${D}${sbindir}/wpa_supplicant
        ln -sf /usr/sbin/wpa_cli.nxp ${D}${sbindir}/wpa_cli
	ln -sf /usr/sbin/hostapd.nxp ${D}${sbindir}/hostapd
	ln -sf /usr/sbin/hostapd_cli.nxp ${D}${sbindir}/hostapd_cli

#	Based on MACHINE type
#	echo "DEBUG:: MACHINE TYPE :: ${MACHINE}"
	# Added Script file for switching between CYW and NXP
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

#	Install nxp linux calibration files
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1XK/* ${D}/lib/firmware/nxp/murata/files/1XK
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1YM/* ${D}/lib/firmware/nxp/murata/files/1YM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1ZM/* ${D}/lib/firmware/nxp/murata/files/1ZM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/2DS/* ${D}/lib/firmware/nxp/murata/files/2DS
        #       Copying wl tool binary based on 32-bit/64-bit arch to /usr/sbin
        if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${S}/nxp-linux-calibration/murata/files/64_bit/* ${D}/lib/firmware/nxp/murata/files/64_bit
	else
		install -m 755 ${S}/nxp-linux-calibration/murata/files/32_bit/* ${D}/lib/firmware/nxp/murata/files/32_bit
	fi

	install -m 444 ${S}/nxp-linux-calibration/murata/files/bt_power_config_1.sh ${D}/lib/firmware/nxp/murata/files
        install -m 444 ${S}/nxp-linux-calibration/murata/files/regulatory.rules ${D}/lib/firmware/nxp/murata/files
        install -m 777 ${S}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}/lib/firmware/nxp/murata/files
        install -m 755 ${S}/nxp-linux-calibration/murata/switch_regions.sh ${D}/usr/sbin/switch_regions.sh
        install -m 755 ${S}/nxp-linux-calibration/murata/start_country.service ${D}/lib/firmware/nxp/murata/files
        install -m 444 ${S}/nxp-linux-calibration/murata/README.txt ${D}/lib/firmware/nxp/murata/README.txt

#	Copy 1XK Dedicated Bluetooth Antenna configuration file
	install -m 755 ${S}/WlanCalData_ext_2ANT_Dedicated_BT_1XK.conf ${D}/lib/firmware/nxp/murata/files/1XK
	install -m 755 ${S}/uartspi_n61x_v1.bin.se ${D}/lib/firmware/nxp
	install -m 755 ${S}/sduart_nw61x_v1.bin.se ${D}/lib/firmware/nxp
	install -m 444 ${S}/WlanCalData_ext.conf ${D}/lib/firmware/nxp
}

PACKAGES =+ "${PN}-mfgtest"

FILES:${PN} += "/lib/firmware"
FILES:${PN} += "/lib/firmware/*"
FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "{sysconfdir}/firmware"
FILES:${PN} += "/lib"
FILES:${PN} += "{sysconfdir}/firmware/nxp"
#FILES:${PN} += "/usr/sbin/wpa_supplicant"

FILES:${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"


