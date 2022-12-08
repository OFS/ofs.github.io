<h1>Intel<sup>&reg;</sup> FPGA Interface Manager Developer Guide: Intel Open Stack for Intel Stratix 10</h1>

You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Intel products described herein. 
No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document.

All information provided here is subject to change without notice. Contact your Intel representative to obtain the latest Intel product specifications and roadmaps.

The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request.
Intel, the Intel logo, Agilex, Altera, Arria, Cyclone, Enpirion, eASIC, easicopy, MAX, Nios, Quartus, Stratix words and logos are trademarks of Intel Corporation or its subsidiaries in the U.S. and/or other countries. Intel warrants performance of its FPGA and semiconductor products to current specifications in accordance with Intel's standard warranty, but reserves the right to make changes to any products and services at any time without notice. Intel assumes no responsibility or liability arising out of the application or use of any information, product, or service described herein except as expressly agreed to in writing by Intel. Intel customers are advised to obtain the latest version of device specifications before relying on any published information and before placing orders for products or services.

*Other names and brands may be claimed as the property of others.
Copyright 2022<sup>

- [1. Introduction](#1-introduction)
  - [1.1. About This Document](#11-about-this-document)
    - [1.1.1. Terminology](#111-terminology)
    - [1.1.2. Table 1-1 Glossary](#112-table-1-1-glossary)
  - [1.2. Release Capabilities](#12-release-capabilities)
  - [1.3. Prerequisites](#13-prerequisites)
    - [1.3.1. Base Knowledge and Skills Prerequisites](#131-base-knowledge-and-skills-prerequisites)
    - [1.3.2. Development Environment](#132-development-environment)
- [2. Top Level Description](#2-top-level-description)
  - [2.1. Top Level FPGA](#21-top-level-fpga)
  - [2.2. FIM FPGA Resource Usage](#22-fim-fpga-resource-usage)
  - [2.3. FPGA Directory Structure](#23-fpga-directory-structure)
- [3. Description of Sub-Systems](#3-description-of-sub-systems)
  - [3.1. Host Control and Data Flow](#31-host-control-and-data-flow)
- [4. High Level Development Flow](#4-high-level-development-flow)
  - [4.1. Installation of Intel OFS](#41-installation-of-intel-ofs)
    - [4.1.1. Compiling the Intel OFS FIM](#411-compiling-the-intel-ofs-fim)
      - [4.1.1.1. Setting Up Required Environment Variables](#4111-setting-up-required-environment-variables)
      - [4.1.1.2. Compiling](#4112-compiling)
      - [4.1.1.3. Relocatable PR Directory Tree](#4113-relocatable-pr-directory-tree)
    - [4.1.2. Unit Level Simulation](#412-unit-level-simulation)
      - [4.1.2.1. DFH Walking Unit Simulation Output](#4121-dfh-walking-unit-simulation-output)
  - [4.2. Debugging](#42-debugging)
    - [4.2.1. Signal Tap Prerequisites](#421-signal-tap-prerequisites)
    - [4.2.2. Adding Signal Tap](#422-adding-signal-tap)
      - [4.2.2.1. Signal Tap trace acquisition](#4221-signal-tap-trace-acquisition)
  - [4.3. FIM Modification Example](#43-fim-modification-example)
    - [4.3.1. Hello FIM example](#431-hello-fim-example)
      - [4.3.1.1. src/fims/d5005/Intel OFS_top.sv](#4311-srcfimsd5005intel-ofs_topsv)
      - [4.3.1.2. ipss/d5005/emif/emif_csr.sv](#4312-ipssd5005emifemif_csrsv)
      - [4.3.1.3. src/hello_fim/hello_fim_top.sv](#4313-srchello_fimhello_fim_topsv)
      - [4.3.1.4. src/hello_fim/hello_fim_com.sv](#4314-srchello_fimhello_fim_comsv)
      - [4.3.1.5. Unit Level Simulations](#4315-unit-level-simulations)
      - [4.3.1.6. syn/syn_top/d5005.qsf](#4316-synsyn_topd5005qsf)
      - [4.3.1.7. syn/d5005/setup/hello_fim_design_files.tcl](#4317-synd5005setuphello_fim_design_filestcl)
        - [4.3.1.7.1. Build hello_fim example](#43171-build-hello_fim-example)
      - [4.3.1.8. Test the hello_fim on a D5005](#4318-test-the-hello_fim-on-a-d5005)
    - [4.3.2. Conclusion](#432-conclusion)
# 1. Introduction
## 1.1. About This Document

Intel<sup>&reg;</sup>​ Open FPGA Stack (Intel OFS) addresses the demand for FPGA acceleration boards and workloads by providing a powerful methodology for the rapid development of FPGA Acceleration systems.  This methodology addresses the challenges and responsibilities of board, platform and workload developers by providing a complete FPGA project consisting of RTL and simulation code, build scripts and software.  This provided FPGA project can be rapidly customized to meet new market requirements.

Intel OFS separates the FPGA design into two areas: FPGA Interface Manager (FIM) and workload (or Acceleration Function Unit) as shown in the figure below:

<img src="../fim_dev/images/FIM_top_intro.png" alt="FIM Block Diagram" style="width:800px">

As can be seen in this diagram, the Intel OFS FPGA structure has a natural separation into two distinct areas: 
* FPGA Interface Manager (FIM or sometimes called the "the shell") containing:
  * FPGA external interfaces and IP cores (e.g. Ethernet, DDR-4, PCIe, etc)
  * PLLs/resets
  * FPGA - Board management infrastructure
  * Interface to Acceleration Function Unit (AFU)
* Acceleration Function Unit ("the workload")
  * Uses the FIM interfaces to perform useful work inside the FPGA
  * Contains logic supporting partial reconfiguration
  * Remote Signal Tap core for remote debugging of workload
  

This document serves as a design guide for FPGA developers, system architects and hardware developers using Intel OFS as a starting point for the creation of a FPGA Interface Manager (FIM) for a custom FPGA acceleration board.   

This guide is organized as follows: 

* Introduction
* Top Level Block Diagram description
  * Control and data flow
* Description of Sub-systems
  * Command/status registers (CSR) and software interface
  * Clocking, resets and interfaces
  * High speed interface (HSSI)
  * External attached memory
* High Level development flow description
  * Installation of Intel OFS RTL and development packages
  * Compiling FIM
  * Simulation  
* Demonstration steps illustrating how to change areas of the design
* Debugging

This document uses the Intel Programmable Acceleration Card D5005 as an example platform to illustrate key points and demonstrate how to extend the capabilities provided in Intel OFS.  The demonstration steps serve as a tutorial for the development of your Intel OFS knowledge.

This document covers Intel OFS architecture lightly.  For more details on the Intel OFS architecture, please see [*Open FPGA Stack Technical Reference Manual*](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005.md).

You are encouraged to read [*Intel OFS AFU Development Guide*](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/dev_guides/AFU%20User%20Guide/AFU_User_Guide.md) to fully understand how AFU Developers will use your newly developed FIM.

### 1.1.1. Terminology
<a name="terminology"></a>

### 1.1.2. Table 1-1 Glossary
<a name="glossary"></a>

|Term  |Description  |
|---------|---------|
|Intel Open FPGA Stack (Intel OFS)     | A modular collection of hardware platform components, open source software, and broad ecosystem support that provides a standard and scalable model for AFU and software developers to optimize and reuse their designs.         |
|Intel FPGA PAC D5005    | A high-performance PCI Express* (PCIe*)-based FPGA acceleration card for data centers. This card is the Intel Stratix 10 Target platform for Intel OFS.   |
| Accelerator Functional Unit (AFU) | A hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance.  Note: An AFU region is the part of the design where an AFU may reside.  This AFU may or may not be a partial reconfiguration region. |
| Basic Building Block (BBB) | Features within an AFU or part of an FPGA interface that can be reused across designs.  These building blocks do not have stringent interface requirements like the FIM’s AFU and host interface requires.  All BBBs must have a (globally unique identifier) GUID.                   |
|FPGA Interface Manager (FIM) | Provides platform management, functionality, clocks, resets and standard interfaces to host and AFUs.  The FIM resides in the static region of the FPGA and contains the FPGA Management Engine (FME) and I/O ring.                                       |
| FPGA Management Engine (FME) | A module within the FIM that provides management and error detection.                                                             |
| Open Programmable Acceleration Engine Software Development Kit (OPAE SDK) | A collection of libraries and tools to facilitate the development of software applications and accelerators using OPAE.                                                                                                                                                           |
| Platform Interface Manager (PIM) | An interface manager that comprises two components: a configurable platform specific interface for board developers and a collection of shims that AFU developers can use to handle clock crossing, response sorting, buffering and different protocols.                       |                                                                      
|Intel Virtualization Technology for Directed I/O (VT-d)     |An extension of the VT-x and VT-I processor virtualization technologies which adds new support for I/O device virtualization.         |
| Single-Root Input-Output Virtualization (SR-IOV)   | A technology that provides isolation of PCI Express resources for manageability and performance.   |
|Command/Status Register (CSR)  | An internal FPGA register that allows the host to both control and obtain status within the device. |
|Board Peripheral Fabric (BPF) | A 64-bit AXI4-lite compliant interconnect fabric that connects the host control and status path for board peripheral modules |  

## 1.2. Release Capabilities

This release of Intel OFS FIM supports the following key features:

- 1 - Host channel interface via PCIe Gen 3 x 16 SRIOV (1PF, 3 VF, AXI-S TLP packets)
- DDR4 SDRAM External memory interface (AXI-M)
- 1 - 10G Ethernet interfaces (1x10G)
- MSI-X Interrupts (PF, VF)
- 1 - AFU
- Exercisers demonstrating PCIe, external memory and Ethernet interfaces
- Port, FME CSR
- Remote Signal Tap

Intel OFS is extensible to meet the needs of a broad set of customer applications, however not all use cases are easily served.  The general uses cases listed below are examples where the Intel OFS base design can be easily re-used to build a custom FIM:
1. Use Intel OFS reference design as-is
    - Porting the code to another platform that is identical to Intel OFS reference platform changing targeted FPGA device and pinout
    - Change I/O assignments without changing design
2. Update the configuration of peripheral IP in Intel OFS reference design, not affecting FIM architecture
    - External memory settings
    - HSSI analog settings
3. Remove/update peripheral feature in Intel OFS reference design, not affecting FIM architecture
    - External memory speed/width change
    - Change 10G Ethernet to 25 or 100G Ethernet IP
    - Change number of VFs supported
4. Add new features as an extension to Intel OFS reference design, not affecting FIM architecture
    - Add/remove external memory interface to the design
    - Add/remove user clocks for AFU
    - Add/remove IP to the design with connection to AFU

More advanced use cases requiring changes or additions to the host PCIe channel are not easily supported with this release of the Intel OFS FIM.

Reuse of the provided host management FPGA logic and software is the fastest and most simple approach to FIM customization.
## 1.3. Prerequisites

### 1.3.1. Base Knowledge and Skills Prerequisites

The Intel OFS is an advanced application of FPGA technology. This guide assumes you have the following FPGA logic design-related knowledge and skills:

- FPGA compilation flows using Intel<sup>&reg;</sup> Quartus<sup>&reg;</sup> Prime Pro Edition design flow.
- Static Timing closure, including familiarity with the Timing Analyzer tool in Intel<sup>&reg;</sup> Quartus<sup>&reg;</sup> Prime Pro Edition, applying timing constraints, Synopsys* Design Constraints (.sdc) language and Tcl scripting, and design methods to close on timing critical paths.
- RTL and coding practices for FPGA implementation.
- RTL simulation tools.
-  Intel<sup>&reg;</sup> Quartus<sup>&reg;</sup> Prime Pro Edition Signal Tap Logic Analyzer tool software.

### 1.3.2. Development Environment

To run the tutorial steps in this guide requires this development environment:

| Item                          | Version         |
| ------------------------- | ---------- |
| Intel Quartus Prime Pro   | Intel Quartus Prime Pro 22.1 (with license patch) |
| Target D5005 Sever Operating System   |  Red Hat RHEL 8.2  (Windows is not supported)   |
| OPAE SDK   | https://github.com/OPAE/opae-sdk/tree/2.1.1    |
| Simulator  | Synopsys VCS R-2020.12-SP1-1 for UVM simulation of top level FIM and unit level  |
| Python    | 3.6.8 or newer  |
| cmake     | 3.11.4 or newer |
| GCC       | 7.2.0 or newer  |
| perl      | 5.8.8 or newer  |

The following server and Intel PAC card are required to run the examples in this guide:

1. Qualified Intel Xeon <sup>&reg;</sup> server see [Qualified Servers](https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/intel-fpga-pac-d5005/buy.html)
2. Intel FPGA PAC D5005 with root entry hash erased (Please contact Intel for root entry hash erase instructions).  The standard PAC D5005 card is programmed to only allow the FIM binary files signed by Intel to be loaded.  The root entry hash erase process will allow newly created, unsigned FIM binary files to be loaded.
3. Intel FPGA PAC D5005 installed in the qualified server following instructions in [Intel OFS Getting Started User Guide](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005.md)

The steps included in this guide have been verified in the Dell R740 and HPE ProLiant DL380 Gen10 servers.
# 2. Top Level Description

The FIM targets operation in the Intel PAC D5005 card.  The block diagram of the D5005 is shown below:
<img src="../fim_dev/images/d5005_Top.png" alt="Intel FPGA PAC D5005" style="width:600px">

The key D5005 FPGA interfaces are:

- Host interface 
    - PCIe Gen3 x 16
- Network interface
  - 2 - QSFP28 cages
  - Current FIM supports 1 x 10 GbE, other interfaces can be created  
- External Memory
  - 2 or 4 channels of DDR4-2400 to RDIMM modules
  - RDIMM modules =  8GB organized as 1 Gb X 72
- Board Management
  - SPI interface
  - FPGA configuration
  
## 2.1. Top Level FPGA

The internal FPGA architecture is shown below:

<img src="../fim_dev/images/Top_Rel1.png" alt="OFS FIM Top Level Block Diagram" style="width:500px">

## 2.2. FIM FPGA Resource Usage

The FIM uses a small portion of the available FPGA resources.  The table below shows resource usage for a base FIM built with 2 channels of external memory, a small AFU instantiated that has host CSR read/write, external memory test and Ethernet test functionality.
| Entity         | ALMs Used | % ALMS Used | M20Ks  | % M20Ks used | DSP Blocks | Pins | IOPLLs |
|----------------|-----------|-------------|--------|--------------|------------|------|--------|
| Intel OFS_top       | 112333.5  | 12.0%       | 978    | 8.3%         | 0          | 344  | 8      |
| afu_top        | 54184.6   | 5.8%        | 606    | 5.2%         | 0          | 0    | 1      |
| auto_fab_0     | 1592.5    | 0.2%        | 9      | 0.1%         | 0          | 0    | 0      |
| bpf_rsv_5_slv  | 1         | 0.0%        | 0      | 0.0%         | 0          | 0    | 0      |
| bpf_rsv_6_slv  | 0.8       | 0.0%        | 0      | 0.0%         | 0          | 0    | 0      |
| bpf_rsv_7_slv  | 1         | 0.0%        | 0      | 0.0%         | 0          | 0    | 0      |
| bpf            | 250.2     | 0.0%        | 0      | 0.0%         | 0          | 0    | 0      |
| emif_top_inst  | 4465.6    | 0.5%        | 0      | 0.0%         | 0          | 0    | 6      |
| eth_ac_wrapper | 7313      | 0.8%        | 9      | 0.1%         | 0          | 0    | 0      |
| fme_top        | 1774.2    | 0.2%        | 6      | 0.1%         | 0          | 0    | 0      |
| pcie_wrapper   | 42227.2   | 4.5%        | 348    | 3.0%         | 0          | 0    | 0      |
| pmci_top       | 471.7     | 0.1%        | 0      | 0.0%         | 0          | 0    | 0      |
| rst_ctrl       | 45.9      | 0.0%        | 0      | 0.0%         | 0          | 0    | 0      |
| sys_pll        | 0.5       | 0.0%        | 0      | 0.0%         | 0          | 0    | 1      |
|                |           |             |        |              |            |      |        |
|                |           |             |        |              |            |      |        |
| Total ALMS     | 933,120   |             |        |              |            |      |        |
| Total M20Ks    | 11,721    |             |        |              |            |      |        |




##  2.3. FPGA Directory Structure

The Intel OFS Git OFS repository intel-ofs-fim directory structure is shown below:

```
├── ipss
│   └── d5005
|       ├── emif
|       ├── eth
|       └── pcie
├── license
│   └── quartus-0.0-0.01Intel OFS-linux.run
├── sim
│   └── d5005
|       ├── bfm
|       ├── rp_bfm
│       ├── scripts
│       ├── simple_test_pcie
│       ├── simple_test_sriov
│       └── unit_test

├── src
│   ├── common
│   ├── fims
│   ├── fme
│   ├── he_hssi
│   ├── he_lb
│   ├── includes
│   ├── interrupt
│   ├── ip
│   ├── pd_qsys
│   └── port_gasket
│   └── tod
├── syn
│   ├── build_top.sh
│   ├── common
│   └── d5005
|       ├── scripts
|       ├── setup
|       ├── syn_mem4
|       ├── syn_top
|       └── unit_level
└── verification
|   ├── common
|   └── d5005
|   |   ├── testbench
|   |   └── tests
|   ├── scripts
└── sim_top.sh
```

The contents of each directory is described below:

**ipss** - IP files

**license** - Quartus patch file to add IP license

**sim** - Unit level testbench simulation files

**src** - SystemVerilog source files

**syn** - Synthesis scripts

**verification**  - UVM simulation files and individual tests for top level verification 


# 3. Description of Sub-Systems

## 3.1. Host Control and Data Flow
The host control and data flow is shown in the diagram below:

<img src="../fim_dev/images/data_flow.png" alt="OFS FIM Top Level Block Diagram" style="width:500px">

The control and data is composed of the following:

* Host Interface Adapter (PCIe)
* Low Performance Peripherals
  * Slow speed peripherals (I2C, Smbus, etc)
  * Management peripherals (FME)

* High Performance Peripherals
  * Memory peripherals
  * Acceleration Function peripherals
  * HPS Peripheral

* Fabrics
   * Peripheral Fabric (multi drop)
   * AFU Streaming fabric (point to point)
  
Peripherals are connected to one another using AXI:

* Via the peripheral fabric (AXI4-Lite, multi drop)
* Via the AFU streaming fabric (AXI-S, point to point)

Peripherals are presented to software as:

* Intel OFS managed peripherals that implement DFH CSR structure.  
* Native driver managed peripherals (i.e. Exposed via an independent PF, VF)

The peripherals connected to the peripheral fabric are primarily Intel OPAE managed resources, whereas the peripherals connected to the AFU are “primarily” managed by native OS drivers. The word “primarily” is used since the AFU is not mandated to expose all its peripherals to Intel OPAE. It can be connected to the peripheral fabric, but can choose to expose only a subset of its capability to Intel OPAE.

Intel OFS uses a defined set of CSRs to expose the functionality of the FPGA to the host software.  These registers are described in [*Open FPGA Stack Reference Manual - MMIO Regions section](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005.md#7-mmio-regions).

If you make changes to the FIM that affect the software operation, then Intel OFS provides a mechanism to communicate that information to the proper software driver.  The [Device Feature Header (DFH) structure](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005.md#721-device-feature-header-dfh-structure) provides a mechanism to maintain compatibility with OPAE software.  Please see [FPGA Device Feature List (DFL) Framework Overview](https://github.com/OPAE/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#fpga-device-feature-list-dfl-framework-overview) for an excellent description of DFL operation from the driver perspective.

When you are planning your address space for your FIM updates, please be aware Intel OFS FIM targeting Intel FPGA PAC D5005, 256KB of MMIO region is allocated for external FME features and 128kB of MMIO region is allocated for external port features. Each external feature must implement a feature DFH, and the DFH needs to be placed at 4KB boundary. The last feature in the external feature list must have the EOL bit in its DFH set to 1 to mark the end of external feature list.  Since the FPGA address space is limited, consider using an indirect addressing scheme to conserve address space.

# 4. High Level Development Flow

The Intel OFS provides a framework of FPGA synthesizable code, simulation environment, and synthesis/simulation scripts.  FIM designers can take the provided code and scripts and modify existing code or add new code to meet your specific product requirements.

FIM development for a new acceleration card consists of the following steps:

1. Installation of Intel OFS and familiarization with scripts and source code
1. Development of high level block diagram with your specific functionality
    1. Determination of requirements and key performance metrics
    1. Selection of IP cores
    1. Selection of FPGA device
    2. Software memory map
2. Selection and implementation of FIM Physical interfaces including:
    1. External clock sources and creation of internal PLL clocks
    2. General I/O
    3. Transceivers
    4. External memories
    5. FPGA programming methodology
3. Device physical implementation
    1. FPGA device pin assignment
    2. Inclusion of logic lock regions
    3. Creation of timing constraints
    4. Create Quartus FIM test project and validate:
        1. Placement
        2. Timing constraints
        3. Build script process
        4. Review test FIM FPGA resource usage
4. Select FIM to AFU interfaces and development of PIM
5. FIM design implementation
    1. RTL coding
    2. IP instantiation
    3. Development of test AFU to validate FIM
    4. Unit and device level simulation
    5. Timing constraints and build scripts
    6. Timing closure and build validation
6. Creation of FIM documentation to support AFU development and synthesis
7. Software Device Feature discovery
8. Hardware/software integration, validation and debugging
9.  High volume production preparation

The FIM developer works closely with the hardware design of the target board, software development and system validation.

Understanding how the AFU developer consumes the FIM, aides the FIM developer in program success.  Please read [*Intel OFS AFU Development Guide*](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/dev_guides/AFU%20User%20Guide/AFU_User_Guide.md) for a detailed description of AFU development.

## 4.1. Installation of Intel OFS

In this section you set up a development machine for compiling the Intel OFS FIM. These steps are separate from the setup for a deployment machine where the FPGA acceleration card is installed.  Typically, FPGA development and deployment work is performed on separate machines, however, both development and deployment can be performed on the same server if desired.  Please see [*Intel OFS Getting Started User Guide*](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005.md) for instructions on installing software for deployment of your FPGA FIM, AFU and software application on a server.  

Building the Intel OFS FIM requires the build machine to have at least 64 GB of RAM.

Please see [*Intel® OFS 2022.2 Beta (Intel® Stratix® 10)*](https://github.com/otcshare/intel-ofs-fim/releases) for key information on best known configuration for this release and a listing of known issues.

The following is a summary of the steps to set up for FIM development:

1. Install Quartus Prime Pro 22.1 Linux and setup environment
2. Clone the `intel-ofs-fim` repository
3. Test installation by building the provided FIM

Intel Quartus Prime Pro version 22.1 is the currently verified version of Quartus used for building the FIM and AFU images for this release.  Porting to newer versions of Quartus may be performed by developers.  Download Quartus Prime Pro Linux version 22.1 from <https://fpgasoftware.intel.com/22.1/?edition=pro&platform=linux>.

After running the Quartus Prime Pro installer, set the PATH environment variable to make utilities `quartus`, `jtagconfig`, and `quartus_pgm` discoverable. Edit your bashrc file `~/.bashrc` to add the following line:

```
export PATH=$PATH:<Quartus install directory>/quartus/bin
```

For example, if the Quartus install directory is /home/intelFPGA_pro/22.1 then the new line is:

```
export PATH=$PATH:/home/intelFPGA_pro/22.1/quartus/bin
```

Verify, Quartus is discoverable by opening a new shell:

```
$ which quartus
/home/intelFPGA_pro/22.1/quartus/bin/quartus
```
Note, for some Linux distributions such as Red Hat 8.2, Quartus requires installation of the following libraries:
```
$ sudo dnf install install libnsl
$ sudo dnf install ncurses-compat-libs
$ sudo ln -s /usr/bin/python3 /usr/bin/python
 

```

You will need to obtain a license for Quartus Pro to compile the design.  This license is obtained from Intel.  Additionally, Intel OFS for Stratix 10 requires a license for the Low Latency 10Gbps Ethernet MAC (6AF7 0119) IP core.  This license is required to generate a programming file using the provided Intel OFS source code.  The Low Latency 10Gbps Ethernet MAC (6AF7 0119) IP core license patch installer is provided in the intel-ofs-fim git repository in the /license directory.  After cloning the Intel OFS release in step 4 below, you can install this IP license.  



3. Install git and install git lfs to extact large files within the repository that are compressed with git lfs.  Please note, for proper operation of files retrieved from Intel OFS repository, you will require git lfs. 

```
    $ sudo dnf install git
   
   Install git lfs:

	$ curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
	$ sudo dnf install git-lfs
	$ git lfs install
```

4. Retrieve Intel OFS repositories:

The Intel OFS FIM source code is included in the OTCShare GitHub repository. Create a new directory to use as a clean starting point to store the retrieved files.  The following is a short description of each repository, followed by the git commands for cloning. Please note if using an SSH url to clone instead of HTTPS, you will need to follow the Github [guidelines on generating a new SSH key and integrating it with your Githhub profile](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent). The instructions section uses the HTTPS git method for cloning repositories.

1. Navigate to location for storage of Intel OFS source, create the top-level source directory and clone Intel OFS repositories.

```
    $ mkdir Intel OFS_fim_build_root
    $ cd Intel OFS_fim_build_root
    $ export Intel OFS_BUILD_ROOT=$PWD
    $ git clone https://github.com/otcshare/intel-ofs-fim.git
    $ cd intel-ofs-fim
    $ git checkout ofs-1.3.1

    Verify proper tag is selected:
    $ git describe --tags
    ofs-1.3.1
```
2. Install the Low Latency 10Gbps Ethernet MAC (6AF7 0119) IP license by running provided license installer.

```dotnetcli
    $ cd license
    $ chmod +x quartus-0.0-0.01Intel OFS-linux.run
    $ sudo ./quartus-0.0-0.01Intel OFS-linux.run
    Follow steps to install license
    
    Verify patch installed
   $ quartus_sh --version
   Quartus Prime Shell
   Version 22.1.0 Build 174 03/30/2022 Patches 0.01Intel OFS SC Pro Edition

```

### 4.1.1. Compiling the Intel OFS FIM

Intel OFS provides a build script with the following FPGA image creation options:

* Flat compile which combines the FIM and AFU into one FPGA image that is loaded into the entire FPGA device

* A PR compile which creates a FPGA image consisting of the FIM that is loaded into the static region of the FPGA and a default AFU that is loaded into dynamic region. Additional AFUs maybe loaded into the dynamic region using partial reconfiguration.

The build scripts included with Intel OFS are verified to run in a bash shell. Other shells have not been tested. Each build script step will take several hours to complete.s Please note, building directly in Quartus GUI is not supported - you must build with the provided scripts.

The following sections describe how to set up the environment and build the provided FIM and AFU. Follow these steps as a tutorial to learn the build flow. You will use this environment and build scripts for the creation of your specialized FIM.

#### 4.1.1.1. Setting Up Required Environment Variables
Set required environment variables as shown below. These environment variables must be set prior to simulation or compilation tasks so creating a simple script to set these variables saves time.

```
   $ cd $Intel OFS_BUILD_ROOT/intel-ofs-fim
	$ export OFS_ROOTDIR=$PWD

   *Note, OFS_ROOTDIR is the directory where you cloned the repo, e.g. /home/MyProject/intel-ofs-fim *

	$ export WORKDIR=$OFS_ROOTDIR
	$ export VERDIR=$OFS_ROOTDIR/verification
	$ export QUARTUS_HOME=$QUARTUS_ROOTDIR

   *Note, QUARTUS_ROOTDIR is your Quartus installation directory, e.g. $QUARTUS_ROOTDIR/bin contains Quartus executuable*

	$ export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
	$ export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
	$ export IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
	$ export OPAE_SDK_REPO_BRANCH=release/2.1.1
```

#### 4.1.1.2. Compiling

The usage of the compile build script is shown below:
```
syn/build_top.sh [-p] target_configuration work_dir 

      * target_configuration - Specifies the project  
         For example: d5005
  
      * work_dir - Work Directory for this build in the form a directory name. It is created in the <local repo directory>/intel-ofs-fim/<work_dir> 
          - NOTE: The directory name must start with "work".  If the work directory exists, then the script stops and asks if you want to overwrite the directory.
            - e.g.
                - syn/build_top.sh d5005 work_d5005
                
                work directory as a name will be created in <local repo directory>/intel-ofs-fim/work_d5005

                
                The obmission of <work_dir> results in a default work directory (<local repo  directory>/intel-ofs-fim/work)

        - compile reports and artifacts (.rpt, .sof, etc) are stored in <work_dir>/syn/<OFS_PROJECT>/<OFS_FIM>/<OFS_BOARD>/syn_top/output_files
  
        - There is a log file created in intel-ofs-fim directory.  
        - [-p]  Optional switch for creation of a relocatable PR build tree supporting the creation of a PR-able AFU workload.   
        The "-p" switch invokes generate_pr_release.sh at the end of the FIM build and writes the PR build tree to the top of the work directory.  More information on this option is provided below. 
```
In the next example, you will build the provided example design using a flat, non-PR build flow.


 Build the provided base example design:

 ```
    $ cd $Intel OFS_BUILD_ROOT/intel-ofs-fim
    
    $ syn/build_top.sh d5005 work_d5005


    ... build takes ~5 hours to complete

Compile work directory:     <$Intel OFS_BUILD_ROOT>/work_d5005/syn/syn_top
Compile artifact directory: <$Intel OFS_BUILD_ROOT>/work_d5005/syn/syn_top/output_files


***********************************
***
***        OFS_PROJECT: d5005
***        Q_PROJECT:  d5005
***        Q_REVISION: d5005
***        SEED: 03
***        Build Complete
***        Timing Passed!
***
***********************************
```
The build script copies the ipss, sim, src and syn directories to the specified work directory and then these copied files are used in the Quartus compilation process.  Do not edit the files in the work directory, these files are copies of source files.

Some the key output files are described below:


<work_dir>/syn/d5005/syn_top == 
```
├── syn_top                    // D5005 Quartus build area with Quartus files used this build
│  ├── d5005.ipregen.rpt       // IP regeneration report states the output of IP upgrade
│  ├── d5005.qpf               // Quartus Project File (qpf) mentions about Quartus version and project revision
│  ├── d5005.qsf               // Quartus Settings File (qsf) lists current project settings and entity level assignments
│  ├── d5005.stp               // Signal Tap file included in the d5005.qsf. This file can be modified as required if you need to add an Signal Tap instance
│  ├── fme_id.mif              // the fme id hex value is stored in a mif file format
│  ├── Intel OFS_pr_afu.json        // PR JSON file
│  ├── Intel OFS_pr_afu.qsf                // PR AFU qsf file
│  ├── Intel OFS_pr_afu_sources.tcl        // AFU source file list
│  ├── ip_upgrade_port_diff_reports   // IP upgrade report files for reference

```
<work_dir>/syn/d5005/syn_top/output_files == Directory with build reports and FPGA programming files. 

The programming files consist of the Quartus generated d5005.sof and d5005.pof.  The D5005 board hardware provides a 2 Gb flash device to store the FPGA programming files and a MAX10 BMC that reads this flash and programs the D5005 Stratix 10 FPGA. The syn/build_top.sh script runs script file /syn/d5005/scripts/build_flash/build_flash.sh which takes the Quartus generated d5005.sof and creates binary files in the proper format to be loaded into the 2 Gb flash device.  You can also run build_flash.sh by itself if needed.  The build_flash  script runs PACSign (if installed) to create an unsigned FPGA programming file that can be stored in the D5005 FPGA flash. Please note, if the D5005 has the root entry hash key loaded, then PACsign must be run with d5005_page1.bin as the input with the proper key to create an authenticated FPGA binary file.  Please see [Security User Guide: Intel® Open FPGA Stack for Intel® Stratix 10 FPGA](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/user_guides/%20ug_security_ofs_d5005/ug-pac-security-d5005.md) for details on the security aspects of Intel® Open FPGA Stack.

The following table provides further detail on the generated bin files.

| File            | Description                        |
|-----------------|------------------------------------|
| d5005.sof | This is the Quartus generated programming file created by Quartus synthesis and place and route.  This file can be used to programming the FPGA using a JTAG programmer.  This file is used as the source file for the binary files used to program the FPGA flash. |
| d5005.bin |  This is an intermediate raw binary image of the FPGA  |
| d5005_page1.bin | This is the binary file created from input file, d5005.sof.  This file is used as the input file to the PACSign utility to generate **d5005_page1_unsigned.bin** binary image file. |
| d5005_page1_unsigned.bin | This is the unsigned PACSign output which can be programmed into the FPGA flash of an unsigned D5005 usign the OPAE SDK utility **fpgasupdate**  |
| mfg_d5005_reversed.bin | A special programming file for a third party programming device used in board manufacturing.  This file is typically not used.|


build/output_files/timing_report == Directory containing clocks report, failing paths and passing margin reports
 

#### 4.1.1.3. Relocatable PR Directory Tree

If you are developing FIM to be used by another team developing the AFU workload, scripts are provided that create a relocatable PR directory tree. ODM and board developers will make use of this capability to enable a broad set of AFUs to be loaded on a board using PR.  The relocatable PR directory contains the Quartus *.qdb file that goes the FIM.

The creation of the relocatable PR directory tree requires a clone of the Intel Basic Building Blocks (BBB) repository. The OFS_PLATFORM_AFU_BBB environment variable must point to the repository, for example.

```
$ cd $Intel OFS_BUILD_ROOT
$ git clone https://github.com/OPAE/ofs-platform-afu-bbb
$ cd ofs-platform-afu-bbb
$ export OFS_PLATFORM_AFU_BBB=$PWD
$ cd $OFS_ROOTDIR
```

You can create this relocatable PR directory tree by either:

* Build FIM and AFU using /syn/build_top.sh followed by running /syn/common/scripts/generate_pr_release.sh
* Build FIM and AFU using /syn/build_top.sh with optional -p switch included

The generate_pr_release.sh has the following command structure:

```
./syn/common/scripts/generate_pr_release.sh -t <path to generated release tree> *Board Build Target* <work dir from build_top.sh>

Where:

-t <path to generated release tree> = location for your relocatable PR directory tree
*Board Build Target* is the name of the board target/FIM e.g. d5005
<work dir from build_top.sh> 


```
Here is an example of running the generate_pr_release.sh script:

```

$ syn/common/scripts/generate_pr_release.sh -t work_d5005/build_tree d5005  work_d5005

**********************************
********* ENV SETUP **************

FIM Project:
  OFS_PROJECT = d5005
  OFS_FIM     = .
  OFS_BOARD   = .
  Q_PROJECT   = d5005
  Q_REVISION  = d5005
  Fitter SEED = 03
FME id
  BITSTREAM_ID = 04010002c7cab852
  BITSTREAM_MD = 0000000002204283

...
...
```
The resulting relocatable build tree has the following structure:
```
.
├── bin
│   ├── afu_synth
│   ├── build_env_config
│   ├── run.sh -> afu_synth
│   └── update_pim
├── hw
│   ├── blue_bits
│   │   ├── d5005_page1_unsigned.bin
│   │   └── d5005.sof -> ../lib/build/syn/d5005/syn_top/output_files/d5005.sof
│   └── lib
│       ├── build
│       ├── fme-ifc-id.txt
│       ├── fme-platform-class.txt
│       └── platform
```
   
This build tree can be moved to a different location and used for AFU development of a PR capable AFU to be used with this board.
### 4.1.2. Unit Level Simulation

Unit level simulation of key components is provided. These simulations provide verification of the following areas:

* HSSI
* PCIe
* External Memory
* FIM management
  
These simulations use the Synopsys VCS simulator. Each simulation contains a readme file explaining how to run the simulation.  Your simulation shell requires Python, Quartus, and VCS to run.  To run a simulation of the dfh_walker that simulates host access to the internal DFH registers, perform the following steps:

```
Before running unit simulation, you must set environment variables as described below:
   $ cd $Intel OFS_BUILD_ROOT/intel-ofs-fim
	$ export OFS_ROOTDIR=$PWD

   *Note, OFS_ROOTDIR is the directory where you cloned the repo, e.g. /home/MyProject/intel-ofs-fim *

	$ export WORKDIR=$OFS_ROOTDIR
	$ export VERDIR=$OFS_ROOTDIR/verification
	$ export QUARTUS_HOME=$QUARTUS_ROOTDIR

   *Note, QUARTUS_ROOTDIR is your Quartus installation directory, e.g. $QUARTUS_ROOTDIR/bin contains Quartus executuable*

	$ export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
	$ export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
	$ export IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
	$ export OPAE_SDK_REPO_BRANCH=release/2.1.1

```

To compile all IPs:

```
        $ cd $Intel OFS_BUILD_ROOT/intel-ofs-fim/sim/d5005/unit_test/<test_name>/scripts
        $ gmake -f Makefile_VCS.mk cmplib
```
The IPs are generated here: sim/d5005/ip_libraries/
Once the IPs are generated, they can be used for any unit test.

To compile the RTL and Test Bench, run the following command:
```     
        cd sim/d5005/unit_test/<test_name>/scripts
        gmake -f Makefile_VCS.mk build
```
The RTL file list for unit_test is located here: sim/d5005/scripts/rtl_comb.f

To run the simulation, run the following command:

```
        cd sim/d5005/unit_test/<test_name>/scripts
        gmake -f Makefile_VCS.mk run [DUMP=1]
```
Simulation files are located in the sim/d5005/unit_test/<test_name>/sim directory.

To run compile and simulation together:

```
        gmake -f Makefile_VCS.mk build run [DUMP=1] OR
        gmake -f Makefile_VCS.mk run_test [DUMP=1]
```
To view simulation waveform:
```
        cd sim/d5005/unit_test/<test_name>/sim
        dve -full64 -vpd inter.vpd &
```

#### 4.1.2.1. DFH Walking Unit Simulation Output

```
********************************************
 Running TEST(0) : test_fme_dfh_walking
********************************************
READ64: address=0x00000000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x4000000010000000

FME_DFH
   Address   (0x0)
   DFH value (0x4000000010000000)
READ64: address=0x00001000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000020000001

THERM_MNGM_DFH
   Address   (0x1000)
   DFH value (0x3000000020000001)
READ64: address=0x00003000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010000007

GLBL_PERF_DFH
   Address   (0x3000)
   DFH value (0x3000000010000007)
READ64: address=0x00004000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x30000000c0001004

GLBL_ERROR_DFH
   Address   (0x4000)
   DFH value (0x30000000c0001004)
READ64: address=0x00010000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x300000010000000e

SPI_DFH
   Address   (0x10000)
   DFH value (0x300000010000000e)
READ64: address=0x00020000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000100000020

PCIE_DFH
   Address   (0x20000)
   DFH value (0x3000000100000020)
READ64: address=0x00030000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x300000010000100f

HSSI_DFH
   Address   (0x30000)
   DFH value (0x300000010000100f)
READ64: address=0x00040000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000500000009

EMIF_DFH
   Address   (0x40000)
   DFH value (0x3000000500000009)
READ64: address=0x00090000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010001005

FME_PR_DFH
   Address   (0x90000)
   DFH value (0x3000000010001005)
READ64: address=0x00091000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x4000000010001001

PORT_DFH
   Address   (0x91000)
   DFH value (0x4000000010001001)
READ64: address=0x00092000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010000014

USER_CLOCK_DFH
   Address   (0x92000)
   DFH value (0x3000000010000014)
READ64: address=0x00093000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x30000000d0002013

PORT_STP_DFH
   Address   (0x93000)
   DFH value (0x30000000d0002013)
READ64: address=0x000a0000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000010000002010

AFU_INTF_DFH
   Address   (0xa0000)
   DFH value (0x3000010000002010)
MMIO error count matches: x

Test status: OK

********************
  Test summary
********************
   test_fme_dfh_walking (id=0) - pass
Test passed!
Assertion count: 0

```
The simulation transcript is displayed while the simulation runs.  The transcript is saved to the file transcript.out for review after the simulation completes.  The simulation waveform database is saved as vcdplus.vpd for post simulation review. You are encouraged to run the additional simulation examples to learn about each key area of the Intel OFS shell.

## 4.2. Debugging

For degugging issues within the FIM, Signal Tap can be used gain internal visibility into your design.  This section describes the process of adding a Signal Tap instance to your FIM design

### 4.2.1. Signal Tap Prerequisites

To use Signal Tap with Intel OFS, you will need the following:

* Understanding of Signal Tap fundamentals - please review [*Quartus Prime Pro Edition User Guide: Debug Tools*](https://www.intel.com/content/www/us/en/programmable/documentation/nfc1513989909783.html).  

* The Intel FPGA PAC D5005 has a built in Intel FPGA Download Cable II allowing JTAG access to the S10 FPGA. You can access the D5005 built in Intel FPGA Download Cable II by connecting your server to the Micro USB connector as shown below:

<img src="../fim_dev/images/D5005_MicroUSB.png" alt="Quartus Signal Tap" style="width:500px">

*  If you are using a custom board without a built-in Intel FPGA Download Cable then an external Intel Download Cable II (see [Download Cables](https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/download-cables.html) for more information) can be used for Signal Tap access.  The custom board must have JTAG access to the target FPGA for the Intel FPGA Download Cable II.
  
### 4.2.2. Adding Signal Tap

The following steps guide you through the process of adding a Signal Tap instance to your design.  The added Signal Tap instance provides hardware to capture the desired internal signals and connect the stored trace information via JTAG.  Please be aware, the added Signal Tap hardware will consume FPGA resources and may require additional floorplanning steps to accomodate these resources.  Some areas of the FIM use logic lock regions and these regions may need to be re-sized. These steps assume the use of the Intel PAC D5005.

1. Perform a full compile using the script build_top.sh.
2. Once the compile completes open the Quartus GUI using the FIM project.  The Quartus project is named d5005 and is located in the work directory syn/d5005/syn_top/d5005.qpf.  Once the project is loaded, go to Tools > Signal Tap Logic Analyzer to bring up the Signal Tap GUI.

<img src="../fim_dev/images/QuartusSignalTap.png" alt="Quartus Signal Tap" style="width:500px">

3. Accept the "Default" selection and click "Create".
   
<img src="../fim_dev/images/Default_SignalTap.png" alt="Default Signal Tap" style="width:500px">

4. 	This brings up Signal Tap Logic Analyzer window as shown below:

<img src="../fim_dev/images/STP_GUI.png" alt="Signal Tap GUI" style="width:500px">

5. 	Set up clock for STP instance.  In this example, the EMIF CSR module is being instrumented.  If unfamiliar with code, it is helpful to use the Quartus Project Navigator to find the specific block of interest and open the design instance for review.  For example, see snip below using Project Navigator to open emif_csr block:

<img src="../fim_dev/images/STP_ProjNav.png" alt="Project Navigator" style="width:500px">	

6. 	After reviewing code, assign clock for sampling Signal Tap instrumented signals of interest.  Note, the clock selected and the signals you want to view should be the same for best trace fidelity.  Different clocks can be used however there maybe issues with trace inaccuracy due sampling time differences.  In the middle right of the Signal Tap window under Signal Configuration, Clock:  select "…" as shown below: 
	
<img src="../fim_dev/images/STP_Clock.png" alt="STP Clock" style="width:500px">

7. 	After reviewing code, assign clock for sampling Signal Tap instrumented signals of interest.  In the middle right of the Signal Tap window under Signal Configuration, Clock:  select "…" as shown below:   This brings up the Node Finder tool.  Input "*emif_csr*" into Named and select "Search".  This brings up all nodes from the pre-synthesis view.  Expand, "mem" and "emif_csr" and scroll through this list to become familiar with nodes, and then select csr_if.clk and click ">"  to select this clock as shown below and click "OK": 

<img src="../fim_dev/images/STP_nodefinder.png" alt="Node Finder" style="width:500px">

8. Update the sample depth and other Signal Tap settings as needed for your debugging criteria.

<img src="../fim_dev/images/STP_settings.PNG" alt="STP Settings" style="width:500px"> 

9. In the Signal Tap GUI add nodes to be instrumented by double clicking on "Double-click to add nodes".

<img src="../fim_dev/images/STP_addNodes.PNG" alt="STP Clock" style="width:500px">


1.  This brings up the Node Finder.  Add signals to be traced by the Signal Tap instance.  Click "Insert" to add the signals.
2.  To provide a unique name for your Signal Tap instance, select "auto signaltap_0", right click and select rename instance and provide a descriptive name for your instance.
3.  Save the newly created Signal Tap file and click "Yes" to add the new Signal Tap file to the project.
4.  Compile the project with the Signal Tap file added to the project.
5.  Once the compile successfully completes with proper timing, you can load the generated ofs_fim.sof using the Intel FPGA Downloader cable.
    
#### 4.2.2.1. Signal Tap trace acquisition

Load the Signal Tap instrumented SOF file into your target board, open the STP file in the Signal Tap GUI and start the signal acquisition.  

1. The SOF file is located in the work directory build/output_files/ofs_fim.sof.  If the target FPGA is on a different server, then transfer d5005.sof and STP files to the server with the target FPGA.  
2. Load the SOF using the Intel FPGA PAC D5005 built-in Intel FPGA Download Cable II. 
3. Once the SOF file is loaded, start the Quartus Signal Tap GUI.
   
```
$ quartus_stpw

The Signal Tap GUI comes up.
```
4. In the Signal Tap GUI, `Hardware:` selection box select the cable "Stratix10 Darby Creek [ JTAG cable number ]" as shown below:
  
<img src="../fim_dev/images/STP_HW.png" alt="STP HW" style="width:500px">

1. In `File` open your STP file.  Your STP file settings will load.  If not already set, you can create the trigger conditions, then start analysis with `F5`.

## 4.3. FIM Modification Example

An example of FIM modification are provided in this section.  This example can be used in your specific application as a starting point.  This example shows the basic flow and listing of files that are to be changed.

### 4.3.1. Hello FIM example

If you intend to add a new module to the FIM area, then you will need to inform the host software of the new module.  The FIM exposes its functionalities to host software through a set of CSR registers that are mapped to an MMIO region (Memory Mapped IO).  This set of CSR registers and their operation is described in [FIM MMIO Regions](https://github.com/otcshare/intel-ofs-docs/blob/main/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005.md#7-mmio-regions).

See [FPGA Device Feature List (DFL) Framework Overview](https://github.com/OPAE/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#fpga-device-feature-list-dfl-framework-overview) for a description of the software process to read and process the linked list of Device Feature Header (DFH) CSRs within a FPGA.

This example adds a simple DFH register set to the FIM. You can use this example as the basis for adding a new feature to your FIM.  

The steps to add this simple DFH register are described below.

1. Review current design documentation: OFS Tech Ref MMIO Regions
2. Understand FME and Port regions, DFH walking, DFH register structure 
3. Run unit level simulations and review output:
			i.  sim/d5005/unit_test/dfh_walker
1. Note DFH link list order, see [DFH Walker Unit Level Simulation Output](#dfh-walking-unit-simulation-output)
4. Make code changes to top level FIM file to instantiate new DFH register
5. The DFH registers follow a link list.  This example inserts the hello_fim DFH register after the EMIF DFH register, so the emif_csr.sv parameters are updated to insert the hello_fim DFH register as next register in the link list.
6. Create the new hello_fim SystemVerilog files.
7. Update and run the dfh_walker unit simulation files
8. Update synthesis files to include the new hello_fim source files
9. Build and test the new FIM

The following sections describe changes to add the hello_fim DFH example to the Intel provided FPGA design.

#### 4.3.1.1. src/fims/d5005/Intel OFS_top.sv
		
1. Edit top level design module: src/fims/d5005/Intel OFS_top.sv
  1. Instantiate new hello_fim module in Intel OFS_top.sv at line 294


```Verilog
//*******************************
// FME
//*******************************

  fme_top 
  fme_top(
          .clk               (clk_1x                    ),
          .rst_n             (rst_n_d_1x       ),
          .pwr_good_n        (ninit_done                ),
          .i_pcie_error      ('0                        ),
          
          .axi_lite_m_if     (bpf_fme_mst_if            ),
          .axi_lite_s_if     (bpf_fme_slv_if            )
         );


`ifdef INCLUDE_HELLO_FIM

		hello_fim_top 
           hello_fim_top (
		.clk   (clk_1x),
   
       .rst_n                      (rst_n_d_1x),
       .csr_lite_if             (bpf_rsv_5_slv_if)
		
		   
		);
`endif
		
//*******************************
// AFU
//*******************************

```

You will connect the Hello_FIM DFH register to the existing BPF reserved link 5.  The provided Intel OFS reference design includes 3 reserved BPF interfaces available for custom usage such as new OPAE controlled modules.  The address map of BPF is shown below:

| **Address**       | **Size (Byte)** | **Feature**                 | **Master** |
| ----------------- | --------------- | --------------------------- | ---------- |
| 0x00000 – 0x0FFFF | 64K             | FME (FME, Error, etc)       | Yes        |
| 0x10000 – 0x1FFFF | 64K             | PMCI Proxy (SPI Controller) | Yes        |
| 0x20000 – 0x2FFFF | 64K             | PCIe CSR                    |            |
| 0x30000 – 0x3FFFF | 64K             | HSSI CSR                    |            |
| 0x40000 – 0x4FFFF | 64K             | EMIF CSR                    |            |
| 0x50000 – 0x5FFFF | 64K             | Reserved                    |            |
| 0x60000 – 0x6FFFF | 64K             | Reserved                    |            |
| 0x70000 – 0x7FFFF | 64K             | Reserved                    |            |

The BPF reserved link 5 is connected to a dummy connection to prevent this link from being optimized out the design during synthesis.  You will add a compiler `define that will cause this dummy connection to be removed when the variable INCLUDE_HELLO_FIM is defined by editing line 575 if iofs_top.sv as shown below:

```Verilog
    // Reserved address response
   `ifndef INCLUDE_HELLO_FIM
    bpf_dummy_slv
    bpf_rsv_5_slv (
        .clk            (clk_1x),
        .dummy_slv_if   (bpf_rsv_5_slv_if)
    );
    `endif
```
#### 4.3.1.2. ipss/d5005/emif/emif_csr.sv

The Hello_FIM DFH is inserted in the DFH link list after the EMIF CSR DFH and before the FME_PR DFH.  The file ipss/d5005/emif/emif_csr.sv contains a parameter defining the next address for the next DFH in in the link list chain.  You will change the next address offset to be 0x10000 so the reveserved BPF AXI lite link connected to the Hello_FIM DFH register is next in the DFH link list.

```Verilog
module emif_csr #(
  parameter NUM_LOCAL_MEM_BANKS = 1,
  parameter END_OF_LIST         = 1'b0,
  `ifndef INCLUDE_HELLO_FIM
  parameter NEXT_DFH_OFFSET     = 24'h05_0000
  `else
  parameter NEXT_DFH_OFFSET     = 24'h01_0000//New for Hello_FIM, next offset now at 0x50000
  `endif
)
```
#### 4.3.1.3. src/hello_fim/hello_fim_top.sv

Create hello_fim_top.sv, and store it in src/hello_fim directory. The main purpose of this RTL is to convert AXI4-Lite interface to a simple interface to interface with the registers in hello_fim_com.sv.  This register sets the DFH feature ID to 0xfff which is undefined.  Since this for test purposes, using an undefined feature ID will result in no driver being used.  Normally, a defined feature ID will be used to associate a specific driver with the FPGA module.

```Verilog
// ***************************************************************************
//                               INTEL CONFIDENTIAL
//
//        Copyright (C) 2021 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all  documents related to
// the  source  code  ("Material")  are  owned  by  Intel  Corporation  or its
// suppliers  or  licensors.    Title  to  the  Material  remains  with  Intel
// Corporation or  its suppliers  and licensors.  The Material  contains trade
// secrets  and  proprietary  and  confidential  information  of  Intel or its
// suppliers and licensors.  The Material is protected  by worldwide copyright
// and trade secret laws and treaty provisions. No part of the Material may be
// used,   copied,   reproduced,   modified,   published,   uploaded,  posted,
// transmitted,  distributed,  or  disclosed  in any way without Intel's prior
// express written permission.
//
// No license under any patent,  copyright, trade secret or other intellectual
// property  right  is  granted  to  or  conferred  upon  you by disclosure or
// delivery  of  the  Materials, either expressly, by implication, inducement,
// estoppel or otherwise.  Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
// You will not, and will not allow any third party to modify, adapt, enhance, 
// disassemble, decompile, reverse engineer, change or create derivative works 
// from the Software except and only to the extent as specifically required by 
// mandatory applicable laws or any applicable third party license terms 
// accompanying the Software.
//
// -----------------------------------------------------------------------------
// Engineer     : 
// Create Date  : Nov 2021
// Module Name  : hello_fim_top.sv
// Project      : Intel OFS
// -----------------------------------------------------------------------------
//
// Description: 
// This is a simple module that implements DFH registers and 
// AVMM address decoding logic.


module hello_fim_top  #(
   parameter ADDR_WIDTH  = 12, 
   parameter DATA_WIDTH = 64, 
   parameter bit [11:0] FEAT_ID = 12'hfff,
   parameter bit [3:0]  FEAT_VER = 4'h0,
   parameter bit [23:0] NEXT_DFH_OFFSET = 24'h04_0000,
   parameter bit END_OF_LIST = 1'b0
)(
   input  logic    clk,
   input  logic    rst_n,
// -----------------------------------------------------------
//  AXI4LITE Interface
// -----------------------------------------------------------
   ofs_fim_axi_lite_if.slave   csr_lite_if
);

import ofs_fim_cfg_pkg::*;
import ofs_csr_pkg::*;

//-------------------------------------
// Signals
//-------------------------------------
   logic [ADDR_WIDTH-1:0]              csr_waddr;
   logic [DATA_WIDTH-1:0]              csr_wdata;
   logic [DATA_WIDTH/8-1:0]            csr_wstrb;
   logic                               csr_write;
   logic                               csr_slv_wready;
   csr_access_type_t                   csr_write_type;

   logic [ADDR_WIDTH-1:0]              csr_raddr;
   logic                               csr_read;
   logic                               csr_read_32b;
   logic [DATA_WIDTH-1:0]              csr_readdata;
   logic                               csr_readdata_valid;
   logic [ADDR_WIDTH-1:0]              csr_addr;

   logic [63:0]                        com_csr_writedata;
   logic                               com_csr_read;
   logic                               com_csr_write;
   logic [63:0]                        com_csr_readdata;
   logic                               com_csr_readdatavalid;
   logic [5:0]                         com_csr_address;

// AXI-M CSR interfaces
ofs_fim_axi_mmio_if #(
   .AWID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .AWADDR_WIDTH (ADDR_WIDTH),
   .WDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH),
   .ARID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .ARADDR_WIDTH (ADDR_WIDTH),
   .RDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH)
) csr_if();

// AXI4-lite to AXI-M adapter
axi_lite2mmio axi_lite2mmio (
   .clk       (clk),
   .rst_n     (rst_n),
   .lite_if   (csr_lite_if),
   .mmio_if   (csr_if)
);

//---------------------------------
// Map AXI write/read request to CSR write/read,
// and send the write/read response back
//---------------------------------
ofs_fim_axi_csr_slave #(
   .ADDR_WIDTH (ADDR_WIDTH),
   .USE_SLV_READY (1'b1)
   
   ) csr_slave (
   .csr_if             (csr_if),

   .csr_write          (csr_write),
   .csr_waddr          (csr_waddr),
   .csr_write_type     (csr_write_type),
   .csr_wdata          (csr_wdata),
   .csr_wstrb          (csr_wstrb),
   .csr_slv_wready     (csr_slv_wready),
   .csr_read           (csr_read),
   .csr_raddr          (csr_raddr),
   .csr_read_32b       (csr_read_32b),
   .csr_readdata       (csr_readdata),
   .csr_readdata_valid (csr_readdata_valid)
);

// Address mapping
assign csr_addr          	= csr_write ? csr_waddr : csr_raddr;
assign com_csr_address     	= csr_addr[5:0];  // byte address
assign csr_slv_wready 		= 1'b1 ;
// Write data mapping
assign com_csr_writedata   	= csr_wdata;

// Read-Write mapping
always_comb
begin
   com_csr_read            	= 1'b0;
   com_csr_write        	= 1'b0;
   casez (csr_addr[11:6])
      6'h00 : begin // Common CSR
         com_csr_read       = csr_read;
         com_csr_write 		= csr_write;
      end   
      default: begin
         com_csr_read     	= 1'b0;
         com_csr_write    	= 1'b0;
      end
   endcase
end
// Read-Write mapping
always_comb
begin
   com_csr_read            	= 1'b0;
   com_csr_write        	= 1'b0;
   casez (csr_addr[11:6])
      6'h00 : begin // Common CSR
         com_csr_read       = csr_read;
         com_csr_write 		= csr_write;
      end   
      default: begin
         com_csr_read     	= 1'b0;
         com_csr_write    	= 1'b0;
      end
   endcase
end

// Read data mapping
   always_comb begin
      if (com_csr_readdatavalid) begin
         csr_readdata       = com_csr_readdata;
         csr_readdata_valid = 1'b1;
      end
      else begin
         csr_readdata       = '0;
         csr_readdata_valid = 1'b0;
      end
   end
   
   hello_fim_com  #(
   .FEAT_ID          (FEAT_ID),
   .FEAT_VER         (FEAT_VER),
   .NEXT_DFH_OFFSET  (NEXT_DFH_OFFSET),
   .END_OF_LIST      (END_OF_LIST)
) hello_fim_com_inst (
   .clk                   (clk                     ),
   .rst_n                 (rst_n                  ),
   .writedata             (com_csr_writedata       ),
   .read                  (com_csr_read            ),
   .write                 (com_csr_write           ),
   .byteenable            (4'hF                    ),
   .readdata              (com_csr_readdata        ),
   .readdatavalid         (com_csr_readdatavalid   ),
   .address               (com_csr_address         )
   );


endmodule

```


#### 4.3.1.4. src/hello_fim/hello_fim_com.sv

Create hello_fim_com.sv, and store it in src/hello_fim directory. This is the simple RTL to implement the Hello FIM registers. You may use this set of registers as the basis for your custom implementation.

```Verilog
// ***************************************************************************
//                               INTEL CONFIDENTIAL
//
//        Copyright (C) 2021 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all  documents related to
// the  source  code  ("Material")  are  owned  by  Intel  Corporation  or its
// suppliers  or  licensors.    Title  to  the  Material  remains  with  Intel
// Corporation or  its suppliers  and licensors.  The Material  contains trade
// secrets  and  proprietary  and  confidential  information  of  Intel or its
// suppliers and licensors.  The Material is protected  by worldwide copyright
// and trade secret laws and treaty provisions. No part of the Material may be
// used,   copied,   reproduced,   modified,   published,   uploaded,  posted,
// transmitted,  distributed,  or  disclosed  in any way without Intel's prior
// express written permission.
//
// No license under any patent,  copyright, trade secret or other intellectual
// property  right  is  granted  to  or  conferred  upon  you by disclosure or
// delivery  of  the  Materials, either expressly, by implication, inducement,
// estoppel or otherwise.  Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
// You will not, and will not allow any third party to modify, adapt, enhance, 
// disassemble, decompile, reverse engineer, change or create derivative works 
// from the Software except and only to the extent as specifically required by 
// mandatory applicable laws or any applicable third party license terms 
// accompanying the Software.
//
// -----------------------------------------------------------------------------
// Engineer     : 
// Create Date  : Nov 2021
// Module Name  : hello_fim_com.sv
// Project      : IOFS
// -----------------------------------------------------------------------------
//
// Description: 
// This is a simple module that implements DFH registers and 
// AVMM address decoding logic.


module hello_fim_com #(
    parameter bit [11:0] FEAT_ID = 12'h001,
    parameter bit [3:0]  FEAT_VER = 4'h1,
    parameter bit [23:0] NEXT_DFH_OFFSET = 24'h1000,
    parameter bit END_OF_LIST = 1'b0
 )(
 input clk,
 input rst_n,
 input [63:0] writedata,
 input read,
input write,
input [3:0] byteenable,
output reg [63:0] readdata,
output reg readdatavalid,
input [5:0] address
);


reg [63:0] rdata_comb;
reg [63:0] scratch_reg;

always @(posedge clk)  
   if (!rst_n) readdata[63:0] <= 64'h0; else readdata[63:0] <= rdata_comb[63:0];

always @(posedge clk)
   if (!rst_n) readdatavalid <= 1'b0; else readdatavalid <= read;

wire wr = write;
wire re = read;
wire [5:0] addr = address[5:0];
wire [63:0] din  = writedata [63:0];
wire wr_scratch_reg = wr & (addr[5:0]  == 6'h30)? byteenable[0]:1'b0;

// 64 bit scratch register
always @( posedge clk)
   if (!rst_n)  begin
      scratch_reg <= 64'h0;
   end
   else begin
   if (wr_scratch_reg) begin 
      scratch_reg <=  din;  
   end
end

always @ (*)
begin
rdata_comb = 64'h0000000000000000;
   if(re) begin
      case (addr)  
	6'h00 : begin
		rdata_comb [11:0]	= FEAT_ID ;  // dfh_feature_id 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [15:12]	= FEAT_VER ;  // dfh_feature_rev 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [39:16]	= NEXT_DFH_OFFSET ;  // dfh_dfh_ofst is reserved or a constant value, a read access gives the reset value
		rdata_comb [40]	    = END_OF_LIST ;        //dfh_end_of_list
		rdata_comb [59:40]	= 20'h00000 ;  // dfh_rsvd1 	is reserved or a constant value, a read access gives the reset value
		rdata_comb [63:60]	= 4'h3 ;  // dfh_feat_type 	is reserved or a constant value, a read access gives the reset value
	end
	6'h30 : begin
		rdata_comb [63:0]	= scratch_reg; 
	end
        6'h38 : begin
                rdata_comb [63:0]       = 64'h6626_0701_5000_0034;
        end
	default : begin
		rdata_comb = 64'h0000000000000000;
	end
      endcase
   end
end

endmodule

```

#### 4.3.1.5. Unit Level Simulations
To run a unit level simulation test for the updated RTL files, make modifications to your cloned /my_ofs_project/intel-ofs-fim/sim/d5005/unit_test/dfh_walker files.  The following simulation files are updated to test the new hello_fim.
				
1. Edit sim/d5005/unit_test/dfh_walker/testbench/test_csr_defs.sv
  
   1. Update enum line 38
   
```Verilog
	   typedef enum {
      FME_DFH_IDX,
      THERM_MNGM_DFH_IDX,
      GLBL_PERF_DFH_IDX,
      GLBL_ERROR_DFH_IDX,
      SPI_DFH_IDX,
      PCIE_DFH_IDX,
      HSSI_DFH_IDX,
      EMIF_DFH_IDX,
      HELLO_FIM_DFH_IDX,//New for HELLO_FIM
      FME_PR_DFH_IDX,
      PORT_DFH_IDX,
      USER_CLOCK_DFH_IDX,
      PORT_STP_DFH_IDX,
      AFU_INTF_DFH_IDX,
      MAX_FME_DFH_IDX
   } t_fme_dfh_idx;
```

   1. Edit function dfh_name line 78
   
```Verilog
function automatic dfh_name[MAX_FME_DFH_IDX-1:0] get_fme_dfh_names();
      dfh_name[MAX_FME_DFH_IDX-1:0] fme_dfh_names;

      fme_dfh_names[FME_DFH_IDX]         = "FME_DFH";
      fme_dfh_names[THERM_MNGM_DFH_IDX]  = "THERM_MNGM_DFH";
      fme_dfh_names[GLBL_PERF_DFH_IDX]   = "GLBL_PERF_DFH";
      fme_dfh_names[GLBL_ERROR_DFH_IDX]  = "GLBL_ERROR_DFH";
      fme_dfh_names[SPI_DFH_IDX]         = "SPI_DFH";
      fme_dfh_names[PCIE_DFH_IDX]        = "PCIE_DFH";
      fme_dfh_names[HSSI_DFH_IDX]        = "HSSI_DFH";
      fme_dfh_names[EMIF_DFH_IDX]        = "EMIF_DFH";
      fme_dfh_names[HELLO_FIM_DFH_IDX]        = "HELLO_FIM_DFH";//New for HELLO_FIM
      fme_dfh_names[FME_PR_DFH_IDX]      = "FME_PR_DFH";
      fme_dfh_names[PORT_DFH_IDX]        = "PORT_DFH";
      fme_dfh_names[USER_CLOCK_DFH_IDX]  = "USER_CLOCK_DFH";
      fme_dfh_names[PORT_STP_DFH_IDX]    = "PORT_STP_DFH";
      fme_dfh_names[AFU_INTF_DFH_IDX]    = "AFU_INTF_DFH";

      return fme_dfh_names;
   endfunction
```

   1. Update get_fme_dfh_values

```Verilog
  function automatic [MAX_FME_DFH_IDX-1:0][63:0] get_fme_dfh_values();
      logic[MAX_FME_DFH_IDX-1:0][63:0] fme_dfh_values;

      fme_dfh_values[FME_DFH_IDX]        = 64'h4000_0000_1000_0000;
      fme_dfh_values[THERM_MNGM_DFH_IDX] = 64'h3_00000_002000_0001;
      fme_dfh_values[GLBL_PERF_DFH_IDX]  = 64'h3_00000_001000_0007;
      fme_dfh_values[GLBL_ERROR_DFH_IDX] = 64'h3_00000_00C000_1004;  
      fme_dfh_values[SPI_DFH_IDX]        = 64'h3_00000_010000_000e;  
      fme_dfh_values[PCIE_DFH_IDX]       = 64'h3_00000_010000_0020;  
      fme_dfh_values[HSSI_DFH_IDX]       = 64'h3_00000_010000_100f;  
      fme_dfh_values[EMIF_DFH_IDX]       = 64'h3_00000_010000_0009; //Update to link to Hello_FIM 
      fme_dfh_values[HELLO_FIM_DFH_IDX]  = 64'h3_00000_040000_0FFF;  //New for Hello_FIM
      fme_dfh_values[FME_PR_DFH_IDX]     = 64'h3_00000_001000_1005;  
      fme_dfh_values[PORT_DFH_IDX]       = 64'h4000_0000_1000_1001;
      fme_dfh_values[USER_CLOCK_DFH_IDX] = 64'h3_00000_001000_0014;
      fme_dfh_values[PORT_STP_DFH_IDX]   = 64'h3_00000_00D000_2013;
      fme_dfh_values[AFU_INTF_DFH_IDX]   = 64'h3_00001_000000_2010; 

      return fme_dfh_values;
   endfunction

```

1. Update sim/d5005/dfh_walker/scripts/Makefile_VCS.mk to set macro for INCLUDE_HELLO_FIM starting at line 56 to add +define+INCLUDE_HELLO_FIM
```
VLOG_OPT += +define+SIM_MODE +define+VCS_S10 +define+RP_MAX_TAGS=64 +define+INCLUDE_DDR4 +define+INCLUDE_SPI_BRIDGE +define+INCLUDE_USER_CLOCK +define+INCLUDE_HSSI +define+SIM_USE_PCIE_DUMMY_CSR +define+INCLUDE_HELLO_FIM
```
1. Update sim/d5005/scripts/rt_comb.f to add the path to your new hello_fim_top and hello_top_com SystemVerilog files.  The update is shown below as the new line - 329 below:

```

$WORKDIR/src/hello_fim/hello_fim_com.sv
$WORKDIR/src/hello_fim/hello_fim_top.sv

```

After making these changes, run the unit level simulation using sim/d5005/unit_test/dfh_walker test.  Before running, ensure your shell has the environment variables set properly as defined in [Setting Up Required Environment Variables](#setting-up-required-environment-variables).


```
$ cd sim/d5005/unit_test/dfh_walker/scripts
$ gmake -f Makefile_VCS.mk cmplib
$ gmake -f Makefile_VCS.mk build run [DUMP=1]

```

Expected output:
```dotnetcli
 ********************************************
 Running TEST(0) : test_fme_dfh_walking
********************************************
READ64: address=0x00000000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x4000000010000000

FME_DFH
   Address   (0x0)
   DFH value (0x4000000010000000)
READ64: address=0x00001000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000020000001

THERM_MNGM_DFH
   Address   (0x1000)
   DFH value (0x3000000020000001)
READ64: address=0x00003000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010000007

GLBL_PERF_DFH
   Address   (0x3000)
   DFH value (0x3000000010000007)
READ64: address=0x00004000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x30000000c0001004

GLBL_ERROR_DFH
   Address   (0x4000)
   DFH value (0x30000000c0001004)
READ64: address=0x00010000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x300000010000000e

SPI_DFH
   Address   (0x10000)
   DFH value (0x300000010000000e)
READ64: address=0x00020000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000100000020

PCIE_DFH
   Address   (0x20000)
   DFH value (0x3000000100000020)
READ64: address=0x00030000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x300000010000100f

HSSI_DFH
   Address   (0x30000)
   DFH value (0x300000010000100f)
READ64: address=0x00040000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000100000009

EMIF_DFH
   Address   (0x40000)
   DFH value (0x3000000100000009)
READ64: address=0x00050000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000400000fff

HELLO_FIM_DFH
   Address   (0x50000)
   DFH value (0x3000000400000fff)
READ64: address=0x00090000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010001005

FME_PR_DFH
   Address   (0x90000)
   DFH value (0x3000000010001005)
READ64: address=0x00091000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x4000000010001001

PORT_DFH
   Address   (0x91000)
   DFH value (0x4000000010001001)
READ64: address=0x00092000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000000010000014

USER_CLOCK_DFH
   Address   (0x92000)
   DFH value (0x3000000010000014)
READ64: address=0x00093000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x30000000d0002013

PORT_STP_DFH
   Address   (0x93000)
   DFH value (0x30000000d0002013)
READ64: address=0x000a0000 bar=0 vf_active=0 pfn=0 vfn=0

   READDATA: 0x3000010000002010

AFU_INTF_DFH
   Address   (0xa0000)
   DFH value (0x3000010000002010)
MMIO error count matches: x

Test status: OK

********************
  Test summary
********************
   test_fme_dfh_walking (id=0) - pass
Test passed!
Assertion count: 0

```

#### 4.3.1.6. syn/syn_top/d5005.qsf

1. Edit syn/syn_top/d5005.qsf      
   1.  Add new macro "INCLUDE_HELLO_FIM" line 107
```
		set_global_assignment -name VERILOG_MACRO "INCLUDE_HELLO_FIM"
```

  2. Add new line 211 to source TCL script with new hello_fim files
```
		set_global_assignment -name SOURCE_TCL_SCRIPT_FILE ../../../syn/d5005/setup/hello_fim_design_files.tcl
```
#### 4.3.1.7. syn/d5005/setup/hello_fim_design_files.tcl 

Create "hello_fim_design_files.tcl" file and store in the syn/d5005/setup directory. This tcl file is called from d5005.qsf.

```tcl
# Copyright 2021 Intel Corporation.
#
# THIS SOFTWARE MAY CONTAIN PREPRODUCTION CODE AND IS PROVIDED BY THE
# COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Hello FIM Files
#--------------------
set_global_assignment -name SYSTEMVERILOG_FILE src/hello_fim/hello_fim_com.sv
set_global_assignment -name SYSTEMVERILOG_FILE src/hello_fim/hello_fim_top.sv
```
##### 4.3.1.7.1. Build hello_fim example

With the preceding changes complete, build the new hello_fim example using the following steps:

```dotnetcli
$ cd $OFS_ROOTDIR
$ syn/build_top.sh d5005 work_d5005_hello_fim

```

Verify the design successfully compiled and timing closure is achieved by checking work_d5005_hello_fim/syn/d5005/syn_top/output_files/timing_report/clocks.sta.fail.summary - this file should be empty.  If there are timing failures, then this file will list the failing clock domain(s).

#### 4.3.1.8. Test the hello_fim on a D5005

Load the built FPGA binary file using an unsigned image.  The FPGA image will be in work_d5005_hello_fim/syn/d5005/syn_top/output_files/d5005_page1_unsigned.bin

Provide the file d5005_page1_unsigned.bin on the server with the Intel FPGA PAC D5005.

```
   $ sudo fpgasupdate d5005_page1_unsigned.bin <D5005 PCIe B:D.F>
   $ sudo rsu bmcimg <D5005 PCIe B:D.F>

   Verify FPGA image is loaded.

   $ sudo fpgainfo fme
```

Use the OPAE SDK tool opae.io to check default driver binding using your card under test PCIe B:D.F.  The steps below will use 0000:12:00.0 as the card under test PCIe B:D.F.

```dotnetcli
 sudo opae.io init -d 0000:12:00.0 $USER
 [0000:12:00.0] (0x8086, 0xbcce) Intel D5005 ADP (Driver: dfl-pci)
```
The dfl-pci driver is used by OPAE SDK fpgainfo commands.  The next steps will bind the card under test to the vfio driver to enable access to the registers.

```dotnetcli
 sudo opae.io init -d 0000:12:00.0 $USER
 opae.io 0.2.3
Unbinding (0x8086,0xbcce) at 0000:12:00.0 from dfl-pci
Binding (0x8086,0xbcce) at 0000:12:00.0 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:12:00.0 is 35
Assigning /dev/vfio/35 to $USER
```
Confirm the vfio driver is bound to the card under test.

```dotnetcli
$ opae.io ls
opae.io 0.2.3
[0000:12:00.0] (0x8086, 0xbcce) Intel D5005 ADP (Driver: vfio-pci)
```
Run the following command to walk DFH link list.  The new hello_fim register is located at offset 0x50000.

```dotnetcli
$ opae.io walk -d 0000:12:00.0
opae.io 0.2.3
offset: 0x0000, value: 0x4000000010000000
    dfh: id = 0x0, rev = 0x0, next = 0x1000, eol = 0x0, reserved = 0x0, feature_type = 0x4
offset: 0x1000, value: 0x3000000020000001
    dfh: id = 0x1, rev = 0x0, next = 0x2000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x3000, value: 0x3000000010000007
    dfh: id = 0x7, rev = 0x0, next = 0x1000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x4000, value: 0x30000000c0001004
    dfh: id = 0x4, rev = 0x1, next = 0xc000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x10000, value: 0x300000010000000e
    dfh: id = 0xe, rev = 0x0, next = 0x10000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x20000, value: 0x3000000100000020
    dfh: id = 0x20, rev = 0x0, next = 0x10000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x30000, value: 0x300000010000100f
    dfh: id = 0xf, rev = 0x1, next = 0x10000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x40000, value: 0x3000000100000009
    dfh: id = 0x9, rev = 0x0, next = 0x10000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x50000, value: 0x3000000400000fff
    dfh: id = 0xfff, rev = 0x0, next = 0x40000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x90000, value: 0x3000000010001005
    dfh: id = 0x5, rev = 0x1, next = 0x1000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x91000, value: 0x4000000010001001
    dfh: id = 0x1, rev = 0x1, next = 0x1000, eol = 0x0, reserved = 0x0, feature_type = 0x4
offset: 0x92000, value: 0x3000000010000014
    dfh: id = 0x14, rev = 0x0, next = 0x1000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0x93000, value: 0x30000000d0002013
    dfh: id = 0x13, rev = 0x2, next = 0xd000, eol = 0x0, reserved = 0x0, feature_type = 0x3
offset: 0xa0000, value: 0x3000010000002010
    dfh: id = 0x10, rev = 0x2, next = 0x0, eol = 0x1, reserved = 0x0, feature_type = 0x3

```
Read the default values from the hello_fim registers:

```dotnetcli
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50000
opae.io 0.2.3
0x3000000400000fff
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50030
opae.io 0.2.3
0x0
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50038
opae.io 0.2.3
0x6626070150000034

```
Write the scratchpad register at 0x50030

```dotnetcli
$ opae.io -d 0000:12:00.0 -r 0 poke 0x50038 0x123456789abcdef
opae.io 0.2.3
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50038
opae.io 0.2.3
0x6626070150000034
$ opae.io -d 0000:12:00.0 -r 0 poke 0x50030 0x123456789abcdef
opae.io 0.2.3
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50030
opae.io 0.2.3
0x123456789abcdef
$ opae.io -d 0000:12:00.0 -r 0 poke 0x50030 0xfedcba9876543210
opae.io 0.2.3
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50030
opae.io 0.2.3
0xfedcba9876543210
$ opae.io -d 0000:12:00.0 -r 0 poke 0x50030 0x55550000aaaaffff
opae.io 0.2.3
$ opae.io -d 0000:12:00.0 -r 0 peek 0x50030
opae.io 0.2.3
0x55550000aaaaffff
```

Release the card under test from the vfio driver to re-bind to the dfl-pci driver:

```dotnetcli
$ sudo opae.io release -d 0000:12:00.0
opae.io 0.2.3
Releasing (0x8086,0xbcce) at 0000:12:00.0 from vfio-pci
Rebinding (0x8086,0xbcce) at 0000:12:00.0 to dfl-pci
$ sudo opae.io ls
opae.io 0.2.3
[0000:12:00.0] (0x8086, 0xbcce) Intel D5005 ADP (Driver: dfl-pci)

```
### 4.3.2. Conclusion

Using the Intel OFS reference design and OPAE SDK enables the rapid creation of market leading FPGA applications.