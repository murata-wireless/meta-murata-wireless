#!/bin/bash
VERSION=03222018

# Use colors to highlight pass/fail conditions. 
RED='\033[1;31m' # Red font to flag errors
GRN='\033[1;32m' # Green font to flag pass
YLW='\033[1;33m' # Yellow font for highlighting
NC='\033[0m' # No Color

clear
#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

echo " "
echo "MURATA Custom i.MX Linux build using Yocto"
echo "=========================================="

echo " "
echo "1) Verifying Host Environment"
echo "-----------------------------"

# Get Linux distro; make sure it is "Ubuntu"
Linux_Distro=$(lsb_release -i -s)
if [ $Linux_Distro == "Ubuntu" ]; then
                echo -e "Murata: Verified Linux Distribution: " ${GRN}$Linux_Distro${NC}
else
                echo -e "${RED}Murata: Only Ubuntu Linux Distribution supported; not:${NC}" $Linux_Distro
                exit
fi

# Get Ubuntu release version; make sure it is either 16.04, 14.04 or 12.04. 
Ubuntu_Release=$(lsb_release -r -s)
if [ $Ubuntu_Release == "16.04" ] || [ $Ubuntu_Release == "14.04" ] || [ $Ubuntu_Release == "12.04" ]; then
                echo -e "Murata: Verified Ubuntu Release:${NC}     " ${GRN}$Ubuntu_Release${NC}
else
                echo -e "${RED}Murata: Only Ubuntu versions 16.04, 14.04, and 12.04 are supported; not:" $Ubuntu_Release
		echo -e "Exiting script.....${NC}"
                exit
fi 


# Ubuntu Distro and Version verified. Now add necessary commands. 

# BSP directory
export BSP_DIR=`pwd`

echo " "
echo "2) Verifying Script Version"
echo "---------------------------"


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
	cd $TEST_DIR_NAME/cyw-script-utils/latest
	git fetch --all 		--quiet
	git reset --hard origin/master 	--quiet
	git pull origin master 		--quiet
else
	git clone $META_MURATA_WIRELESS_GIT --quiet
	cd $TEST_DIR_NAME/cyw-script-utils/latest
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
		echo "Update to latest version using following copy command:"
		echo " "
		echo ""\$ "cp ./meta-murata-wireless/cyw-script-utils/latest/Murata_Wireless_Yocto_Build.sh ."
		echo " "
		echo -e "${YLW}Exiting script.....${NC}"
       		exit
	else
		echo " "
		echo -e "${YLW}CONTINUING WITH CURRENT SCRIPT.${NC}"
	fi
fi

# Initialize variables
BRANCH_RELEASE_OPTION=0
VIO_SIGNALING_OPTION=0
LINUX_SRC=""
LINUX_DEST=""
VIO_SIGNALING_STRING=""
CWD=""

echo " "
echo "3) Select Release Type"
echo "----------------------"

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

iMXYoctoRelease=""
YoctoBranch=""
fmacversion=""

while true; do
echo " "
echo "4) Select "\""fmac"\"" version"
echo "------------------------"
ORGA_FMAC=""\""orga"\""   (v4.12)"
BATTRA_FMAC=""\""battra"\"" (v4.14)"

echo     " "
echo     "-------------------------------------------------------------"
echo     "| Entry | "\""fmac"\"" version                                    |"
echo     "|-------|---------------------------------------------------|"
echo     "|  1.   | $ORGA_FMAC - Previous release               |"
echo -e  "|  2.   | $BATTRA_FMAC - ${GRN}Latest and Highly recommended${NC}  |"
echo     "-------------------------------------------------------------"

while true; do
	read -p "Select which entry? " FMAC_VERSION
	if [ "$FMAC_VERSION" = "1" ] || [ "$FMAC_VERSION" = "2" ]; then
		#echo "FMAC DEBUG:: $FMAC_VERSION"
		break
	else
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		echo $'\n'	
	fi
done

