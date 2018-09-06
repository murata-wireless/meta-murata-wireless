# Copyright (C) 2012-2016 Freescale Semiconductor

SUMMARY = "Replacement recipe"

do_install_append() {
        rm -r ${D}/lib/firmware/bcm
        rm ${D}/etc/firmware/*.hcd
}


FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
#FILES_${PN} += "${bindir}"
#FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"

