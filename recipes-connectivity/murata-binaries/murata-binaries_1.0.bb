SUMMARY = "Murata Binaries"
LICENSE = "BSD-3-Clause"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

SRC_URI = " \
        git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=indrik;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=indrik;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=kirkstone-indrik;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
        file://set_module.sh \
        file://cyfmac55572-pcie.txt \
        file://cyfmac55572-sdio.txt \
        file://cyfmac55572-sdio-ifx-demo.txt \
        file://cyfmac55572-sdio_v2.4.3.txt \
        file://cyfmac55572-sdio_v2.5.1.txt \
        file://load-bluetooth.sh \
        file://set-bluetooth.sh \
        file://load-2ea-bt.sh \
        file://cyfmac4373.bin \
        file://hostapd-wifi6.conf \
        file://wpa_supplicant-wifi6.conf \
"

SRCREV_cyw-fmac-fw="d6cd8b50b5f71ca3ba26fd88177676a688aac85b"
SRCREV_cyw-fmac-nvram="2e0679dbe25a4ae38480b09c80b007dde90b636f"
SRCREV_cyw-bt-patch="ad078a3ed656e48e686c9b9ef7023e3c5c25f11f"
SRCREV_cyw-fmac-utils-imx32="fcdd231e9bb23db3c93c10e5dff43a1182f220c5"
SRCREV_cyw-fmac-utils-imx64="52cc4cc6be8629781014505aa276b67e18cf6e8d"

SRCREV_default = "${AUTOREV}"

S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " libnl wpa-supplicant linux-firmware"

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
    install -d ${D}/lib/firmware/brcm
    install -d ${D}/lib/firmware/brcm/murata-master
	install -d ${D}/usr/sbin
	install -d ${D}/etc/udev/rules.d
    install -d ${D}/usr/share/murata_wireless

#   Copying *.HCD files to etc/firmware and etc/firmware/murata-master (using "_" before the name of the file in murata-master)
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4335C0.ZP.hcd ${D}/lib/firmware/brcm/BCM4335C0.ZP.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd ${D}/lib/firmware/brcm/BCM4345C0_003.001.025.0187.0366.1MW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd ${D}/lib/firmware/brcm/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43341B0.1BW.hcd ${D}/lib/firmware/brcm/BCM43341B0.1BW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd ${D}/lib/firmware/brcm/BCM43430A1_001.002.009.0159.0528.1DX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4350C0.1BB.hcd ${D}/lib/firmware/brcm/BCM4350C0.1BB.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd ${D}/lib/firmware/brcm/BCM4356A2_001.003.015.0112.0410.1CX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}/lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/lib/firmware/brcm/BCM4373A0.2AE.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/lib/firmware/brcm/BCM4373A0.2BC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}/lib/firmware/brcm/CYW4343A2_001.003.016.0031.0000.1YN.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd ${D}/lib/firmware/brcm/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd ${D}/lib/firmware/brcm/BCM.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}/lib/firmware/brcm/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/lib/firmware/brcm/

    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}/lib/firmware/brcm/murata-master/_BCM4335C0.ZP.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd   ${D}/lib/firmware/brcm/murata-master/_BCM4345C0_003.001.025.0187.0366.1MW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd  ${D}/lib/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd ${D}/lib/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}/lib/firmware/brcm/murata-master/_BCM43341B0.1BW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd  ${D}/lib/firmware/brcm/murata-master/_BCM43430A1_001.002.009.0159.0528.1DX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}/lib/firmware/brcm/murata-master/_BCM4350C0.1BB.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd   ${D}/lib/firmware/brcm/murata-master/_BCM4356A2_001.003.015.0112.0410.1CX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4373A0.2AE.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4373A0.2BC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}/lib/firmware/brcm/murata-master/_CYW4343A2_001.003.016.0031.0000.1YN.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd ${D}/lib/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd

#	Temporary from MMW
        install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/lib/firmware/brcm/murata-master

