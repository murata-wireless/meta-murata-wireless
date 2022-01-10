#!/bin/bash
VERSION=01102022


###################################################################################################
#                             RELEASE HISTORY
#-------------------------------------------------------------------------------------------------
#  Revision |  Date        |  Initials    |       Change Description
#-----------|--------------|--------------|-------------------------------------------------------
#  1.0      | 12/01/2020   |    JK        |    Added support for sumo-zigra and rocko-mini-zigra
#  1.1      | 12/09/2020   |    JK        |    Added support for krogoth-zigra, krogoth-kong and
#           |              |              |    krogoth-manda
#  1.2      | 12/19/2020   |    JK        |    Fix Zigra FMAC String display for 5.4.47
#  1.3      | 12/21/2020   |    RC        |    Added support for imx8mmddr4evk machine type
#  1.4      | 01/06/2021   |    JK        |    Supports NXP Wireless (1ZM, 1YM-SDIO and 1YM-PCIe).
#           |              |              |    Supports 1.8V VIO Signaling with NXP i.MX6UL(L) EVK.
#  1.5      | 01/22/2021   |    JK        |    Remove Manda and Add Spiga
#  1.6      | 01/27/2021   |    RC        |    Remove unsupported machine types for NXP Wireless
#  1.7      | 02/02/2021   |    RC        |    Added back Manda
#  1.8      | 02/11/2021   |    JK        |    Add Spiga Revision 1.1
#           |              |              |    Add Disclaimer
#  1.9      | 04/05/2021   |    JK        |    Add installation of repo tool from google sources
#           |              |              |    into a temporary folder, "repo-murata".
#           |              |              |    Overrides the default Ubuntu repo tool.
#  1.10     | 05/27/2021   |    RC        |    Add check for previous meta-murata-wireless folder.
#  1.11     | 05/31/2021   |    RC        |    Add check for .repo folders
#  1.12     | 06/14/2021   |    JK        |    Add Exiting the script after dash check
#  1.13     | 06/29/2021   |    RC        |    Add Baragon
#  1.14     | 11/18/2021   |    RC        |    Removed NXP into seperate script. Renamed script.
#  1.15     | 11/22/2021   |    RC        |    Added support for hardknott and cynder.
#  1.16     | 12/14/2021   |    RC        |    Updated hardknott-cynder support.
#  1.17     | 01/10/2022   |    RC        |    Moved legacy support under flags.
####################################################################################################

# Use colors to highlight pass/fail conditions.
RED='\033[1;31m' # Red font to flag errors
GRN='\033[1;32m' # Green font to flag pass
YLW='\033[1;33m' # Yellow font for highlighting
NC='\033[0m' # No Color

#--------------------------- Variables-----------------------------------------------------------
STEP_COUNT=1

# Set LEGACY_SOFTWARE_SUPPORT to "ON" to enable legacy FMAC. Turn "OFF" otherwise.
LEGACY_SOFTWARE_SUPPORT="OFF"

# Set LEGACY_PLATFORM_SUPPORT to "ON" to enable legacy Kernels. Turn "OFF" otherwise.
LEGACY_PLATFORM_SUPPORT="OFF"

# BSP directory
export BSP_DIR=`pwd`

# Initialize variables
LINUX_SRC=""
LINUX_DEST=""
CWD=""

MOTHRA_FMAC_INDEX="1"
MANDA_FMAC_INDEX="2"
KONG_FMAC_INDEX="3"
ZIGRA_FMAC_INDEX="4"
SPIGA_FMAC_INDEX="5"
BARAGON_FMAC_INDEX="6"
CYNDER_FMAC_INDEX="7"

MOTHRA_FMAC_STR="mothra"
MANDA_FMAC_STR="manda"
KONG_FMAC_STR="kong"
ZIGRA_FMAC_STR="zigra"
SPIGA_FMAC_STR="spiga"
BARAGON_FMAC_STR="baragon"
CYNDER_FMAC_STR="cynder"

LINUX_KERNEL_5_10_52=0
LINUX_KERNEL_5_4_47=1
LINUX_KERNEL_4_14_98=2
LINUX_KERNEL_4_9_123=3
LINUX_KERNEL_4_1_15=4

# Linux Kernel Strings
LINUX_KERNEL_5_10_52_STR="5.10.52"
LINUX_KERNEL_5_4_47_STR="5.4.47"
LINUX_KERNEL_4_14_98_STR="4.14.98"
LINUX_KERNEL_4_9_123_STR="4.9.123"
LINUX_KERNEL_4_1_15_STR="4.1.15"

DISTRO_NAME=fsl-imx-fb
IMAGE_NAME=core-image-base

iMXYoctoRelease=""
YoctoBranch=""
fmacversion=""
linuxVersion=""

# Hardknott
iMXhardknottcynderStableReleaseTag="imx-imx-hardknott-cynder_r1.0"
iMXhardknottcynderDeveloperRelease="imx-hardknott-cynder"

# Zeus
iMXzeusbaragonStableReleaseTag="imx-zeus-baragon_r1.0"
iMXzeusbaragonDeveloperRelease="imx-zeus-baragon"

iMXzeusspigaStableReleaseTag="imx-zeus-spiga_r1.0"
iMXzeusspigaDeveloperRelease="imx-zeus-spiga"

iMXzeuszigraStableReleaseTag="imx-zeus-zigra_r1.0"
iMXzeuszigraDeveloperRelease="imx-zeus-zigra"

# Sumo
iMXsumobaragonStableReleaseTag="imx-sumo-baragon_r1.0"
iMXsumobaragonDeveloperRelease="imx-sumo-baragon"

iMXsumospigaStableReleaseTag="imx-sumo-spiga_r1.0"
iMXsumospigaDeveloperRelease="imx-sumo-spiga"

iMXsumozigraStableReleaseTag="imx-sumo-zigra_r1.0"
iMXsumozigraDeveloperRelease="imx-sumo-zigra"

iMXsumokongStableReleaseTag="imx-sumo-kong_r1.1"
iMXsumokongDeveloperRelease="imx-sumo-kong"

iMXsumomandaStableReleaseTag="imx-sumo-manda_r1.2"
iMXsumomandaDeveloperRelease="imx-sumo-manda"

# Rocko-Mini
iMXrockominibaragonStableReleaseTag="imx-rocko-mini-baragon_r1.0"
iMXrockominibaragonDeveloperRelease="imx-rocko-mini-baragon"

iMXrockominispigaStableReleaseTag="imx-rocko-mini-spiga_r1.0"
iMXrockominispigaDeveloperRelease="imx-rocko-mini-spiga"

iMXrockominizigraStableReleaseTag="imx-rocko-mini-zigra_r1.0"
iMXrockominizigraDeveloperRelease="imx-rocko-mini-zigra"

iMXrockominikongStableReleaseTag="imx-rocko-mini-kong_r1.0"
iMXrockominikongDeveloperRelease="imx-rocko-mini-kong"

iMXrockominimandaStableReleaseTag="imx-rocko-mini-manda_r2.2"
iMXrockominimandaDeveloperRelease="imx-rocko-mini-manda"

# Krogoth
iMXkrogothbaragonStableReleaseTag="imx-krogoth-baragon_r1.0"
iMXkrogothbaragonDeveloperRelease="imx-krogoth-baragon"

iMXkrogothspigaStableReleaseTag="imx-krogoth-spiga_r1.0"
iMXkrogothspigaDeveloperRelease="imx-krogoth-spiga"

iMXkrogothzigraStableReleaseTag="imx-krogoth-zigra_r1.0"
iMXkrogothzigraDeveloperRelease="imx-krogoth-zigra"

iMXkrogothmandaStableReleaseTag="imx-krogoth-manda_r2.1"
iMXkrogothmandaDeveloperRelease="imx-krogoth-manda"

iMXkrogothmothraStableReleaseTag="imx-krogoth-mothra_r1.1"
iMXkrogothmothraDeveloperRelease="imx-krogoth-mothra"

imxhardknottYocto="5.10.52_2.1.0 GA"
imxzeusYocto="5.4.47_2.2.0 GA"
imxsumoYocto="4.14.98_2.3.0 GA"
imxrockominiYocto="4.9.123_2.3.0 GA"
imxkrogothYocto="4.1.15_2.0.0 GA"


#--------------------------------------------------------------------------------------------------


clear
#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

