SUMMARY = "Murata Binaries"
LICENSE = "BSD-3-Clause"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

SRC_URI = " \
        https://github.com/Infineon/ifx-linux-firmware/archive/refs/tags/release-v6.1.97-2024_1115.tar.gz;destsuffix=cyw-fmac-fw-ifx;name=cyw-fmac-fw-ifx \
        git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=jaculus;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=jaculus;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=master;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
        file://cyfmac55500-sdio.txt \
        file://set_module.sh \
        file://load-bluetooth.sh \
        file://set-bluetooth.sh \
        file://hostapd-wifi6.conf \
        file://wpa_supplicant-wifi6.conf \
        file://murata_test_version.sh \
"

SRC_URI[cyw-fmac-fw-ifx.sha256sum]="34f5bfac6476d849af26f945705dc5a19965825333840405ef25dcd835d521d7"
SRCREV_cyw-fmac-fw="acc1006a873a196495ed209bd18b3f47b4128426"
SRCREV_cyw-fmac-nvram="146d1438372b6c4857f92b8769b91c1801d3ede2"
SRCREV_cyw-bt-patch="83f8e16423c47e195f52a06fd68ac92a20a80a9f"
SRCREV_cyw-fmac-utils-imx32="fcdd231e9bb23db3c93c10e5dff43a1182f220c5"
SRCREV_cyw-fmac-utils-imx64="52cc4cc6be8629781014505aa276b67e18cf6e8d"

SRCREV_default = "${AUTOREV}"
SRCREV_FORMAT = "muratabinaries"

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
    install -d ${D}/${base_libdir}/firmware/cypress
    install -d ${D}/${base_libdir}/firmware/cypress/murata-master
    install -d ${D}/${base_libdir}/firmware/brcm
    install -d ${D}/${base_libdir}/firmware/brcm/murata-master
    install -d ${D}/usr/sbin
    install -d ${D}/etc/udev/rules.d
    install -d ${D}/usr/share/murata_wireless
    install -d ${D}/etc

#   Copying *.HCD files to etc/firmware and etc/firmware/murata-master (using "_" before the name of the file in murata-master)
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4335C0.ZP.hcd ${D}/${base_libdir}/firmware/brcm/BCM4335C0.ZP.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd ${D}/${base_libdir}/firmware/brcm/BCM4345C0_003.001.025.0187.0366.1MW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43012C1_003.002.024.0036.0008.2GF.hcd ${D}/${base_libdir}/firmware/brcm/CYW43012C1_003.002.024.0036.0008.2GF.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43341B0.1BW.hcd ${D}/${base_libdir}/firmware/brcm/BCM43341B0.1BW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd ${D}/${base_libdir}/firmware/brcm/BCM43430A1_001.002.009.0159.0528.1DX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4350C0.1BB.hcd ${D}/${base_libdir}/firmware/brcm/BCM4350C0.1BB.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd ${D}/${base_libdir}/firmware/brcm/BCM4356A2_001.003.015.0112.0410.1CX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/${base_libdir}/firmware/brcm/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2BC.hcd ${D}/${base_libdir}/firmware/brcm/BCM4373A0_001.001.025.0103.0155.FCC.CE.2BC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}/${base_libdir}/firmware/brcm/CYW4343A2_001.003.016.0031.0000.1YN.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55560A1_001.002.087.0269.0100.FCC.2EA.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/BCM.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55500A1_001.002.032.0040.0033_FCC.hcd ${D}/${base_libdir}/firmware/brcm/CYW55500A1_001.002.032.0040.0033_FCC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/${base_libdir}/firmware/brcm/README_BT_PATCHFILE.txt

    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4335C0.ZP.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd   ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4345C0_003.001.025.0187.0366.1MW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd  ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43012C1_003.002.024.0036.0008.2GF.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_CYW43012C1_003.002.024.0036.0008.2GF.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43341B0.1BW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43430A1_001.002.009.0159.0528.1DX.hcd  ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43430A1_001.002.009.0159.0528.1DX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4350C0.1BB.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4356A2_001.003.015.0112.0410.1CX.hcd   ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4356A2_001.003.015.0112.0410.1CX.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0275.1XA.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0274.1XA.dAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4373A0_001.001.025.0103.0155.FCC.CE.2AE.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4373A0_001.001.025.0103.0155.FCC.CE.2BC.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4373A0_001.001.025.0103.0155.FCC.CE.2BC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4343A2_001.003.016.0031.0000.1YN.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_CYW4343A2_001.003.016.0031.0000.1YN.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0275.2BZ.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4359D0_004.001.016.0241.0274.2BZ.dAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4373A0_001.001.025.0119.0000.2AE.USB_FCC.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_CYW4373A0_001.001.025.0119.0000.2AE.USB_FCC.hcd
install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55500A1_001.002.032.0040.0033_FCC.hcd ${D}/${base_libdir}/firmware/brcm/_CYW55500A1_001.002.032.0040.0033_FCC.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/${base_libdir}/firmware/brcm/murata-master/README_BT_PATCHFILE.txt


# For 2FY
    install -m 444 ${WORKDIR}/cyfmac55500-sdio.txt ${D}/${base_libdir}/firmware/cypress

