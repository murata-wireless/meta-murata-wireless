do_install_append() {
	# Remove pointless bash script
	rm -r ${D}/lib/firmware/brcm
	rm -r ${D}/etc/firmware
}

FILES_${PN} += "/lib/firmware/brcm"
FILES_${PN} += "/lib/firmware/brcm/murata_NVRAM"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
FILES_${PN} += "${bindir}"
FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"
FILES_${PN} += "/etc/firmware"
