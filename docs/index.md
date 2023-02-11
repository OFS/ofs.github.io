# Open FPGA Stack Overview

<image src="hw/d5005/reference_manuals/ofs_fim/images/OFS.png" align="right" width="200" height="200">
 Open FPGA Stack (OFS): OFS is an open-source solution that provides a hardware and software framework for building your shell design and subsequently your workload.  
OFS provides reference shell designs targeting different Intel<sup>&reg;</sup> FPGA devices with upstreamed drivers and management software tools.  




The reference shells, called FPGA Interface Manager, provide an integrated, timing closed I/O ring with the most common interfaces for applications. You can add or subtract interfaces to the I/O ring depending on your application requirements.
You can leverage the build scripts, RTL, unit tests software and drivers targeting this reference shell as a starting point for your own FPGA platform solution.

OFS targets Intel Stratix<sup>&reg;</sup> 10 and Intel Agilex<sup>&trade;</sup> FPGA Device Families.  
To find out more about Intel FPGAs, visit the [Intel Stratix 10](https://www.intel.com/content/www/us/en/products/details/fpga/stratix/10.html) and [Intel Agilex](https://www.intel.com/content/www/us/en/products/details/fpga/agilex.html) pages at Intel.com

<image src="hw/d5005/reference_manuals/ofs_fim/images/Base-FIM.png" align="center" width="400" height="400">


## Open FPGA Stack Repositories


Accessing OFS ingredients to use within the development framework is easy.  The github.com/OFS site provides all the hardware and software repositories in one location.

<image src="hw/d5005/reference_manuals/ofs_fim/images/OFS-repo.png" align="center" width="500" height="500">

<br>

|Repository Folder |Description | Hardware or Software Repository |
|:----------------:|------------------|:--------------------|
| linux-dfl        |This repository is a mirror of the linux.org Git site and contains the most up-to-date drivers that are being developed and upstreamed for OFS platforms.|Software|
|opae-sdk | Contains the ingredients to build the OFS Open Programmable Acceleration Engine (OPAE) Software Development Kit which provides APIs and userspace tools for OFS FPGA management. | Software |
|ofs.github.io | Contains the hardware and software collateral that surfaces on the OFS website: https://ofs.github.io | Markdown/HTML |
| ofs-d5005 | Provides RTL, unit tests, and build scripts to create Intel Stratix 10 FIM and is leveraged as a starting point for a custom design.  The reference FIM targets an Intel FPGA PAC D5005 development board. | Hardware |
| ofs-fim-common | Provides RTL components that are shared among all new platforms that are introduced in OFS.  This folder is a subumodule in each platform repository folder. | Hardware |
| ofs-platform-afu-bbb | Contains the hardware and software code used to build the host interface for the FIM and provides test examples. | Hardware/Software |
| linux-dfl-backport | A place for finding and leveraging out-of-tree backported drivers for older OS versions . | Software |
| examples-afu | Provides standard AFU examples you can use as a template for starting your own workload design. | Software |
| opae-legacy | Supports OFS platforms built on the legacy version of OPAE software.  Not used in current OFS designs | Software |
| opae-sim | This repository is used to build the AFU Hardware/Software Co-Simulation Environment workload developers can use to ensure their AFU can work with the OFS software stack. | Hardrware/Software ||

<br>

## **RTL Repository**

Every FPGA RTL development repository is named after the platform it targets.  This platform target is a starting point for development and can be considered a best known configuration for debugging.

The structure of the RTL repository remains the same regardless of which device platform you decide to use.  The advantage of this is you will quickly become familiar with the hierarchy as you consider new FPGA application development.

<image src="hw/d5005/reference_manuals/ofs_fim/images/platform-repo.png" align="center" width="350" height="350">

<br>

| Directory | Description |
|:----------:|--------------------|
|eval_scripts | Provides resources to setup, compile, simulate and test the reference FIM that can be built in the repository.|
| ipss | Contains the code and supporting files that configure and build the default configuration of the key subsystems |
| license | Contains license required to build the IP in Quartus<sup>&reg;</sup>.  Note you still utilize an evaluation license or purchase a license to use Quartus Prime Pro Software.|
| ofs-common@commit#| Contains scripts and source code that are common to all of the platform RTL repositories and to your own FPGA design.  This directory is referenced through a specific commit and you have the option to update to the latest ofs-common as your design evolves.|
| sim | Provides test benches and supporting code for unit tests. |
| src | Contains all structural and behavioral code for FIM including top-level RTL for synthesis and AFU infrastructure code. |
| syn | Provides scripts, settings and setup files for running FIM synthesis. ||

<br>

## **How Can I Start Using OFS?**

The best way to start using OFS is to evaluate the reference FIM that can be built in the platform repository by leveraging our eval_scripts to run through the hardware and software build flow and test the design in simulation and optionally hardware as well.

The reference FIM in the platform repository currently targets PCIe attach applications and can be used as-is or can be used as a starting point for modification, greatly reducing development time. The ofs-d5005 repository provides capability to build an Intel Stratix 10 OFS reference FIM.  Additional repositories that support Intel Agilex FPGA will be added in a future OFS GitHub release.  For more information about the upcoming Intel Agilex offering, visit the OFS webpage on [intel.com](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/pac/open-fpga-stack.html) and submit the available questionnaire.

<image src="hw/d5005/reference_manuals/ofs_fim/images/FIM-s10-OFS block.png" align="center" width="350" height="350">

<br>


**OFS FIM Targeting Intel Stratix 10 FPGA**

| Key Feature | Intel Stratix 10 Reference FIM | 
|:-----------:|:-------------------------------|
|FPGA  | Intel Stratix 10 SX FPGA |
|Ethernet Configuration | 1x10GbE example with 2x100GbE capability |
| PCIe | Gen3x16 |
|EMIF | Up to four DDR channels |
| PF/VF | 1 PF/3 VFs |
|Management | FPGA Management Engine (FME) with FIM management registers|
|Interface | Arm<sup>&reg;</sup> AMBA<sup>&reg;</sup>4 AXI Interface |
| HLD support | oneAPI |
| Software | Kernel code upstreamed to Linux.org |

Note: Source code for BMC RTL/Firmware that works with this reference FIM can be obtained by contacting your Intel Sales Representative.

Click here for the [Intel Stratix 10 OFS Collateral](https://ofs.github.io/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/).

To find information on the latest releases, go to the [Discussions Tab](https://github.com/orgs/OFS/discussions) in the OFS GitHub repository.