if [ -h /bin/sh ] && `which readlink > /dev/null 2>&1` && [ -n "`readlink /bin/sh | grep '\<dash$'`" ]; then
	printf '%b' "${RED}===============================================================\n"
	printf '%b'  "Error: DASH shell not supported as system shell\n"
	printf '%b'  "===============================================================\n${NC}"
	printf '%b'  "The script has detected that your system uses the dash shell\n"
	printf '%b'  "as /bin/sh.  This shell is not supported by the script.\n"
	printf '%b'  "You can work around this problem by changing /bin/sh to be a\n"
	printf '%b'  "symbolic link to a supported shell such as bash.\n"
	printf '%b'  "For example, on Ubuntu systems, execute this shell command:\n\n"
	printf '%b'  "${YLW}   $ sudo dpkg-reconfigure dash\n\n"
	printf '%b'  "   Then select option 'No'\n\n${NC}"
	printf '%b'  "${RED}===============================================================\n"
	printf '%b'  "Exiting script.....\n${NC}"
	exit 1
fi

echo " "
echo "MURATA Custom i.MX Linux build using Yocto"
echo "=========================================="

echo " "
echo "${STEP_COUNT}) Verifying Host Environment"
echo "-----------------------------"

(( STEP_COUNT += 1 ))

# Get Linux distro; make sure it is "Ubuntu"
Linux_Distro=$(lsb_release -i -s)
if [ $Linux_Distro == "Ubuntu" ]; then
	echo -e "Murata: Verified Linux Distribution: " ${GRN}$Linux_Distro${NC}
else
	echo -e "${RED}Murata: Only Ubuntu Linux Distribution supported; not:${NC}" $Linux_Distro
	exit
fi

# Get Ubuntu release version; make sure it is either 20.04, 18.04, 16.04, 14.04 or 12.04.
Ubuntu_Release=$(lsb_release -r -s)
if [ $Ubuntu_Release == "20.04" ] || [ $Ubuntu_Release == "18.04" ] || [ $Ubuntu_Release == "16.04" ] || [ $Ubuntu_Release == "14.04" ] || [ $Ubuntu_Release == "12.04" ]; then
	echo -e "Murata: Verified Ubuntu Release:${NC}     " ${GRN}$Ubuntu_Release${NC}
else
	echo -e "${RED}Murata: Only Ubuntu versions 20.04, 18.04, 16.04, 14.04, and 12.04 are supported; not:" $Ubuntu_Release
	echo -e "Exiting script.....${NC}"
	exit
fi

# Install "repo" tool within BSP folder
echo " "
echo -e "${YLW}NOTE:${NC} Installing repo tool in a temporary folder, named, "\""repo-murata"\"" in $BSP_DIR"
echo "Temporary folder, "\""repo-murata"\"" will be deleted after the image gets built."
echo " "
echo -n -e "Do you want to continue? ${GRN}Y${NC}/${YLW}n${NC}: "
read PROCEED_UPDATE_OPTION

if [ "$PROCEED_UPDATE_OPTION" = "y" ] || [ "$PROCEED_UPDATE_OPTION" = "Y" ] || [ "$PROCEED_UPDATE_OPTION" = "" ]; then
	rm -rf repo-murata
	mkdir repo-murata
	cd repo-murata
	curl https://storage.googleapis.com/git-repo-downloads/repo > ${BSP_DIR}/repo-murata/repo
	chmod a+x ${BSP_DIR}/repo-murata/repo
	export REPO_PATH=${BSP_DIR}/repo-murata/
else
	echo " "
	echo -e "${RED}Murata: Skipping repo tool installation"
	echo -e "Exiting script.....${NC}"
fi

# Ubuntu Distro and Version verified. Now add necessary commands.

echo " "
echo "${STEP_COUNT}) Verifying Script Version"
echo "---------------------------"

(( STEP_COUNT += 1 ))

GITHUB_PATH="\""https://github.com/murata-wireless/meta-murata-wireless.git"\""
META_MURATA_WIRELESS_GIT="https://github.com/murata-wireless/meta-murata-wireless.git"

echo "Fetching latest script from Murata Github."
echo "Cloning $GITHUB_PATH"
echo "Creating "\""meta-murata-wireless"\"" subfolder."


# check to see if there is already a folder with name, "meta-murata-wireless"
# if it is, then fetch the latest files
# else clone meta-murata-wireless
TEST_DIR_NAME=meta-murata-wireless
if [ -d "$TEST_DIR_NAME" ]; then
	cd $TEST_DIR_NAME/script-utils/latest
	git fetch --all 		--quiet
	git reset --hard origin/master 	--quiet
	git pull origin master 		--quiet
else
	git clone $META_MURATA_WIRELESS_GIT --quiet
	cd $TEST_DIR_NAME/script-utils/latest
fi

export SCRIPT_DIR=`pwd`
#echo "Latest folder path: $SCRIPT_DIR"

# Scan through the file Murata_Wireless_Yocto_Build.sh to fetch the Revision Information
COUNTER=0
input_file_path="$SCRIPT_DIR/Murata_Wireless_Yocto_Build.sh"

while IFS= read -r LATEST_VER
do
	COUNTER=$[$COUNTER +1]
	if [ "$COUNTER" = "2" ] ; then
	break
	fi
done < "$input_file_path"

cd $BSP_DIR

# read first and second line of Murata_Wireless_Yocto_Build.sh script
IFS== read FIRST_LINE LATEST_VER <<< $LATEST_VER

# Check for latest revision
if [ "$VERSION" = "$LATEST_VER" ]; then
	echo    "Latest:  $LATEST_VER"
	echo -e "Current: $VERSION${GRN}........PASS${NC}"
else
	echo    "Latest:  $LATEST_VER"
	echo -e "Current: ${YLW}$VERSION........MISMATCH${NC}"
	echo " "

	echo -n -e "Do you want to update build script? ${GRN}Y${NC}/${YLW}n${NC}: "
	read PROCEED_UPDATE_OPTION

	if [ "$PROCEED_UPDATE_OPTION" = "y" ] || [ "$PROCEED_UPDATE_OPTION" = "Y" ] || [ "$PROCEED_UPDATE_OPTION" = "" ]; then
		echo "NOTE: Latest build script is not tested fully. Please take a backup of the previous script before replacing."
		echo "Update to latest version using following copy command:"
		echo " "
		echo ""\$ "cp ./meta-murata-wireless/script-utils/latest/Murata_Wireless_Yocto_Build.sh ."
		echo " "
		echo -e "${YLW}Exiting script.....${NC}"
       		exit
	else
		echo " "
		echo -e "${YLW}CONTINUING WITH CURRENT SCRIPT.${NC}"
	fi
fi

#######################   Functions ##########################################################
function select_supported_distros_for_5_x_onwards {
	echo " "
	echo "${STEP_COUNT}.1) Select DISTRO"
	echo "------------------"
	echo " "
	echo "----------------------------------------------------------------------------"
	echo "| Entry |   DISTRO Name     |    Description                               |"
	echo "|-------|-------------------|----------------------------------------------|"
	echo "|   1   | fsl-imx-fb        | Frame Buffer graphics - no X11 or Wayland    |"
	echo "|   2   | fsl-imx-wayland   | Wayland weston graphics                      |"
	echo "|   3   | fsl-imx-xwayland  | Wayland graphics and X11. X11 applications   |"
	echo "|       |                   | using EGL are not supported                  |"
	echo "----------------------------------------------------------------------------"

	# Prompting the user to select the DISTRO
	echo " "
	while true; do
		echo -e -n "Select your entry for DISTRO: "
		read DISTRO_OPTION
		case $DISTRO_OPTION in
		1)
			DISTRO_NAME=fsl-imx-fb
			break
			;;
		2)
			DISTRO_NAME=fsl-imx-wayland
			break
			;;
		3)
			DISTRO_NAME=fsl-imx-xwayland
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
}


function select_previous_distros_supported {
	echo " "
	echo "${STEP_COUNT}.1) Select DISTRO"
	echo "------------------"
	echo " "
	echo "----------------------------------------------------------------------------"
	echo "| Entry |   DISTRO Name     |    Description                               |"
	echo "|-------|-------------------|----------------------------------------------|"
	echo "|   1   | fsl-imx-x11       | Only X11 graphics                            |"
	echo "|   2   | fsl-imx-wayland   | Wayland weston graphics                      |"
	echo "|   3   | fsl-imx-xwayland  | Wayland graphics and X11. X11 applications   |"
	echo "|       |                   | using EGL are not supported                  |"
	echo "|   4   | fsl-imx-fb        | Frame Buffer graphics - no X11 or Wayland    |"
	echo "----------------------------------------------------------------------------"

	# Prompting the user to select the DISTRO
	echo " "
	while true; do
		echo -e -n "Select your entry for DISTRO: "
		read DISTRO_OPTION
		case $DISTRO_OPTION in
		1)
			DISTRO_NAME=fsl-imx-x11
			break
			;;
		2)
			DISTRO_NAME=fsl-imx-wayland
			break
			;;
		3)
			DISTRO_NAME=fsl-imx-xwayland
			break
			;;
		4)
			DISTRO_NAME=fsl-imx-fb
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
}

