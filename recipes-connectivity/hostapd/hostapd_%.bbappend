do_install_append () {
    	install -d ${D}${sbindir}
	install -m 755 ${D}${sbindir}/hostapd ${D}${sbindir}/hostapd.nxp
        rm ${D}${sbindir}/hostapd
}

FILES_${PN} += "/usr/bin/hostapd.nxp"
