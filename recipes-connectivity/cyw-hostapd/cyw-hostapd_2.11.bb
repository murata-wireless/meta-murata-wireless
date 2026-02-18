SUMMARY = "User space daemon for extended IEEE 802.11 management"
HOMEPAGE = "http://w1.fi/hostapd/"
SECTION = "kernel/userland"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://hostapd/README;beginline=5;endline=47;md5=8e2c69e491b28390f9de0df1f64ebd6d"

DEPENDS = "libnl openssl"

SRC_URI = " \
	   http://w1.fi/releases/hostapd-${PV}.tar.gz \
	   file://defconfig_base \
	   file://init \
	   file://hostapd.service \
	   file://0000-hostapd.patch;apply=yes \
"

SRC_URI[sha256sum] = "2b3facb632fd4f65e32f4bf82a76b4b72c501f995a4f62e330219fe7aed1747a"

S = "${WORKDIR}/hostapd-${PV}"
B = "${WORKDIR}/hostapd-${PV}/hostapd"

inherit update-rc.d systemd pkgconfig features_check

CONFLICT_DISTRO_FEATURES = "openssl-no-weak-ciphers"

INITSCRIPT_NAME = "hostapd"

do_configure:append() {
#    echo "WORKDIR: VKJB: ${WORKDIR}"
    install -m 0644 ${UNPACKDIR}/defconfig_base ${B}/.config
}

do_compile() {
    export CFLAGS="-MMD -O2 -Wall -g"
    export EXTRA_CFLAGS="${CFLAGS}"
    make V=1
}

do_install() {
    install -d ${D}${sbindir}
    install -d ${D}/usr/share/murata_wireless

    install -m 0755 ${B}/hostapd ${D}${sbindir}/hostapd.cyw
    install -m 0755 ${B}/hostapd_cli ${D}/usr/share/murata_wireless/hostapd_cli.cyw
}

FILES:${PN} += "${sbindir}/hostapd.cyw"
FILES:${PN} += "usr/share/murata_wireless"
