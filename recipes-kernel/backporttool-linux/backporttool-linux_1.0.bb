# Released under the MIT license (see COPYING.MIT for the terms)


DESCRIPTION = "Cypress Orga Wi-Fi driver backport recipe"
HOMEPAGE = "https://github.com/murata-wireless"
SECTION = "kernel/modules"
LICENSE = "GPL-2.0-only"


LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI =  " \
    git://github.com/murata-wireless/cyw-fmac;protocol=http;branch=imx-langdale-godzilla \
    file://0001-backports-pkg-for-6.1.1.patch;apply=yes \
    file://0002-yacc-flex-in-kconf-makefile.patch;apply=yes \
    file://0003-kernel_change_for_fmac_log_string.patch;apply=yes \
"

SRCREV = "d23cd1725e9cd3b1d0518f47a2cae4bcd8c62c92"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "KLIB_BUILD=${STAGING_KERNEL_DIR} KLIB=${D} DESTDIR=${D}"

DEPENDS += "virtual/kernel bison-native flex-native"
inherit module-base
#addtask make_scripts after do_patch before do_configure
#do_make_scripts[lockfiles] = "${TMPDIR}/kernel-scripts.lock"
#do_make_scripts[deptask] = "do_populate_sysroot"

do_configure:prepend() {
	chmod -R 777 ./
	cp ${STAGING_KERNEL_BUILDDIR}/.config ${STAGING_KERNEL_DIR}/.config
	CC=${BUILD_CC} oe_runmake defconfig-brcmfmac
}

do_configure:append() {
	oe_runmake	
}

FILES:${PN} += "${nonarch_base_libdir}/udev \
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

