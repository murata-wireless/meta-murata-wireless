do_install:append() {
	# Prune firmware that is not used by the Murata images.
	rm -rf ${D}${nonarch_base_libdir}/firmware/brcm
	rm -rf ${D}${nonarch_base_libdir}/firmware/liquidio
	rm -rf ${D}${nonarch_base_libdir}/firmware/matrox
	rm -rf ${D}${nonarch_base_libdir}/firmware/mediatek
	rm -rf ${D}${nonarch_base_libdir}/firmware/mellanox
	rm -rf ${D}${nonarch_base_libdir}/firmware/meson
	rm -rf ${D}${nonarch_base_libdir}/firmware/microchip
	rm -rf ${D}${nonarch_base_libdir}/firmware/moxa
	rm -rf ${D}${nonarch_base_libdir}/firmware/mrvl
	rm -rf ${D}${nonarch_base_libdir}/firmware/vicam
	rm -rf ${D}${nonarch_base_libdir}/firmware/vxge
	rm -rf ${D}${nonarch_base_libdir}/firmware/wfx
	rm -rf ${D}${nonarch_base_libdir}/firmware/yam
	rm -rf ${D}${nonarch_base_libdir}/firmware/yamaha
	rm -rf ${D}${nonarch_base_libdir}/firmware/iwlwifi*
	rm -rf ${D}${nonarch_base_libdir}/firmware/LICENCE*
	rm -rf ${D}${nonarch_base_libdir}/firmware/acenic
	rm -rf ${D}${nonarch_base_libdir}/firmware/adaptec
	rm -rf ${D}${nonarch_base_libdir}/firmware/agere_ap_fw.bin
	rm -rf ${D}${nonarch_base_libdir}/firmware/agere_sta_fw.bin
	rm -rf ${D}${nonarch_base_libdir}/firmware/amd
	rm -rf ${D}${nonarch_base_libdir}/firmware/amdtee
	rm -rf ${D}${nonarch_base_libdir}/firmware/amd-ucode
	rm -rf ${D}${nonarch_base_libdir}/firmware/amlogic
	rm -rf ${D}${nonarch_base_libdir}/firmware/3com
	rm -rf ${D}${nonarch_base_libdir}/firmware/a300_pfp.fw
	rm -rf ${D}${nonarch_base_libdir}/firmware/a300_pm4.fw
	rm -rf ${D}${nonarch_base_libdir}/firmware/advansys
	rm -rf ${D}${nonarch_base_libdir}/firmware/airoha
	rm -rf ${D}${nonarch_base_libdir}/firmware/amdgpu
	rm -rf ${D}${nonarch_base_libdir}/firmware/amphion
	rm -rf ${D}${nonarch_base_libdir}/firmware/ar3k
	rm -rf ${D}${nonarch_base_libdir}/firmware/ar5523.bin
	rm -rf ${D}${nonarch_base_libdir}/firmware/arm
	rm -rf ${D}${nonarch_base_libdir}/firmware/as*.hex
	rm -rf ${D}${nonarch_base_libdir}/firmware/ath*
	rm -rf ${D}${nonarch_base_libdir}/firmware/at*
	rm -rf ${D}${nonarch_base_libdir}/firmware/av7110
	rm -rf ${D}${nonarch_base_libdir}/firmware/bnx2
	rm -rf ${D}${nonarch_base_libdir}/firmware/bnx2x
	rm -rf ${D}${nonarch_base_libdir}/firmware/cadence
	rm -rf ${D}${nonarch_base_libdir}/firmware/cavium
	rm -rf ${D}${nonarch_base_libdir}/firmware/cirrus
	rm -rf ${D}${nonarch_base_libdir}/firmware/cis
	rm -rf ${D}${nonarch_base_libdir}/firmware/cnm
	rm -rf ${D}${nonarch_base_libdir}/firmware/cpia2
	rm -rf ${D}${nonarch_base_libdir}/firmware/cxgb3
	rm -rf ${D}${nonarch_base_libdir}/firmware/cxgb4
	rm -rf ${D}${nonarch_base_libdir}/firmware/dabusb
	rm -rf ${D}${nonarch_base_libdir}/firmware/dpaa2
	rm -rf ${D}${nonarch_base_libdir}/firmware/dsp56k
	rm -rf ${D}${nonarch_base_libdir}/firmware/e100
	rm -rf ${D}${nonarch_base_libdir}/firmware/edgeport
	rm -rf ${D}${nonarch_base_libdir}/firmware/emi26
	rm -rf ${D}${nonarch_base_libdir}/firmware/emi62
	rm -rf ${D}${nonarch_base_libdir}/firmware/ene-ub6250
	rm -rf ${D}${nonarch_base_libdir}/firmware/ess
	rm -rf ${D}${nonarch_base_libdir}/firmware/go7007
	rm -rf ${D}${nonarch_base_libdir}/firmware/i915
	rm -rf ${D}${nonarch_base_libdir}/firmware/inside-secure
	rm -rf ${D}${nonarch_base_libdir}/firmware/intel
	rm -rf ${D}${nonarch_base_libdir}/firmware/isci
	rm -rf ${D}${nonarch_base_libdir}/firmware/ixp4xx
	rm -rf ${D}${nonarch_base_libdir}/firmware/kaweth
	rm -rf ${D}${nonarch_base_libdir}/firmware/keyspan
	rm -rf ${D}${nonarch_base_libdir}/firmware/keyspan_pda
	rm -rf ${D}${nonarch_base_libdir}/firmware/korg
	rm -rf ${D}${nonarch_base_libdir}/firmware/mwl8k
	rm -rf ${D}${nonarch_base_libdir}/firmware/mwlwifi
	rm -rf ${D}${nonarch_base_libdir}/firmware/netronome
	rm -rf ${D}${nonarch_base_libdir}/firmware/nvidia
	rm -rf ${D}${nonarch_base_libdir}/firmware/qlogic
	rm -rf ${D}${nonarch_base_libdir}/firmware/powervr
	rm -rf ${D}${nonarch_base_libdir}/firmware/r128
	rm -rf ${D}${nonarch_base_libdir}/firmware/radeon
	rm -rf ${D}${nonarch_base_libdir}/firmware/rsi
	#rm -rf ${D}${nonarch_base_libdir}/firmware/RTL8192E
	rm -rf ${D}${nonarch_base_libdir}/firmware/rtl_bt
	rm -rf ${D}${nonarch_base_libdir}/firmware/rtl_nic
	rm -rf ${D}${nonarch_base_libdir}/firmware/rtlwifi
	rm -rf ${D}${nonarch_base_libdir}/firmware/rtw88
	rm -rf ${D}${nonarch_base_libdir}/firmware/rtw89
	rm -rf ${D}${nonarch_base_libdir}/firmware/sb16
	rm -rf ${D}${nonarch_base_libdir}/firmware/*.fw
	rm -rf ${D}${nonarch_base_libdir}/firmware/*.bin
	rm -rf ${D}${nonarch_base_libdir}/firmware/*.dat
	rm -rf ${D}${nonarch_base_libdir}/firmware/*.dlmem
	rm -rf ${D}${nonarch_base_libdir}/firmware/*.inp
	rm -rf ${D}${nonarch_base_libdir}/firmware/myricom
	rm -rf ${D}${nonarch_base_libdir}/firmware/ositech
	rm -rf ${D}${nonarch_base_libdir}/firmware/qca
	rm -rf ${D}${nonarch_base_libdir}/firmware/qcom
	rm -rf ${D}${nonarch_base_libdir}/firmware/qed
	rm -rf ${D}${nonarch_base_libdir}/firmware/rockchip
	rm -rf ${D}${nonarch_base_libdir}/firmware/slicoss
	rm -rf ${D}${nonarch_base_libdir}/firmware/sun
	rm -rf ${D}${nonarch_base_libdir}/firmware/sxg
	rm -rf ${D}${nonarch_base_libdir}/firmware/tehuti
	rm -rf ${D}${nonarch_base_libdir}/firmware/ti
	rm -rf ${D}${nonarch_base_libdir}/firmware/ti-connectivity
	rm -rf ${D}${nonarch_base_libdir}/firmware/tigon
	rm -rf ${D}${nonarch_base_libdir}/firmware/ti-keystone
	rm -rf ${D}${nonarch_base_libdir}/firmware/ttusb-budget
	rm -rf ${D}${nonarch_base_libdir}/firmware/ueagle-atm
	rm -rf ${D}${nonarch_base_libdir}/firmware/libertas
	rm -rf ${D}${nonarch_base_libdir}/firmware/xe
}

#  FILES_${PN} += "${nonarch_base_libdir}/firmware/brcm"
#  FILES_${PN} += "${nonarch_base_libdir}/firmware/brcm/murata_NVRAM"

#  FILES_${PN} += "${nonarch_base_libdir}firmware"
#  FILES_${PN} += "${nonarch_base_libdir}firmware/*"
#  #FILES_${PN} += "${bindir}"
#  #FILES_${PN} += "${sbindir}"
#  FILES_${PN} += "${sysconfdir}/firmware"
#  FILES_${PN} += "/lib"
#  #FILES_${PN} += "/etc/firmware"
