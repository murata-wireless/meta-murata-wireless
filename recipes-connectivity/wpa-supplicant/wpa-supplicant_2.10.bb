SUMMARY = "Client for Wi-Fi Protected Access (WPA)"
HOMEPAGE = "http://w1.fi/wpa_supplicant/"
DESCRIPTION = "wpa_supplicant is a WPA Supplicant for Linux, BSD, Mac OS X, and Windows with support for WPA and WPA2 (IEEE 802.11i / RSN). Supplicant is the IEEE 802.1X/WPA component that is used in the client stations. It implements key negotiation with a WPA Authenticator and it controls the roaming and IEEE 802.11 authentication/association of the wlan driver."
BUGTRACKER = "http://w1.fi/security/"
SECTION = "network"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYING;md5=5ebcb90236d1ad640558c3d3cd3035df \
                    file://README;beginline=1;endline=56;md5=e3d2f6c2948991e37c1ca4960de84747 \
                    file://wpa_supplicant/wpa_supplicant.c;beginline=1;endline=12;md5=76306a95306fee9a976b0ac1be70f705"
DEPENDS = "dbus libnl"
#RRECOMMENDS:${PN} = "wpa-supplicant-passphrase wpa-supplicant-cli"

PACKAGECONFIG ??= "openssl"
PACKAGECONFIG[gnutls] = ",,gnutls libgcrypt"
PACKAGECONFIG[openssl] = ",,openssl"

inherit pkgconfig systemd

#SYSTEMD_SERVICE:${PN} = "wpa_supplicant.service"
#SYSTEMD_AUTO_ENABLE = "disable"

SRC_URI = "http://w1.fi/releases/wpa_supplicant-${PV}.tar.gz \
           file://defconfig \
           file://wpa-supplicant.sh \
           file://wpa_supplicant.conf \
           file://wpa_supplicant.conf-sane \
           file://99_wpa_supplicant \
	   file://0001-wpa_supplicant-Support-4-way-handshake-offload-for-F.patch;apply=yes \
	   file://0002-wpa_supplicant-Notify-Neighbor-Report-for-driver-tri.patch;apply=yes \
	   file://0003-nl80211-Report-connection-authorized-in-EVENT_ASSOC.patch;apply=yes \
	   file://0004-wpa_supplicant-Add-PMKSA-cache-for-802.1X-4-way-hand.patch;apply=yes \
	   file://0005-OpenSSL-Fix-build-with-OpenSSL-1.0.1.patch;apply=yes \
	   file://0006-nl80211-Check-SAE-authentication-offload-support.patch;apply=yes \
	   file://0007-SAE-Pass-SAE-password-on-connect-for-SAE-authenticat.patch;apply=yes \
	   file://0008-nl80211-Support-4-way-handshake-offload-for-WPA-WPA2.patch;apply=yes \
	   file://0009-AP-Support-4-way-handshake-offload-for-WPA-WPA2-PSK.patch;apply=yes \
	   file://0010-nl80211-Support-SAE-authentication-offload-in-AP-mod.patch;apply=yes \
	   file://0011-SAE-Support-SAE-authentication-offload-in-AP-mode.patch;apply=yes \
	   file://0012-DPP-Do-more-condition-test-for-AKM-type-DPP-offload.patch;apply=yes \
	   file://0013-non-upstream-defconfig_base-Add-Infineon-default-con.patch;apply=yes \
	   file://0014-CVE_2019_9501-Fix-to-check-Invalid-GTK-IE-length-in-.patch;apply=yes \
	   file://0015-Add-CONFIG_WPA3_SAE_AUTH_EARLY_SET-flags-and-codes.murata.patch;apply=yes \
	   file://0016-SAE-Set-the-right-WPA-Versions-for-FT-SAE-key-manage.patch;apply=yes \
	   file://0017-wpa_supplicant-Support-WPA_KEY_MGMT_FT-for-eapol-off.patch;apply=yes \
	   file://0018-wpa_supplicant-suppress-deauth-for-PMKSA-caching-dis.patch;apply=yes \
	   file://0019-Fix-for-PMK-expiration-issue-through-supplicant.murata.patch;apply=yes \
	   file://0020-SAE-Drop-PMKSA-cache-after-receiving-specific-deauth.patch;apply=yes \
	   file://0021-Avoid-deauthenticating-STA-if-the-reason-for-freeing.patch;apply=yes \
	   file://0022-wpa_supplicant-support-bgscan.patch;apply=yes \
	   file://0023-non-upstream-wl-cmd-create-interface-to-support-driv.murata.patch;apply=yes \
	   file://0024-non-upstream-wl-cmd-create-wl_do_cmd-as-an-entry-doi.patch;apply=yes \
	   file://0025-non-upstream-wl-cmd-create-ops-table-to-do-wl-comman.patch;apply=yes \
	   file://0026-non-upstream-wl-cmd-add-more-compile-flag.patch;apply=yes \
	   file://0027-Fix-dpp-config-parameter-setting.patch;apply=yes \
	   file://0028-DPP-Resolving-failure-of-dpp-configurator-exchange-f.patch;apply=yes \
	   file://0029-Enabling-SUITEB192-and-SUITEB-compile-options.patch;apply=yes \
	   file://0030-DPP-Enabling-CLI_EDIT-option-for-enrollee-plus-respo.patch;apply=yes \
	   file://0031-P2P-Fixes-Scan-trigger-failed-once-GC-invited-by-GO.patch;apply=yes \
	   file://0032-non-upstream-SAE-disconnect-after-PMKSA-cache-expire.patch;apply=yes \
	   file://0033-Add-support-for-beacon-loss-roaming.patch;apply=yes \
	   file://0034-wpa_supplicant-Set-PMKSA-to-driver-while-key-mgmt-is.patch;apply=yes \
	   file://0035-nl80211-Set-NL80211_SCAN_FLAG_COLOCATED_6GHZ-in-scan.patch;apply=yes \
	   file://0036-scan-Add-option-to-disable-6-GHz-collocated-scanning.patch;apply=yes \
	   file://0037-Enabling-OWE-in-wpa_supplicant.patch;apply=yes \
	   file://0038-Add-link-loss-timer-on-beacon-loss.patch;apply=yes \
	   file://0039-FT-Sync-nl80211-ext-feature-index.patch;apply=yes \
	   file://0040-nl80211-Introduce-a-vendor-header-for-vendor-NL-ifac.patch;apply=yes \
	   file://0041-add-support-to-offload-TWT-setup-request-handling-to.patch;apply=yes \
	   file://0042-add-support-to-offload-TWT-Teardown-request-handling.patch;apply=yes \
	   file://0043-Add-support-to-configure-TWT-of-a-session-using-offs.patch;apply=yes \
	   file://0044-Establish-a-Default-TWT-session-in-the-STA-after-ass.patch;apply=yes \
	   file://0045-validate-the-TWT-parameters-exponent-and-mantissa-pa.patch;apply=yes \
	   file://0046-Fix-for-station-sending-open-auth-instead-of-SAE-aut.patch;apply=yes \
	   file://0047-Fix-ROAMOFFLOAD-raises-portValid-too-early.patch;apply=yes \
	   file://0048-Fix-associating-failed-when-PMK-lifetime-is-set-to-1.patch;apply=yes \
	   file://0049-non-upstream-p2p_add_group-command-unification.patch;apply=yes \
"

