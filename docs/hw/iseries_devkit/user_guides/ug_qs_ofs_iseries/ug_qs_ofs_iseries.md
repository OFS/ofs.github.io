# Getting Started Guide: Open FPGA Stack for Intel Agilex 7 FPGAs Targeting the Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile)

Last updated: **March 20, 2024** 

## 1.0 About This Document

The purpose of this document is to help users get started in evaluating the 2024.1 version of the PCIe Attach release targeting the I-Series Development Kit. After reviewing this document, a user shall be able to:

* Set up a server environment according to the Best Known Configuration (BKC)
* Load and verify firmware targeting the FIM and AFU regions of the Agilex FPGA
* Verify full stack functionality offered by the PCIe Attach OFS solution
* Learn where to find additional information on other PCIe Attach ingredients

### 1.1 Audience

The information in this document is intended for customers evaluating the PCIe Attach shell targeting Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile). This platform is a Development Kit intended to be used as a starting point for evaluation and development.

*Note: Code command blocks are used throughout the document. Commands that are intended for you to run are preceded with the symbol '$', and comments with '#'. Full command output may not be shown.*

#### Table 1: Terminology

| Term                      | Abbreviation | Description                                                  |
| :------------------------------------------------------------:| :------------:| ------------------------------------------------------------ |
|Advanced Error Reporting	|AER	|The PCIe AER driver is the extended PCI Express error reporting capability providing more robust error reporting. [(link)](https://docs.kernel.org/PCI/pcieaer-howto.html?highlight=aer)|
|Accelerator Functional Unit	|AFU	|Hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance. Note: An AFU region is the part of the design where an AFU may reside. This AFU may or may not be a partial reconfiguration region.|
|Basic Building Block	|BBB|	Features within an AFU or part of an FPGA interface that can be reused across designs. These building blocks do not have stringent interface requirements like the FIM's AFU and host interface requires. All BBBs must have a (globally unique identifier) GUID.|
|Best Known Configuration	|BKC	|The software and hardware configuration Intel uses to verify the solution.|
|Board Management Controller|	BMC	|Supports features such as board power managment, flash management, configuration management, and board telemetry monitoring and protection. The majority of the BMC logic is in a separate component, such as an Intel® Max® 10 or Intel Cyclone® 10 device; a small portion of the BMC known as the PMCI resides in the main Agilex FPGA.
|Configuration and Status Register	|CSR	|The generic name for a register space which is accessed in order to interface with the module it resides in (e.g. AFU, BMC, various sub-systems and modules).|
|Data Parallel C++	|DPC++|	DPC++ is Intel’s implementation of the SYCL standard. It supports additional attributes and language extensions which ensure DCP++ (SYCL) is efficiently implanted on Intel hardware.
|Device Feature List	|DFL	| The DFL, which is implemented in RTL, consists of a self-describing data structure in PCI BAR space that allows the DFL driver to automatically load the drivers required for a given FPGA configuration. This concept is the foundation for the OFS software framework. [(link)](https://docs.kernel.org/fpga/dfl.html)|
|FPGA Interface Manager	|FIM|	Provides platform management, functionality, clocks, resets and standard interfaces to host and AFUs. The FIM resides in the static region of the FPGA and contains the FPGA Management Engine (FME) and I/O ring.|
|FPGA Management Engine	|FME	|Performs reconfiguration and other FPGA management functions. Each FPGA device only has one FME which is accessed through PF0.|
|Host Exerciser Module	|HEM	|Host exercisers are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc.|
|Input/Output Control|	IOCTL	|System calls used to manipulate underlying device parameters of special files.|
|Intel Virtualization Technology for Directed I/O	|Intel VT-d	|Extension of the VT-x and VT-I processor virtualization technologies which adds new support for I/O device virtualization.|
|Joint Test Action Group	|JTAG	| Refers to the IEEE 1149.1 JTAG standard; Another FPGA configuration methodology.|
|Memory Mapped Input/Output	|MMIO|	The memory space users may map and access both control registers and system memory buffers with accelerators.|
|oneAPI Accelerator Support Package	|oneAPI-asp	|A collection of hardware and software components that enable oneAPI kernel to communicate with oneAPI runtime and OFS shell components. oneAPI ASP hardware components and oneAPI kernel form the AFU region of a oneAPI system in OFS.|
|Open FPGA Stack	|OFS|	OFS is a software and hardware infrastructure providing an efficient approach to develop a custom FPGA-based platform or workload using an Intel, 3rd party, or custom board. |
|Open Programmable Acceleration Engine Software Development Kit|	OPAE SDK|	The OPAE SDK is a software framework for managing and accessing programmable accelerators (FPGAs). It consists of a collection of libraries and tools to facilitate the development of software applications and accelerators. The OPAE SDK resides exclusively in user-space.|
|Platform Interface Manager	|PIM|	An interface manager that comprises two components: a configurable platform specific interface for board developers and a collection of shims that AFU developers can use to handle clock crossing, response sorting, buffering and different protocols.|
|Platform Management Controller Interface|	PMCI|	The portion of the BMC that resides in the Agilex FPGA and allows the FPGA to communicate with the primary BMC component on the board.|
|Partial Reconfiguration	|PR	|The ability to dynamically reconfigure a portion of an FPGA while the remaining FPGA design continues to function. For OFS designs, the PR region is referred to as the pr_slot.|
|Port|	N/A	|When used in the context of the fpgainfo port command it represents the interfaces between the static FPGA fabric and the PR region containing the AFU.|
|Remote System Update|	RSU	|The process by which the host can remotely update images stored in flash through PCIe. This is done with the OPAE software command "fpgasupdate".|
|Secure Device Manager	|SDM|	The SDM is the point of entry to the FPGA for JTAG commands and interfaces, as well as for device configuration data (from flash, SD card, or through PCI Express* hard IP).|
|Static Region|	SR	|The portion of the FPGA design that cannot be dynamically reconfigured during run-time.|
|Single-Root Input-Output Virtualization|	SR-IOV	|Allows the isolation of PCI Express resources for manageability and performance.|
|SYCL	|SYCL|	SYCL (pronounced "sickle") is a royalty-free, cross-platform abstraction layer that enables code for heterogeneous and offload processors to be written using modern ISO C++ (at least C++ 17). It provides several features that make it well-suited for programming heterogeneous systems, allowing the same code to be used for CPUs, GPUs, FPGAs or any other hardware accelerator. SYCL was developed by the Khronos Group, a non-profit organization that develops open standards (including OpenCL) for graphics, compute, vision, and multimedia. SYCL is being used by a growing number of developers in a variety of industries, including automotive, aerospace, and consumer electronics.|
|Test Bench	|TB	|Testbench or Verification Environment is used to check the functional correctness of the Design Under Test (DUT) by generating and driving a predefined input sequence to a design, capturing the design output and comparing with-respect-to expected output.|
|Universal Verification Methodology	|UVM	|A modular, reusable, and scalable testbench structure via an API framework.  In the context of OFS, the UVM enviroment provides a system level simulation environment for your design.|
|Virtual Function Input/Output	|VFIO	|An Input-Output Memory Management Unit (IOMMU)/device agnostic framework for exposing direct device access to userspace. (link)|


#### Table 2: Software and Component Version Summary for OFS PCIe Attach targeting the I-Series Development Kit

The OFS 2024.1 PCIe Attach release is built upon tightly coupled software and Operating System version(s). The repositories listed below are used to manually build the Shell and the AFU portion of any potential workloads. Use this section as a general reference for the versions which compose this release. Specific instructions on building the FIM or AFU are discussed in their respective documents.

| Component | Version |
| ----- | -----  |
| Quartus | https://www.intel.com/content/www/us/en/software-kit/794624/intel-quartus-prime-pro-edition-design-software-version-23-4-for-linux.html, patches: 0.17 patch (PCIe) |
| Host Operating System | https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.6/x86_64/product-software |
| OneAPI-ASP | https://github.com/OFS/oneapi-asp/releases/tag/ofs-2024.1-1, patches: 0.02 |
| OFS Platform AFU BBB  | https://github.com/OFS/ofs-platform-afu-bbb/releases/tag/ofs-2024.1-1|
| OFS FIM Common Resources| https://github.com/OFS/ofs-fim-common/releases/tag/ofs-2023.3-2 |
| AFU Examples | https://github.com/OFS/examples-afu/releases/tag/ofs-2023.3-2 |
| OPAE-SIM | https://github.com/OPAE/opae-sim |


#### Table 3: Programmable Firmware Version Summary for OFS PCIe Attach Targeting the I-Series Development Kit

OFS releases include pre-built binaries for the FPGA, OPAE SDK and Linux DFL which can be programmed out-of-box (OOB) and include known identifiers shown below. Installation of artifacts provided with this release will be discussed in their relevant sections.

| Component | Version| Link |
| ----- | ----- | ----- |
| FIM (shell) | Pr Interface ID: TBD  | https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1 |
| Host OPAE SDK| https://github.com/OPAE/opae-sdk, tag: 2.12.0-4| https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4 |
| Host Linux DFL Drivers| https://github.com/OPAE/linux-dfl, tag: ofs-2024.1-6.1-2 | https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2|

#### Table 4: Hardware BKC for OFS PCIe Attach

The following table highlights the hardware which composes the Best Known Configuation (BKC) for the OFS 2024.1 PCIe Attach release. The Intel FPGA Download Cable II is not required when using the I Series Dev Kit, as the device has an on-board blaster.

| Component | Link |
| ----- | ----- |
| Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile) | https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agi027.html |
| (optional) Intel FPGA Download Cable II| https://www.intel.com/content/www/us/en/products/sku/215664/intel-fpga-download-cable-ii/specifications.html|

### 1.2 Board Installation and Server Settings

Instructions detailing the board installation guidelines for an I-Series Dev Kit including server BIOS settings and regulatory information can be found in the [Board Installation Guidelines: Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) and Intel Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile)](../../../common/board_installation/devkit_board_installation/devkit_board_installation_guidelines.md). This document also covers the installation of a JTAG cable, which is required for shell programming.

