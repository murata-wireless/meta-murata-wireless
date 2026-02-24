SUMMARY = "Infineon wl tool (userspace)"
HOMEPAGE = "https://github.com/Infineon/wl_tool"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://wl/src/Makefile;md5=5c4c235684aa751e990632f19cb3f25d"

SRC_URI = "git://github.com/Infineon/wl_tool.git;protocol=https;branch=main"
SRCREV = "f52bf6b8b41e84d0329720a85f1711d573c4cd70"
PV = "1.0+git${SRCPV}"

DEPENDS += "libnl"

S = "${WORKDIR}/git/wl/src"

WL_TARGETARCH:aarch64 = "arm64"
WL_TARGETARCH:arm     = "arm_le"

EXTRA_OEMAKE += "TARGETARCH=${WL_TARGETARCH} APPLY_PREFIX=false NL80211=1"

do_compile() {
    oe_runmake -f linux_external.mk ${EXTRA_OEMAKE}
}

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${S}/wl_tool_NL80211 ${D}${sbindir}/wl
}

FILES:${PN} += "${sbindir}/wl"