#FMAC_VERSION="1"
	if [ "$FMAC_VERSION" = "1" ] && [ "$BRANCH_TAG_OPTION" = "y" ]; then
		echo -e "${GRN}Selected : $ORGA_FMAC${NC}"
		echo " "
		echo "5) Select i.MX Yocto Release"
		echo "----------------------------"
		echo " "
		echo "----------------------------------------------------------------------------"
		echo "|Entry|     i.MX Yocto   | Yocto   | i.MX          |"\""meta-murata-wireless"\"" |"
		echo "|     |      Release     | branch  | Supported     |     Release Tag       |"
		echo "|-----|------------------|---------|---------------|-----------------------|"
		echo "|  1  | 4.9.51 8MQ Beta  | morty   | 8             | imx8-morty-orga_r1.1  |"
		echo "|  2  | 4.9.11_1.0.0 GA  | morty   | 6,7           | imx-morty-orga_r1.2   |"
		echo "|  3  | 4.1.15_2.0.0 GA  | krogoth | 6,7 (No 7ULP) | imx-krogoth-orga_r1.1 |" 
		echo "----------------------------------------------------------------------------"
		break
	elif [ "$FMAC_VERSION" = "1" ] && [ "$BRANCH_TAG_OPTION" = "n" ]; then
		echo -e "${GRN}Selected : $ORGA_FMAC${NC}"
		echo " "
		echo "5) Select i.MX Yocto Release"
		echo "----------------------------"
		echo " "
		echo "----------------------------------------------------------------------------"
		echo "|Entry|     i.MX Yocto   | Yocto   | i.MX          |"\""meta-murata-wireless"\"" |"
		echo "|     |      Release     | branch  | Supported     |     Release Tag       |"
		echo "|-----|------------------|---------|---------------|-----------------------|"
		echo "|  1  | 4.9.51 8MQ Beta  | morty   | 8             | imx8-morty-orga       |"
		echo "|  2  | 4.9.11_1.0.0 GA  | morty   | 6,7           | imx-morty-orga        |"
		echo "|  3  | 4.1.15_2.0.0 GA  | krogoth | 6,7 (No 7ULP) | imx-krogoth-orga      |" 
		echo "----------------------------------------------------------------------------"
		break
	elif [ "$FMAC_VERSION" = "2" ] && [ "$BRANCH_TAG_OPTION" = "y" ]; then
		echo -e "${GRN}Selected : $BATTRA_FMAC${NC}"
		echo " "
		echo "5) Select i.MX Yocto Release"
		echo "----------------------------"
		echo " "
		echo "------------------------------------------------------------------------------"
		echo "|Entry|     i.MX Yocto   | Yocto   | i.MX          |"\""meta-murata-wireless"\""   |"
		echo "|     |      Release     | branch  | Supported     |     Release Tag         |"
		echo "|-----|------------------|---------|---------------|-------------------------|"
		echo "|  1  | 4.9.51 8MQ Beta  | morty   | 8             | imx8-morty-battra_r1.0  |"
		echo "|  2  | 4.9.11_1.0.0 GA  | morty   | 6,7           | imx-morty-battra_r1.0   |"
		echo "|  3  | 4.1.15_2.0.0 GA  | krogoth | 6,7 (No 7ULP) | imx-krogoth-battra_r1.0 |" 
		echo "------------------------------------------------------------------------------"
		break
	elif [ "$FMAC_VERSION" = "2" ] && [ "$BRANCH_TAG_OPTION" = "n" ]; then
		echo -e "${GRN}Selected : $BATTRA_FMAC${NC}"
		echo " "
		echo "5) Select i.MX Yocto Release"
		echo "----------------------------"
		echo " "
		echo "----------------------------------------------------------------------------"
		echo "|Entry|     i.MX Yocto   | Yocto   | i.MX          |"\""meta-murata-wireless"\"" |"
		echo "|     |      Release     | branch  | Supported     |     Release Tag       |"
		echo "|-----|------------------|---------|---------------|-----------------------|"
		echo "|  1  | 4.9.51 8MQ Beta  | morty   | 8             | imx8-morty-battra     |"
		echo "|  2  | 4.9.11_1.0.0 GA  | morty   | 6,7           | imx-morty-battra      |"
		echo "|  3  | 4.1.15_2.0.0 GA  | krogoth | 6,7 (No 7ULP) | imx-krogoth-battra    |" 
		echo "----------------------------------------------------------------------------"
		break
	else
		echo -e "${RED}Error: That is not a valid choice, try again.${NC}"
		echo $'\n'
	fi
done

while true; do
	read -p "Select which entry? " ENTRY
	if [ "$ENTRY" = "1" ] || [ "$ENTRY" = "2" ] || [ "$ENTRY" = "3" ]; then
		#echo "DEBUG:: $ENTRY"
		break
	else
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		echo $'\n'	
	fi
