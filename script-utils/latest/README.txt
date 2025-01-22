Title: README.txt
Date:  December 19th, 2024

Description: 
============
"meta-murata-wireless" is a customized Yocto layer which enables wireless support for Murata modules in the Yocto build. 
For more details contact Murata support at "community.murata.com" or for i.MX processors visit our i.MX landing page at
"https://www.murata.com/products/connectivitymodule/wi-fi-bluetooth/overview/nxp-imx". 

Build Procedure: 
================
Currently only Ubuntu 12.04, 14.04, 16.04, 18.04, 20.04 and 22.04 (64-bit) distros are supported. Please install one of
these versions on your host machine/environment before invoking the "Host_Setup_for_Yocto.sh" script. Once the host 
environment is verified/configured, then you can run the "Murata_Wireless_Yocto_Build_xxx.sh" script to generate the 
desired Yocto Linux image.

Folder Contents: 
================
Host_Setup_for_Yocto.sh:
---------------------------------------------- 
Script which first verifies then initializes Linux environment for building Murata-customized Yocto image.
Open a terminal and run the command: 
$./Host_Setup_for_Yocto.sh

Murata_Wireless_Yocto_Build_IFX.sh:
-----------------------------------
Script which prompts the user for target hardware/CPU, additional hardware configuration, desired "meta-murata-wireless"
branch or tag release. It then error checks the input before kicking off Murata-customized Yocto build. The last command
invoked is "bitbake" to generate the final/desired SD card image. 
NOTE: the final "bitbake" command will take hours to complete. 
Open a terminal in desired i.MX Yocto build folder, and run the command: 

$./Murata_Wireless_Yocto_Build_IFX.sh

--------------------------------------------------------------------------------------
| Kernel release | Yocto code name  |  FMAC code name |  Release information         |
|----------------|------------------|-----------------|------------------------------|
| 6.6.23_2.0.0   | Scarthgap        |  Jaculus        |  imx-scarthgap-jaculus_r1.0  |
|----------------|------------------|-----------------|------------------------------|
| 6.6.3_1.0.0    | Nanbield         |  Indrik         |  imx-nanbield-indrik_r1.0    |
|----------------|------------------|-----------------|------------------------------|
| 6.1.36_2.1.0   | Mickeldore       |  Godzilla       |  imx-mickledore-godzilla_r1.0|
|                |                  |  Hedorah        |  imx-mickledore-hedorah_r1.0 |
|                |                  |  Indrik         |  imx-mickledore-indrik_r1.0  |
|                |                  |  Jaculus        |  imx-mickledore-jaculus_r1.0 |
|----------------|------------------|-----------------|------------------------------|
| 6.1.1_1.0.0    | Langdale         |  Fafnir         |  imx-langdale-fafnir_r1.0    |
|                |                  |  Godzilla       |  imx-langdale-godzilla_r1.0  |
|----------------|------------------|-----------------|------------------------------|
| 5.15.32_2.0.0  | Kirkstone        |  Ebirah         |  imx-kirkstone-ebirah_r1.0   |
|                |                  |  Fafnir         |  imx-kirkstone-fafnir_r1.0   |
|                |                  |  Godzilla       |  imx-kirkstone-godzilla_r1.0 |
|                |                  |  Indrik         |  imx-kirkstone-indrik_r1.0   |
|                |                  |  Jaculus        |  imx-kirkstone-jaculus_r1.0  |
--------------------------------------------------------------------------------------

Murata_Wireless_Yocto_Build_NXP.sh:
-----------------------------------
Script which prompts the user for target hardware/CPU, additional hardware configuration, desired "meta-murata-wireless"
branch or tag release. It then error checks the input before kicking off Murata-customized Yocto build. The last command
invoked is "bitbake" to generate the final/desired SD card image. 
NOTE: the final "bitbake" command will take hours to complete. 
Open a terminal in desired i.MX Yocto build folder, and run the command: 

$./Murata_Wireless_Yocto_Build_NXP.sh

--------------------------------------------------------------------
| Kernel release | Yocto code name  |  Release information         |
|----------------|------------------|------------------------------|
| 5.10.52_2.1.0  | Hardknott        |  imx-hardknott-5-10-52_r1.0  |
|----------------|------------------|------------------------------|
| 5.10.72_2.2.0  | Hardknott        |  imx-hardknott-5-10-72_r1.0  |
--------------------------------------------------------------------
| 5.15.32_2.0.0  | Kirkstone        |  imx-kirkstone-5-15-32_r1.0  |
--------------------------------------------------------------------
| 6.1.1_1.0.0    | Langdale         |  imx-langdale-6-1-1_r1.0     |
--------------------------------------------------------------------
| 6.1.36_2.1.0   | Mickledore       |  imx-mickledore-6-1-36_r1.0  |
--------------------------------------------------------------------
| 6.6.3_1.0.0    | Nanbield         |  imx-nanbield-6-6-3_r1.0     |
--------------------------------------------------------------------



