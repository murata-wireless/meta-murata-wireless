SUMMARY = "Cypress Backport tool"
LICENSE = "GPLv2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"


inherit systemd
inherit native

SYSTEMD_AUTO_ENABLE = "disable"

SRC_URI =  "https://github.com/murata-wireless/cyw-fmac/raw/imx8-morty-battra/imx8-morty-battra_r${PV}.tar.gz;name=archive1"
SRC_URI += "https://github.com/murata-wireless/meta-murata-wireless/raw/imx8-morty-battra/LICENSE;name=archive99"

SRC_URI[archive1.md5sum] = "589ce47e7b9e2d2cdb4169f61cdd8fc2"
SRC_URI[archive1.sha256sum] = "17dcabd5a8b309127579641b05f2d616ace7abbc407e9598e539d6e0569f14f2"

#LICENSE
SRC_URI[archive99.md5sum] = "b234ee4d69f5fce4486a80fdaf4a4263"
SRC_URI[archive99.sha256sum] = "8177f97513213526df2cf6184d8ff986c675afb514d4e68a404010521b880643"

S = "${WORKDIR}/backporttool-native-${PV}"
B = "${WORKDIR}/backporttool-native-${PV}/"

DEPENDS = "linux-imx"

do_configure () {
	echo "Configuring"
        echo "KLIB:       ${KLIB}"
        echo "KLIB_BUILD: ${KLIB_BUILD} "
}

export EXTRA_CFLAGS = "${CFLAGS}"
export BINDIR = "${sbindir}"
#KLIB="${TMPDIR}/work-shared/${MACHINE}/kernel-source"
#KLIB_BUILD="${TMPDIR}/work/imx8mqevk-poky-linux/linux-imx/4.9.51-r0/build"

do_compile () {
	echo "Compiling: "
        #echo "Testing Make Display:: ${MAKE}"
        pwd

        echo "KLIB:       ${KLIB}"
        echo "KLIB_BUILD: ${KLIB_BUILD} "
        echo "KBUILD_OUTPUT: ${KBUILD_OUTPUT}"

        cp -a ${TMPDIR}/work/x86_64-linux/backporttool-native/1.0-r0/imx8-morty-battra_r1.0/. .

        oe_runmake KLIB="${STAGING_KERNEL_DIR}" KLIB_BUILD="${STAGING_KERNEL_BUILDDIR}" defconfig-brcmfmac

#        oe_runmake KLIB="${TMPDIR}/work-shared/${MACHINE}/kernel-source" \
#KLIB_BUILD="${TMPDIR}/work/imx8mqevk-poky-linux/linux-imx/4.9.51-r0/build" \
#defconfig-brcmfmac
}

do_install () {
	echo "Installing: "

        install -d ${D}${sbindir}

#       Copies .config into /murata folder
#        install -m 0644 ${S}/.config ${D}${sbindir}
}

FILES_${PN} += "${sbindir}"
PACKAGES += "FILES-${PN}"


