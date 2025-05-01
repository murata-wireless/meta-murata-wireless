do_install:append () {
    	install -d ${D}${sbindir}
	install -m 755 ${D}${sbindir}/hostapd ${D}${sbindir}/hostapd.nxp
	install -m 755 ${D}${sbindir}/hostapd_cli ${D}${sbindir}/hostapd_cli.nxp
        rm ${D}${sbindir}/hostapd
	rm ${D}${sbindir}/hostapd_cli
}

FILES:${PN} += "/usr/bin/hostapd.nxp"
FILES:${PN} += "/usr/bin/hostapd_cli.nxp"
