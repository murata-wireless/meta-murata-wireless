SUMMARY = "Infineon wl tool (userspace)"
HOMEPAGE = "https://github.com/Infineon/wl_tool"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://Makefile;md5=5c4c235684aa751e990632f19cb3f25d"

SRC_URI = "git://github.com/Infineon/wl_tool.git;protocol=https;branch=main \
           file://0001-wlu-fix-inttypes.patch \
"

SRCREV = "f52bf6b8b41e84d0329720a85f1711d573c4cd70"
PV = "1.0+git${SRCPV}"

S = "${WORKDIR}/git/wl/src"

inherit pkgconfig
DEPENDS += "libnl pkgconfig-native"

WL_TARGETARCH:aarch64 = "arm64"
WL_TARGETARCH:arm     = "arm_le"

do_configure[noexec] = "1"

# 1. Ensure global variables are set cleanly
DEPENDS += "libnl"

B_ARCH = "${@'arm64' if d.getVar('TARGET_ARCH') == 'aarch64' else 'arm'}"

# 2. Re-stabilize EXTRA_OEMAKE back to its basic arguments without CFLAGS/CPPFLAGS overrides
EXTRA_OEMAKE = "TARGETARCH=${B_ARCH} APPLY_PREFIX=false NL80211=1"

# 1. Clean compiler variable wrapper with header paths
EXTRA_OEMAKE += "CC='${CC} -I${STAGING_INCDIR}/libnl3'"

# 2. Force the libraries directly into the Linker tool command
EXTRA_OEMAKE += "LD='${CC} ${LDFLAGS} -lnl-3 -lnl-genl-3'"

TARGET_CFLAGS += "-Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration -Wno-error=stringop-truncation"

TARGET_CFLAGS += "-D_GNU_SOURCE -Dipv6_hdr=ipv6hdr"

do_compile:prepend() {

    # Dynamically inject the missing layout right into bcmutils.c before compilation starts
    if [ "${B_ARCH}" = "arm" ]; then
        sed -i '/#include <bcmutils.h>/a struct ipv6_hdr { unsigned char p:4, v:4; unsigned char f[3]; unsigned short payload_len; unsigned char nexthdr; unsigned char h; struct { unsigned char addr[16]; } saddr; struct { unsigned char addr[16]; } daddr; };' ${S}/bcmutils.c
    fi
    
    # Dynamically link netlink headers into a standard shared folder path
    ln -sf ${STAGING_INCDIR}/libnl3/netlink ${STAGING_INCDIR}/netlink
}

do_compile() {
    oe_runmake -f linux_external.mk
}

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${S}/wl_tool_NL80211 ${D}${sbindir}/wl
}

FILES:${PN} += "${sbindir}/wl"
INSANE_SKIP:${PN}-dbg += "buildpaths"
INSANE_SKIP:${PN} = "ldflags"

