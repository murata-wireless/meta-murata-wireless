#!/bin/bash
VERSION=05092024


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
#  1.14     | 11/18/2021   |    RC        |    Removed CYW/IFX into seperate script. Renamed script.
#  1.15     | 11/22/2021   |    RC        |    Added support for hardknott.
#  1.16     | 12/20/2021   |    RC        |    Added support for i.MX8DXL.
#  1.17     | 01/13/2022   |    RC        |    Removed support for 5.4.47, added support for 5.10.72.
#  1.18     | 03/22/2022   |    JK        |    Fix the file name of Murata_Wirless_Yocto_Build to NXP
#  1.19     | 03/23/2022   |    JK        |    Fix build script error for copying bbappend file.
#           |              |              |    Add support for 8M-PLUS.
#  1.20     | 03/24/2022   |    JK        |    Made the image build to fsl-image-validation-imx for
#           |              |              |    8M-PLUS.
#  1.21     | 04/26/2022   |    JK        |    Rename Murata_Wireless_Yocto_Build to 
#           |              |              |    Murata_Wireless_Yocto_Build_CYW.sh.
#  1.22     | 03/16/2023   |    RC        |    Added support for 5.15.32.
#  1.23     | 04/25/2023   |    RC        |    Updated to use correct NXP repositories.
#  1.24     | 04/28/2023   |    JK        |    Updated to support 22.04.
#  1.25     | 06/12/2023   |    RC        |    Added support for Linux 6.1.1.
#  1.26     | 10/13/2023   |    RC        |    Added support for Linux 6.1.36.
#  1.27     | 05/09/2024   |    RC        |    Added support for Linux 6.6.3.
####################################################################################################

# Use colors to highlight pass/fail conditions.
RED='\033[1;31m' # Red font to flag errors
GRN='\033[1;32m' # Green font to flag pass
YLW='\033[1;33m' # Yellow font for highlighting
NC='\033[0m' # No Color

#--------------------------- Variables-----------------------------------------------------------
STEP_COUNT=1

# BSP directory
export BSP_DIR=`pwd`

# Initialize variables
LINUX_SRC=""
LINUX_DEST=""
CWD=""

LINUX_KERNEL_5_10_52=0
LINUX_KERNEL_5_10_72=1
LINUX_KERNEL_5_15_32=2
LINUX_KERNEL_6_1_1=3
LINUX_KERNEL_6_1_36=4
LINUX_KERNEL_6_6_3=5

# Linux Kernel Strings
LINUX_KERNEL_5_10_52_STR="5.10.52"
LINUX_KERNEL_5_10_72_STR="5.10.72"
LINUX_KERNEL_5_15_32_STR="5.15.32"
LINUX_KERNEL_6_1_1_STR="6.1.1"
LINUX_KERNEL_6_1_36_STR="6.1.36"
LINUX_KERNEL_6_6_3_STR="6.6.3"

DISTRO_NAME=fsl-imx-fb
IMAGE_NAME=core-image-base

iMXYoctoRelease=""
YoctoBranch=""
linuxVersion=""

iMXhardknott52StableReleaseTag="imx-hardknott-5-10-52_r1.0"
iMXhardknott52DeveloperRelease="imx-hardknott-5-10-52"

iMXhardknott72StableReleaseTag="imx-hardknott-5-10-72_r1.0"
iMXhardknott72DeveloperRelease="imx-hardknott-5-10-72"

iMXkirkstoneStableReleaseTag="imx-kirkstone-5-15-32_r1.0"
iMXkirkstoneDeveloperRelease="imx-kirkstone-5-15-32"

iMXlangdaleStableReleaseTag="imx-langdale-6-1-1_r1.0"
iMXlangdaleDeveloperRelease="imx-langdale-6-1-1"

iMXmickledoreStableReleaseTag="imx-mickledore-6-1-36_r1.0"
iMXmickledoreDeveloperRelease="imx-mickledore-6-1-36"

iMXnanbieldStableReleaseTag="imx-nanbield-6-6-3_r1.0"
iMXnanbieldDeveloperRelease="imx-nanbield-6-6-3"

imxhardknottYocto52="5.10.52_2.1.0 GA"
imxhardknottYocto72="5.10.72_2.2.0"
imxkirkstone="5.15.32_2.0.0"
imxlangdale="6.1.1_1.0.0"
imxmickledore="6.1.36_2.1.0"
imxnanbield="6.6.3_1.0.0"


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

