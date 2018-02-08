SUMMARY = "Murata Binaries"
LICENSE = "BSD"

LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

#Default NVRAM, Firmware and CLM Blob files
SRC_URI =  "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43012-sdio.bin;name=archive2"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43012-sdio.clm_blob;name=archive3"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac43012-sdio.txt;name=archive4"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43340-sdio.bin;name=archive5"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac43340-sdio.txt;name=archive6"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43362-sdio.bin;name=archive7"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac43362-sdio.txt;name=archive8"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac4339-sdio.bin;name=archive9"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac4339-sdio.txt;name=archive10"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43430-sdio.bin;name=archive11"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac43430-sdio.txt;name=archive12"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43455-sdio.bin;name=archive13"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac43455-sdio.clm_blob;name=archive14"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac43455-sdio.txt;name=archive15"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac4354-sdio.bin;name=archive16"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac4354-sdio.txt;name=archive17"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-fw/raw/orga/brcmfmac4356-pcie.bin;name=archive18"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/brcmfmac4356-pcie.txt;name=archive19"

#murata-master for NVRAM files
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43012-sdio.1LV.txt;name=archive24"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43340-sdio.1BW.txt;name=archive25"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43362-sdio.SN8000.txt;name=archive26"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac4339-sdio.1CK.txt;name=archive27"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac4339-sdio.ZP.txt;name=archive28"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43430-sdio.1DX.txt;name=archive29"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43430-sdio.1LN.txt;name=archive30"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43455-sdio.1HK.txt;name=archive31"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43455-sdio.1LC.txt;name=archive32"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac43455-sdio.1MW.txt;name=archive33"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac4354-sdio.1BB.txt;name=archive34"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/murata-master/brcmfmac4356-pcie.1CX.txt;name=archive35"


#Default hcd files
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW4335C0.ZP.hcd;name=archive36"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW4345C0.1MW.hcd;name=archive37"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW43012C0.1LV.hcd;name=archive38"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW43341B0.1BW.hcd;name=archive39"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW43430A1.1DX.hcd;name=archive40"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/README_BT_PATCHFILES;name=archive41"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/CYW4350C0.1BB.hcd;name=archive42"

#murata-master for hcd file
#SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW4335C0.ZP.hcd;name=archive42"
#SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW4345C0.1MW.hcd;name=archive43"
#SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW43012C0.1LV.hcd;name=archive44"
#SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW43341B0.1BW.hcd;name=archive45"
#SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW43430A1.1DX.hcd;name=archive46"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW43430A1.1DX.1dB_Less.hcd;name=archive47"
SRC_URI += "https://github.com/murata-wireless/cyw-bt-patch/raw/krogoth-orga/murata-master/CYW43430A1.1DX.2dB_Less.hcd;name=archive48"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-utils-imx32/raw/orga/wl;name=archive49"

#README file
SRC_URI += "https://github.com/murata-wireless/meta-murata-wireless/raw/imx-krogoth-orga/LICENSE;name=archive99"
SRC_URI += "https://github.com/murata-wireless/cyw-fmac-nvram/raw/orga/README_NVRAM;name=archive100"

SRC_URI[archive2.md5sum] = "9bfb3d7cf9eabc63bfc029646d82f42d"
SRC_URI[archive2.sha256sum] = "109ae675f931f7dc6a3d1409a9b18d2fd14aa1fb00b8bc4be6b869d90d2e8d9f"

SRC_URI[archive3.md5sum] = "993f4b4693f25049e10a9a6f8430dca6"
SRC_URI[archive3.sha256sum] = "d52808db96233a66d2f5b5193513a7fec37bed3b01e1452916e3d4194dd47798"


SRC_URI[archive4.md5sum] = "8f5ff13473d46769b1a5158edd25e570"
SRC_URI[archive4.sha256sum] = "fa0d7ade09034776ac80b42410230f91cc4a01be4e04dfcc5498d68012389498"

SRC_URI[archive5.md5sum] = "6f8478d1f0fcdcceb8e4ec8b4e92c69c"  
SRC_URI[archive5.sha256sum] = "154cdef77d0a18f66dec1bf34a4759bee956bec8d396eb58f2b141051907f415"

