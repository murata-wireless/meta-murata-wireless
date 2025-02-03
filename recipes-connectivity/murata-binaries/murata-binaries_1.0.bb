SUMMARY = "Murata Binaries"
LICENSE = "GPL-2.0-only"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

IMX_FIRMWARE_SRC ?= "git://github.com/NXP/imx-firmware.git;protocol=https"
SRCBRANCH_imx-firmware = "lf-6.6.23_2.0.0"

SRC_URI = " \
        ${IMX_FIRMWARE_SRC};branch=${SRCBRANCH_imx-firmware};destsuffix=imx-firmware;name=imx-firmware \
        git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=master;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
        https://github.com/Infineon/ifx-linux-firmware/archive/refs/tags/release-v6.1.97-2024_1115.tar.gz;destsuffix=cyw-fmac-fw-ifx;name=cyw-fmac-fw-ifx \
        git://github.com/murata-wireless/cyw-fmac-fw;protocol=http;branch=jaculus;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/murata-wireless/cyw-fmac-nvram;protocol=http;branch=master;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=master;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/murata-wireless/cyw-fmac-utils-imx32;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/murata-wireless/cyw-fmac-utils-imx64;protocol=http;branch=master;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
        git://github.com/project-chip/connectedhomeip;protocol=http;branch=master;destsuffix=connectedhomeip;name=connectedhomeip \
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
        file://switch_module_imx93ea-ucom.sh \
        file://ot-daemon.64-bit \
        file://ot-ctl.64-bit \
        file://fw_loader_imx_lnx.64-bit \
        file://ot-daemon.32-bit \
        file://ot-ctl.32-bit \
        file://WlanCalData_ext.conf \
        file://test_2el_spi.sh \
        file://mlanutl.32-bit \
        file://mlanutl.64-bit \
        file://load-fmac.sh \
        file://load-2ea-bt.sh \
        file://hostapd-wifi6.conf \
        file://wpa_supplicant-wifi6.conf \
        file://chip-tool \
        file://chip-tool-web \
        file://brcm_patchram_plus_usb_64bit \
        file://cyfmac55500-sdio.txt \
"

SRC_URI[cyw-fmac-fw-ifx.sha256sum]="34f5bfac6476d849af26f945705dc5a19965825333840405ef25dcd835d521d7"
SRCREV_nxp-linux-calibration="87197da5490dfe36da2e7c40df256a20d43ab0df"
SRCREV_cyw-fmac-fw="a5cb86a5d11192ba6e7738f82b4d2dc9eeeca679"
SRCREV_cyw-fmac-nvram="76931abf63d6ff069bb98ac9a57bceb4a7dc9b3f"
SRCREV_cyw-bt-patch="83f8e16423c47e195f52a06fd68ac92a20a80a9f"
SRCREV_cyw-fmac-utils-imx32="dad9ed86bf6691910197bc91d42a45ea8175180c"
SRCREV_cyw-fmac-utils-imx64="368bd9a4163e115468d79c238192b41f6266c523"
SRCREV_connectedhomeip="7879111b8b17d5cb2789ffd4d634438dd2e8c52a"
SRCREV_imx-firmware = "7e038c6afba3118bcee91608764ac3c633bce0c4"

SRCREV_default = "${AUTOREV}"
SRCREV_FORMAT = "muratabinaries"

S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " linux-firmware libnl wpa-supplicant cyw-supplicant"

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
DO_INSTALL_64BIT_BINARIES_mx9 = "yes"

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

    # Install /lib/firmware/nxp folder
    install -d ${D}/${base_libdir}/firmware/nxp
    install -d ${D}/${base_libdir}/firmware/nxp/murata
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1XK
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1ZM
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1YM
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2DS
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1XL
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2EL
    install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2DL

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
    install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/${base_libdir}/firmware/brcm/README_BT_PATCHFILE.txt

    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4335C0.ZP.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM4345C0_003.001.025.0187.0366.1MW.hcd   ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM4345C0_003.001.025.0187.0366.1MW.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd  ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0303.0267.1LV.sAnt.hcd
    install -m 444 ${WORKDIR}/cyw-bt-patch/BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd ${D}/${base_libdir}/firmware/brcm/murata-master/_BCM43012C0_003.001.015.0300.0266.1LV.dAnt.hcd
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
    install -m 444 ${WORKDIR}/cyw-bt-patch/README_BT_PATCHFILE.txt ${D}/${base_libdir}/firmware/brcm/murata-master/README_BT_PATCHFILE.txt