### 1.3 I-Series Development Kit JTAG Setup

A specific JTAG driver needs to be installed on the host OS. Follow the instructions under the driver setup for Red Hat 5+ on [Intel® FPGA Download Cable (formerly USB-Blaster) Driver for Linux*](https://www.intel.com/content/www/us/en/support/programmable/support-resources/download/dri-usb-b-lnx.html).

View the JTAG Chain after installing the proper driver and Quartus 23.3

```bash
cd ~/intelFPGA_pro/quartus/bin
./jtagconfig -D
1) AGI FPGA Development Kit [1-13]
   (JTAG Server Version 23.3.0 Build 104 09/20/2023 SC Pro Edition)
  034BB0DD   AGIB027R29A(.|R2|R3)/.. (IR=10)
  020D10DD   VTAP10 (IR=10)
    Design hash    27AA3E0B7CE0A5B9F366
    + Node 08586E00  (110:11) #0
    + Node 0C006E00  JTAG UART #0
    + Node 19104600  Nios II #0
    + Node 30006E02  Signal Tap #2
    + Node 30006E01  Signal Tap #1
    + Node 30006E00  Signal Tap #0

  Captured DR after reset = (0069761BB020D10DD) [65]
  Captured IR after reset = (000D55) [21]
  Captured Bypass after reset = (2) [3]
  Captured Bypass chain = (0) [3]
  JTAG clock speed auto-adjustment is enabled. To disable, set JtagClockAutoAdjust parameter to 0
  JTAG clock speed 24 MHz
```

### 1.5 Upgrading the I-Series Development Kit FIM via JTAG

Intel provides a pre-built FIM that can be used out-of-box for platform bring-up. This shell design is available on the [OFS 2024.1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1). After programming the shell and installing both the OPAE SDK and Linux DFL kernel drivers as shown in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](../../../common/sw_installation/pcie_attach/sw_install_pcie_attach.md), you can confirm the correct FIM has been configured by checking the output of `fpgainfo fme` against the following table:

