# Released under the MIT license (see COPYING.MIT for the terms)


DESCRIPTION = "Cypress Orga Wi-Fi driver backport recipe"
HOMEPAGE = "https://github.com/murata-wireless"
SECTION = "kernel/modules"
LICENSE = "GPLv2"


LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

# Points to Kong FMAC source code
SRC_URI =  " \
    git://github.com/murata-wireless/cyw-fmac;protocol=http;branch=imx-rocko-kong \
    file://0001-kernel_change_for_fmac_log_string.patch;apply=yes \
"
SRCREV = "159cbae033dc771b7e03216a9f8fb2bc05f9c253"


S = "${WORKDIR}/git"


EXTRA_OEMAKE = "KLIB_BUILD=${STAGING_KERNEL_DIR} KLIB=${D} DESTDIR=${D}"

DEPENDS += "virtual/kernel bison-native flex-native coreutils-native "
inherit module-base
addtask make_scripts after do_patch before do_configure
do_make_scripts[lockfiles] = "${TMPDIR}/kernel-scripts.lock"
do_make_scripts[deptask] = "do_populate_sysroot"


do_configure_prepend() {
	chmod -R 777 ./
	cp ${STAGING_KERNEL_BUILDDIR}/.config ${STAGING_KERNEL_DIR}/.config
	CC=${BUILD_CC} oe_runmake defconfig-brcmfmac
}

do_configure_append() {
	oe_runmake	
}


FILES_${PN} += "${nonarch_base_libdir}/udev \
                ${sysconfdir}/udev \
				${nonarch_base_libdir} \
               "

do_compile() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake KERNEL_PATH=${STAGING_KERNEL_DIR}   \
		   KERNEL_SRC=${STAGING_KERNEL_DIR}    \
		   KERNEL_VERSION=${KERNEL_VERSION}    \
		   CC="${KERNEL_CC}" LD="${KERNEL_LD}" \
		   AR="${KERNEL_AR}" \
		   ${MAKE_TARGETS}
}

do_install() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake DEPMOD=echo INSTALL_MOD_PATH="${D}" \
	           KERNEL_SRC=${STAGING_KERNEL_DIR} \
	           CC="${KERNEL_CC}" LD="${KERNEL_LD}" \
	           modules_install
	rm ${STAGING_KERNEL_DIR}/.config
}

