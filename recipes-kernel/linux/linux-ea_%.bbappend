FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://wifi.cfg"
SRC_URI:append = " file://0001-patch-indrik-fmac-6-1-36.patch \
"