SRC_URI[sha256sum] = "20df7ae5154b3830355f8ab4269123a87affdea59fe74fe9292a91d0d7e17b2f"

CVE_PRODUCT = "wpa_supplicant"

S = "${WORKDIR}/wpa_supplicant-${PV}"

#PACKAGES:prepend = "wpa-supplicant-passphrase wpa-supplicant-cli "
#FILES:wpa-supplicant-passphrase = "${bindir}/wpa_passphrase"
#FILES:wpa-supplicant-cli = "${sbindir}/wpa_cli"
#FILES:${PN} += "${datadir}/dbus-1/system-services/* ${systemd_system_unitdir}/*"
#CONFFILES:${PN} += "${sysconfdir}/wpa_supplicant.conf"

do_configure () {
	${MAKE} -C wpa_supplicant clean
	install -m 0755 ${WORKDIR}/defconfig wpa_supplicant/.config

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

#do_install () {
#	install -d ${D}${sbindir}
#	install -m 755 wpa_supplicant/wpa_supplicant ${D}${sbindir}
#	install -m 755 wpa_supplicant/wpa_cli        ${D}${sbindir}
#
#	install -d ${D}${bindir}
#	install -m 755 wpa_supplicant/wpa_passphrase ${D}${bindir}

#	install -d ${D}${docdir}/wpa_supplicant
#	install -m 644 wpa_supplicant/README ${WORKDIR}/wpa_supplicant.conf ${D}${docdir}/wpa_supplicant

#	install -d ${D}${sysconfdir}
#	install -m 600 ${WORKDIR}/wpa_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant.conf

#	install -d ${D}${sysconfdir}/network/if-pre-up.d/
#	install -d ${D}${sysconfdir}/network/if-post-down.d/
#	install -d ${D}${sysconfdir}/network/if-down.d/
#	install -m 755 ${WORKDIR}/wpa-supplicant.sh ${D}${sysconfdir}/network/if-pre-up.d/wpa-supplicant
#	cd ${D}${sysconfdir}/network/ && \
#	ln -sf ../if-pre-up.d/wpa-supplicant if-post-down.d/wpa-supplicant

#	install -d ${D}/${sysconfdir}/dbus-1/system.d
#	install -m 644 ${S}/wpa_supplicant/dbus/dbus-wpa_supplicant.conf ${D}/${sysconfdir}/dbus-1/system.d
#	install -d ${D}/${datadir}/dbus-1/system-services
#	install -m 644 ${S}/wpa_supplicant/dbus/*.service ${D}/${datadir}/dbus-1/system-services

#	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
#		install -d ${D}/${systemd_system_unitdir}
#		install -m 644 ${S}/wpa_supplicant/systemd/*.service ${D}/${systemd_system_unitdir}
#	fi

#	install -d ${D}/etc/default/volatiles
#	install -m 0644 ${WORKDIR}/99_wpa_supplicant ${D}/etc/default/volatiles
#}

pkg_postinst:${PN} () {
	# If we're offline, we don't need to do this.
	if [ "x$D" = "x" ]; then
		killall -q -HUP dbus-daemon || true
	fi

}

do_install () {
	echo "Compiling: "
        echo "ARCH: ${ARCH} "
	install -d ${D}${sbindir}
	install -m 755 wpa_supplicant/wpa_supplicant ${D}${sbindir}/wpa_supplicant.cyw
        install -m 755 wpa_supplicant/wpa_cli ${D}${sbindir}/wpa_cli.cyw
}