function select_build_image_name {
	echo "${STEP_COUNT}.2) Select Image"
	echo "-----------------"
	echo " "

	#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
	echo "--------------------------------------------------------------------------------"
	echo "| Entry |      Image Name              | Description                           |"
	echo "|-------|------------------------------|---------------------------------------|"
	echo "|   1   | core-image-sato              | An image with Sato, a mobile          |"
	echo "|       |                              | environment and visual style for      |"
	echo "|       |                              | mobile devices. The image supports X11|"
	echo "|       |                              | with a Sato theme and uses Pimlico    |"
	echo "|       |                              | applications. It contains a terminal, |"
	echo "|       |                              | an editor and a file manager.         |"
	echo "|       |                              |                                       |"
	echo "|   2   | fsl-image-machine-test       | An FSL Community i.MX core image with |"
	echo "|       |                              | console environment - no GUI interface|"
	echo "|       |                              |                                       |"
	echo "|   3   | fsl-image-validation-imx     | Builds an i.MX image with a GUI       |"
	echo -e "|       | ${GRN}(tested)${NC}                     | without any Qt content.               |"
	echo "|       |                              |                                       |"
	echo "|       |                              |                                       |"
	echo "|   4   | fsl-image-qt5-validation-imx | Builds an opensource Qt 5 image. These|"
	echo "|       |                              | images are only supported for i.MX SoC|"
	echo "|       |                              | with hardware graphics. They are not  |"
	echo "|       |                              | supported on the i.MX 6UltraLite,     |"
	echo "|       |                              | i.MX 6UltraLiteLite, and i.MX 7Dual.  |"
	echo "|       |                              |                                       |"
	echo "|   5   | core-image-base              | A console-only image that fully       |"
	echo -e "|       | ${GRN}(tested)${NC}                     | supports the target device hardware.  |"
	echo "|       |                              |                                       |"
	echo "--------------------------------------------------------------------------------"

	while true; do
		echo -e -n "Select your entry: "
		read IMAGE_OPTION
		case $IMAGE_OPTION in
			1)
			IMAGE_NAME=core-image-sato
			break
			;;

		2)
			IMAGE_NAME=fsl-image-machine-test
			break
			;;

		3)
			IMAGE_NAME=fsl-image-validation-imx
			break
			;;

		4)
			IMAGE_NAME=fsl-image-qt5-validation-imx
			break
			;;

		5)
			IMAGE_NAME=core-image-base
			break
			;;

		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
	echo -e "${GRN}Selected Image: $IMAGE_NAME. ${NC}"
}


# For i.MX8 series, make the default image type to fsl-image-validation-imx
function select_default_image {
	if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ] || [ "$TARGET_NAME" = "imx8mnddr4evk" ]; then
		IMAGE_NAME=fsl-image-validation-imx
	fi
}