#   Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/cypress folder
	install -m 444 ${WORKDIR}/cyw-fmac-fw/*.bin ${D}/${base_libdir}/firmware/cypress

    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac43022-sdio.trxs ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55500-sdio.trxse ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55572-pcie.trxse ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55572-sdio.trxse ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac4373-sdio.industrial.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2AE.bin
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac4373-sdio.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.bin

#   Rename clm blob files accordingly
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4354-sdio.1BB.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4354-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4356-pcie.1CX.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4356-pcie.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43012-sdio.1LV.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac43012-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43430-sdio.1DX.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac43430-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43455-sdio.1MW.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac43455-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4359-sdio.1WZ.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4359-pcie.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac54591-pcie.1XA.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac54591-pcie.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac54591-sdio.2BZ.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac54591-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43439-sdio.1YN.clm_blob  ${D}/${base_libdir}/firmware/cypress/cyfmac43439-sdio.clm_blob 
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-sdio.2EA.clm_blob_STAIndoor  ${D}/${base_libdir}/firmware/cypress/cyfmac55572-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55572-pcie.2EA.clm_blob_STAIndoor  ${D}/${base_libdir}/firmware/cypress/cyfmac55572-pcie.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43022-sdio.2GF.STA.clm_blob  ${D}/${base_libdir}/firmware/cypress/cyfmac43022-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac55500-sdio.2FY.clm_blob  ${D}/${base_libdir}/firmware/cypress/cyfmac55500-sdio.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/README_CLM_BLOB.txt ${D}/${base_libdir}/firmware/cypress/README_CLM_BLOB.txt
    install -m 444 ${WORKDIR}/cyw-fmac-fw/README_FW.txt ${D}/${base_libdir}/firmware/cypress/README_FW.txt


    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2AE.clm_blob


#   Copying NVRAM files (*.txt) to lib/firmware/cypress and lib/firmware/cypress/murata-master
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/*.txt ${D}/${base_libdir}/firmware/cypress/murata-master
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43012-sdio.1LV.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43012-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43022-sdio.2GF.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43022-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43340-sdio.1BW.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43340-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43430-sdio.1DX.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43430-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43455-sdio.1MW.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43455-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac54591-pcie.1XA.txt ${D}/${base_libdir}/firmware/cypress/cyfmac54591-pcie.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac43439-sdio.1YN.txt ${D}/${base_libdir}/firmware/cypress/cyfmac43439-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2BC.txt ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2AE.txt ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2AE.txt

#   2FY has an eror with OOB
#	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac55500-sdio.2FY.txt ${D}/${base_libdir}/firmware/cypress/cyfmac55500-sdio.txt

	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac5557x-pcie_sdio.sant.2EA_2EC.txt ${D}/${base_libdir}/firmware/cypress/cyfmac55572-sdio.txt
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac5557x-pcie_sdio.sant.2EA_2EC.txt ${D}/${base_libdir}/firmware/cypress/cyfmac55572-pcie.txt

# Setting the default to 2AE
    install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac4373-sdio.2AE.txt      ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.txt
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac4373-sdio.industrial.bin         ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.bin
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.clm_blob    ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.clm_blob


#   For 2BZ
	install -m 444 ${WORKDIR}/cyw-fmac-nvram/cyfmac54591-sdio.2ant.2BZ.txt ${D}/${base_libdir}/firmware/cypress/cyfmac54591-sdio.txt

	install -m 444 ${WORKDIR}/cyw-fmac-nvram/README_NVRAM.txt ${D}/${base_libdir}/firmware/cypress

	# Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules
	install -m 444 ${WORKDIR}/hostapd-wifi6.conf                ${D}${sysconfdir}/hostapd-wifi6.conf
	install -m 444 ${WORKDIR}/wpa_supplicant-wifi6.conf         ${D}${sysconfdir}/wpa_supplicant-wifi6.conf


#   Copying wl tool binary to /usr/sbin
    if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx64/wl ${D}/usr/sbin/wl
	else
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
	fi

#   Based on MACHINE type
    install -m 755 ${S}/set_module.sh ${D}/usr/sbin/set_module.sh
    install -m 755 ${S}/murata_test_version.sh ${D}/usr/sbin/murata_test_version.sh


#	Defaults point to 2BC
    ln -sf /${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.txt ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.txt
    ln -sf /${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.bin
    ln -sf /${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.clm_blob ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.clm_blob

#   For loading 2EA@BT
	install -m 755 ${WORKDIR}/load-bluetooth.sh ${D}/usr/sbin/load-bluetooth.sh
	install -m 755 ${WORKDIR}/set-bluetooth.sh ${D}/usr/sbin/set-bluetooth.sh
}

PACKAGES =+ "${PN}-mfgtest"

FILES:${PN} += "${base_libdir}/firmware"
FILES:${PN} += "${base_libdir}/firmware/*"
FILES:${PN} += "${base_libdir}/firmware/brcm"
FILES:${PN} += "${base_libdir}/firmware/brcm/murata-master"
FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "${sysconfdir}/firmware"
FILES:${PN} += "${base_libdir}"
FILES:${PN} += "usr/share/murata_wireless"

FILES:${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"