SRC_URI[archive6.md5sum] = "3baf1bb04581b46ed861919b6ee80176"
SRC_URI[archive6.sha256sum] = "98acd589e3a9022363a4ade1df293c15a48ec4a5f13acab795a3ff36a5d28f35"

SRC_URI[archive7.md5sum] = "4add351e6a3d4a855a2e2a259aebe6bd"
SRC_URI[archive7.sha256sum] = "a045e94036f2ada546554885847fdc845120b9fc904f0a8b377df9b75e57459c"

SRC_URI[archive8.md5sum] = "a77318277df2a4dab8dab6b7caa2b275"  
SRC_URI[archive8.sha256sum] = "ef76dd0038f1944430d2c870de8877cc58415b5268422a4e9c343aed0122c2a4"

SRC_URI[archive9.md5sum] = "f315075fa6c604cf9087b7d468de91f3"  
SRC_URI[archive9.sha256sum] = "939b9e29017027093a6cdc67b9bc800badcb3abeccfb75b632aed6b68c914888"

SRC_URI[archive10.md5sum] = "bcd3a921750dfe9f403ef96fdeac6b84"
SRC_URI[archive10.sha256sum] = "cbef1c5f4945d11bd72f2dafaea2e227193dd6ee31e456f455b671610d80284a"

SRC_URI[archive11.md5sum] = "ba679a85c1dc76e9775603af45440bc0"
SRC_URI[archive11.sha256sum] = "996b7ef7cbdb8ea3855fa516acb57630ff03a449fd3bb23e84789f2f04b4faf5"

SRC_URI[archive12.md5sum] = "680f28b5bb6cc75cdba3a8d96151924d"
SRC_URI[archive12.sha256sum] = "6bc800e44a73bc8e809ca0fd35b05227e437bdc5439fa5083a307abe3ae0f810"

SRC_URI[archive13.md5sum] = "fa51d98b871af295de6e32aef101a21d"
SRC_URI[archive13.sha256sum] = "55f1083fb142e57249e38eaf9dab0c7409423a59b2d14751532312b27c289eeb"

SRC_URI[archive14.md5sum] = "718e81e2d9a3185d4ddd6d2bc559cb9b"
SRC_URI[archive14.sha256sum] = "3c8e5bf449ea60121dac8af2ac6588ff1954d3e8c86220c6fea2485129c05c0a"

SRC_URI[archive15.md5sum] = "2e5f51198b7df0e9e03bcd548fde5139"
SRC_URI[archive15.sha256sum] = "daf7859c9469d88180e42b2ee79bd6f5b4801ee515f78a801f5686fc818ad69b"

SRC_URI[archive16.md5sum] = "682abcc3915957f2177ab67b25a49dd5"
SRC_URI[archive16.sha256sum] = "0d57de9fc4746f74a822ff50ab0138da5b9f47efbe443fa1f045301b4bab195f"

SRC_URI[archive17.md5sum] = "fdcb8fdb62fdc97dec84905e0f4182c3"
SRC_URI[archive17.sha256sum] = "debd49edc862972c5dfa0a990a388e67cc669971738a70f5151d93f84a4b34dd"

SRC_URI[archive18.md5sum] = "347c9ee3ffb0e8ad95b71f7b435bca30"
SRC_URI[archive18.sha256sum] = "d46d04cfc454357247ed1855f346c5c7e402d5b2f98e4f6e1375f9293c2092e9"

SRC_URI[archive19.md5sum] = "1df9dc31218512222c95c55fecfff46f"
SRC_URI[archive19.sha256sum] = "3cc5476d4bae51ad558cab0caa40b707548f2b5a1e20e4f81908ec50cffe199c"

# murata-master -- BEGIN
SRC_URI[archive24.md5sum] = "8f5ff13473d46769b1a5158edd25e570"
SRC_URI[archive24.sha256sum] = "fa0d7ade09034776ac80b42410230f91cc4a01be4e04dfcc5498d68012389498"

SRC_URI[archive25.md5sum] = "3baf1bb04581b46ed861919b6ee80176"
SRC_URI[archive25.sha256sum] = "98acd589e3a9022363a4ade1df293c15a48ec4a5f13acab795a3ff36a5d28f35"

