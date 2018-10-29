SUMMARY = "Murata Binaries"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

SRC_URI = " \
	git://github.com/jameelkareem-sample/cyw-fmac-fw;protocol=http;branch=manda;destsuffix=cyw-fmac-fw \
	git://github.com/jameelkareem-sample/cyw-fmac-nvram;protocol=http;branch=manda;destsuffix=cyw-fmac-nvram \
	git://github.com/jameelkareem-sample/cyw-bt-patch;protocol=http;branch=rocko-manda;destsuffix=cyw-bt-patch \
	git://github.com/jameelkareem-sample/cyw-fmac-utils-imx32;protocol=http;branch=manda;destsuffix=cyw-fmac-utils-imx32 \
	file://10-network.rules \
"

SRCREV_cyw-fmac-fw="9a813ba411870cffd4ec20d30623035773564da9"
SRCREV_cyw-fmac-nvram="d27f1bf105fa1e5b828e355793b88d4b66188411"
SRCREV_cyw-bt-patch="748462f0b02ec4aeb500bedd60780ac51c37be31"
SRCREV_cyw-fmac-utils-imx32="b1cbd9170dd96ac73102aeee5d73b11575e1028a"

SRCREV_default = "${AUTOREV}"


S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " libnl"

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
        echo "PWD :: "
        pwd
}

PACKAGES_prepend = "murata-binaries-wlarm "
FILES_murata-binaries-wlarm = "${bindir}/wlarm"


do_install () {
	echo "Installing: "
	install -d ${D}/lib/firmware/brcm
	install -d ${D}/lib/firmware/brcm/murata-master
	install -d ${D}/etc/firmware
	install -d ${D}/etc/firmware/murata-master
	install -d ${D}/usr/sbin
	install -d ${D}/etc/udev/rules.d

#       Copying *.HCD files to etc/firmware and etc/firmware/murata-master
        install -m 444 ${S}//cyw-bt-patch/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/BCM4335C0.ZP.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4345C0.1MW.hcd ${D}${sysconfdir}/firmware/BCM4345C0.1MW.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43012C0.1LV.hcd ${D}${sysconfdir}/firmware/BCM43012C0.1LV.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/BCM43341B0.1BW.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43430A1.1DX.hcd ${D}${sysconfdir}/firmware/BCM43430A1.1DX.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4350C0.1BB.hcd ${D}${sysconfdir}/firmware/BCM4350C0.1BB.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4354A2.1CX.hcd ${D}${sysconfdir}/firmware/BCM4354A2.1CX.hcd
	install -m 444 ${S}//cyw-bt-patch/README_BT_PATCHFILE ${D}${sysconfdir}/firmware

#	install -m 444 ${D}${sysconfdir}/firmware/*.hcd       ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${S}//cyw-bt-patch/CYW4335C0.ZP.hcd    ${D}${sysconfdir}/firmware/murata-master/_BCM4335C0.ZP.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4345C0.1MW.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4345C0.1MW.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43012C0.1LV.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43012C0.1LV.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43341B0.1BW.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43341B0.1BW.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW43430A1.1DX.hcd  ${D}${sysconfdir}/firmware/murata-master/_BCM43430A1.1DX.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4350C0.1BB.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4350C0.1BB.hcd
        install -m 444 ${S}//cyw-bt-patch/CYW4354A2.1CX.hcd   ${D}${sysconfdir}/firmware/murata-master/_BCM4354A2.1CX.hcd
	install -m 444 ${S}//cyw-bt-patch/README_BT_PATCHFILE ${D}${sysconfdir}/firmware/murata-master

#       Copying FW and CLM BLOB files (*.bin, *.clm_blob) to lib/firmware/brcm folder
	install -m 444 ${S}/cyw-fmac-fw/*.bin ${D}/lib/firmware/brcm
##	install -m 444 ${S}/cyw-fmac-fw/*.clm_blob ${D}/lib/firmware/brcm


#       Rename clm blob files accordingly
	install -m 444 ${S}/cyw-fmac-fw/brcmfmac4354-sdio.1BB.clm_blob ${D}/lib/firmware/brcm/brcmfmac4354-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/brcmfmac4356-pcie.1CX.clm_blob ${D}/lib/firmware/brcm/brcmfmac4356-pcie.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/brcmfmac43012-sdio.1LV.clm_blob ${D}/lib/firmware/brcm/brcmfmac43012-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/brcmfmac43430-sdio.1DX.clm_blob ${D}/lib/firmware/brcm/brcmfmac43430-sdio.clm_blob
	install -m 444 ${S}/cyw-fmac-fw/brcmfmac43455-sdio.1HK.clm_blob ${D}/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	
#       Copying NVRAM files (*.txt) to lib/firmware/brcm and lib/firmware/brcm/murata-master
	install -m 444 ${S}/cyw-fmac-nvram/*.txt ${D}/lib/firmware/brcm/murata-master
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac4339-sdio.ZP.txt ${D}/lib/firmware/brcm/brcmfmac4339-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac4354-sdio.1BB.txt ${D}/lib/firmware/brcm/brcmfmac4354-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac4356-pcie.1CX.txt ${D}/lib/firmware/brcm/brcmfmac4356-pcie.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac43012-sdio.1LV.txt ${D}/lib/firmware/brcm/brcmfmac43012-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac43340-sdio.1BW.txt ${D}/lib/firmware/brcm/brcmfmac43340-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac43362-sdio.SN8000.txt ${D}/lib/firmware/brcm/brcmfmac43362-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac43430-sdio.1DX.txt ${D}/lib/firmware/brcm/brcmfmac43430-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/brcmfmac43455-sdio.1MW.txt ${D}/lib/firmware/brcm/brcmfmac43455-sdio.txt
	install -m 444 ${S}/cyw-fmac-nvram/README_NVRAM ${D}/lib/firmware/brcm

	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules

#       Copying wl tool binary to /usr/sbin
	install -m 755 ${S}/cyw-fmac-utils-imx32/wl ${D}/usr/sbin/wl
}

PACKAGES =+ "${PN}-mfgtest"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
FILES_${PN} += "${bindir}"
FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"


FILES_${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP_${PN} += "build-deps"
INSANE_SKIP_${PN} += "file-rdeps"
