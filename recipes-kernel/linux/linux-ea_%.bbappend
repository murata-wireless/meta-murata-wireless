FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://wifi.cfg"
SRC_URI:append = " file://0001-patch-jaculus-fmac-6-6-23.patch \
"