SRC_URI[archive26.md5sum] = "a77318277df2a4dab8dab6b7caa2b275"
SRC_URI[archive26.sha256sum] = "ef76dd0038f1944430d2c870de8877cc58415b5268422a4e9c343aed0122c2a4"

SRC_URI[archive27.md5sum] = "abeae5a9d70824a11724dddd8984a35c"
SRC_URI[archive27.sha256sum] = "8d1d5bdc164d891ab5c4382c36c38ff634f1230e7f167c17aa1907deb16dce73"

SRC_URI[archive28.md5sum] = "bcd3a921750dfe9f403ef96fdeac6b84"
SRC_URI[archive28.sha256sum] = "cbef1c5f4945d11bd72f2dafaea2e227193dd6ee31e456f455b671610d80284a"

SRC_URI[archive29.md5sum] = "680f28b5bb6cc75cdba3a8d96151924d"
SRC_URI[archive29.sha256sum] = "6bc800e44a73bc8e809ca0fd35b05227e437bdc5439fa5083a307abe3ae0f810"

SRC_URI[archive30.md5sum] = "680f28b5bb6cc75cdba3a8d96151924d"
SRC_URI[archive30.sha256sum] = "6bc800e44a73bc8e809ca0fd35b05227e437bdc5439fa5083a307abe3ae0f810"

SRC_URI[archive31.md5sum] = "a94d36a14e427b05aee1b90da1a38e16"
SRC_URI[archive31.sha256sum] = "8c707a240a0417e55117bac50ce3c4abf553859ea95c8cefa9c795d7b2184cd0"

SRC_URI[archive32.md5sum] = "02998f5b252734af60a04a6a3d341119"
SRC_URI[archive32.sha256sum] = "6a7179863cc1a1b78fa7a3553dc70c0061cf4db913564d38b44b92a5a29432e4"

SRC_URI[archive33.md5sum] = "2e5f51198b7df0e9e03bcd548fde5139"
SRC_URI[archive33.sha256sum] = "daf7859c9469d88180e42b2ee79bd6f5b4801ee515f78a801f5686fc818ad69b"

SRC_URI[archive34.md5sum] = "fdcb8fdb62fdc97dec84905e0f4182c3"
SRC_URI[archive34.sha256sum] = "debd49edc862972c5dfa0a990a388e67cc669971738a70f5151d93f84a4b34dd"

SRC_URI[archive35.md5sum] = "1df9dc31218512222c95c55fecfff46f"
SRC_URI[archive35.sha256sum] = "3cc5476d4bae51ad558cab0caa40b707548f2b5a1e20e4f81908ec50cffe199c"
# murata-master -- END

#Default hcd files
SRC_URI[archive36.md5sum] = "c29b894df41e1ed41f1e77d9e44f1aa0"
SRC_URI[archive36.sha256sum] = "2b0aaea00ff44a904ec819029047c52533a474d185279c720ab7001643f78db1"
SRC_URI[archive37.md5sum] = "ea188bde0d4e2c46560dd2158ee1e45b"
SRC_URI[archive37.sha256sum] = "467951cc33dc5b8a2bc4e0cc5ab43d6c625fac26fa22509bf7a810d2a968067e"
SRC_URI[archive38.md5sum] = "909aaf2c23467255852b37bf701bdb70"
SRC_URI[archive38.sha256sum] = "376d300c99fd07d2843b0db4b602695e712e48113b992cd02ac974b8aecffdd6"
SRC_URI[archive39.md5sum] = "54d140ac2503c5d34631cb30c4c3657e"
SRC_URI[archive39.sha256sum] = "f6bdc7112d486542075274c39377bbba876788119947365e8ae5f929c37f349e"
SRC_URI[archive40.md5sum] = "00b4a75a3bc247f96eb07f12b28dd061"
SRC_URI[archive40.sha256sum] = "968948b89bf28da4d7b8b85327021779ef5d0919434d219296d42510498f6e3e"
SRC_URI[archive41.md5sum] = "e0a0362499a37905ae4b471ee15df8a8"
SRC_URI[archive41.sha256sum] = "fc2f1db717004970d5489840f170490745778df3959b33bb5ae0c5f1b2f9688c"
SRC_URI[archive42.md5sum] = "d6a60d308d5ac8277c704d11149dc1c2"
SRC_URI[archive42.sha256sum] = "69430eb0915584bfa8c2e34370ac136f928e621dcf504f024730b9f4094520fa"