# Get Ubuntu release version; make sure it is either 22.04, 20.04, 18.04, 16.04, 14.04 or 12.04.
Ubuntu_Release=$(lsb_release -r -s)
if [ $Ubuntu_Release == "22.04" ] || [ $Ubuntu_Release == "20.04" ] || [ $Ubuntu_Release == "18.04" ] || [ $Ubuntu_Release == "16.04" ] || [ $Ubuntu_Release == "14.04" ] || [ $Ubuntu_Release == "12.04" ]; then
	echo -e "Murata: Verified Ubuntu Release:${NC}     " ${GRN}$Ubuntu_Release${NC}
else
	echo -e "${RED}Murata: Only Ubuntu versions 22.04, 20.04, 18.04, 16.04, 14.04, and 12.04 are supported; not:" $Ubuntu_Release
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
	exit
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

# Scan through the file Murata_Wireless_Yocto_Build_NXP.sh to fetch the Revision Information
COUNTER=0
input_file_path="$SCRIPT_DIR/Murata_Wireless_Yocto_Build_NXP.sh"

while IFS= read -r LATEST_VER
do
	COUNTER=$[$COUNTER +1]
	if [ "$COUNTER" = "2" ] ; then
	break
	fi
done < "$input_file_path"

cd $BSP_DIR

# read first and second line of Murata_Wireless_Yocto_Build_NXP.sh script
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
		echo ""\$ "cp ./meta-murata-wireless/script-utils/latest/Murata_Wireless_Yocto_Build_NXP.sh ."
		echo " "
		echo -e "${YLW}Exiting script.....${NC}"
       		exit
	else
		echo " "
		echo -e "${YLW}CONTINUING WITH CURRENT SCRIPT.${NC}"
	fi
fi

#######################   Functions ##########################################################
function select_supported_distros {
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
	if [ "$TARGET_NAME" = "imx8mqevk" ] || [ "$TARGET_NAME" = "imx8qxpmek" ] || [ "$TARGET_NAME" = "imx8qxpc0mek" ] || [ "$TARGET_NAME" = "imx8mmevk" ] || [ "$TARGET_NAME" = "imx8mm-lpddr4-evk" ] || [ "$TARGET_NAME" = "imx8mmddr4evk" ] || [ "$TARGET_NAME" = "imx8mm-ddr4-evk" ] || [ "$TARGET_NAME" = "imx8mnddr4evk" ] || [ "$TARGET_NAME" = "imx8mn-ddr4-evk" ] || [ "$TARGET_NAME" = "imx8dxl-lpddr4-evk" ] || [ "$TARGET_NAME" = "imx8dxlb0-lpddr4-evk" ] || [ "$TARGET_NAME" = "imx8mp-lpddr4-evk" ]; then
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
	echo "----------------------------------------------------------------------------"
	echo "|Entry|   Linux Kernel    | Yocto      | Modules supported                 |"
	echo "|-----|-------------------|------------|------------------------------------"
	echo "|  0  |     ${LINUX_KERNEL_5_10_52_STR}       | hardknott  | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "|  1  |     ${LINUX_KERNEL_5_10_72_STR}       | hardknott  | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "|  2  |     ${LINUX_KERNEL_5_15_32_STR}       | kirkstone  | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "|  3  |     ${LINUX_KERNEL_6_1_1_STR}         | langdale   | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "|  4  |     ${LINUX_KERNEL_6_1_36_STR}        | mickledore | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "|  5  |     ${LINUX_KERNEL_6_6_3_STR}         | nanbield   | 1ZM, 1YM-SDIO, 1YM-PCIe, 1XK, 1XL |"
	echo "----------------------------------------------------------------------------"
	read -p "Select which entry? " LINUX_KERNEL

	case $LINUX_KERNEL in
	$LINUX_KERNEL_5_10_52)
		linuxVersion=${LINUX_KERNEL_5_10_52_STR}
		break
		;;
	$LINUX_KERNEL_5_10_72)
		linuxVersion=${LINUX_KERNEL_5_10_72_STR}
		break
		;;
	$LINUX_KERNEL_5_15_32)
		linuxVersion=${LINUX_KERNEL_5_15_32_STR}
		break
		;;
	$LINUX_KERNEL_6_1_1)
		linuxVersion=${LINUX_KERNEL_6_1_1_STR}
		break
		;;
	$LINUX_KERNEL_6_1_36)
		linuxVersion=${LINUX_KERNEL_6_1_36_STR}
		break
		;;
	$LINUX_KERNEL_6_6_3)
		linuxVersion=${LINUX_KERNEL_6_6_3_STR}
		break
		;;
	*)
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		echo $'\n'
		;;
	esac
