SUMMARY = "Murata Wi-Fi driver for SDIO module 88w8997"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${S}/cyw-bt-patch/LICENCE.cypress;md5=cbc5f665d04f741f1e006d2096236ba7"

RRECOMMENDS_${PN} = "wireless-tools"

RDEPENDS_${PN} += "bash"

DEPENDS = "virtual/kernel"
do_configure[depends] += "make-mod-scripts:do_compile"

EXTRA_OEMAKE += " \
    KERNELDIR=${STAGING_KERNEL_BUILDDIR} \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SDIO_FILE_EXISTS="no"
SDIO_SOURCE_DIR="none"
SDIO_FILE_SIZE="4477181"
SDIO_FILE_MD5_SUM="d0bc6b101214d0a4a232ef41e6efd3e2"
SDIO_FOLDER_NAME="SD-WLAN-SD-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL"
SDIO_FILE_NAME="${SDIO_FOLDER_NAME}.zip"
SDIO_FOLDER_NAME_EXTRACT="SD-UAPSTA-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL"

SRC_URI = " \
	git://github.com/murata-wireless/cyw-bt-patch;protocol=http;branch=zeus-gamera;destsuffix=cyw-bt-patch;name=cyw-bt-patch \
        file://${SDIO_FILE_NAME} \
        file://1YM_SDIO_Support.txt \
	file://makefile.patch \
"


SRCREV_cyw-bt-patch="558f98ac67bd944afa003c247643fd47cc2dd3ab"
SRCREV_default = "${AUTOREV}"

S = "${WORKDIR}"
B = "${WORKDIR}"
DEPENDS = " libnl"

do_patch() {
	echo "------------------------------------------------------------------------------------------------------------------------"

#	STEP-0: Set sdio source directory
	SDIO_SOURCE_DIR="${S}/../../../../../.."
	cd $SDIO_SOURCE_DIR
	export SDIO_SOURCE_DIR=`pwd`
	echo "DEBUG: SDIO source directory $SDIO_SOURCE_DIR"

#	STEP-1: Check for the presence of the SDIO Source file name, file size and md5sum
        if [ -e $SDIO_SOURCE_DIR/${SDIO_FILE_NAME} ]; then
		filesize=$(stat --format=%s "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}")
		file1_md5=$(md5sum "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}" | cut -d " " -f1)

		if [ "${file1_md5}" = "${SDIO_FILE_MD5_SUM}" ] && [ "${filesize}" = "${SDIO_FILE_SIZE}" ]; then
			echo "DEBUG: BOTH MD5SUM and file size MATCHES."
			SDIO_FILE_EXISTS="yes"
		else
			echo "DEBUG: MD5SUM / File Size DOES NOT MATCH."
		fi
	else
		echo "DEBUG: File ${SDIO_FILE_NAME} DOES NOT EXIST"
        fi

#	STEP 2: Copy the zip file to work dir and unzip it.
	if [ "$SDIO_FILE_EXISTS" = "yes" ]; then
        	cp $SDIO_SOURCE_DIR/${SDIO_FILE_NAME} ${S}
		cd ${S}
		# Remove existing extracted folder
		rm -rf ${SDIO_FOLDER_NAME}
		unzip ${SDIO_FILE_NAME}
	fi	

#	STEP 3: Untar and Apply the makefile patch
	if [ "$SDIO_FILE_EXISTS" = "yes" ]; then
		tar -xvf ${S}/SD-WLAN-SD-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL.tar
		for i in `ls *.tgz`; do tar -xvf $i; done
		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}
        	patch -p1 < ${S}/makefile.patch
	fi

	echo "------------------------------------------------------------------------------------------------------------------------"
}