#   Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/cypress folder
	install -m 444 ${WORKDIR}/cyw-fmac-fw/*.bin ${D}/lib/firmware/cypress
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-pcie.trxse ${D}/lib/firmware/cypress
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-sdio.trxse ${D}/lib/firmware/cypress
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.bin
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.bin

#   Rename clm blob files accordingly
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4354-sdio.1BB.clm_blob ${D}/lib/firmware/cypress/cyfmac4354-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4356-pcie.1CX.clm_blob ${D}/lib/firmware/cypress/cyfmac4356-pcie.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43012-sdio.1LV.clm_blob ${D}/lib/firmware/cypress/cyfmac43012-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43430-sdio.1DX.clm_blob ${D}/lib/firmware/cypress/cyfmac43430-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43455-sdio.1MW.clm_blob ${D}/lib/firmware/cypress/cyfmac43455-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4359-sdio.1WZ.clm_blob ${D}/lib/firmware/cypress/cyfmac4359-pcie.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac54591-pcie.1XA.clm_blob ${D}/lib/firmware/cypress/cyfmac54591-pcie.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac54591-sdio.2BZ.clm_blob ${D}/lib/firmware/cypress/cyfmac54591-sdio.clm_blob

# 	For 2AE and 1YN
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob
	install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43439-sdio.1YN.clm_blob  ${D}/lib/firmware/cypress/cyfmac43439-sdio.clm_blob 

#   For 2EA
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-sdio.2EA.clm_blob  ${D}/lib/firmware/cypress/cyfmac55572-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-pcie.2EA.clm_blob  ${D}/lib/firmware/cypress/cyfmac55572-pcie.clm_blob

	install -m 444 ${WORKDIR}/cyw-fmac-fw/README_CLM_BLOB.txt ${D}/lib/firmware/cypress/README_CLM_BLOB.txt
	install -m 444 ${WORKDIR}/cyw-fmac-fw/README_FW.txt ${D}/lib/firmware/cypress/README_FW.txt

#   Copying NVRAM files (*.txt) to lib/firmware/cypress and lib/firmware/cypress/murata-master
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/*.txt ${D}/lib/firmware/cypress/murata-master

	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4339-sdio.ZP.txt ${D}/lib/firmware/cypress/cyfmac4339-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4354-sdio.1BB.txt ${D}/lib/firmware/cypress/cyfmac4354-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4356-pcie.1CX.txt ${D}/lib/firmware/cypress/cyfmac4356-pcie.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43012-sdio.1LV.txt ${D}/lib/firmware/cypress/cyfmac43012-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43340-sdio.1BW.txt ${D}/lib/firmware/cypress/cyfmac43340-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43362-sdio.SN8000.txt ${D}/lib/firmware/cypress/cyfmac43362-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43430-sdio.1DX.txt ${D}/lib/firmware/cypress/cyfmac43430-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43455-sdio.1MW.txt ${D}/lib/firmware/cypress/cyfmac43455-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac54591-pcie.1XA.txt ${D}/lib/firmware/cypress/cyfmac54591-pcie.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac5557x-pcie_sdio.sant.2EA_2EC.txt ${D}/lib/firmware/cypress/cyfmac55572-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac5557x-pcie_sdio.sant.2EA_2EC.txt ${D}/lib/firmware/cypress/cyfmac55572-pcie.txt

#	For 2AE, 2BC, and 1YN
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43439-sdio.1YN.txt ${D}/lib/firmware/cypress/cyfmac43439-sdio.txt

	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2BC.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2AE.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.txt

    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.bin
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.bin

    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob


    install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2BC.txt      ${D}/lib/firmware/cypress/cyfmac4373-sdio.txt
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin         ${D}/lib/firmware/cypress/cyfmac4373-sdio.bin
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.clm_blob    ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob

#	For 2EA 
    install -m 444 ${WORKDIR}/cyfmac55572-sdio-ifx-demo.txt ${D}/lib/firmware/cypress/murata-master
    install -m 444 ${WORKDIR}/cyfmac55572-sdio_v2.4.3.txt ${D}/lib/firmware/cypress/murata-master
    install -m 444 ${WORKDIR}/cyfmac55572-sdio_v2.5.1.txt ${D}/lib/firmware/cypress/murata-master

#   For 2BZ
	install -m 444 ${S}/cyw-fmac-nvram/cyfmac54591-sdio.2ant.2BZ.txt ${D}/lib/firmware/cypress/cyfmac54591-sdio.txt

	install -m 444 ${S}/cyw-fmac-nvram/README_NVRAM.txt ${D}/lib/firmware/cypress

	# Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules

#   Copying wl tool binary to /usr/sbin
    if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${S}/cyw-fmac-utils-imx64/wl ${D}/usr/sbin/wl
	else
		install -m 755 ${S}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
	fi

#   Based on MACHINE type
    install -m 755 ${S}/set_module.sh ${D}/usr/sbin/set_module.sh
	install -m 444 ${S}/cyfmac4373.bin ${D}/lib/firmware/cypress

#	Defaults point to 2BC
    ln -sf /lib/firmware/cypress/cyfmac4373-sdio.2BC.txt ${D}/lib/firmware/cypress/cyfmac4373-sdio.txt
    ln -sf /lib/firmware/cypress/cyfmac4373-sdio.2BC.bin ${D}/lib/firmware/cypress/cyfmac4373-sdio.bin
    ln -sf /lib/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob ${D}/lib/firmware/cypress/cyfmac4373-sdio.clm_blob

#   For loading 2EA@BT
	install -m 755 ${WORKDIR}/load-2ea-bt.sh ${D}/usr/sbin/load-2ea-bt.sh
	install -m 755 ${WORKDIR}/load-bluetooth.sh ${D}/usr/sbin/load-bluetooth.sh
	install -m 755 ${WORKDIR}/set-bluetooth.sh ${D}/usr/sbin/set-bluetooth.sh
}

PACKAGES =+ "${PN}-mfgtest"

FILES:${PN} += "/lib/firmware"
FILES:${PN} += "/lib/firmware/*"
FILES:${PN} += "/lib/firmware/brcm"
FILES:${PN} += "/lib/firmware/brcm/murata-master"
FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "{sysconfdir}/firmware"
FILES:${PN} += "/lib"
FILES:${PN} += "usr/share/murata_wireless"

FILES:${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"