done


iMX8mortyorgaStableReleaseTag="imx8-morty-orga_r1.1"
iMXmortyorgaStableReleaseTag="imx-morty-orga_r1.2"
iMXkrogothorgaStableReleaseTag="imx-krogoth-orga_r1.1"

iMX8mortyorgaDeveloperRelease="imx8-morty-orga"
iMXmortyorgaDeveloperRelease="imx-morty-orga"
iMXkrogothorgaDeveloperRelease="imx-krogoth-orga"

iMX8mortybattraStableReleaseTag="imx8-morty-battra_r1.0"
iMXmortybattraStableReleaseTag="imx-morty-battra_r1.0"
iMXkrogothbattraStableReleaseTag="imx-krogoth-battra_r1.0"

iMX8mortybattraDeveloperRelease="imx8-morty-battra"
iMXmortybattraDeveloperRelease="imx-morty-battra"
iMXkrogothbattraDeveloperRelease="imx-krogoth-battra"

imx8mortyYocto="4.9.51 8MQ Beta"
imxmortyYocto="4.9.11_1.0.0 GA"
imxkrogothYocto="4.1.15_2.0.0 GA"

#Based on FMAC_VERSION
if [ "$FMAC_VERSION" = "1" ]; then
	#------------ Stable Release ----------------
	# imx8-morty-orga_r1.0
	if [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "1" ]; then
		BRANCH_RELEASE_OPTION=1
		BRANCH_RELEASE_NAME="$iMX8mortyorgaStableReleaseTag"
		iMXYoctoRelease="$imx8mortyYocto"
		YoctoBranch="morty"
		fmacversion="$ORGA_FMAC"

	# morty-orga_r1.0
	elif [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "2" ]; then
		BRANCH_RELEASE_OPTION=2
		BRANCH_RELEASE_NAME="$iMXmortyorgaStableReleaseTag"
		iMXYoctoRelease="$imxmortyYocto"
		YoctoBranch="morty"
		fmacversion="$ORGA_FMAC"

	# krogoth-orga_r1.0
	elif [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "3" ]; then
		BRANCH_RELEASE_OPTION=3
		BRANCH_RELEASE_NAME="$iMXkrogothorgaStableReleaseTag"
		iMXYoctoRelease="$imxkrogothYocto"
		YoctoBranch="krogoth"
		fmacversion="$ORGA_FMAC"

	# ------------Developer Release--------------
	# imx8-morty
	elif   [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "1" ]; then
		BRANCH_RELEASE_OPTION=4
		BRANCH_RELEASE_NAME="$iMX8mortyorgaDeveloperRelease"
		iMXYoctoRelease="$imx8mortyYocto"
		YoctoBranch="morty"
		fmacversion="$ORGA_FMAC"

	# morty-orga
	elif [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "2" ]; then
		BRANCH_RELEASE_OPTION=5
		BRANCH_RELEASE_NAME="$iMXmortyorgaDeveloperRelease"
		iMXYoctoRelease="$imxmortyYocto"
		YoctoBranch="morty"
		fmacversion="$ORGA_FMAC"

	# krogoth-orga
	elif [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "3" ]; then
		BRANCH_RELEASE_OPTION=6
		BRANCH_RELEASE_NAME="$iMXkrogothorgaDeveloperRelease"
		iMXYoctoRelease="$imxkrogothYocto"
		YoctoBranch="krogoth"
		fmacversion="$ORGA_FMAC"
	fi
