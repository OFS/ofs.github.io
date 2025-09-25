# Getting Started Guide: Open FPGA Stack for Intel Stratix 10

Last updated: **September 25, 2025** 

## 1.0 Introduction

This document helps users get started in evaluating Open FPGA Stack (OFS) for Stratix® 10 FPGA targeting the Intel® FPGA PAC D5005. After reviewing the document a user shall be able to:

- Set up a development environment with all OFS ingredients
- Build and install the OFS Linux Kernel drivers on the host
- Build and install the Open Programmable Acceleration Engine Software Development Kit (OPAE SDK) on the host
- Flash an OFS FIM binary onto the Intel® FPGA PAC D5005
- Verify the functionality of OFS on an Intel® FPGA PAC D5005 board
- Know where to find additional information on all OFS ingredients

The following flow charts show a high level overview of the initial bring-up process, split into three sequential diagrams.

#### Diagram 1: Installing the OPAE SDK

![UG_1](.images/UG_DIAGRAM_1_D5005.png)

#### Diagram 2: Installing the Linux DFL Drivers

![UG_2](.images/UG_DIAGRAM_2_D5005.png)

#### Diagram 3: Bringing up the Intel D5005

![UG_3](./images/UG_DIAGRAM_3_D5005.png)

### 1.1 Intended Audience

The information in this document is intended for customers evaluating the Open FPGA Stack for Stratix® 10 FPGA on the Intel PAC D5005. This document will cover key topics related to initial setup and development, with links for deeper dives on the topics discussed therein.

### 1.2 Terminology

