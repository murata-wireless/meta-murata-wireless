require nxp-wlan-sdk_git.inc

SUMMARY = "NXP Wi-Fi SDK"

inherit module-base

TARGET_CC_ARCH += "${LDFLAGS}"

do_patch () {
	echo "In patch function: vkjb"
	pwd
#        SDIO_SOURCE_DIR="${S}/../../.."
#	echo "two"
#	cd ${SDIO_SOURCE_DIR}
	pwd
	cd git/
	echo "3:"
	pwd
#	cp makefile.patch ${S}
#	echo "S: ${S}"
#	ls -al
#	echo "B: ${B}"
#	cd ${S}/
	
#	
	patch -p1 < ../makefile.patch
}

do_compile () {
    oe_runmake build
}

do_install () {
    install -d ${D}${datadir}/nxp_wireless
    install -d ${D}${datadir}/nxp_wireless/bin_sdio_1xk
    install -m 0755 mapp/mlanutl/mlanutl ${D}${datadir}/nxp_wireless
    install -m 0755 script/load ${D}${datadir}/nxp_wireless
    install -m 0755 script/unload ${D}${datadir}/nxp_wireless
    install -m 0644 README_MLAN ${D}${datadir}/nxp_wireless

    install -m 0644 moal.ko ${D}${datadir}/nxp_wireless/bin_sdio_1xk
    install -m 0644 mlan.ko ${D}${datadir}/nxp_wireless/bin_sdio_1xk

}

FILES_${PN} = "${datadir}/nxp_wireless"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
