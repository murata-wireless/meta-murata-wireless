SUMMARY = "Murata Binaries"
LICENSE = "GPL-2.0-only"

LIC_FILES_CHKSUM = "file://${S}/nxp-linux-calibration/LICENSE;md5=ffa10f40b98be2c2bc9608f56827ed23"

SRC_URI = " \
	git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=master;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
	file://switch_module.sh \
"

SRCREV_nxp-linux-calibration="843edffde6d9afb3712fd278be59d0163ca458f0"

SRCREV_default = "${AUTOREV}"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

DEPENDS = " libnl "

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

DO_INSTALL_64BIT_BINARIES = "no"
DO_INSTALL_64BIT_BINARIES_mx6 = "no"
DO_INSTALL_64BIT_BINARIES_mx7 = "no"
DO_INSTALL_64BIT_BINARIES_mx8 = "yes"

do_install () {
	echo "Installing: "
	install -d ${D}/usr/sbin
	install -d ${D}/etc/udev/rules.d

        # Install /${base_libdir}/firmware/nxp folder
        install -d ${D}/${base_libdir}/firmware/nxp
        install -d ${D}/${base_libdir}/firmware/nxp/murata
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files
	install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1XK
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1ZM
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/1YM
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2DS
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2DL
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/2EL
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/32_bit
        install -d ${D}/${base_libdir}/firmware/nxp/murata/files/64_bit

#	Based on MACHINE type
	install -m 755 ${S}/switch_module.sh ${D}/usr/sbin/switch_module.sh

#	Install nxp linux calibration files
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1XK/* ${D}/${base_libdir}/firmware/nxp/murata/files/1XK
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1YM/* ${D}/${base_libdir}/firmware/nxp/murata/files/1YM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1ZM/* ${D}/${base_libdir}/firmware/nxp/murata/files/1ZM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/2DS/* ${D}/${base_libdir}/firmware/nxp/murata/files/2DS
	install -m 444 ${S}/nxp-linux-calibration/murata/files/2DL/* ${D}/${base_libdir}/firmware/nxp/murata/files/2DL
	install -m 444 ${S}/nxp-linux-calibration/murata/files/2EL/* ${D}/${base_libdir}/firmware/nxp/murata/files/2EL

	install -m 444 ${S}/nxp-linux-calibration/murata/files/bt_power_config_1.sh ${D}/${base_libdir}/firmware/nxp/murata/files
        install -m 777 ${S}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}/${base_libdir}/firmware/nxp/murata/files
        install -m 755 ${S}/nxp-linux-calibration/murata/switch_regions.sh ${D}/usr/sbin/switch_regions.sh
        install -m 444 ${S}/nxp-linux-calibration/murata/README.txt ${D}/${base_libdir}/firmware/nxp/murata/README.txt
}

PACKAGES =+ "${PN}-mfgtest"

FILES:${PN} += "${base_libdir}/firmware"
FILES:${PN} += "${base_libdir}/firmware/*"
FILES:${PN} += "${bindir}"
FILES:${PN} += "${sbindir}"
FILES:${PN} += "{sysconfdir}/firmware"
FILES:${PN} += "${base_libdir}"
FILES:${PN} += "{sysconfdir}/firmware/nxp"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata/files"
FILES:${PN} += "{sysconfdir}/firmware/nxp/murata/1XK"
#FILES:${PN} += "${D}/usr/sbin/switch_module.sh"
#FILES:${PN} += "/usr/sbin/wpa_supplicant"

INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN} += "file-rdeps"

