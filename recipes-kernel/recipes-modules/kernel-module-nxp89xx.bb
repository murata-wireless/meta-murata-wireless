require nxp-wlan-sdk_git.inc

SUMMARY = "NXP Wi-Fi driver for module 88w8997/8987"

inherit module

EXTRA_OEMAKE += "-C ${STAGING_KERNEL_BUILDDIR} M=${S}"

do_patch () {
        echo "In patch function: vkjb"
        pwd
#        SDIO_SOURCE_DIR="${S}/../../.."
#       echo "two"
#       cd ${SDIO_SOURCE_DIR}
        pwd
        cd git/
        echo "3:"
        pwd
#       cp makefile.patch ${S}
#       echo "S: ${S}"
#       ls -al
#       echo "B: ${B}"
#       cd ${S}/
        patch -p1 < ../makefile.patch
}
