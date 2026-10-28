#!/bin/bash
VERSION=10282026


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
#  1.18     | 04/26/2022   |    JK        |    a) Rename Murata_Wireless_Yocto_Build to 
#           |              |              |       Murata_Wireless_Yocto_Build_CYW.sh.
#           |              |              |    b) Rename release tag
#  1.19     | 08/22/2022   |    RC        |    Added support for FMAC Drogon.
#  1.20     | 01/23/2023   |    JK        |    Added support for FMAC Ebirah.
#  1.21     | 02/12/2023   |    JK        |    Added support for FMAC Ebirah@8M-Plus.
#  1.22     | 02/24/2023   |    RC        |    Added support for FMAC Fafnir. Moved 4.9.123 kernel
#           |              |              |    support to legacy.
#  1.23     | 04/25/2023   |    RC        |    Updated to use correct NXP repositories.
#  1.24     | 04/27/2023   |    JK        |    Add support for 22.04 Ubuntu.
#  1.25     | 06/12/2023   |    RC        |    Added support for langdale.
#  1.26     | 09/08/2023   |    RC        |    Added support for FMAC Godzilla in 6.1.1.
#  1.27     | 10/10/2023   |    RC        |    Added support for FMAC Godzilla in 5.15.32.
#  1.28     | 10/31/2023   |    RC        |    Fixed supported machine names of different kernels.
#  1.29     | 11/06/2023   |    RC        |    Added support for FMAC Godzilla in 6.1.36.
#  1.30     | 06/20/2024   |    RC        |    a) Added support for FMAC Hedorah and Indrik in 6.1.36,
#           |              |              |       Indrik in 5.15.32.
#           |              |              |    b) Added support for i.MX93 and i.MX8ULP EVKs.
#  1.31     | 08/06/2024   |    RC        |    Added support for nanbield.
#  1.32     | 11/20/2024   |    RC        |    Moved 5.10.52 support to legacy.
#  1.33     | 12/16/2024   |    RC        |    Added support for FMAC Jaculus, BSP Scarthgap
#  1.34     | 12/19/2024   |    RC        |    Added support for FMAC Jaculus in 6.1.36 and 5.15.32.
#  1.35     | 02/11/2025   |    RC        |    Added support for FMAC Jaculus in 6.6.52
#  1.36     | 04/29/2025   |    RC        |    Updated scarthgap-jaculus release.
#  1.37     | 07/04/2025   |    RC        |    Added support for FMAC Kraken in 6.6.23 and 5.15.32.
#  1.38     | 07/25/2025   |    RC        |    Added support for FMAC Kraken in 6.1.36.
#  1.39     | 09/03/2025   |    RC        |    Added support for i.MX91 EVK.
#  1.40     | 02/23/2026   |    RC        |    Added support for FMAC Longma, BSP Styhead.
#  1.41     | 02/24/2026   |    RC        |    Added support for BSP Walnascar. Moved older
#           |              |              |    kernels/FMAC to legacy.
#  1.42     | 03/17/2026   |    RC        |    Added support for FMAC Longma in 5.15.32, 6.1.36 and
#           |              |              |    6.6.23.
#  1.43     | 09/09/2026   |    RC        |    Removed legacy support.
#  1.44     | 10/28/2026   |    RC        |    Added support for FMAC Medusa in 6.18.20. Added support for i.MX95 EVK.
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

HEDORAH_FMAC_INDEX="1"
INDRIK_FMAC_INDEX="2"
JACULUS_FMAC_INDEX="3"
KRAKEN_FMAC_INDEX="4"
LONGMA_FMAC_INDEX="5"
MEDUSA_FMAC_INDEX="6"

HEDORAH_FMAC_STR="hedorah"
INDRIK_FMAC_STR="indrik"
JACULUS_FMAC_STR="jaculus"
KRAKEN_FMAC_STR="kraken"
LONGMA_FMAC_STR="longma"
MEDUSA_FMAC_STR="medusa"

LINUX_KERNEL_6_18_20=1
LINUX_KERNEL_6_12_34=2
LINUX_KERNEL_6_12_3=3
LINUX_KERNEL_6_6_23=4
LINUX_KERNEL_6_1_36=5
LINUX_KERNEL_5_15_32=6

# Linux Kernel Strings
LINUX_KERNEL_6_18_20_STR="6.18.20"
LINUX_KERNEL_6_12_34_STR="6.12.34"
LINUX_KERNEL_6_12_3_STR="6.12.3"
LINUX_KERNEL_6_6_23_STR="6.6.23"
LINUX_KERNEL_6_1_36_STR="6.1.36"
LINUX_KERNEL_5_15_32_STR="5.15.32"

DISTRO_NAME=fsl-imx-fb
IMAGE_NAME=core-image-base

iMXYoctoRelease=""
YoctoBranch=""
fmacversion=""
linuxVersion=""

# Wrynose
iMXwrynosemedusaStableReleaseTag="imx-wrynose-medusa_r1.0"
iMXwrynosemedusaDeveloperRelease="imx-wrynose-medusa"