# For 2FY
    install -m 444 ${WORKDIR}/cyw-bt-patch/CYW55500A1_001.002.032.0040.0033_FCC.hcd ${D}/${base_libdir}/firmware/brcm/CYW55500A1_001.002.032.0040.0033_FCC.hcd
    install -m 444 ${WORKDIR}/cyfmac55500-sdio.txt ${D}/${base_libdir}/firmware/cypress


#   Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/cypress folder

#   From Murata GitHub
    install -m 444 ${WORKDIR}/cyw-fmac-fw/*.bin ${D}/${base_libdir}/firmware/cypress

#   From IFX GitHub
#   install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/*.bin ${D}/${base_libdir}/firmware/cypress
#    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/*.trxse ${D}/${base_libdir}/firmware/cypress
#    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/*.trxs ${D}/${base_libdir}/firmware/cypress

    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac43022-sdio.trxs ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55500-sdio.trxse ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55572-pcie.trxse ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac55572-sdio.trxse ${D}/${base_libdir}/firmware/cypress

    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac43012-sdio.bin ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac43439-sdio.bin ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac43455-sdio.bin ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac54591-pcie.bin ${D}/${base_libdir}/firmware/cypress
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac54591-sdio.bin ${D}/${base_libdir}/firmware/cypress

    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac4373-sdio.industrial.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2AE.bin
    install -m 444 ${WORKDIR}/ifx-linux-firmware-release-v6.1.97-2024_1115/firmware/cyfmac4373-sdio.bin ${D}/${base_libdir}/firmware/cypresscyfmac4373-sdio.2BC.bin

#    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2AE.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2AE.bin
#    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac4373-sdio.2BC.bin ${D}/${base_libdir}/firmware/cypress/cyfmac4373-sdio.2BC.bin

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
    install -m 444 ${WORKDIR}/cyw-fmac-fw/cyfmac43022-sdio.2GF.IndoorSTA.clm_blob  ${D}/${base_libdir}/firmware/cypress/cyfmac43022-sdio.clm_blob
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
#	install -m 444 ${WORKDIR}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules
	install -m 444 ${WORKDIR}/hostapd-wifi6.conf                ${D}${sysconfdir}/hostapd-wifi6.conf
	install -m 444 ${WORKDIR}/wpa_supplicant-wifi6.conf         ${D}${sysconfdir}/wpa_supplicant-wifi6.conf

	install -d ${D}/${base_libdir}/firmware/nxp
    install -d ${D}/usr/share/nxp_wireless

#   Copying wl tool binary to /usr/sbin
    if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx64/wl ${D}/usr/sbin/wl
		install -m 755 ${WORKDIR}/ot-ctl.64-bit ${D}/usr/sbin/ot-ctl
		install -m 755 ${WORKDIR}/ot-daemon.64-bit ${D}/usr/sbin/ot-daemon
		install -m 755 ${WORKDIR}/fw_loader_imx_lnx.64-bit ${D}/usr/sbin/fw_loader_imx_lnx
		install -m 755 ${WORKDIR}/mlanutl.64-bit ${D}/usr/sbin/mlanutl
	else
		install -m 755 ${WORKDIR}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
		install -m 755 ${WORKDIR}/ot-ctl.32-bit ${D}/usr/sbin/ot-ctl
		install -m 755 ${WORKDIR}/ot-daemon.32-bit ${D}/usr/sbin/ot-daemon
		install -m 755 ${WORKDIR}/mlanutl.32-bit ${D}/usr/sbin/mlanutl
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
	  imx93ea-ucom)
		install -m 755 ${S}/switch_module_imx93ea-ucom.sh ${D}/usr/sbin/switch_module.sh
		;;
	esac

#	Install nxp linux calibration files
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/1XK/* ${D}/${base_libdir}/firmware/nxp/murata/files/1XK
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/1YM/* ${D}/${base_libdir}/firmware/nxp/murata/files/1YM
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/1ZM/* ${D}/${base_libdir}/firmware/nxp/murata/files/1ZM
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/2DS/* ${D}/${base_libdir}/firmware/nxp/murata/files/2DS
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/1XL/* ${D}/${base_libdir}/firmware/nxp/murata/files/1XL
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/2EL/* ${D}/${base_libdir}/firmware/nxp/murata/files/2EL
	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/2DL/* ${D}/${base_libdir}/firmware/nxp/murata/files/2DL



	install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/files/bt_power_config_1.sh ${D}/${base_libdir}/firmware/nxp/murata/files
    install -m 777 ${WORKDIR}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}/${base_libdir}/firmware/nxp/murata/files
    install -m 755 ${WORKDIR}/nxp-linux-calibration/murata/switch_regions.sh ${D}/usr/sbin/switch_regions.sh
    install -m 444 ${WORKDIR}/nxp-linux-calibration/murata/README.txt ${D}/${base_libdir}/firmware/nxp/murata/README.txt

#	Copy configuration file for 2EL
#	install -m 444 ${WORKDIR}/WlanCalData_ext.conf ${D}/${base_libdir}/firmware/nxp
    install -m 755 ${WORKDIR}/test_2el_spi.sh ${D}/usr/sbin/test_2el_spi.sh
	install -m 755 ${WORKDIR}/load-fmac.sh ${D}/usr/share/murata_wireless/load-fmac.sh
	install -m 755 ${WORKDIR}/load-2ea-bt.sh ${D}/usr/sbin/load-2ea-bt.sh


	install -m 755 ${WORKDIR}/chip-tool ${D}/usr/sbin/chip-tool
	install -m 755 ${WORKDIR}/chip-tool-web ${D}/usr/sbin/chip-tool-web
	install -m 755 ${WORKDIR}/connectedhomeip/credentials/production/paa-root-certs/* ${D}/usr/share/murata_wireless
	install -m 755 ${WORKDIR}/brcm_patchram_plus_usb_64bit ${D}/usr/sbin/brcm_patchram_plus_usb_64bit

    # Install NXP Connectivity
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/wifi_mod_para.conf    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity SD8801 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8801_SD/ed_mac_ctrl_V1_8801.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8801_SD/sd8801_uapsta.bin         ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity 8987 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8987/ed_mac_ctrl_V3_8987.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8987/sd8987_wlan.bin           ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8987/sdiouart8987_combo_v0.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8987/txpwrlimit_cfg_8987.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8987/uartuart8987_bt.bin       ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity PCIE8997 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997/ed_mac_ctrl_V3_8997.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997/pcie8997_wlan_v4.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997/pcieuart8997_combo_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997/txpwrlimit_cfg_8997.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997/uartuart8997_bt_v4.bin    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity SDIO8997 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997_SD/ed_mac_ctrl_V3_8997.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997_SD/sdio8997_wlan_v4.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997_SD/sdiouart8997_combo_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997_SD/txpwrlimit_cfg_8997.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_8997_SD/uartuart8997_bt_v4.bin    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity PCIE9098 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_PCIE/ed_mac_ctrl_V3_909x.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_PCIE/pcie9098_wlan_v1.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_PCIE/pcieuart9098_combo_v1.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_PCIE/txpwrlimit_cfg_9098.conf  ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_PCIE/uartuart9098_bt_v1.bin    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity SD9098 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_SD/sdio9098_wlan_v1.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_SD/sdiouart9098_combo_v1.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_9098_SD/uartuart9098_bt_v1.bin    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity IW416 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/sdioiw416_wlan_v0.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/sdiouartiw416_combo_v0.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/uartiw416_bt_v0.bin        ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity IW612 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/sduart_nw61x_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/sd_w61x_v1.bin.se      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/uartspi_n61x_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp
}

PACKAGES =+ "${PN}-mfgtest"

FILES:${PN} += "${base_libdir}/firmware"
FILES:${PN} += "${base_libdir}/firmware/*"
FILES:${PN} += "${base_libdir}/firmware/brcm"
FILES:${PN} += "${base_libdir}/firmware/brcm/murata-master"
FILES:${PN} += "usr/share/nxp_wireless"
FILES:${PN} += "usr/share/murata_wireless"

FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "${sysconfdir}/firmware"
FILES:${PN} += "${base_libdir}"
FILES:${PN} += "${sysconfdir}/firmware/nxp"

FILES:${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"
INSANE_SKIP:${PN} += "already-stripped"
