Title: README.txt
Date:  October 11th, 2023

Description: 
============
"meta-murata-wireless" is a customized Yocto layer which enables wireless support for Murata modules in the Yocto build. 
For more details email Murata support at "wirelessFAQ@murata.com" or for i.MX processors visit our i.MX landing page at
"https://wireless.murata.com/imx". 

Build Procedure: 
================
Currently only Ubuntu 12.04, 14.04, 16.04, 18.04, 20.04 and 22.04 (64-bit) distros are supported. Please install one of
these versions on your host machine/environment before invoking the "Host_Setup_for_Yocto.sh" script. Once the host 
environment is verified/configured, then you can run the "Murata_Wireless_Yocto_Build_CYW.sh" script to generate the 
desired Yocto Linux image.

Folder Contents: 
================
Host_Setup_for_Yocto.sh:
---------------------------------------------- 
Script which first verifies then initializes Linux environment for building Murata-customized Yocto image.
The script also prompts to install the necessary tool chain for TI Sitara platforms.
Open a terminal and run the command: 
$./Host_Setup_for_Yocto.sh

Murata_Wireless_Yocto_Build_CYW.sh:
-----------------------------------
Script which prompts the user for target hardware/CPU, additional hardware configuration, desired "meta-murata-wireless"
branch or tag release. It then error checks the input before kicking off Murata-customized Yocto build. The last command
invoked is "bitbake" to generate the final/desired SD card image. 
NOTE: the final "bitbake" command will take hours to complete. 
Open a terminal in desired i.MX Yocto build folder, and run the command: 

$./Murata_Wireless_Yocto_Build_CYW.sh

--------------------------------------------------------------------------------------
| Kernel release | Yocto code name  |  FMAC code name |  Release information         |
|----------------|------------------|-----------------|------------------------------|
| 5.15.32_2.0.0  | Kirkstone        |  Ebirah         |  imx-kirkstone-ebirah_r1.0   |
|                |                  |  Fafnir         |  imx-kirkstone-fafnir_r1.0   |
|----------------|------------------|-----------------|------------------------------|
| 5.10.52_2.1.0  | Hardknott        |  Drogon         |  imx-hardknott-drogon_r1.0   |
|                |                  |  Cynder         |  imx-hardknott-cynder_r1.0   |
|----------------|------------------|-----------------|------------------------------|
| 5.4.47_2.2.0   | Zeus             |  Baragon        |  imx-zeus-baragon_r1.0       |
|                |                  |  Spiga          |  imx-zeus-spiga_r1.0         |
|----------------|------------------|-----------------|------------------------------|
| 4.14.98_2.3.0  | Sumo             |  Baragon        |  imx-sumo-baragon_r1.0       |
|                |                  |  Spiga          |  imx-sumo-spiga_r1.0         |
|----------------|------------------|-----------------|------------------------------|
| 4.9.123_2.3.0  | Rocko Mini       |  Baragon        |  imx-rocko-mini-baragon_r1.0 |
|                |                  |  Spiga          |  imx-rocko-mini-spiga_r1.0   |
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
| 5.10.72_2.1.0  | Hardknott        |  imx-hardknott-5-10-72_r1.0  |
--------------------------------------------------------------------
| 5.15.32_2.0.0  | Kirkstone        |  imx-kirkstone-5-15-32_r1.0  |
--------------------------------------------------------------------
| 6.1.1_1.0.0    | Langdale         |  imx-langdale-6-1-1_r1.0     |
--------------------------------------------------------------------
| 6.1.36_2.1.0   | Mickledore       |  imx-mickledore-6-1-36_r1.0  |
--------------------------------------------------------------------
| 6.6.3_1.0.0    | Nanbield         |  imx-nanbield-6-6-3_r1.0     |
--------------------------------------------------------------------



