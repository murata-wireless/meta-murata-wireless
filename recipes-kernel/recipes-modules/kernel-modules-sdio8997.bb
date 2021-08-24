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
SDIO_FILE_SIZE="2326786"
SDIO_FILE_MD5_SUM="d1a26c76d9ab071b792b54ef73827f8e"
SDIO_FOLDER_NAME="EAR_SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL"
SDIO_FILE_NAME="${SDIO_FOLDER_NAME}.zip"
SDIO_FOLDER_NAME_EXTRACT="SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL"

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
		echo "Copying the zip file"
        	cp $SDIO_SOURCE_DIR/${SDIO_FILE_NAME} ${S}
		cd ${S}
		pwd
#		# Remove existing extracted folder
		rm -rf ${SDIO_FOLDER_NAME}
		unzip ${SDIO_FILE_NAME}

		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}
#		rm COPYING
	fi	

#	STEP 3: Untar and Apply the makefile patch
	if [ "$SDIO_FILE_EXISTS" = "yes" ]; then
		ls -al ${S}/
		cd ${S}/SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL
		tar -xvf ${S}/SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL/wlan_src.tar
		pwd
		cd ${S}/SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL/wlan_src
		for i in `ls *.tar`; do tar -xvf $i; done


		cd ${S}/SDIO_WLAN_UART_BT_IW416_16.92.10.p151_16.92.10.p151-FP92-BT-FP92-LINUX-MM5X17241-MGPL
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

		oe_runmake clean
		oe_runmake build

		# Change build folder to 8997 folder (mbtc_src)
#    		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}/mapp/mlanutl
#		pwd
#		oe_runmake build

		# Change build folder to 8997 folder (mbt_src)
#    		cd ${S}/${SDIO_FOLDER_NAME_EXTRACT}/mbt_src
#		pwd
#		oe_runmake build
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

   		cp -rf ${S}/${SDIO_FOLDER_NAME_EXTRACT}/bin_wlan ${D}${datadir}/nxp_wireless

	    	# Install NXP 8997-SDIO(1YM) firmware
    		install -d ${D}${nonarch_base_libdir}/firmware/nxp
    		install -m 0644 ${S}/${SDIO_FOLDER_NAME_EXTRACT}/Firmware/sdiouart8978_combo_v0.bin ${D}${nonarch_base_libdir}/firmware/nxp
	else
		# install file mentioning no SDIO driver support
		install -d ${D}${nonarch_base_libdir}/firmware/nxp
		install -m 0777 ${S}/1YM_SDIO_Support.txt ${D}${nonarch_base_libdir}/firmware/nxp/1YM_SDIO_Support.txt
	fi
}

FILES_${PN} = "${datadir}/nxp_wireless"
FILES_${PN} += "${nonarch_base_libdir}/firmware/nxp"

INSANE_SKIP_${PN} = "ldflags"