# Walnascar
iMXwalnascarlongmaStableReleaseTag="imx-walnascar-longma_r1.0"
iMXwalnascarlongmaDeveloperRelease="imx-walnascar-longma"

# Styhead
iMXstyheadlongmaStableReleaseTag="imx-styhead-longma_r1.0"
iMXstyheadlongmaDeveloperRelease="imx-styhead-longma"

# Scarthgap
iMXscarthgaplongmaStableReleaseTag="imx-scarthgap-longma_r1.0"
iMXscarthgaplongmaDeveloperRelease="imx-scarthgap-longma"

iMXscarthgapkrakenStableReleaseTag="imx-scarthgap-kraken_r1.0"
iMXscarthgapkrakenDeveloperRelease="imx-scarthgap-kraken"

iMXscarthgapjaculusStableReleaseTag="imx-scarthgap-jaculus_r1.1"
iMXscarthgapjaculusDeveloperRelease="imx-scarthgap-jaculus"

# Mickledore
iMXmickledorelongmaStableReleaseTag="imx-mickledore-longma_r1.0"
iMXmickledorelongmaDeveloperRelease="imx-mickledore-longma"

iMXmickledorekrakenStableReleaseTag="imx-mickledore-kraken_r1.0"
iMXmickledorekrakenDeveloperRelease="imx-mickledore-kraken"

iMXmickledorejaculusStableReleaseTag="imx-mickledore-jaculus_r1.0"
iMXmickledorejaculusDeveloperRelease="imx-mickledore-jaculus"

iMXmickledoreindrikStableReleaseTag="imx-mickledore-indrik_r1.0"
iMXmickledoreindrikDeveloperRelease="imx-mickledore-indrik"

iMXmickledorehedorahStableReleaseTag="imx-mickledore-hedorah_r1.0"
iMXmickledorehedorahDeveloperRelease="imx-mickledore-hedorah"

# Kirkstone
iMXkirkstonelongmaStableReleaseTag="imx-kirkstone-longma_r1.0"
iMXkirkstonelongmaDeveloperRelease="imx-kirkstone-longma"

iMXkirkstonekrakenStableReleaseTag="imx-kirkstone-kraken_r1.0"
iMXkirkstonekrakenDeveloperRelease="imx-kirkstone-kraken"

iMXkirkstonejaculusStableReleaseTag="imx-kirkstone-jaculus_r1.0"
iMXkirkstonejaculusDeveloperRelease="imx-kirkstone-jaculus"

iMXkirkstoneindrikStableReleaseTag="imx-kirkstone-indrik_r1.0"
iMXkirkstoneindrikDeveloperRelease="imx-kirkstone-indrik"

imxwrynoseYocto="6.18.20_2.0.0"
imxwalnascarYocto="6.12.34_2.1.0"
imxstyheadYocto="6.12.3_1.0.0"
imxscarthgapYocto="6.6.23_2.0.0"
imxmickledoreYocto="6.1.36_2.1.0"
imxkirkstoneYocto="5.15.32_2.0.0 GA"

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
if [ $Ubuntu_Release == "22.04" ] ||  [ $Ubuntu_Release == "20.04" ] || [ $Ubuntu_Release == "18.04" ] || [ $Ubuntu_Release == "16.04" ] || [ $Ubuntu_Release == "14.04" ] || [ $Ubuntu_Release == "12.04" ]; then
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
	exit 1
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

# Scan through the file Murata_Wireless_Yocto_Build_IFX.sh to fetch the Revision Information
COUNTER=0
input_file_path="$SCRIPT_DIR/Murata_Wireless_Yocto_Build_IFX.sh"

while IFS= read -r LATEST_VER
do
	COUNTER=$[$COUNTER +1]
	if [ "$COUNTER" = "2" ] ; then
	break
	fi
done < "$input_file_path"

cd $BSP_DIR

# read first and second line of Murata_Wireless_Yocto_Build_IFX.sh script
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
		echo ""\$ "cp ./meta-murata-wireless/script-utils/latest/Murata_Wireless_Yocto_Build_IFX.sh ."
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
	if [[ "$TARGET_NAME" =~ ^imx[89] ]]; then
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
	echo "-----------------------------------------------------------------------------------"
	echo "|Entry|   Linux Kernel   | Yocto      | FMAC Supported                            |"
	echo "|-----|------------------|------------|-------------------------------------------|"
	echo "|  1  |     ${LINUX_KERNEL_6_18_20_STR}      | wrynose    | Medusa                                    |"
	echo "|  2  |     ${LINUX_KERNEL_6_12_34_STR}      | walnascar  | Longma                                    |"
	echo "|  3  |     ${LINUX_KERNEL_6_12_3_STR}       | styhead    | Longma                                    |"
	echo "|  4  |     ${LINUX_KERNEL_6_6_23_STR}       | scarthgap  | Jaculus, Kraken, Longma                   |"
	echo "|  5  |     ${LINUX_KERNEL_6_1_36_STR}       | mickledore | Hedorah, Indrik, Jaculus, Kraken, Longma  |"
	echo "|  6  |     ${LINUX_KERNEL_5_15_32_STR}      | kirkstone  | Indrik, Jaculus, Kraken, Longma           |"

	echo "-----------------------------------------------------------------------------------"
	read -p "Select which entry? " LINUX_KERNEL

	case $LINUX_KERNEL in
	$LINUX_KERNEL_5_15_32)
		linuxVersion=${LINUX_KERNEL_5_15_32_STR}
		break
		;;
	$LINUX_KERNEL_6_1_36)
		linuxVersion=${LINUX_KERNEL_6_1_36_STR}
		break
		;;
	$LINUX_KERNEL_6_6_23)
		linuxVersion=${LINUX_KERNEL_6_6_23_STR}
		break
		;;
	$LINUX_KERNEL_6_12_3)
		linuxVersion=${LINUX_KERNEL_6_12_3_STR}
		break
		;;
	$LINUX_KERNEL_6_12_34)
		linuxVersion=${LINUX_KERNEL_6_12_34_STR}
		break
		;;
	$LINUX_KERNEL_6_18_20)
		linuxVersion=${LINUX_KERNEL_6_18_20_STR}
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