elif [ "$FMAC_VERSION" = "2" ]; then
	# imx8-morty-battra_r1.0
	if [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "1" ]; then
		BRANCH_RELEASE_OPTION=1
		BRANCH_RELEASE_NAME="$iMX8mortybattraStableReleaseTag"
		iMXYoctoRelease="$imx8mortyYocto"
		YoctoBranch="morty"
		fmacversion="$BATTRA_FMAC"

	# morty-battra_r1.0
	elif [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "2" ]; then
		BRANCH_RELEASE_OPTION=2
		BRANCH_RELEASE_NAME="$iMXmortybattraStableReleaseTag"
		iMXYoctoRelease="$imxmortyYocto"
		YoctoBranch="morty"
		fmacversion="$BATTRA_FMAC"


	# krogoth-battra_r1.0
	elif [ "$BRANCH_TAG_OPTION"    = "y" ] && [ "$ENTRY" = "3" ]; then
		BRANCH_RELEASE_OPTION=3
		BRANCH_RELEASE_NAME="$iMXkrogothbattraStableReleaseTag"
		iMXYoctoRelease="$imxkrogothYocto"
		YoctoBranch="krogoth"
		fmacversion="$BATTRA_FMAC"

	# imx8-morty
	elif   [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "1" ]; then
		BRANCH_RELEASE_OPTION=4
		BRANCH_RELEASE_NAME="$iMX8mortybattraDeveloperRelease"
		iMXYoctoRelease="$imx8mortyYocto"
		YoctoBranch="morty"
		fmacversion="$BATTRA_FMAC"

	# morty-battra
	elif [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "2" ]; then
		BRANCH_RELEASE_OPTION=5
		BRANCH_RELEASE_NAME="$iMXmortybattraDeveloperRelease"
		iMXYoctoRelease="$imxmortyYocto"
		YoctoBranch="morty"
		fmacversion="$BATTRA_FMAC"

	# krogoth-battra
	elif [ "$BRANCH_TAG_OPTION" = "n" ] && [ "$ENTRY" = "3" ]; then
		BRANCH_RELEASE_OPTION=6
		BRANCH_RELEASE_NAME="$iMXkrogothbattraDeveloperRelease"
		iMXYoctoRelease="$imxkrogothYocto"
		YoctoBranch="krogoth"
		fmacversion="$BATTRA_FMAC"

	fi
fi

while true; do
case $BRANCH_RELEASE_OPTION in
	# For Branch : ----------------------imx8-morty-orga-------------------------
	1|4)
	echo -e "${GRN}Selected: $iMXYoctoRelease ${NC}"

	while true; do

	echo " "
	echo "6) Select Target"
	echo "----------------"
	echo " "
	echo "------------------------------------------------"
	echo "| Entry  |  Target Name      | i.MX Platform   |"
	echo "|--------|-------------------|-----------------|"
	echo "|  1     |  imx8mqevk        | i.MX 8MQuad EVK |"
	echo "------------------------------------------------"
	echo -n "Select your entry: "
	read TARGET_OPTION
	case $TARGET_OPTION in
		1)
		TARGET_NAME=imx8mqevk
		break
		;;

		*)
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		;;
	esac
	done
	echo -e "${GRN}Selected target : $TARGET_NAME ${NC}"
	break
	;;


	2|5)
	# For Branch/Tag : ---------------------imx-morty-orga / r_1.1-------------------------------
	echo -e "${GRN}Selected: $iMXYoctoRelease ${NC}"
	echo $'\n'

#       Prompting the user to select TARGET
	while true; do
	echo " "
	echo "6) Select Target"
	echo "----------------"
	echo " "
	echo "------------------------------------------------------"
	echo "| Entry  |    Target Name    | i.MX Platform         |"
	echo "|--------|-------------------|-----------------------|"
	echo "|  1     |  imx7dsabresd     | i.MX 7Dual SDB        |"
	echo "|  2     |  imx6qpsabresd    | i.MX 6QuadPlus SDB    |"
	echo "|  3     |  imx6qsabresd     | i.MX 6Quad SDB        |"
	echo "|  4     |  imx6dlsabresd    | i.MX 6DualLite SDB    |"
	echo "|  5     |  imx6sxsabresd    | i.MX 6SX  SDB         |"
	echo "|  6     |  imx6slevk        | i.MX 6SL  EVK         |"
	echo "|  7     |  imx6ulevk        | i.MX 6UL  EVK         |"
	echo "|  8     |  imx6ull14x14evk  | i.MX 6ULL EVK(14x14)  |"
	echo "|  9     |  imx6ull9x9evk    | i.MX 6ULL EVK(9x9)    |"
	echo "|  10    |  imx7ulpevk       | i.MX 7ULP EVK         |"
	echo "------------------------------------------------------"
	echo -n "Select your entry: "
	read TARGET_OPTION

	case $TARGET_OPTION in
		1)
		TARGET_NAME=imx7dsabresd
		break
		;;

		2)
		TARGET_NAME=imx6qpsabresd
		break
		;;

		3)
		TARGET_NAME=imx6qsabresd
		break
		;;

		4)
		TARGET_NAME=imx6dlsabresd
		break
		;;

		5)
		TARGET_NAME=imx6sxsabresd
		break
		;;

		6)
		TARGET_NAME=imx6slevk
		break
		;;

		7)
		TARGET_NAME=imx6ulevk
		break
		;;

		8)
		TARGET_NAME=imx6ull14x14evk
		break
		;;

		9)
		TARGET_NAME=imx6ull9x9evk
		break
		;;

		10)
		TARGET_NAME=imx7ulpevk
		break
		;;

		*)
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		;;
	esac
	done

	echo -e "${GRN}Selected target: $TARGET_NAME ${NC}"
	echo $'\n'

