do_install:append() {
	# Remove pointless bash script
	rm -r ${D}/${base_libdir}/firmware/brcm
	rm -r ${D}/${base_libdir}/firmware/liquidio
	rm -r ${D}/${base_libdir}/firmware/matrox
	rm -r ${D}/${base_libdir}/firmware/mediatek
	rm -r ${D}/${base_libdir}/firmware/mellanox
	rm -r ${D}/${base_libdir}/firmware/meson
	rm -r ${D}/${base_libdir}/firmware/microchip
	rm -r ${D}/${base_libdir}/firmware/moxa
	rm -r ${D}/${base_libdir}/firmware/mrvl
	rm -r ${D}/${base_libdir}/firmware/vicam
	rm -r ${D}/${base_libdir}/firmware/vxge
	rm -r ${D}/${base_libdir}/firmware/wfx
	rm -r ${D}/${base_libdir}/firmware/yam
	rm -r ${D}/${base_libdir}/firmware/yamaha
	rm -r ${D}/${base_libdir}/firmware/iwlwifi*
	rm -r ${D}/${base_libdir}/firmware/LICENCE*
	rm -r ${D}/${base_libdir}/firmware/acenic
	rm -r ${D}/${base_libdir}/firmware/adaptec
	rm -r ${D}/${base_libdir}/firmware/agere_ap_fw.bin
	rm -r ${D}/${base_libdir}/firmware/agere_sta_fw.bin
	rm -r ${D}/${base_libdir}/firmware/amd
	rm -r ${D}/${base_libdir}/firmware/amd-ucode
	rm -r ${D}/${base_libdir}/firmware/3com
	rm -r ${D}/${base_libdir}/firmware/a300_pfp.fw
	rm -r ${D}/${base_libdir}/firmware/a300_pm4.fw
	rm -r ${D}/${base_libdir}/firmware/advansys
	rm -r ${D}/${base_libdir}/firmware/amdgpu
	rm -r ${D}/${base_libdir}/firmware/amphion
	rm -r ${D}/${base_libdir}/firmware/ar5523.bin
	rm -r ${D}/${base_libdir}/firmware/as*.hex
	rm -r ${D}/${base_libdir}/firmware/ath*
	rm -r ${D}/${base_libdir}/firmware/at*
	rm -r ${D}/${base_libdir}/firmware/av7110
	rm -r ${D}/${base_libdir}/firmware/bnx2
	rm -r ${D}/${base_libdir}/firmware/bnx2x
	rm -r ${D}/${base_libdir}/firmware/cadence
	rm -r ${D}/${base_libdir}/firmware/cavium
	rm -r ${D}/${base_libdir}/firmware/cirrus
	rm -r ${D}/${base_libdir}/firmware/cis
	rm -r ${D}/${base_libdir}/firmware/cnm
	rm -r ${D}/${base_libdir}/firmware/cpia2
	rm -r ${D}/${base_libdir}/firmware/cxgb3
	rm -r ${D}/${base_libdir}/firmware/cxgb4
	rm -r ${D}/${base_libdir}/firmware/dabusb
	rm -r ${D}/${base_libdir}/firmware/dpaa2
	rm -r ${D}/${base_libdir}/firmware/dsp56k
	rm -r ${D}/${base_libdir}/firmware/e100
	rm -r ${D}/${base_libdir}/firmware/edgeport
	rm -r ${D}/${base_libdir}/firmware/emi26
	rm -r ${D}/${base_libdir}/firmware/emi62
	rm -r ${D}/${base_libdir}/firmware/ene-ub6250
	rm -r ${D}/${base_libdir}/firmware/ess
	rm -r ${D}/${base_libdir}/firmware/go7007
	rm -r ${D}/${base_libdir}/firmware/i915
	rm -r ${D}/${base_libdir}/firmware/inside-secure
	rm -r ${D}/${base_libdir}/firmware/intel
	rm -r ${D}/${base_libdir}/firmware/isci
	rm -r ${D}/${base_libdir}/firmware/kaweth
	rm -r ${D}/${base_libdir}/firmware/keyspan
	rm -r ${D}/${base_libdir}/firmware/keyspan_pda
	rm -r ${D}/${base_libdir}/firmware/korg
	rm -r ${D}/${base_libdir}/firmware/mwl8k
	rm -r ${D}/${base_libdir}/firmware/mwlwifi
	rm -r ${D}/${base_libdir}/firmware/qlogic
	rm -r ${D}/${base_libdir}/firmware/r128
	rm -r ${D}/${base_libdir}/firmware/radeon
	rm -r ${D}/${base_libdir}/firmware/rsi
	rm -r ${D}/${base_libdir}/firmware/RTL8192E
	rm -r ${D}/${base_libdir}/firmware/rtl_bt
	rm -r ${D}/${base_libdir}/firmware/rtl_nic
	rm -r ${D}/${base_libdir}/firmware/rtlwifi
	rm -r ${D}/${base_libdir}/firmware/rtw88
	rm -r ${D}/${base_libdir}/firmware/rtw89
	rm -r ${D}/${base_libdir}/firmware/sb16
	rm -r ${D}/${base_libdir}/firmware/*.fw
	rm -r ${D}/${base_libdir}/firmware/*.bin
	rm -r ${D}/${base_libdir}/firmware/*.dat
	rm -r ${D}/${base_libdir}/firmware/*.dlmem
	rm -r ${D}/${base_libdir}/firmware/*.inp
	rm -r ${D}/${base_libdir}/firmware/myricom
	rm -r ${D}/${base_libdir}/firmware/ositech
	rm -r ${D}/${base_libdir}/firmware/qca
	rm -r ${D}/${base_libdir}/firmware/qcom
	rm -r ${D}/${base_libdir}/firmware/qed
	rm -r ${D}/${base_libdir}/firmware/rockchip
	rm -r ${D}/${base_libdir}/firmware/slicoss
	rm -r ${D}/${base_libdir}/firmware/sun
	rm -r ${D}/${base_libdir}/firmware/sxg
	rm -r ${D}/${base_libdir}/firmware/tehuti
	rm -r ${D}/${base_libdir}/firmware/ti
	rm -r ${D}/${base_libdir}/firmware/ti-connectivity
	rm -r ${D}/${base_libdir}/firmware/tigon
	rm -r ${D}/${base_libdir}/firmware/ti-keystone
	rm -r ${D}/${base_libdir}/firmware/ttusb-budget
	rm -r ${D}/${base_libdir}/firmware/ueagle-atm
	rm -r ${D}/${base_libdir}/firmware/libertas
}

FILES_${PN} += "/${base_libdir}/firmware/brcm"
FILES_${PN} += "/${base_libdir}/firmware/brcm/murata_NVRAM"

FILES_${PN} += "/${base_libdir}/firmware"
FILES_${PN} += "/${base_libdir}/firmware/*"
#FILES_${PN} += "${bindir}"
#FILES_${PN} += "${sbindir}"
FILES_${PN} += "{sysconfdir}/firmware"
FILES_${PN} += "/${base_libdir}"
#FILES_${PN} += "/etc/firmware"