#murata-master for hcd files
#SRC_URI[archive43.md5sum] = "ea188bde0d4e2c46560dd2158ee1e45b"
#SRC_URI[archive43.sha256sum] = "467951cc33dc5b8a2bc4e0cc5ab43d6c625fac26fa22509bf7a810d2a968067e"
#SRC_URI[archive44.md5sum] = "909aaf2c23467255852b37bf701bdb70"
#SRC_URI[archive44.sha256sum] = "376d300c99fd07d2843b0db4b602695e712e48113b992cd02ac974b8aecffdd6"
#SRC_URI[archive45.md5sum] = "54d140ac2503c5d34631cb30c4c3657e"
#SRC_URI[archive45.sha256sum] = "f6bdc7112d486542075274c39377bbba876788119947365e8ae5f929c37f349e"
#SRC_URI[archive46.md5sum] = "00b4a75a3bc247f96eb07f12b28dd061"
#SRC_URI[archive46.sha256sum] = "968948b89bf28da4d7b8b85327021779ef5d0919434d219296d42510498f6e3e"
SRC_URI[archive47.md5sum] = "5484bcea05ce0e5d3a9f59729a55361f"
SRC_URI[archive47.sha256sum] = "de519797eb6ea5803fa1057d42c7a99aa248fb9f9a4d7f003e2ce0e1a679d7e8"
SRC_URI[archive48.md5sum] = "35976ab973cdece456c0727c2e4b324a"
SRC_URI[archive48.sha256sum] = "402051c47605d038dd408532963d7b8cfc3a5341824de382914175aca0b70626"

# wl 32-bit
SRC_URI[archive49.md5sum] = "dd77547875b660408c61ab145fbc0997"
SRC_URI[archive49.sha256sum] = "5250aa02ebe852bd25998b00670b4fbb164695cafb2f24f620bda322ee3e2c25"

#SRC_URI[archive50.md5sum] = "ca7a386965df8d424fda8cfd38d77a74"
#SRC_URI[archive50.sha256sum] = "937c6b6916d956525742df44f00ec87e1cea027740c955076fb30d0838512367"

#LICENSE
SRC_URI[archive99.md5sum] = "b234ee4d69f5fce4486a80fdaf4a4263"
SRC_URI[archive99.sha256sum] = "8177f97513213526df2cf6184d8ff986c675afb514d4e68a404010521b880643"

#README_NVRAM
SRC_URI[archive100.md5sum] = "3886cfa8976ba29c5d5bd1bc507fbefc"
SRC_URI[archive100.sha256sum] = "2a79807f73f5689f38d06de1f0bd5ff3b115e4fe8ce84a7cca06a1e1d24b6855"


S = "${WORKDIR}/murata-binaries-${PV}"
B = "${WORKDIR}/murata-binaries-${PV}/"


do_compile () {
	echo "Compiling: "
        echo "Testing Make        Display:: ${MAKE}"
        echo "Testing bindir      Display:: ${bindir}"
        echo "Testing base_libdir Display:: ${base_libdir}"
        echo "Testing sysconfdir  Display:: ${sysconfdir}"
        echo "Testing S  Display:: ${S}"
        echo "Testing B  Display:: ${B}"
        echo "Testing D  Display:: ${D}"
        echo "WORK_DIR :: ${WORKDIR}"
        echo "PWD :: "
        pwd
}

PACKAGES_prepend = "murata-binaries-wlarm "
FILES_murata-binaries-wlarm = "${bindir}/wlarm"


