HOMEPAGE = "http://w1.fi/hostapd/"
SECTION = "kernel/userland"
LICENSE = "GPLv2 | BSD"
LIC_FILES_CHKSUM = "file://${B}/README;md5=1ec986bec88070e2a59c68c95d763f89"
DEPENDS = "libnl openssl"
SUMMARY = "User space daemon for extended IEEE 802.11 management"

inherit update-rc.d systemd
INITSCRIPT_NAME = "hostapd"

SYSTEMD_SERVICE_${PN} = "hostapd.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

SRC_URI = " \
    http://w1.fi/releases/hostapd-${PV}.tar.gz \
    file://defconfig \
    file://init \
    file://hostapd.service \
    file://0003-nl80211-Report-connection-authorized-in-EVENT_ASSOC.patch;apply=yes \
    file://0005-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0006-nl80211-Check-SAE-authentication-offload-support.patch;apply=yes \
    file://0008-OpenSSL-Fix-build-with-OpenSSL-1.0.1.patch;apply=yes \
    file://0009-non-upstream-Sync-nl80211.h-for-PSK-4-way-HS-offload.patch;apply=yes \
    file://0010-nl80211-Support-4-way-handshake-offload-for-WPA-WPA2.patch;apply=yes \
    file://0011-AP-Support-4-way-handshake-offload-for-WPA-WPA2-PSK.patch;apply=yes \
    file://0012-nl80211-Support-SAE-authentication-offload-in-AP-mod.patch;apply=yes \
    file://0013-SAE-Support-SAE-authentication-offload-in-AP-mode.patch;apply=yes \
    file://0014-P2P-Fix-P2P-authentication-failure-due-to-AP-mode-4-.patch;apply=yes \
    file://0015-AP-Silently-ignore-management-frame-from-unexpected-.patch;apply=yes \
    file://udhcpd.conf \
"

S = "${WORKDIR}/hostapd-${PV}"
B = "${WORKDIR}/hostapd-${PV}/hostapd"

do_configure() {
    install -m 0644 ${WORKDIR}/defconfig ${B}/.config
}

do_compile() {
    export CFLAGS="-MMD -O2 -Wall -g -I${STAGING_INCDIR}/libnl3"
    make
}

do_install() {
    install -d ${D}${sbindir} ${D}${sysconfdir}/init.d ${D}${systemd_unitdir}/system/
    install -m 0644 ${B}/hostapd.conf ${D}${sysconfdir}

#   Adding udhcdp.conf
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}

    install -m 0755 ${B}/hostapd ${D}${sbindir}
    install -m 0755 ${B}/hostapd_cli ${D}${sbindir}
    install -m 755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/hostapd
    install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system/
    sed -i -e 's,@SBINDIR@,${sbindir},g' -e 's,@SYSCONFDIR@,${sysconfdir},g' ${D}${systemd_unitdir}/system/hostapd.service
}

CONFFILES_${PN} += "${sysconfdir}/hostapd.conf"
CONFFILES_${PN} += "${sysconfdir}/udhcpd.conf"

SRC_URI[md5sum] = "f188fc53a495fe7af3b6d77d3c31dee8"
SRC_URI[sha256sum] = "881d7d6a90b2428479288d64233151448f8990ab4958e0ecaca7eeb3c9db2bd7"
