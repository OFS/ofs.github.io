# Open FPGA Stack Overview 

<image src="hw/n6001/reference_manuals/ofs_fim/images/ofs-logo-1x1.png" align="right" width="200" height="200">


 Open FPGA Stack (OFS): OFS is an open-source hardware and software framework that reduces the development time for creating your custom platform.   Provided within this framework are reference designs targeting different Intel<sup>&reg;</sup> FPGA devices with upstreamed drivers and management software tools.  

<image src="hw/d5005/reference_manuals/ofs_fim/images/Base-FIM.png" align="left" padding="10px,3px,10px,10px" width="200" height="200">

The reference shells, called FPGA Interface Manager (FIMs), provide an integrated, timing closed design with the most common interfaces for host attach applications. After selecting your starting shell, you can add or subtract interfaces depending on your application requirements.
Then leverage the build scripts, RTL, unit tests, Universal Verification Methodology (UVM) environment, software and drivers for this reference shell as a starting point for your own FPGA platform solution.


OFS currently targets Intel Stratix<sup>&reg;</sup> 10 and Intel Agilex<sup>&reg;</sup> 7 FPGA Device Families.  
To find out more about Intel FPGAs, visit the [Intel Stratix 10](https://www.intel.com/content/www/us/en/products/details/fpga/stratix/10.html) and [Intel Agilex 7](https://www.intel.com/content/www/us/en/products/details/fpga/agilex/7.html) pages at Intel.com.

<br>

## **How Can I Start Using OFS?**

 1. If you are interested in a production card that uses OFS for your workload application development or for full deployment, please refer to the [**OFS Board Catalog**](https://www.intel.com/content/www/us/en/content-details/765730/open-fpga-stack-board-catalog.html).  

 2. If you are an FPGA developer, refer to our [FPGA Developer Journey Guide] to understand the OFS development flow as well as the reference shells, tools and development boards you can use to gest started.  FPGA Developers interested in oneAPI should reference this guide as well.
 
 3. If you are a software developer, refer to our [Software Tab](https://ofs.github.io/ofs-2023.3-2/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/) for driver and user space tool development resources.

 4. If you are an application developer, preview our overview [video](https://www.youtube.com/watch?v=i-z7Oyyg_l8) on how OFS can help you develop FPGA-based workloads and review one of the AFU Developer Guides to find the OFS resources available for creating your own application workload.

* [Accelerator Functional Unit (AFU) Developer Guide: OFS for Intel® Agilex® 7 PCIe Attach](https://ofs.github.io/ofs-2023.3-2/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/)
* [Accelerator Functional Unit (AFU) Developer Guide: OFS for Intel® Agilex® 7 SoC Attach](https://ofs.github.io/ofs-2023.3-2/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/)
* [Accelerator Functional Unit (AFU) Developer Guide: OFS for Intel® Stratix® 10 FPGA PCIe Attach](https://ofs.github.io/ofs-2023.3-2/hw/d5005/dev_guides/afu_dev/ug_dev_afu_d5005/)

Beyond the resources we have on this [site](https://ofs.github.io), you can navigate to the OFS GitHub repos by clicking the GitHub repository icon at the top left corner of this site page.

<image src="hw/common/user_guides/ug_fpga_developer/images/Repo-site-access.png">

## **What FIM Reference Designs Are Available?**

Below summarizes the five current reference designs (aka FIMs) you can choose from:


**OFS FIM Targeting Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup>7 PCIe Attach (2xR-tile, F-tile)**

<image src="hw/common/user_guides/ug_fpga_developer/images/I-Series-PCIe-Attach.png">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | AGIB027R29A1E2VR3                                           |
| PCIe                                  | R-tile PCIe* Gen5x8                   |
| Virtualization                        | 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | * Two Fabric DDR4 channels, x64 (no ECC), 2666 MHz, 8GB |
| Ethernet                              | 2x4x25GbE, 2x200GbE, 2x400GbE |
| Hard Processor System                 | Not enabled |
| Configuration and Board Manageability | * FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br>* Platform Management Controller Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | Supported |
| OneAPI                                | OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | * Linux DFL drivers targeting OFS FIMs<br>* OPAE Software Development Kit* OPAE Tools |
| Target Board                          | [Intel Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agi027.html) |


Click here for the [OFS Collateral for Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> PCIe Attach Reference FIM](https://ofs.github.io/ofs-2023.3-2/hw/common/user_guides/ug_eval_script_ofs_agx7_pcie_attach/ug_eval_script_ofs_agx7_pcie_attach/) documentation collection.

<br>


**OFS FIM Targeting Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup>7 PCIe Attach (2xF-tile)**

<image src="hw/common/user_guides/ug_fpga_developer/images/F-tile-PCIe-Attach.png">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | AGFB027R24C2E2VR2                                           |
| PCIe                                  | F-tile PCIe* Gen4x16 |
| Virtualization                        | 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | 3 DDR Channels:* One HPS DDR4 bank, x40 (x32 Data and x8 ECC), 2400 MHz, 1GB each* Two Fabric DDR4 banks, x64 (no ECC), 2400 MHz, 8GB |
| Ethernet                              | 2x4x25GbE |
| Hard Processor System                 | 64-bit quad core Arm® Cortex®-A53 MPCore with integrated peripherals. |
| Configuration and Board Manageability | * FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br>* Platform Management Controller Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | Supported |
| OneAPI                                | OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | * Linux DFL drivers targeting OFS FIMs<br>* OPAE Software Development Kit* OPAE Tools |
| Target Board                          | [Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile)](https://www.intel.com/content/www/us/en/docs/programmable/739942/current/overview.html) |


Click here for the [OFS Collateral for Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> PCIe Attach Reference FIM](https://ofs.github.io/ofs-2023.3-2/hw/common/user_guides/ug_eval_script_ofs_agx7_pcie_attach/ug_eval_script_ofs_agx7_pcie_attach/) documentation collection.

<br>


**OFS FIM Targeting Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup>7 PCIe Attach (P-tile, E-tile)**


<image src="hw/n6001/reference_manuals/ofs_fim/images/Agilex_Fabric_Features.png">



| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Target OPN                            | AGFB014R24A2E2V                                              |
| PCIe                                  | P-tile PCIe* Gen4x16                                         |
| Virtualization                        | 5 physical functions/3 virtual functions with ability to expand |
| Memory                                | 5 DDR Channels:* One HPS DDR4 bank, x40 (x32 Data and x8 ECC), 1200 MHz, 1GB each* Four Fabric DDR4 banks, x32 (no ECC), 1200 MHz, 4GB |
| Ethernet                              | 2x4x25GbE, 2x4x10GbE or 2x100GbE |
| Hard Processor System                 | 64-bit quad core Arm® Cortex®-A53 MPCore with integrated peripherals. |
| Configuration and Board Manageability | * FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br>* Platform Controller Management Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | Supported |
| OneAPI                                | OneAPI Acceleration Support Package (ASP) provided with compiled FIM to support OneAPI Runtime |
| Software Support                      | * Linux DFL drivers targeting OFS FIMs<br>* OPAE Software Development Kit* OPAE Tools |
| Target Board                          | [Intel® FPGA SmartNIC N6001-PL](https://www.intel.com/content/www/us/en/content-details/779620/a-smartnic-for-accelerating-communications-and-networking-workloads.html) |

Click here for the [OFS Collateral for Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> PCIe Attach Reference FIM](https://ofs.github.io/ofs-2023.3-2/hw/common/user_guides/ug_eval_script_ofs_agx7_pcie_attach/ug_eval_script_ofs_agx7_pcie_attach/) documentation collection.

<br>


**OFS FIM Features Targeting Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> 7 SoC Attach**

<image src="hw/f2000x/reference_manuals/ofs_fim/images/Agilex_Fabric_Features.svg">


| Key Feature                           | Description                                                  |
| :-------------------------------------: | :------------------------------------------------------------ |
| Device OPN                            | AGFC023R25A2E2VR0                                            |
| PCIe                                  | P-tile PCIe* Gen4x16 to the Host<br />P-tile PCIe* Gen4x16 to the SoC (IceLake-D) |
| Virtualization                        | Host: 2 physical functions <br />SoC:   1 physical function and 3 Virtual functions |
| Memory                                | Four Fabric DDR4 banks, x40 (optional ECC, be configured as x32 and ECC x8 ), 1200 MHz, 4GB |
| Ethernet                              | 2x4x25GbE |
| Configuration and Board Manageability | * FPGA Management Engine that provides general control of common FPGA tasks (ex. error reporting, partial reconfiguration)<br> * Platform Controller Management Interface (PMCI) Module for Board Management Controller |
| Partial Reconfiguration               | Supported |
| Software Support                      | * Linux DFL drivers targeting OFS FIMs<br> * OPAE Software Development Kit * OPAE Tools |
| Target Board                         | [Intel® Infrastructure Processing Unit (Intel® IPU) Platform F2000X-PL](https://www.intel.com/content/www/us/en/products/details/network-io/ipu/f2000x-pl-platform.html)

Note: Source code for BMC RTL/Firmware that works with this reference FIM can be obtained by contacting your Intel Sales Representative.

Click here for the [OFS Collateral for Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> SoC Attach Reference FIM](https://ofs.github.io/ofs-2023.3-2/hw/f2000x/user_guides/ug_eval_ofs/ug_eval_script_ofs_f2000x/) documentation collection.


<br>


**OFS FIM Targeting Intel<sup>&reg;</sup> Stratix<sup>&reg;</sup> 10 FPGA PCIe Attach**

<image src="hw/d5005/reference_manuals/ofs_fim/images/FIM-s10-OFS.png">


| Key Feature | Description | 
|:-----------:|:-------------------------------|
| Device OPN  | 1SX280HN2F43E2VG |
|Ethernet Configuration | 1x10GbE example with 2x100GbE capability |
| PCIe | Gen3x16 |
|EMIF | Up to four DDR channels |
| PF/VF | 1 PF/3 VFs |
|Management | FPGA Management Engine (FME) with FIM management registers|
|Interface | Arm<sup>&reg;</sup> AMBA<sup>&reg;</sup>4 AXI Interface |
| HLD support | oneAPI |
| Software | Kernel code upstreamed to Linux.org |
|Target Board  | [Intel® FPGA Programmable Acceleration Card D5005](https://www.intel.com/content/www/us/en/docs/programmable/683568/current/introduction.html)|


Click here for the [OFS Collateral for Intel<sup>&reg;</sup> Stratix<sup>&reg;</sup> 10 FPGA PCIe Attach Reference FIM](https://ofs.github.io/ofs-2023.3-2/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/) documentation.


To find information on the latest releases, go to the [Discussions Tab](https://github.com/orgs/OFS/discussions) in the OFS GitHub repository.

<br>

## **Open FPGA Stack Repositories**


Accessing OFS ingredients to use within the development framework is easy.  The [github.com/OFS](https://github.com/OFS) site provides all the hardware and software repositories in one location.

|Development Focus|Repository Folder | Description |
|:----------------:|:------------------:|:--------------------|
|Hardware | [ofs-agx7-pcie-attach](https://github.com/OFS/ofs-agx7-pcie-attach) | Provides RTL, unit tests, and build scripts to create an Intel<sup>&reg;</sup> Agilex<sup>&reg;</sup> 7 FIM and is leveraged as a starting point for a custom PCIe Attach design.  The provided reference FIM can target the following boards:</br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Intel® FPGA SmartNIC N6001-PL Platform](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/smartnic/n6000-pl-platform.html) </br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Intel Agilex 7 FPGA F-Series Development Kit (2x F-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html)</br>&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Intel Agilex 7 FPGA I-Series Development Kit (2 x R-Tile, 1 x F-Tile)](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agi027.html) |
|Hardware | [ofs-f2000x-pl](https://github.com/OFS/ofs-f2000x-pl) | Provides RTL, unit tests, and build scripts to create Intel<sup>&reg;</sup>Agilex<sup>&reg;</sup> FIM and is leveraged as a starting point for a custom SoC Attach design.  The reference FIM targets an [Intel® FPGA IPU F2000X-PL Platform](https://www.intel.com/content/www/us/en/products/details/network-io/ipu/f2000x-pl-platform.html). |
|Hardware | [ofs-d5005](https://github.com/OFS/ofs-d5005) | Provides RTL, unit tests, and build scripts to create Intel<sup>&reg;</sup> Stratix 10<sup>&reg;</sup> FIM and is leveraged as a starting point for a custom PCIe Attach design.  The reference FIM targets an Intel® FPGA PAC D5005 development board. |
| Hardware| [oneapi-asp](https://github.com/OFS/oneapi-asp) | Contains the files to generate the support package that works with the reference shells and allows you to use OneAPI. This is an optional repository for developers interested in OneAPI|
|Hardware| [ofs-fim-common](https://github.com/OFS/ofs-fim-common) | Provides RTL components that are shared among all new platforms that are introduced in OFS.  This folder is a subumodule in each platform repository folder. |
| Hardware | [examples-afu](https://github.com/OFS/examples-afu) | Provides simple Accelerator Functional Unit (AFU) examples you can use as a template for starting your own workload design.  |
| Hardware | [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) | Contains the hardware code to build a standard interface between the FIM and your workload. | 
| Software | [linux-dfl](https://github.com/OFS/linux-dfl) | This repository is a mirror of the linux.org Git site and contains the most up-to-date drivers that are being developed and upstreamed for OFS platforms.|
| Software | [meta-ofs](https://github.com/OFS/meta-ofs) | This repository provides the Linux<sup>&reg;</sup> DFL kernel and the OPAE SDK for the Yocto<sup>&reg;</sup> Project.|
| Software | [opae-sdk](https://github.com/OFS/opae-sdk) | Contains the ingredients to build the OFS Open Programmable Acceleration Engine (OPAE) Software Development Kit which provides APIs and userspace tools for OFS FPGA management. |
| Software | [opae-sim](https://github.com/OFS/opae-sim) | This repository is used to build the AFU Hardware/Software Co-Simulation Environment workload developers can use to ensure their AFU can work with the OFS software stack. |
| Software | [linux-dfl-backport](https://github.com/OFS/linux-dfl-backport) | A place for finding and leveraging out-of-tree backported drivers for older OS versions .  |
| Software | [opae-legacy](https://github.com/OFS/opae-legacy) | Supports OFS platforms built on the legacy version of OPAE software.  Not used in current OFS designs |
| Documentation | [ofs.github.io](https://github.com/OFS/ofs.github.io) | Contains the hardware and software collateral that surfaces on the OFS website: <https://ofs.github.io> | 

<br>