#	Start - Prompt user to select VIO Signaling
	if [ "$TARGET_NAME" = "imx6ulevk" ] ||  [ "$TARGET_NAME" = "imx6ull14x14evk" ] ||  [ "$TARGET_NAME" = "imx6ull9x9evk" ]; then
		while true; do

		echo " "
		echo "6.1) Select VIO Signaling"
		echo "-------------------------"
		echo " "
		echo    "------------------------------------------------------------------------------"
		echo    "| Entry  |  Options                                                          |"
		echo    "|--------|-------------------------------------------------------------------|"
		echo    "|   1.   | 1.8V VIO signaling with UHS support                               |"
		echo -e "|   2.   | 1.8V VIO signaling ${YLW}without${NC} UHS support                            |"
		echo -e "|   ${GRN}3.${NC}   | ${GRN}3.3V VIO signaling (No HW mods needed)${NC}                            |"
		echo    "------------------------------------------------------------------------------"
		echo " "
                echo " Refer to Murata Quickstart Guide for more details:"
                echo " - Murata Wi-Fi BT Solution for i.MX Quick Start Guide (Linux) 5.x.pdf"
		echo " "

		echo -n "Select your entry: "
		read VIO_SIGNALING_OPTION
		case $VIO_SIGNALING_OPTION in
			1)
			LINUX_SRC=linux-imx_4.9.11.bbappend.6UL_6ULL@1.8V
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling with UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			2)
			LINUX_SRC=linux-imx_4.9.11.bbappend.6UL_6ULL@1.8V_No_UHS
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling without UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			3)
			LINUX_SRC=linux-imx_4.9.11.bbappend
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="3.3V VIO signaling (No HW mods needed)"
			break
			;;

			*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
		done
		echo -e "${GRN}Selected $VIO_SIGNALING_STRING. ${NC}"
	fi

	if [ "$TARGET_NAME" = "imx6sxsabresd" ]; then
		while true; do
		echo " "
		echo "6.1) Select VIO Signaling"
		echo "-------------------------"
		echo " "
		echo "---------------------------------------------------"
		echo "| Entry  |  Options                               |"
		echo "|--------|----------------------------------------|"
		echo "|   1.   | 1.8V VIO signaling with UHS support    |"
		echo "|   ${GRN}2.${NC}   | ${GRN}3.3V VIO signaling (No HW mods needed)${NC} |"
		echo "--------------------------------------------------"
		echo " "
                echo " Refer to Murata Quickstart Guide for more details:"
                echo " - Murata Wi-Fi BT Solution for i.MX Quick Start Guide (Linux) 5.x.pdf"
		echo " "

		echo -n "Select your entry: "
		read VIO_SIGNALING_OPTION
		case $VIO_SIGNALING_OPTION in
			1)
			LINUX_SRC=linux-imx_4.9.11.bbappend.6SX@1.8V
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling with UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			2)
			LINUX_SRC=linux-imx_4.9.11.bbappend
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="3.3V VIO signaling"
			break
			;;

			*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
		done
		echo -e "${GRN}Selected $VIO_SIGNALING_STRING. ${NC}"
	fi

	if [ "$TARGET_NAME" = "imx7ulpevk" ]; then
		while true; do
		echo " "
		echo "6.1) Select VIO Signaling"
		echo "-------------------------"
		echo " "
		echo "-------------------------------------------------"
		echo "| Entry  |  Options                             |"
		echo "|--------|--------------------------------------|"
		echo "|   1.   | 1.8V VIO signaling with UHS support  |"
		echo "-------------------------------------------------"
		echo " "
                echo " Refer to Murata Quickstart Guide for more details:"
                echo " - Murata Wi-Fi BT Solution for i.MX Quick Start Guide (Linux) 5.x.pdf"
		echo " "
		echo -n  "Select your entry: "
		read VIO_SIGNALING_OPTION
		case $VIO_SIGNALING_OPTION in
			1)
			LINUX_SRC=linux-imx_4.9.11.bbappend.7ULP@1.8V
			LINUX_DEST=linux-imx_4.9.11.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling with UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
		done
		echo -e "${GRN}Selected $VIO_SIGNALING_STRING. ${NC}"
	fi
