cp ./sources/meta-murata-wireless/freescale/imx6ulevk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6ull14x14evk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6dlsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6qpsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6qsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6slevk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6sxsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/firmware-imx_5.4.bbx ./sources/meta-fsl-arm/recipes-bsp/firmware-imx/firmware-imx_5.4.bb

EULA=$EULA DISTRO=$DISTRO MACHINE=$MACHINE . ./sources/meta-fsl-bsp-release/imx/tools/fsl-setup-release.sh -b $@

echo "INTERNAL_MIRROR = \"http://localhost\"" >> conf/local.conf
echo "CORE_IMAGE_EXTRA_INSTALL += \" hostap-conf hostap-utils hostapd backporttool-linux murata-binaries iperf iperf3\"" >> conf/local.conf

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-murata-wireless \"" >> conf/bblayers.conf

echo ""
echo "CORRECTION: Murata modified the following files"
echo "  - bblayers.conf present in <BUILD_DIR>/conf"
echo "  - local.conf present in <BUILD_DIR>/conf"
echo "  - imx6ulevk.conf present in sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6ull14x14evk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6dlsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6qpsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6qsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6slevk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo "  - imx6sxsabresd.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/"
echo ""
echo "Murata-Wireless setup complete. Create an image with:"
echo "    $ bitbake fsl-image-validation-imx"
echo ""

# Start parsing first line from local.conf for fetching MACHINE type
COUNTER=0
input_file_path="conf/local.conf"
IMX6ULL='imx6ull14x14evk'
while IFS= read -r LATEST_VER
do
	COUNTER=$[$COUNTER +1]
	if [ "$COUNTER" = "1" ] ; then
	break
	fi
done < "$input_file_path"

IFS== read FIRST_LINE MACHINE_TEXT LATEST_VER <<< $LATEST_VER
#echo "1. DEBUG-DEBUG:: First line is machine type:$MACHINE_TEXT"

MACHINE_TEXT=`echo $MACHINE_TEXT | sed 's/^ *$//g'`
#echo "2. DEBUG-DEBUG:: First line is machine type:$MACHINE_TEXT-$IMX6ULL"

MACHINE_TEXT=`echo $MACHINE_TEXT | sed 's/.$//'`
#echo "3. DEBUG-DEBUG:: First line is machine type:$MACHINE_TEXT"

MACHINE_TEXT=`echo $MACHINE_TEXT | sed 's/^.//'`
#echo "4. DEBUG-DEBUG:: First line is machine type:$MACHINE_TEXT"

if [ "$MACHINE_TEXT" == $IMX6ULL ]; then
#	echo    "Latest:  Success"
#	pwd
	cd ..
	cp ./sources/meta-murata-wireless/freescale/linux-imx_4.1.15.bbx ./sources/meta-fsl-bsp-release/imx/meta-bsp/recipes-kernel/linux/linux-imx_4.1.15.bb
fi

