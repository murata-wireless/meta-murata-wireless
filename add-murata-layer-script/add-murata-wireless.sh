cp ./sources/meta-murata-wireless/freescale/imx6ulevk.conf ./sources/meta-fsl-bsp-release/imx/meta-bsp/conf/machine/
EULA=$EULA DISTRO=$DISTRO MACHINE=$MACHINE . ./sources/meta-fsl-bsp-release/imx/tools/fsl-setup-release.sh -b $@

echo "INTERNAL_MIRROR = \"http://localhost\"" >> conf/local.conf
echo "CORE_IMAGE_EXTRA_INSTALL += \" hostap-conf hostap-utils hostapd backporttool-linux murata-binaries iperf3\"" >> conf/local.conf

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-murata-wireless \"" >> conf/bblayers.conf

echo ""
echo "CORRECTION: Murata modified the following files"
echo "  - bblayers.conf present in <BUILD_DIR>/conf"
echo "  - local.conf present in <BUILD_DIR>/conf"
echo "  - imx6ulevk.conf present in sources/meta-freescale/conf/machine"
echo ""
echo "Murata-Wireless setup complete. Create an image with:"
echo "    $ bitbake fsl-image-validation-imx"
echo ""