#### Table 5: FIM Version

|Identifier|Value|
|-----|-----|
|Pr Interface ID|5bcd682f-5093-5fc7-8cd2-ae8073e19452 (TBD)|
|Bitstream ID|TBD|

1. Download and unpack the artifacts from [the 2024.1 release page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2024.1-1/iseries-dk-images.tar.gz). The file `ofs_top_hps.sof` is the base OFS FIM file. This file is loaded into the FPGA using the development kit built in USB Blaster. Please be aware this FPGA is not loaded into non-volatile storage, therefore if the server is power cycled, you will need to reload the FPGA .sof file.

    ```bash
    wget https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2024.1-1/iseries-dk-images.tar.gz
    tar xf iseries-dk-images.tar.gz
    cd iseries-dk-images/
    
    ```

2. Remove the card from the PCIe bus to prevent a surprise link down. This step is not necessary if no image is currently loaded.
    
    ```bash
    sudo pci_device <PCIe BDF> unplug
    ```

3. Start the Quartus Prime Programmer GUI interface, `quartus_pgmw &`, located in the `bin` directory of your Quartus installation. Select "Hardware Setup", double click the AGI FPGA Development Kit hardware item and change the hardware frequency to 16MHz.

    ![QProgrammer Hardware Setup](./images/iseries_qprogrammer_hardwaresetup.png)

4. On the home screen select "Auto Detect" and accept the default device.

5. Left click on the line for device AGIB027R29A (the Agilex device) and hit "Change File". Load ofs_top.sof from the artifacts directory and check "Program / Configure". Hit start.

    ![QProgrammer Auto Detect](./images/iseries_qprogrammer_autodetect.png)

6. Re-add the card to the PCIe bus. This step is not necessary if no image was loaded beforehand.

    ```bash
    sudo pci_device <BDF> plug
    ```

7. If this is the first time you've loaded an image into the board, you will need to restart (warm boot) the server (not power cycle / cold boot).

