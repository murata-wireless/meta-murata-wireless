#!/bin/bash
# Updating local.conf for TI MIRRORS
echo "TI_MIRROR = \"http://software-dl.ti.com/processor-sdk-mirror/sources/\"" >> ${TI_BUILD_DIR}/conf/local.conf
echo "MIRRORS += \" \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "bzr://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "cvs://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "git://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "gitsm://.*/.*    \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "hg://.*/.*       \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "osc://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "p4://.*/.*       \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "npm://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "ftp://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "https?$://.*/.*  \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "svn://.*/.*      \${TI_MIRROR} \n \\" >> ${TI_BUILD_DIR}/conf/local.conf
echo "\"" >> ${TI_BUILD_DIR}/conf/local.conf

# Updating BBLAYERS with meta-murata-wireless
echo "BBLAYERS += \" ${TISDK_DIR}/sources/meta-murata-wireless \"" >> ${TI_BUILD_DIR}/conf/bblayers.conf

# Updating recipe files for dev-deps error
echo "INSANE_SKIP_\${PN} += \"dev-deps\"" >> ${TISDK_DIR}/sources/meta-ros/recipes-ros/vision-opencv/cv-bridge_1.11.16.bb
echo "INSANE_SKIP_\${PN} += \"dev-deps\"" >> ${TISDK_DIR}/sources/meta-ros/recipes-ros/geometry2/tf2-py_0.5.17.bb
echo "INSANE_SKIP_\${PN} += \"dev-deps\"" >> ${TISDK_DIR}/sources/meta-ros/recipes-ros/image-common/camera-calibration-parsers_1.11.13.bb

# Updating kernel recipe file
echo "SRC_URI += \" file://0001-murata-fmac-defconfig.cfg\"" >> ${TISDK_DIR}/sources/meta-processor-sdk/recipes-kernel/linux/linux-ti-staging_4.9.bbappend
echo "KERNEL_CONFIG_FRAGMENTS_append_am57xx-evm = \" \${WORKDIR}/0001-murata-fmac-defconfig.cfg\"" >> ${TISDK_DIR}/sources/meta-processor-sdk/recipes-kernel/linux/linux-ti-staging_4.9.bbappend

echo "ARAGO_BASE += \" \\"       >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "    backporttool-linux \\" >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "    murata-binaries \\"    >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "    hostapd \\"            >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "    wpa-supplicant \\"     >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "    iperf3 \\" 		 >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb
echo "\"" 			 >> ${TISDK_DIR}/sources/meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-base.bb

