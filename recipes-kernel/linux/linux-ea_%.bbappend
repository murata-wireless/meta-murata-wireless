FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://wifi.cfg"
SRC_URI:append = " file://0001-patch-longma-fmac.patch \
                   file://0002-murata-customized-string.patch \
                   file://0004-wifi-brcmfmac-add-missing-header-include-for-brcmf_d.patch \
                   file://0008-Patch-for-CYW4373-hci-up-fail-issue.patch \
                   file://0001-ifx-dts-mods-for-8m-mini.patch \
"

#SRC_URI:append = " file://0003-murata-1XL-hex.patch \
#"