echo " "
echo "${STEP_COUNT}) Select "\""fmac"\"" version"
echo "------------------------"
(( STEP_COUNT += 1 ))

while true; do
	case $LINUX_KERNEL in
	$LINUX_KERNEL_5_15_32)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo     "|  1.   | ${INDRIK_FMAC_STR}                                            |"
			echo     "|  2.   | ${JACULUS_FMAC_STR}                                           |"
			echo     "|  3.   | ${KRAKEN_FMAC_STR}                                            |"
			echo -e  "|  4.   | ${LONGMA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for INDRIK
				FMAC_VERSION=${INDRIK_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: kirkstone-indrik"
					BRANCH_RELEASE_NAME="$iMXkirkstoneindrikStableReleaseTag"
				else
					#echo "DEBUG:: kirkstone-indrik"
					BRANCH_RELEASE_NAME="$iMXkirkstoneindrikDeveloperRelease"
				fi
				iMXYoctoRelease="$imxkirkstoneYocto"
				YoctoBranch="kirkstone"
				fmacversion=${INDRIK_FMAC_STR}
				break
				;;
			2)
				# for JACULUS
				FMAC_VERSION=${JACULUS_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: kirkstone-jaculus"
					BRANCH_RELEASE_NAME="$iMXkirkstonejaculusStableReleaseTag"
				else
					#echo "DEBUG:: kirkstone-jaculus"
					BRANCH_RELEASE_NAME="$iMXkirkstonejaculusDeveloperRelease"
				fi
				iMXYoctoRelease="$imxkirkstoneYocto"
				YoctoBranch="kirkstone"
				fmacversion=${JACULUS_FMAC_STR}
				break
				;;
			3)
				# for KRAKEN
				FMAC_VERSION=${KRAKEN_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: kirkstone-kraken"
					BRANCH_RELEASE_NAME="$iMXkirkstonekrakenStableReleaseTag"
				else
					#echo "DEBUG:: kirkstone-kraken"
					BRANCH_RELEASE_NAME="$iMXkirkstonekrakenDeveloperRelease"
				fi
				iMXYoctoRelease="$imxkirkstoneYocto"
				YoctoBranch="kirkstone"
				fmacversion=${KRAKEN_FMAC_STR}
				break
				;;
			4)
				# for LONGMA
				FMAC_VERSION=${LONGMA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: kirkstone-longma"
					BRANCH_RELEASE_NAME="$iMXkirkstonelongmaStableReleaseTag"
				else
					#echo "DEBUG:: kirkstone-longma"
					BRANCH_RELEASE_NAME="$iMXkirkstonelongmaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxkirkstoneYocto"
				YoctoBranch="kirkstone"
				fmacversion=${LONGMA_FMAC_STR}
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
	$LINUX_KERNEL_6_1_36)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo     "|  1.   | ${HEDORAH_FMAC_STR}                                           |"
			echo     "|  2.   | ${INDRIK_FMAC_STR}                                            |"
			echo     "|  3.   | ${JACULUS_FMAC_STR}                                           |"
			echo     "|  4.   | ${KRAKEN_FMAC_STR}                                            |"
			echo -e  "|  5.   | ${LONGMA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for HEDORAH
				FMAC_VERSION=${HEDORAH_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: mickledore-hedorah"
					BRANCH_RELEASE_NAME="$iMXmickledorehedorahStableReleaseTag"
				else
					#echo "DEBUG:: mickledore-hedorah"
					BRANCH_RELEASE_NAME="$iMXmickledorehedorahDeveloperRelease"
				fi
				iMXYoctoRelease="$imxmickledoreYocto"
				YoctoBranch="mickledore"
				fmacversion=${HEDORAH_FMAC_STR}
				break
				;;
			2)
				# for INDRIK
				FMAC_VERSION=${INDRIK_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: mickledore-indrik"
					BRANCH_RELEASE_NAME="$iMXmickledoreindrikStableReleaseTag"
				else
					#echo "DEBUG:: mickledore-indrik"
					BRANCH_RELEASE_NAME="$iMXmickledoreindrikDeveloperRelease"
				fi
				iMXYoctoRelease="$imxmickledoreYocto"
				YoctoBranch="mickledore"
				fmacversion=${INDRIK_FMAC_STR}
				break
				;;
			3)
				# for JACULUS
				FMAC_VERSION=${JACULUS_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: mickledore-jaculus"
					BRANCH_RELEASE_NAME="$iMXmickledorejaculusStableReleaseTag"
				else
					#echo "DEBUG:: mickledore-jaculus"
					BRANCH_RELEASE_NAME="$iMXmickledorejaculusDeveloperRelease"
				fi
				iMXYoctoRelease="$imxmickledoreYocto"
				YoctoBranch="mickledore"
				fmacversion=${JACULUS_FMAC_STR}
				break
				;;
			4)
				# for KRAKEN
				FMAC_VERSION=${KRAKEN_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: mickledore-kraken"
					BRANCH_RELEASE_NAME="$iMXmickledorekrakenStableReleaseTag"
				else
					#echo "DEBUG:: mickledore-kraken"
					BRANCH_RELEASE_NAME="$iMXmickledorekrakenDeveloperRelease"
				fi
				iMXYoctoRelease="$imxmickledoreYocto"
				YoctoBranch="mickledore"
				fmacversion=${KRAKEN_FMAC_STR}
				break
				;;
			5)
				# for LONGMA
				FMAC_VERSION=${LONGMA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: mickledore-longma"
					BRANCH_RELEASE_NAME="$iMXmickledorelongmaStableReleaseTag"
				else
					#echo "DEBUG:: mickledore-longma"
					BRANCH_RELEASE_NAME="$iMXmickledorelongmaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxmickledoreYocto"
				YoctoBranch="mickledore"
				fmacversion=${LONGMA_FMAC_STR}
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
	$LINUX_KERNEL_6_6_23)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo     "|  1.   | ${JACULUS_FMAC_STR}                                           |"
			echo     "|  2.   | ${KRAKEN_FMAC_STR}                                            |"
			echo  -e "|  3.   | ${LONGMA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for JACULUS
				FMAC_VERSION=${JACULUS_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: scarthgap-jaculus"
					BRANCH_RELEASE_NAME="$iMXscarthgapjaculusStableReleaseTag"
				else
					#echo "DEBUG:: scarthgap-jaculus"
					BRANCH_RELEASE_NAME="$iMXscarthgapjaculusDeveloperRelease"
				fi
				iMXYoctoRelease="$imxscarthgapYocto"
				YoctoBranch="scarthgap"
				fmacversion=${JACULUS_FMAC_STR}
				break
				;;
			2)
				# for KRAKEN
				FMAC_VERSION=${KRAKEN_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: scarthgap-kraken"
					BRANCH_RELEASE_NAME="$iMXscarthgapkrakenStableReleaseTag"
				else
					#echo "DEBUG:: scarthgap-kraken"
					BRANCH_RELEASE_NAME="$iMXscarthgapkrakenDeveloperRelease"
				fi
				iMXYoctoRelease="$imxscarthgapYocto"
				YoctoBranch="scarthgap"
				fmacversion=${KRAKEN_FMAC_STR}
				break
				;;
			3)
				# for LONGMA
				FMAC_VERSION=${LONGMA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: scarthgap-longma"
					BRANCH_RELEASE_NAME="$iMXscarthgaplongmaStableReleaseTag"
				else
					#echo "DEBUG:: scarthgap-longma"
					BRANCH_RELEASE_NAME="$iMXscarthgaplongmaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxscarthgapYocto"
				YoctoBranch="scarthgap"
				fmacversion=${LONGMA_FMAC_STR}
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
	$LINUX_KERNEL_6_12_3)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo -e  "|  1.   | ${LONGMA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for LONGMA
				FMAC_VERSION=${LONGMA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: styhead-longma"
					BRANCH_RELEASE_NAME="$iMXstyheadlongmaStableReleaseTag"
				else
					#echo "DEBUG:: styhead-longma"
					BRANCH_RELEASE_NAME="$iMXstyheadlongmaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxstyheadYocto"
				YoctoBranch="styhead"
				fmacversion=${LONGMA_FMAC_STR}
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
	$LINUX_KERNEL_6_12_34)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo -e  "|  1.   | ${LONGMA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for LONGMA
				FMAC_VERSION=${LONGMA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: walnascar-longma"
					BRANCH_RELEASE_NAME="$iMXwalnascarlongmaStableReleaseTag"
				else
					#echo "DEBUG:: walnascar-longma"
					BRANCH_RELEASE_NAME="$iMXwalnascarlongmaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxwalnascarYocto"
				YoctoBranch="walnascar"
				fmacversion=${LONGMA_FMAC_STR}
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
	$LINUX_KERNEL_6_18_20)
		while true; do
			echo     "-------------------------------------------------------------"
			echo     "| Entry | "\""fmac"\"" version                                    |"
			echo     "|-------|---------------------------------------------------|"
			echo -e  "|  1.   | ${MEDUSA_FMAC_STR} - ${GRN}Latest release${NC}                           |"
			echo     "-------------------------------------------------------------"
			read -p "Select which entry? " FMAC_VERSION
			case $FMAC_VERSION in
			1)
				# for MEDUSA
				FMAC_VERSION=${MEDUSA_FMAC_INDEX}
				if [ "$BRANCH_TAG_OPTION"    = "y" ]; then
					#echo "DEBUG:: wrynose-medusa"
					BRANCH_RELEASE_NAME="$iMXwrynosemedusaStableReleaseTag"
				else
					#echo "DEBUG:: wrynose-medusa"
					BRANCH_RELEASE_NAME="$iMXwrynosemedusaDeveloperRelease"
				fi
				iMXYoctoRelease="$imxwrynoseYocto"
				YoctoBranch="wrynose"
				fmacversion=${MEDUSA_FMAC_STR}
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

