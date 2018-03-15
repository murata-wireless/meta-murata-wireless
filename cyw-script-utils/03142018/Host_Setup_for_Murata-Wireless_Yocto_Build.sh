#!/bin/bash
VERSION=03152018

# Murata cript File used to do necessary host setup on Ubuntu 16.04, 14.04 or 12.04 for Linux i.MX Yocto image build. 
#
# User running this script needs root priviledges - i.e. included in "sudoers" file. 
# Script assumes that "root" is not executing it. 
#  
# Use colors to highlight pass/fail conditions. 


RED='\033[1;31m' # Red font to flag errors
GRN='\033[1;32m' # Green font to flag pass
YLW='\033[1;33m' # Yellow font for highlighting
NC='\033[0m' # No Color

#echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

# Kick off script with log message. 
echo -e "Murata: setup script to check Ubuntu installation and install additional"
echo -e "        host packages necessary for Yocto build"
echo    "========================================================================"

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
echo "2) Verifying Host Script Version"
echo "--------------------------------"


GITHUB_PATH="\""https://github.com/murata-wireless/meta-murata-wireless.git"\""
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
	git clone https://github.com/murata-wireless/meta-murata-wireless.git --quiet
	cd $TEST_DIR_NAME/cyw-script-utils/latest
fi

export SCRIPT_DIR=`pwd`
#echo "Latest folder path: $SCRIPT_DIR"

# Scan through the file Host_Setup_for_Murata-Wireless_Yocto_Build.sh to fetch the Revision Information
COUNTER=0
input_file_path="$SCRIPT_DIR/Host_Setup_for_Murata-Wireless_Yocto_Build.sh"

while IFS= read -r LATEST_VER
do
  COUNTER=$[$COUNTER +1]
  if [ "$COUNTER" = "2" ] ; then
  break
  fi
done < "$input_file_path"

cd $BSP_DIR

# read first and second line of Host_Setup_for_Murata-Wireless_Yocto_Build.sh script
IFS== read FIRST_LINE LATEST_VER <<< $LATEST_VER


# Check for latest revision
if [ "$VERSION" = "$LATEST_VER" ]; then
	echo    "Latest:  $LATEST_VER"
	echo -e "Current: $VERSION${GRN}........PASS${NC}"
else 
	echo    "Latest:  $LATEST_VER"
	echo -e "Current: ${YLW}$VERSION........MISMATCH${NC}"
	echo " "

        echo -n -e "Do you want to update host setup script? ${GRN}Y${NC}/${YLW}n${NC}: "
	read PROCEED_UPDATE_OPTION
	
	if [ "$PROCEED_UPDATE_OPTION" = "y" ] || [ "$PROCEED_UPDATE_OPTION" = "Y" ] || [ "$PROCEED_UPDATE_OPTION" = "" ]; then
		echo "Update to latest version using following copy command:"
		echo " "
		echo ""\$ "cp ./meta-murata-wireless/cyw-script-utils/latest/Host_Setup_for_Murata-Wireless_Yocto_Build.sh ."
		echo " "
		echo -e "${YLW}Exiting script.....${NC}"
       		exit
	else
		echo " "
		echo -e "${YLW}CONTINUING WITH CURRENT SCRIPT.${NC}"
	fi
fi


#------------------------------------------------------------------------------------------------------------------------
# Essential Yocto Project host packages: 
echo " "
echo "3) Installing Essential Yocto host packages"
echo "-------------------------------------------"
echo " "
echo    "Murata: Installing Essential Yocto Project host packages."
echo -e "        ${YLW}sudoers-priviledged user will be prompted for password...${NC}"

sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev
# i.MX layers host packages for a Ubuntu 12.04 or 14.04 or 16.04 host setup are:
echo -e "${GRN}Murata: Installing i.MX layers host packages...${NC}"
sudo apt-get install libsdl1.2-dev xterm sed cvs subversion coreutils texi2html docbook-utils python-pysqlite2 help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial autoconf automake groff curl lzop asciidoc repo

# Check Ubuntu version and install additional packages accordingly
if [ $Ubuntu_Release == "12.04" ]; then
                # i.MX layers host packages for a Ubuntu 12.04 host setup only are:
                echo -e "${GRN}Murata: Installing i.MX layers host packages for a Ubuntu 12.04 host setup only...${NC}"
                sudo apt-get install uboot-mkimage 
elif [ $Ubuntu_Release == "16.04" ] || [ $Ubuntu_Release == "14.04" ]; then
                # i.MX layers host packages for a Ubuntu 14.04 or 16.04 host setup only are:
                echo -e "${GRN}Murata: Installing i.MX layers host packages for a Ubuntu 16.04 or 14.04 host setup only...${NC}"
                sudo apt-get install u-boot-tools
else
                echo -e "${RED}Murata: Ubuntu Release version not supported:${NC}" $Ubuntu_Release
                exit        
fi

# Host packages installed. 
echo -e "${GRN}Murata: Ubuntu Linux host environment verified, necessary host packages installed...${NC}"


echo " "
echo "4) GIT Configuration"
echo "--------------------"
echo " "
# Now set git username and email address
read -p "Enter your name for git configuration: " Your_Name
echo "OK to proceed with git username as?:" $Your_Name
read -p "Y/N: " Proceed_Flag
if [ $Proceed_Flag == "Y" ]; then
                git config --global user.name "$Your_Name"
else
                echo -e "${RED}Murata: error with git username configuration. Please run "
		echo -e "${YLW}'git config --global user.name \"Your Name\"'${RED} before Yocto build!!!${NC}"
                echo -e "${RED}Murata: if you need to correct git username then run"
		echo -e "${YLW}'git config --global --unset-all user.name'${RED} first.${NC}"
fi

echo " "
read -p "Enter your email address for git configuration: " Email_Address
echo "OK to proceed with git email address as?:" $Email_Address 
read -p "Y/N: " Proceed_Flag
if [ $Proceed_Flag == "Y" ]; then
                git config --global user.email $Email_Address
else
                echo -e "${RED}Murata: error with git email address configuration. Please run "
		echo -e "${YLW}'git config --global user.email \"Your Email\"'${RED} before Yocto build!!!${NC}"
                echo -e "${RED}Murata: if you need to correct git email address then run"
		echo -e "${YLW}'git config --global --unset-all user.email'${RED} first.${NC}"
fi

echo " "
# Print out git username and email address before exiting script.
echo -e "${YLW}Murata: please verify git username and email address prior to running Yocto build."
echo -e "Currently configured as...${NC}"
git config --list

# Host packages installed. Script finished.  
echo -e "${GRN}Murata: If git username/email OK, then ready to build \"meta-murata-wireless\" customized i.MX Linux image!${NC}"

