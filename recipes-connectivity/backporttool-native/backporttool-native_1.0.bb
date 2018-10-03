SUMMARY = "Cypress Backport tool"
LICENSE = "GPLv2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
#COMPATIBLE_MACHINE = "am335x-evm"


inherit systemd
inherit native
#inherit module

SYSTEMD_AUTO_ENABLE = "disable"

SRC_URI =  "https://github.com/murata-wireless/cyw-fmac/raw/imx-morty-battra_r${PV}/imx-morty-battra_r${PV}.tar.gz;name=archive1"
SRC_URI += "https://github.com/murata-wireless/meta-murata-wireless/raw/imx-morty-battra/LICENSE;name=archive99"

SRC_URI[archive1.md5sum] = "308528ef68f054af128e4664e6af4333"
SRC_URI[archive1.sha256sum] = "503c001845416b33b52704da39bec16f049def66081478b1b9107f12cf006046"

#LICENSE
SRC_URI[archive99.md5sum] = "b234ee4d69f5fce4486a80fdaf4a4263"
SRC_URI[archive99.sha256sum] = "8177f97513213526df2cf6184d8ff986c675afb514d4e68a404010521b880643"

S = "${WORKDIR}/backporttool-native-${PV}"
B = "${WORKDIR}/backporttool-native-${PV}/"

DEPENDS = " linux-ti-staging"
do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_configure[depends] += "virtual/kernel:do_compile_kernelmodules"
#do_configure[depends] += "virtual/kernel:kernel_do_compile"

do_compile[depends] += "virtual/kernel:do_shared_workdir"
do_compile[depends] += "virtual/kernel:do_compile_kernelmodules"
#do_compile[depends] += "virtual/kernel:kernel_do_compile"

do_configure () {
	echo "Configuring"
        echo "KLIB:       ${KLIB}"
        echo "KLIB_BUILD: ${KLIB_BUILD} "
}

export EXTRA_CFLAGS = "${CFLAGS}"
export BINDIR = "${sbindir}"
export TEST_KERNEL_DIR = "${kerneldir}"
export TEST_KERNEL_SRC_PATH = "${KERNEL_SRC_PATH}"
export TEST_KERNEL_SRC = "${KERNEL_SRC}"
export TEST_KERNEL_PATH = "${KERNEL_PATH}"

KLIB="${TMPDIR}/work-shared/${MACHINE}/kernel-source"
KLIB_BUILD="${TMPDIR}/work/imx6ulevk-poky-linux-gnueabi/linux-imx/4.9.11-r0/build"

#KLIB="${STAGING_KERNEL_DIR}"
#KLIB_BUILD="${STAGING_KERNEL_BUILDDIR}"
#KERNEL_VERSION = "${@base_read_file('${STAGING_KERNEL_BUILDDIR}/kernel-abiversion')}"

do_compile () {
	echo "Compiling: "
        #echo "Testing Make Display:: ${MAKE}"
        pwd

        echo "KLIB:       ${KLIB}"
        echo "KLIB_BUILD: ${KLIB_BUILD} "
        echo "KBUILD_OUTPUT: ${KBUILD_OUTPUT}"
        echo "MULTIMACH_TARGET_SYS: ${MULTIMACH_TARGET_SYS}"
        echo "TEST_KERNEL_DIR: ${TEST_KERNEL_DIR}"
        echo "TEST_KERNEL_SRC_PATH: ${TEST_KERNEL_SRC_PATH}"
        echo "TEST_KERNEL_SRC: ${TEST_KERNEL_SRC}"
        echo "TEST_KERNEL_PATH: ${TEST_KERNEL_PATH}"

        cp -a ${TMPDIR}/work/x86_64-linux/backporttool-native/1.0-r0/imx-morty-battra_r1.0/. .
	rm -rf .git

        oe_runmake KLIB="${STAGING_KERNEL_DIR}" KLIB_BUILD="${STAGING_KERNEL_BUILDDIR}" kernelversion=${KERNEL_VERSION} defconfig-brcmfmac

#oe_runmake KLIB=/home/jameel/project/task121-ti-4-1-15/tisdk/build/arago-tmp-external-linaro-toolchain/work-shared/am335x-evm/kernel-source KLIB_BUILD=/home/jameel/project/task121-ti-4-1-15/tisdk/build/arago-tmp-external-linaro-toolchain/work-shared/am335x-evm/#kernel-build-artifacts defconfig-brcmfmac

#        oe_runmake KLIB="${TMPDIR}/work-shared/${MACHINE}/kernel-source" \
#KLIB_BUILD="${TMPDIR}/work/imx6ulevk-poky-linux-gnueabi/linux-imx/4.9.11-r0/build" \
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