do_compile() {

	if [ ${TARGET_ARCH} = "aarch64" ]; then
       		export ARCH=arm64
    		export CROSS_COMPILE="${TARGET_PREFIX}"
    	else
		export ARCH=arm
		export CROSS_COMPILE=arm-poky-linux-gnueabi-
    	fi

#	STEP-0: Set sdio source directory
	SDIO_SOURCE_DIR="${S}/../../../../../.."
	cd $SDIO_SOURCE_DIR
	export SDIO_SOURCE_DIR=`pwd`
	echo "DEBUG: SDIO source directory $SDIO_SOURCE_DIR"

#	STEP-1: Check for the presence of the SDIO Source file name, file size and md5sum
        if [ -e $SDIO_SOURCE_DIR/${SDIO_FILE_NAME} ]; then
		filesize=$(stat --format=%s "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}")
		file1_md5=$(md5sum "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}" | cut -d " " -f1)

		if [ "${file1_md5}" = "${SDIO_FILE_MD5_SUM}" ] && [ "${filesize}" = "${SDIO_FILE_SIZE}" ]; then
			echo "DEBUG: BOTH MD5SUM and file size MATCHES."
			SDIO_FILE_EXISTS="yes"
		else
			echo "DEBUG: MD5SUM / File Size DOES NOT MATCH."
		fi
	else
		echo "DEBUG: File ${SDIO_FILE_NAME} DOES NOT EXIST"
        fi

	if [ "$SDIO_FILE_EXISTS" = "yes" ]; then
		# Change build folder to 8997 folder (wlan_src)
    		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}/wlan_src
		pwd
		oe_runmake build

		# Change build folder to 8997 folder (mbtc_src)
    		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}/mbtc_src
		pwd
		oe_runmake build

		# Change build folder to 8997 folder (mbt_src)
    		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}/mbt_src
		pwd
		oe_runmake build
	fi
}


do_install () {
	echo "DEBUG: Testing Installing: "

#	STEP-0: Set sdio source directory
	SDIO_SOURCE_DIR="${S}/../../../../../.."
	cd $SDIO_SOURCE_DIR
	export SDIO_SOURCE_DIR=`pwd`
	echo "DEBUG: SDIO source directory $SDIO_SOURCE_DIR"

#	STEP-1: Check for the presence of the SDIO Source file name, file size and md5sum
        if [ -e $SDIO_SOURCE_DIR/${SDIO_FILE_NAME} ]; then
		filesize=$(stat --format=%s "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}")
		file1_md5=$(md5sum "$SDIO_SOURCE_DIR/${SDIO_FILE_NAME}" | cut -d " " -f1)

		if [ "${file1_md5}" = "${SDIO_FILE_MD5_SUM}" ] && [ "${filesize}" = "${SDIO_FILE_SIZE}" ]; then
			echo "DEBUG: BOTH MD5SUM and file size MATCHES."
			SDIO_FILE_EXISTS="yes"
		else
			echo "DEBUG: MD5SUM / File Size DOES NOT MATCH."
		fi
	else
		echo "DEBUG: File ${SDIO_FILE_NAME} DOES NOT EXIST"
        fi

	if [ "$SDIO_FILE_EXISTS" = "yes" ]; then
   		# install ko and configs to rootfs
   		install -d ${D}${datadir}/nxp_wireless

   		cp -rf ${S}/SD-UAPSTA-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL/bin_sd8997 ${D}${datadir}/nxp_wireless
   		cp -rf ${S}/SD-UAPSTA-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL/bin_sd8997_bt ${D}${datadir}/nxp_wireless
   		cp -rf ${S}/SD-UAPSTA-BT-8997-U16-MMC-W16.68.10.p56-16.26.10.p56-C4X16667_V4-MGPL/bin_sd8997_btchar ${D}${datadir}/nxp_wireless

	    	# Install NXP 8997-SDIO(1YM) firmware
    		install -d ${D}${nonarch_base_libdir}/firmware/nxp
    		install -m 0644 ${S}/FwImage/sd8997_bt_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp
    		install -m 0644 ${S}/FwImage/sd8997_wlan_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp
    		install -m 0644 ${S}/FwImage/sdsd8997_combo_v4.bin ${D}${nonarch_base_libdir}/firmware/nxp
	else
		# install file mentioning no SDIO driver support
		install -d ${D}${nonarch_base_libdir}/firmware/nxp
		install -m 0777 ${S}/1YM_SDIO_Support.txt ${D}${nonarch_base_libdir}/firmware/nxp/1YM_SDIO_Support.txt
	fi
}

FILES_${PN} = "${datadir}/nxp_wireless"
FILES_${PN} += "${nonarch_base_libdir}/firmware/nxp"

INSANE_SKIP_${PN} = "ldflags"