do_install () {
	echo "Installing: "

	# Install NVRAM Files 
        install -d ${D}/lib/firmware/brcm
        install -m 444 ${WORKDIR}/brcmfmac43012-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43012-sdio.clm_blob ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43012-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43340-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43340-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43362-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43362-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4339-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4339-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43430-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43430-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43455-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43455-sdio.clm_blob ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac43455-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4354-sdio.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4354-sdio.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4356-pcie.bin ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/brcmfmac4356-pcie.txt ${D}/lib/firmware/brcm
	install -m 444 ${WORKDIR}/README_NVRAM ${D}/lib/firmware/brcm
        
        install -d ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43012-sdio.1LV.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43340-sdio.1BW.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43362-sdio.SN8000.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac4339-sdio.1CK.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac4339-sdio.ZP.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43430-sdio.1DX.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43430-sdio.1LN.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43455-sdio.1HK.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43455-sdio.1LC.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac43455-sdio.1MW.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac4354-sdio.1BB.txt ${D}/lib/firmware/brcm/murata-master
        install -m 444 ${WORKDIR}/brcmfmac4356-pcie.1CX.txt ${D}/lib/firmware/brcm/murata-master


        install -d ${D}${sysconfdir}/firmware
        install -m 444 ${WORKDIR}/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/BCM4335C0.ZP.hcd
        install -m 444 ${WORKDIR}/CYW4345C0.1MW.hcd ${D}${sysconfdir}/firmware/BCM4345C0.1MW.hcd
        install -m 444 ${WORKDIR}/CYW43012C0.1LV.hcd ${D}${sysconfdir}/firmware/BCM43012C0.1LV.hcd
        install -m 444 ${WORKDIR}/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/BCM43341B0.1BW.hcd
        install -m 444 ${WORKDIR}/CYW43430A1.1DX.hcd ${D}${sysconfdir}/firmware/BCM43430A1.1DX.hcd
        install -m 444 ${WORKDIR}/README_BT_PATCHFILES ${D}${sysconfdir}/firmware


        install -d ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${WORKDIR}/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/murata-master/BCM4335C0.ZP.hcd
        install -m 444 ${WORKDIR}/CYW4345C0.1MW.hcd ${D}${sysconfdir}/firmware/murata-master/BCM4345C0.1MW.hcd
        install -m 444 ${WORKDIR}/CYW43012C0.1LV.hcd ${D}${sysconfdir}/firmware/murata-master/BCM43012C0.1LV.hcd
        install -m 444 ${WORKDIR}/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/murata-master/BCM43341B0.1BW.hcd
        install -m 444 ${WORKDIR}/CYW43430A1.1DX.hcd ${D}${sysconfdir}/firmware/murata-master/BCM43430A1.1DX.hcd
        install -m 444 ${WORKDIR}/CYW4350C0.1BB.hcd  ${D}${sysconfdir}/firmware/murata-master/BCM4350C0.1BB.hcd

        install -m 444 ${WORKDIR}/README_BT_PATCHFILES ${D}${sysconfdir}/firmware/murata-master

#        install -m 444 ${WORKDIR}/CYW4335C0.ZP.hcd ${D}${sysconfdir}/firmware/murata-master
#        install -m 444 ${WORKDIR}/CYW4345C0.1MW.hcd ${D}${sysconfdir}/firmware/murata-master
#        install -m 444 ${WORKDIR}/CYW43012C0.1LV.hcd ${D}${sysconfdir}/firmware/murata-master
#        install -m 444 ${WORKDIR}/CYW43341B0.1BW.hcd ${D}${sysconfdir}/firmware/murata-master
#        install -m 444 ${WORKDIR}/CYW43430A1.1DX.hcd ${D}${sysconfdir}/firmware/murata-master

        install -m 444 ${WORKDIR}/CYW43430A1.1DX.1dB_Less.hcd ${D}${sysconfdir}/firmware/murata-master
        install -m 444 ${WORKDIR}/CYW43430A1.1DX.2dB_Less.hcd ${D}${sysconfdir}/firmware/murata-master

        install -d ${D}${sbindir}
        install -m 755 ${WORKDIR}/wl ${D}${sbindir}/wl

}

PACKAGES =+ "${PN}-mfgtest"

FILES_${PN} += "/lib/firmware"
FILES_${PN} += "/lib/firmware/*"
FILES_${PN} += "${bindir}"
FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/lib"


FILES_${PN}-mfgtest = " \
	/usr/bin/wl \
"


