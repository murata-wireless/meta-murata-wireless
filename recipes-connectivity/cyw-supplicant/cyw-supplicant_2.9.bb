SUMMARY = "Client for Wi-Fi Protected Access (WPA)"
HOMEPAGE = "http://w1.fi/wpa_supplicant/"
BUGTRACKER = "http://w1.fi/security/"
SECTION = "network"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://COPYING;md5=279b4f5abb9c153c285221855ddb78cc\
                    file://README;beginline=1;endline=56;md5=e7d3dbb01f75f0b9799e192731d1e1ff \
                    file://wpa_supplicant/wpa_supplicant.c;beginline=1;endline=12;md5=0a8b56d3543498b742b9c0e94cc2d18b"
DEPENDS = "dbus libnl openssl"
#RRECOMMENDS_${PN} = "wpa-supplicant-passphrase wpa-supplicant-cli"

PACKAGECONFIG ??= "gnutls"
PACKAGECONFIG[gnutls] = ",,gnutls libgcrypt"
PACKAGECONFIG[openssl] = ",,openssl"

inherit pkgconfig

#SYSTEMD_SERVICE_${PN} = "wpa_supplicant.service wpa_supplicant-nl80211@.service wpa_supplicant-wired@.service"
#SYSTEMD_AUTO_ENABLE = "disable"

SRC_URI = "http://w1.fi/releases/wpa_supplicant-${PV}.tar.gz  \
           file://defconfig \
           file://wpa-supplicant.sh \
           file://wpa_supplicant.conf \
           file://wpa_supplicant.conf-sane \
           file://99_wpa_supplicant \
	   file://0001-wpa_supplicant-Support-4-way-handshake-offload-for-F.patch;apply=yes \
	   file://0002-wpa_supplicant-Notify-Neighbor-Report-for-driver-tri.patch;apply=yes \
	   file://0003-nl80211-Report-connection-authorized-in-EVENT_ASSOC.patch;apply=yes \
	   file://0004-wpa_supplicant-Add-PMKSA-cache-for-802.1X-4-way-hand.patch;apply=yes \
	   file://0005-Sync-with-mac80211-next.git-include-uapi-linux-nl802.patch;apply=yes \  
	   file://0006-nl80211-Check-SAE-authentication-offload-support.patch;apply=yes \
	   file://0007-SAE-Pass-SAE-password-on-connect-for-SAE-authenticat.patch;apply=yes \
           file://0008-OpenSSL-Fix-build-with-OpenSSL-1.0.1.patch;apply=yes \
	   file://0009-non-upstream-Sync-nl80211.h-for-PSK-4-way-HS-offload.patch;apply=yes \
	   file://0010-nl80211-Support-4-way-handshake-offload-for-WPA-WPA2.patch;apply=yes \
	   file://0011-AP-Support-4-way-handshake-offload-for-WPA-WPA2-PSK.patch;apply=yes \
	   file://0012-nl80211-Support-SAE-authentication-offload-in-AP-mod.patch;apply=yes \
	   file://0013-SAE-Support-SAE-authentication-offload-in-AP-mode.patch;apply=yes \
	   file://0014-P2P-Fix-P2P-authentication-failure-due-to-AP-mode-4-.patch;apply=yes \
	   file://0015-AP-Silently-ignore-management-frame-from-unexpected-.patch;apply=yes \
	   file://0016-DPP-Do-more-condition-test-for-AKM-type-DPP-offload.patch;apply=yes \
"

SRC_URI[md5sum] = "2d2958c782576dc9901092fbfecb4190"
SRC_URI[sha256sum] = "fcbdee7b4a64bea8177973299c8c824419c413ec2e3a95db63dd6a5dc3541f17"

CVE_PRODUCT = "wpa_supplicant"

S = "${WORKDIR}/wpa_supplicant-${PV}"

do_configure () {
	${MAKE} -C wpa_supplicant clean
	install -m 0755 ${WORKDIR}/defconfig wpa_supplicant/.config
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> wpa_supplicant/.config
	echo "DRV_CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> wpa_supplicant/.config
	
	if echo "${PACKAGECONFIG}" | grep -qw "openssl"; then
        	ssl=openssl
	elif echo "${PACKAGECONFIG}" | grep -qw "gnutls"; then
        	ssl=gnutls
	fi
	if [ -n "$ssl" ]; then
        	sed -i "s/%ssl%/$ssl/" wpa_supplicant/.config
	fi

	# For rebuild
	rm -f wpa_supplicant/*.d wpa_supplicant/dbus/*.d
}

export EXTRA_CFLAGS = "${CFLAGS}"
export BINDIR = "${sbindir}"

do_compile () {
	unset CFLAGS CPPFLAGS CXXFLAGS
	sed -e "s:CFLAGS\ =.*:& \$(EXTRA_CFLAGS):g" -i ${S}/src/lib.rules
	oe_runmake -C wpa_supplicant
}

do_install () {
	echo "Compiling: "
        echo "ARCH: ${ARCH} "
	install -d ${D}${sbindir}
	install -m 755 wpa_supplicant/wpa_supplicant ${D}${sbindir}/wpa_supplicant.cyw
}

pkg_postinst_wpa-supplicant () {
	# If we're offline, we don't need to do this.
	if [ "x$D" = "x" ]; then
		killall -q -HUP dbus-daemon || true
	fi

}