echo -e "${GRN}Selected : $fmacversion${NC}"

while true; do
	case $LINUX_KERNEL in
	$LINUX_KERNEL_5_15_32)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "-----------------------------------------------------------"
			echo "| Entry  |    Target Name      | NXP i.MX EVK Part Number |"
			echo "|--------|---------------------|--------------------------|"
			echo "|  1     |  imx6ulevk          | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk    | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6qsabresd       | MCIMX6Q-SDB              |"
			echo "|  4     |  imx6dlsabresd      | MCIMX6DL-SDP             |"
			echo "|  5     |  imx8mqevk          | MCIMX8M-EVKB             |"
			echo "|  6     |  imx8mm-lpddr4-evk  | 8MMINILPD4-EVK           |"
			echo "|  7     |  imx8mn-ddr4-evk    | 8MNANOD4-EVK             |"
			echo "|  8     |  imx8qxpc0mek       | MCIMX8QXP-CPU            |"
			echo "|  9     |  imx8mp-lpddr4-evk  | 8MPLUSLPD4-EVK           |"
			echo "-----------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
				break
				;;
			5)
				TARGET_NAME=imx8mqevk
				PART_NUMBER=MCIMX8M-EVKB
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			6)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			7)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_5.15.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			8)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
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
	$LINUX_KERNEL_6_1_36)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "----------------------------------------------------------------"
			echo "| Entry  |    Target Name           | NXP i.MX EVK Part Number |"
			echo "|--------|--------------------------|--------------------------|"
			echo "|  1     |  imx6ulevk               | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk         | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6sxsabresd           | MCIMX6SX-SDB             |"
			echo "|  4     |  imx6qsabresd            | MCIMX6Q-SDB              |"
			echo "|  5     |  imx6qpsabresd           | MCIMX6QP-SDB             |"
			echo "|  6     |  imx6dlsabresd           | MCIMX6DL-SDP             |"
			echo "|  7     |  imx7dsabresd            | MCIMX7SABRE              |"
			echo "|  8     |  imx7ulpevk              | MCIMX7ULP-EVK            |"
			echo "|  9     |  imx8mqevk               | MCIMX8M-EVKB             |"
			echo "|  10    |  imx8mm-lpddr4-evk       | 8MMINILPD4-EVK           |"
			echo "|  11    |  imx8mm-ddr4-evk         | 8MMINID4-EVK             |"
			echo "|  12    |  imx8mn-lpddr4-evk       | 8MNANOLPD4-EVK           |"
			echo "|  13    |  imx8mn-ddr4-evk         | 8MNANOD4-EVK             |"
			echo "|  14    |  imx8qxpc0mek            | MCIMX8QXP-CPU            |"
			echo "|  15    |  imx8mp-lpddr4-evk       | 8MPLUSLPD4-EVK           |"
			echo "|  16    |  imx8ulp-lpddr4-evk      | MCIMX8ULP-EVK            |"
			echo "|  17    |  imx8ulp-9x9-lpddr4-evk  | MCIMX8ULP-EVK9           |"
			echo "|  18    |  imx93evk                | MCIMX93-EVK              |"
			echo "|  19    |  imx93-11x11-lpddr4x-evk | MCIMX93-EVK (11x11)      |"
			echo "|  20    |  imx93-9x9-lpddr4-qsb    | MCIMX93-EVK (9x9)        |"
			echo "|  21    |  imx93-14x14-lpddr4x-evk | MCIMX93-EVK (14x14)      |"
			echo "----------------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
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
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			10)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			11)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			12)
				TARGET_NAME=imx8mn-lpddr4-evk
				PART_NUMBER=8MNANOLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			13)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			14)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			15)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			16)
				TARGET_NAME=imx8ulp-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			17)
				TARGET_NAME=imx8ulp-9x9-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK9
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			18)
				TARGET_NAME=imx93evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			19)
				TARGET_NAME=imx93-11x11-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			20)
				TARGET_NAME=imx93-9x9-lpddr4-qsb
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			21)
				TARGET_NAME=imx93-14x14-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
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
	$LINUX_KERNEL_6_6_23)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "----------------------------------------------------------------"
			echo "| Entry  |    Target Name           | NXP i.MX EVK Part Number |"
			echo "|--------|--------------------------|--------------------------|"
			echo "|  1     |  imx6ulevk               | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk         | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6sxsabresd           | MCIMX6SX-SDB             |"
			echo "|  4     |  imx6qsabresd            | MCIMX6Q-SDB              |"
			echo "|  5     |  imx6qpsabresd           | MCIMX6QP-SDB             |"
			echo "|  6     |  imx6dlsabresd           | MCIMX6DL-SDP             |"
			echo "|  7     |  imx7dsabresd            | MCIMX7SABRE              |"
			echo "|  8     |  imx7ulpevk              | MCIMX7ULP-EVK            |"
			echo "|  9     |  imx8mqevk               | MCIMX8M-EVKB             |"
			echo "|  10    |  imx8mm-lpddr4-evk       | 8MMINILPD4-EVK           |"
			echo "|  11    |  imx8mm-ddr4-evk         | 8MMINID4-EVK             |"
			echo "|  12    |  imx8mn-lpddr4-evk       | 8MNANOLPD4-EVK           |"
			echo "|  13    |  imx8mn-ddr4-evk         | 8MNANOD4-EVK             |"
			echo "|  14    |  imx8qxpc0mek            | MCIMX8QXP-CPU            |"
			echo "|  15    |  imx8mp-lpddr4-evk       | 8MPLUSLPD4-EVK           |"
			echo "|  16    |  imx8ulp-lpddr4-evk      | MCIMX8ULP-EVK            |"
			echo "|  17    |  imx8ulp-9x9-lpddr4-evk  | MCIMX8ULP-EVK9           |"
			echo "|  18    |  imx91-11x11-lpddr4-evk  | IMX91LP4EVK-11CM         |"
			echo "|  19    |  imx93evk                | MCIMX93-EVK              |"
			echo "|  20    |  imx93-11x11-lpddr4x-evk | MCIMX93-EVK (11x11)      |"
			echo "|  21    |  imx93-9x9-lpddr4-qsb    | MCIMX93-EVK (9x9)        |"
			echo "|  22    |  imx93-14x14-lpddr4x-evk | MCIMX93-EVK (14x14)      |"
			echo "----------------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
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
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			10)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			11)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			12)
				TARGET_NAME=imx8mn-lpddr4-evk
				PART_NUMBER=8MNANOLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			13)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			14)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			15)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			16)
				TARGET_NAME=imx8ulp-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			17)
				TARGET_NAME=imx8ulp-9x9-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK9
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			18)
				TARGET_NAME=imx91-11x11-lpddr4-evk
				PART_NUMBER=IMX91LP4EVK-11CM
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			19)
				TARGET_NAME=imx93evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			20)
				TARGET_NAME=imx93-11x11-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			21)
				TARGET_NAME=imx93-9x9-lpddr4-qsb
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			22)
				TARGET_NAME=imx93-14x14-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
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
	$LINUX_KERNEL_6_12_3)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "----------------------------------------------------------------"
			echo "| Entry  |    Target Name           | NXP i.MX EVK Part Number |"
			echo "|--------|--------------------------|--------------------------|"
			echo "|  1     |  imx6ulevk               | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk         | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6sxsabresd           | MCIMX6SX-SDB             |"
			echo "|  4     |  imx6qsabresd            | MCIMX6Q-SDB              |"
			echo "|  5     |  imx6qpsabresd           | MCIMX6QP-SDB             |"
			echo "|  6     |  imx6dlsabresd           | MCIMX6DL-SDP             |"
			echo "|  7     |  imx7dsabresd            | MCIMX7SABRE              |"
			echo "|  8     |  imx7ulpevk              | MCIMX7ULP-EVK            |"
			echo "|  9     |  imx8mqevk               | MCIMX8M-EVKB             |"
			echo "|  10    |  imx8mm-lpddr4-evk       | 8MMINILPD4-EVK           |"
			echo "|  11    |  imx8mm-ddr4-evk         | 8MMINID4-EVK             |"
			echo "|  12    |  imx8mn-lpddr4-evk       | 8MNANOLPD4-EVK           |"
			echo "|  13    |  imx8mn-ddr4-evk         | 8MNANOD4-EVK             |"
			echo "|  14    |  imx8qxpc0mek            | MCIMX8QXP-CPU            |"
			echo "|  15    |  imx8mp-lpddr4-evk       | 8MPLUSLPD4-EVK           |"
			echo "|  16    |  imx8ulp-lpddr4-evk      | MCIMX8ULP-EVK            |"
			echo "|  17    |  imx8ulp-9x9-lpddr4-evk  | MCIMX8ULP-EVK9           |"
			echo "|  18    |  imx91-11x11-lpddr4-evk  | IMX91LP4EVK-11CM         |"
			echo "|  19    |  imx93evk                | MCIMX93-EVK              |"
			echo "|  20    |  imx93-11x11-lpddr4x-evk | MCIMX93-EVK (11x11)      |"
			echo "|  21    |  imx93-9x9-lpddr4-qsb    | MCIMX93-EVK (9x9)        |"
			echo "|  22    |  imx93-14x14-lpddr4x-evk | MCIMX93-EVK (14x14)      |"
			echo "----------------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
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
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			10)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			11)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			12)
				TARGET_NAME=imx8mn-lpddr4-evk
				PART_NUMBER=8MNANOLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			13)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			14)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			15)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			16)
				TARGET_NAME=imx8ulp-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			17)
				TARGET_NAME=imx8ulp-9x9-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK9
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			18)
				TARGET_NAME=imx91-11x11-lpddr4-evk
				PART_NUMBER=IMX91LP4EVK-11CM
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			19)
				TARGET_NAME=imx93evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			20)
				TARGET_NAME=imx93-11x11-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			21)
				TARGET_NAME=imx93-9x9-lpddr4-qsb
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			22)
				TARGET_NAME=imx93-14x14-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
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
	$LINUX_KERNEL_6_12_34)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "----------------------------------------------------------------"
			echo "| Entry  |    Target Name           | NXP i.MX EVK Part Number |"
			echo "|--------|--------------------------|--------------------------|"
			echo "|  1     |  imx6ulevk               | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk         | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6sxsabresd           | MCIMX6SX-SDB             |"
			echo "|  4     |  imx6qsabresd            | MCIMX6Q-SDB              |"
			echo "|  5     |  imx6qpsabresd           | MCIMX6QP-SDB             |"
			echo "|  6     |  imx6dlsabresd           | MCIMX6DL-SDP             |"
			echo "|  7     |  imx7dsabresd            | MCIMX7SABRE              |"
			echo "|  8     |  imx7ulpevk              | MCIMX7ULP-EVK            |"
			echo "|  9     |  imx8mqevk               | MCIMX8M-EVKB             |"
			echo "|  10    |  imx8mm-lpddr4-evk       | 8MMINILPD4-EVK           |"
			echo "|  11    |  imx8mm-ddr4-evk         | 8MMINID4-EVK             |"
			echo "|  12    |  imx8mn-lpddr4-evk       | 8MNANOLPD4-EVK           |"
			echo "|  13    |  imx8mn-ddr4-evk         | 8MNANOD4-EVK             |"
			echo "|  14    |  imx8qxpc0mek            | MCIMX8QXP-CPU            |"
			echo "|  15    |  imx8mp-lpddr4-evk       | 8MPLUSLPD4-EVK           |"
			echo "|  16    |  imx8ulp-lpddr4-evk      | MCIMX8ULP-EVK            |"
			echo "|  17    |  imx8ulp-9x9-lpddr4-evk  | MCIMX8ULP-EVK9           |"
			echo "|  18    |  imx91-11x11-lpddr4-evk  | IMX91LP4EVK-11CM         |"
			echo "|  19    |  imx93evk                | MCIMX93-EVK              |"
			echo "|  20    |  imx93-11x11-lpddr4x-evk | MCIMX93-EVK (11x11)      |"
			echo "|  21    |  imx93-9x9-lpddr4-qsb    | MCIMX93-EVK (9x9)        |"
			echo "|  22    |  imx93-14x14-lpddr4x-evk | MCIMX93-EVK (14x14)      |"
			echo "----------------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
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
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			10)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			11)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			12)
				TARGET_NAME=imx8mn-lpddr4-evk
				PART_NUMBER=8MNANOLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			13)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			14)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			15)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			16)
				TARGET_NAME=imx8ulp-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			17)
				TARGET_NAME=imx8ulp-9x9-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK9
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			18)
				TARGET_NAME=imx91-11x11-lpddr4-evk
				PART_NUMBER=IMX91LP4EVK-11CM
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			19)
				TARGET_NAME=imx93evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			20)
				TARGET_NAME=imx93-11x11-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			21)
				TARGET_NAME=imx93-9x9-lpddr4-qsb
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			22)
				TARGET_NAME=imx93-14x14-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
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
	$LINUX_KERNEL_6_18_20)
		while true; do
			echo " "
			echo "${STEP_COUNT}) Select Target"
			echo "----------------"
			echo " "
			echo "----------------------------------------------------------------"
			echo "| Entry  |    Target Name           | NXP i.MX EVK Part Number |"
			echo "|--------|--------------------------|--------------------------|"
			echo "|  1     |  imx6ulevk               | MCIMX6UL-EVK             |"
			echo "|  2     |  imx6ull14x14evk         | MCIMX6ULL-EVK            |"
			echo "|  3     |  imx6sxsabresd           | MCIMX6SX-SDB             |"
			echo "|  4     |  imx6qsabresd            | MCIMX6Q-SDB              |"
			echo "|  5     |  imx6qpsabresd           | MCIMX6QP-SDB             |"
			echo "|  6     |  imx6dlsabresd           | MCIMX6DL-SDP             |"
			echo "|  7     |  imx7dsabresd            | MCIMX7SABRE              |"
			echo "|  8     |  imx7ulpevk              | MCIMX7ULP-EVK            |"
			echo "|  9     |  imx8mqevk               | MCIMX8M-EVKB             |"
			echo "|  10    |  imx8mm-lpddr4-evk       | 8MMINILPD4-EVK           |"
			echo "|  11    |  imx8mm-ddr4-evk         | 8MMINID4-EVK             |"
			echo "|  12    |  imx8mn-lpddr4-evk       | 8MNANOLPD4-EVK           |"
			echo "|  13    |  imx8mn-ddr4-evk         | 8MNANOD4-EVK             |"
			echo "|  14    |  imx8qxpc0mek            | MCIMX8QXP-CPU            |"
			echo "|  15    |  imx8mp-lpddr4-evk       | 8MPLUSLPD4-EVK           |"
			echo "|  16    |  imx8ulp-lpddr4-evk      | MCIMX8ULP-EVK            |"
			echo "|  17    |  imx8ulp-9x9-lpddr4x-evk | MCIMX8ULP-EVK9           |"
			echo "|  18    |  imx91-11x11-lpddr4-evk  | IMX91LP4EVK-11CM         |"
			echo "|  19    |  imx93-11x11-lpddr4x-evk | MCIMX93-EVK (11x11)      |"
			echo "|  20    |  imx93-9x9-lpddr4-qsb    | MCIMX93-EVK (9x9)        |"
			echo "|  21    |  imx93-14x14-lpddr4x-evk | MCIMX93-EVK (14x14)      |"
			echo "|  22    |  imx95-19x19-lpddr5-evk  | IMX95LPD5EVK-19          |"
			echo "|  23    |  imx952-15x15-lpddr4x-evk| IMX95LP4XEVK-15          |"
			echo "|  24    |  imx952-19x19-lpddr5-evk | IMX95LPD5EVK-19          |"
			echo "----------------------------------------------------------------"
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
				PART_NUMBER=MCIMX6DL-SDP
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
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			10)
				TARGET_NAME=imx8mm-lpddr4-evk
				PART_NUMBER=8MMINILPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			11)
				TARGET_NAME=imx8mm-ddr4-evk
				PART_NUMBER=8MMINID4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			12)
				TARGET_NAME=imx8mn-lpddr4-evk
				PART_NUMBER=8MNANOLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			13)
				TARGET_NAME=imx8mn-ddr4-evk
				PART_NUMBER=8MNANOD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			14)
				TARGET_NAME=imx8qxpc0mek
				PART_NUMBER=MCIMX8QXP-CPU
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			15)
				TARGET_NAME=imx8mp-lpddr4-evk
				PART_NUMBER=8MPLUSLPD4-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			16)
				TARGET_NAME=imx8ulp-lpddr4-evk
				PART_NUMBER=MCIMX8ULP-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			17)
				TARGET_NAME=imx8ulp-9x9-lpddr4x-evk
				PART_NUMBER=MCIMX8ULP-EVK9
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			18)
				TARGET_NAME=imx91-11x11-lpddr4-evk
				PART_NUMBER=IMX91LP4EVK-11CM
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			19)
				TARGET_NAME=imx93-11x11-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			20)
				TARGET_NAME=imx93-9x9-lpddr4-qsb
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			21)
				TARGET_NAME=imx93-14x14-lpddr4x-evk
				PART_NUMBER=MCIMX93-EVK
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			22)
				TARGET_NAME=imx95-19x19-lpddr5-evk
				PART_NUMBER=IMX95LPD5EVK-19
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			23)
				TARGET_NAME=imx952-15x15-lpddr4x-evk
				PART_NUMBER=IMX95LP4XEVK-15
				LINUX_SRC=linux-imx_6.1.bbappend.8MQ
				LINUX_DEST=linux-imx_%.bbappend
				DISTRO_NAME=fsl-imx-wayland
				break
				;;
			24)
				TARGET_NAME=imx952-19x19-lpddr5-evk
				PART_NUMBER=IMX95LPD5EVK-19
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
		select_supported_distros_for_5_x_onwards		
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
		echo "       $ bitbake fsl-image-validation-imx"
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
	if [ "$iMXYoctoRelease" = "$imxwrynoseYocto" ]; then
		#echo "DEBUG:: IMXALL-WRYNOSE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-wrynose -m imx-6.18.20-2.0.0.xml
	elif [ "$iMXYoctoRelease" = "$imxwalnascarYocto" ]; then
		#echo "DEBUG:: IMXALL-WALNASCAR"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-walnascar -m imx-6.12.34-2.1.0.xml
	elif [ "$iMXYoctoRelease" = "$imxstyheadYocto" ]; then
		#echo "DEBUG:: IMXALL-STYHEAD"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-styhead -m imx-6.12.3-1.0.0.xml
	elif [ "$iMXYoctoRelease" = "$imxscarthgapYocto" ]; then
		#echo "DEBUG:: IMXALL-SCARTHGAP"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-scarthgap -m imx-6.6.23-2.0.0.xml
	elif [ "$iMXYoctoRelease" = "$imxmickledoreYocto" ]; then
		#echo "DEBUG:: IMXALL-MICKLEDORE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-mickledore -m imx-6.1.36-2.1.0.xml
	elif [ "$iMXYoctoRelease" = "$imxkirkstoneYocto" ]; then
		#echo "DEBUG:: IMXALL-KIRKSTONE"
		$REPO_PATH/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-kirkstone -m imx-5.15.32-2.0.0.xml
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

	# Copy the target specific files
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

	if [ "$PROCEED_BUILD" = "y" ] || [ "$PROCEED_BUILD" = "Y" ] || [ "$PROCEED_BUILD" = "" ]; then
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
