require recipes-connectivity/nxp-wlan-sdk/nxp-wlan-sdk_git.inc

SUMMARY = "NXP Wi-Fi driver for PCIE module 88w8997"

RDEPENDS_${PN} += "bash"


DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
    KERNELDIR=${STAGING_KERNEL_BUILDDIR} \
"

do_compile_prepend () {
    # Change build folder to 8997 folder
    cd ${S}/mwifiex_8997

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
   install -d ${D}${datadir}/nxp_wireless
   cp -rf ${S}/bin_pcie8997 ${D}${datadir}/nxp_wireless
}


FILES_${PN} = "${datadir}/nxp_wireless"

INSANE_SKIP_${PN} = "ldflags"