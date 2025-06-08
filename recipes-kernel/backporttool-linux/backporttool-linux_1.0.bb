# Released under the MIT license (see COPYING.MIT for the terms)


DESCRIPTION = "Cypress Orga Wi-Fi driver backport recipe"
HOMEPAGE = "https://github.com/murata-wireless"
SECTION = "kernel/modules"
LICENSE = "GPL-2.0-only"


LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI =  " \
    https://github.com/Infineon/ifx-backports/archive/refs/tags/release-v6.1.97-2024_1115.tar.gz;protocol=http;destsuffix=cyw-fmac;name=cyw-fmac \
    file://0002-yacc-flex-in-kconf-makefile.patch;apply=yes \
"

SRC_URI[cyw-fmac.sha256sum]="9c09ec7053db61339c7b59c1d5de1d3129fd86edd5bbe952693e3158c9663703"
S = "${WORKDIR}/ifx-backports-release-v6.1.97-2024_1115/v6.1.97-backports"

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

