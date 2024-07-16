# Getting Started Guide: Open FPGA Stack for Intel<sup>&reg;</sup> Agilex FPGAs Targeting the Intel® FPGA SmartNIC N6000/1-PL

Last updated: **July 16, 2024** 

## 1.0 Introduction

The purpose of this document is to help users get started in evaluating the 2024.2-1 version of the Open FPGA Stack (OFS) for the Intel Agilex FPGA targeting the Intel N6000/1-PL FPGA SmartNIC Platform. After reviewing the document a user shall be able to:

- Set up their server environment according to the Best Known Configuration (BKC)
- Build and install the OFS Linux Kernel drivers
- Build and install the Open Programmable Acceleration Engine Software Development Kit (OPAE SDK) software on top of the OFS Linux kernel drivers
- Load and Verify the Firmware and FIM versions loaded on their boards
- Verify the full stack functionality offered by the OFS solution
- Know where to find additional information on other OFS ingredients

### 1.1 Audience

The information in this document is intended for customers evaluating the PCIe Attach shell targeting Intel N6000/1-PL FPGA SmartNIC Platforms. These platforms are Development Kits intended to be used as a starting point for evaluation and development.

*Note: Code command blocks are used throughout the document. Commands that are intended for you to run are preceded with the symbol '$', and comments with '#'. Full command output may not be shown.*

### 1.2 Terminology

#### Table 1: Terminology

