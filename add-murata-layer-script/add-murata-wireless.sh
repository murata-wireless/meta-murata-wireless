cp ./sources/meta-murata-wireless/freescale/imx6ulevk.conf ./sources/meta-freescale/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6ull14x14evk.conf ./sources/meta-imx/meta-imx-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6slevk.conf ./sources/meta-freescale/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6sxsabresd.conf ./sources/meta-freescale/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6qsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6qpsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx6dlsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx8_all.conf ./sources/meta-imx/meta-imx-bsp/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx8mm-lpddr4-evk.conf ./sources/meta-freescale/conf/machine/
cp ./sources/meta-murata-wireless/freescale/imx8mn-lpddr4-evk.conf ./sources/meta-freescale/conf/machine/
cp ./sources/meta-murata-wireless/freescale/layer.conf ./sources/meta-imx/meta-imx-bsp/conf/


#EULA=$EULA DISTRO=$DISTRO MACHINE=$MACHINE . ./sources/meta-fsl-bsp-release/imx/tools/fsl-setup-release.sh -b $@
. ./setup-environment $@

echo "INTERNAL_MIRROR = \"http://localhost\"" >> conf/local.conf
echo "CORE_IMAGE_EXTRA_INSTALL += \" hostap-conf hostap-utils hostapd murata-binaries iperf3 \"" >> conf/local.conf
echo "CORE_IMAGE_EXTRA_INSTALL += \" bluez5 bluez5-noinst-tools bluez5-obex openobex obexftp glibc-gconv-utf-16 glibc-utils wpa-supplicant python3\"" >> conf/local.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-murata-wireless \"" >> conf/bblayers.conf
echo ""
echo "CORRECTION: Murata modified the following files"
echo "  - bblayers.conf present in <BUILD_DIR>/conf"
echo "  - local.conf present in <BUILD_DIR>/conf"
echo "  - imx6ulevk.conf present in sources/meta-freescale/conf/machine"
echo "  - imx6ull14x14evk.conf present in sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx6slevk.conf ./sources/meta-freescale/conf/machine"
echo "  - imx6sxsabresd.conf ./sources/meta-freescale/conf/machine"
echo "  - imx6qsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx6qpsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx6dlsabresd.conf ./sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx8mnevk.conf ./sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx8_all.conf ./sources/meta-imx/meta-imx-bsp/conf/machine"
echo "  - imx8mm-lpddr4-evk.conf ./sources/meta-freescale/conf/machine"
echo "  - imx8mn-lpddr4-evk.conf ./sources/meta-freescale/conf/machine"
echo "  - layer.conf ./sources/meta-imx/meta-imx-bsp/conf"

echo ""
echo "Murata-Wireless setup complete. Create an image with:"
echo "    $ bitbake fsl-image-validation-imx"
echo ""