done
echo -e "${GRN}Selected : $linuxVersion${NC}"
(( STEP_COUNT += 1 ))

case $LINUX_KERNEL in
$LINUX_KERNEL_5_10_52)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: hardknott release"
		BRANCH_RELEASE_NAME="$iMXhardknott52StableReleaseTag"
	else
		#echo "DEBUG:: hardknott developer"
		BRANCH_RELEASE_NAME="$iMXhardknott52DeveloperRelease"
	fi
	iMXYoctoRelease="$imxhardknottYocto52"
	YoctoBranch="hardknott"
	;;
$LINUX_KERNEL_5_10_72)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: hardknott release"
		BRANCH_RELEASE_NAME="$iMXhardknott72StableReleaseTag"
	else
		#echo "DEBUG:: hardknott developer"
		BRANCH_RELEASE_NAME="$iMXhardknott72DeveloperRelease"
	fi
	iMXYoctoRelease="$imxhardknottYocto72"
	YoctoBranch="hardknott"
	;;
$LINUX_KERNEL_5_15_32)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: kirkstone release"
		BRANCH_RELEASE_NAME="$iMXkirkstoneStableReleaseTag"
	else
		#echo "DEBUG:: kirkstone developer"
		BRANCH_RELEASE_NAME="$iMXkirkstoneDeveloperRelease"
	fi
	iMXYoctoRelease="$imxkirkstone"
	YoctoBranch="kirkstone"
	;;
$LINUX_KERNEL_6_1_1)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: langdale release"
		BRANCH_RELEASE_NAME="$iMXlangdaleStableReleaseTag"
	else
		#echo "DEBUG:: langdale developer"
		BRANCH_RELEASE_NAME="$iMXlangdaleDeveloperRelease"
	fi
	iMXYoctoRelease="$imxlangdale"
	YoctoBranch="langdale"
	;;
$LINUX_KERNEL_6_1_36)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: mickledore release"
		BRANCH_RELEASE_NAME="$iMXmickledoreStableReleaseTag"
	else
		#echo "DEBUG:: mickledore developer"
		BRANCH_RELEASE_NAME="$iMXmickledoreDeveloperRelease"
	fi
	iMXYoctoRelease="$imxmickledore"
	YoctoBranch="mickledore"
	;;
$LINUX_KERNEL_6_6_3)
	if [ "$BRANCH_TAG_OPTION" = "y" ] ; then
		#echo "DEBUG:: nanbield release"
		BRANCH_RELEASE_NAME="$iMXnanbieldStableReleaseTag"
	else
		#echo "DEBUG:: nanbield developer"
		BRANCH_RELEASE_NAME="$iMXnanbieldDeveloperRelease"
	fi
	iMXYoctoRelease="$imxnanbield"
	YoctoBranch="nanbield"
	;;
*)
	echo -e "${RED}NXP support is not avilable in this kernel.${NC}"
	exit
esac