#	End - Prompt user to select VIO Signaling
	break
	;;

	# For Branch : ---------------------------imx-krogoth-orga---------------------------
	3|6)
	echo -e "${GRN}Selected: $iMXYoctoRelease ${NC}"
	echo $'\n'

	while true; do
	echo " "
	echo "6) Select target"
	echo "----------------"
	echo " "
	echo "------------------------------------------------------"
	echo "| Entry  |    Target Name    | i.MX Platform         |"
	echo "|--------|-------------------|-----------------------|"
	echo "|  1     |  imx7dsabresd     | i.MX 7Dual SDB        |"
	echo "|  2     |  imx6qpsabresd    | i.MX 6QuadPlus SDB    |"
	echo "|  3     |  imx6qsabresd     | i.MX 6Quad SDB        |"
	echo "|  4     |  imx6dlsabresd    | i.MX 6DualLite SDB    |"
	echo "|  5     |  imx6sxsabresd    | i.MX 6SX  SDB         |"
	echo "|  6     |  imx6slevk        | i.MX 6SL  EVK         |"
	echo "|  7     |  imx6ulevk        | i.MX 6UL  EVK         |"
	echo "|  8     |  imx6ull14x14evk  | i.MX 6ULL EVK(14x14)  |"
	echo "|  9     |  imx6ull9x9evk    | i.MX 6ULL EVK(9x9)    |"
	echo "------------------------------------------------------"
	echo -n "Select your entry: "
	read TARGET_OPTION
	case $TARGET_OPTION in
		1)
		TARGET_NAME=imx7dsabresd
		break
		;;

		2)
		TARGET_NAME=imx6qpsabresd
		break
		;;

		3)
		TARGET_NAME=imx6qsabresd
		break
		;;

		4)
		TARGET_NAME=imx6dlsabresd
		break
		;;

		5)
		TARGET_NAME=imx6sxsabresd
		break
		;;

		6)
		TARGET_NAME=imx6slevk
		break
		;;

		7)
		TARGET_NAME=imx6ulevk
		break
		;;

		8)
		TARGET_NAME=imx6ull14x14evk
		break
		;;

		9)
		TARGET_NAME=imx6ull9x9evk
		break
		;;

		*)
		echo -e "${RED}That is not a valid choice, try again.${NC}"
		;;
	esac
	done

	echo -e "${GRN}Selected target : $TARGET_NAME ${NC}"
	echo $'\n'

