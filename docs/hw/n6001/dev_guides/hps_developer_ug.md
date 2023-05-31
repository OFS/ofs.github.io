
# **Hard Processor System Software Developer Guide: Intel OFS for Intel Agilex FPGAs**

# **Targeting Intel® N6000/1-PL FPGA SmartNIC Platform**

Quartus Prime Pro Version: 22.1+

Last updated: **28 February 2023**

You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Intel products described herein.

No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document.

All information provided here is subject to change without notice. Contact your Intel representative to obtain the latest Intel product specifications and roadmaps.

The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request.

Intel Corporation. All rights reserved. Intel, the Intel logo, and other Intel marks are trademarks of Intel Corporation or its subsidiaries. Intel warrants performance of its FPGA and semiconductor products to current specifications in accordance with Intel&#39;s standard warranty but reserves the right to make changes to any products and services at any time without notice. Intel assumes no responsibility or liability arising out of the application or use of any information, product, or service described herein except as expressly agreed to in writing by Intel. Intel customers are advised to obtain the latest version of device specifications before relying on any published information and before placing orders for products or services.

\*Other names and brands may be claimed as the property of others.

Copyright © 2023, Intel Corporation. All rights reserved.

**Contents**

**[**1. Introduction**](#_Toc94083790)**

[1.1 Reference Documents](#_Toc94083791)

[1.2 Reference Images](#heading-1.2)

**[**2.0 Architecture Overview**](#_Toc94083792)**

[2.1 HPS Peripherals](#_Toc94083793)

[2.2 Zarlink Device](#_Toc94083794)

[2.3 Copy Engine](#_Toc94083795)

[2.4 Boot Flow](#_Toc94083796)

[2.5 Authorization](#_Toc94083797)

**[**3.0 Environment Setup**](#_Toc94083798)**

[3.1 Building U-Boot](#_Toc94083799)

[3.2 Yocto](#heading-3.2)

[3.2.1 Building the Yocto Image](#heading-3.2.1)

[3.2.2 Customizing the Yocto Image for N6000](#heading-3.2.2)

**[**4.0 Booting the HPS**](#_Toc94083811)**

[4.1 Intel OFS FIM Boot Overview](#heading-4.1)

[4.2 Booting Intel OFS FIM for Intel Agilex FPGAs](#heading-4.2)

[4.3 Example Boot](#heading-4.3)

**[**5.0 HPS command usage**](#_Toc94083812)**

[5.1 Synopsis](#_Toc94083813)

[5.2 Description](#_Toc94083814)

[5.3 Options](#_Toc94083815)

[5.4 Subcommands](#_Toc94083816)

[5.4.1 cpeng](#_Toc94083817)

[5.4.2 heartbeat](#_Toc94083818)

**[**6.0 Using meta-bake.py**](#heading-6.0)**

**[**7.0 Bringing up the HPS**](#heading-7.0)**

**[**8.0 Debugging**](#_Toc94083819)**

**[**9.0 Software Example - Adding helloworld to rootfile system**](#heading-9.0)**

**[**10.0 Connecting remotely to the HPS using `ssh`**](#heading-10.0)**

[layers.yaml Reference](#heading-layersyaml)

[FAQs](#_Toc94083821)

[Document Revision History](#heading-docrev)


**List of Figures**

[Figure 1. Intel Agilex FPGA HPS Peripheral](#_Toc94083823)

[Figure 2. Typical FPGA First Configuration Steps](#_Toc94083824)

**List of Tables**

[Table 1 Reference Documents](#_Toc94083825)

[Table 2 FPGA Configuration First Stages](#_Toc94083826)

[Table 3 Components](#_Toc94083827)

[Table 4 Yocto repositories](#_Toc94083828)

[Table 5 Modified Recipes](#_Toc94083829)

# Glossary

| Acronym | Expansion |
| --- | --- |
| AFU | Accelerator Function Unit |
| ATF | Arm\* Trusted Firmware |
| BDF | Bus Device Function |
| CE | Copy Engine |
| CSR | Configuration Status Register |
| FIM | FPGA Interface Manager (also referred to as FPGA shell design) |
| GPIO | General Purpose Input Output |
| HPS | Hard Processor System |
| HW | Hardware |
| OPAE | Open Programmable Acceleration Engine |
| RSU | Remote System Update |
| SS | Subsystem |
| SW | Software |

# File Types

|Extension | Description|
| ---| --- |
| ITS File (*.its) | The image source file which describes the contents of the image and defines various properties used during boot. Actual contents to be included in the image (kernel, ramdisk, etc.) are specified in the image source file as paths to the appropriate data files. |
| ITB File (*.itb) | Produced as output from `mkimage`, using an image source file. Contains all the referenced data (kernel, ramdisk, SSBL, etc.) and other information needed by UBoot to handle the image properly. This image is transferred to the target and booted. |
| DTB File (*.dtb)| The Device Tree Blob is loaded into memory by U-Boot during the boot process, and a pointer to it is shared with the kernel. This file describes the system's hardware layout to the kernel. |
| FIT Image (*.fit)| Format used for uImage payloads developed by U-boot. On aarch64 the kernel must be in image format and needs a device tree to boot.|

<a name ="_Toc94083790"></a>

# 1. Introduction

The Intel Open FPGA Stack (Intel OFS) is a modular collection of hardware platform components, open source upstreamed software, and broad ecosystem support that enables an efficient path to develop a custom FPGA platform. Intel OFS Provides a framework of FPGA synthesizable code, a simulation environment and synthesis/simulation scripts.  The updated Intel OFS architecture for Intel Agilex FPGA devices improves upon the modularity, configurability and scalability of the first release of the Intel OFS architecture while maintaining compatibility with the original design.  The primary components of the FPGA Interface Manager or shell of the reference design are:

- PCIe Subsystem
- HSSI Subsystem
- Memory Subsystem
- Hard Processor System (HPS)
- Reset Controller
- FPGA Management Engine (FME)
- AFU Peripheral Fabric for AFU accesses to other interface peripherals
- Board Peripheral Fabric for master to slave CSR accesses from Host or AFU
- SPI Interface to BMC controller

The Intel<sup>&reg;</sup> N6000-PL and N6001-PL FPGA SmartNIC Platforms are acceleration card that use the Intel OFS infrastructure. The key difference between these two platforms is:
 
- Intel<sup>&reg;</sup> N6000-PL SmartNIC Platform has a bifurcated PCIe bus with Gen4x8 interfacing to the the Intel Agilex FPGA and Gen4x8 interfacing to an Intel E810 SmartNIC.  This platform is targeted specifically for VRAN, UPF and vCSR applications.  The FPGA designs targeting these vertical market applications were generated using the Intel OFS infrastructure.
- Intel<sup>&reg;</sup> N6001-PL SmartNIC Platform has a Gen4x16 interface directly to the Intel Agilex FPGa and is not populated with an Intel E810 SmartNIC.  This platform is the reference platform for the Intel OFS reference designs for Intel Agilex FPGA.  

Note: throughout this document ""Intel N6000/1-PL FPGA SmartNIC Platform"" denotes both cards. This document describes the software package that runs on the Hard Processor System (HPS) which is a key component within the platform.

The Intel N6000/1-PL FPGA SmartNIC Platform has a customized build script that can be used to both set up a development environment and build the essential pieces of the HPS software image. This script, `meta-bake.py`, has its own dedicated section **8.0 Image Creation with `meta-bake.py`** which can be used to quickly get started with the HPS build flow. It is recommended you use this build script to execute your build flow, as it will handle all of the setup and patching required to build out your complete Yocto image. You can familiarize yourself with the contents of this package in its public GitHub repository located at https://github.com/OPAE/meta-opae-fpga/tree/main/tools/meta-bake.

<a name ="_Toc94083791"></a>

## 1.1 Reference Documents

**Table 1. Reference Documents**

| **Document Title** |
| --- |
| [Intel® Agilex™ Hard Processor System Technical Reference Manual](https://www.intel.com/content/www/us/en/programmable/documentation/slu1548263438002.html) |
| [Intel® Agilex™ SoC FPGA Boot User Guide](https://www.intel.com/content/www/us/en/programmable/documentation/pww1591206997703.html) |
| [Intel® Agilex™ Configuration User Guide](https://www.intel.com/content/www/us/en/programmable/documentation/oex1546548090650.html) |

<a name ="heading-1.2"></a>

## 1.2 Reference Images

Intel has provided a set of two pre-compiled ITB images that can be used for exploration and evaluation of the HPS bring-up flow. These images contain the complete SSBL package specific to the board and can be copied to the N6000/1-PL SmartNIC Platform with an HPS enabled FIM loaded. Refer to **Section 4.1 Example Boot** for an example on how to use the built-in copy engine IP in tandem with the host-side `cpeng` software to transfer an SSBL.

The package is found on the Intel Resource and Design Center with [Content ID 762960](https://www.intel.com/content/www/us/en/search.html?ws=idsa-default#q=762960&sort=relevancy&f:@tabfilter=[Developers]). The contents include two ITB files - one with the Vendor Authorized Boot (VAB) certificate included, and one without. Which you choose to load depends on whether the currently loaded FIM requires VAB authentication.

The default username is `root` and the password is empty. A good place to start after loading the ITB is to set up SSH for file transfers and the remote console, as seen in Section **8.1 Connecting remotely to the HPS using `ssh`**.

<a name="_Toc94083792"></a>

# 2.0 Architecture Overview

The Intel OFS architecture is classified into:

1. Host Interface Adapters (PCIe\*)
2. Low Performance Peripherals \
  2.1. Slow speed peripherals (example: JTAG, I2C, SMBus, and so on) \
  2.2. Management peripherals (example: FPGA FME)
3. High Performance Peripherals \
  3.1. Memory peripherals \
  3.2. Acceleration Function Units (AFUs) \
  3.3. HPS Peripheral
4. Fabrics \
  4.1. Peripheral Fabric (multi drop) \
  4.2. AFU Streaming fabric (point to point)

The HPS is connected to the AFU and implements all the board specific flows that customers require to begin the application development using the HPS such as host communication, firmware load and update, integration with Intel OFS, and memory. The HPS implements a basic &quot;Hello World&quot; software application and is intended as a starting point for customers to begin development with HPS.

<a name="_Toc94083793"></a>

## 2.1 HPS Peripherals

**Figure 1  Intel Agilex FPGA HPS Peripherals**

![](ug_images/Image1.png)

The Intel Agilex™ SoC integrates a full-featured Arm\* Cortex-A53\* MPCore Processor.

The Cortex-A53 MPCore supports high-performance applications and provides the capability for secure processing and virtualization.

Each CPU in the processor has the following features:

- Support for 32-bit and 64-bit instruction sets.
- To pipeline with symmetric dual issue of most instructions.
- Arm NEON\* Single Instruction Multiple Data (SIMD) co-processor with a Floating-Point Unit (FPU)
- Single and double-precision IEEE-754 floating point math support
- Integer and polynomial math support.
- Symmetric Multiprocessing (SMP) and Asymmetric Multiprocessing (AMP) modes.
- Armv8 Cryptography Extension.
- Level 1 (L1) cache:
- 32 KB two-way set associative instruction cache.
- Single Error Detect (SED) and parity checking support for L1 instruction cache.
- 32 KB four-way set associative data cache.
- Error checking and correction (ECC), Single Error Correct, Double Error Detect (SECDED) protection for L1 data cache.
- Memory Management Unit (MMU) that communicates with the System MMU (SMMU).
- Generic timer.
- Governor module that controls clock and reset.
- Debug modules:
- Performance Monitor Unit.
- Embedded Trace Macrocell (ETMv4).
- Arm CoreSight\* cross trigger interface, the four CPUs share a 1 MB L2 cache with ECC, SECDED protection.

A Snoop Control Unit (SCU) maintains coherency between the CPUs and communicates with the system Cache Coherency Unit (CCU). At a system level, the Cortex-A53 MPCore interfaces to a Generic Interrupt Controller (GIC), CCU, and System Memory Management Unit (SMMU).

Beyond the Arm\* Cortex-A53\* MPCore Processor, the HPS integrates a variety of useful peripherals for you to use in your design, such as Ethernet, USB, Memory Controller, on-chip RAM, SPI, UART and more. Please refer to the [Intel® Agilex™ Hard Processor System Technical Reference Manual](https://www.intel.com/content/www/us/en/programmable/documentation/slu1548263438002.html) for more information.

<a name="_Toc94083794"></a>

## 2.2 Zarlink Device

The Microchip® Zarlink device ZL30793 is used for time synchronization. It acts as the protocol engine that drives IEEE 1588-2008 PTP protocol. The Zarlink device is connected to the HPS side and the programming interface is SPI. The FPGA bitstream contains the HPS has First Stage Bootloader (FSBL) only. This enable commands to be given from a terminal program connected through UART.

The software in HPS can access the Clock generator through SPI to enable write and read operations controlled by the terminal program. It can also read the status of the hold over and Loss of Lock signals and control the LED.

<a name="_Toc94083795"</a>

## 2.3 Copy Engine

The host provides the `hps` OPAE command with related options to transfer images from host to HPS. The module in the Intel OFS FIM and HPS software that performs this transfer is called the Copy Engine (CPE). 

The CPE software is patched into Linux on the HPS in Yocto through the *meta-intel-fpga-refdes* layer. This service is daemonized and requires `systemd` in order to operate. This service will communicate with the HPS IP integrated in the FIM in order to coordinate and monitor file transfers from the host CPE software to DDR connected the HPS. The CPE HPS-side software takes advantage of the build-in Userspace I/O lightweight kernel module to communicate with the FIM's HPS IP. It can restart the transfer if the initial transfer of the image is not successful. The CPE can also serve as reference on how to integrate your own systemd service in the Linux build running on the HPS.

<a name="_Toc94083796"</a>

## 2.4 Boot Flow

The boot flow for the Agilex OFS design for the Intel N6000/1-PL FPGA SmartNIC Platform is an FPGA-first boot flow, meaning the Intel Agilex Secure Device Manager (SDM) configures the FPGA first and then boots the HPS. Alternatively, you can boot the HPS first and then configure the FPGA core as part of the Second-Stage Boot Loader (SSBL) or after the Operating System (OS) boots. HPS-first boot is not covered in this document, but for more information please refer to the [Intel® Agilex™ SoC FPGA Boot User Guide](https://www.intel.com/content/www/us/en/programmable/documentation/pww1591206997703.html).

For the FPGA-first boot flow supported by the Intel Agilex OFS FIM, the First Stage Bootloader is part of FPGA bitstream. The available Secure Device Manager (SDM) in the FPGA initially configures the FPGA core and periphery in this mode.

After completion, the HPS boots. All the I/O, including the HPS-allocated I/O, are configured, and brought out of tri-state. If the HPS is not booted:

- The HPS is held in reset
- HPS-dedicated I/O are held in reset
- HPS-allocated I/O are driven with reset values from the HPS.
- If the FPGA is configured before the HPS boots, then the boot flow looks as shown in the example figure below.

**Figure 2. Typical FPGA First Configuration Steps**

![](ug_images/Image2.png)

The flow includes the Time from Power-on-Reset (TPOR) to boot completion (TBoot\_Complete).

**Table 2. FPGA Configuration First Stages**

| **Time** | **Boot Stage** | **Device State** |
| --- | --- | --- |
| TPOR to T1 | POR | Power-on reset |
| T1 to T2 | SDM: Boot ROM |
| | |1. SDM samples the MSEL pins to determine the configuration scheme and boot source.
| | |2. SDM establishes the device security level based on eFuse values.
| | |3. SDM initializes the device by reading the configuration firmware (initial part of the bitstream) from the boot source.
| | |4. SDM authenticates and decrypts the configuration firmware (this process occurs as necessary throughout the configuration).
| | |5. SDM starts executing the configuration firmware.
 | | |
| T2 to T3 | SDM: Configuration Firmware |
| | |1. SDM I/O are enabled.
| | |2. SDM configures the FPGA I/O and core (full configuration) and enables the rest of your configured SDM I/O.
| | |3. SDM loads the FSBL from the bitstream into HPS on-chip RAM.
| | |4. SDM enables HPS SDRAM I/O and optionally enables HPS debug.
| | |5. FPGA is in user mode.
| | |6. HPS is released from reset. CPU1-CPU3 are in a wait-for-interrupt (WFI) state.
 | | |
| T3 to T4 | First-Stage Boot Loader (FSBL) |
| | |1. HPS verifies the FPGA is in user mode.
| | |2. The FSBL initializes the HPS, including the SDRAM.
| | |3. The user application through the host must request the copy engine using the OPAE command hps to transfer the itb image (SSBL +Linux) to the HPS DRAM.
| | |4. HPS peripheral I/O pin mux and buffers are configured. Clocks, resets, and bridges are also configured.
| | |5. HPS I/O peripherals are available.
 | | |
| T4 to T5 | Second-Stage Boot Loader (SSBL) |
| | |1. HPS bootstrap completes.
| | |2. OS is loaded into SDRAM.
 | | |
| T5 to TBoot\Complete | Operating System (OS) | The OS boots and applications are scheduled for runtime launch. |
 | | |

When using the Pre-boot Execution Environment (PXE) boot mechanism, you must use an option ROM. Intel OFS FIM does not have PXE boot implemented in the HPS.

<a name="_Toc94083797"></a>

## 2.5 Authorization

The HPS FSBL is part of the static region (SR) FPGA bitstream. Intel provides the capability to sign the FPGA bitstream binaries so that they can be authenticated when remotely updated and when configuring the FPGA. Signing of the SR bitstream is a two-stage process where you must sign with:

    1. `quartus_sign` tool
    2. OPAE `PACSign` tool

Signing with PACSign ensures the security of the BMC RSU update process to the flash, and requires a compatible binary file. Quartus signing provides ensures security when the bitstream is configured through the SDM into the Intel Agilex FPGA device using Vendor Authorized Boot.

Vendor Authorized Bootloader (VAB) considers the SDM as a trusted root entity such that when firmware is authenticated and booted and is running on the SDM with dedicated crypto HW IP blocks, it is considered a trusted entity. As such it is trusted to perform the authentication and authorization steps for subsequent bitstreams.

Each subsequent loaded object after the SDM boot firmware does not need to re-implement the authentication and authorization functions. The authentication and authorization functions are centralized. Arm Trusted Firmware (ATF) is used to make a trusted execution environment (TEE) in the HPS. The source code for both Arm Trusted firmware and the First Stage Boot Loader (FSBL) is provided in the GitHub\*.

The SSBL + Linux is a part of an itb file and may also be signed with Quartus\_sign and PACSign for authentication. Refer to the Security User Guide for Intel OFS for Intel Agilex FPGA for more information on signing.

<a name="_Toc94083798"></a>

# 3 Environment Setup

<a name="_Toc94083799"></a>

## 3.1 Building U-Boot

![](ug_images/Image3.png)

The following flow walks through downloading and building U-Boot manually. This information was ported from the [Agilex SoC GSRD](https://rocketboards.org/foswiki/Projects/AgilexSoCSingleQSPIFlashBoot#:~:text=cd%20%24TOP_FOLDER%0Awget,none%2Dlinux%2Dgnu%2D). 

If you are creating a development environment using `meta-bake.py` to pull down dependencies but not build, both U-Boot and the patches required to work with the Intel N6000/1-PL FPGA SmartNIC Platform are located at */meta-opae-fpga/tools/meta-bake/build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig*. To review the required patches applied to U-Boot, navigate to */meta-opae-fpga/tools/meta-bake/build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/git/patches*. From there, using git commands such as `git status` and `git branch` will show changes to the build environment. To build U-Boot manually after execution of `meta-bake.py` for any reason, navigate to */meta-bake/build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-srcfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig* and run `make`.

The following steps show how to manually download and build U-Boot. A recipe for the Intel N6000/1-PL FPGA SmartNIC Platform is patched in when using meta-bake.py when setting up a build environment and is not shown here.

``` bash
[user@localhost ]: sudo dnf install -y bison flex swig
[user@localhost ]: wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
[user@localhost ]: tar xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz
[user@localhost ]: export PATH=`pwd`/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin:$PATH

[user@localhost ]: git clone https://github.com/altera-opensource/u-boot-socfpga.git
[user@localhost ]: cd u-boot-socfpga
[user@localhost ]: git checkout socfpga_v2021.07

[user@localhost ]: export CROSS_COMPILE=aarch64-none-linux-gnu-
[user@localhost ]: export ARCH=arm
[user@localhost ]: make clean && make mrproper

# No VAB support
[user@localhost ]: make socfpga_agilex_n6000_defconfig

[user@localhost ]: make -j `nproc`
[user@localhost ]: cd ..
```

U-Boot comes with its own `dumpimage` tool, which can be used to identify an image and extract and identify its contents. This tool is built by default under */u-boot-socfpga/tools*, and in the `meta-bake.py` environment setup under */meta-opae-fpga/tools/meta-bake/build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig/tools*. This tool can also be used to extract specific components of the ITB file.

<a name="heading-3.2"></a>

# 3.2 Yocto

Yocto is an open source toolkit used to create Linux distributions and commonly used for creating Linux images
and bootloaders for embedded environments. A Yocto build environment is made up of one or more layers, with each
layer consisting of recipes that get processed to build/install components in a layer. The workhorse of a Yocto
build is the program called `bitbake`. This program processes the recipes to compile and build packages and images
for the target platform. For SoC platforms, like the HPS, the ARM cross compiler is required.

The build script used for the Agilex SoC GSRD, `create-linux-distro-release`, is a bash script that automates the build
of Linux images of different types (gsrd, nand, etc.) that are compatible with a target FPGA platform (agilex, stratix10, etc.).

This script has been ported to python and modified to build and environment for the Intel FPGA SmartNIC N6000/1 platform, named `meta-bake.py`. This script pulls in the necessary patches and additional changes needed to support the platform. 

In general, meta-bake.py pulls Yocto layers/recipes from public repositories, configures a Yocto build environment, and builds an image for a supported FPGA platform. The Yocto layer is always the first to be built, and includes the `bitbake` utility. The following table lists the remote repositories hosting Yocto meta data
source used by `meta-bake.py` and `create-linux-distro` as well as source code used for building binaries that make up the Linux image (kernel and rootfs).

**Note:** Not all repositories can be viewed in a web browser. All can be cloned using git. 

Repository | Description
-----------|------------
https://git.yoctoproject.org/git/poky.git | Base build tools and meta data layers
https://git.openembedded.org/meta-openembedded | Layers for OE-core packages
https://git.yoctoproject.org/git/meta-intel-fpga | Meta data layers for Intel FPGA SoC platforms
https://github.com/altera-opensource/meta-intel-fpga-refdes | BSP layer for Intel SoC FPGA GSRD
https://github.com/altera-opensource/linux-socfpga | Linux kernel source repository for socfpga
https://github.com/altera-opensource/u-boot-socfpga | u-boot bootloader source repository for socfpga
https://github.com/altera-opensource/arm-trusted-firmware.git | Source for ATF

Recipes in the *meta-intel-fpga-refdes* layer mostly inherit from and extend recipes in other layers.
The following table lists the new or modified recipes (in *meta-intel-fpga-refdes*) necessary to support an N6000/1 boot image.

Component | Recipe | Description
----------|--------|------------
Linux Kernel | recipes-kernel/linux/linux-socfpga-lts_5.10.bbappend | Recipe to append the GSRC SoC FPGA device tree to the Yocto build
U-Boot | recipes-bsp/u-boot/u-boot-socfpga_v2021.07.bbappend | Recipe to fetch and build socfpga U-Boot. Modified to support N6000/1 in u-boot. This also creates a shell script, *mkuboot-fit.sh.
copy-engine | recipes-bsp/copy-engine/copy-engine-0.1.bb | New recipe to build copy-engine daemon in rootfs.
N6000/1 Image | recipes-images/poky/n6000-image-minimal.bb | New recipe to create the N6000 image with copy-engine and linuxptp packages installed.

*mkuboot-fit.sh* is meant to be called after a Yocto build to create the u-boot FIT image for N6000. This is a workaround for the Yocto
build order which builds the bootloader (u-boot) before building the Linux image rootfs. Because the rootfs is part of the u-boot FIT
image, the rootfs must be built before building the bootloader. The result of calling this script is copying the rootfs (as a .cpio file)
to the u-boot source file tree and calling `make` in the u-boot build tree. When called again with the rootfs present, the resulting image
will contain the rootfs. This is performed automatically as a part of the `meta-bake.py` build flow.

See [here](https://www.yoctoproject.org) for more information regarding Yocto.
Several reference designs found in rocketboards.org use Yocto for building the Linux image and/or bootloader.
For the N6000 image and boot flow, the Yocto build
[script](https://releases.rocketboards.org/release/2021.04/gsrd/tools/create-linux-distro-release) for the
[Agilex SoC Golden System Reference Design](https://rocketboards.org/foswiki/Documentation/AgilexSoCGSRD) has
been adapted to automate building the boot loader, Linux Image, and filesystem needed to support the N6000 device.

<a name="heading-3.2.1"></a>

## 3.2.1 Building the Yocto Image

If you are creating a development environment using `meta-bake.py`, Yocto is automatically built. This section walks through the manual process of building Yocto.

Once the modified `create-linux-distro-release` has been downloaded, the N6000 u-boot FIT image can be built
following the example below. The `-f build` argument in this example is used to indicate the directory to use
for the Yocto workspace and artifacts. It is recommended that this location have at least 100Gb free. It is
important to note that any downloaded source file will be erased and downloaded again with every subsequent
invocation of this script.

```bash
./create-linux-distro-release -t agilex -f build -i n6000
```

All image files will be copied to *build/agilex-n6000-images*.
The *u-boot.itb* file to use for N6000 is *build/agilex-n6000-images/u-boot.itb*.
The FSBL will be in *build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig/spl/u-boot-spl-dtb.hex*.

**Note:** Although the directory contains `atf` (for ARM Trusted Firmware), the current U-Boot binaries built for Intel FPGA SmartNIC N6000/1
will not use ATF.

<a name="heading-3.2.2"></a>

## 3.2.2 Customing the Yocto image 

The following is a list or customizations made for building Yocto to run on the Intel FPGA SmartNIC N6000/1-PL platform.

### Extending the u-boot recipe

A recipe extension file (recipes-bsb/u-boot/u-boot-socfpga_v2021.07.bbappend) has been added to the *meta-intel-fpga-refdes* layer
that does the following:

- Adds patches using Yocto's patching mechanism
- Introduces a new u-boot config, *socfpga_agilex_n6000_defconfig*, and associates it with a keyword, `agilex-n6000`, that can be
referenced in Yocto configuration files. These patches are necessary until those changes are merged into the public u-boot-socfpga
repository. This config works for both Smartnic Platforms. 
- Creates *mkuboot-fit.sh* script file with variables for u-boot source and build directories that will get expanded
to the actual paths that Yocto uses for fetching/building u-boot.
Along with this recipe file, relevant patch files have been added. Once the changes are in the u-boot repository, the patches and
any references to them must be removed.

### Patching Linux Kernel

The kernel extension recipe, *meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts_5.10.bbappend*, in the *meta-intel-fpga-refdes* layer, has been
modified to add a patch file using Yocto's patching mechanism. This patch file adds the device tree for N6000 and is only
necessary until this change is merged into the public linux-socfpga repository.

### Adding Custom User Space Software

A new recipe, *meta-intel-fpga-refdes/recipes-bsp/copy-engine-0.1.bb* and relevant source files, have been added to the *meta-intel-fpga-refdes* layer.
This recipe includes instructions for building the copy-engine program as well as installing it as a systemd service.
Yocto will build this into an RPM package that gets installed into any image that includes it in the `IMAGE_INSTALL` variable.
This recipe may be used as a guide for installing additional user space software.

### Adding Kernel Driver Software

New recipes for custom kenel modules can be created at */build/meta-intel-fpga-refdes/recipes-kernel/linux/*, and instructed to include custom module code. These can be patched in, included as a part of a new branch, or included by default if upstreamed. For more information visit the YoctoProject's [Linux Kernel Development Manual](https://docs.yoctoproject.org/2.6/kernel-dev/kernel-dev.html). An example file from N6000 that can be used as an example is */build/meta-intel-fpga-refdes/recipes-kernel/linux/linux-socfpga-lts_5.10.bbappend*. 

### Creating an Image Type

A new recipe, *meta-intel-fpga-refdes/recipes-images/poky/n6000-image-minimal.bb*, has been added that includes directives to install the copy-engine
package (built in this layer) as well as the `linuxptp` package (available in other layers). In addition to including these
packages, this recipe includes a rootfs post processing command that removes the Linux kernel image files from the rootfs.
This is done because the Linux kernel is part of the u-boot FIT image and therefore not used from the rootfs. Removing this
redundant file reduces the final u-boot FIT image by about 30Kb. This recipe may be modified or used as a guide to add additional
user space software.

### Testing and Debugging

As mentioned previously, the script will erase source files every time it is executed. This means that any changes
made locally will be lost when the script is run again after making these changes. The example below shows how to
test local changes without executing the script again.

```bash
[user@localhost ]: cd build
[user@localhost ]: source poky/oe-init-build-env agilex-gsrd-rootfs/
[user@localhost ]: bitbake n6000-image-minimal
[user@localhost ]: ./agilex-n6000-rootfs/tmp/deploy/images/agilex/mkuboot-fit.sh
```

<a name="_Toc94083811"></a>

# 4.0 Booting the HPS

<a name="heading-4.1"></a>

## 4.1 Intel OFS FIM Boot Overview

This implementation of an FPGA First boot flow requires that the FSBL poll on a given register before continuing to boot the HPS. Once this register indicates it is (copy engine) ready, the FSBL loads a monolithic u-boot FIT image at a given offset 0x02000000 ( **Refer to section 4** Booting Intel OFS FIM for Intel Agilex FPGA).

This image is made up of the following components:

- U-boot bootloader also referred to as second stage bootloader
- Linux Kernel image
- Root filesystem (rootfs) consisting of kernel modules as well as user space software.

<a name="heading-4.2"></a>

## 4.2 Booting Intel OFS FIM for Intel Agilex FPGA

As mentioned before, this boot flow is an FPGA-first boot flow which requires that the Intel Agilex FPGA to be configured with the necessary components (SPL/FSBL, copyengine) in order for the HPS to boot.

SD/eMMC is not supported for FSBL for HPS first

- First Stage Bootloader (FSBL): u-boot-spl-dtb.hex is embedded into FPGA image
- Monolithic FIT Image Downloaded from Host, u-boot.itb contains the following components

    1) Second Stage Bootloader (SSBL): U-boot + U-boot Device Tree

    2) Linux kernel, Image, + Linux Device Tree

    3) Linux RAM based Root File System

- First Stage Bootloader (FSBL) is U-boot-spl
- U-boot-spl is built when u-boot is built
- Artifact is u-boot-spl-dtb.hex
  - The user has to check into build location : [ofs-dev/-/tree/master/syn/ofs\_ac/common/setup/u-boot-spl-dtb.hex](https://gitlab.devtools.intel.com/OFS/ofs-dev/-/tree/master/syn/ofs_ac/common/setup/u-boot-spl-dtb.hex)
  - Then run the command
  - quartus/pfg -c -o hps/path=u-boot-spl-dtb.hex orig.sof orig/fsbl.sof

Things to be taken care

    - The size of the u-boot.itb matters.
    - FIT is downloaded to [0x2000000](https://gitlab.devtools.intel.com/psg-opensource/uboot-socfpga/-/blob/socfpga_v2021.07_RC/configs/socfpga_agilex_n6010_defconfig)
    - Linux Device Tree and RootFS are unpacked to high memory
    - Linux is unpacked to an address specified in the FIT, [0xb600000](https://gitlab.devtools.intel.com/psg-opensource/uboot-socfpga/-/blob/socfpga_v2021.07_RC/arch/arm/dts/socfpga_agilex_n6010-u-boot.dtsi)
    - If size of u-boot.itb is greater than 0xb600000 – 0x2000000, then FIT will be corrupted mid extraction, resulting in unpredictable kernel crashes.

This example assumes the following preconditions have been met prior to booting HPS:

 1) A SOF file synthesized with the SPL (u-boot-spl-dtb.hex).

 2) Copy engine IP with relevant registers accessible to host and HPS.

Once the host FPGA boots with the required bitstream, the SPL in the HPS begins polling a register in the copy engine. One way to get an indication that the HPS is ready to continue past the SPL is to use a terminal emulator on a host with a serial cable connected to the FPGA&#39;s UART port. To transfer the u-boot FIT image, use the hps program with &#39;cpeng&#39; subcommand from the host. Note, the hps program can be installed as part of installing the OPAE SDK suite of packages.

`hps` command details can be found the below section.

As mentioned before, this boot flow is an FPGA-first boot flow which requires that the Agilex based FPGA be configured with
the necessary components (SPL/FSBL, copy-engine) in order for the HPS to boot.

<a name="heading-4.3"></a>

## 4.3 Example Boot

This example assumes the following preconditions have been met prior to booting HPS:

- A SOF file synthesized with the SPL (u-boot-spl-dtb.hex).
- Copy engine IP with relevant registers accessible to host and HPS.

Once the host FPGA boots with the required bitstream, the SPL in the HPS will begin polling a register in the copy engine.
One way to get an indication that the HPS is ready to continue past the SPL is to use a terminal emulator on a host with a
serial cable connected to the FPGA's UART port.

To transfer the u-boot FIT image, use the `hps` program with `cpeng` subcommand from the host.
Note, the `hps` program is installed as part of installing the OPAE SDK suite of packages.
See [here](https://github.com/OPAE/opae-sdk/tree/master/ofs/apps/cpeng#readme) for information on running the `hps` program.

```bash
[user@localhost ]: hps cpeng -f u-boot.itb
```

This will transfer the u-boot FIT image via the copy engine IP to the HPS DDR and then signal completion of the transfer to the
copy engine. Once the copy engine completes the actual transfer, it will write to the register the HPS SPL is polling on allowing
the SPL to load the u-boot bootloader which will in turn boot into the Linux image embedded in the u-boot FIT image.
If a terminal emulator is connected to the UART as described above, a user can observe u-boot and Linux running on the HPS. 

<a name="_Toc94083812"></a>

# 5.0 HPS Command Usage

<a name="_Toc94083813"></a>

## 5.1 Synopsis

<pre>hps OPTIONS SUBCOMMAND SUBCOMMAND\_OPTIONS</pre>

<a name="_Toc94083814"></a>

## 5.2 Description

hps is an application to aid in the development, deployment, and debugging of an HPS (hard processor system) on an Intel Agilex device using Intel OFS. The current version of the hps program assumes an AFU (accelerator functional unit) is configured into the FPGA that can be discovered/accessed through an OPAE library and used for communicating with the HPS. When invoked with one of its subcommands, hps will enumerate the AFU for that subcommand before executing it.

<a name="_Toc94083815"></a>

## 5.3 Options

<pre>-h,--help

Print this help message and exit

-p,--pci-address address

Use address in the filter for locating the AFU where address must be in

the following format: [domain]\bus\:\device\.\function\

-l,--log-level \level\

stdout logging level. Must be one of:

{trace,debug,info,warning,error,critical,off}

Default is info.

-s,--shared

open in shared mode, default is off

-t,--timeout timeout

Program timeout in milliseconds. Default is 60000.</pre>

<a name="_Toc94083816"></a>

## 5.4 Subcommands

<a name="_Toc94083817"></a>

### 5.4.1 cpeng

The copy engine command is used to program copy engine AFU registers to copy an image file from the host into the FPGA DDR.
When the HPS boots, the first stage boot loader loads an image
from a specific offset in DDR that will be used to transition into the second
stage boot loader and subsequently boot into the embedded Linux that is also
part of this image.

| cpeng  options | description |
----- | -----
-h,--help | Print this help message and exit
-f,--filename filename | Path to image file to copy. Default is u-boot.itb
-d,--destination offset | DDR Offset. Default is 0x2000000.
-t,--timeout cpeng timeout| Timeout of cpeng command in microseconds. Default is 1 sec (1000000 usec).
-r,--data-request-limit size| Can be 64, 128, 512, or 1024 and represents the PCIe request size in bytes that the copy engine IP will use. This is encoded to 0, 1, 2, or 3 and written to the copy engine DATA\REQUEST\LIMIT register. Default is 512.
-c,--chunk size| Split the copy into chunks of size size. 0 indicates no chunks. Chunk sizes must be aligned with data request limit. Default is 4096.
--soft-reset| Issue a soft reset only.
--skip-ssbl-verify| Do not wait for ssbl verify.
--skip-kernel-verify| Do now wait for kernel verify.

<a name="_Toc94083818"></a>

### 5.4.2 heartbeat

This subcommand reads the value in the HPS2HOST register
to check for a hearbeat. This compares the value to previous value
read and determines the HPS is alive if the value is incrementing.
This relies on the hps running the hello-cpeng program in &#39;heartbeat&#39;
mode which will increment the upper 16 bits in the HPS2HOST register.
Please see a typical sequence of using the rsu and hps commands as below for a device with BDF 15:00:0

``` bash
rsu fpga -p user1 15:00.0
sudo opae.io release -d 15:00.0
sudo opae.io init -d 15:00.4 root:root
hps cpeng -f u-boot-userkey-vab.itb
timeout 5 hps heartbeat
sudo opae.io release -d 15:00.0
hps cpeng -f u-boot-userkey-vab.itb
```

The above command will transfer the u-boot FIT image via the copy engine IP to the HPS DDR and then signal completion of the transfer to the copy engine. After the copy engine completes the actual transfer, it writes to the register the HPS SPL is polling on allowing the SPL to load the u-boot bootloader which in turn boots into the Linux image embedded in the u-boot FIT image. If a terminal emulator is connected to the UART as described above, a user can observe u-boot and Linux running on the HPS.

First FSBL is loaded and executed by FPGA configuration. Then Board/Server gets powered on. FPGA Configuration is done via JTAG followed by a reboot

The FSBL will send the following output the serial port:
``` bash
U-Boot SPL 2021.07-00312-g32c0556437 (Sep 17 2021 - 08:42:45 -0700)
Reset state: Cold
MPU 1200000 kHz
L4 Main 400000 kHz
L4 sys free 100000 kHz
L4 MP 200000 kHz
L4 SP 100000 kHz
SDMMC 50000 kHz
DDR: Warning: DRAM size from device tree (1024 MiB)
mismatch with hardware (2048 MiB).
DDR: 1024 MiB
SDRAM-ECC: Initialized success with 239 ms
waiting for host to copy image
```

<a name="heading-6.0"></a>

# 6.0 Using meta-bake.py


A script called *meta-bake.py* has been added to allow for more control of configuration/customization of recipes and their dependencies.
This script separates the data from the logic by requiring that data be expressed in a yaml configuration file. This file contains the
following confiration data:

- machine - The FPGA/SoC platform to build for, choices are agilex, stratix10, arria10, cyclone5
- image - The image type to build, choices are gsrd, nand, pcie, pr, qsqpi, sgmii, tse, n6000
- target - The build target to build. This is typically a Yocto image to build.
- fit - Make a monolothic FIT image after the Yocto build. This will use u-boot source and binaries as well as the rootfs made for the image.
- repos - A list of repositories to pull for Yocto recipes. This information is made up of:
  - name - The project name (this is also the directory where source is clone to)
  - url - The URL to pull the source from
  - branch - The branch to checkout
  - add_layers - Can be either True or a list of sub-directories to add as layers in bblayers.conf
  - patch - Path to a file to use to patch the source code
  - keep - When set to true, this will leave the source tree untouched on subsequent runs
- upstream_versions - Dependencies/versions to use for either Linux kernel, u-boot, and/or ATF. This information is made up of:
  - name - Project name
  - version - version to configure recipes that use it
  - branch - branch to use, will use git hash in recipe
  - url - URL to pull the source from
  - disabled - when set to True, this project will be ignored
- local - Used to configure local.conf used by Yocto/bitbake build. This information is made up of:
  - remove - List of keys to remove from local.conf
  - values - Dictionary of key/value pairs to use to insert into local.conf. Any existing key/value pairs will be overwritten.

### Quick Start ###

To create an u-boot fit image for N6000 platforms, run the following command after meeting these setup conditions:

- Host PC with Linux. Ubuntu 20.04, Centos 8, and RHEL 8.7 were used for the development of the N6000 image
  - ARM cross compiler
    - set CROSS_COMPILE environment variable to: <path to cross compiler>/bin/aarch64-linux-gnu-
        - e.x. export CROSS_COMPILE=aarch64-linux-gnu-
    - set ARCH to: arm64
        - e.x. export ARCH=arm64
- At least 100 Gb of disk space
- Tested on IOFS 3.0.0


```
>./meta-bake.py build
```

After running this build, the images you need to boot the HPS (following the steps in section [7.0 Bringing up the HPS](#heading-7.0)) are located under build/agilex-n6000-images. 

This script will do the following:
* Parse layers.yaml for configuration to use for build
* Download recipe repositories (including poky) listed in `repos` secion of layers.yaml
  * Apply refdes-n6000 patch to meta-intel-fpga-refdes source tree
* Configure Yocto build in build directory
  * Source build/poky/oe-init-build-env passing in agilex-n6000-rootfs. This will initialize conf files.
  * Configure build/agilex-n6000-rootfs/conf/local.conf using values in `local` section of layers.yaml
    * _Note_: IMAGE_FSTYPES is configured to include `cpio`
  * Configure build/agilex-n6000-rootfs/conf/bblayers.conf using layer specification in `repos` section of layers.yaml
* Run Yocto build for target listed in layers.conf
  * Call `bitbake n6000-image-minimal`
* Get environment variables to locate rootfs cpio file as well as u-boot source and build directories
* Copy rootfs created by Yocto build for u-boot
  * Copy rootfs cpio file (n6000-image-minimal-agilex*.rootfs.cpio) to u-boot build directory for selected configuration (socfpga_agilex_n6000_defconfig)
* Call u-boot build in directory for selected configuration
* Copy FIT image (u-boot.itb) to images directory, build/agilex-n6000-images
  * Many important images are copied to *build/agilex-n6000-images*, which may be useful if using VAB

## Required Changes ##
The patch file applied on top of the meta-intel-fpga-refdes repository introduces patches to:
* Add patch files so that Yocto can modify Linux kernel to add configuration for creating a device tree binary (DTB) compatible with N6000
* Add patch files so that Yocto can modify the bootloader in u-boot to support booting with the assistance of the copy engine IP
* Modify rootfs to include copy-engine daemon as well as other packages that can be useful for debug

These changes may eventually be merged into upstream repositories for Linux socfpga, u-boot socfpga, and meta-intel-fpga-rerdes.
Once all changes make their way into the repositories for the aforementioned projects, it will no longer be necessary to apply patches.

## Manual Build ##

One may use meta-bake.py to only pull down required repositories and configure a Yocto build environment by using the --skip-build command line argument.
To initiate a build after this, source poky/oe-init-build-env passing in a directory as the only argument.
This will set up the user's environment to be able to run bitbake.
To build the Yocto image, run `bitbake n6000-image-minimal`.
This will build all the components necessary to build a FIT image.
Once the build is complete, u-boot make system may be used to make the FIT.
The u-boot build directory for the selected configuration can be found in the Yocto build environment directory at:
``` bash
> cd tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig
```
Once in this directory, ensure that the necessary files are present in here in order to assemble the FIT image (u-boot.itb)
```bash
> cp ../../../../../../deploy/images/agilex/n6000-image-minimal-agilex.cpio rootfs.cpio
> ls Image linux.dtb rootfs.cpio
Image  linux.dtb  rootfs.cpio
> make
```

## Manual VAB Signing ##

- By default, `meta-bake.py` will sign and certify the proper files for use with VAB. Below is an example on how to perform the manual [VAB Signing Process](https://rocketboards.org/foswiki/Documentation/IntelAgilexSoCSecureBootDemoDesign#:~:text=5.%20Generate%20Signature,qky/software0_cancel3.qky).

Make sure Quartus already installed and its tools added to environment. Example PATH=$PATH:/home/intelFPGA\pro/21.3/quartus/bin/

``` bash
cd HPS_VAB

quartus_sign --family=agilex --operation=make_private_pem --curve=secp384r1 --no_passphrase userkey_root_private.pem

quartus_sign --family=agilex --operation=make_public_pem userkey_root_private.pem userkey_root_public.pem

quartus_sign --family=agilex --operation=make_rootuserkey_root_public.pem userkey_root_public.qky

chmod +x fcs_prepare

./fcs_prepare --hps_cert bl31.bin -v

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_cert_bl31.bin.ccert

# ATF Sign

./fcs_prepare --finish signed_cert_bl31.bin.ccert --imagefile bl31.bin
mv hps_image_signed.vab signed-bl31.bin
rm unsigned_cert.ccert

# u-boot-nodtb

./fcs_prepare --hps_cert u-boot-nodtb.bin -v

#signed_u-boot-nodtb.bin.ccert

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_u-boot-nodtb.bin.ccert

# u-boot-nodtb.bin Sign

./fcs_prepare --finish signed_u-boot-nodtb.bin.ccert --imagefile u-boot-nodtb.bin
mv hps_image_signed.vab signed-u-boot-nodtb.bin
rm unsigned\_cert.ccert

# u-boot.dtb

./fcs_prepare --hps_cert u-boot.dtb -v

#signed_u-boot.dtb.ccert

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_u-boot.dtb.ccert

# u-boot.dtb Sign

./fcs_prepare --finish signed_u-boot.dtb.ccert --imagefile u-boot.dtb
mv hps_image_signed.vab signed-u-boot.dtb
rm unsigned_cert.ccert

# Image

./fcs_prepare --hps/cert Image -v

#signed_Image.ccert

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_Image.ccert

# Image Sign

./fcs_prepare --finish signed_Image.ccert --imagefile Image
mv hps_image_signed.vab signed-Image
rm unsigned_cert.ccert

# linux.dtb

./fcs_prepare --hps_cert linux.dtb -v

#signed_linux.dtb.ccert

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_linux.dtb.ccert

# linux.dtb Sign

./fcs_prepare --finish signed_linux.dtb.ccert --imagefile linux.dtb
mv hps_image_signed.vab signed-linux.dtb
rm unsigned_cert.ccert

# rootfs.cpio

./fcs_prepare --hps_cert rootfs.cpio -v

#signed_rootfs.cpio.ccert

quartus_sign --family=agilex --operation=SIGN --qky=userkey_root_public.qky --pem=userkey_root_private.pem unsigned_cert.ccert signed_rootfs.cpio.ccert

# rootfs.cpio

./fcs_prepare --finish signed_rootfs.cpio.ccert --imagefile rootfs.cpio
mv hps_image_signed.vab signed-rootfs.cpio
rm unsigned_cert.ccert
```

copy the following to u-boot-socfpga folder:-

``` bash
#Copy the image back to uboot folder
cp signed-bl31.bin ../u-boot-socfpga/
cp signed-u-boot-nodtb.bin ../u-boot-socfpga/
cp signed-u-boot.dtb ../u-boot-socfpga/
cp signed-Image ../u-boot-socfpga/
cp signed-linux.dtb ../u-boot-socfpga/
cp signed-rootfs.cpio ../u-boot-socfpga/
```
Recompile the u-boot

``` bash
$ git clone https://github.com/altera-opensource/u-boot-socfpga
$ cd u-boot-socfpga
$ export CROSS\COMPILE=aarch64-none-linux-gnu-; export ARCH=arm
$ make socfpga/agilex/n6000/vab/defconfig
$ make -j 24
$ cd ..

```
**Figure 3.1 N6000 Configs**

![](ug_images/Image4.png)

If you not see the defconfig desire, please checkout the correct branch version. Example above is socfpga_v2021.10.

If the memory device tree it mismatches with your hardware (figure below), change the memory device tree at u-boot-socfpga/arch/arm/dts/socfpga_agilex_n6000-u-boot.dtsi

To make it 2GB, change as

```
memory {

\* 2GB \*

reg = <0 0x00000000 0 0x40000000>,<0 0x00000000 0 0x40000000>;

};
```
**Figure 3.2 Device tree mismatches example**

![](ug_images/Image5.png)

Refer to 6. Host Side Startup

``` bash
sudo opae.io init -d 4b:00.4 root:root
hps cpeng -f u-boot.itb
timeout 5 hps heartbeat
```
The error happen (Figure below) when the Images do not sign with VAB.

**Figure 3.3 VAB certificate error example**

![](ug_images/Image6.png)

<a name ="heading-7.0"></a>

# 7.0 Bringing up the HPS

1. Bind vfio-pci driver to Copy Engine PCIe Physical Function

     <pre>opae.io init -d b1:00.4 root</pre>

2. Run the following command to load image and boot linux on HPS:

     <pre>hps cpeng -f u-boot.itb</pre>

Output:
``` bash
[2021-09-25 01:59:25.538] [cpeng] [info] starting copy of file:u-boot.itb, size: 116725656, chunk size: 4096
[2021-09-25 01:59:29.935] [cpeng] [info] last chunk 1944, aligned 2048
[2021-09-25 01:59:29.935] [cpeng] [info] transferred file in 28498 chunk(s)
[2021-09-25 01:59:29.935] [cpeng] [info] waiting for ssbl verify...
[2021-09-25 01:59:33.848] [cpeng] [info] ssbl verified
[2021-09-25 01:59:33.848] [cpeng] [info] waiting for kernel verify...
[2021-09-25 01:59:39.626] [cpeng] [info] kernel verified
```
3. Hps command can be used to monitor Keep-alive from HPS:

     <pre>hps heartbeat</pre>

Output:
``` bash
[2021-09-25 01:59:42.722] [heartbeat] [info] heartbeat value: 0x30015
[2021-09-25 01:59:43.722] [heartbeat] [info] heartbeat value: 0x40015
[2021-09-25 01:59:44.722] [heartbeat] [info] heartbeat value: 0x50015
[2021-09-25 01:59:45.723] [heartbeat] [info] heartbeat value: 0x60015
[2021-09-25 01:59:46.723] [heartbeat] [info] heartbeat value: 0x70015
```
4. Login to HPS as user, root, with no password over serial connection. This process is covered in section **8.1 Connecting to remotely to the HPS using `ssh`**. The terminal will come up as given below:
``` bash
agilex login: root

root@agilex:~# ls

root@agilex:~# ls /

bin dev home lib mnt root sbin sys usr

boot etc init media proc run srv tmp var

root@agilex:~#
```
<a name="_Toc94083819"></a>

# 8.0 Debugging

Debugging the HPS from the host side is standard HPS debugging. The primary debug tool is UART on the HPS and Arm\* DS-5 debugger.

A UART connection can be enabled on the board using the following procedure:

1. Connect the HPS Debug Card and HPS UART to the Intel N6000-PL FPGA SmartNIC Platform board

2. Open Putty with the following setting
```
    Port:COM4

    Baudrate:115200

    Data bits : 8

    Stop bits : 1

    Parity : None

    Flow Control : None
```
3. Reboot the Intel N6000-PL FPGA SmartNIC Platform board by typing &quot;reboot&quot; in the shell. You will be able to see the HPS UART traffic in the putty. If any issues are encountered in this step, check the HPS UART connection and the UART driver.

4. Check the PCI bdf ( **lspci | grep acc** ) or **fpgainfo fme** at the shell prompt.

5. Run the rsu and fpga\reconfig scripts with respective arguments to print the logs.

<a name="heading-9.0"></a>

# 9.0 Software Example - Adding helloworld to rootfile system ##

``` bash

> cd meta-intel-fpga-refdes/
> mkdir recipe-example
> mkdir helloworld
> cd helloworld
> nano helloworld.bb
```

Write the helloworld.bb with below script and save.

``` bash
SUMMARY = "Example hello world" DESCRIPTION = "helloworld in HPS"
AUTHOR = "mabdrahi <mohamad.aliff.abd.rahim@intel.com>"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit systemd pkgconfig

SRC_URI = "file://helloworld.c"

S = "${WORKDIR}"

do_compile() {
        ${CC} ${CFLAGS} ${LDFLAGS} helloworld.c -o helloworld
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 helloworld ${D}${bindir}
}
```

``` bash
> cd  meta-intel-fpga-refdes/recipes-images/poky
> nano n6000-image-minimal.bb
```

Add the **helloworld** to this file and save

``` bash

require recipes-core/images/core-image-base.bb
require core-image-essential.inc

IMAGE_INSTALL += "packagegroup-common-essential"
IMAGE_INSTALL += "packagegroup-network-essential"
IMAGE_INSTALL += "packagegroup-core-ssh-openssh"

IMAGE_INSTALL += "copy-engine-0.1"
IMAGE_INSTALL += "linuxptp"
IMAGE_INSTALL += "minicom"

IMAGE_INSTALL += "helloworld"

export IMAGE_BASENAME = "n6000-image-minimal"

ROOTFS_POSTPROCESS_COMMAND += "remove_image; "
remove_image() {
        rm ${IMAGE_ROOTFS}/boot/Image*
        echo "cpio: ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}-${MACHINE}.cpio" >> ${DEPLOY_DIR_IMAGE}/uboot-cfg.yaml
}
```

``` bash

> cd build/agilex-n6000-rootfs/tmp/work/agilex-poky-linux/u-boot-socfpga/1_v2021.07+gitAUTOINC+24e26ba4a0-r0/build/socfpga_agilex_n6000_defconfig
> make clean
> rm -rf rootfs.cpio
```

Now compile the build directory

``` bash
> meta-bake.py build
```

Another example of a C program compiled and run on the HPS as a daemonized process can be found at location `meta-intel-fpga-refdes/recipes-bsp/cope-engine`. A reference for the individual tasks Yocto can be asked to complete as a part of the execution of BitBake recipes can be found on the [YoctoProject site](https://docs.yoctoproject.org/ref-manual/tasks.html).

<a name="heading-10.0"></a>

## 10.0 Connecting remotely to the HPS using `ssh` ##

The HPS running on the Intel FPGA PAC N6000-PL SmartNIC Platform can be remotely accessed to via the utility `ssh`, allowing the user to run commands and copy files. SSH must be run over a Point-To-Point Protocol daemon that has been included in the HPS software (as a part of the *meta-openembedded* layer, in the *recipes-daemons/ippool* recipe). In this example, the HPS is set up as a PPP Server, and the host OS is set up as a PPP Client. Serial communication between the host and HPS is accomplished via HPS UART1, which communicates through the FIM to the Soft UART on the FPGA, who in turn communicates with the host over PCIe.

The following steps assume the SSBL has not yet been loaded onto the HPS. If it has, a cold boot will reset the system.

1. The HPS Copy Engine Module is available for access on PF 4 via the PF/VF Mux on the FPGA. This port needs to be bound to driver `vfio-pci` (the following example assumes PCIE BDF 0000:b1:00.0). Substitute your device's BDF address and desired user/group access permissions into the following command.

```bash
[user@localhost ]: sudo opae.io init -d 0000:b1:00.4 <USER>[:<GROUP>]
Unbinding (0x8086,0xbcce) at 0000:b1:00.4 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.4 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.4 is 190
Assigning /dev/vfio/190 to DCPsupport
Changing permissions for /dev/vfio/190 to rw-rw----
```

2. When an HPS enabled SOF or BIN with the FSBL is loaded onto the FPGA, a message will be displayed on the host OS (seen via `dmesg`) after boot once the serial port has been registered with the dfl-uart driver. The UART driver is included as a part of the linux-dfl driver package. An example output from `dmesg` is shown below (search dmesg using `dmesg | grep dfl-uart`):

```bash
[    7.343014] dfl-uart dfl_dev.7: serial8250_register_8250_port 2
```

The device file that corresponds with serial UART port 2 is `/dev/ttyS2` (format is `/dev/ttyS<port number>`). A serial communication program can be used to view the HPS boot in realtime, then log in and run commands when boot has completed. Minicom is the program that will be used in this example, although others will work. Install Minicom using DNF `sudo dnf install minicom`. 

3. Minicom requires configuration changes before it can listen to the serial device. Using the built-in menu accessed by `sudo minicom -s`, ensure the information under "Serial port setup" matches the following, where the serial device corresponds with the serial port discussed previously:

```bash 
 +-----------------------------------------------------------------------+
    | A -    Serial Device      : /dev/ttyS2                                |
    |                                                                       |
    | C -   Callin Program      :                                           |
    | D -  Callout Program      :                                           |
    | E -    Bps/Par/Bits       : 115200 8N1                                |
    | F - Hardware Flow Control : Yes                                       |
    | G - Software Flow Control : No                                        |
    |                                                                       |
    |    Change which setting?                                              |
    +-----------------------------------------------------------------------+
```

4. Save and exit the configuration menu. Run Minicom using the command `sudo minicom` and keep the terminal open and connected.

5. Load the SSBL onto the HPS using a second terminal. This requires a built ITB image.

```bash
[user@localhost ]: hps cpeng -f u-boot.itb
```

6. You should see the HPS boot sequence continue through your Minicom terminal. Once boot has completed, log in using the user `root` with an empty password.

```bash
...
...
...
[  OK  ] Finished Load/Save Random Seed.
[  OK  ] Finished OpenSSH Key Generation.

Poky (Yocto Project Reference Distro) 3.3.6 agilex ttyS0

agilex login: root
root@agilex:~#
```

7. Configure the running Yocto image on the HPS as a PPP server. Run the following command through Minicom on the HPS (connects address 192.168.250.2 on the HPS to 192.168.250.1 on the host):

```bash
root@agilex:~# pppd noauth passive 192.168.250.1:192.168.250.2
[  410.465450] PPP generic driver version 2.4.2
...
```

8. Exit the Minicom program running on the host using `^A X`. Execute the following command on the host to establish a PPP connection as the client (if not installed on the host, run `sudo dnf install ppp`):

```bash
[user@localhost ]: sudo pppd ttyS2 115200 crtscts lock local noauth passive debug
```

9. A new network interface device registered to ppp should be visible.

```bash
[user@localhost ]: ip -4 addr
...
8: ppp0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 3
    inet 192.168.250.2 peer 192.168.250.1/32 scope global ppp0
       valid_lft forever preferred_lft forever

```

With both the client and server communicating, `ssh` and `scp` can be used to run commands and transfer files using IPv4 address 192.168.250.1 on the host. An example operation run on the host OS is shown below:

```bash
[user@localhost ]: scp file_package.tar.gz root@192.168.250.1
```

**Note:** If you are developing software for the HPS and altering system settings, it is possible for `ssh` to prohibit a connection due to a false man-in-the-middle attack warning. The flag `<ssh/scp> -o StrictHostKeyChecking=no` can be used to ignore the warning. 

<a name="heading-layersyaml"></a>

## layers.yaml Reference ##

```yaml
machine: agilex
image: n6000
target: n6000-image-minimal
fit: true
repos:
  - name: poky
    url: https://git.yoctoproject.org/git/poky.git
    branch: hardknott
  - name: meta-intel-fpga
    url: https://git.yoctoproject.org/git/meta-intel-fpga.git
    branch: hardknott
    add_layers: true
  - name: meta-intel-fpga-refdes
    url: https://github.com/intel-innersource/os.linux.yocto.reference-design.meta-intel-fpga-refdes
    branch: hardknott
    patch: refdes-n6000.patch
    keep: true
    add_layers: true
  - name: meta-openembedded
    url: git://git.openembedded.org/meta-openembedded.git
    branch: hardknott
    add_layers:
      - meta-oe
      - meta-networking
      - meta-python
upstream_versions:
  linux:
    name: linux-socfpga
    version: '5.10.50'
    branch: socfpga-5.10-lts
    url: https://github.com/altera-opensource/linux-socfpga.git
  uboot:
    name: u-boot-socfpga
    version: '2021.07'
    branch: socfpga_v2021.07
    url: https://github.com/altera-opensource/u-boot-socfpga.git
  atf:
    disabled: true
    version: '2.4.1'
    branch: socfpga_v2.4.1
    url: https://github.com/altera-opensource/arm-trusted-firmware.git
local:
  remove:
    - MACHINE
    - UBOOT_CONFIG
    - IMAGE
    - SRC_URI
  values:
    MACHINE: $machine
    DL_DIR: $build_dir/downloads
    DISTRO_FEATURES_append: " systemd"
    VIRTUAL-RUNTIME_init_manager: systemd
    IMAGE_TYPE: $image
    IMAGE_FSTYPES: "+=cpio tar.gz"
    PREFERRED_PROVIDER_virtual/kernel: linux-socfpga-lts
    PREFERRED_VERSION_linux-socfpga-lts: 5.10%
    UBOOT_CONFIG: agilex-n6000
    PREFERRED_PROVIDER_virtual/bootloader: u-boot-socfpga
    PREFERRED_VERSION_u-boot-socfpga: v2021.07%
```

<a name="_Toc94083821"></a>

# FAQs

Below are the Frequently Asked Questions:

1. How will you get the software stack for HPS (FSBL, U-Boot, Kernel)? Or will there be a package available to them on Git, Intel RDC?

    **Answer** : HPS software has been around for quite a long time. Support for the Intel OFS and the N6000-PL FPGA SmartNIC Platform will be upstreamed and available from rocketboards.com, just like any other HPS based project.

2. What are the recommended steps for building the binaries and where will those be located?

    **Answer:** There are many documents on building the binaries at rocketboards.com. Any reference binaries can be stored at rocketboards.com as well.

3. What are the host side commands used to put the binaries to Copy Engine and from there to HPS?

    **Answer:** There is a single command, hps to download the single binary through the Copy Engine to the HPS.

4. What are the host side commands used to reset the HPS from Host side?

    **Answer:** This functionality is planned to be added to the hps command.

5. What is the procedure used to debug the HPS from Host side?

    **Answer:** Debugging the HPS from the host side is standard HPS debugging. The primary debug tool is UART on the HPS and the Arm\* DS debugger.

6. Do we have performance metrics about HPS, like whether any bench marking information available with any sample application is available?

    **Answer:** Any performance metrics on the HPS would be available on rocketboards.com.

7. What is the PXE boot flow and what is required to enable the same?

    **Answer:** On some configurations, HPS is treated as a fully-fledged SoC and can PXE boot itself. But you must add this functionality.


<a name="heading-docrev"></a>

# Document Revision History

| **Document Version** | **Changes** |
| --- | --- |
| 2022.03.03 | Clarified text in some sections, document reorganization |
| 2022.07.31 | Added detail for establishing a Host-side debug session over PCIe in section <b>8.1 Connecting remotely to the HPS using `pppd`.</b>|
| 2022.01.18 | Added detailed steps for debugging and addressed review comments like adding Glossary |
| 2021.10.28 | Updated the Boot flow and added new tables. |
| 2021.09.30 | Initial release. |
