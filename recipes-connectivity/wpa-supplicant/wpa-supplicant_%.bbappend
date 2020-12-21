do_install_append () {
    	install -d ${D}${sbindir}
	install -m 755 ${D}${sbindir}/wpa_supplicant ${D}${sbindir}/wpa_supplicant.nxp
        rm ${D}${sbindir}/wpa_supplicant
}

FILES_${PN} += "/usr/bin/wpa_supplicant.nxp"