#	Start - Prompt user to select VIO Signaling
	if [ "$TARGET_NAME" = "imx6ulevk" ] ||  [ "$TARGET_NAME" = "imx6ull14x14evk" ] ||  [ "$TARGET_NAME" = "imx6ull9x9evk" ]; then
		while true; do
		echo " "
		echo "6.1) Select VIO Signaling"
		echo "-------------------------"
		echo " "
		echo    "------------------------------------------------------------------------------"
		echo    "| Entry  |  Options                                                          |"
		echo    "|--------|-------------------------------------------------------------------|"
		echo    "|   1.   | 1.8V VIO signaling with UHS support                               |"
		echo -e "|   2.   | 1.8V VIO signaling ${YLW}without${NC} UHS support                            |"
		echo -e "|   ${GRN}3.${NC}   | ${GRN}3.3V VIO signaling (No HW mods needed)${NC}                            |"
		echo     "------------------------------------------------------------------------------"
		echo " "
                echo " Refer to Murata Quickstart Guide for more details:"
                echo " - Murata Wi-Fi BT Solution for i.MX Quick Start Guide (Linux) 5.x.pdf"
		echo " "

		echo -n "Select your entry: "
		read VIO_SIGNALING_OPTION
		case $VIO_SIGNALING_OPTION in
			1)
			LINUX_SRC=linux-imx_4.1.15.bbappend.6UL_6ULL@1.8V
			LINUX_DEST=linux-imx_4.1.15.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling with UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			2)
			LINUX_SRC=linux-imx_4.1.15.bbappend.6UL_6ULL@1.8V_No_UHS
			LINUX_DEST=linux-imx_4.1.15.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling without UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			3)
			LINUX_SRC=linux-imx_4.1.15.bbappend
			LINUX_DEST=linux-imx_4.1.15.bbappend
			VIO_SIGNALING_STRING="3.3V VIO signaling"
			break
			;;

			*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
		done
		echo -e "${GRN}Selected $VIO_SIGNALING_STRING. ${NC}"
	fi

	if [ "$TARGET_NAME" = "imx6sxsabresd" ]; then
		while true; do
		echo " "
		echo "6.1) Select VIO Signaling"
		echo "-------------------------"
		echo " "
		echo "-------------------------------------------------"
		echo "| Entry  |  Options                             |"
		echo "|--------|--------------------------------------|"
		echo "|   1.   | 1.8V VIO signaling with UHS support  |"
		echo "|   ${GRN}2.${NC}   | ${GRN}3.3V VIO signaling${NC}                   |"
		echo "-------------------------------------------------"
		echo " "
                echo " Refer to Murata Quickstart Guide for more details:"
                echo " - Murata Wi-Fi BT Solution for i.MX Quick Start Guide (Linux) 5.x.pdf"
		echo " "

		echo -n "Select your entry: "
		read VIO_SIGNALING_OPTION
		case $VIO_SIGNALING_OPTION in
			1)
			LINUX_SRC=linux-imx_4.1.15.bbappend.6SX@1.8V
			LINUX_DEST=linux-imx_4.1.15.bbappend
			VIO_SIGNALING_STRING="1.8V VIO signaling with UHS support - ${YLW}HW mods needed${NC}"
			break
			;;

			2)
			LINUX_SRC=linux-imx_4.1.15.bbappend
			LINUX_DEST=linux-imx_4.1.15.bbappend
			VIO_SIGNALING_STRING="3.3V VIO signaling"
			break
			;;

			*)
			echo -e "${RED}That is not a valid choice, try again.${NC}"
			;;
		esac
		done
		echo -e "${GRN}Selected $VIO_SIGNALING_STRING. ${NC}"
	fi
#	End - Prompt user to select VIO Signaling
	break
	;;

	# For Retry : ------------------------------Retry-------------------------------------------
	*)
	echo -e "${RED}That is not a valid choice, try again.${NC}"
	;;
esac
done

DISTRO_NAME=fsl-imx-x11
IMAGE_NAME=fsl-image-validation-imx

echo " "
echo "7) Select DISTRO & Image"
echo "------------------------"
echo " "
echo "Murata default DISTRO & Image pre-selected are:"
echo -e "${GRN}DISTRO: $DISTRO_NAME${NC}"
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
			echo " "
			echo "7.1) Select DISTRO"
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

			#       Prompting the user to select the DISTRO
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
			echo -e "${GRN}Selected DISTRO: $DISTRO_NAME. ${NC}"
		else
			echo -e "${GRN}Proceeding with Murata default DISTRO: $DISTRO_NAME${NC}"
		fi
	
	#       Prompting the user to select which image to build
	  	if [ "$PROMPT" = "U" ] || [ "$PROMPT" = "u" ]; then

			echo ""
			echo " "
			echo "7.2) Select Image"
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

				*)
				echo -e "${RED}That is not a valid choice, try again.${NC}"
				;;
			esac
			done
			echo -e "${GRN}Selected Image: $IMAGE_NAME. ${NC}"
		else
			echo -e "${GRN}Proceeding with Murata default Image:  $IMAGE_NAME${NC}"
		fi
	
else
	echo -e "${GRN}Proceeding with Murata defaults.${NC}"
fi


#echo $'\n'
#echo "-------------------------------Creation of Build Directory---------------------------"
echo " "
echo "8) Creation of Build directory"
echo "------------------------------"
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

echo " "
echo "9) Verify your selection"
echo "-------------------------"
echo " "

