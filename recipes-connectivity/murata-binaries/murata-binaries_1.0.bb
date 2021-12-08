SUMMARY = "Murata Binaries"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

SRC_URI = " \
	git://github.com/murata-wireless/nxp-linux-calibration;protocol=http;branch=master;destsuffix=nxp-linux-calibration;name=nxp-linux-calibration \
        git://github.com/jameel-kareem3/cyw-fmac-fw;protocol=http;branch=cynder;destsuffix=cyw-fmac-fw;name=cyw-fmac-fw \
        git://github.com/jameel-kareem3/cyw-fmac-nvram;protocol=http;branch=cynder;destsuffix=cyw-fmac-nvram;name=cyw-fmac-nvram \
        git://github.com/jameel-kareem3/cyw-bt-patch;protocol=http;branch=hardknott-cynder;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        git://github.com/jameel-kareem3/cyw-fmac-utils-imx32;protocol=http;branch=cynder;destsuffix=cyw-fmac-utils-imx32;name=cyw-fmac-utils-imx32 \
        git://github.com/jameel-kareem3/cyw-fmac-utils-imx64;protocol=http;branch=cynder;destsuffix=cyw-fmac-utils-imx64;name=cyw-fmac-utils-imx64 \
	file://switch_module.sh \
	file://WlanCalData_ext_2ANT_Dedicated_BT_1XK.conf \
"

SRCREV_nxp-linux-calibration="7c0c175f6544aad35e26e8ce9c44c839d20da290"
SRCREV_cyw-fmac-fw="86addd0f77da2fc8f9d3743d3bad317348d7e0f8"
SRCREV_cyw-fmac-nvram="a8f7498173b23a2f754763d2e15ea53d9fb8f84d"
SRCREV_cyw-bt-patch="5b3cbf7b95efdc8015e5f41d1ed10bfbd9ef4464"
SRCREV_cyw-fmac-utils-imx32="e248804b6ba386fedcd462ddd9394f42f73a17af"
SRCREV_cyw-fmac-utils-imx64="1bc78d68f9609290b2f6578516011c57691f7815"

SRCREV_default = "${AUTOREV}"

S = "${WORKDIR}"
B = "${WORKDIR}"
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

PACKAGES_prepend = "murata-binaries-wlarm "
FILES_murata-binaries-wlarm = "${bindir}/wlarm"

DO_INSTALL_64BIT_BINARIES = "no"
DO_INSTALL_64BIT_BINARIES_mx6 = "no"
DO_INSTALL_64BIT_BINARIES_mx7 = "no"
DO_INSTALL_64BIT_BINARIES_mx8 = "yes"

do_install () {
	echo "Installing: "
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

# 	Added Calibration configuration file for 1YM(NXP)
#	install -m 444 ${S}/10-network.rules                  ${D}${sysconfdir}/udev/rules.d/10-network.rules


#	Based on MACHINE type
	install -m 755 ${S}/switch_module.sh ${D}/usr/sbin/switch_module.sh

#	Install nxp linux calibration files
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1XK/* ${D}/lib/firmware/nxp/murata/files/1XK
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1YM/* ${D}/lib/firmware/nxp/murata/files/1YM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/1ZM/* ${D}/lib/firmware/nxp/murata/files/1ZM
	install -m 444 ${S}/nxp-linux-calibration/murata/files/2DS/* ${D}/lib/firmware/nxp/murata/files/2DS
        #       Copying wl tool binary based on 32-bit/64-bit arch to /usr/sbin
        if [ ${TARGET_ARCH} = "aarch64" ]; then
		install -m 444 ${S}/nxp-linux-calibration/murata/files/64_bit/* ${D}/lib/firmware/nxp/murata/files/64_bit
	else
		install -m 444 ${S}/nxp-linux-calibration/murata/files/32_bit/* ${D}/lib/firmware/nxp/murata/files/32_bit
	fi

	install -m 444 ${S}/nxp-linux-calibration/murata/files/bt_power_config_1.sh ${D}/lib/firmware/nxp/murata/files
        install -m 444 ${S}/nxp-linux-calibration/murata/files/regulatory.rules ${D}/lib/firmware/nxp/murata/files
        install -m 444 ${S}/nxp-linux-calibration/murata/files/wifi_mod_para_murata.conf ${D}/lib/firmware/nxp/murata/files
        install -m 444 ${S}/nxp-linux-calibration/murata/switch_regions.sh ${D}/lib/firmware/nxp/murata

        install -m 444 ${S}/nxp-linux-calibration/README.txt   ${D}/lib/firmware/nxp/murata/README.txt

#	Copy 1XK Dedicated Bluetooth Antenna configuration file
	install -m 755 ${S}/WlanCalData_ext_2ANT_Dedicated_BT_1XK.conf ${D}/lib/firmware/nxp/
}

PACKAGES =+ "${PN}-mfgtest"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
FILES_${PN} += "${bindir}"
FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"
FILES_${PN} += "{sysconfdir}/firmware/nxp"
FILES_${PN} += "{sysconfdir}/firmware/nxp/murata"
FILES_${PN} += "{sysconfdir}/firmware/nxp/murata/files"
FILES_${PN} += "{sysconfdir}/firmware/nxp/murata/1XK"
#FILES_${PN} += "/usr/sbin/wpa_supplicant"

FILES_${PN}-mfgtest = " \
	/usr/bin/wl \
"

INSANE_SKIP_${PN} += "build-deps"
INSANE_SKIP_${PN} += "file-rdeps"

