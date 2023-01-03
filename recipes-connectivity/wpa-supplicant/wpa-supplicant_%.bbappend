do_install:append () {
    	install -d ${D}${sbindir}
	install -m 755 ${D}${sbindir}/wpa_supplicant ${D}${sbindir}/wpa_supplicant.nxp
	install -m 755 ${D}${sbindir}/wpa_cli ${D}${sbindir}/wpa_cli.nxp
        rm ${D}${sbindir}/wpa_supplicant
        rm ${D}${sbindir}/wpa_cli
}

FILES:${PN} += "/usr/bin/wpa_supplicant.nxp"
FILES:${PN} += "/usr/bin/wpa_cli.nxp"