| Term       | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| AER        | Advanced Error Reporting, The PCIe AER driver is the extended PCI Express error reporting capability providing more robust error reporting. |
| AFU        | Accelerator Functional Unit, Hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance. Note: An AFU region is the part of the design where an AFU may reside. This AFU may or may not be a partial reconfiguration region |
| BBB        | Basic Building Block, Features within an AFU or part of an FPGA interface that can be reused across designs. These building blocks do not have stringent interface requirements like the FIM's AFU and host interface requires. All BBBs must have a (globally unique identifier) GUID. |
| BKC        | Best Known Configuration, The exact hardware configuration Intel has optimized and validated the solution against. |
| BMC        | Board Management Controller, Acts as the Root of Trust (RoT) on the Intel FPGA PAC platform. Supports features such as power sequence management and board monitoring through on-board sensors. |
| CSR        | Command/status registers (CSR) and software interface, OFS uses a defined set of CSR's to expose the functionality of the FPGA to the host software. |
| DFL        | Device Feature List, A concept inherited from OFS. The DFL drivers provide support for FPGA devices that are designed to support the Device Feature List. The DFL, which is implemented in RTL, consists of a self-describing data structure in PCI BAR space that allows the DFL driver to automatically load the drivers required for a given FPGA configuration. |
| FIM        | FPGA Interface Manager, Provides platform management, functionality, clocks, resets and standard interfaces to host and AFUs. The FIM resides in the static region of the FPGA and contains the FPGA Management Engine (FME) and I/O ring. |
| FME        | FPGA Management Engine, Provides a way to manage the platform and enable acceleration functions on the platform. |
| HEM        | Host Exerciser Module, Host exercisers are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. |
| Intel VT-d | Intel Virtualization Technology for Directed I/O, Extension of the VT-x and VT-I processor virtualization technologies which adds new support for I/O device virtualization. |
| IOCTL      | Input/Output Control, System calls used to manipulate underlying device parameters of special files. |
| JTAG       | Joint Test Action Group, Refers to the IEEE 1149.1 JTAG standard; Another FPGA configuration methodology. |
| MMIO       | Memory Mapped Input/Output, Users may map and access both control registers and system memory buffers with accelerators. |
| OFS        | Open FPGA Stack, A modular collection of hardware platform components, open source software, and broad ecosystem support that provides a standard and scalable model for AFU and software developers to optimize and reuse their designs. |
| OPAE SDK   | Open Programmable Acceleration Engine Software Development Kit, A collection of libraries and tools to facilitate the development of software applications and accelerators using OPAE. |
| PAC        | Programmable Acceleration Card: FPGA based Accelerator card  |
| PIM        | Platform Interface Manager, An interface manager that comprises two components: a configurable platform specific interface for board developers and a collection of shims that AFU developers can use to handle clock crossing, response sorting, buffering and different protocols. |
| PR         | Partial Reconfiguration, The ability to dynamically reconfigure a portion of an FPGA while the remaining FPGA design continues to function. In the context of Intel FPGA PAC, a PR bitstream refers to an Intel FPGA PAC AFU. Refer to [Partial Reconfiguration](https://www.intel.com/content/www/us/en/programmable/products/design-software/fpga-design/quartus-prime/features/partial-reconfiguration.html) support page. |
| RSU        | Remote System Update, A Remote System Update operation sends an instruction to the Intel FPGA PAC D5005 device that triggers a power cycle of the card only, forcing reconfiguration. |
| SR-IOV     | Single-Root Input-Output Virtualization, Allows the isolation of PCI Express resources for manageability and performance. |
| TB         | Testbench, Testbench or Verification Environment is used to check the functional correctness of the Design Under Test (DUT) by generating and driving a predefined input sequence to a design, capturing the design output and comparing with-respect-to expected output. |
| UVM        | Universal Verification Methodology, A modular, reusable, and scalable testbench structure via an API framework. |
| VFIO       | Virtual Function Input/Output, An IOMMU/device agnostic framework for exposing direct device access to user space. |

### 1.3 References and Versions

The OFS 2024.2-1 Release targeting the Intel® FPGA SmartNIC N6000/1-PL is built upon tightly coupled software and firmware versions. Use this section as a general reference for the versions which compose this release.

The following table highlights the hardware which makes up the Best Known Configuration (BKC) for the OFS 2024.2-1 release.

#### Table 2: Hardware BKC

| Component | Version |
| --------- | ------- |
| 1 x Intel® FPGA SmartNIC N6001-PL, SKU2 | ![HARDWARE_1_N6000](/ofs-2024.2-1/hw/n6001/user_guides/ug_qs_ofs_n6001/images/HARDWARE_1_N6000.png) |
| 1 x Supermicro Server SYS-220HE | ![HARDWARE_2_SERVER](/ofs-2024.2-1/hw/n6001/user_guides/ug_qs_ofs_n6001/images/HARDWARE_2_SERVER.png)|
| 1 x Intel FPGA Download Cable II (Only Required for manual flashing) |![HARDWARE_3_JTAG](/ofs-2024.2-1/hw/n6001/user_guides/ug_qs_ofs_n6001/images/HARDWARE_3_JTAG.png) |
| 1 x 2x5 Extension header - Samtech Part No: ESQ-105-13-L-D (Only Required for manual flashing) |![HARDWARE_4_EXTENDER](/ofs-2024.2-1/hw/n6001/user_guides/ug_qs_ofs_n6001/images/HARDWARE_4_EXTENDER.png) |

The following table highlights the versions of the software which compose the OFS stack. The installation of the OPAE SDK on top of the Linux DFL drivers will be discussed in their relevant sections in this document.

#### Table 3: Software Version Summary

| Component | Version |
| --------- | ------- |
| FPGA Platform | [Intel® FPGA SmartNIC N6001-PL](https://cdrdv2.intel.com/v1/dl/getContent/723837?explicitVersion=true), release notes: <https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1> under "Known Issues"|
| OPAE SDK | [2.13.0-3](https://github.com/OFS/opae-sdk/releases/tag/2.13.0-3)|
| Kernel Drivers |[intel-1.11.0-2](https://github.com/OFS/linux-dfl-backport/releases/tag/intel-1.11.0-2)|
| OneAPI-ASP | [ofs-2024.2-1](https://github.com/OFS/oneapi-asp/releases/tag/ofs-2024.2-1)  |
| OFS FIM Source Code for N6001| [ofs-2024.2-1](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1) |
| OFS FIM Common Resources| [Tag: ofs-fim-common-1.1.0-rc2](https://github.com/OFS/ofs-fim-common/releases/tag/ofs-fim-common-1.1.0-rc2) |
|OFS Platform AFU BBB | [ofs-2024.2-1](https://github.com/OFS/ofs-platform-afu-bbb/releases/tag/ofs-2024.2-1) |
| Intel Quartus Prime Pro Edition Design Software* | [Quartus Prime Pro Version 24.1 for Linux](https://www.intel.com/content/www/us/en/software-kit/794624/intel-quartus-prime-pro-edition-design-software-version-24-1-for-linux.html)  |
| Operating System | [RedHat® Enterprise Linux® (RHEL) 8.10](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.10/x86_64/product-software) |

The following table highlights the differences between N6000/1 PL FPGA SmartNIC platforms (SKU1/SKU2). Use this table to identify which version of the N6000/1-PL FPGA SmartNIC platform you have. The board identification printed by the `fpgainfo fme` commands depends on both the OPAE SDK and Linux DFL drivers to be installed as shown in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](/ofs-2024.2-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach.md).

#### Table 4: Intel N6000/1-PL FPGA SmartNIC Platform SKU Mapping

| SKU Mapping | SKU Value | Primary Difference| `fpgainfo` Identification|
| --------- | ------- | ----- | ----- |
|N6000| Q1613314XXXXX | PCIe Gen 4 1x16 mechanical bifurcated 2x8 logical to host, with one PCIe Gen 4x8 endpoint reserved for Intel E810-C-CAM2 NIC, the other reserved for FIM| "Intel Acceleration Development Platform N6000"|
|N6001| Q0216514XXXXX | PCIe Gen 4 1x16 mechanical and logical connection between host and FIM| "Intel Acceleration Development Platform N6001"|

The following table highlights the programmable firmware versions that are supported on the Intel N6000/1-PL FPGA SmartNIC Platform in the [OFS 2024.2-1 release](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1). Programming and verifying these components is discussed in their respective sections.

#### Table 5: Intel® FPGA SmartNIC N6000/1-PL Programmable Component Version Summary

| Component | Version |
| ----- | ----- |
| PR Interface ID |  a791757d-38a6-5159-a7fc-e1a61157a07b  |
| Bitstream ID | 360571656856467345 |
| BMC RTL | 3.15.2 |
| BMC NIOS FW| 3.15.2 |

### 1.4 Reference Documents

Documentation is collected on [https://ofs.github.io/ofs-2024.1-1/](https://ofs.github.io/ofs-2024.1-1/).

### 1.5 Board Installation and Server Setup

Platform installation instructions, server BIOS settings and regulatory information can be found in the [Board Installation Guide: OFS for Acceleration Development Platforms](https://ofs.github.io/ofs-2024.2-1/hw/common/board_installation/adp_board_installation/adp_board_installation_guidelines).

#### Table 6: SuperMicro Server BMC BKC

| Component| Version|
| -----| -----|
| BIOS Version| American Megatrends International, LLC(1.4) |

## 2.0 OFS Stack Architecture Overview for Reference Platform

### 2.1 Hardware Components

The OFS hardware architecture decomposes all designs into a standard
set of modules, interfaces, and capabilities. Although the OFS infrastructure provides a standard set of functionality and capability, the user is responsible for making the customizations to their specific design in compliance with the specifications outlined in the [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/).

OFS is a hardware and software infrastructure that provides an efficient approach to developing a custom FPGA-based platform or workload using an Intel, 3rd party, or custom board.

#### 2.1.1 FPGA Interface Manager

![OFS_FIM](/ofs-2024.2-1/hw/n6001/reference_manuals/ofs_fim/images/Agilex_Fabric_Features.png)

The FPGA Interface Manager (FIM), or shell of the FPGA provides platform management
functionality, clocks, resets, and interface access to the host and
peripheral features on the acceleration platform. The OFS architecture for Intel Agilex FPGA provides modularity, configurability and scalability.  The primary components of the FPGA Interface Manager or shell of the reference design are:

- PCIe Subsystem - a hierarchical design that targets the P-tile PCIe hard IP and is configured to support Gen4 speeds and Arm AXI4-Stream Data Mover functional mode.
- Ethernet Subsystem - provides portability to different Ethernet configurations across platforms and generations and reusability of the hardware framework and software stack.
- Memory Subsystem - composed of 5 DDR4 channels; one HPS DDR4 bank, x40 (x32 Data and x8 ECC), 1200 MHz, 1GB each, and four Fabric DDR4 banks, x32 (no ECC), 1200 MHz, 4GB
- Hard Processor System - 64-bit quad core ARM® Cortex*-A53 MPCore with integrated peripherals.
- Reset Controller
- FPGA Management Engine - Provides a way to manage the platform and enable acceleration functions on the platform.
- AFU Peripheral Fabric for AFU accesses to other interface peripherals
- Board Peripheral Fabric for master to slave CSR accesses from Host or AFU
- Platform Management Controller Interface (PMCI) to the board management controller

The FPGA Management Engine (FME)
provides management features for the platform and the
loading/unloading of accelerators through partial reconfiguration. Each
feature of the FME exposes itself to the kernel-level OFS drivers on the host through a Device Feature Header (DFH)
register that is placed at the beginning of Control Status Register
(CSR) space. Only one PCIe link can access the FME register space in a
multi-host channel design architecture at a time.

*Note: For more information on the FIM and its external connections, refer to the [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/).*

#### 2.1.2 AFU

An AFU is an acceleration workload that interfaces to the FIM. The AFU boundary in this reference design comprises both static and partial reconfiguration (PR) regions.  You can decide how you want to partition these two areas or if you want your AFU region to only be a partial reconfiguration region. A port gasket within the design provides all the PR specific modules and logic required to support partial reconfiguration. Only one partial reconfiguration region is supported in this design.

Similar to the FME, the port gasket exposes its capability to the host software
driver through a DFH register placed at the beginning of the port gasket CSR
space. In addition, only one PCIe link can access the port register
space.  

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

The AFU has the option to consume
native packets from the host or interface channels or to instantiate a
shim provided by the Platform Interface Manager (PIM) to translate
between protocols.

*Note: For more information on the Platform Interface Manager and AFU development and testing, refer to the [Workload Developer Guide: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/).*

### 2.2 OFS Software Overview

The responsibility of the OFS kernel drivers is to act as the lowest software
layer in the FPGA software stack, providing a minimalist driver implementation between the
host software and functionality that has been implemented on the development platform. This leaves the implementation of IP-specific
software in user-land, not the kernel. The OFS software stack also
provides a mechanism for interface and feature discovery of FPGA
platforms.

The OPAE SDK is a software framework for managing and accessing programmable accelerators (FPGAs). It consists of a collection of libraries and tools to facilitate the development of software applications and accelerators. The OPAE SDK resides exclusively in user-space, and can be found on the [OPAE SDK Github](https://github.com/OPAE/opae-sdk).

The OFS drivers decompose implemented functionality, including external FIM features such as HSSI, EMIF and SPI, into sets of
individual Device Features. Each Device Feature has its associated
Device Feature Header (DFH), which enables a uniform discovery mechanism
by software. A set of Device Features are exposed through the host
interface in a Device Feature List (DFL). The OFS drivers discover
and "walk" the Device Features in a Device Feature List and associate
each Device Feature with its matching kernel driver.

In this way the OFS software provides a clean and extensible framework
for the creation and integration of additional functionalities and their
features.

*Note: A deeper dive on available SW APIs and programming model is available in the [Software Reference Manual: Open FPGA Stack](https://ofs.github.io/latest/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/) and on [kernel.org](https://docs.kernel.org/fpga/dfl.html?highlight=fpga).*

## 3.0 OFS DFL Kernel Drivers

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks like DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality. An in depth look at the various aspects of the driver architecture such as the API, an explanation of the DFL framework, and instructions on how to port DFL driver patches to other kernel distributions can be found on https://github.com/OPAE/linux-dfl/wiki.

An in-depth review of the Linux device driver architecture can be found on [opae.github.io](https://opae.github.io/latest/docs/drv_arch/drv_arch.html).

The DFL driver suite can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2024.2-1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1).

Build and installation instructions are detailed in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](/ofs-2024.2-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach.md).

## 4.0 OPAE Software Development Kit

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit the [opae reference](https://opae.github.io/2.3.0/index.html) page.

The OPAE SDK source code is contained within a single GitHub repository
hosted at the [OPAE Github](https://github.com/OFS/opae-sdk/releases/tag/2.13.0-3). This repository is open source and does not require any permissions to access. You have two options to install OPAE as discussed below - using pre-built packages offered by Intel, or building the source code locally.

The OPAE SDK can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2024.2-1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1).

You can choose to build and install the OPAE SDK from source, which is detailed in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](/ofs-2024.2-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach.md).

### 4.4 FPGA Device Access Permissions

Access to FPGA accelerators and devices is controlled using file access permissions on the Intel® FPGA device files, /dev/dfl-fme.* and /dev/dfl-port.*, as well as to the files reachable through /sys/class/fpga_region/.

In order to allow regular (non-root) users to access accelerators, you need to grant them read and write permissions on /dev/dfl-port.* (with * denoting the respective socket, i.e. 0 or 1). E.g.:


```bash
sudo chmod a+rw /dev/dfl-port.0
```

### 4.5 Memlock limit

Depending on the requirements of your application, you may also want to increase the maximum amount of memory a user process is allowed to lock. The exact way to do this depends on your Linux distribution.


You can check the current memlock limit using

```bash
ulimit -l
```

A way to permanently remove the limit for locked memory for a regular user is to add the following lines to your /etc/security/limits.conf:

```bash
user1    hard   memlock           unlimited
user1    soft   memlock           unlimited
```

This removes the limit on locked memory for user user1. To remove it for all users, you can replace user1 with *:

```bash
*    hard   memlock           unlimited
*    soft   memlock           unlimited
```

Note that settings in the /etc/security/limits.conf file don't apply to services. To increase the locked memory limit for a service you need to modify the application's systemd service file and add the line:

```bash
[Service]
LimitMEMLOCK=infinity
```

### 4.6 OPAE Tools Overview

The following section offers a brief introduction including expected output values for the utilities included with OPAE. A full explanation of each command with a description of its syntax is available in the [opae-sdk GitHub repo](https://github.com/OPAE/opae-sdk/blob/2.13.0-3/doc/src/fpga_tools/readme.md). The following command outputs were captured using an N6001 device.

#### 4.6.1 Board Management with fpgainfo

The **fpgainfo** utility displays FPGA information derived from sysfs files.

Displays FPGA information derived from sysfs files. The command argument is one of the following: errors, power, temp, port, fme, bmc, phy or mac, security. Some commands may also have other arguments or options that control their behavior.

For systems with multiple FPGA devices, you can specify the BDF to limit the output to the FPGA resource with the corresponding PCIe configuration. If not specified, information displays for all resources for the given command.

*Note: Your BItstream ID and PR Interface Id may not match the below examples.*

The following examples walk through sample outputs generated by `fpgainfo`.

```bash
$ sudo fpgainfo fme

Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.2
Board Management Controller Build version: 3.15.2
//****** FME ******//
Object Id                        : 0xED00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 360571656856467345
Bitstream Version                : 5.0.1
Pr Interface Id                  : a791757d-38a6-5159-a7fc-e1a61157a07b
Boot Page                        : user1
Factory Image Info               : a2b5fd0e7afca4ee6d7048f926e75ac2
User1 Image Info                 : a791757d-38a6-5159-a7fc-e1a61157a07b
User2 Image Info                 : a791757d-38a6-5159-a7fc-e1a61157a07b

```

```bash
$ sudo fpgainfo bmc

Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.2
Board Management Controller Build version: 3.15.2
//****** FME ******//
Object Id                        : 0xED00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 360571656856467345
Bitstream Version                : 5.0.1
Pr Interface Id                  : a791757d-38a6-5159-a7fc-e1a61157a07b
( 1) VCCRT_GXER_0V9 Voltage                             : 0.91 Volts
( 2) FPGA VCCIO_1V2 Voltage                             : 1.21 Volts
( 3) Inlet 12V Aux Rail Current                         : 0.87 Amps
( 4) FPGA E-Tile Temperature [Remote]                   : 47.00 Celsius
( 5) AVDD_ETH_0V9_CVL Voltage                           : 1.48 Volts
( 6) FPGA E-TILE Temperature #3                         : 51.00 Celsius
...
(77) FPGA FABRIC Remote Digital Temperature#3           : 47.00 Celsius
(78) MAX10 & Board CLK PWR 3V3 Inlet Current            : 0.97 Amps
(79) CVL Non Core Rails Inlet Current                   : 0.01 Amps
(80) FPGA Core Voltage Phase 0 VR Temperature           : 49.50 Celsius

```

#### 4.6.2 Sensor Monitoring with fpgad

The **fpgad** is a service that can help you protect the server from crashing when the hardware reaches an upper non-recoverable or lower non-recoverable sensor threshold (also called as fatal threshold). The fpgad is capable of monitoring each of the 80 sensors reported by the Board Management Controller. This service is only available once the installation instructions in sections [3.2 Building and Installing the OFS DFL Kernel Drivers](#32-building-and-installing-the-ofs-dfl-kernel-drivers-from-source) and [4.1 OPAE SDK Build Environment Setup](#41-opae-sdk-build-environment-setup) have been completed
.
*Note: Qualified OEM server systems should provide the required cooling for your workloads. Therefore, using **fpgad** may be optional.*

When the opae-tools-extra-2.13.0-3.x86_64  package is installed, **fpgad** is placed in the OPAE binaries directory (default: /usr/bin). The configuration file fpgad.cfg is located at /etc/opae. The log file fpgad.log which monitors **fpgad** actions is located at /var/lib/opae/.
The **fpgad** periodically reads the sensor values and if the values exceed the warning threshold stated in the fpgad.conf or the hardware defined warning threshold, it masks the PCIe Advanced Error Reporting (AER) registers for the Intel N6000/1-PL FPGA SmartNIC Platform to avoid system reset.
Use the following command to start the **fpgad** service:

Use the following command to start the fpgad service:

```bash
$ sudo systemctl start fpgad
```
The configuration file only includes the threshold setting for critical sensor 12V Aux Rail Voltage (sensor 29). This sensor does not have a hardware defined warning threshold and hence **fpgad** relies on the configuration file. The **fpgad** uses information contained within this file to mask the PCIe AER register when the sensor reaches the warning threshold.

You may create another entry below the 12V Aux Voltage entry for any other sensors on the board. The updated configuration file includes a new entry for **(18) Board Front Side Temperature** with arbitrary values:

```json
{
"configurations": {
	"fpgad-xfpga": {
		"configuration": {
		},
		"enabled": true,
		"plugin": "libfpgad-xfpga.so",
		"devices": [
			[ "0x8086", "0xbcc0" ],
			[ "0x8086", "0xbcc1" ]
		]
	},
	"fpgad-vc": {
		"configuration": {
			"cool-down": 30,
			"get-aer": [
				"setpci -s %s ECAP_AER+0x08.L",
				"setpci -s %s ECAP_AER+0x14.L"
			],
			"disable-aer": [
				"setpci -s %s ECAP_AER+0x08.L=0xffffffff",
				"setpci -s %s ECAP_AER+0x14.L=0xffffffff"
			],
			"set-aer": [
				"setpci -s %s ECAP_AER+0x08.L=0x%08x",
				"setpci -s %s ECAP_AER+0x14.L=0x%08x"
			],
			"config-sensors-enabled": true,
			"sensors": [
				{
					"name": "12V AUX Voltage",
					"low-warn": 11.40,
					"low-fatal": 10.56
				},
				{
					“name”: “3V3 VR Temperature”,
					“low-warn”: 50.00,
					“low-fatal”: 100.00
	
				}
			]
		},
		"enabled": true,
		"plugin": "libfpgad-vc.so",
		"devices": [
			[ "0x8086", "0x0b30" ],
			[ "0x8086", "0x0b31" ],
			[ "0x8086", "0xaf00" ],
			[ "0x8086", "0xbcce" ]
			]
	}
},
"plugins": [
	"fpgad-xfpga",
	"fpgad-vc"
]
}
```

You can monitor the log file to see if upper or lower warning threshold levels are hit. For example:

```bash
$ tail -f /var/lib/opae/fpgad.log | grep “sensor.*warning”
fpgad-vc: sensor ' Columbiaville Die Temperature ' warning
```

You must take appropriate action to recover from this warning **before** the sensor value reaches upper or lower fatal limits. On reaching the warning threshold limit, the daemon masks the AER registers and the log file will indicate that the sensor is tripped.
Sample output: Warning message when the 'CVL Core0 Voltage VR Temperature' exceeds the upper warning threshold limit


```bash
$ tail -f /var/lib/opae/fpgad.log 
fpgad-vc: sensor 'CVL Core Voltage VR Temperature' warning.
fpgad-vc: saving previous ECAP_AER+0x08 value 0x057ff030 for 0000:b0:02.0
fpgad-vc: saving previous ECAP_AER+0x14 value 0x0000f1c1 for 0000:b0:02.0
fpgad-vc: sensor 'CVL Core Voltage VR Temperature' still tripped.
```

If the upper or lower fatal threshold limit is reached, then a power cycle of server is required to recover the Intel N6000/1-PL SmartNIC FPGA Platform. AER is unmasked by the **fpgad** after the sensor values are within the normal range which is above the lower warning or below the upper warning threshold.

To stop **fpgad**:

```bash
$ sudo systemctl stop fpgad.service
```

To check status of fpgad:

```bash
$ sudo systemctl status fpgad.service
```

Optional: To enable fpgad to re-start on boot, execute

```bash
$ sudo systemctl enable fpgad.service
```

For a full list of systemctl commands, run the following command:

```bash
$ systemctl -h
```

#### 4.6.3 Updating with fpgasupdate

The **fpgasupdate** tool updates the Intel Max10 Board Management Controller (BMC) image and firmware (FW), root entry hash, and FPGA Static Region (SR) and user image (PR). The **fpgasupdate** tool only accepts images that have been formatted using PACsign. If a root entry hash has been programmed onto the board, then you must also sign the image using the correct keys. Refer to the [Security User Guide: Open FPGA Stack](https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/ug-pac-security.md) for information on created signed images and on programming and managing the root entry hash.  

The Intel® FPGA SmartNIC N6000/1-PL ships with a factory, user1, and user2 programmed image for both the FIM and BMC FW and RTL on all cards. The platform ships with a single FIM image that can be programmed into either user1 or user2, depending in the image selected.

Use the following chart for information on the Bitstream ID and Pr Interface ID, two unique values reported by `fpgainfo` which can be used to identify the loaded FIM.

##### Table 7: FIM Version Summary for OFS 2024.2-1 Release

| FIM Version | Bitstream ID | Pr Interface ID | File Name | Download Location|
| ----- | ----- | ----- | ----- | ----- |
| ofs-2024.2-1| 360571656856467345| a791757d-38a6-5159-a7fc-e1a61157a07b| ofs_top_page[1/2]_unsigned_user[1/2].bin | [ofs-2024.2-1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1)|
| ofs-n6001-0.9.0-rc2 |  0x50102025AD3DD11| 92ec8960-2f2f-5544-9804-075d2e8a71a1 | ofs_top_page[1/2]_unsigned_user[1/2].bin|[ofs-2.3.0 Release Page](https://github.com/otcshare/intel-ofs-n6001/releases/tag/ofs-n6001-0.9.1)|
| OFS-2.3.0 |  0x50102022267A9ED| f59830f7-e716-5369-a8b0-e7ea897cbf82 | ofs_top_page[1/2]_unsigned_user[1/2].bin|[ofs-2.3.0 Release Page](https://github.com/otcshare/intel-ofs-fim/releases/tag/ofs-2.3.0)|
| OFS-2.2.0 | 0x501020295B081F0 | 8c157a52-1cf2-5d37-9514-944af0a060da | ofs_top_page[1/2]_unsigned_user[1/2].bin|[ofs-2.2.0-beta Release Page](https://github.com/otcshare/intel-ofs-fim/releases/tag/ofs-2.2.0-beta)|

##### Table 8: BMC Version Summary for OFS 2024.2-1 Release
| BMC FW and RTL Version | File Name | Download Location|
| ----- | ----- | ----- |
| 3.15.2 | AC_BMC_RSU_user_retail_3.15.2_unsigned.rsu | n/a|

1. Example loading a new version of the BMC RTL and FW.

	```bash
	$ sudo fpgasupdate AC_BMC_RSU_user_retail_3.11.0_unsigned.rsu <PCI ADDRESS>
	[2022-04-14 16:32:47.93] [WARNING ] Update starting. Please do not interrupt.                                           
	[2022-04-14 16:32:47.93] [INFO    ] updating from file /home/user/AC_BMC_RSU_user_retail_3.11.0_unsigned.rsu with size 904064                                   
	[2022-04-14 16:32:47.94] [INFO    ] waiting for idle                                                                    
	[2022-04-14 16:32:47.94] [INFO    ] preparing image file                                                                
	[2022-04-14 16:33:26.98] [INFO    ] writing image file                                                                  
	(100%) [████████████████████] [904064/904064 bytes][Elapsed Time: 0:00:00.00]                                           
	[2022-04-14 16:33:26.98] [INFO    ] programming image file                                                              
	(100%) [████████████████████] [Elapsed Time: 0:00:26.02]                                                                 
	[2022-04-14 16:33:53.01] [INFO    ] update of 0000:b1:00.0 complete                                                     
	[2022-04-14 16:33:53.01] [INFO    ] Secure update OK                                                                    
	[2022-04-14 16:33:53.01] [INFO    ] Total time: 0:01:05.07
	sudo rsu bmcimg
	```

2. Example for loading a Static Region (SR) update image. This process will take up to 20 minutes.

```bash
$ sudo fpgasupdate ofs_top_page1_unsigned_user1.bin <PCI ADDRESS>
[2022-04-14 16:42:31.58] [WARNING ] Update starting. Please do not interrupt.                                           
[2022-04-14 16:42:31.58] [INFO    ] updating from file ofs_top_page1_pacsign_user1.bin with size 19928064               
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



#### 4.6.4 Signing Images with PACSign

PACSign is an OPAE utility which allows users to insert authentication markers into bitstreams targeted for the Intel® FPGA SmartNIC N6000/1-PL. PACSign also allows users updating their Static Region (SR) to designate which partition of flash (user1, user2, factory) to overwrite given a specific FIM binary image. All binary images must be signed using PACSign before fpgasupdate can use them for an update. Assuming no Root Entry Hash (REH) has been programmed on the device, the following examples demonstrate how to prepend the required secury authentication data, and specifiy which region of flash to update.
More information, including charts detailing the different certification types and their required options, are fully described in the PACsign [README](https://github.com/OPAE/opae-sdk/blob/72b8b36bd31103dd24bf8ffee1b03c9623fb0d69/python/pacsign/PACSign.md) on GitHub.

For more information on PACSign and on general security practices surrounding the Intel N6001-PL FPGA SmartNIC device, visit the [Security User Guide: Intel Open FPGA Stack](https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/).

**PACSign** can be run on images that have previously been signed. It will overwrite any existing authentication data.

The following example creates an unsigned SR image from an existing signed SR binary update image, targeting the user1 partition in flash.

```bash
$ PACSign SR -t UPDATE -s 0 -H openssl_manager -i ofs_top_page1_pacsign_user1.bin -o new_image.bin
No root key specified.  Generate unsigned bitstream? Y = yes, N = no: y
No CSK specified.  Generate unsigned bitstream? Y = yes, N = no: y
No root entry hash bitstream specified.  Verification will not be done.  Continue? Y = yes, N = no: y
2021-10-18 14:42:54,490 - PACSign.log - WARNING - Bitstream is already signed - removing signature blocks
```

--->

#### 4.6.5 Loading Images with rsu

The **rsu** performs a Remote System Update operation on a N6000/1-PL device, given its PCIe address. An **rsu** operation sends an instruction to the device to trigger a power cycle of the card and forces reconfiguration from flash for either the BMC or FPGA image.

The Intel® FPGA SmartNIC N6000/1-PL contains two regions of flash you may store FIM images. These locations are referred to as **user1** and **user2**. After an image has been programmed with fpgasupdate in either of these regions you may choose to perform an rsu to switch. This operation indicates to the BMC which region to configure the FPGA device from after power-on.

If the **factory** image has been updated, Intel strongly recommends the user to immediately RSU to the factory image to ensure the image is functional.

The user can determine which region of flash was used to configure their FPGA device using the command `fpgainfo fme` and referring to the row labelled **Boot Page**.

```bash
$ sudo fpgainfo fme | grep Boot
Boot Page                        : user1
```

Swapping between **user1** and **user2** skips load times that are created when using `fpgasupdate` to flash a new FIM image.

**`rsu` Overview**

**Mode 1: RSU**

Perform RSU (remote system update) operation on a development platform given its PCIe address. An RSU operation sends an instruction to the device to trigger a power cycle of the card only. This will force reconfiguration from flash for either BMC, Retimer, SDM, (on devices that support these) or the FPGA.

**Mode 2: Default FPGA Image**

Set the default FPGA boot sequence. The --page option determines the primary FPGA boot image. The --fallback option allows a comma-separated list of values to specify fallback images.

The following example will load an image stored in **user2**.

```bash
$ sudo rsu fpga --page=user2 0000:b1:00.0
2022-04-15 09:25:22,951 - [[pci_address(0000:b1:00.0), pci_id(0x8086, 0xbcce)]] performing RSU operation
2022-04-15 09:25:22,955 - [[pci_address(0000:b0:02.0), pci_id(0x8086, 0x347a)]] removing device from PCIe bus
2022-04-15 09:25:22,998 - waiting 10 seconds for boot
2022-04-15 09:25:33,009 - rescanning PCIe bus: /sys/devices/pci0000:b0/pci_bus/0000:b0
2022-04-15 09:25:34,630 - RSU operation complete
```

*Note: As a result of using the **rsu** command, the host rescans the PCI bus and may assign a different Bus/Device/Function (B/D/F) value than the originally assigned value.*



#### 4.6.6 Verify FME Interrupts with hello_events

The **hello_events** utility is used to verify FME interrupts. This tool injects FME errors and waits for error interrupts, then clears the errors.

Sample output from `sudo hello_events`.

```bash
$ sudo hello_events
Waiting for interrupts now...
injecting error
FME Interrupt occurred
Successfully tested Register/Unregister for FME events!
clearing error
```



#### 4.6.7 Host Exercisor Modules

The reference FIM and unchanged FIM compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. There are three HEMs present in the Intel OFS Reference FIM - HE-LPBK, HE-MEM, and HE-HSSI. These exercisers are tied to three different VFs that must be enabled before they can be used.
Execution of these exercisers requires you bind specific VF endpoint to **vfio-pci**. The host-side software looks for these endpoints to grab the correct FPGA resource.

Refer to the Intel [Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/) for a full description of these modules.

##### Table 9: Module PF/VF Mappings

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

##### 4.6.7.1 HE-MEM / HE-LB

The host exerciser used to exercise and characterize the various host-FPGA interactions eg. MMIO, Data transfer from host to FPGA , PR, host to FPGA memory etc.
**Host Exerciser Loopback (HE-LBK)** AFU can move data between host memory and FPGA.

HE-LBK supports:
- Latency (AFU to Host memory read)
- MMIO latency (Write+Read)
- MMIO BW (64B MMIO writes)
- BW (Read/Write, Read only, Wr only)

**Host Exerciser Loopback Memory (HE-MEM)** AFU is used to exercise use of FPGA connected DDR, data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host.

**HE-LB** is responsible for generating traffic with the intention of exercising the path from the AFU to the Host at full bandwidth. **HE-MEM** is used to exercise use of FPGA connected DDR; data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host. **HE-MEM** uses external DDR memory (i.e. EMIF) to store data. It has a customized version of the AVMM interface to communicate with the EMIF memory controller. Both exercisers rely on the user-space tool host_exerciser. When using the Intel N6001-PL FPGA SmartNIC Platform, optimal performance requires the exercisers be run at 400 MHz.

Execution of these exercisers requires you to bind specific VF endpoint to **vfio-pci**. The following commands will bind the correct endpoint for a device with B/D/F 0000:b1:00.0 and run through a basic loopback test.

**Note:** While running the `opae.io init` command listed below, if no output is present after completion then the command has failed. Double check that Intel VT-D and IOMMU have been enabled in the kernel as discussed in step 12 in section [3.1 Intel OFS DFL Kernel Driver Environment Setup](#31-ofs-dfl-kernel-driver-environment-setup).
	
```bash
$ sudo pci_device  0000:b1:00.0 vf 3
$ sudo opae.io init -d 0000:b1:00.2 user:user
Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci                                                                  
Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci 
iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 188                                                                  
Assigning /dev/vfio/188 to DCPsupport                                                                                  
Changing permissions for /dev/vfio/188 to rw-rw----


$ sudo host_exerciser --clock-mhz 400 lpbk
starting test run, count of 1
API version: 4
Bus width: 64 bytes
AFU clock from command line: 400 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1025
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 2895
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 9.055 GB/s
    Test lpbk(1): PASS
```

The following example will run a loopback throughput test using one cacheline per request.

```bash
$ sudo pci_device  0000:b1:00.0 vf 3
$ sudo opae.io init -d 0000:b1:00.2 user:user
$ sudo host_exerciser --clock-mhz 400 --mode trput --cls cl_1 lpbk
starting test run, count of 1
API version: 4
Bus width: 64 bytes
AFU clock from command line: 400 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 512
    Host Exerciser numWrites: 513
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 1663
    Total number of Reads sent: 512
    Total number of Writes sent: 512
    Bandwidth: 15.763 GB/s
    Test lpbk(1): PASS
```

##### 4.6.7.2 Traffic Generator AFU Test Application

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
$ mem_tg tg_test
[2024-06-26 10:27:31.317] [tg_test] [info] starting test run, count of 1
Memory channel clock frequency unknown. Assuming 300 MHz.
Channel 0:
TG PASS
Mem Clock Cycles: 127
DEBUG: wcnt_ 1
DEBUG: rcnt_ 1
DEBUG: bcnt_ 1
DEBUG: loop_ 1
DEBUG: num_ticks 127
Write BW: 0.151181 GB/s
Read BW: 0.151181 GB/s
Thread on channel 0 exited with status 0
[2024-06-26 10:27:31.318] [tg_test] [info] Test tg_test(1): PASS
```

Target channel 1 with a 1MB single-word write only test for 1000 iterations

```bash
$ mem_tg --loops 1000 -r 0 -w 2000 -m 1 tg_test
[2024-06-26 10:28:17.861] [tg_test] [info] starting test run, count of 1
Memory channel clock frequency unknown. Assuming 300 MHz.
Channel 1:
TG PASS
Mem Clock Cycles: 4379946
DEBUG: wcnt_ 2000
DEBUG: rcnt_ 0
DEBUG: bcnt_ 1
DEBUG: loop_ 1000
DEBUG: num_ticks 4379946
Write BW: 8.76723 GB/s
Read BW: 0 GB/s

Thread on channel 1 exited with status 0
```

Target channel 2 with 4MB write/read test of max burst length for 10 iterations

```bash
$ mem_tg --loops 10 -r 8 -w 8 --bls 255 -m 2 tg_test
[2024-06-26 10:29:04.653] [tg_test] [info] starting test run, count of 1
Memory channel clock frequency unknown. Assuming 300 MHz.
Channel 2:
TG PASS
Mem Clock Cycles: 89462
DEBUG: wcnt_ 8
DEBUG: rcnt_ 8
DEBUG: bcnt_ 255
DEBUG: loop_ 10
DEBUG: num_ticks 89462
Write BW: 4.37817 GB/s
Read BW: 4.37817 GB/s

Thread on channel 2 exited with status 0
```

```bash
$ sudo mem_tg --loops 1000 -r 2000 -w 2000 --stride 2 --bls 2  -m 1 tg_test
[2024-06-26 10:29:27.509] [tg_test] [info] starting test run, count of 1
Memory channel clock frequency unknown. Assuming 300 MHz.
Channel 1:
TG PASS
Mem Clock Cycles: 17565290
DEBUG: wcnt_ 2000
DEBUG: rcnt_ 2000
DEBUG: bcnt_ 2
DEBUG: loop_ 1000
DEBUG: num_ticks 17565290
Write BW: 4.37226 GB/s
Read BW: 4.37226 GB/s

Thread on channel 1 exited with status 0
[2024-06-26 10:29:27.568] [tg_test] [info] Test tg_test(1): PASS
```

##### 4.6.7.3 HE-HSSI

HE-HSSI is responsible for handling client-side ethernet traffic. It wraps the 10G and 100G HSSI AFUs, and includes a traffic generator and checker. The user-space tool hssi exports a control interface to the HE-HSSI's AFU's packet generator logic.

The hssi application provides a means of interacting with the 10G and with the 100G HSSI AFUs. In both 10G and 100G operating modes, the application initializes the AFU, completes the desired transfer as described by the mode- specific options, and displays the ethernet statistics by invoking ethtool --statistics INTERFACE.


The following example walks through the process of binding the VF corresponding with the HE-HSSI exerciser to vfio-pci, sending traffic, and verifying that traffic was received.

**1.** **Create** 3 VFs in the PR region.

```bash
$ sudo pci_device b1:00.0 vf 3 
```

**2.** Verify all 3 VFs were created.

```bash
$ lspci -s b1:00 
b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01) 
b1:00.1 Processing accelerators: Intel Corporation Device bcce 
b1:00.2 Processing accelerators: Intel Corporation Device bcce 
b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device 
b1:00.4 Processing accelerators: Intel Corporation Device bcce 
b1:00.5 Processing accelerators: Intel Corporation Device bccf 
b1:00.6 Processing accelerators: Intel Corporation Device bccf 
b1:00.7 Processing accelerators: Intel Corporation Device bccf 
```

**3.** **Bind** all of the PF/VF endpoints to the `vfio-pci` driver.

```bash
$ sudo opae.io init -d 0000:b1:00.1 user:user
Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 187
Assigning /dev/vfio/187 to DCPsupport
Changing permissions for /dev/vfio/187 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.2 user:user
Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 188
Assigning /dev/vfio/188 to DCPsupport
Changing permissions for /dev/vfio/188 to rw-rw----

...

$ sudo opae.io init -d 0000:b1:00.7 user:user
Binding (0x8086,0xbccf) at 0000:b1:00.7 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.7 is 319
Assigning /dev/vfio/319 to DCPsupport
Changing permissions for /dev/vfio/319 to rw-rw----
```

**4.** Check that the accelerators are present using `fpgainfo`. *Note your port configuration may differ from the below.*

```bash
$ sudo fpgainfo port 
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

The following table contains a mapping between each VF, Accelerator GUID, and component.

###### Table 10: Accelerator PF/VF and GUID Mappings

| Component| VF| Accelerator GUID|
| -----| -----| -----|
| Intel N6000/1-PL FPGA SmartNIC Platform base PF| XXXX:XX:XX.0| N/A|
| VirtIO Stub| XXXX:XX:XX.1|3e7b60a0-df2d-4850-aa31-f54a3e403501|
| HE-MEM Stub| XXXX:XX:XX.2| 56e203e9-864f-49a7-b94b-12284c31e02b|
| Copy Engine| XXXX:XX:XX.4| 44bfc10d-b42a-44e5-bd42-57dc93ea7f91|
| HE-MEM| XXXX:XX:XX.5| 8568ab4e-6ba5-4616-bb65-2a578330a8eb |
| HE-HSSI| XXXX:XX:XX.6| 823c334c-98bf-11ea-bb37-0242ac130002 |
| MEM-TG| XXXX:XX:XX.7| 4dadea34-2c78-48cb-a3dc-5b831f5cecbb |

**5.** Check Ethernet PHY settings with `fpgainfo`.

```bash
$ sudo fpgainfo phy -B 0xb1 
IIntel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.2
Board Management Controller Build version: 3.15.2
//****** FME ******//
Object Id                        : 0xED00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 360571656856467345
Bitstream Version                : 5.0.1
Pr Interface Id                  : a791757d-38a6-5159-a7fc-e1a61157a07b
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

**6.** Set loopback mode.

```bash
$ sudo hssiloopback --loopback enable  --pcie-address 0000:b1:00.0 
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

**7.** Send traffic through the 10G AFU.

```bash
$ sudo hssi --pci-address b1:00.6 hssi_10g --num-packets 100       
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

The `hssi_loopback` utility works in conjunction with a packet generator accelerator function unit (AFU) to test high-speed serial interface (HSSI) cards. The hssi_loopback utility tests both external and internal loopbacks.

The `hssistats` tool provides the MAC statistics.

## 5.0 Upgrading the Intel® FPGA SmartNIC N6000/1-PL with 2024.2-1 Version of the BMC and FIM

If your Intel® FPGA SmartNIC N6000/1-PL does not have the 2024.1 version of the FIM and BMC, use this section to begin your upgrade process. The upgrade process depends on both the OPAE SDK and kernel drivers, which were installed in the [Software Installation Guide: PCIe Attach](/ofs-2024.2-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach.md). Use the output of **fpgainfo** and compare against the table below to determine if an upgade is necessary.

### Table 11: FIM Version Summary for Intel OFS 2024.2-1 Release

| FIM Version | Bitstream ID | Pr Interface ID | File Name | Download Location|
| ----- | ----- | ----- | ----- | ----- |
| 1 | 360571656856467345 | a791757d-38a6-5159-a7fc-e1a61157a07b | ofs_top_page[1 / 2]_unsigned_user[1 / 2].bin|[ofs-2024.2-1 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1)|

### Table 12: BMC Version Summary for Intel OFS 2024.2-1 Release

| BMC FW and RTL Version | File Name | Download Location|
| ----- | ----- | ----- |
| 3.15.2 | AC_BMC_RSU_user_retail_3.15.2_unsigned.rsu | n/a|

Sample output of `fpgainfo` with matching values:

```bash
Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.2
Board Management Controller Build version: 3.15.2
//****** FME ******//
Object Id                        : 0xED00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 360571656856467345
Bitstream Version                : 5.0.1
Pr Interface Id                  : a791757d-38a6-5159-a7fc-e1a61157a07b
Boot Page                        : user1
Factory Image Info               : a2b5fd0e7afca4ee6d7048f926e75ac2
User1 Image Info                 : a791757d-38a6-5159-a7fc-e1a61157a07b
User2 Image Info                 : a791757d-38a6-5159-a7fc-e1a61157a07b
```

1. If your output does not match the table above, download the appropriate FIM image from the [Intel OFS 2024.2-1 (Intel Agilex)](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.2-1) release page. Once downloaded transfer the file over to the server and use the **fpgasupdate** utility to perform an upgrade of the BMC.

```bash
$ sudo fpgasupdate AC_BMC_RSU_user_retail_3.15.2_unsigned.rsu
[2022-04-14 16:32:47.93] [WARNING ] Update starting. Please do not interrupt.                                           
[2022-04-14 16:32:47.93] [INFO    ] updating from file /home/user/AC_BMC_RSU_user_retail_3.15.2_unsigned.rsu with size 904064                                   
[2022-04-14 16:32:47.94] [INFO    ] waiting for idle                                                                    
[2022-04-14 16:32:47.94] [INFO    ] preparing image file                                                                
[2022-04-14 16:33:26.98] [INFO    ] writing image file                                                                  
(100%) [████████████████████] [904064/904064 bytes][Elapsed Time: 0:00:00.00]                                           
[2022-04-14 16:33:26.98] [INFO    ] programming image file                                                              
(100%) [████████████████████] [Elapsed Time: 0:00:26.02]                                                                 
[2022-04-14 16:33:53.01] [INFO    ] update of 0000:b1:00.0 complete                                                     
[2022-04-14 16:33:53.01] [INFO    ] Secure update OK                                                                    
[2022-04-14 16:33:53.01] [INFO    ] Total time: 0:01:05.07
sudo rsu bmcimg
```
2. Load the new FIM image.

	```bash
	$ sudo fpgasupdate ofs_top_page1_unsigned_user1.bin <PCI ADDRESS>
	[2022-04-14 16:42:31.58] [WARNING ] Update starting. Please do not interrupt.                                           
	[2022-04-14 16:42:31.58] [INFO    ] updating from file ofs_top_page1_pacsign_user1.bin with size 19928064               
	[2022-04-14 16:42:31.60] [INFO    ] waiting for idle                                                                    
	[2022-04-14 16:42:31.60] [INFO    ] preparing image file                                                                
	[2022-04-14 16:42:38.61] [INFO    ] writing image file                                                                  
	(100%) [████████████████████] [19928064/19928064 bytes][Elapsed Time: 0:00:16.01]                                       
	[2022-04-14 16:42:54.63] [INFO    ] programming image file                                                              
	(100%) [████████████████████][Elapsed Time: 0:06:16.40]                                                                 
	[2022-04-14 16:49:11.03] [INFO    ] update of 0000:b1:00.0 complete                                                     
	[2022-04-14 16:49:11.03] [INFO    ] Secure update OK                                                                    
	[2022-04-14 16:49:11.03] [INFO    ] Total time: 0:06:39.45
	sudo rsu fpga --page=user1 <PCI ADDRESS>
	```

3. Verify output of **fpgainfo** matches the table above.


## Notices & Disclaimers

Intel<sup>&reg;</sup> technologies may require enabled hardware, software or service activation.
No product or component can be absolutely secure. 
Performance varies by use, configuration and other factors.
Your costs and results may vary. 
You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Intel products described herein. You agree to grant Intel a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein.
No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document.
The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications.  Current characterized errata are available on request.
Intel disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade.
You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. 
<sup>&copy;</sup> Intel Corporation.  Intel, the Intel logo, and other Intel marks are trademarks of Intel Corporation or its subsidiaries.  Other names and brands may be claimed as the property of others. 

OpenCL and the OpenCL logo are trademarks of Apple Inc. used by permission of the Khronos Group™. 
<!-- include ./docs/hw/n6001/doc_modules/links.md -->  
<!-- include ./docs/hw/doc_modules/links.md -->
