# Open FPGA Stack Overview 

<image src="hw/n6001/reference_manuals/ofs_fim/images/ofs-logo-1x1.png" align="right" width="200" height="200">


 Open FPGA Stack (OFS): OFS is an open-source hardware and software framework that reduces the development time for creating your custom platform.   Provided within this framework are reference designs targeting different Altera FPGA devices with upstreamed drivers and management software tools.  

<image src="hw/d5005/reference_manuals/ofs_fim/images/Base-FIM.png" align="left" padding="10px,3px,10px,10px" width="200" height="200">

The reference shells, called FPGA Interface Manager (FIMs), provide an integrated, timing closed design with the most common interfaces for host attach applications. After selecting your starting shell, you can add or subtract interfaces depending on your application requirements.
Then leverage the build scripts, RTL, unit tests, Universal Verification Methodology (UVM) environment, software and drivers for this reference shell as a starting point for your own FPGA platform solution.


OFS currently targets Stratix<sup>&reg;</sup> 10 and Agilex<sup>&reg;</sup> 7 FPGA Device Families.  
To find out more about Altera FPGAs, visit the [Stratix 10](https://www.intel.com/content/www/us/en/products/details/fpga/stratix/10.html) and [Agilex 7](https://www.intel.com/content/www/us/en/products/details/fpga/agilex/7.html) pages at Intel.com.

<br>

## **How Can I Start Using OFS?**

 1. If you are interested in a production card that uses OFS for your workload application development or for full deployment, please refer to the [**OFS Board Catalog**](https://www.intel.com/content/www/us/en/content-details/765730/open-fpga-stack-board-catalog.html).  

 2. If you are an FPGA developer, refer to our [FPGA Developer Journey Guide: Open FPGA Stack](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_fpga_developer/ug_fpga_developer/ ) to understand the OFS development flow as well as the reference shells, tools and development boards you can use to gest started.  FPGA Developers interested in oneAPI should reference this guide as well.
 
 3. If you are a software developer, refer to our [Software Tab](https://ofs.github.io/ofs-2025.1-1/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/) for driver and user space tool development resources.

 4. If you are an application developer, preview our overview [video](https://www.youtube.com/watch?v=i-z7Oyyg_l8) on how OFS can help you develop FPGA-based workloads and review one of the AFU Developer Guides to find the OFS resources available for creating your own application workload.

* [Workload Developer Guide: OFS for Agilex™ 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/)
* [Workload Developer Guide: OFS for Agilex™ 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/)
* [Workload Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/afu_dev/ug_dev_afu_d5005/)

Beyond the resources we have on this [site](https://ofs.github.io), you can navigate to the OFS GitHub repos by clicking the GitHub repository icon at the top left corner of this site page.

<image src="hw/common/user_guides/ug_fpga_developer/images/Repo-site-access.png">

## **What FIM Reference Designs Are Available?**

Below summarizes the five current reference designs (aka FIMs) you can choose from:


**OFS FIM Targeting Agilex<sup>&reg;</sup>7 PCIe Attach (2xR-tile, F-tile)**

<image src="hw/common/user_guides/ug_fpga_developer/images/I-Series-PCIe-Attach.png">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | &bull; AGIB027R29A1E1VB                                           |
| PCIe                                  | &bull; R-tile PCIe Gen5x16<br>&bull; R-tile PCIe 2xGen5x8<br> &bull; R-tile PCIe Gen4x16                   |
| Virtualization                        | &bull; 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | &bull; Four Fabric DDR4 channels consisting of:<br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; Two x64 (no ECC), 2666 MHz, 8GB Component memory<br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; Two x64 (no ECC), 2666 MHz, 8GB UDIMM memory <br>OR<br>&bull; Three Fabric DDR4 channels consisting of:<br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; Two x64 (no ECC), 2666 MHz, 8GB Component memory<br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; One x64 (no ECC), 2666 MHz, 8GB RDIMM memory|
| Ethernet                              | &bull; 2x4x25GbE<br>&bull; 2x200GbE<br>&bull; 2x400GbE |
| Hard Processor System                 | &bull; Not enabled |
| Configuration and Board Manageability | &bull; FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration) |
| Partial Reconfiguration               | &bull; Supported |
| OneAPI<sup>[1]</sup>                                | &bull; OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | &bull; Linux DFL drivers targeting OFS FIMs<br>&bull; OPAE Software Development Kit* OPAE Tools |
| Target Board                          | &bull; [Agilex™ 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agi027.html) |

<sup>[1]</sup> OFS version 2024.2-1 is the latest version of OFS that supports OneAPI. Please use this version of OFS if OneAPI support is required.

Click here for the [OFS Collateral for Agilex™ 7 FPGA PCIe Attach Reference FIM](https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_pcie_attach) documentation collection.

<br>


**OFS FIM Targeting Agilex<sup>&reg;</sup>7 PCIe Attach (2xF-tile)**

<image src="hw/common/user_guides/ug_fpga_developer/images/F-tile-PCIe-Attach.png">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | &bull; AGFB027R24C2E2VR2                                           |
| PCIe                                  | &bull; F-tile PCIe* Gen4x16 |
| Virtualization                        | &bull; 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | 3 DDR Channels:<br>&bull; One HPS DDR4 bank, x40 (x32 Data and x8 ECC), 2400 MHz, 1GB each<br>&bull; Two Fabric DDR4 banks, x64 (no ECC), 2400 MHz, 8GB |
| Ethernet                              | &bull; 2x4x25GbE |
| Hard Processor System                 | &bull; 64-bit quad core Arm® Cortex®-A53 MPCore with integrated peripherals. |
| Configuration and Board Manageability | &bull; FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration) |
| Partial Reconfiguration               | &bull; Supported |
| OneAPI<sup>[1]</sup>                                | &bull; OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | &bull; Linux DFL drivers targeting OFS FIMs<br>&bull; OPAE Software Development Kit<br>&bull; OPAE Tools |
| Target Board                          | &bull; [Agilex™ 7 FPGA F-Series Development Kit (2x F-Tile)](https://www.intel.com/content/www/us/en/docs/programmable/739942/current/overview.html) |

<sup>[1]</sup> OFS version 2024.2-1 is the latest version of OFS that supports OneAPI. Please use this version of OFS if OneAPI support is required.

Click here for the [OFS Collateral for Agilex™ 7 FPGA PCIe Attach Reference FIM](https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_pcie_attach) documentation collection.

<br>


**OFS FIM Targeting Agilex<sup>&reg;</sup>7 PCIe Attach (P-tile, E-tile)**


<image src="hw/n6001/reference_manuals/ofs_fim/images/Agilex_Fabric_Features.png">



| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | &bull; AGFB014R24A2E2V                                              |
| PCIe                                  | &bull; P-tile PCIe* Gen4x16                                         |
| Virtualization                        | &bull; 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | 5 DDR Channels:<br>&bull;  One HPS DDR4 bank, x40 (x32 Data and x8 ECC), 1200 MHz, 1GB each<br>&bull; Four Fabric DDR4 banks, x32 (no ECC), 1200 MHz, 4GB |
| Ethernet                              | Provided configurations:<br>&bull; 2x4x25GbE<br>&bull;  2x4x10GbE<br>&bull;  2x100GbE |
| Hard Processor System                 | &bull; 64-bit quad core Arm® Cortex®-A53 MPCore with integrated peripherals. |
| Configuration and Board Manageability | &bull;  FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br>&bull;  Platform Controller Management Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | &bull; Supported |
| OneAPI<sup>[1]</sup>                                | &bull; OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | &bull;  Linux DFL drivers targeting OFS FIMs<br>&bull;  OPAE Software Development Kit<br>&bull;  OPAE Tools |
| Target Board                          | &bull; [Intel® FPGA SmartNIC N6001-PL](https://www.intel.com/content/www/us/en/content-details/779620/a-smartnic-for-accelerating-communications-and-networking-workloads.html) |

<sup>[1]</sup> OFS version 2024.2-1 is the latest version of OFS that supports OneAPI. Please use this version of OFS if OneAPI support is required.

Click here for the [OFS Collateral for Agilex™ 7 FPGA PCIe Attach Reference FIM](https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_pcie_attach) documentation collection.

<br>


**OFS FIM Features Targeting Agilex<sup>&reg;</sup> 7 SoC Attach**

<image src="hw/f2000x/reference_manuals/ofs_fim/images/Agilex_Fabric_Features.svg">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Device OPN                            | AGFC023R25A2E2VR0                                            |
| PCIe                                  | &bull; P-tile PCIe* Gen4x16 to the Host<br>&bull; P-tile PCIe* Gen4x16 to the SoC (IceLake-D) |
| Virtualization                        | &bull; Host: 2 physical functions <br>&bull; SoC:   1 physical function and 3 Virtual functions |
| Memory                                | &bull; Four Fabric DDR4 banks, x40 (optional ECC, be configured as x32 and ECC x8 ), 1200 MHz, 4GB |
| Ethernet                              | &bull; 2x4x25GbE |
| Configuration and Board Manageability | &bull;  FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br>&bull; Platform Controller Management Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | &bull; Supported |
| Software Support                      | &bull; Linux DFL drivers targeting OFS FIMs<br>&bull; OPAE Software Development Kit&bull; OPAE Tools |
| Target Board                         | &bull; [Intel® Infrastructure Processing Unit (Intel® IPU) Platform F2000X-PL](https://www.intel.com/content/www/us/en/products/details/network-io/ipu/f2000x-pl-platform.html)

Note: Source code for BMC RTL/Firmware that works with this reference FIM can be obtained by contacting your Altera Sales Representative.

Click here for the [OFS Collateral for Agilex™ SoC Attach Reference FIM](https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_soc_attach) documentation collection.

<br>


**OFS FIM Targeting Stratix<sup>&reg;</sup> 10 FPGA PCIe Attach**

<image src="hw/d5005/reference_manuals/ofs_fim/images/FIM-s10-OFS.png">


| Key Feature | Description | 
|:-----------:|:-------------------------------|
| Device OPN  | &bull; 1SX280HN2F43E2VG |
|Ethernet Configuration | &bull; 1x10GbE example with 2x100GbE capability |
| PCIe | &bull; Gen3x16 |
|EMIF | &bull; Up to four DDR channels |
| PF/VF | &bull; 1 PF/3 VFs |
|Management | &bull; FPGA Management Engine (FME) with FIM management registers|
|Interface | &bull; Arm<sup>&reg;</sup> AMBA<sup>&reg;</sup>4 AXI Interface |
| HLD support | &bull; oneAPI |
| Software | &bull; Kernel code upstreamed to Linux.org |
|Target Board  | &bull; [Intel® FPGA Programmable Acceleration Card D5005](https://www.intel.com/content/www/us/en/docs/programmable/683568/current/introduction.html)|

Click here for the [OFS Collateral for Stratix® 10 FPGA PCIe Attach Reference FIM](https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_s10_pcie_attach)) documentation.

To find information on the latest releases, go to the [Discussions Tab](https://github.com/orgs/OFS/discussions) in the OFS GitHub repository.

<br>

## **Open FPGA Stack Repositories**


Accessing OFS ingredients to use within the development framework is easy.  The [github.com/OFS](https://github.com/OFS) site provides all the hardware and software repositories in one location.

|Development Focus|Repository Folder | Description |
|:----------------:|:------------------:|:--------------------|
|Hardware | [ofs-agx7-pcie-attach](https://github.com/OFS/ofs-agx7-pcie-attach) | Provides RTL, unit tests, and build scripts to create an Agilex<sup>&reg;</sup> 7 FIM and is leveraged as a starting point for a custom PCIe Attach design.  The provided reference FIM can target the following boards:</br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Intel® FPGA SmartNIC N6001-PL Platform](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/smartnic/n6000-pl-platform.html) </br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Agilex 7 FPGA F-Series Development Kit (2x F-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html)</br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Agilex 7 FPGA I-Series Development Kit (2 x R-Tile, 1 x F-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agi027.html) |
|Hardware | [ofs-f2000x-pl](https://github.com/OFS/ofs-f2000x-pl) | Provides RTL, unit tests, and build scripts to create Agilex<sup>&reg;</sup> FIM and is leveraged as a starting point for a custom SoC Attach design.  The reference FIM targets an [Intel® FPGA IPU F2000X-PL Platform](https://www.intel.com/content/www/us/en/products/details/network-io/ipu/f2000x-pl-platform.html). |
|Hardware | [ofs-d5005](https://github.com/OFS/ofs-d5005) | Provides RTL, unit tests, and build scripts to create Stratix 10<sup>&reg;</sup> FIM and is leveraged as a starting point for a custom PCIe Attach design.  The reference FIM targets an Intel® FPGA PAC D5005 development board. |
| Hardware| [oneapi-asp](https://github.com/OFS/oneapi-asp) | Contains the files to generate the support package that works with the reference shells and allows you to use OneAPI. This is an optional repository for developers interested in OneAPI|
|Hardware| [ofs-fim-common](https://github.com/OFS/ofs-fim-common) | Provides RTL components that are shared among all new platforms that are introduced in OFS.  This folder is a subumodule in each platform repository folder. |
| Hardware | [examples-afu](https://github.com/OFS/examples-afu) | Provides simple Accelerator Functional Unit (AFU) examples you can use as a template for starting your own workload design.  |
| Hardware | [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) | Contains the hardware code to build a standard interface between the FIM and your workload. | 
| Software | [linux-dfl](https://github.com/OFS/linux-dfl) | This repository is a mirror of the linux.org Git site and contains the most up-to-date drivers that are being developed and upstreamed for OFS platforms.|
| Software | [linux-dfl-backport](https://github.com/OFS/linux-dfl-backport) | A place for finding and leveraging out-of-tree backported drivers for older OS versions .  |
| Software | [meta-ofs](https://github.com/OFS/meta-ofs) | This repository provides the Linux<sup>&reg;</sup> DFL kernel and the OPAE SDK for the Yocto<sup>&reg;</sup> Project.|
| Software | [opae-sdk](https://github.com/OFS/opae-sdk) | Contains the ingredients to build the OFS Open Programmable Acceleration Engine (OPAE) Software Development Kit which provides APIs and userspace tools for OFS FPGA management. |
| Software | [opae-sim](https://github.com/OFS/opae-sim) | This repository is used to build the AFU Hardware/Software Co-Simulation Environment workload developers can use to ensure their AFU can work with the OFS software stack. |
| Software | [opae-legacy](https://github.com/OFS/opae-legacy) | Supports OFS platforms built on the legacy version of OPAE software.  Not used in current OFS designs |
| Documentation | [ofs.github.io](https://github.com/OFS/ofs.github.io) | Contains the hardware and software collateral that surfaces on the OFS website: <https://ofs.github.io> | 

<br>




[Open FPGA Stack (OFS) Collateral Site]: https://ofs.github.io/ofs-2025.1-1
[OFS Welcome Page]: https://ofs.github.io/ofs-2025.1-1
[OFS Collateral for Stratix® 10 FPGA PCIe Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_s10_pcie_attach
[OFS Collateral for Agilex™ 7 FPGA PCIe Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_pcie_attach
[OFS Collateral for Agilex™ SoC Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_soc_attach


[Automated Evaluation User Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/
[Automated Evaluation User Guide: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_eval_script_ofs_agx7_pcie_attach/ug_eval_script_ofs_agx7_pcie_attach/
[Automated Evaluation User Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_eval_ofs/ug_eval_script_ofs_f2000x/


[Board Installation Guide: OFS for Acceleration Development Platforms]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/adp_board_installation/adp_board_installation_guidelines
[Board Installation Guide: OFS for Agilex™ 7 PCIe Attach Development Kits]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/devkit_board_installation/devkit_board_installation_guidelines
[Board Installation Guide: OFS For Agilex™ 7 SoC Attach IPU F2000X-PL]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/f2000x_board_installation/f2000x_board_installation
[Board Installation Guide: OFS for Agilex™ 5 PCIe Attach Development Kits]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/devkit_board_installation/devkit_board_installation_guidelines


[Software Installation Guide: OFS for PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach
[Software Installation Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/soc_attach/sw_install_soc_attach


[Getting Started Guide: OFS for Stratix 10® FPGA PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (I-Series Development Kit (2xR-Tile, 1xF-Tile))]: https://ofs.github.io/ofs-2025.1-1/hw/iseries_devkit/user_guides/ug_qs_ofs_iseries/ug_qs_ofs_iseries/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (F-Series Development Kit (2xF-Tile))]: https://ofs.github.io/ofs-2025.1-1/hw/ftile_devkit/user_guides/ug_qs_ofs_ftile/ug_qs_ofs_ftile/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (Intel® FPGA SmartNIC N6001-PL/N6000-PL)]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/
[Getting Started Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/


[Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/
[Shell Technical Reference Manual: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/
[Shell Technical Reference Manual: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs/


[Shell Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/fim_dev/ug_dev_fim_ofs_d5005/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (2xR-tile, F-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (2xF-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (P-tile, E-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/
[Shell Developer Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/
[Shell Developer Guide: OFS for Agilex™ 5 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/


[Workload Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/afu_dev/ug_dev_afu_d5005/
[Workload Developer Guide: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/
[Workload Developer Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/
[Workload Developer Guide: OFS for Agilex™ 5 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/agx5/user_guides/afu_dev/ug_dev_afu_ofs_agx5/


[oneAPI Accelerator Support Package (ASP): Getting Started User Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/oneapi_asp/ug_oneapi_asp/
[oneAPI Accelerator Support Package(ASP) Reference Manual: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/reference_manual/oneapi_asp/oneapi_asp_ref_mnl/


[UVM Simulation User Guide: OFS for Stratix® 10 PCIe Attach]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_sim_ofs_d5005/ug_sim_ofs_d5005/
[UVM Simulation User Guide: OFS for Agilex™ 7 PCIe Attach]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_sim_ofs_agx7_pcie_attach/ug_sim_ofs_agx7_pcie_attach/
[UVM Simulation User Guide: OFS for Agilex™ 7 SoC Attach]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_sim_ofs/ug_sim_ofs/


[FPGA Developer Journey Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_fpga_developer/ug_fpga_developer/ 
[PIM Based AFU Developer Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/ug_dev_pim_based_afu/
[AFU Simulation Environment User Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_sim_env/ug_dev_afu_sim_env/
[AFU Host Software Developer Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_host_software/ug_dev_afu_host_software/
[Docker User Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_docker/ug_docker/
[KVM User Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_kvm/ug_kvm/
[Hard Processor System Software Developer Guide: OFS for Agilex™ FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/hps_dev/hps_developer_ug/
[Software Reference Manual: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/
[Troubleshooting Guide for OFS Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_troubleshoot/ug_agx7_troubleshoot/


[OFS repository - linux-dfl]: https://github.com/OFS/linux-dfl
[OFS repository - linux-dfl - wiki page]: https://github.com/OFS/linux-dfl/wiki
[OPAE SDK repository]: https://github.com/OFS/opae-sdk
[OFS Site]: https://ofs.github.io
[examples-afu]: https://github.com/OFS/examples-afu.git


[Intel® oneAPI Base Toolkit (Base Kit)]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html
[Intel® oneAPI Toolkits Installation Guide for Linux* OS]: https://www.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top.html
[Intel® oneAPI Programming Guide]: https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top.html
[FPGA Optimization Guide for Intel® oneAPI Toolkits]: https://www.intel.com/content/www/us/en/develop/documentation/oneapi-fpga-optimization-guide/top.html
[oneAPI-samples]: https://github.com/oneapi-src/oneAPI-samples.git
[Intel® oneAPI DPC++/C++ Compiler Handbook for Intel® FPGAs]: https://www.intel.com/content/www/us/en/docs/oneapi-fpga-add-on/developer-guide/current.html


[OPAE SDK]: https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/quick_start/readme/
[OFS DFL kernel driver]: https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/quick_start/readme/#build-the-opae-linux-device-drivers-from-the-source


[Connecting an AFU to a Platform using PIM]: https://github.com/OPAE/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[PIM Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/01_pim_ifc
[Non-PIM AFU Development]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/03_afu_main
[Multi-PCIe Link AFUs]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/04_multi_link
[VChan Muxed AFUs]:  https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/05_pim_vchan
[PIM AFU Interface]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[PIM Board Vendors]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_board_vendors.md
[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md
[PIM IFC Host Channel]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md
[PIM IFC Local Memory]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md
[base_ifcs]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/base_ifcs
[ifcs_classes]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/ifc_classes
[utils]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/utils
[Device Feature List Overview]: https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#device-feature-list-dfl-overview



[Token authentication requirements for Git operations]: https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations
[4.0 OPAE Software Development Kit]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit
[6.2 Installing the OPAE SDK On the Host]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/#62-installing-the-opae-sdk-on-the-host

[Signal Tap Logic Analyzer: Introduction & Getting Started]: https://www.intel.com/content/www/us/en/programmable/support/training/course/odsw1164.html
[Quartus Pro Prime Download]: https://www.intel.com/content/www/us/en/software-kit/839515/intel-quartus-prime-pro-edition-design-software-version-24-3-for-linux.html

[Red Hat Linux]: https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.4/x86_64/product-software
[OFS GitHub Docker]: https://github.com/OFS/ofs.github.io/tree/main/docs/hw/common/user_guides/ug_docker

[Security User Guide: Open FPGA Stack]: https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/ug-pac-security.md

[Device Feature List Feature IDs]: https://github.com/OFS/dfl-feature-id/blob/main/dfl-feature-ids.rst

[OFS 2024.1 F2000X-PL Release Notes]: https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2025.1-1

[AXI Streaming IP for PCI Express User Guide]: https://www.intel.com/content/www/us/en/docs/programmable/790711/24-3-1/introduction.html

[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md


