# Medusa kernel integration

## Vendor input

`recipes-kernel/linux/linux-imx/0006-infineon-fmac-6.18.20.patch`
is imported byte-for-byte from the supplied combined Infineon patch, including
its MMC changes. No individual vendor patches need to be added to SRC_URI.

SHA-256: `caaad47f1269381819cf9c4e151ae64cac92cacec65068f9d40dc0abab63e83a`

The path-specific `.gitattributes` rule disables line-ending conversion for this
file, preserving the supplied bytes on Windows as well as Linux.

## Active layer changes

- Replace the Longma patch with the combined Medusa patch in `linux-imx_%.bbappend`.
- Change the Murata driver identification string to `imx-wrynose-medusa`, without
  assigning an unconfirmed release number.
- Rebase the Murata defconfig patch onto the NXP 6.18.20 defconfig; retain its
  existing Wi-Fi, Bluetooth, MMC and shared-SDIO configuration choices.
- Rebase the DTS patch while preserving all eight custom i.MX8MM/i.MX8MN DTS files
  and their Makefile entries. Preserve new NXP baseline DTB entries.
- Apply the i.MX8MP 2FY power-sequence delays to `imx8mp-evk.dts`, where the
  `usdhc1_pwrseq` node now resides; the old `imx8mp-evk-usdhc1-m2.dts` is absent.
  Retain the i.MX8ULP and i.MX93 delay changes, rebasing i.MX93 context.
- Remove the redundant `0004-wifi-brcmfmac-add-missing-header-include-for-brcmf_d.patch`
  from the active series: the Medusa source already includes `debug.h`.
- Retain the UART DMA workaround, CYW4373 Bluetooth patch and SoftAP fix.

Legacy patch files and inactive `.6ULL`/`.8MQ` bbappend templates are retained;
those templates are not migrated or validated by this integration and still
reference Longma. Do not use them as Medusa templates without a separate rebase.
Firmware/NVRAM references, build scripts and README files are unchanged.

## Validation (2026-09-02)

Baseline: NXP tag `lf-6.18.20-2.0.0`, commit
`b096ce610e956cc2596006343df8a2a26ed6e019`.

Extracted pristine target source directories from that commit with Git
line-ending conversion disabled. Ran `git apply --check` followed by
`git apply --whitespace=nowarn` for each patch in the following order:

1. `0006-infineon-fmac-6.18.20.patch`
2. `0002-murata-customized-string.patch`
3. `0003-defconfig-imx8.patch`
4. `0004-murata-dts-imx8.patch`
5. `0006-disable-dma-hciuart-kernel-crash.patch`
6. `0008-Patch-for-CYW4373-hci-up-fail-issue.patch`
7. `0009-SoftAP-Kernel-Dump-Fix.patch`

All seven checks and applications passed sequentially, without reject files.
This validates textual applicability, not compilation or runtime behavior.
No BitBake build, Kconfig resolution, DTB compilation or hardware test was run.

On the Linux Yocto build host, next run `bitbake -c patch -f virtual/kernel`,
then build `virtual/kernel` and the target image. Check the resolved kernel
configuration, custom DTBs and Wi-Fi/Bluetooth operation on target hardware,
including shared SDIO, suspend/resume and the included MMC changes.