while true; do
	case $LINUX_KERNEL in
	$LINUX_KERNEL_5_10_52)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "------------------------------------------------------------"
			echo "| Entry  |    Target Name       | NXP i.MX EVK Part Number |"
			echo "|--------|----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk           | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk     | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk           | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mmevk           | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mmddr4evk       | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mnddr4evk       | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpmek          | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxl-lpddr4-evk  | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk   | 8MPLUSLPD4-EVK           |"
			echo "------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mmevk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mmddr4evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mnddr4evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpmek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxl-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
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
	$LINUX_KERNEL_5_10_72)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "------------------------------------------------------------"
			echo "| Entry  |    Target Name       | NXP i.MX EVK Part Number |"
			echo "|--------|----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk           | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk     | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk           | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mmevk           | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mmddr4evk       | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mnddr4evk       | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpmek          | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxl-lpddr4-evk  | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk   | 8MPLUSLPD4-EVK           |"
			echo "------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mmevk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mmddr4evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mnddr4evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpmek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxl-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_5.10.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
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
	$LINUX_KERNEL_5_15_32)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "------------------------------------------------------------"
			echo "| Entry  |    Target Name       | NXP i.MX EVK Part Number |"
			echo "|--------|----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk           | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk     | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk           | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mmevk           | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mmddr4evk       | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mnddr4evk       | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpmek          | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxl-lpddr4-evk  | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk   | 8MPLUSLPD4-EVK           |"
			echo "------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mmevk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mmddr4evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mnddr4evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpmek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxl-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
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
	$LINUX_KERNEL_6_1_1)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "------------------------------------------------------------"
			echo "| Entry  |    Target Name       | NXP i.MX EVK Part Number |"
			echo "|--------|----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk           | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk     | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk           | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mmevk           | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mmddr4evk       | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mnddr4evk       | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpmek          | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxl-lpddr4-evk  | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk   | 8MPLUSLPD4-EVK           |"
			echo "------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mmevk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mmddr4evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mnddr4evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpmek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxl-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
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
	$LINUX_KERNEL_6_1_36)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "------------------------------------------------------------"
			echo "| Entry  |    Target Name       | NXP i.MX EVK Part Number |"
			echo "|--------|----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk           | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk     | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk           | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mmevk           | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mmddr4evk       | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mnddr4evk       | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpmek          | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxl-lpddr4-evk  | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk   | 8MPLUSLPD4-EVK           |"
			echo "------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mmevk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mmddr4evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mnddr4evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpmek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxl-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
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
	$LINUX_KERNEL_6_6_3)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "-------------------------------------------------------------"
			echo "| Entry  |    Target Name        | NXP i.MX EVK Part Number |"
			echo "|--------|-----------------------|--------------------------|"
			echo "|  1     |  imx6ulevk            | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk      | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx8mqevk            | MCIMX8M-EVKB             |"
			echo "|  4     |  imx8mm-lpddr4-evk    | 8MMINILPD4-EVK           |"
			echo "|  5     |  imx8mm-ddr4-evk      | 8MMINID4-EVK             |"
			echo "|  6     |  imx8mn-ddr4-evk      | 8MNANOD4-EVK             |"
			echo "|  7     |  imx8qxpc0mek         | MCIMX8QXP-CPU            |"
			echo "|  8     |  imx8dxlb0-lpddr4-evk | MCIMX8DXL-EVK            |"
			echo "|  9     |  imx8mp-lpddr4-evk    | 8MPLUSLPD4-EVK           |"
			echo "-------------------------------------------------------------"
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
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			4)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			5)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8dxlb0-lpddr4-evk
				PART_NUMBER=MCIMX8DXL-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			9)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
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
		select_supported_distros		
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
	if [ "$iMXYoctoRelease" = "$imxhardknottYocto52" ]; then
		#echo "DEBUG:: IMXALL-HARDKNOTT-52"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.52-2.1.0.xml
	elif [ "$iMXYoctoRelease" = "$imxhardknottYocto72" ]; then
		#echo "DEBUG:: IMXALL-HARDKNOTT-52"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.72-2.2.0.xml
	elif [ "$iMXYoctoRelease" = "$imxkirkstone" ]; then
		#echo "DEBUG:: IMXALL-KIRKSTONE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-kirkstone -m imx-5.15.32-2.0.0.xml
	elif [ "$iMXYoctoRelease" = "$imxlangdale" ]; then
		#echo "DEBUG:: IMXALL-LANGDALE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-langdale -m imx-6.1.1-1.0.0.xml
	elif [ "$iMXYoctoRelease" = "$imxmickledore" ]; then
		#echo "DEBUG:: IMXALL-MICKLEDORE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-mickledore -m imx-6.1.36-2.1.0.xml
	elif [ "$iMXYoctoRelease" = "$imxnanbield" ]; then
		#echo "DEBUG:: IMXALL-NANBIELD"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-nanbield -m imx-6.6.3-1.0.0.xml
	fi

	#echo "DEBUG:: Performing repo sync......."
	$REPO_PATH/repo sync
	cd $BSP_DIR


	#echo "DEBUG:: Performing Setup of DISTRO and MACHINE"
	#echo "DEBUG:: pwd = $BSP_DIR"
	DISTRO=$DISTRO_NAME MACHINE=$TARGET_NAME source ./imx-setup-release.sh -b $BUILD_DIR_NAME
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

	if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
		cp $LINUX_SRC $LINUX_DEST
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