| Term     | Description                                                  |
| -------- | ------------------------------------------------------------ |
| AER | Advanced Error Reporting, The PCIe AER driver is the extended PCI Express error reporting capability providing more robust error reporting. |
| AFU      | Accelerator Functional Unit, Hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance. Note: An AFU region is the part of the design where an AFU may reside. This AFU may or may not be a partial reconfiguration region |
| BBB | Basic Building Block, Features within an AFU or part of an FPGA interface that can be reused across designs. These building blocks do not have stringent interface requirements like the FIM's AFU and host interface requires. All BBBs must have a (globally unique identifier) GUID. |
| BKC      | Best Known Configuration, The exact hardware configuration Intel has optimized and validated the solution against. |
| BMC      | Board Management Controller, Acts as the Root of Trust (RoT) on the Intel FPGA PAC platform. Supports features such as power sequence management and board monitoring through on-board sensors. |
| CSR | Command/status registers (CSR) and software interface, OFS uses a defined set of CSR's to expose the functionality of the FPGA to the host software. |
| DFL      | Device Feature List, A concept inherited from OFS. The DFL drivers provide support for FPGA devices that are designed to support the Device Feature List. The DFL, which is implemented in RTL, consists of a self-describing data structure in PCI BAR space that allows the DFL driver to automatically load the drivers required for a given FPGA configuration. |
| FIM      | FPGA Interface Manager, Provides platform management, functionality, clocks, resets and standard interfaces to host and AFUs. The FIM resides in the static region of the FPGA and contains the FPGA Management Engine (FME) and I/O ring. |
| FME      | FPGA Management Engine, Provides a way to manage the platform and enable acceleration functions on the platform. |
| HEM      | Host Exerciser Module, Host exercisers are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. |
| Intel FPGA PAC D5005 | Intel FPGA Programmable Acceleration Card D5005, A high performance PCI Express (PCIe)-based FPGA acceleration card for data centers. This card is the target platform for the initial OFS release. |
| Intel VT-d | Intel Virtualization Technology for Directed I/O, Extension of the VT-x and VT-I processor virtualization technologies which adds new support for I/O device virtualization. |
| IOCTL | Input/Output Control, System calls used to manipulate underlying device parameters of special files. |
| JTAG     | Joint Test Action Group, Refers to the IEEE 1149.1 JTAG standard; Another FPGA configuration methodology. |
| MMIO | Memory Mapped Input/Output, Users may map and access both control registers and system memory buffers with accelerators. |
| OFS      | Open FPGA Stack, A modular collection of hardware platform components, open source software, and broad ecosystem support that provides a standard and scalable model for AFU and software developers to optimize and reuse their designs. |
| OPAE SDK | Open Programmable Acceleration Engine Software Development Kit, A collection of libraries and tools to facilitate the development of software applications and accelerators using OPAE. |
| PAC | Programmable Acceleration Card: FPGA based Accelerator card |
| PIM      | Platform Interface Manager, An interface manager that comprises two components: a configurable platform specific interface for board developers and a collection of shims that AFU developers can use to handle clock crossing, response sorting, buffering and different protocols. |
| PR       | Partial Reconfiguration, The ability to dynamically reconfigure a portion of an FPGA while the remaining FPGA design continues to function. In the context of Intel FPGA PAC, a PR bitstream refers to an Intel FPGA PAC AFU. Refer to [Partial Reconfiguration](https://www.intel.com/content/www/us/en/programmable/products/design-software/fpga-design/quartus-prime/features/partial-reconfiguration.html) support page. |
| RSU      | Remote System Update, A Remote System Update operation sends an instruction to the Intel FPGA PAC D5005 device that triggers a power cycle of the card only, forcing reconfiguration. |
| SR-IOV | Single-Root Input-Output Virtualization, Allows the isolation of PCI Express resources for manageability and performance. |
| TB | Testbench, Testbench or Verification Environment is used to check the functional correctness of the Design Under Test (DUT) by generating and driving a predefined input sequence to a design, capturing the design output and comparing with-respect-to expected output. |
| UVM | Universal Verification Methodology, A modular, reusable, and scalable testbench structure via an API framework. |
| VFIO | Virtual Function Input/Output, An IOMMU/device agnostic framework for exposing direct device access to userspace. |

### 1.3 Reference Documents



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
  

### 1.4 Component Version Summary

The OFS 2024.1-1 Release targeting the Stratix® 10 FPGA is built upon tightly coupled software and firmware versions. Use this section as a general reference for the versions which comprise this release.

The following table highlights the hardware which makes up the Best Known Configuration (BKC) for the OFS 2024.1-1 release.

#### Table 1-2: Hardware BKC

| Component |
| --------- |
| 1 x Intel® FPGA PAC D5005 |
| 1 x [Supported Server Model](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/pac/d5005/view.html) |
| 1 x [Intel FPGA Download Cable II](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/cables-adapters.html)   *(Optional, only required if loading images via JTAG)* |

The following table highlights the versions of the software which comprise the OFS stack. The installation of the user-space OPAE SDK on top of the kernel-space linux-dfl drivers is discussed in subsequent sections of this document.

#### Table 1-3: Software Version Summary

| Component | Version |
| --------- | ------- |
| FPGA Platform | [Intel® FPGA PAC D5005](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/pac/d5005.html) |
| OPAE SDK | [Tag: 2.12.0-5](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5) |
| Kernel Drivers | [Tag: ofs-2024.1-6.1-2](https://github.com/OPAE/linux-dfl/releases/tag/ofs-2024.1-6.1-2) |
| OFS FIM Source Code| [Branch: ofs-2024.1-1](https://github.com/OFS/ofs-fim-common/tree/ofs-2024.1-1) |
| Intel Quartus Prime Pro Edition Design Software | 23.4 [Intel® Quartus® Prime Pro Edition Linux] |
| Operating System | [RHEL 8.6](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.2/x86_64/product-software) |

A download page containing the release and already-compiled FIM binary artifacts that you can use for immediate evaluation on the Intel® FPGA PAC D5005 can be found on the [OFS 2024.1-1](https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1) official release drop on GitHub.

**Note:** If you wish to freeze your Red Hat operating system version on the RHEL 8.6, refer to the following [solution](https://access.redhat.com/solutions/238533) provided in the Red Hat customer portal.

### 1.5 Host BIOS

These are the host BIOS settings required to work with the OFS stack, which relies on SR-IOV for some of its functionality. Information about any given server's currently loaded firmware and BIOS settings can be found through its remote access controller, or by manually entering the BIOS by hitting a specific key during power on. Your specific server platform will include instructions on proper BIOS configuration and should be followed when altering settings. Ensure the following has been set:

- PCIe slot width **must** be set to your design's width (1x16, 2x8)
- PCIe slot generation **must** be set to your design's supported generation (3, 4, 5)
- Intel VT for Directed I/O (VT-d) must be enabled

Specific BIOS paths are not listed here as they can differ between BIOS vendors and versions.

### 1.6 Host Server Kernel and GRUB Configuration

While many host Linux kernel and OS distributions may work with this design, only the following configuration(s) have been tested. You will need to download and install the OS on your host of choice; we will build the required kernel alongside the Linux DFL driver set.

* OS: RedHat® Enterprise Linux® (RHEL) 8.6
* Kernel: 6.1.78

## 2.0 OFS Stack Architecture Overview for Reference Platform

### 2.1 Hardware Components

The OFS hardware architecture decomposes all designs into a standard set of modules, interfaces, and capabilities. Although the OFS infrastructure provides a standard set of functionality and capability, the user is responsible for making the customizations to their specific design in compliance with the specifications outlined in the [Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/latest/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/).

OFS is a blanket term which can be used to collectively refer to all ingredients of the OFS reference design, which includes the core hardware components discussed below and software.

#### 2.1.1 FPGA Interface Manager

The FPGA Interface Manager (FIM) or 'shell' provides platform management functionality, clocks, resets, and interface access to the host and peripheral features on the acceleration platform. The FIM is implemented in a static region of the FPGA device.

The primary components of the FIM reference design are:

- PCIe Subsystem
- Transceiver Subsystem
- Memory Subsystem
- FPGA Management Engine
- AFU Peripheral Fabric for AFU accesses to other interface peripherals
- Board Peripheral Fabric for master to slave CSR accesses from host or AFU
- Interface to Board Management Controller (BMC)

The FPGA Management Engine (FME) provides management features for the platform and the loading/unloading of accelerators through partial reconfiguration.

For more information on the FIM and its external connections, please refer to the [Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/latest/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/), and the [Intel FPGA Programmable Acceleration Card D5005 Data Sheet](https://www.intel.com/content/www/us/en/programmable/documentation/cvl1520030638800.html). Below is a high-level block diagram of the FIM.

**Figure 2-1 FIM Overview**

![fim-overview](/ofs-2025.1-1/hw/d5005/user_guides/ug_qs_ofs_d5005/images/Fabric_Features.png){ align=left }

#### 2.1.2 AFU

An AFU is an acceleration workload that interfaces to the FIM. The AFU boundary in this reference design comprises both static and partial reconfiguration (PR) regions. You can decide how you want to partition these two areas or if you want your AFU region to only be a partial reconfiguration region. A port gasket within the design provides all the PR specific modules and logic required for partial reconfiguration. Only one partial reconfiguration region is supported in this design.

Similar to the FME, the port gasket exposes its capabilities to the host software driver through a DFH register placed at the beginning of the port gasket CSR space. In addition, only one PCIe link can access the port register space.

You can compile your design in one of the following ways:

- Your AFU resides in a partial reconfiguration (PR) region of the FPGA.
- Your AFU is a part of the static region (SR) and is a compiled flat design.
- Your AFU contains both static and PR regions.

The AFU provided in this release is comprised of the following functions:

- AFU interface handler to verify transactions coming from the AFU region.
- PV/VF Mux to route transactions to and from corresponding AFU components, including the ST2MM module, PCIe loopback host exerciser (HE-LB), HSSI host exerciser (HE-HSSI), and Memory Host Exerciser (HE-MEM).
- AXI4 Streaming to Memory Map (ST2MM) Module that routes MMIO CSR accesses to FME and board peripherals.
- Host exercisers to test PCIe, memory and HSSI interfaces (these can be removed from the AFU region after your FIM design is complete to provide more resource area for workloads).
- Port gasket and partial reconfiguration support.

For more information on the Platform Interface Manager (PIM) and AFU development and testing, please refer to the [OFS AFU Development Guide].

### 2.2 OFS Software Overview

#### 2.2.1 Kernel Drivers for OFS

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks like DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality. An in depth look at the various aspects of the driver architecture such as the API, an explanation of the DFL framework, and instructions on how to port DFL driver patches to other kernel distributions can be found on the [DFL Wiki](https://github.com/OPAE/linux-dfl/wiki) page.

## 3.0 Intel FPGA PAC D5005 Card Installation and Server Requirements

Currently OFS for Stratix® 10 FPGA targets the Intel® FPGA PAC D5005. Because the Intel® FPGA PAC D5005 is a production card, you must prepare the card in order to receive a new non-production bitstream. For these instructions, please contact an Intel representative.

## 4.0 OFS DFL Kernel Drivers

### 4.1 OFS DFL Kernel Driver Installation

All OFS DFL kernel driver code resides in the [Linux DFL](https://github.com/OFS/linux-dfl) GitHub repository. This repository is open source and does not require any permissions to access. It includes a snapshot of the latest best-known configuration (BKC) Linux kernel with the OFS driver included in the `drivers/fpga/*` directory. Downloading, configuration, and compilation will not be discussed in this document. Please refer to the [Software Installation Guide: OFS for PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach) for guidelines on environment setup and build steps for all OFS stack components.

The DFL driver suite can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2024.1-1 Release Page](https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1).

It is recommended you boot into your operating system's native *4.18.x* kernel before attempting to upgrade to the dfl enabled *6.1.78* You may experience issues when moving between two dfl enabled *6.1.78* kernels.

This installation process assumes the user has access to an internet connection in order to pull specific GitHub repositories, and to satisfy package dependencies.

### 4.2 OFS DFL Kernel Driver Installation Environment Setup

All OFS DFL kernel driver primary release code for this release resides in the [Linux DFL GitHub repository](https://github.com/OFS/linux-dfl). This repository is open source and does not require any special permissions to access. It includes a snapshot of the Linux kernel with *most* of the OFS DFL drivers included in `/drivers/fpga/*`. Download, configuration, and compilation will be discussed in this section. Refer back to section [1.6 Host Server Kernel and GRUB Configuration](#16-host-server-kernel-and-grub-configuration) for a list of supported Operating System(s).

You can choose to install the DFL kernel drivers by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on your platform's release page, skip to section [4.4 Installing the OFS DFL Kernel Drivers from Pre-Built Packages](#43-installing-the-ofs-dfl-kernel-drivers-from-pre-built-packages). Regardless of your choice you will need to follow the two steps in this section to prepare your server environment for installation.

This installation process assumes the user has access to an internet connection to clone specific GitHub repositories, and to satisfy package dependencies.

1. It is recommended you lock your Red Hat release version to RedHatEnterprise Linux® (RHEL) 8.6 to prevent accidental upgrades. Update installed system packages to their latest versions. We need to enable the code-ready-builder and EPEL repositories.

    ```bash
    subscription-manager release --set=8.6
    sudo dnf update
    subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
    sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    ```

2. Install the following package dependencies if building and installing drivers from source. If you do not require the use of a proxy to pull in downloads using `dnf`, you can safely remove those parameters from the following commands:
    
    ```bash
    If you require the use of a proxy, add it to DNF using by editing the following file
    sudo nano /etc/dnf/dnf.conf
    # Include your proxy by adding the following line, replacing the URL with your proxy's URL
    # proxy=http://proxy.server.com:port
    
    sudo dnf install python3 python3-pip python3-devel python3-jsonschema python3-pyyaml git gcc gcc-c++ make cmake libuuid-devel json-c-devel hwloc-devel tbb-devel cli11-devel spdlog-devel libedit-devel systemd-devel doxygen python3-sphinx pandoc rpm-build rpmdevtools python3-virtualenv yaml-cpp-devel libudev-devel libcap-devel numactl-devel bison flex automake autoconf libtools
    
    python3 -m pip install --user jsonschema virtualenv pudb pyyaml setuptools pybind11

    # If setuptools and pybind11 were already installed

    python3 -m pip install --upgrade --user pybind11 setuptools
    ```

### 4.3 Building and Installing the OFS DFL Kernel Drivers from Source

It is recommended you create an empty top level directory for your OFS related repositories to keep the working environment clean. All steps in this installation will use a generic top-level directory at `/home/OFS/`. If you have created a different top-level directory, replace this path with your custom path.

1. Initialize an empty git repository and clone the DFL driver source code:

    ```bash
    mkdir /home/OFS/
    cd /home/OFS/
    git init
    git clone https://github.com/OFS/linux-dfl
    cd /home/OFS/linux-dfl
    git checkout tags/ofs-2024.1-6.1-2
    ```

    *Note: The linux-dfl repository is roughly 5 GB in size.*

2. Verify that the correct tag/branch have been checked out.

    ```bash
    git describe --tags
    ofs-2024.1-6.1-2
    ```
    
    *Note: If two different tagged releases are tied to the same commit, running git describe tags may report the other release's tag. This is why the match is made explicit.*        

3. Copy an existing kernel configuration file from `/boot` and apply the minimal required settings changes.
    
    ```bash
    cd /home/OFS/linux-dfl
    cp /boot/config-`uname -r` .config
    cat configs/dfl-config >> .config
    echo 'CONFIG_LOCALVERSION="-dfl"' >> .config
    echo 'CONFIG_LOCALVERSION_AUTO=y' >> .config
    sed -i -r 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/' .config
    sed -i '/^CONFIG_DEBUG_INFO_BTF/ s/./#&/' .config
    echo 'CONFIG_DEBUG_ATOMIC_SLEEP=y' >> .config
    export LOCALVERSION=
    ```

    *Note:* If you wish to add an identifier to the kernel build, edit .config and make your additions to the line CONFIG_LOCALVERSION="<indentifier>".

4. The above command may report errors resembling `symbol value 'm' invalid for CHELSIO_IPSEC_INLINE`. These errors indicate that the nature of the config has changed between the currently executing kernel and the kernel being built. The option "m" for a particular kernel module is no longer a valid option, and the default behavior is to simply turn the option off. However, the option can likely be turned back on by setting it to 'y'. If the user wants to turn the option back on, change it to 'y' and re-run "make olddefconfig":
    
    ```bash
    cd /home/OFS/linux-dfl
    echo 'CONFIG_CHELSIO_IPSEC_INLINE=y' >> .config
    ```
    
    *Note: To use the built-in GUI menu for editing kernel configuration parameters, you can opt to run `make menuconfig`.*
    
5. Linux kernel builds take advantage of multiple processors to parallelize the build process. Display how many processors are available with the `nproc` command, and then specify how many make threads to utilize with the `-j` option. Note that number of threads can exceed the number of processors. In this case, the number of threads is set to the number of processors in the system.
    
    ```bash
    cd /home/OFS/linux-dfl
    make -j $(nproc)
    ```
    
6. You have two options to build the source:

    - Using the built-in install option from the kernel Makefile.
    - Locally building a set of RPM/DEP packages.
    
    This first flow will directly install the kernel and kernel module files without the need to create a package first:

    ```bash
    cd /home/OFS/linux-dfl
    sudo make modules_install -j $(nproc)
    sudo make install
    ```

    In this second flow, the OFS Makefile contains a few options for package creation:
    
    - rpm-pkg: Build both source and binary RPM kernel packages
    - binrpm-pkg: Build only the binary kernel RPM package
    - deb-pkg: Build both source and binary deb kernel packages
    - bindeb-pkg: Build only the binary kernel deb package
    
    If you are concerned about the size of the resulting package and binaries, they can significantly reduce the size of the package and object files by using the make variable INSTALL_MOD_STRIP. If this is not a concern, feel free to skip this step. The below instructions will build a set of binary RPM packages:

    ```bash
    cd /home/OFS/linux-dfl
    make INSTALL_MOD_STRIP=1 binrpm-pkg -j `nproc`
    ```

    If the kernel development package is necessary for other software you plan on installing outside of OFS, you should instead use the build target `rpm-pkg`. 
    
    By default, a directory is created in your home directory called `rpmbuild`. This directory will house all the kernel packages which have been built. You need to navigate to the newly built kernel packages and install them. The following files were generated using the build command executed in the previous step:

    ```bash
    cd ~/rpmbuild/RPMS/x86_64
    ls
    kernel-5.14.0_dfl.x86_64.rpm  kernel-headers-6.1.78_dfl.x86_64.rpm
    sudo dnf localinstall kernel*.rpm
    ```

7. The system will need to be rebooted in order for changes to take effect. After a reboot, select the newly built kernel as the boot target. This can be done pre-boot using the command `grub2-reboot`, which removes the requirement for user intervention. After boot, verify that the currently running kernel matches expectation.

    ```bash
    uname -r
    6.1.78-dfl
    ```

8. Verify the DFL drivers have been successfully installed by reading version information directly from `/lib/modules`. Recall that the name of the kernel built as a part of this section is 5.14.0-dfl. If the user set a different name for their kernel, change this path as needed:

    ```bash
    cd /usr/lib/modules/6.1.78-dfl/kernel/drivers/fpga
    ls
    dfl-afu.ko     dfl-fme.ko      dfl-fme-region.ko  dfl.ko             dfl-pci.ko      fpga-mgr.ko     intel-m10-bmc-sec-update.ko
    dfl-fme-br.ko  dfl-fme-mgr.ko  dfl-hssi.ko        dfl-n3000-nios.ko  fpga-bridge.ko  fpga-region.ko
    ```

    If an OFS device that is compatible with these drivers is installed on the server, you can double check the driver versions by listing the currently loaded kernel modules with `lsmod`:

    ```bash
    lsmod | grep dfl
    uio_dfl                20480  0
    dfl_emif               16384  0
    uio                    20480  1 uio_dfl
    ptp_dfl_tod            16384  0
    dfl_intel_s10_iopll    20480  0
    8250_dfl               20480  0
    dfl_fme_region         20480  0
    dfl_fme_br             16384  0
    dfl_fme_mgr            20480  2
    dfl_fme                49152  0
    dfl_afu                36864  0
    dfl_pci                20480  0
    dfl                    40960  11 dfl_pci,uio_dfl,dfl_fme,intel_m10_bmc_pmci,dfl_fme_br,8250_dfl,qsfp_mem,ptp_dfl_tod,dfl_afu,dfl_intel_s10_iopll,dfl_emif
    fpga_region            20480  3 dfl_fme_region,dfl_fme,dfl
    fpga_bridge            20480  4 dfl_fme_region,fpga_region,dfl_fme,dfl_fme_br
    fpga_mgr               20480  4 dfl_fme_region,fpga_region,dfl_fme_mgr,dfl_fme
    ```

9. Four kernel parameters must be added to the boot command line for the newly installed kernel. First, open the file `grub`:

    ```bash
    sudo vim /etc/default/grub
    ```

10. In the variable *GRUB_CMDLINE_LINUX* add the following parameters in bold: GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet **intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200**".

    *Note: If you wish to instead set hugepages on a per session basis, you can perform the following steps. These settings will be lost on reboot.*

    ```bash
    mkdir -p /mnt/huge 
    mount -t hugetlbfs nodev /mnt/huge 
    echo 2048 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages 
    echo 2048 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages 
    ```

11. Save your edits, then apply them to the GRUB2 configuration file.

    ```bash
    sudo grub2-mkconfig
    ```

12. Warm reboot. Your kernel parameter changes should have taken affect.

    ```bash
    cat /proc/cmdline
    BOOT_IMAGE=(hd1,gpt2)/vmlinuz-6.1.78-dfl root=/dev/mapper/cl-root ro crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200 rhgb quiet
    ```

    A list of all DFL drivers and their purpose is maintained on the [DFL Wiki](https://github.com/OFS/linux-dfl/wiki/FPGA-DFL-Driver-Modules#fpga-driver-modules).

### 4.4 Installing the OFS DFL Kernel Drivers from Pre-Built Packages

To use the pre-built Linux DFL packages, you first need to download the files from your chosen platform's release page. You can choose to either install using the SRC RPMs, or to use the pre-built RPM packages targeting the official supported release platform.

```bash
tar xf kernel-6.1.78_dfl-1.x86_64-*.tar.gz

sudo dnf localinstall kernel-6.1.78_dfl_*.x86_64.rpm \
kernel-devel-5.14.0_dfl_*.x86_64.rpm \
kernel-headers-5.14.0_dfl_*.x86_64.rpm

### OR

sudo dnf localinstall kernel-6.1.78_dfl_*.src.rpm
```

## 5.0 OPAE Software Development Kit

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices.

The OPAE SDK source code is contained within a single GitHub repository hosted at the [OPAE GitHub](https://github.com/OFS/opae-sdk). This repository is open source.

### 5.1 OPAE SDK Installation

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit [opae.github.io](https://opae.github.io/latest/index.html).

The OPAE SDK source code is contained within a single GitHub repository hosted at the [OPAE Github](https://github.com/OFS/opae-sdk/releases/tag/2.14.0-3). This repository is open source and does not require any permissions to access.

You can choose to install the OPAE SDK by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on your chosen platform's release page, skip to section [5.3 Installing the OPAE SDK with Pre-built Packages](#53-installing-the-opae-sdk-with-pre-built-packages). Regardless of your choice you will need to follow the steps in this section to prepare your server for installation.

You may also choose to use the supplied Python 3 installation script. This script ships with a README detailing execution instructions and is available on the PCIe Attach's platform release page. It can be used to automate installation of the pre-built packages, or to build from source.

### 5.2 OPAE SDK Installation Environment Setup

This installation process assumes you have access to an internet connection to pull specific GitHub repositories, and to satisfy package dependencies.

#### Table 4: OPAE Package Description
        
| Package Name| Description|
| -----| -----|
| opae | OPAE SDK is a collection of libraries and tools to facilitate the development of software applications and accelerators using OPAE. It provides a library implementing the OPAE C API for presenting a streamlined and easy-to-use interface for software applications to discover, access, and manage FPGA devices and accelerators using the OPAE software stack. |
| opae-debuginfo| This package provides debug information for package opae. Debug information is useful when developing applications that use this package or when debugging this package.|
| opae-debugsource| This package provides debug sources for package opae. Debug sources are useful when developing applications that use this package or when debugging this package.|
| opae-devel| OPAE headers, tools, sample source, and documentation|
| opae-devel-debuginfo|This package provides debug information for package opae-devel. Debug information is useful when developing applications that use this package or when debugging this package. |
| opae-tools| This package contains OPAE base tools binaries|
| opae-extra-tools| Additional OPAE tools|
| opae-extra-tools-debuginfo| This package provides debug information for package opae-extra-tools. Debug information is useful when developing applications that use this package or when debugging this package.|

1. Remove any currently installed OPAE packages.

    ```bash
    sudo dnf remove opae*
    ```

2. Initialize an empty git repository and clone the tagged OPAE SDK source code.

    ```bash
    cd /home/OFS/
    git init
    git clone https://github.com/OFS/opae-sdk opae-sdk
    cd /home/OFS/opae-sdk
    git checkout tags/2.12.0-5
    ```

3. Verify that the correct tag/branch have been checkout out.

    ```bash
    git describe --tags
    2.12.0-5
    ```

4. Set up a temporary `podman` container to build OPAE, which will allow you to customize the python installation without affecting system packages.
    
    ```bash
    sudo dnf install podman
    cd /home/OFS
    podman pull registry.access.redhat.com/ubi8:8.6
    podman run -ti -v "$PWD":/src:Z -w /src registry.access.redhat.com/ubi8:8.6
    
    # Everything after runs within container:
    
    # Enable EPEL
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    
    dnf install --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms -y python3 python3-pip python3-devel python3-jsonschema python3-pyyaml git gcc gcc-c++ make cmake libuuid-devel json-c-devel hwloc-devel tbb-devel cli11-devel spdlog-devel libedit-devel systemd-devel doxygen python3-sphinx pandoc rpm-build rpmdevtools python3-virtualenv yaml-cpp-devel libudev-devel libcap-devel make automake autoconf libtools
    
    pip3 install --upgrade --prefix=/usr pip setuptools pybind11
    
    ./opae-sdk/packaging/opae/rpm/create unrestricted
    
    exit
    ```
    
    The following packages will be built in the same directory as `create`:


5. Install the packages you just created.
    
    ```bash
    cd /home/OFS/opae-sdk/packaging/opae/rpm
    rm -rf opae-*.src.rpm 
    sudo dnf localinstall -y opae*.rpm
    ```

6. Check that all packages have been installed and match expectation:
    
    ```bash
    rpm -qa | grep opae
    opae-2.12.0-5.el8.x86_64.rpm
    opae-debuginfo-2.12.0-5.el8.x86_64.rpm
    opae-debugsource-2.12.0-5.el8.x86_64.rpm
    opae-devel-2.12.0-5.el8.x86_64.rpm
    opae-devel-debuginfo-2.12.0-5.el8.x86_64.rpm
    opae-extra-tools-2.12.0-5.el8.x86_64.rpm
    opae-extra-tools-debuginfo-2.12.0-5.el8.x86_64.rpm
    ```

### 5.3 Installing the OPAE SDK with Pre-Built Packages

You can skip the entire build process and use a set of pre-built binaries supplied by Intel. Visit your chosen platform's release page. Ender the Assets tab you will see a file named opae-2.12.0-5.x86_64-\<\<date\>\>_\<\<build\>\>.tar.gz. Download this package and extract its contents:

```bash
tar xf opae-2.12.0-5.x86_64-*.tar.gz
```

For a fast installation you can delete the source RPM as it isn't necessary, and install all remaining OPAE RPMs:

```bash
rm opae-*.src.rpm
sudo dnf localinstall opae*.rpm
```

### 5.4 OPAE Tools Overview

The OPAE SDK user-space tools sit upon the kernel-space DFL drivers. In order to use OPAE SDK functionality the user needs to have installed both the OPAE SDK and Linux DFL driver set. You must have at least one D5005 card with the appropriate FIM present in your system. The steps to read and load a new FIM version are discussed in section [7.1 Programming the OFS FIM](#71-programming-the-ofs-fim). After both the DFL kernel-space drivers have been installed and the FIM has been upgraded, you may proceed to test the OPAE commands discussed below.

This section covers basic functionality of the commonly used OPAE tools and their expected results. These steps may also be used to verify that all OFS software installation has been completed successfully. A complete overview of the OPAE tools can be found on the [OPAE GitHub](https://github.com/OFS/opae-sdk) and in your cloned GitHub repo at `<your path>/opae-sdk/doc/src/fpga_tools`. More commands are listed than are defined in the list below - most of these are called by other tools and do not need to be called directly themselves.

#### 5.4.1 `fpgasupdate`

The fpgasupdate tool updates the Intel Max10 BMC image and firmware, root entry hash, and FPGA Static Region (SR) and user image (PR). The fpgasupdate will only accept images that have been formatted using PACsign. If a root entry hash has been programmed onto the board, then the image will also need to be signed using the correct keys. Please refer to the [Security User Guide: Intel Open FPGA Stack] for information on created signed images and on programming and managing the root entry hash.

The Intel FPGA PAC ships with a factory and user programmed image for both the FIM and BMC FW and RTL on all cards.

#### Table 5-1: `fpgasupdate` Overview

**Synopsis:**

```bash
fpgasupdate [--log-level=<level>] file [bdf]
```

**Description:** The fpgasupdate command implements a secure firmware update.

|Command |args (optional)| Description|
| ----- | ----- | ----- |
| | --log-level <level> | Specifies the `log-level` which is the level of information output to your command tool. The following seven levels  are available: `state`, `ioctl`, `debug`, `info`, `warning`, `error`, `critical`. Setting `--log-level=state` provides the most verbose output. Setting `--log-level=ioctl` provides the second most information, and so on. The default level is `info`.  |
| | file |  Specifies the secure update firmware file to be programmed. This file may be to program a static region (SR), programmable region (PR), root entry hash, key cancellation, or other device-specific firmware. |
| | bdf | The PCIe address of the PAC to program. `bdf` is of the form `[ssss:]bb:dd:f`, corresponding to PCIe segment, bus, device, function. The segment is optional. If you do not specify a segment, the segment defaults to `0000`. If the system has only one PAC you can omit the `bdf` and let `fpgasupdate`  determine the address automatically. |

#### 5.4.2 `fpgainfo`

**Synopsis:**

```bash
   fpgainfo [-h] [-S <segment>] [-B <bus>] [-D <device>] [-F <function>] [PCI_ADDR]
            {errors,power,temp,fme,port,bmc,mac,phy,security}
```

**Description:**
 Displays FPGA information derived from sysfs files. The command argument is one of the following: errors, power, temp, port, fme, bmc, phy or mac, security. Some commands may also have other arguments or options that control their behavior.

For systems with multiple FPGA devices, you can specify the BDF to limit the output to the FPGA resource with the corresponding PCIe configuration. If not specified, information displays for all resources for the given command.

|Command|args (optional)|Description|
|-------|----------------|-------------|
| | --help, -h | Prints help information and exits. |
| | --version, -v | Prints version information and exits. |
| | -S, --segment | PCIe segment number of resource. |
| | -B, --bus | PCIe bus number of resource. |
| | -D, --device | PCIe device number of resource. |
| | -F, --function | PCIe function number of resource. |
| errors | {fme, port, all} --clear, -c | First agument to the errors command specifies the resource type to display in human readable format. The second optional argument clears errors for the given FPGA resource. |
|power|   |Provides total power in watts that the FPGA hardware consumes|
|temp|   |Provides FPGA temperature values in degrees Celsius|
|port|   |Provides information about the port|
|fme|   |Provides information about the FME|
|bmc|   |Provides BMC sensors information|
|mac|   |Provides information about MAC ROM connected to FPGA|
|security|  |Provides information about the security keys, hashes, and flash count, if available.|

*Note: Your Bitstream ID and PR Interface Id may not match the below examples.*

The following examples walk through sample outputs generated by `fpgainfo`.

```bash
$ sudo fpgainfo fme

Open FPGA Stack Platform
Board Management Controller, MAX10 NIOS FW version: 2.0.8
Board Management Controller, MAX10 Build version: 2.0.8
//****** FME ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:3B:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 288511860124977321
Bitstream Version                : 4.0.1
Pr Interface Id                  : a195b6f7-cf23-5a2b-8ef9-1161e184ec4e
Boot Page                        : user
```

```bash
$ sudo fpgainfo bmc

Open FPGA Stack Platform
Board Management Controller, MAX10 NIOS FW version: 2.0.8
Board Management Controller, MAX10 Build version: 2.0.8
//****** BMC SENSORS ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:3B:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 288511860124977321
Bitstream Version                : 4.0.1
Pr Interface Id                  : a195b6f7-cf23-5a2b-8ef9-1161e184ec4e
( 1) VCCERAM Voltage                                    : 0.90 Volts
( 2) VCCT Temperature                                   : 29.00 Celsius
( 3) 12v Backplane Voltage                              : 12.17 Volts
( 4) VCCERAM Current                                    : 0.18 Amps
( 5) FPGA Transceiver Temperature                       : 36.50 Celsius
( 6) QSFP1 Supply Voltage                               : 0.00 Volts
( 7) 3.3v Temperature                                   : 29.00 Celsius
( 8) 12v Backplane Current                              : 2.28 Amps
( 9) RDIMM3 Temperature                                 : 25.50 Celsius
(10) VCCR Voltage                                       : 1.12 Volts
(11) Board Inlet Air Temperature                        : 24.50 Celsius
(12) 1.8v Temperature                                   : 27.50 Celsius
(13) 12v AUX Voltage                                    : 12.14 Volts
(14) VCCR Current                                       : 0.55 Amps
(15) RDIMM0 Temperature                                 : 24.50 Celsius
(16) FPGA Core Voltage                                  : 0.88 Volts
(17) VCCERAM Temperature                                : 27.50 Celsius
(18) 12v AUX Current                                    : 1.19 Amps
(19) QSFP0 Temperature                                  : N/A
(20) VCCT Voltage                                       : 1.12 Volts
(21) FPGA Core Current                                  : 11.60 Amps
(22) FPGA Core Temperature                              : 42.50 Celsius
(23) 12v Backplane Temperature                          : 24.00 Celsius
(24) VCCT Current                                       : 0.14 Amps
(25) RDIMM1 Temperature                                 : 24.00 Celsius
(26) 3.3v Voltage                                       : 3.30 Volts
(27) VCCR Temperature                                   : 33.50 Celsius
(28) 1.8v Voltage                                       : 1.80 Volts
(29) 3.3v Current                                       : 0.32 Amps
(30) Board Exhaust Air Temperature                      : 26.00 Celsius
(31) 12v AUX Temperature                                : 25.00 Celsius
(32) QSFP0 Supply Voltage                               : 0.00 Volts
(33) QSFP1 Temperature                                  : N/A
(34) 1.8v Current                                       : 0.54 Amps
(35) RDIMM2 Temperature                                 : 26.00 Celsius
```

#### 5.4.3 `rsu`

The **rsu** performs a Remote System Update operation on a device, given its PCIe address. A **rsu** operation sends an instruction to the device to trigger a power cycle of the card only. This will force reconfiguration from flash for either the BMC or FPGA.

The Intel FPGA PAC contains a region of flash the user may store their FIM image. After an image has been programmed with fpgasupdate the user may choose to perform rsu to update the image on the device.

**Note:** The D5005 platform only supports storing and configuring a single user image from flash for the FPGA. It does not include support for the user1/user2 partitions as shown in other OFS related acceleration boards.

**`rsu` Overview**

**Synopsis**

```bash
rsu [-h] [-d] {bmc,bmcimg,retimer,sdm,fpgadefault} [PCIE_ADDR]
```

```bash
rsu bmc --page=(user) [PCIE_ADDR]
rsu retimer [PCIE_ADDR]
rsu sdm [PCIE_ADDR]
```

Perform RSU (remote system update) operation on PAC device given its PCIe address. An RSU operation sends an instruction to the device to trigger a power cycle of the card only. This will force reconfiguration from flash for either BMC, Retimer, SDM, (on devices that support these) or the FPGA.

*Note: As a result of using the **rsu** command, the host rescans the PCI bus and may assign a different Bus/Device/Function (B/D/F) value than the originally assigned value.*

#### 5.4.4 `PACsign`

PACSign is an OPAE utility which allows users to insert authentication markers into bitstreams targeted for the platform. All binary images must be signed using PACSign before fpgasupdate can use them for an update. Assuming no Root Entry Hash (REH) has been programmed on the device, the following examples demonstrate how to prepend the required secure authentication data, and specify which region of flash to update.
More information, including charts detailing the different certification types and their required options, are fully described in the PACsign python/pacsign/PACSign.md [OPAE GitHub](https://github.com/OFS/opae-sdk) on GitHub.

#### Table 5-4: `PACSign` Overview

**Synopsis:**

```bash
PACSign [-h] {FIM,SR,SR_TEST,BBS,BMC,BMC_FW,BMC_FACTORY,AFU,PR,PR_TEST,GBS,FACTORY,PXE,THERM_SR,THERM_PR} ...

PACSign <CMD> [-h] -t {UPDATE,CANCEL,RK_256,RK_384} -H HSM_MANAGER [-C HSM_CONFIG] [-s SLOT_NUM] [-r ROOT_KEY] [-k CODE_SIGNING_KEY] [-d CSK_ID] [-R ROOT_BITSTREAM] [-S] [-i INPUT_FILE] [-o OUTPUT_FILE] [-b BITSTREAM_VERSION] [-y] [-v]
```

**Description:**
The PACSign utility inserts authentication markers into bitstreams.

|Command |args (optional)| Description|
| ----- | ----- | ----- |
| |(required) -t, --cert_type TYPE |The following operations are supported: UPDATE, CANCEL, RK_256, RK_348|
| |(required) -H, --HSM_manager MODULE |The module name for a module that interfaces to a HSM. PACSign includes both the openssl_manager and pkcs11_manager to handle keys and signing operations.  |
|| -C, --HSM_config CONFIG |The argument to this operation is passed verbatim to the specified HSM. For pkcs11_manager, this option specifies a JSON file describing the PKCS #11 capable HSM’s parameters. |
|| -r, --root_key KEY_ID |The key identifier that the HSM uses to identify the root key to be used for the selected operation.|
|| -k, --code_signing_key KEY_ID |The key indentifier that the HSM uses to identify the code signing key to be used for the selected operation|
|| -d, --csk_id CSK_NUM |Only used for type CANCEL. Specifies the key number of the code signing key to cancel.|
|| -s, --slot_num {0,1,2}  |For bitstream types with multiple slots (i.e. multiple ST regions), this option specifies which of the slots to which this bitstream is to be acted upon|
|| -b, --bitstream_version VERSION |User-formatted version information. This can be any string up to 32 bytes in length.|
|| -S, --SHA384 |Used to specify that PACSign is to use 384-bit crypto. Default is 256-bit|
|| -R, --ROOT_BITSTREAM ROOT_BITSTREAM |Valid when verifying bitstreams. The verification step will ensure the generated bitstream is able to be loaded on a board with the specified root entry hash programmed.|
|| -i, --input_file FILE |Only to be used for UPDATE operations. Specifies the file name containing data to be signed|
|| -o, --output_file FILE |Specifies the file name for the signed output bitstream.|
|| -y, --yes |Silently answer all queries from PACSign in the affirmative. |
|| -v, --verbose |Can be specified multiple times. Increases the verbosity of PACSign. Once enables non-fatal warnings to be displayed. Twice enables progress information. Three or more occurrences enables very verbose debugging information.|
|| -h |Prints help information and exits|
||{FIM, SR, SR_TEST, BBS, BMC, BMC_FW, BMC_FACTORY, AFU, PR, PR_TEST, GBS, FACTORY, PXE, THERM_SR, THERM_PR} | Bitstream type identifier.|

**PACSign** can be run on images that have previously been signed. It will overwrite any existing authentication data.

The following example will create an unsigned SR image from an existing signed SR binary update image.

```bash
PACSign SR -t UPDATE -s 0 -H openssl_manager -i d5005_page1_unsigned.bin -o new_image.bin
#output
No root key specified.  Generate unsigned bitstream? Y = yes, N = no: y
No CSK specified.  Generate unsigned bitstream? Y = yes, N = no: y
No root entry hash bitstream specified.  Verification will not be done.  Continue? Y = yes, N = no: y
2022-07-20 10:13:54,954 - PACSign.log - WARNING - Bitstream is already signed - removing signature blocks
```

#### 5.4.5 `bitstreaminfo`

Displays authentication information contained with each provided `file` on the command line. This includes any JSON header strings, authentication header block information, and a small portion  of the payload. The binary is installed by default at `/usr/bin/bitstreaminfo`.<br>

#### 5.4.6 `hssi`

The hssi application provides a means of interacting with the 10G and with the 100G HSSI AFUs. In both 10G and 100G operating modes, the application initializes the AFU, completes the desired transfer as described by the mode-specific options. Only the `hssi_10g` MODE is currently supported. An example of this command's output can be found in section [5.2.9 Running the Host Exerciser Modules](#529-running-the-host-exerciser-modules). The binary is installed by default at `/usr/bin/hssi`.<br>

#### 5.4.7 `opae.io`

Opae.io is a interactive Python environment packaged on top of libopaevfio.so, which provides user space access to PCIe devices via the vfio-pci driver. The main feature of opae.io is its built-in Python command interpreter, along with some Python bindings that provide a means to access Configuration and Status Registers (CSRs) that reside on the PCIe device. opae.io has two operating modes: command line mode and interactive mode. An example of this command's output can be found in section [5.2.9 Running the Host Exerciser Modules](#529-running-the-host-exerciser-modules). The binary is installed by default at `/usr/bin/opae.io`.<br>

#### 5.4.8 `host_exerciser`

The host exerciser is used to exercise and characterize the various host-FPGA interactions eg. MMIO, Data transfer from host to FPGA , PR, host to FPGA memory etc. An example of this command's output can be found in section [5.2.9 Running the Host Exerciser Modules](#529-running-the-host-exerciser-modules). The binary is installed by default at `/usr/bin/host_exerciser`. For more information refer to - [Host Exerciser](https://opae.github.io/latest/docs/fpga_tools/host_exerciser/host_exerciser.html)<br>

#### 5.4.9 Running the Host Exerciser Modules

The reference FIM and unchanged compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. 

**Note:** Before continuing, if huge pages are not set refer to [section 4.2, step 7](#42-building-and-installing-the-ofs-dfl-kernel-drivers-from-source).


There are three HEMs present in the OFS FIM - HE-LPBK, HE-HSSI, and HE-MEM. These exercisers are tied to three different VFs that must be enabled before they can be used. The user should enable the VF for each HEM using the below steps:

**1.** Determine the BDF of the Intel® FPGA PAC D5005 card.

The PCIe BDF address is initially determined when the server powers on. The user can determine the addresses of all Intel® FPGA PAC D5005 boards using `lspci`:

```bash
lspci -d :bcce

3b:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
```

**Note:** Before continuing, if you updated your OFS installation, please also [update your PAC FIM](#70-programming-the-ofs-fim-and-bmc) to run HEMs.

**2.** Enable three VFs.

In this example, the BDF address is 0000:3b:00.0. With this information the user can now enable three VFs with the following:

```bash
sudo pci_device 0000:3b:00.0 vf 3
```

**3.** Verify that all three VFs have been created.

```bash
lspci -s 3b:00

3b:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
3b:00.1 Processing accelerators: Intel Corporation Device bccf (rev 01)
3b:00.2 Processing accelerators: Intel Corporation Device bccf (rev 01)
3b:00.3 Processing accelerators: Intel Corporation Device bccf (rev 01)
```

**4.** Bind the 3 VFs to the vfio-pci driver.

```bash
sudo opae.io init -d 0000:3b:00.1 $USER

opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:3b:00.1 from dfl-pci
Binding (0x8086,0xbccf) at 0000:3b:00.1 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:3b:00.1 is 142
Assigning /dev/vfio/142 to $USER:$USER
Changing permissions for /dev/vfio/142 to rw-rw----


sudo opae.io init -d 0000:3b:00.2 $USER

opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:3b:00.2 from dfl-pci
Binding (0x8086,0xbccf) at 0000:3b:00.2 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:3b:00.2 is 143
Assigning /dev/vfio/143 to $USER:$USER
Changing permissions for /dev/vfio/143 to rw-rw----


sudo opae.io init -d 0000:3b:00.3 $USER

opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:3b:00.3 from dfl-pci
Binding (0x8086,0xbccf) at 0000:3b:00.3 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:3b:00.3 is 144
Assigning /dev/vfio/144 to $USER:$USER
Changing permissions for /dev/vfio/144 to rw-rw----
```

**5.** Check that the accelerators are present using fpgainfo. *Note your port configuration may differ from the below.*

```bash
$ sudo fpgainfo port

//****** PORT ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:3B:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
//****** PORT ******//
Object Id                        : 0x603B000000000000
PCIe s:b:d.f                     : 0000:3B:00.3
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Accelerator GUID                 : 823c334c-98bf-11ea-bb37-0242ac130002
//****** PORT ******//
Object Id                        : 0x403B000000000000
PCIe s:b:d.f                     : 0000:3B:00.2
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Accelerator GUID                 : 8568ab4e-6ba5-4616-bb65-2a578330a8eb
//****** PORT ******//
Object Id                        : 0x203B000000000000
PCIe s:b:d.f                     : 0000:3B:00.1
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Accelerator GUID                 : 56e203e9-864f-49a7-b94b-12284c31e02b
```

#### Table 5-5 VF to HEM Mappings

|VF BDF |HEM |
|---------|---------|
|BBBB:DD.1| HE-LB   |
|BBBB:DD.2| HE-MEM  |
|BBBB:DD.3| He-HSSI |

**HE-MEM / HE-LB**

HE-LB is responsible for generating traffic with the intention of exercising the path from the AFU to the Host at full bandwidth. HE-MEM is used to exercise the DDR interface; data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host. HE-MEM uses external DDR memory (i.e. EMIF) to store data. It has a customized version of the AVMM interface to communicate with the EMIF memory controller. Both exercisers rely on the user-space tool `host_exerciser`. The following commands are supported by the HE-LB/HE-MEM OPAE driver program. They may need to be run using `sudo` privileges, depending on your server configuration.

Basic operations:

```bash
$ sudo host_exerciser lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
	Number of clocks: 5342
	Total number of Reads sent: 1024
	Total number of Writes sent: 1024
	Bandwidth: 3.067 GB/s
	Test lpbk(1): PASS

$ sudo host_exerciser --mode lpbk lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
	Number of clocks: 5358
	Total number of Reads sent: 1024
	Total number of Writes sent: 1024
	Bandwidth: 3.058 GB/s
    Test lpbk(1): PASS

$ sudo host_exerciser --mode write lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 0
    Host Exerciser numWrites: 1025
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 2592
    Total number of Reads sent: 0
    Total number of Writes sent: 1024
    Bandwidth: 6.321 GB/s
    Test lpbk(1): PASS

$ sudo host_exerciser --mode trput lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
    Number of clocks: 3384
    Total number of Reads sent: 512
    Total number of Writes sent: 512
    Bandwidth: 4.842 GB/s
    Test lpbk(1): PASS


```

Number of cachelines per request 1, 2, and 4. The user may replace `--mode lpbk` with `read, write, trput`. The target `lpbk` can be replaced with `mem`:

```bash
$ sudo host_exerciser --mode lpbk --cls cl_1 lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
    Number of clocks: 5475
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 2.993 GB/s
    Test lpbk(1): PASS


$ sudo host_exerciser --mode lpbk --cls cl_2 lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
    Number of clocks: 5356
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.059 GB/s
    Test lpbk(1): PASS


$ sudo host_exerciser --mode lpbk --cls cl_4 lpbk

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
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
    Number of clocks: 4481
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.656 GB/s
    Test lpbk(1): PASS


```

Interrupt tests (only valid for mode `mem`):

```bash
$ sudo host_exerciser --interrupt 0 mem

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
Using Interrupts
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1026
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 5140
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.188 GB/s
    Test mem(1): PASS

$ sudo host_exerciser --interrupt 1 mem

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
Using Interrupts
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1026
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 5079
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.226 GB/s
    Test mem(1): PASS


$ sudo host_exerciser --interrupt 2 mem

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
Using Interrupts
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1026
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 5525
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.439 GB/s
    Test mem(1): PASS


$ sudo host_exerciser --interrupt 3 mem

    starting test run, count of 1
API version: 1
AFU clock: 250 MHz
Allocate SRC Buffer
Allocate DST Buffer
Allocate DSM Buffer
Using Interrupts
    Host Exerciser Performance Counter:
    Host Exerciser numReads: 1024
    Host Exerciser numWrites: 1026
    Host Exerciser numPendReads: 0
    Host Exerciser numPendWrites: 0
    Host Exerciser numPendEmifReads: 0
    Host Exerciser numPendEmifWrites: 0
    Number of clocks: 4735
    Total number of Reads sent: 1024
    Total number of Writes sent: 1024
    Bandwidth: 3.460 GB/s
    Test mem(1): PASS
```

**HE-HSSI**

HE-HSSI is responsible for handling client-side ethernet traffic. It wraps the 10G ethernet AFU and includes a 10G traffic generator and checker. The user-space tool `hssi` exports a control interface to the HE-HSSI's AFU's packet generator logic. Context sensitive information is given by the `hssi --help` command. Help for the 10G specific test is given by `hssi hssi_10g --help` Example useage:

```bash
$ sudo hssi --pci-address 3b:00.3 hssi_10g --eth-ifc s10hssi0 --eth-loopback on --he-loopback=off  --num-packets 100

10G loopback test
  port: 0
  eth_loopback: on
  he_loopback: off
  num_packets: 100
  packet_length: 64
  src_address: 11:22:33:44:55:66
    (bits):  0x665544332211
  dest_address: 77:88:99:aa:bb:cc
    (bits): 0xccbbaa998877
  random_length: fixed
  random_payload: incremental
  rnd_seed0: 5eed0000
  rnd_seed1: 5eed0001
  rnd_seed2: 25eed
  eth: s10hssi0
```

## 6.0 Compiling OFS FIM

Pre-Compiled FIM binaries are at [OFS 2024.1-1 release page](https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1) and to compile the OFS FIM for Intel® FPGA PAC D5005 follow the below steps :

1) Compile OFS FIM manually - Steps are provided in the developer guide to compile FIM and generate binaries. Refer to [Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/).

2) Compile OFS FIM using evaluation script - The script guides you to the steps required for compilation via selecting options from the menu. Refer to [Automated Evaluation User Guide: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/).

## 7.0 Programming the OFS FIM and BMC

Instructions surrounding the compilation and simulation of the OFS FIM have fully moved into the [Shell Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/fim_dev/ug_dev_fim_ofs_d5005/).

### 7.1 Programming the OFS FIM

In order to program the OFS FIM, both the OPAE SDK and DFL drivers need to be installed on the host system. Please complete the steps in sections [4.0 OFS DFL Kernel Drivers](#40-ofs-dfl-kernel-drivers) and [5.0 OPAE Software Development Kit](#50-opae-software-development-kit). The OFS FIM version can be identified using the OPAE tool `fpgainfo`. A sample output of this command is included below.

```bash
$ sudo fpgainfo fme

Intel FPGA Programmable Acceleration Card D5005
Board Management Controller, MAX10 NIOS FW version: 2.0.8
Board Management Controller, MAX10 Build version: 2.0.8
//****** FME ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:3B:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x138D
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 288511860124977321
Bitstream Version                : 4.0.1
Pr Interface Id                  : a195b6f7-cf23-5a2b-8ef9-1161e184ec4e
Boot Page                        : user
```

Use the value under `PR Interface ID` to identify that FIM that has been loaded. Refer to the table below for a list of previous FIM releases:

#### Table 7-1 Previous FIM Releases

| PR Release | PR Interface ID |
|---------|---------|
| 2023.2 | edad864c-99d6-5831-ab67-62bfd81ec654|
| 2022.2 (tag 1.3.0)                         | bf531bcf-a896-5171-ab31-601a4ab754b6                    |
| 2022.1 Beta (tag: 1.2.0-beta)              | 2fae83fc-8568-53aa-9157-8f75e9c0ba92                   |
| OFS 2.1 Beta (tag: 1.1.0-beta)             | 99160d37e42a 3f8b586f-c275-594c-92e2-d9f2c23e94d1                    |
| OFS 1.0 (tag: ofs-1.0.0)                   | b5f6a71e-daec-59c3-a43a-85567b51fd3f |
| Intel Acceleration Stack for Intel® FPGA PAC D5005 2.0.1 | 9346116d-a52d-5ca8-b06a-a9a389ef7c8d |

If the user's card does not report a PR Interface ID which matches the above table, then a new FIM will need to be programmed.

#### 7.1.1 Programming the FIM

**1.** Download the file **d5005_page1_unsigned.bin** from [OFS 2024.1-1 release page](https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1).

**2.** Run `PACSign` to create an unsigned image with added header for use by fpgasupdate

```bash
$ PACSign SR -y -v -t UPDATE -s 0 -H openssl_manager -i d5005_page1_unsigned.bin -o d5005_PACsigned_unsigned.bin
```

**3.** Run `fpgasupdate` to load the image into the user location of the Intel® FPGA PAC D5005 FPGA flash, NOTE: use "sudo fpgainfo fme" command to find the PCIe address for your card.

```bash
$ sudo fpgasupdate d5005_PACsigned_unsigned.bin 3B:00.0
```

**4.** Run `RSU` command.

```bash
$ sudo rsu bmcimg 0000:3B:00.0
```

### 7.2 Programming the BMC

**1.** Download intel-fpga-bmc images(To download OFS Stratix 10 BMC binaries contact Intel Technical Sales Representative)

**2.** The file `unsigned_bmc_fw.bin` has the newly binary format. This bitstream is programmed with remote system update (RSU) and the bitstream must be signed with PACSign tool to generate.

**3.** Run `PACSign` to create an unsigned image with added header for use by fpgasupdate

```bash
$ PACSign BMC -y -v -t UPDATE -s 0 -H openssl_manager -i unsigned_bmc_fw.bin -o PACsigned_unsigned_bmc_fw.bin

2022-04-22 03:07:05,626 - PACSign.log - INFO - OpenSSL version "OpenSSL 1.1.1k  FIPS 25 Mar 2021" matches "1.1.1"
2022-04-22 03:07:05,648 - PACSign.log - INFO - Bitstream not previously signed
2022-04-22 03:07:05,648 - PACSign.log - INFO - platform value is '688128'
2022-04-22 03:07:05,745 - PACSign.log - INFO - Starting Block 0 creation
2022-04-22 03:07:05,745 - PACSign.log - INFO - Calculating SHA256
2022-04-22 03:07:05,747 - PACSign.log - INFO - Calculating SHA384
2022-04-22 03:07:05,749 - PACSign.log - INFO - Done with Block 0
2022-04-22 03:07:05,749 - PACSign.log - INFO - Starting Root Entry creation
2022-04-22 03:07:05,749 - PACSign.log - INFO - Calculating Root Entry SHA
2022-04-22 03:07:05,749 - PACSign.log - INFO - Starting Code Signing Key Entry creation
2022-04-22 03:07:05,749 - PACSign.log - INFO - Calculating Code Signing Key Entry SHA
2022-04-22 03:07:05,749 - PACSign.log - INFO - Code Signing Key Entry done
2022-04-22 03:07:05,749 - PACSign.log - INFO - Starting Block 0 Entry creation
2022-04-22 03:07:05,749 - PACSign.log - INFO - Calculating Block 0 Entry SHA
2022-04-22 03:07:05,749 - PACSign.log - INFO - Block 0 Entry done
2022-04-22 03:07:05,749 - PACSign.log - INFO - Starting Block 1 creation
2022-04-22 03:07:05,750 - PACSign.log - INFO - Block 1 done
2022-04-22 03:07:05,757 - PACSign.log - INFO - Writing blocks to file
2022-04-22 03:07:05,758 - PACSign.log - INFO - Processing of file 'PACsigned_unsigned_bmc_fw.bin' complete
```

**4.** Run `fpgasupdate` to perform an upgrade of the BMC.

```bash
$ sudo fpgasupdate PACsigned_unsigned_bmc_fw.bin 3B:00.0

[2022-04-22 03:08:34.15] [WARNING ] Update starting. Please do not interrupt.
[2022-04-22 03:08:34.15] [INFO    ] updating from file pacsign_unsigned_bmc_fw.bin with size 819968
[2022-04-22 03:08:34.15] [INFO    ] waiting for idle
[2022-04-22 03:08:34.15] [INFO    ] preparing image file
[2022-04-22 03:09:02.18] [INFO    ] writing image file
(100%) [████████████████████] [819968/819968 bytes][Elapsed Time: 0:00:13.01]
[2022-04-22 03:09:15.20] [INFO    ] programming image file
(100%) [████████████████████][Elapsed Time: 0:00:29.03]
[2022-04-22 03:09:44.24] [INFO    ] update of 0000:3B:00.0 complete
[2022-04-22 03:09:44.24] [INFO    ] Secure update OK
[2022-04-22 03:09:44.24] [INFO    ] Total time: 0:01:10.08
```

## Notices & Disclaimers

Altera® Corporation technologies may require enabled hardware, software or service activation. No product or component can be absolutely secure. Performance varies by use, configuration and other factors. Your costs and results may vary. You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Altera or Intel products described herein. You agree to grant Altera Corporation a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein. No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Altera or Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document. The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request. Altera disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade. You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. © Altera Corporation. Altera, the Altera logo, and other Altera marks are trademarks of Altera Corporation. Other names and brands may be claimed as the property of others.

OpenCL* and the OpenCL* logo are trademarks of Apple Inc. used by permission of the Khronos Group™.  
[License quartus-0.0-0.01iofs-linux.run]: https://github.com/OFS/ofs-d5005/blob/release/1.0.x/license/quartus-0.0-0.01iofs-linux.run
[OFS D5005 FIM Github Branch]: https://github.com/OFS/ofs-d5005
[OFS FIM_COMMON Github Branch]: https://github.com/OFS/ofs-fim-common
[OPAE SDK Branch]: https://github.com/OFS/opae-sdk/tree/2.12.0-5
[OPAE SDK Tag]: https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5
[OPAE SDK SIM Branch]: https://github.com/OFS/opae-sim/tree/2.12.0-5
[OPAE SDK SIM Tag]: https://github.com/OFS/opae-sim/releases/tag/2.12.0-5
[Linux DFL]: https://github.com/OFS/linux-dfl
[Kernel Driver Branch]: https://github.com/OFS/linux-dfl/tree/ofs-2024.1-6.1-2
[Kernel Driver Tag]: https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2
[OFS Release]: https://github.com/OFS/ofs-d5005/releases/
[Quartus® Prime Pro Edition Linux]: https://www.intel.com/content/www/us/en/software-kit/782411/intel-quartus-prime-pro-edition-design-software-version-25-1-for-linux.html

[Qualified Servers]: https://www.intel.com/content/www/us/en/products/details/fpga/platforms/pac/d5005/view.html
[Open FPGA Stack Reference Manual - MMIO Regions section]: https://ofs.github.io/ofs-2024.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/#7-mmio-regions
[Device Feature Header (DFH) structure]: https://ofs.github.io/ofs-2024.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/#721-device-feature-header-dfh-structure
[FPGA Device Feature List (DFL) Framework Overview]: https://github.com/ofs/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#fpga-device-feature-list-dfl-framework-overview
[ofs-platform-afu-bbb]: https://github.com/OFS/ofs-platform-afu-bbb
[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md
[Connecting an AFU to a Platform using PIM]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[AFU Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial
[AFU types]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types
[Host Channel]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md
[Local Memory]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md
[OPAE C API]: https://ofs.github.io/ofs-2024.1-1/sw/fpga_api/prog_guide/readme/#opae-c-api-programming-guide
[example AFUs]: https://github.com/OFS/examples-afu.git
[PIM Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial
[Non-PIM AFU Development]: https://github.com/OFS/examples-afu/tree/main/tutorial
[Unit Level Simulation]: https://ofs.github.io/ofs-2024.1-1/hw/d5005/dev_guides/fim_dev/ug_dev_fim_ofs_d5005/#412-unit-level-simulation

[Security User Guide: Intel® Open FPGA Stack for Intel® Stratix 10® PCIe Attach FPGAs]: https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/ug-pac-security.md
[Board Management User Guide]: https://github.com/otcshare/ofs-bmc/tree/main/docs/user_guides/bmc/ug_dev_bmc_ofs_n600x.md
[OPAE.io]: https://ofs.github.io/ofs-2024.1-1/sw/fpga_api/quick_start/readme/
[OPAE GitHub]: https://github.com/OFS/opae-sdk

[5.0 OPAE Software Development Kit]: https://ofs.github.io/ofs-2024.1-1/hw/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005/#50-opae-software-development-kit
[README_ofs_d5005_eval.txt]: https://github.com/OFS/ofs-d5005/blob/release/1.0.x/eval_scripts/README_ofs_d5005_eval.txt
[FIM MMIO Regions]: https://ofs.github.io/ofs-2024.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/#mmio_regions

[evaluation script]: https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1
[OFS]: https://github.com/OFS
[OFS GitHub page]: https://ofs.github.io
[DFL Wiki]: https://github.com/OPAE/linux-dfl/wiki
[release notes]: https://github.com/OFS/ofs-d5005/releases/tag/ofs-2024.1-1



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