8. Verify the PR Interface ID for your image matches expectation. When loading a FIM from the pre-compiled binary included in the artifacts archive, this ID will match the one listed in [Table 5](#table-5-hardware-bkc-for-ofs-pcie-attach).

## 2.0 OFS Stack Architecture Overview for Reference Platform

### 2.1 Hardware Components

The OFS hardware architecture decomposes all designs into a standard set of modules, interfaces, and capabilities. Although the OFS infrastructure provides a standard set of functionality and capability, the user is responsible for making the customizations to their specific design in compliance with the specifications outlined in the [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2023.3/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/).

OFS is a hardware and software infrastructure that provides an efficient approach to developing a custom FPGA-based platform or workload using an Intel, 3rd party, or custom board.

#### 2.1.1 FPGA Interface Manager

![iSeries-PCIe-Attach](./images/iseries_fim_overview.jpg)

The FPGA Interface Manager (FIM), or shell of the FPGA provides platform management functionality, clocks, resets, and interface access to the host and peripheral features on the acceleration platform. The OFS architecture for Intel Agilex 7 FPGA provides modularity, configurability, and scalability. The primary components of the FPGA Interface Manager or shell of the reference design are:

* PCIe Subsystem - a hierarchical design that targets the P-tile PCIe hard IP and is configured to support bifurcated Gen 5 speeds
* Ethernet Subsystem - provides portability to different Ethernet configurations across platforms and generations and reusability of the hardware framework and software stack.
* Memory Subsystem - 2 x 8 GB DDR4 DIMMs, supporting 2666 MHz speeds, 64-bit width (no ECC)
* Reset Controller
* FPGA Management Engine - Provides a way to manage the platform and enable acceleration functions on the platform.
* AFU Peripheral Fabric for AFU accesses to other interface peripherals
* Board Peripheral Fabric for master to slave CSR accesses from Host or AFU
* Platform Management Controller Interface (PMCI) to the board management controller

The FPGA Management Engine (FME) provides management features for the platform and the loading/unloading of accelerators through partial reconfiguration. Each feature of the FME exposes itself to the kernel-level OFS drivers on the host through a Device Feature Header (DFH) register that is placed at the beginning of Control Status Register (CSR) space. Only one PCIe link can access the FME register space in a multi-host channel design architecture at a time.

*Note: For more information on the FIM and its external connections, refer to the [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2023.3/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/).*

#### 2.1.2 AFU

An AFU is an acceleration workload that interfaces to the FIM. The AFU boundary in this reference design comprises both static and partial reconfiguration (PR) regions. You can decide how you want to partition these two areas or if you want your AFU region to only be a partial reconfiguration region. A port gasket within the design provides all the PR specific modules and logic required to support partial reconfiguration. Only one partial reconfiguration region is supported in this design.

Like the FME, the port gasket exposes its capability to the host software driver through a DFH register placed at the beginning of the port gasket CSR space. In addition, only one PCIe link can access the port register space.

You can compile your design in one of the following ways:

- Your entire AFU resides in a partial reconfiguration region of the FPGA.
- The AFU is part of the static region and is compiled as a flat design.
- Your AFU contains both static and PR regions.

In this design, the AFU region is comprised of:

- AFU Interface handler to verify transactions coming from AFU region.
- PF/VF Mux to route transactions to and from corresponding AFU components: ST2MM module, Virtio LB stub, PCIe loopback host exerciser (HE-LB), HSSI host exerciser (HE-HSSI), Memory Host Exerciser (HE-MEM), Traffic Generator to memory (HE-MEM-TG), Port Gasket (PRG) and HPS Copy Engine.
- AXI4 Streaming to Memory Map (ST2MM) Module that routes MMIO CSR accesses to FME and board peripherals.
- Host exercisers to test PCIe, memory and HSSI interfaces (these can be removed from the AFU region after your FIM design is complete to provide more resource area for workloads)
- Basic HPS Copy Engine to copy second-stage bootloader and Linux OS image from Host DDR to HPS DDR.
- Port gasket and partial reconfiguration support.
- Component for handling PLDM over MCTP over PCIe Vendor Defined Messages (VDM)

The AFU has the option to consume native packets from the host or interface channels or to instantiate a shim provided by the Platform Interface Manager (PIM) to translate between protocols.

*Note: For more information on the Platform Interface Manager and AFU development and testing, refer to the [Workload Developer Guide: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2023.3/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/).*

### 2.2 OFS Software Overview

The responsibility of the OFS kernel drivers is to act as the lowest software layer in the FPGA software stack, providing a minimalist driver implementation between the host software and functionality that has been implemented on the development platform. This leaves the implementation of IP-specific software in user-land, not the kernel. The OFS software stack also provides a mechanism for interface and feature discovery of FPGA platforms.

The OPAE SDK is a software framework for managing and accessing programmable accelerators (FPGAs). It consists of a collection of libraries and tools to facilitate the development of software applications and accelerators. The OPAE SDK resides exclusively in user-space, and can be found on the [OPAE SDK Github](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4).

The OFS drivers decompose implemented functionality, including external FIM features such as HSSI, EMIF and SPI, into sets of individual Device Features. Each Device Feature has its associated Device Feature Header (DFH), which enables a uniform discovery mechanism by software. A set of Device Features are exposed through the host interface in a Device Feature List (DFL). The OFS drivers discover and "walk" the Device Features in a Device Feature List and associate each Device Feature with its matching kernel driver.

In this way the OFS software provides a clean and extensible framework for the creation and integration of additional functionalities and their features.

*Note: A deeper dive on available SW APIs and programming model is available in the [Software Reference Manual: Open FPGA Stack](/hw/common/reference_manual/ofs_sw/mnl_sw_ofs.md), on [kernel.org](https://docs.kernel.org/fpga/dfl.html?highlight=fpga), and through the [Linux DFL wiki pages](https://github.com/OFS/linux-dfl/wiki).*

## 3.0 OFS DFL Kernel Drivers

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks like DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality. An in depth look at the various aspects of the driver architecture such as the API, an explanation of the DFL framework, and instructions on how to port DFL driver patches to other kernel distributions can be found on [the wiki](https://github.com/OPAE/linux-dfl/wiki).

An in-depth review of the Linux device driver architecture can be found on [opae.github.io](https://opae.github.io/latest/docs/drv_arch/drv_arch.html).

The DFL driver suite can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2024.1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1).

You can also build and install the software stack yourself from source as shown in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](../../../common/sw_installation/pcie_attach/sw_install_pcie_attach.md).

## 4.0 OPAE Software Development Kit

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit [opae.github.io](https://opae.github.io/latest/index.html).

The OPAE SDK source code is contained within a single GitHub repository hosted at the [OPAE Github](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4). This repository is open source and does not require any permissions to access.

You may choose to use the supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2024.1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1).

Instructions on building and installing the OPAE SDK from source can be found in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](../../../common/sw_installation/pcie_attach/sw_install_pcie_attach.md).

### 4.1 OPAE Tools Overview

The following section offers a brief introduction including expected output values for the utilities included with OPAE. A full explanation of each command with a description of its syntax is available in the [opae-sdk GitHub repo](https://github.com/OPAE/opae-sdk/blob/2.12.0-4/doc/src/fpga_tools/readme.md).

A list of all tools included in the OPAE SDK release can be found on the [OPAE FPGA Tools](https://ofs.github.io/ofs-2023.3/sw/fpga_tools/fpgadiag/) tab of ofs.github.io.

#### 4.1.1 Board Management with fpgainfo

The **fpgainfo** utility displays FPGA information derived from sysfs files. As this release targets a development kit platform, it does not have access to an on-board BMC. Subcommands that target specific BMC functionality (such as reading temeletry) are not supported for this release.

Displays FPGA information derived from sysfs files. The command argument is one of the following: errors, power, temp, port, fme, bmc, phy or mac, security. Some commands may also have other arguments or options that control their behavior.

For systems with multiple FPGA devices, you can specify the BDF to limit the output to the FPGA resource with the corresponding PCIe configuration. If not specified, information displays for all resources for the given command.

*Note: Your Bitstream ID and PR Interface Id may not match the below examples.*

The following examples walk through sample outputs generated by `fpgainfo`. As the I-Series Development Kit does not contain a traditional BMC as used by other OFS products, those lines in `fpgainfo`'s output will not return valid objects. The subcommand `fpgainfo bmc` will likewise fail to report telemetry data.

```bash
Intel Acceleration Development Platform N6001
board_n6000.c:306:read_bmcfw_version() **ERROR** : Failed to get read object
board_n6000.c:482:print_board_info() **ERROR** : Failed to read bmc version
board_n6000.c:332:read_max10fw_version() **ERROR** : Failed to get read object
board_n6000.c:488:print_board_info() **ERROR** : Failed to read max10 version
Board Management Controller NIOS FW version:
Board Management Controller Build version:
//****** FME ******//
Interface                        : DFL
Object Id                        : 0xEF00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : TBD
Bitstream Version                : 5.0.1
Pr Interface Id                  : TBD
Boot Page                        : N/A
```

#### 4.1.2 Updating with fpgasupdate

The **fpgasupdate** tool is used to program AFU workloads into an open slot in a FIM. The **fpgasupdate** tool only accepts images that have been formatted using PACsign.

As the I-Series Development Kit does not contain a traditional BMC, you do not have access to a factory, user1, and user2 programmed image for both the FIM and BMC FW and RTL. Only the programming of a GBS workload is supported for this release.

The process of programming a SOF with a new FIM version is shown in section [1.5 Upgrading the I-Series Development Kit FIM via JTAG](#15-upgrading-the--enviseries_dk_model_full--fim-via-jtag)

```bash
sudo fpgasupdate ofs_pr_afu.gbs   <PCI ADDRESS>
[2022-04-14 16:42:31.58] [WARNING ] Update starting. Please do not interrupt.                                           
[2022-04-14 16:42:31.58] [INFO    ] updating from file ofs_pr_afu.gbs with size 19928064               
[2022-04-14 16:42:31.60] [INFO    ] waiting for idle                                                                 
[2022-04-14 16:42:31.60] [INFO    ] preparing image file                                                                
[2022-04-14 16:42:38.61] [INFO    ] writing image file                                                                 
(100%) [████████████████████] [19928064/19928064 bytes][Elapsed Time: 0:00:16.01]                                       
[2022-04-14 16:42:54.63] [INFO    ] programming image file                                                              
(100%) [████████████████████][Elapsed Time: 0:06:16.40]                                                                 
[2022-04-14 16:49:11.03] [INFO    ] update of 0000:b1:00.0 complete                                                     
[2022-04-14 16:49:11.03] [INFO    ] Secure update OK                                                                   
[2022-04-14 16:49:11.03] [INFO    ] Total time: 0:06:39.45
```

#### 4.1.3 Verify FME Interrupts with hello_events

The **hello_events** utility is used to verify FME interrupts. This tool injects FME errors and waits for error interrupts, then clears the errors.

Sample output from `sudo hello_events`.

```bash
sudo hello_events
Waiting for interrupts now...
injecting error
FME Interrupt occurred
Successfully tested Register/Unregister for FME events!
clearing error
```

#### 4.1.4 Host Exercisor Modules

The reference FIM and unchanged FIM compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. There are three HEMs present in the Intel OFS Reference FIM - HE-LPBK, HE-MEM, and HE-HSSI. These exercisers are tied to three different VFs that must be enabled before they can be used.
Execution of these exercisers requires you bind specific VF endpoint to **vfio-pci**. The host-side software looks for these endpoints to grab the correct FPGA resource.

Refer to the Intel [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2023.3/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/) for a full description of these modules.

##### Table 7: Module PF/VF Mappings

| Module | PF/VF |
|----- | ----- |
|ST2MM| PF0|
|HE-MEM|PF0-VF0|
|HE-HSSI|PF0-VF1 |
|HE-MEM_TG|PF0-VF2 |
|HE-LB Stub|PF1-VF0 |
|HE-LB|PF2 |
|VirtIO LB Stub|PF3|
|HPS Copy Engine|PF4 |

##### 4.1.4.1 HE-MEM / HE-LB

The host exerciser used to exercise and characterize the various host-FPGA interactions eg. MMIO, Data transfer from host to FPGA , PR, host to FPGA memory etc.
**Host Exerciser Loopback (HE-LBK)** AFU can move data between host memory and FPGA.

HE-LBK supports:
- Latency (AFU to Host memory read)
- MMIO latency (Write+Read)
- MMIO BW (64B MMIO writes)
- BW (Read/Write, Read only, Wr only)

**Host Exerciser Loopback Memory (HE-MEM)** AFU is used to exercise use of FPGA connected DDR, data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host.

**HE-LB** is responsible for generating traffic with the intention of exercising the path from the AFU to the Host at full bandwidth. **HE-MEM** is used to exercise use of FPGA connected DDR; data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host. **HE-MEM** uses external DDR memory (i.e. EMIF) to store data. It has a customized version of the AVMM interface to communicate with the EMIF memory controller. Both exercisers rely on the user-space tool host_exerciser. When using the I-Series Development Kit SmartNIC Platform, optimal performance requires the exercisers be run at 400 MHz.

Execution of these exercisers requires you to bind specific VF endpoint to **vfio-pci**. The following commands will bind the correct endpoint for a device with B/D/F 0000:b1:00.0 and run through a basic loopback test.

*Note: While running the `opae.io init` command listed below, the command has failed if no output is present after completion. Double check that Intel VT-D and IOMMU have been enabled in the kernel as discussed in section [3.0 OFS DFL Kernel Drivers](#30-ofs-dfl-kernel-drivers).*

```bash
sudo pci_device  0000:b1:00.0 vf 3

sudo opae.io init -d 0000:b1:00.2 user:user
Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci                                                             
Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci 
iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 188                                                                  
Assigning /dev/vfio/188 to user                                                                 
Changing permissions for /dev/vfio/188 to rw-rw----


sudo host_exerciser --clock-mhz 400 lpbk
    starting test run, count of 1
API version: 1
AFU clock from command line: 400 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1025
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Number of clocks: 5224
    Total number of Reads sent: 1024
    Total number of Writes sent: 1022
    Bandwidth: 5.018 GB/s
    Test lpbk(1): PASS

```

The following example will run a loopback throughput test using one cache line per request.

```bash
sudo pci_device  0000:b1:00.0 vf 3

sudo opae.io init -d 0000:b1:00.2 user:user

sudo host_exerciser --clock-mhz 400 --mode trput --cls cl_1 lpbk
    starting test run, count of 1
API version: 1
AFU clock from command line: 400 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 512
    Host Exerciser numWrites: 513
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Number of clocks: 3517
    Total number of Reads sent: 512
    Total number of Writes sent: 512
    Bandwidth: 7.454 GB/s
    Test lpbk(1): PASS

```

##### 4.1.4.2 Traffic Generator AFU Test Application

Beginning in OPAE version 2.0.11-1+ the TG AFU has an OPAE application to access & exercise traffic, targeting a specific bank. The supported arguments for test configuration are:

- Number of test loops: --loops
- Number of read transfers per test loop: -r,--read
- Number of write transfers per test loop: -w,--write
- Burst size of each transfer: -b,--bls
- Address stride between each transfer: --stride
- Target memory TG: -m,--mem-channel

Below are some example commands for how to execute the test application.
To run the preconfigured write/read traffic test on channel 0:

```bash
mem_tg tg_test
```

Target channel 1 with a 1MB single-word write only test for 1000 iterations

```bash
mem_tg --loops 1000 -r 0 -w 2000 -m 1 tg_test
```

Target channel 2 with 4MB write/read test of max burst length for 10 iterations

```bash
mem_tg --loops 10 -r 8 -w 8 --bls 255 -m 2 tg_test
```

```bash
sudo mem_tg --loops 1000 -r 2000 -w 2000 --stride 2 --bls 2  -m 1 tg_test
[2022-07-15 00:13:16.349] [tg_test] [info] starting test run, count of 1
Memory channel clock frequency unknown. Assuming 300 MHz.
TG PASS
Mem Clock Cycles: 17565035
Write BW: 4.37232 GB/s
Read BW: 4.37232 GB/s
```

##### 4.1.4 HE-HSSI

HE-HSSI is responsible for handling client-side ethernet traffic. It wraps the 10G and 100G HSSI AFUs and includes a traffic generator and checker. The user-space tool `hssi` exports a control interface to the HE-HSSI's AFU's packet generator logic.

The `hssi` application provides a means of interacting with the 10G and with the 100G HSSI AFUs. In both 10G and 100G operating modes, the application initializes the AFU, completes the desired transfer as described by the mode- specific options, and displays the ethernet statistics by invoking `ethtool --statistics INTERFACE`.

```bash
sudo fpgainfo phy b1:00.0
board_n6000.c:306:read_bmcfw_version() **ERROR** : Failed to get read object
board_n6000.c:482:print_board_info() **ERROR** : Failed to read bmc version
board_n6000.c:332:read_max10fw_version() **ERROR** : Failed to get read object
board_n6000.c:488:print_board_info() **ERROR** : Failed to read max10 version
Board Management Controller NIOS FW version:
Board Management Controller Build version:
//****** PHY ******//
Interface                        : DFL
Object Id                        : 0xEF00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 0x501020241BF165B
Bitstream Version                : TBD
Pr Interface Id                  : TBD
QSFP0                            : Connected
QSFP1                            : Connected
//****** HSSI information ******//
HSSI version                     : 2.0
Number of ports                  : 8
Port0                            :25GbE        UP
Port1                            :25GbE        UP
Port2                            :25GbE        UP
Port3                            :25GbE        DOWN
Port4                            :25GbE        UP
Port5                            :25GbE        UP
Port6                            :25GbE        DOWN
Port7                            :25GbE        DOWN
```

The following example walks through the process of binding the VF corresponding with the HE-HSSI exerciser to vfio-pci, sending traffic, and verifying that traffic was received.

###### Table 8: Accelerator PF/VF and GUID Mappings

| Component| VF| Accelerator GUID|
| -----| -----| -----|
| I Series Dev Kit base PF| XXXX:XX:XX.0| N/A|
| VirtIO Stub| XXXX:XX:XX.1|3e7b60a0-df2d-4850-aa31-f54a3e403501|
| HE-MEM Stub| XXXX:XX:XX.2| 56e203e9-864f-49a7-b94b-12284c31e02b|
| Copy Engine| XXXX:XX:XX.4| 44bfc10d-b42a-44e5-bd42-57dc93ea7f91|
| HE-MEM| XXXX:XX:XX.5| 8568ab4e-6ba5-4616-bb65-2a578330a8eb |
| HE-HSSI| XXXX:XX:XX.6| 823c334c-98bf-11ea-bb37-0242ac130002 |
| MEM-TG| XXXX:XX:XX.7| 4dadea34-2c78-48cb-a3dc-5b831f5cecbb |

1. **Create** 3 VFs in the PR region.

    ```bash
    sudo pci_device b1:00.0 vf 3 
    ```

2. Verify all 3 VFs were created.
    
    ```bash
    lspci -s b1:00 
    b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01) 
    b1:00.1 Processing accelerators: Intel Corporation Device bcce 
    b1:00.2 Processing accelerators: Intel Corporation Device bcce 
    b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device 
    b1:00.4 Processing accelerators: Intel Corporation Device bcce 
    b1:00.5 Processing accelerators: Intel Corporation Device bccf 
    b1:00.6 Processing accelerators: Intel Corporation Device bccf 
    b1:00.7 Processing accelerators: Intel Corporation Device bccf 
    ```

3. **Bind** all the PF/VF endpoints to the `vfio-pci` driver.
    
    ```bash
    sudo opae.io init -d 0000:b1:00.1 user:user
    Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
    Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
    iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 187
    Assigning /dev/vfio/187 to user
    Changing permissions for /dev/vfio/187 to rw-rw----
    
    sudo opae.io init -d 0000:b1:00.2 user:user
    Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci
    Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci
    iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 188
    Assigning /dev/vfio/188 to user
    Changing permissions for /dev/vfio/188 to rw-rw----
    
    ...
    
    sudo opae.io init -d 0000:b1:00.7 user:user
    Binding (0x8086,0xbccf) at 0000:b1:00.7 to vfio-pci
    iommu group for (0x8086,0xbccf) at 0000:b1:00.7 is 319
    Assigning /dev/vfio/319 to user
    Changing permissions for /dev/vfio/319 to rw-rw----
    ```

4. Check that the accelerators are present using `fpgainfo`. *Note your port configuration may differ from the below.*
    
    ```bash
    sudo fpgainfo port 
    //****** PORT ******//
    Object Id                        : 0xEC00000
    PCIe s:b:d.f                     : 0000:B1:00.0
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x00
    //****** PORT ******//
    Object Id                        : 0xE0B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.7
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCF
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 4dadea34-2c78-48cb-a3dc-5b831f5cecbb
    //****** PORT ******//
    Object Id                        : 0xC0B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.6
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCF
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 823c334c-98bf-11ea-bb37-0242ac130002
    //****** PORT ******//
    Object Id                        : 0xA0B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.5
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCF
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 8568ab4e-6ba5-4616-bb65-2a578330a8eb
    //****** PORT ******//
    Object Id                        : 0x80B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.4
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 44bfc10d-b42a-44e5-bd42-57dc93ea7f91
    //****** PORT ******//
    Object Id                        : 0x40B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.2
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 56e203e9-864f-49a7-b94b-12284c31e02b
    //****** PORT ******//
    Object Id                        : 0x20B1000000000000
    PCIe s:b:d.f                     : 0000:B1:00.1
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x01
    Accelerator GUID                 : 3e7b60a0-df2d-4850-aa31-f54a3e403501
    ```

5. Check Ethernet PHY settings with `fpgainfo`.
    
    ```bash
    sudo fpgainfo phy -B 0xb1 
    //****** FME ******//
    Object Id                        : 0xED00001
    PCIe s:b:d.f                     : 0000:B1:00.0
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x00
    Ports Num                        : 01
    Bitstream Id                     : TBD
    Bitstream Version                : 5.0.1
    Pr Interface Id                  : TBD
    //****** HSSI information ******//
    HSSI version                     : 1.0
    Number of ports                  : 8
    Port0                            :25GbE        DOWN
    Port1                            :25GbE        DOWN
    Port2                            :25GbE        DOWN
    Port3                            :25GbE        DOWN
    Port4                            :25GbE        DOWN
    Port5                            :25GbE        DOWN
    Port6                            :25GbE        DOWN
    Port7                            :25GbE        DOWN
    ```

6. Set loopback mode.
    
    ```bash
    sudo hssiloopback --loopback enable  --pcie-address 0000:b1:00.0 
    args Namespace(loopback='enable', pcie_address='0000:b1:00.0', port=0)
    sbdf: 0000:b1:00.0
    FPGA dev: {'segment': 0, 'bus': 177, 'dev': 0, 'func': 0, 'path': '/sys/class/fpga_region/region0', 'pcie_address': '0000:b1:00.0'}
    args.hssi_grps{0: ['dfl_dev.6', ['/sys/bus/pci/devices/0000:b1:00.0/fpga_region/region0/dfl-fme.0/dfl_dev.6/uio/uio0']]}
    fpga uio dev:dfl_dev.6
    
    --------HSSI INFO START-------
    DFH                     :0x3000000010002015
    HSSI ID                 :0x15
    DFHv                    :0.5
    guidl                   :0x99a078ad18418b9d
    guidh                   :0x4118a7cbd9db4a9b
    HSSI version            :1.0
    Firmware Version        :1
    HSSI num ports          :8
    Port0                   :25GbE
    Port1                   :25GbE
    Port2                   :25GbE
    Port3                   :25GbE
    Port4                   :25GbE
    Port5                   :25GbE
    Port6                   :25GbE
    Port7                   :25GbE
    --------HSSI INFO END-------
    
    hssi loopback enabled to port0
    
    ```

7. Send traffic through the 10G AFU.
    
    ```bash
    sudo hssi --pci-address b1:00.6 hssi_10g --num-packets 100       
    10G loopback test
      port: 0
      eth_loopback: on
      he_loopback: none
      num_packets: 100
      packet_length: 64
      src_address: 11:22:33:44:55:66
        (bits): 0x665544332211
      dest_address: 77:88:99:aa:bb:cc
        (bits): 0xccbbaa998877
      random_length: fixed
      random_payload: incremental
      rnd_seed0: 5eed0000
      rnd_seed1: 5eed0001
      rnd_seed2: 25eed
      eth:
    
    No eth interface, so not honoring --eth-loopback.
    0x40000           ETH_AFU_DFH: 0x1000010000001000
    0x40008          ETH_AFU_ID_L: 0xbb370242ac130002
    0x40010          ETH_AFU_ID_H: 0x823c334c98bf11ea
    0x40030      TRAFFIC_CTRL_CMD: 0x0000000000000000
    0x40038     TRAFFIC_CTRL_DATA: 0x0000000100000000
    0x40040 TRAFFIC_CTRL_PORT_SEL: 0x0000000000000000
    0x40048        AFU_SCRATCHPAD: 0x0000000045324511
    
    0x3c00         number_packets: 0x00000064
    0x3c01          random_length: 0x00000000
    0x3c02         random_payload: 0x00000000
    0x3c03                  start: 0x00000000
    0x3c04                   stop: 0x00000000
    0x3c05           source_addr0: 0x44332211
    0x3c06           source_addr1: 0x00006655
    0x3c07             dest_addr0: 0xaa998877
    0x3c08             dest_addr1: 0x0000ccbb
    0x3c09        packet_tx_count: 0x00000064
    0x3c0a              rnd_seed0: 0x5eed0000
    0x3c0b              rnd_seed1: 0x5eed0001
    0x3c0c              rnd_seed2: 0x00025eed
    0x3c0d             pkt_length: 0x00000040
    0x3cf4          tx_end_tstamp: 0x000003d2
    0x3d00                num_pkt: 0xffffffff
    0x3d01               pkt_good: 0x00000064
    0x3d02                pkt_bad: 0x00000000
    0x3d07            avst_rx_err: 0x00000000
    0x3d0b          rx_sta_tstamp: 0x00000103
    0x3d0c          rx_end_tstamp: 0x0000053b
    0x3e00               mac_loop: 0x00000000
    
    HSSI performance:
            Selected clock frequency : 402.832 MHz
            Latency minimum : 642.948 ns
            Latency maximum : 896.155 ns
            Achieved Tx throughput : 18.4528 GB/s
            Achieved Rx throughput : 16.7101 GB/s
    
    No eth interface, so not showing stats.
    
    ```

The `hssi_loopback` utility works in conjunction with a packet generator accelerator function unit (AFU) to test high-speed serial interface (HSSI) cards. `hssi_loopback` tests both external and internal loopbacks.

The `hssistats` tool provides the MAC statistics.
