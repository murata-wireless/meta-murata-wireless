require recipes-connectivity/nxp-wlan-sdk/iw612-sdk_git.inc

SUMMARY = "NXP Wi-Fi driver for module IW612"

INHIBIT_PACKAGE_STRIP = "1"

#inherit module

#EXTRA_OEMAKE += "-C ${STAGING_KERNEL_BUILDDIR} M=${S}"

inherit module-base

TARGET_CC_ARCH += "${LDFLAGS}"

RDEPENDS_${PN} += "bash"


DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
    KERNELDIR=${STAGING_KERNEL_BUILDDIR} \
"

do_compile:prepend () {
    # Change build folder to iw612 folder
    
    cd ${S}

    if [ ${TARGET_ARCH} = "aarch64" ]; then
	echo "DEBUG:: In AARCH64"
       	export ARCH=arm64
    	export CROSS_COMPILE="${TARGET_PREFIX}"
    else
	echo "DEBUG:: In ARM"
	export ARCH=arm
	export CROSS_COMPILE=arm-poky-linux-gnueabi-
    fi

    oe_runmake build
}


do_install () {
    # install ko and configs to rootfs
    install -d ${D}${datadir}/murata_wireless

    echo "PWD: ${S}"
    install -m 0755  ${S}/mlan.ko ${D}${datadir}/murata_wireless
    install -m 0755  ${S}/sdxxx.ko ${D}${datadir}/murata_wireless
}


FILES:${PN} = "${datadir}/murata_wireless"
FILES:${PN} = "${datadir}/murata_wireless/*"

#INSANE_SKIP:${PN} = "ldflags"


COMPATIBLE_MACHINE = "(imx-nxp-bsp|mx6|mx7|mx8)"


