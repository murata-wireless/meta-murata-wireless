FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://wifi.cfg"
SRC_URI:append = " file://0001-patch-jaculus-fmac-6-6-23.patch \
                   file://0008-Patch-for-CYW4373-hci-up-fail-issue-for-6.6.23.patch \
"

#SRC_URI:append = " file://0001-patch-jaculus-fmac-6-6-23.patch \
#file://0003-murata-2EL-hex.patch \
#"