# Check for .repo folders
check_path=`pwd`
check_path=${check_path%/*}
while [[ "$check_path" != "" ]]; do
	#echo "Checking $check_path"
	if [[ -e "$check_path/.repo" ]]; then
		echo -e "${RED}Found a .repo folder in $check_path. Please ensure no parent folder contains a .repo folder when running the script. Exiting...${NC}"
		exit
	else
		if [[ "$check_path" == "$HOME" ]]; then
			break
		else
			check_path=${check_path%/*}
		fi
	fi
done

echo " "
echo "${STEP_COUNT}) Select Release Type"
echo "----------------------"

(( STEP_COUNT += 1 ))

echo -e "a) Stable: Murata tested/verified release tag. ${GRN}Stable is the recommended default.${NC}"
echo " "
#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
echo -e "b) Developer: Includes latest fixes on branch. ${YLW}May change at any time.${NC}"
echo " "

echo -n -e "Select ${GRN}Stable${NC} ( ${YLW}"\'"n"\'"=Developer${NC} )? ${GRN}Y${NC}/${YLW}n${NC}: "
read BRANCH_TAG_OPTION
if [ "$BRANCH_TAG_OPTION" = "y" ] || [ "$BRANCH_TAG_OPTION" = "Y" ] || [ "$BRANCH_TAG_OPTION" = "" ]; then
	BRANCH_TAG_OPTION="y"
	echo -e "${GRN}Stable release selected${NC}"
else
	BRANCH_TAG_OPTION="n"
	echo -e "${YLW}WARNING!!! Developer release selected${NC}"
fi

############################### Linux Kernel Selection #####################################
while true; do
	echo " "
	echo "${STEP_COUNT}) Select "\""Linux Kernel"\"" "
	echo "------------------------"
	echo "--------------------------------------------------------------------------"
	echo "|Entry|   Linux Kernel   | Yocto      | FMAC Supported                   |"
	echo "|-----|------------------|------------|----------------------------------|"
	if [ "${LEGACY_SOFTWARE_SUPPORT}" = "ON" ]; then
		echo "|  0  |     ${LINUX_KERNEL_5_10_52_STR}       | hardknott | Cynder                           |"
		echo "|  1  |     ${LINUX_KERNEL_5_4_47_STR}        | zeus      | Baragon,Spiga,Zigra              |"
		echo "|  2  |     ${LINUX_KERNEL_4_14_98_STR}       | sumo      | Baragon,Spiga,Zigra,Kong,Manda   |"
		echo "|  3  |     ${LINUX_KERNEL_4_9_123_STR}       | rocko     | Baragon,Spiga,Zigra,Kong,Manda   |"
		echo "|  4  |     ${LINUX_KERNEL_4_1_15_STR}        | krogoth   | Baragon,Spiga,Zigra,Manda,Mothra |"
	else
		echo "|  0  |     ${LINUX_KERNEL_5_10_52_STR}       | hardknott | Cynder                           |"
		echo "|  1  |     ${LINUX_KERNEL_5_4_47_STR}        | zeus      | Baragon,Spiga                    |"
		echo "|  2  |     ${LINUX_KERNEL_4_14_98_STR}       | sumo      | Baragon,Spiga                    |"
		echo "|  3  |     ${LINUX_KERNEL_4_9_123_STR}       | rocko     | Baragon,Spiga                    |"
	fi

	echo "--------------------------------------------------------------------------"
	read -p "Select which entry? " LINUX_KERNEL

	if [ "${LEGACY_SOFTWARE_SUPPORT}" = "ON" ]; then
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_1_15)
			linuxVersion=${LINUX_KERNEL_4_1_15_STR}
			break
			;;
		$LINUX_KERNEL_4_9_123)
			linuxVersion=${LINUX_KERNEL_4_9_123_STR}
			break
			;;
		$LINUX_KERNEL_4_14_98)
			linuxVersion=${LINUX_KERNEL_4_14_98_STR}
			break
				;;
		$LINUX_KERNEL_5_4_47)
			linuxVersion=${LINUX_KERNEL_5_4_47_STR}
			break
			;;
		$LINUX_KERNEL_5_10_52)
			linuxVersion=${LINUX_KERNEL_5_10_52_STR}
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			echo $'\n'
			;;
		esac
	else
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_9_123)
			linuxVersion=${LINUX_KERNEL_4_9_123_STR}
			break
			;;
		$LINUX_KERNEL_4_14_98)
			linuxVersion=${LINUX_KERNEL_4_14_98_STR}
			break
				;;
		$LINUX_KERNEL_5_4_47)
			linuxVersion=${LINUX_KERNEL_5_4_47_STR}
			break
			;;
		$LINUX_KERNEL_5_10_52)
			linuxVersion=${LINUX_KERNEL_5_10_52_STR}
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			echo $'\n'
			;;
		esac
	fi
done
echo -e "${GRN}Selected : $linuxVersion${NC}"
(( STEP_COUNT += 1 ))

echo " "
echo "${STEP_COUNT}) Select "\""fmac"\"" version"
echo "------------------------"
(( STEP_COUNT += 1 ))

if [ "${LEGACY_SOFTWARE_SUPPORT}" = "ON" ]; then
	while true; do
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_1_15) # for 4.1.15_2.0.0
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $MOTHRA_FMAC_STR - Old release                               |"
				echo     "|  1.   | $MANDA_FMAC_STR - Old release                               |"
				echo     "|  2.   | $ZIGRA_FMAC_STR - Old release                               |"
				echo     "|  3.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  4.   | $BARAGON_FMAC_STR - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " ENTRY
				case $ENTRY in
				0) # for MOTHRA
					FMAC_VERSION=${MOTHRA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUG:: krogoth-mothra_r1.1"
						BRANCH_RELEASE_NAME="$iMXkrogothmothraStableReleaseTag"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$MOTHRA_FMAC_STR"
						# krogoth-kong
					else
						#echo "DEBUG:: krogoth-mothra"
						BRANCH_RELEASE_NAME="$iMXkrogothmothraDeveloperRelease"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$MOTHRA_FMAC_STR"
					fi
					break
					;;
				1) # for MANDA
					FMAC_VERSION=${MANDA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"     = "y" ]; then
						#echo "DEBUG:: krogoth-manda_r2.2"
						BRANCH_RELEASE_NAME="$iMXkrogothmandaStableReleaseTag"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$MANDA_FMAC_STR"
					else
						#echo "DEBUG:: krogoth-manda"
						BRANCH_RELEASE_NAME="$iMXkrogothmandaDeveloperRelease"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$MANDA_FMAC_STR"
					fi
					break
					;;
				2) # for ZIGRA
					FMAC_VERSION=${ZIGRA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: krogoth-zigra_r1.0"
						BRANCH_RELEASE_NAME="$iMXkrogothzigraStableReleaseTag"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$ZIGRA_FMAC_STR"
						# krogoth-zigra
					else
						#echo "DEBUG:: krogoth-zigra"
						BRANCH_RELEASE_NAME="$iMXkrogothzigraDeveloperRelease"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$ZIGRA_FMAC_STR"
					fi
					break
					;;
				3) # for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: krogoth-spiga_r1.0"
						BRANCH_RELEASE_NAME="$iMXkrogothspigaStableReleaseTag"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$SPIGA_FMAC_STR"
						# krogoth-spiga
					else
						#echo "DEBUG:: krogoth-spiga"
						BRANCH_RELEASE_NAME="$iMXkrogothspigaDeveloperRelease"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$SPIGA_FMAC_STR"
					fi
					break
					;;
				4) # for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: krogoth-baragon_r1.0"
						BRANCH_RELEASE_NAME="$iMXkrogothbaragonStableReleaseTag"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$BARAGON_FMAC_STR"
						# krogoth-baragon
					else
						#echo "DEBUG:: krogoth-baragon"
						BRANCH_RELEASE_NAME="$iMXkrogothbaragonDeveloperRelease"
						iMXYoctoRelease="$imxkrogothYocto"
						YoctoBranch="krogoth"
						fmacversion="$BARAGON_FMAC_STR"
					fi
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_4_9_123) #for 4.9.123_2.3.0
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $MANDA_FMAC_STR - Old release                               |"
				echo     "|  1.   | $KONG_FMAC_STR - Old release                                |"
				echo     "|  2.   | $ZIGRA_FMAC_STR - Old release                               |"
				echo     "|  3.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  4.   | $BARAGON_FMAC_STR - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " ENTRY
				case $ENTRY in
				0) #for MANDA
					# rocko-mini-manda_r2.2
					FMAC_VERSION=${MANDA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUG:: rocko-mini-manda_r2.2"
						BRANCH_RELEASE_NAME="$iMXrockominimandaStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$MANDA_FMAC_STR"
						# rocko-mini-manda
					else
						#echo "DEBUG:: rocko-mini-manda"
						BRANCH_RELEASE_NAME="$iMXrockominimandaDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$MANDA_FMAC_STR"
					fi
					break
					;;
				1) # for KONG
					FMAC_VERSION=${KONG_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUG:: rocko-mini-kong_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominikongStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$KONG_FMAC_STR"
						# rocko-mini-kong
					else
						#echo "DEBUG:: rocko-mini-kong"
						BRANCH_RELEASE_NAME="$iMXrockominikongDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$KONG_FMAC_STR"
					fi
					break
					;;
				2) # for ZIGRA
					FMAC_VERSION=${ZIGRA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: rocko-mini-zigra_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominizigraStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$ZIGRA_FMAC_STR"
						# rocko-mini-zigra
					else
						#echo "DEBUG:: rocko-mini-zigra"
						BRANCH_RELEASE_NAME="$iMXrockominizigraDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$ZIGRA_FMAC_STR"
					fi
					break
					;;
				3) # for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: rocko-mini-spiga_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominispigaStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$SPIGA_FMAC_STR"
						# rocko-mini-spiga
					else
						#echo "DEBUG:: rocko-mini-SPIGA"
						BRANCH_RELEASE_NAME="$iMXrockominispigaDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$SPIGA_FMAC_STR"
					fi
					break
					;;
				4) # for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: rocko-mini-baragon_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominibaragonStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$BARAGON_FMAC_STR"
						# rocko-mini-baragon
					else
						#echo "DEBUG:: rocko-mini-BARAGON"
						BRANCH_RELEASE_NAME="$iMXrockominibaragonDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$BARAGON_FMAC_STR"
					fi
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_4_14_98)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $MANDA_FMAC_STR - Old release                               |"
				echo     "|  1.   | $KONG_FMAC_STR - Old release                                |"
				echo     "|  2.   | $ZIGRA_FMAC_STR - Old release                               |"
				echo     "|  3.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  4.   | $BARAGON_FMAC_STR - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " ENTRY
				case $ENTRY in
				0) # for MANDA
					FMAC_VERSION=${MANDA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-manda_r1.2"
						BRANCH_RELEASE_NAME="$iMXsumomandaStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$MANDA_FMAC_STR"
					# sumo-manda
					else
						#echo "DEBUG:: sumo-manda"
						BRANCH_RELEASE_NAME="$iMXsumomandaDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$MANDA_FMAC_STR"
					fi
					break
					;;
				1) #for KONG
					FMAC_VERSION=${KONG_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-kong_r1.1"
						BRANCH_RELEASE_NAME="$iMXsumokongStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$KONG_FMAC_STR"
					# sumo-kong
					else
						#echo "DEBUG:: sumo-kong"
						BRANCH_RELEASE_NAME="$iMXsumokongDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$KONG_FMAC_STR"
					fi
					break
					;;
				2) #for ZIGRA
					FMAC_VERSION=${ZIGRA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-zigra_r1.0"
						BRANCH_RELEASE_NAME="$iMXsumozigraStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$ZIGRA_FMAC_STR"
					# sumo-kong
					else
						#echo "DEBUG:: sumo-zigra"
						BRANCH_RELEASE_NAME="$iMXsumozigraDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$ZIGRA_FMAC_STR"
					fi
					break
					;;
				3) #for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-spiga_r1.0"
						BRANCH_RELEASE_NAME="$iMXsumospigaStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$SPIGA_FMAC_STR"
					# sumo-kong
					else
						#echo "DEBUG:: sumo-zigra"
						BRANCH_RELEASE_NAME="$iMXsumospigaDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$SPIGA_FMAC_STR"
					fi
					break
					;;
				4) #for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-baragon_r1.0"
						BRANCH_RELEASE_NAME="$iMXsumobaragonStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$BARAGON_FMAC_STR"
					# sumo-baragon
					else
						#echo "DEBUG:: sumo-baragon"
						BRANCH_RELEASE_NAME="$iMXsumobaragonDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$BARAGON_FMAC_STR"
					fi
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_5_4_47)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $ZIGRA_FMAC_STR - Old release                               |"
				echo     "|  1.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  2.   | ${BARAGON_FMAC_STR} - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " FMAC_VERSION
				case $FMAC_VERSION in
				0)
					# for ZIGRA
					FMAC_VERSION=${ZIGRA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: zeus-zigra"
						BRANCH_RELEASE_NAME="$iMXzeuszigraStableReleaseTag"
					else
						#echo "DEBUG:: zeus-zigra"
						BRANCH_RELEASE_NAME="$iMXzeuszigraDeveloperRelease"
					fi
					iMXYoctoRelease="$imxzeusYocto"
					YoctoBranch="zeus"
					fmacversion=${ZIGRA_FMAC_STR}
					break
					;;
				1)
					# for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: zeus-spiga"
						BRANCH_RELEASE_NAME="$iMXzeusspigaStableReleaseTag"
					else
						#echo "DEBUG:: zeus-spiga"
						BRANCH_RELEASE_NAME="$iMXzeusspigaDeveloperRelease"
					fi
					iMXYoctoRelease="$imxzeusYocto"
					YoctoBranch="zeus"
					fmacversion=${SPIGA_FMAC_STR}
					break
					;;
				2)
					# for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: zeus-baragon"
						BRANCH_RELEASE_NAME="$iMXzeusbaragonStableReleaseTag"
					else
						#echo "DEBUG:: zeus-baragon"
						BRANCH_RELEASE_NAME="$iMXzeusbaragonDeveloperRelease"
					fi
					iMXYoctoRelease="$imxzeusYocto"
					YoctoBranch="zeus"
					fmacversion=${BARAGON_FMAC_STR}
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_5_10_52)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo -e  "|  0.   | ${CYNDER_FMAC_STR} - ${GRN}Latest release${NC}                           |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " FMAC_VERSION
				case $FMAC_VERSION in
				0)
					# for CYNDER
					FMAC_VERSION=${CYNDER_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: hardknott-cynder"
						BRANCH_RELEASE_NAME="$iMXhardknottcynderStableReleaseTag"
					else
						#echo "DEBUG:: hardknott-cynder"
						BRANCH_RELEASE_NAME="$iMXhardknottcynderDeveloperRelease"
					fi
					iMXYoctoRelease="$imxhardknottYocto"
					YoctoBranch="hardknott"
					fmacversion=${CYNDER_FMAC_STR}
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
else
	while true; do
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_9_123) #for 4.9.123_2.3.0
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  1.   | $BARAGON_FMAC_STR - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " ENTRY
				case $ENTRY in
				0) # for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: rocko-mini-spiga_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominispigaStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$SPIGA_FMAC_STR"
						# rocko-mini-spiga
					else
						#echo "DEBUG:: rocko-mini-SPIGA"
						BRANCH_RELEASE_NAME="$iMXrockominispigaDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$SPIGA_FMAC_STR"
					fi
					break
					;;
				1) # for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION" = "y" ]; then
						#echo "DEBUGG:: rocko-mini-baragon_r1.0"
						BRANCH_RELEASE_NAME="$iMXrockominibaragonStableReleaseTag"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$BARAGON_FMAC_STR"
						# rocko-mini-baragon
					else
						#echo "DEBUG:: rocko-mini-BARAGON"
						BRANCH_RELEASE_NAME="$iMXrockominibaragonDeveloperRelease"
						iMXYoctoRelease="$imxrockominiYocto"
						YoctoBranch="rocko"
						fmacversion="$BARAGON_FMAC_STR"
					fi
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_4_14_98)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  1.   | $BARAGON_FMAC_STR - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " ENTRY
				case $ENTRY in
				0) #for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-spiga_r1.0"
						BRANCH_RELEASE_NAME="$iMXsumospigaStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$SPIGA_FMAC_STR"
					# sumo-kong
					else
						#echo "DEBUG:: sumo-zigra"
						BRANCH_RELEASE_NAME="$iMXsumospigaDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$SPIGA_FMAC_STR"
					fi
					break
					;;
				1) #for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: sumo-baragon_r1.0"
						BRANCH_RELEASE_NAME="$iMXsumobaragonStableReleaseTag"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$BARAGON_FMAC_STR"
					# sumo-baragon
					else
						#echo "DEBUG:: sumo-baragon"
						BRANCH_RELEASE_NAME="$iMXsumobaragonDeveloperRelease"
						iMXYoctoRelease="$imxsumoYocto"
						YoctoBranch="sumo"
						fmacversion="$BARAGON_FMAC_STR"
					fi
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_5_4_47)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo     "|  0.   | $SPIGA_FMAC_STR - Previous release                          |"
				echo -e  "|  1.   | ${BARAGON_FMAC_STR} - ${GRN}Latest release${NC}                          |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " FMAC_VERSION
				case $FMAC_VERSION in
				0)
					# for SPIGA
					FMAC_VERSION=${SPIGA_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: zeus-spiga"
						BRANCH_RELEASE_NAME="$iMXzeusspigaStableReleaseTag"
					else
						#echo "DEBUG:: zeus-spiga"
						BRANCH_RELEASE_NAME="$iMXzeusspigaDeveloperRelease"
					fi
					iMXYoctoRelease="$imxzeusYocto"
					YoctoBranch="zeus"
					fmacversion=${SPIGA_FMAC_STR}
					break
					;;
				1)
					# for BARAGON
					FMAC_VERSION=${BARAGON_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: zeus-baragon"
						BRANCH_RELEASE_NAME="$iMXzeusbaragonStableReleaseTag"
					else
						#echo "DEBUG:: zeus-baragon"
						BRANCH_RELEASE_NAME="$iMXzeusbaragonDeveloperRelease"
					fi
					iMXYoctoRelease="$imxzeusYocto"
					YoctoBranch="zeus"
					fmacversion=${BARAGON_FMAC_STR}
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		$LINUX_KERNEL_5_10_52)
			while true; do
				echo     "-------------------------------------------------------------"
				echo     "| Entry | "\""fmac"\"" version                                    |"
				echo     "|-------|---------------------------------------------------|"
				echo -e  "|  0.   | ${CYNDER_FMAC_STR} - ${GRN}Latest release${NC}                           |"
				echo     "-------------------------------------------------------------"
				read -p "Select which entry? " FMAC_VERSION
				case $FMAC_VERSION in
				0)
					# for CYNDER
					FMAC_VERSION=${CYNDER_FMAC_INDEX}
					if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
						#echo "DEBUG:: hardknott-cynder"
						BRANCH_RELEASE_NAME="$iMXhardknottcynderStableReleaseTag"
					else
						#echo "DEBUG:: hardknott-cynder"
						BRANCH_RELEASE_NAME="$iMXhardknottcynderDeveloperRelease"
					fi
					iMXYoctoRelease="$imxhardknottYocto"
					YoctoBranch="hardknott"
					fmacversion=${CYNDER_FMAC_STR}
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					echo $'\n'
					;;
				esac
			done
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
fi
echo -e "${GRN}Selected : $fmacversion${NC}"

if [ "${LEGACY_PLATFORM_SUPPORT}" = "ON" ]; then
	while true; do
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_1_15) # for 4.1.15_2.0.0
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select target"
				echo "----------------"
				echo " "
				echo "----------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number  |"
				echo "|--------|-------------------|---------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK              |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK             |"
				echo "|  3     |  imx6sxsabresd    | MCIMX6SX-SDB              |"
				echo "|  4     |  imx6qsabresd     | MCIMX6Q-SDB               |"
				echo "|  5     |  imx6qpsabresd    | MCIMX6QP-SDB              |"
				echo "|  6     |  imx6dlsabresd    | MCIMX6Q-SDB               |"
				echo "|  7     |  imx7dsabresd     | MCIMX7SABRE               |"
				echo "----------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6sxsabresd
					PART_NUMBER=MCIMX6SX-SDB
					break
					;;
				4)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB 
					break
					;;
				5)
					TARGET_NAME=imx6qpsabresd
					PART_NUMBER=MCIMX6QP-SDB
					break
					;;
				6)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				7)
					TARGET_NAME=imx7dsabresd
					PART_NUMBER=MCIMX7SABRE
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done

			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_4_9_123) #for 4.9.123_2.3.0
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6sxsabresd    | MCIMX6SX-SDB             |"
				echo "|  4     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  5     |  imx6qpsabresd    | MCIMX6QP-SDB             |"
				echo "|  6     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  7     |  imx7dsabresd     | MCIMX7SABRE              |"
				echo "|  8     |  imx7ulpevk       | MCIMX7ULP-EVK            |"
				echo "|  9     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  10    |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "|  11    |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  12    |  imx8mmddr4evk    | 8MMINID4-EVK             |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION

				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6sxsabresd
					PART_NUMBER=MCIMX6SX-SDB
					break
					;;
				4)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx6qpsabresd
					PART_NUMBER=MCIMX6QP-SDB
					break
					;;
				6)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				7)
					TARGET_NAME=imx7dsabresd
					PART_NUMBER=MCIMX7SABRE
					break
					;;
				8)
					TARGET_NAME=imx7ulpevk
					PART_NUMBER=MCIMX7ULP-EVK
					break
					;;
				9)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				10)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				11)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				12)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8mmddr4evk
					PART_NUMBER=8MMINID4-EVK
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_4_14_98)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6sxsabresd    | MCIMX6SX-SDB             |"
				echo "|  4     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  5     |  imx6qpsabresd    | MCIMX6QP-SDB             |"
				echo "|  6     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  7     |  imx7dsabresd     | MCIMX7SABRE              |"
				echo "|  8     |  imx7ulpevk       | MCIMX7ULP-EVK            |"
				echo "|  9     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  10    |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "|  11    |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  12    |  imx8mmddr4evk    | 8MMINID4-EVK             |"
				echo "|  13    |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6sxsabresd
					PART_NUMBER=MCIMX6SX-SDB
					break
					;;
				4)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;

				5)
					TARGET_NAME=imx6qpsabresd
					PART_NUMBER=MCIMX6QP-SDB
					break
					;;
				6)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				7)
					TARGET_NAME=imx7dsabresd
					PART_NUMBER=MCIMX7SABRE
					break
					;;
				8)
					TARGET_NAME=imx7ulpevk
					PART_NUMBER=MCIMX7ULP-EVK
					break
					;;
				9)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				10)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				11)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				12)
					TARGET_NAME=imx8mmddr4evk
					PART_NUMBER=8MMINID4-EVK
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				13)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			break
			;;
		$LINUX_KERNEL_5_4_47)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6sxsabresd    | MCIMX6SX-SDB             |"
				echo "|  4     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  5     |  imx6qpsabresd    | MCIMX6QP-SDB             |"
				echo "|  6     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  7     |  imx7dsabresd     | MCIMX7SABRE              |"
				echo "|  8     |  imx7ulpevk       | MCIMX7ULP-EVK            |"
				echo "|  9     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  10    |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  11    |  imx8mmddr4evk    | 8MMINID4-EVK             |"
				echo "|  12    |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "|  13    |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6sxsabresd
					PART_NUMBER=MCIMX6SX-SDB
					break
					;;
				4)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx6qpsabresd
					PART_NUMBER=MCIMX6QP-SDB
					break
					;;
				6)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				7)
					TARGET_NAME=imx7dsabresd
					PART_NUMBER=MCIMX7SABRE
					break
					;;
				8)
					TARGET_NAME=imx7ulpevk
					PART_NUMBER=MCIMX7ULP-EVK
					break
					;;
				9)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				10)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				11)
					TARGET_NAME=imx8mmddr4evk
					PART_NUMBER=8MMINID4-EVK
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				12)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				13)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_5_10_52)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6sxsabresd    | MCIMX6SX-SDB             |"
				echo "|  4     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  5     |  imx6qpsabresd    | MCIMX6QP-SDB             |"
				echo "|  6     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  7     |  imx7dsabresd     | MCIMX7SABRE              |"
				echo "|  8     |  imx7ulpevk       | MCIMX7ULP-EVK            |"
				echo "|  9     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  10    |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  11    |  imx8mmddr4evk    | 8MMINID4-EVK             |"
				echo "|  12    |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "|  13    |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6sxsabresd
					PART_NUMBER=MCIMX6SX-SDB
					break
					;;
				4)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx6qpsabresd
					PART_NUMBER=MCIMX6QP-SDB
					break
					;;
				6)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				7)
					TARGET_NAME=imx7dsabresd
					PART_NUMBER=MCIMX7SABRE
					break
					;;
				8)
					TARGET_NAME=imx7ulpevk
					PART_NUMBER=MCIMX7ULP-EVK
					break
					;;
				9)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				10)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				11)
					TARGET_NAME=imx8mmddr4evk
					PART_NUMBER=8MMINID4-EVK
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				12)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				13)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
else
	while true; do
		case $LINUX_KERNEL in
		$LINUX_KERNEL_4_1_15) # for 4.1.15_2.0.0
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select target"
				echo "----------------"
				echo " "
				echo "----------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number  |"
				echo "|--------|-------------------|---------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK              |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK             |"
				echo "|  3     |  imx6qsabresd     | MCIMX6Q-SDB               |"
				echo "|  4     |  imx6dlsabresd    | MCIMX6Q-SDB               |"
				echo "----------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB 
					break
					;;
				4)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done

			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_4_9_123) #for 4.9.123_2.3.0
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  4     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  5     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  6     |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "|  7     |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION

				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				4)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				6)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				7)
					LINUX_SRC=linux-imx_4.9.123.bbappend.8MQ
					LINUX_DEST=linux-imx_4.9.123.bbappend
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_4_14_98)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  4     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  5     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  6     |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "|  7     |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  8     |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;

				4)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				6)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				7)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				8)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_4.14.98.bbappend.8MQ
					LINUX_DEST=linux-imx_4.14.98.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			break
			;;
		$LINUX_KERNEL_5_4_47)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  4     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  5     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  6     |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  7     |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "|  8     |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				4)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				6)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				7)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				8)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_5.4.bbappend.8MQ
					LINUX_DEST=linux-imx_5.4.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		$LINUX_KERNEL_5_10_52)
			while true; do
				echo " "
				echo "${STEP_COUNT}) Select Target"
				echo "----------------"
				echo " "
				echo "---------------------------------------------------------"
				echo "| Entry  |    Target Name    | NXP i.MX EVK Part Number |"
				echo "|--------|-------------------|--------------------------|"
				echo "|  1     |  imx6ulevk        | MCIMX6UL-EVK             |"
				echo "|  2     |  imx6ull14x14evk  | MCIMX6ULL-EVK            |"
				echo "|  3     |  imx6qsabresd     | MCIMX6Q-SDB              |"
				echo "|  4     |  imx6dlsabresd    | MCIMX6Q-SDB              |"
				echo "|  5     |  imx8mqevk        | MCIMX8M-EVKB             |"
				echo "|  6     |  imx8mmevk        | 8MMINILPD4-EVK           |"
				echo "|  7     |  imx8mnddr4evk    | 8MNANOD4-EVK             |"
				echo "|  8     |  imx8qxpmek       | MCIMX8QXP-CPU            |"
				echo "---------------------------------------------------------"
				echo -n "Select your entry: "
				read TARGET_OPTION
				case $TARGET_OPTION in
				1)
					TARGET_NAME=imx6ulevk
					PART_NUMBER=MCIMX6UL-EVK
					break
					;;
				2)
					TARGET_NAME=imx6ull14x14evk
					PART_NUMBER=MCIMX6ULL-EVK
					break
					;;
				3)
					TARGET_NAME=imx6qsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				4)
					TARGET_NAME=imx6dlsabresd
					PART_NUMBER=MCIMX6Q-SDB
					break
					;;
				5)
					TARGET_NAME=imx8mqevk
					PART_NUMBER=MCIMX8M-EVKB
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				6)
					TARGET_NAME=imx8mmevk
					PART_NUMBER=8MMINILPD4-EVK
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				7)
					TARGET_NAME=imx8mnddr4evk
					PART_NUMBER=8MNANOD4-EVK
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				8)
					TARGET_NAME=imx8qxpmek
					PART_NUMBER=MCIMX8QXP-CPU
					LINUX_SRC=linux-imx_5.10.bbappend.8MQ
					LINUX_DEST=linux-imx_%.bbappend
					DISTRO_NAME=fsl-imx-wayland
					break
					;;
				*)
					echo -e "${RED}That is not a valid choice, try again.${NC}"
					;;
				esac
			done
			echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
			echo $'\n'
			break
			;;
		*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
	done
fi

(( STEP_COUNT += 1 ))

echo "${STEP_COUNT}) Select DISTRO & Image"
echo "------------------------"
echo " "
echo "Murata default DISTRO & Image pre-selected are:"
echo -e "${GRN}DISTRO: $DISTRO_NAME${NC}"

select_default_image

echo -e "${GRN}Image:  $IMAGE_NAME${NC}"
echo " "
echo -e -n "Proceed with this configuration? ${GRN}Y${NC}/${YLW}n${NC}: "
read PROMPT

if [ "$PROMPT" = "n" ] || [ "$PROMPT" = "N" ]; then
	echo -e "${YLW}Select unsupported options (for DISTRO and Image) by entering: "\""U"\"" at the next prompt."
	echo " "
	echo -e -n "Do you REALLY want to proceed ?: U${NC}: "
	read PROMPT


	if [ "$PROMPT" = "U" ] || [ "$PROMPT" = "u" ]; then
		# For 5.4.47 onwards, as per i.MX Yocto Project Users Guide, x11 Distro is no longer supported
		if [ ${linuxVersion} = ${LINUX_KERNEL_5_4_47_STR} ] || [ ${linuxVersion} = ${LINUX_KERNEL_5_10_52_STR} ]; then
			select_supported_distros_for_5_x_onwards
		else
			select_previous_distros_supported
		fi		
		echo -e "${GRN}Selected DISTRO: $DISTRO_NAME. ${NC}"
	else
		echo -e "${GRN}Proceeding with Murata default DISTRO: $DISTRO_NAME${NC}"
	fi

	# Prompting the user to select which image to build
	if [ "$PROMPT" = "U" ] || [ "$PROMPT" = "u" ]; then
		echo ""
		echo " "
		select_build_image_name
	else
		echo -e "${GRN}Proceeding with Murata default Image:  $IMAGE_NAME${NC}"
	fi
else
	echo -e "${GRN}Proceeding with Murata defaults.${NC}"
fi

(( STEP_COUNT += 1 ))

#echo $'\n'
#echo "-------------------------------Creation of Build Directory---------------------------"
echo " "
echo "${STEP_COUNT}) Creation of Build directory"
echo "-------------------------------"
echo " "
echo "Ex: <build-imx6ulevk-x11> for imx6ulevk with x11 backend"
echo "Ex: <build-xwayland-imx8mq> for imx8mqevk with xwayland backend"
echo " "
echo "NOTE: The directory will be created in your <fsl-yocto-bsp-release> folder."
while true; do

export CWD=`pwd`
#echo "DEBUG:: :Current working directory :: $CWD"
echo " "
echo -n "Enter build directory name: "
read BUILD_DIR_NAME

#To check if a directory exists
	if [ "$BUILD_DIR_NAME" = "" ]; then
		echo -e "Provide a valid build directory${RED}.....FAIL${NC}"
	elif [ -d "$BUILD_DIR_NAME" ]; then
		echo -e "${RED}Error: Conflict with existing build directory - $BUILD_DIR_NAME.${NC}"
		echo " "
		echo "You have 2 options:"
		echo "1. You can provide another build directory name. "
		echo "2. If this is a continuation of a build that was aborted, then"
		echo "   (a) Execute the following command from BSP directory:"
		echo "       $ source setup-environment $BUILD_DIR_NAME"
		echo "   (b) Execute the following command from $BUILD_DIR_NAME directory:"
		echo "       $ bitbake fsl-imaga-validation-imx"
		echo " "
		read -p "Select which entry 1 or 2? " DIR_OPTION
		if [ "$DIR_OPTION" = "2" ]; then
			echo "${RED}Build script has been termintated.${NC}"
			exit
		fi
	else
		#echo "DEBUG:: NEW DIRECTORY: $BUILD_DIR_NAME"
		break
	fi
done
(( STEP_COUNT += 1 ))

echo " "
echo "${STEP_COUNT}) Verify your selection"
echo "-------------------------"
echo " "
(( STEP_COUNT += 1 ))

echo -e "i.MX Yocto Release              : ${GRN}$iMXYoctoRelease${NC}"
echo -e "Yocto branch                    : ${GRN}$YoctoBranch${NC}"
echo -e "fmac version                    : ${GRN}$fmacversion${NC}"
echo -e "Target                          : ${GRN}$TARGET_NAME${NC}"
echo -e "NXP i.MX EVK Part Number        : ${GRN}$PART_NUMBER${NC}"
echo -e "meta-murata-wireless Release Tag: ${GRN}$BRANCH_RELEASE_NAME${NC}"
echo -e "DISTRO                          : ${GRN}$DISTRO_NAME${NC}"
echo -e "Image                           : ${GRN}$IMAGE_NAME ${NC}"
echo -e "Build Directory                 : ${GRN}$BUILD_DIR_NAME${NC}"
echo " "
echo "Please verify your selection"


echo -e -n "Do you accept selected configurations ? ${GRN}Y${NC}/${YLW}n${NC}: "
read REPLY

if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ "$REPLY" = "" ]; then
	echo " "
	echo "${STEP_COUNT}) Acceptance of End User License Agreement(EULA)"
	echo "--------------------------------------------------"
	echo " "
	#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
	echo "********************************************************************************"
	echo "* Thank you for entering necessary configuration!                             *"
	echo "* Please be patient to complete the last phase of the build script process.    *"
	echo "* Final steps of the build script require user to review and accept            *"
	echo "* NXP/Freescale Software License Agreement.                                    *"
	echo "*                                                                              *"
	echo -e "* ${YLW}NOTE: It may take several minutes to display EULA Agreement.                 ${NC}*"
	echo "*                                                                              *"
	echo -e "* User is prompted to enter space bar to fully display EULA Agreement OR "\'"q"\'"   *"
	echo "* to quit reading entire EULA.                                                 *"
	echo "*                                                                              *"
	echo "* Please enter space bar (repeatedly)  OR 'q' until you see the final EULA     *"
	echo "* acceptance prompt as shown below:                                            *"
	echo "*                                                                              *"
	echo -e "* ${GRN}Do you accept the EULA you just read? (y/n)                                  ${NC}*"
	echo "*                                                                              *"
	echo "* Please make sure to enter 'y', so build script continues.                    *"
	echo "* Once EULA has been successfully accepted following line is displayed:        *"
	echo "*                                                                              *"
	echo -e "* ${GRN}EULA has been accepted.${NC}                                                      *"
	echo "*                                                                              *"
	echo "* Once EULA is accepted, final step (last User Prompt) is to kick off Yocto    *"
	echo "* build.                                                                       *"
	echo "********************************************************************************"
	echo " "
	(( STEP_COUNT += 1 ))


	while true; do
	echo -e -n "Do you want to continue? ${GRN}Y${NC}/${YLW}n${NC}: "
	read PROCEED_OPTION

	if [ "$PROCEED_OPTION" = "Y" ] || [ "$PROCEED_OPTION" = "y" ] || [ "$PROCEED_OPTION" = "" ]; then
		break
	elif [ "$PROCEED_OPTION" = "n" ] || [ "$PROCEED_OPTION" = "N" ]; then
		echo -e "${RED}Exiting script.....${NC}"
		exit
	else
		echo -e "${RED}That is not a valid choice, try again.${NC}"
	fi
	done

	# Invoke Repo Init based on Yocto Release
	if [ "$iMXYoctoRelease" = "$imxhardknottYocto" ]; then
		#echo "DEBUG:: IMXALL-HARDKNOTT"
		$REPO_PATH/repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.52-2.1.0.xml
	elif [ "$iMXYoctoRelease" = "$imxzeusYocto" ]; then
		#echo "DEBUG:: IMXALL-ZEUS"
		$REPO_PATH/repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-zeus -m imx-5.4.47-2.2.0.xml
	elif [ "$iMXYoctoRelease" = "$imxsumoYocto" ]; then
		#echo "DEBUG:: IMXALL-SUMO"
		$REPO_PATH/repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-sumo -m imx-4.14.98-2.3.0.xml
	elif [ "$iMXYoctoRelease" = "$imxrockominiYocto" ]; then
		#echo "DEBUG:: IMXALL-ROCKO-MINI"
		$REPO_PATH/repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-rocko -m imx-4.9.123-2.3.0-8mm_ga.xml
	elif [ "$iMXYoctoRelease" = "$imxkrogothYocto"  ]; then
		#echo "DEBUG:: KROGOTH"
		$REPO_PATH/repo init -u https://source.codeaurora.org/external/imx/fsl-arm-yocto-bsp.git -b imx-4.1-krogoth -m imx-4.1.15-2.1.1.xml
	fi

	#echo "DEBUG:: Performing repo sync......."
	$REPO_PATH/repo sync
	cd $BSP_DIR


	#echo "DEBUG:: Performing Setup of DISTRO and MACHINE"
	#echo "DEBUG:: pwd = $BSP_DIR"
	if [ "$iMXYoctoRelease" = "$imxzeusYocto" ] || [ "$iMXYoctoRelease" = "$imxhardknottYocto" ]; then
		DISTRO=$DISTRO_NAME MACHINE=$TARGET_NAME source ./imx-setup-release.sh -b $BUILD_DIR_NAME
	else
		DISTRO=$DISTRO_NAME MACHINE=$TARGET_NAME source ./fsl-setup-release.sh -b $BUILD_DIR_NAME
	fi
	export BUILD_DIR=`pwd`

	cd $BSP_DIR/sources
	# check to see if there is already a folder with name, "meta-murata-wireless"
	# if it is, then exit
	TEST_DIR_NAME=meta-murata-wireless
	if [ -d "$TEST_DIR_NAME" ]; then
		echo " "
		echo -e "${YLW}NOTE:${NC} $TEST_DIR_NAME already present in sources folder. This happens if this is not a clean build."
		echo " "
		echo -n -e "Do you want to delete this folder and fetch the latest version? (Selecting 'n' will use the existing copy) ${GRN}Y${NC}/${YLW}n${NC}: "
		read PROCEED_UPDATE_OPTION

		if [ "$PROCEED_UPDATE_OPTION" = "y" ] || [ "$PROCEED_UPDATE_OPTION" = "Y" ] || [ "$PROCEED_UPDATE_OPTION" = "" ]; then
			rm -rf $TEST_DIR_NAME
			git clone $META_MURATA_WIRELESS_GIT
		else
			echo " "
			echo -e "${RED}Murata: Skipping $TEST_DIR_NAME download...${NC}"
		fi
	else
		git clone $META_MURATA_WIRELESS_GIT
	fi

	cd meta-murata-wireless

	git checkout $BRANCH_RELEASE_NAME
	cd $BSP_DIR
	echo "Build Image"
	chmod 777 sources/meta-murata-wireless/add-murata-layer-script/add-murata-wireless.sh
	sh ./sources/meta-murata-wireless/add-murata-layer-script/add-murata-wireless.sh $BUILD_DIR_NAME
	cd $BSP_DIR/sources/meta-murata-wireless/recipes-kernel/linux

	#for rocko-mini-manda or kong
	if [ "$iMXYoctoRelease" = "$imxrockominiYocto" ]; then
		if [ "$FMAC_VERSION" = "$MANDA_FMAC_INDEX" ] || [ "$FMAC_VERSION" = "$KONG_FMAC_INDEX" ]; then
			#echo "DEBUG:: MANDA/KONG-LOADING-FOR-ROCKO-MINI"
			if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ]; then
				#echo "DEBUG FOR IMX8-rocko-mini: COPYING IMX8 BACKPORTS, Murata-Binaries and bbx files"
				#echo "DEBUG:: SRC::$LINUX_SRC DEST::$LINUX_SRC"
				if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
					#echo "DEBUG:: Before copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
					cp $LINUX_SRC $LINUX_DEST
					#echo "DEBUG:: After copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
				fi
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.0.bb \
					$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.0.bbx
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.0.bb \
					$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.0.bbx
				cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/backporttool-linux_1.0.bb@imx8 \
					$BSP_DIR/sources/meta-murata-wireless/recipes-kernel/backporttool-linux/backporttool-linux_1.0.bb
				cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/murata-binaries_1.0.bb@imx8 \
					$BSP_DIR/sources/meta-murata-wireless/recipes-connectivity/murata-binaries/murata-binaries_1.0.bb
			fi
		fi
	fi

	#for rocko-mini-zigra, spiga or baragon
	if [ "$iMXYoctoRelease" = "$imxrockominiYocto" ]; then
		if [ "$FMAC_VERSION" = "$ZIGRA_FMAC_INDEX" ] || [ "$FMAC_VERSION" = "$SPIGA_FMAC_INDEX" ] || [ "$FMAC_VERSION" = "$BARAGON_FMAC_INDEX" ]; then
			#echo "DEBUG:: ZIGRA/SPIGA/BARAGON-LOADING-FOR-ROCKO-MINI"
			if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ]; then
				#echo "DEBUG FOR IMX8-rocko-mini: COPYING IMX8 BACKPORTS, and bbx files"
				#echo "DEBUG:: SRC::$LINUX_SRC DEST::$LINUX_SRC"
				if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
					#echo "DEBUG:: Before copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
					cp $LINUX_SRC $LINUX_DEST
					#echo "DEBUG:: After copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
				fi
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.0.bb \
					$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.0.bbx
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.0.bb \
					$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.0.bbx
				cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/backporttool-linux_1.0.bb@imx8 \
					$BSP_DIR/sources/meta-murata-wireless/recipes-kernel/backporttool-linux/backporttool-linux_1.0.bb
			fi
		fi
	fi

	#for sumo-manda
	if [ "$FMAC_VERSION" = $MANDA_FMAC_INDEX ] && [ "$iMXYoctoRelease" = "$imxsumoYocto" ]; then
		mv $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bb $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bbx
		mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappendx
		mv $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bb $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bbx
		mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappendx

		if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
			#echo "DEBUG:: Before copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
			cp $LINUX_SRC $LINUX_DEST
			#echo "DEBUG:: After copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
		fi

		if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ] || [ "$TARGET_NAME" = "imx8mnevk" ]; then
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bb \
			$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bbx
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bb \
			$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bbx
			cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/murata-binaries_1.0.bb@imx8 \
			$BSP_DIR/sources/meta-murata-wireless/recipes-connectivity/murata-binaries/murata-binaries_1.0.bb
		fi
	fi

	#for sumo-kong
	if [ "$FMAC_VERSION" = $KONG_FMAC_INDEX ] && [ "$iMXYoctoRelease" = "$imxsumoYocto" ]; then
		mv $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bb $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bbx
		mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappendx
		mv $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bb $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bbx
		mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappendx

		if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
			#echo "DEBUG:: Before copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
			cp $LINUX_SRC $LINUX_DEST
			#echo "DEBUG:: After copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
		fi

		if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ] || [ "$TARGET_NAME" = "imx8mnddr4evk" ]; then
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bb \
			$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bbx
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bb \
			$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bbx
			cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/murata-binaries_1.0.bb@imx8 \
			$BSP_DIR/sources/meta-murata-wireless/recipes-connectivity/murata-binaries/murata-binaries_1.0.bb
		fi
	fi


	#for sumo-zigra, sumo-spiga or sumo-baragon
	if [ "$iMXYoctoRelease" = "$imxsumoYocto" ]; then
		if [ "$FMAC_VERSION" = $SPIGA_FMAC_INDEX ] || [ "$FMAC_VERSION" = $ZIGRA_FMAC_INDEX ] || [ "$FMAC_VERSION" = $BARAGON_FMAC_INDEX ]; then
			mv $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bb $BSP_DIR/sources/meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.6.bbx
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/hostapd/hostapd_%.bbappendx
			mv $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bb $BSP_DIR/sources/poky/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.6.bbx
			mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappendx

			if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
				#echo "DEBUG:: Before copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
				cp $LINUX_SRC $LINUX_DEST
				#echo "DEBUG:: After copying SRC::$LINUX_SRC DEST::$LINUX_DEST"
			fi

			if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ] || [ "$TARGET_NAME" = "imx8mnddr4evk" ]; then
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bb \
				$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca6174_2.1.bbx
				mv $BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bb \
				$BSP_DIR/sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/kernel-modules/kernel-module-qca9377_2.1.bbx
				cp -f $BSP_DIR/sources/meta-murata-wireless/freescale/backporttool-linux_1.0.bb@imx8 \
				$BSP_DIR/sources/meta-murata-wireless/recipes-kernel/backporttool-linux/backporttool-linux_1.0.bb
			fi
		fi
	fi

	# for zeus and hardknott
	if [ "$iMXYoctoRelease" = "$imxzeusYocto" ] || [ "$iMXYoctoRelease" = "$imxhardknottYocto" ]; then
		if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
			cp $LINUX_SRC $LINUX_DEST
		fi
	fi

	cd $BUILD_DIR

	echo " "
	echo "${STEP_COUNT}) Starting Build Now."
	echo "-----------------------"
	echo " "
	echo -e "${YLW}NOTE: depending on machine type, build may take 1-7 hours to complete.${NC}"
	echo " "
	echo ""\'"Y"\'" to continue, "\'"n"\'" aborts build."
	echo -e -n "Do you want to start the build ? ${GRN}Y${NC}/${YLW}n${NC}: "
	read PROCEED_BUILD
	(( STEP_COUNT += 1 ))

	if [ "$PROCEED_BUILD" = "y" ] || [ "$PROCEED_BUILD" = "Y" ] || [ "$PROCEED_BUILD" = "" ] ; then
		bitbake $IMAGE_NAME
		cd $BSP_DIR
		rm -rf repo-murata
		exit
	else
		echo -e "${RED}Exiting script.....${NC}"
		exit
	fi
else
	echo -e "${RED}Exiting script.....${NC}"
	exit
fi

#*************************************** For i.MX - end *****************************************
