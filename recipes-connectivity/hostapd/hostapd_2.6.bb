HOMEPAGE = "http://w1.fi/hostapd/"
SECTION = "kernel/userland"
LICENSE = "GPLv2 | BSD"
LIC_FILES_CHKSUM = "file://${B}/README;md5=8aa4e8c78b59b12016c4cb2d0a8db350"
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
    file://0001-hostapd-Avoid-key-reinstallation-in-FT-handshake.patch;apply=yes \
    file://0002-Prevent-reinstallation-of-an-already-in-use-group-ke.patch;apply=yes \
    file://0003-Extend-protection-of-GTK-IGTK-reinstallation-of-WNM-.patch;apply=yes \
    file://0004-Prevent-installation-of-an-all-zero-TK.patch;apply=yes \
    file://0005-Fix-PTK-rekeying-to-generate-a-new-ANonce.patch;apply=yes \
    file://0006-TDLS-Reject-TPK-TK-reconfiguration.patch;apply=yes \
    file://0008-FT-Do-not-allow-multiple-Reassociation-Response-fram.patch;apply=yes \
    file://0009-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0010-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0011-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0012-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0013-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0014-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0015-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0016-driver_nl80211-support-passing-PSK-on-connect.patch;apply=yes \
    file://0017-driver_nl80211-check-4-way-handshake-offload-support.patch;apply=yes \
    file://0018-nl80211-Add-API-to-set-the-PMK-to-the-driver.patch;apply=yes \
    file://0019-driver-Add-port-authorized-event.patch;apply=yes \
    file://0020-nl80211-Handle-port-authorized-event.patch;apply=yes \
    file://0021-murata-hostapd-conf.patch;apply=yes \
    file://0023-driver_nl80211-Fix-802.1X-auth-failure-when-offloadi.patch;apply=yes \
    file://0024-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0025-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0026-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \
    file://0031-nl80211-Use-RSN_AUTH_KEY_MGMT_-instead-of-WLAN_AKM_S.patch;apply=yes \
    file://0032-non-upstream-Sync-with-Linux-kernel-nl80211.h-for-SA.patch;apply=yes \
    file://0033-nl80211-Check-SAE-authentication-offload-support.patch;apply=yes \
    file://0034-SAE-Pass-SAE-password-on-connect-for-SAE-authenticat.patch;apply=yes \
    file://0035-WPA-Ignore-unauthenticated-encrypted-EAPOL-Key-data.patch;apply=yes \
    file://0036-murata-undefined-macro-error-with-wpa_supplicant_and_hostapd.patch;apply=yes \
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

SRC_URI[md5sum] = "eaa56dce9bd8f1d195eb62596eab34c7"
SRC_URI[sha256sum] = "01526b90c1d23bec4b0f052039cc4456c2fd19347b4d830d1d58a0a6aea7117d"