echo -e "i.MX Yocto Release              : ${GRN}$iMXYoctoRelease${NC}"
echo -e "Yocto branch                    : ${GRN}$YoctoBranch${NC}"
echo -e "fmac version                    : ${GRN}$fmacversion${NC}"
echo -e "Target                          : ${GRN}$TARGET_NAME${NC}"
echo -e "meta-murata-wireless Release Tag: ${GRN}$BRANCH_RELEASE_NAME${NC}"

# if the selected branch is i.MX8, then don't display the VIO Signaling selection
if [ "$BRANCH_RELEASE_OPTION" -ne "1" ] && [ "$BRANCH_RELEASE_OPTION" -ne "4" ]; then
#	echo    "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
	echo -e "VIO Signaling                   : ${GRN}$VIO_SIGNALING_STRING${NC}"
fi

echo -e "DISTRO                          : ${GRN}$DISTRO_NAME${NC}"
echo -e "Image                           : ${GRN}$IMAGE_NAME ${NC}"
echo -e "Build Directory                 : ${GRN}$BUILD_DIR_NAME${NC}"


echo " "
echo "Please verify your selection"


echo -e -n "Do you accept selected configurations ? ${GRN}Y${NC}/${YLW}n${NC}: "
read REPLY

if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || [ "$REPLY" = "" ]; then
	echo " "
	echo "10) Acceptance of End User License Agreement(EULA)"
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
	if [ "$iMXYoctoRelease" = "$imx8mortyYocto" ]; then
		#echo "DEBUG:: IMX8"
		repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-morty -m imx-4.9.51-8mq_beta.xml
	elif [ "$iMXYoctoRelease" = "$imxmortyYocto"  ]; then
		#echo "DEBUG:: MORTY"
		repo init -u https://source.codeaurora.org/external/imx/fsl-arm-yocto-bsp.git -b imx-morty -m imx-4.9.11-1.0.0_ga.xml
	elif [ "$iMXYoctoRelease" = "$imxkrogothYocto"  ]; then
		#echo "DEBUG:: KROGOTH"
		repo init -u https://source.codeaurora.org/external/imx/fsl-arm-yocto-bsp.git -b imx-4.1-krogoth -m imx-4.1.15-2.0.0.xml
	fi

	#echo "DEBUG:: Performing repo sync......."
	repo sync
	cd $BSP_DIR


	#echo "DEBUG:: Performing Setup of DISTRO and MACHINE"
	#echo "DEBUG:: pwd = $BSP_DIR"
	DISTRO=$DISTRO_NAME MACHINE=$TARGET_NAME source ./fsl-setup-release.sh -b $BUILD_DIR_NAME
	export BUILD_DIR=`pwd`

	cd $BSP_DIR/sources
	git clone $META_MURATA_WIRELESS_GIT
	cd meta-murata-wireless

	git checkout $BRANCH_RELEASE_NAME
	cd $BSP_DIR
	chmod 777 sources/meta-murata-wireless/add-murata-layer-script/add-murata-wireless.sh
	sh ./sources/meta-murata-wireless/add-murata-layer-script/add-murata-wireless.sh $BUILD_DIR_NAME
	cd $BSP_DIR/sources/meta-murata-wireless/recipes-kernel/linux

#	Copies necessary bbappend file ( 1.8V or 3.3V VIO signaling ) to the default file
	case $BRANCH_RELEASE_OPTION in
		2|3|5|6)
		if [ "$LINUX_SRC" != "$LINUX_DEST" ]; then
			cp $LINUX_SRC $LINUX_DEST
		fi
		;;
	esac

	cd $BUILD_DIR

	echo " "
	echo "11) Starting Build Now."
	echo "-----------------------"
	echo " "
	echo -e "${YLW}NOTE: depending on machine type, build may take 1-7 hours to complete.${NC}"
	echo " "
        echo ""\'"Y"\'" to continue, "\'"n"\'" aborts build."
	echo -e -n "Do you want to start the build ? ${GRN}Y${NC}/${YLW}n${NC}: "
	read PROCEED_BUILD

	if [ "$PROCEED_BUILD" = "y" ] || [ "$PROCEED_BUILD" = "Y" ] || [ "$PROCEED_BUILD" = "" ] ; then
		bitbake $IMAGE_NAME
		exit
	else
		echo -e "${RED}Exiting script.....${NC}"
		exit
	fi
else
	echo -e "${RED}Exiting script.....${NC}"
	exit
fi

	








