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
	   file://udhcpd.conf \
	   file://0000-hostapd.patch;apply=yes \
"


SRC_URI[sha256sum] = "2b3facb632fd4f65e32f4bf82a76b4b72c501f995a4f62e330219fe7aed1747a"

S = "${WORKDIR}/hostapd-${PV}"
B = "${WORKDIR}/hostapd-${PV}/hostapd"

inherit update-rc.d systemd pkgconfig features_check

CONFLICT_DISTRO_FEATURES = "openssl-no-weak-ciphers"

INITSCRIPT_NAME = "hostapd"

SYSTEMD_SERVICE:${PN} = "hostapd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_configure:append() {
    install -m 0644 ${WORKDIR}/defconfig_base ${B}/.config
}

do_compile() {
    export CFLAGS="-MMD -O2 -Wall -g"
    export EXTRA_CFLAGS="${CFLAGS}"
    make V=1
}

do_install() {
    install -d ${D}${sbindir} ${D}${sysconfdir}/init.d ${D}${systemd_unitdir}/system/
    install -m 0644 ${B}/hostapd.conf ${D}${sysconfdir}
#   Adding udhcdp.conf
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}

    install -m 0755 ${B}/hostapd ${D}${sbindir}/hostapd
    install -m 0755 ${B}/hostapd_cli ${D}${sbindir}/hostapd_cli
    install -m 755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/hostapd
    install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system/
    sed -i -e 's,@SBINDIR@,${sbindir},g' -e 's,@SYSCONFDIR@,${sysconfdir},g' ${D}${systemd_unitdir}/system/hostapd.service
}

CONFFILES:${PN} += "${sysconfdir}/hostapd.conf"
