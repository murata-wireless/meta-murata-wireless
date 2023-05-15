do_install:append() {
	# Remove pointless bash script
	rm -r ${D}/lib/firmware/brcm
	rm -r ${D}/lib/firmware/liquidio
	rm -r ${D}/lib/firmware/matrox
	rm -r ${D}/lib/firmware/mediatek
	rm -r ${D}/lib/firmware/mellanox
	rm -r ${D}/lib/firmware/meson
	rm -r ${D}/lib/firmware/microchip
	rm -r ${D}/lib/firmware/moxa
	rm -r ${D}/lib/firmware/mrvl
	rm -r ${D}/lib/firmware/vicam
	rm -r ${D}/lib/firmware/vxge
	rm -r ${D}/lib/firmware/wfx
	rm -r ${D}/lib/firmware/yam
	rm -r ${D}/lib/firmware/yamaha
	rm -r ${D}/lib/firmware/iwlwifi*
	rm -r ${D}/lib/firmware/LICENSE*
}

FILES_${PN} += "/lib/firmware/brcm"
FILES_${PN} += "/lib/firmware/brcm/murata_NVRAM"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
#FILES_${PN} += "${bindir}"
#FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"
#FILES_${PN} += "/etc/firmware"
