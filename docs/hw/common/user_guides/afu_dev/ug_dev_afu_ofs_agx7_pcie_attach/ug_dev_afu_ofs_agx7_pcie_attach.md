# **AFU Developer Guide: OFS for Agilex™ 7 FPGA PCIe Attach FPGAs**

Last updated: **September 25, 2025** 

## **1. Introduction**


This document is a design guide for the creation of an Accelerator Functional Unit (AFU) using Open FPGA Stack (OFS) for Agilex™ 7 FPGAs PCIe Attach. The AFU concept consists of separating out the FPGA design development process into two parts, the construction of the foundational FPGA Interface Manager (FIM), and the development of the Acceleration Function Unit (AFU), as shown in the diagram below.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/FIM_top_intro.png)

This diagram shows the separation of FPGA board interface development from the internal FPGA workload creation.  This separation starts with the FPGA Interface Manager (FIM) which consists of the external interfaces and board management functions.  The FIM is the base system layer and is typically provided by board vendors. The FIM interface is specific to a particular physical platform.  The AFU makes use of the external interfaces with user defined logic to perform a specific application.  By separating out the lengthy and complicated process of developing and integrating external interfaces for an FPGA into a board allows the AFU developer to focus on the needs of their workload.  OFS for Agilex™ 7 FPGAs PCIe Attach provides the following tools for rapid AFU development:

- Scripts for both compilation and simulation setup
- Optional Platform Interface Manager (PIM) which is a set of SystemVerilog shims and scripts for flexible FIM to AFU interfacing
- Acceleration Simulation Environment (ASE) which is a hardware/software co-simulation environment scripts for compilation and Acceleration
- Integration with Open Programmable Acceleration Engine (OPAE) SDK for rapid software development for your AFU application
  

Please notice in the above block diagram that the AFU region consists of static and partial reconfiguration (PR) regions where the PR region can be dynamically reconfigured while the remaining FPGA design continues to function.  Creating AFU logic for the static region is described in Shell Developer Guide for the associated platform.  This guide covers logic in the AFU Main region.

### **1.1. Document Organization**


This document is organized as follows:

- Description of design flow
- Interfaces and functionality provided in the Agilex™ 7 FPGAs PCIe Attach FIM
- Setup of the AFU Development environment
- Synthesize the AFU example
- Testing the AFU example on the Intel® FPGA SmartNIC N6001-PL card
- Hardware/Software co-simulation using ASE
- Debugging an AFU with Remote Signal Tap

This guide provides theory followed by tutorial steps to solidify your AFU development knowledge.


> **_NOTE:_**  
>
>**This guide uses the Intel® FPGA SmartNIC N6001-PL as the platform for all tutorial steps. Additionally, this guide and the tutorial steps can be used with other platforms, such as the Agilex™ 7 FPGA F-Series Development Kit (2x F-Tile).**
>
>**Some of the document links in this guide are specific to the  Intel® FPGA SmartNIC N6001-PL.   If using a different platform, please use the associated documentation for your platform as there could be differences in building the FIM and downloading FIM images.**  
>

If you have worked with previous Altera® Programmable Acceleration products, you will find out that OFS for Agilex™ 7 FPGAs PCIe Attach is similar. However, there are differences and you are advised to carefully read and follow the tutorial steps to fully understand the design tools and flow.


### **1.2. Prerequisite**


This guide assumes you have the following FPGA logic design-related knowledge and skills:

* FPGA compilation flows including the Quartus® Prime Pro Edition design flow
* Static Timing closure, including familiarity with the Timing Analyzer tool in Quartus® Prime Pro Edition software, applying timing constraints, Synopsys* Design Constraints (.sdc) language and Tcl scripting, and design methods to close on timing critical paths.
* RTL and coding practices to create synthesizable logic.
* Understanding of AXI and Avalon memory mapped and streaming interfaces.
* Simulation of complex RTL using industry standard simulators (Synopsys® VCS® or Siemens® QuestaSim®).
* Signal Tap Logic Analyzer tool in the Quartus® Prime Pro Edition software.

You are strongly encouraged to review the Shell Developer Guide for the associated platform.

### **1.3. Acceleration Functional Unit (AFU) Development Flow**


The AFU development flow is shown below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/AFU_Dev_Flow.png)

#### **1.3.1. Understanding Platform Capabilities**


The block diagram of the N6001 Board is shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/N6000_Block.png)

The N6001 FIM provided with this release is shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/N6000_Base_x16_BlockDia.png)

This release FIM provides the following features:

- Host interface
  - PCIe Gen4 x 16
  - 5 - PF, 4 - VF, AXI-S TLP packets
  - MSI-X interrupts
  - Logic to demonstrate simple PCIe loopback
- Network interface
  - 2 - QSFP28/56 cages
  - 2 x 4 x 25 GbE with exerciser logic demonstrating traffic generation/monitoring
- External Memory - DDR4 - 2400
  - HPS - 1GB organized as 256 Mb x 32 with 256 Mb x 8 ECC
  - Channel 0, 1  -  4 GB organized as 1 Gb x 32
  - Channel 2, 3 - 4 GB organized as 1 Gb x 32 with 1 Gb x 8 ECC (ECC is not implemented in this release)
  - Memory exerciser logic demonstrating external memory operation
- Board Management
  - SPI interface
  - FPGA configuration
  - Example logic showing DFH operation
- Remote Signal Tap logic
- Partial reconfiguration control logic
- ARM HPS subsystem with embedded Linux
  - HPS Copy engine

#### **1.3.2. High Level Data Flow**


The OFS high level data flow is shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/OFS_DataFlow.png)

#### **1.3.3. Considerations for PIM Usage**


When creating an AFU, a designer needs to decide what type of interfaces the platform (FIM) should provide to the AFU.  The FIM can provide the native interfaces (i.e. PCIe TLP commands) or standard memory mapped interfaces (i.e. AXI-MM or AVMM) by using the PIM.  The PIM is an abstraction layer consisting of a collection of SystemVerilog interfaces and shims to enable partial AFU portability across hardware despite variations in hardware topology and native interfaces. The PIM adds a level of logic between the AFU and the FIM converting the native interfaces from the FIM to match the interfaces provided by the AFU.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/pim_based_afu.png)

The following resources are available to assist in creating an AFU:

[PIM Core Concepts](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md) provides details on using the PIM and its capabilities. 

[PIM Based AFU Developer Guide](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/ug_dev_pim_based_afu/) provides details on interfacing your AFU to the FIM using the PIM. 

[Multi-PCIe Link AFUs](https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/04_multi_link) provides details on encapsulation of multiple FPGA device connections as a single OPAE handle. 

[VChan Muxed AFUs]( https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/05_pim_vchan) provides details on manually adding the PF/VF mux after PIM shim to optimize resource usage when interfacing multiple AFU's. 

The [examples-afu](https://github.com/OFS/examples-afu.git) repo provides several AFU examples: 

| Example           |  Description            | PIM-based   | Hybrid    | Native   | Multi-Link    | VChan Mux   |
| ----              |  ----                   | ----        | ----      | ----     | ----          | ----        |  
| clocks            | Example AFU using user configurable clocks.        | X |   |   |   |   |
| copy_engine       | Example AFU moving data between host channel and a data engine. | X |   |   |   |   |
| dma               | Example AFU moving data between host channel and local memory with a DMA.      | X |   |   |   |   |
| hello_world       | Example AFU sending "Hello World!" to host channel.    | X | X | X | X | X |
| local_memory      | Example AFU reading and writing local memory.          | X | X |   |   |   |

These examples can be run with the current OFS FIM package.  There are three [AFU types](https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types) of examples provided (PIM based, hybrid and native).  Each example provides the following:

* RTL, which includes the following interfaces: 
   * [Host Channel](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md): 
     * Host memory, providing a DMA interface.
     * MMIO, providing a CSR interface.  
   * [Local Memory](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md)
* Host software example interfacing to the CSR interface and host memory interface, using the [OPAE C API](https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/prog_guide/readme/#opae-c-api-programming-guide).
* Accelerator Description File .json file
* Source file list

#### **1.3.4. AFU Interfaces Included with Intel® FPGA SmartNIC N6001-PL**


The figure below shows the interfaces available to the AFU in this architecture. It also shows the design hierarchy with module names from the fim (top.sv) to the PR region AFU (afu_main.sv).
One of the main differences from the Stratix 10 PAC OFS architecture to this one is the presence of the static port gasket region (port_gasket.sv) that has components to facilitate the AFU and also consists of the PR region (afu_main.sv) via the PR slot. The Port Gasket contains all the PR specific modules and logic, e.g., PR slot reset/freeze control, user clock, remote STP etc. Architecturally, a Port Gasket can have multiple PR slots where user workload can be programmed into. However, only one PR slot is supported for OFS Release for Agilex™. Everything in the Port Gasket until the PR slot should be provided by the FIM developer. The task of the AFU developer is to add their desired application in the afu_main.sv module by stripping out unwanted logic and instantiating the target accelerator.
As shown in the figure below, here are the interfaces connected to the AFU (highlighted in green) via the PCIe Attach FIM:

1. AXI Streaming (AXI-S) interface to the Host via PCIe Gen4x16
2. AXI Memory Mapped Channels (4) to the DDR4 EMIF interface
3. AXI Streaming (AXI-S) interface to the HSSI 25 Gb Ethernet

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/N6000_AFU_IF.png)

## **2. Set Up AFU Development Environment**


This section covers the setup of the AFU development environment.


### **2.1. AFU development environment overview**


A typical development and hardware test environment consists of a development server or workstation with FPGA development tools installed and a separate server with the target OFS compatible FPGA PCIe card installed.  The typical usage and flow of data between these two servers is shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/AFU_Dev_Deploy.png)

Note: both development and hardware testing can be performed on the same server if desired.

This guide uses Intel® FPGA SmartNIC N6001-PL as the target OFS compatible FPGA PCIe card for demonstration steps.  The Intel® FPGA SmartNIC N6001-PL must be fully installed following the [Board Installation Guide: OFS for Agilex™ 7 PCIe Attach Development Kits](https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/devkit_board_installation/devkit_board_installation_guidelines). If using a different OFS FPGA PCIe card, contact your supplier for instructions on how to install and operate user developed AFUs.

The following is a summary of the steps to set up for AFU development:

1. Install Quartus Prime Pro Version 25.1 for Linux with Agilex device support and required Quartus patches.
2. Make sure support tools are installed and meet version requirements.
3. Install OPAE SDK.
4. Download the Basic Building Blocks repository.
5. Build or download the relocatable AFU PR-able build tree based on your Agilex™ FPGA PCIe Attach FIM.
6. Download FIM to the Agilex™ FPGA PCIe Attach platform.

Building AFUs with OFS for Agilex™ requires the build machine to have at least 64 GB of RAM. 


### **2.2. Installation of Quartus and required patches**




### **2.3. Installation of Support Tools**


Make sure support tools are installed and meet version requirements.

The OFS provided Quartus build scripts require the following tools. Verify these are installed in your development environment.


| Item              |  Version            |
| ----              |  ----               |
| Python            | 3.8.10        |
| GCC               | 11.5.0         |
| cmake             | 3.26.5      |
| git               | 2.43.0     |
| perl              | 5.32.1                |


### **2.4. Installation of OPAE SDK**


Working with the Intel® FPGA SmartNIC N6001-PL card requires **opae-2.14.0-3**. Follow the instructions in the Follow the instructions in the [Software Installation Guide: OFS for PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach) to build and install the required OPAE SDK for the Intel® FPGA SmartNIC N6001-PL. Make sure to check out the cloned repository to tag **2.14.0-3** and branch **release/2.14.0**.

```sh
$ git checkout tags/2.14.0-3 -b release/2.14.0
```

> Note: The tutorial steps provided in the next sections assume the OPAE SDK is installed in default system locations, under the directory, ```/usr```. In most system configurations, this will allow the OS and tools to automatically locate the OPAE binaries, scripts, libraries and include files required for the compilation and simulation of the FIM and AFUs.


### **2.5. Download the Basic Building Blocks repositories**


The ```ofs-platform-afu-bbb``` repository contains the PIM files as well as example PIM-based AFUs that can be used for testing and demonstration purposes. This guide will use the ```host_chan_mmio``` AFU example in the [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) repository and the ```hello_world``` sample accompanying the [examples-afu](https://github.com/OFS/examples-afu.git) repository to demonstrate how to synthesize, load, simulate, and test a PIM-based AFU using the Intel® FPGA SmartNIC N6001-PL card with the PCIe Attach FIM.

Execute the next commands to clone the BBB repository.

```sh
  # Create top level directory for AFU development
$ mkdir OFS_BUILD_ROOT
$ cd OFS_BUILD_ROOT
$ export OFS_BUILD_ROOT=$PWD
  
  # Clone the ofs-platform-afu-bbb repository.
$ cd $OFS_BUILD_ROOT
$ git clone https://github.com/OFS/ofs-platform-afu-bbb.git
$ cd ofs-platform-afu-bbb
$ git checkout tags/ofs-2025.1-1
$ export OFS_PLATFORM_AFU_BBB=$PWD
  
  # Verify retrieval
$ ls
LICENSE  plat_if_develop  plat_if_release  plat_if_tests  README.md

```

The documentation in the [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) repository further addresses
  - The PIM concept.
  - The structure of the PIM-based AFU examples.
  - How to generate a release and configure the PIM.
  - How to connect an AFU to an FIM.


### **2.6. Build or download the relocatable PR build tree**


A relocatable PR build tree is needed to build the AFU partial reconfiguration area for the intended FIM. The tree is relocatable and may be copied to a new location. It does not depend on files in the original FIM build.

You can use the  Intel® FPGA SmartNIC N6001-PL release package and download the PR build tree and FIM images, to develop your AFU.  These are located at [OFS-N6001 release](https://github.com/OFS/ofs-n6001/releases)  

Or you can build your own FIM and generate the PR build tree during the process.

To download and untar the pr_build_template:

```sh
$ cd $OFS_BUILD_ROOT
$ wget https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2025.1-1/n6001-images_ofs-2025-1-1.tar.gz
$ tar -zxvf n6001-images_ofs-2025-1-1.tar.gz
$ cd n6001-images_ofs-2025-1-1/
$ cd pr_build_template
$ export OPAE_PLATFORM_ROOT=$PWD

```

To build your own FIM and generate the PR build tree for the Intel® FPGA SmartNIC N6001-PL platform, refer to the [Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (P-tile, E-tile) FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/) and follow the Out-of-Tree PR FIM build flow.  If you are using a different platform, refer to the Shell Developer Guide for your  platform and follow the Out-of-Tree PR FIM build flow.

### **2.7. Download FIM to FPGA**


The AFU requires that the FIM from which the AFU is derived be loaded onto the FPGA.   

If you are using the Intel® FPGA SmartNIC N6001-PL release package downloaded in the previous section:
```sh
$ cd $OFS_BUILD_ROOT/n6001-images_ofs-${{ env.COMMON_OFS_RELEASE_TAR }}/

```

If you are generating your own FIM, use the unsigned FPGA binary images from your FIM build. 

Downlaod the FIM to the Intel® FPGA SmartNIC N6001-PL platform. If you are running on a Virtual Machine, refer to the [KVM User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_kvm/ug_kvm/) for passing the devices to the VM.
```sh
$ sudo fpgasupdate ofs_top_page1_unsigned_user1.bin <N6001 SKU2 PCIe b:d.f>
$ sudo fpgasupdate ofs_top_page2_unsigned_user2.bin <N6001 SKU2 PCIe b:d.f>
$ sudo rsu fpga --page=user1 <N6001 SKU2 PCIe b:d.f>

```

If you are using a different platform, refer to the documentation for your platform to download the FIM images onto your Agilex™ PCIe Attach Platform.

### **2.8. Set up required Environment Variables**


Set the required environment variables as shown below. These environment variables must be set prior to simulation or compilation tasks. You can create a simple script to set these variables and save time going forward.

```sh
# If not already done, export OFS_BUILD_ROOT to the top level directory for AFU development
$ export OFS_BUILD_ROOT=<path to ofs build directory>

# If not already done, export OPAE_PLATFORM_ROOT to the PR build tree directory
$ export OPAE_PLATFORM_ROOT=<path to pr build tree>

# If not already done, export OFS_PLATFORM_AFU_BBB to the clone of ofs-platform-afu-bbb repository which contains PIM files and AFU examples.
$ export OFS_PLATFORM_AFU_BBB=<path to ofs-platform-afu-bbb>
 
# Quartus Tools
# Note, QUARTUS_HOME is your Quartus installation directory, e.g. $QUARTUS_HOME/bin contains Quartus executable.
$ export QUARTUS_HOME=<user_path>/intelFPGA_pro/25.1/quartus
$ export QUARTUS_ROOTDIR=$QUARTUS_HOME
$ export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
$ export QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR
$ export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export QSYS_ROOTDIR=$QUARTUS_ROOTDIR/../qsys
$ export PATH=$QUARTUS_HOME/bin:$QSYS_ROOTDIR/bin:$QUARTUS_HOME/../sopc_builder/bin/:$PATH

# OPAE SDK release
$ export OPAE_SDK_REPO_BRANCH=release/2.14.0

# OPAE and MPF libraries must either be on the default linker search paths or on both LIBRARY_PATH and LD_LIBRARY_PATH.  
$ export OPAE_LOC=/usr
$ export LIBRARY_PATH=$OPAE_LOC/lib:$LIBRARY_PATH
$ export LD_LIBRARY_PATH=$OPAE_LOC/lib64:$LD_LIBRARY_PATH

```

## **3. Compiling an AFU**

In this section, you will use the relocatable PR build tree created in the previous steps from the FIM to compile an example PIM-based AFU. This section will be developed around the ```host_chan_mmio``` and ```hello_world``` AFU examples to showcase the synthesis of a PIM-based AFU.

The build steps presented below demonstrate the ease in building and running an actual AFU on the board. To successfully execute the instructions in this section, you must have set up your development environment and have a relocateable PR Build tree as instructed in section 2 of this document.


### **3.1. Creating the AFU Synthesis Environment**

The PIM flow provides the script ```afu_synth_setup``` to create the synthesis environment to build the AFU examples. See how to use it below.

```
usage: afu_synth_setup [-h] -s SOURCES [-p PLATFORM] [-l LIB] [-f] dst

Generate a Quartus build environment for an AFU. A build environment is
instantiated from a release and then configured for the specified AFU. AFU
source files are specified in a text file that is parsed by rtl_src_config,
which is part of the OPAE base environment.

positional arguments:
  dst                   Target directory path (directory must not exist).

optional arguments:
  -h, --help            show this help message and exit
  -s SOURCES, --sources SOURCES
                        AFU source specification file that will be passed to
                        rtl_src_config. See "rtl_src_config --help" for the
                        file's syntax. rtl_src_config translates the source
                        list into either Quartus or RTL simulator syntax.
  -p PLATFORM, --platform PLATFORM
                        FPGA platform name.
  -l LIB, --lib LIB     FPGA platform release hw/lib directory. If not
                        specified, the environment variables OPAE_FPGA_HW_LIB
                        and then BBS_LIB_PATH are checked.
  -f, --force           Overwrite target directory if it exists.
```


### **3.2. Building and Running host_chan_mmio example AFU**

The ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio``` is a simple example demonstrating both hardware and software access to an AFU. The ```host_chan_mmio``` example AFU consists of the following files.  The hw directory contains the RTL to implement the hardware functionality using Avalon and AXI interfaces. However, this guide will use the AXI version of the ```host_chan_mmio``` AFU to go through the compilation steps. The sw directory of the AFU contains the source code of the host application that communicates with the actual AFU hardware.

```sh
host_chan_mmio
├── hw
│   └── rtl
│       ├── avalon
│       │   ├── afu_avalon512.sv
│       │   ├── afu_avalon.sv
│       │   ├── ofs_plat_afu_avalon512.sv
│       │   ├── ofs_plat_afu_avalon_from_ccip.sv
│       │   └── ofs_plat_afu_avalon.sv
│       ├── axi
│       │   ├── afu_axi512.sv
│       │   ├── afu_axi.sv
│       │   ├── ofs_plat_afu_axi512.sv
│       │   ├── ofs_plat_afu_axi_from_ccip.sv
│       │   └── ofs_plat_afu_axi.sv
│       ├── host_chan_mmio.json
│       ├── test_mmio_avalon0_from_ccip.txt
│       ├── test_mmio_avalon1.txt
│       ├── test_mmio_avalon2_512rw.txt
│       ├── test_mmio_axi0_from_ccip.txt
│       ├── test_mmio_axi1.txt
│       └── test_mmio_axi2_512rw.txt
└── sw
    ├── main.c
    ├── Makefile
```

#### **3.2.1. Build the host_chan_mmio example AFU**

Execute ```afu_synth_setup``` as follows to create the synthesis environment for a ```host_chan_mmio``` AFU that fits the PCIe Attach FIM previously constructed.

```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio
$ afu_synth_setup -s ./hw/rtl/test_mmio_axi1.txt afu_dev
```
Now, move into the synthesis environment ```afu_dev``` directory just created. From there, execute the ```afu_synth``` command. The successful completion of the command will produce the ```host_chan_mmio.gbs``` file under the synthesis environment directory, ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev```.

```sh
$ cd afu_dev
$ $OPAE_PLATFORM_ROOT/bin/afu_synth
Compiling ofs_top ofs_pr_afu
Generating host_chan_mmio.gbs
==================================
...
...
===========================================================================
 PR AFU compilation complete
 AFU gbs file is 'host_chan_mmio.gbs'
 Design meets timing
===========================================================================
```

The previous output indicates the successful compilation of the AFU and the compliance with the timing requirements. Analyze the reports generated in case the design does not meet timing. The timing reports are stored in the directory, ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev/build/syn/board/n6001/syn_top/output_files/timing_report```.

Once the compilation finishes successfully, load the new ```host_chan_mmio.gbs``` bitstream file into the partial reconfiguration region of the target Intel® FPGA SmartNIC N6001-PL board. Keep in mind, that the loaded image is dynamic - this image is not stored in flash and if the card is power cycled, then the PR region is re-loaded with the default AFU.

#### **3.2.2. Download the host_chan_mmio example AFU**

To test the AFU in actual hardware, load the ```host_chan_mmio.gbs``` to the Intel® FPGA SmartNIC N6001-PL card. For this step to be successful, the PCIe Attach FIM must have already been loaded to the Intel® FPGA SmartNIC N6001-PL card following the steps described in Section 2 of this document.
If you are running on a Virtual Machine, refer to the [KVM User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_kvm/ug_kvm/) for passing the devices to the VM.

Verify Board and PCIe b.d.f. For the following example, the N6001 SKU2 PCIe b:d.f is B1:00.0, however this may be different in your system.
```sh
$ fpgainfo fme
Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.0
Board Management Controller Build version: 3.15.0
//****** FME ******//
Interface                        : DFL
Object Id                        : 0xEF00000
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
...
```

Download AFU.
```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev
$ sudo fpgasupdate host_chan_mmio.gbs B1:00.0
[sudo] password for <<Your username>>: 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

#### **3.2.3. Set up host to interface with example AFU**

Set up host to interface with the newly loaded AFU.

List the PFs available, the default N6001 FIM has 5 PFs.
```sh
$ lspci -s B1:00
B1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.3 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.4 Processing accelerators: Intel Corporation Device bcce (rev 01)
```

Create the Virtual Functions (VFs) provided by the FIM, the default N6001 FIM has 3 VFs.  If your FIM uses only PFs, skip this step.
```sh
$ sudo pci_device B1:00.0 vf 3

# Verify the VFs have been added (device id: bccf)
$ lspci -s B1:00
B1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.3 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.4 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.5 Processing accelerators: Intel Corporation Device bccf
B1:00.6 Processing accelerators: Intel Corporation Device bccf
B1:00.7 Processing accelerators: Intel Corporation Device bccf
```

Bind PFs and VFs to VFIO driver (except PF0/B1:00.0, which is the FME PF).  
```sh
# Enter your username.
$ sudo opae.io init -d 0000:b1:00.1 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 183
Assigning /dev/vfio/183 to ceg
Changing permissions for /dev/vfio/183 to rw-rw----
 
$ sudo opae.io init -d 0000:b1:00.2 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 184
Assigning /dev/vfio/184 to ceg
Changing permissions for /dev/vfio/184 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.3 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x1af4,0x1000) at 0000:b1:00.3 from virtio-pci
Binding (0x1af4,0x1000) at 0000:b1:00.3 to vfio-pci
iommu group for (0x1af4,0x1000) at 0000:b1:00.3 is 185
Assigning /dev/vfio/185 to ceg
Changing permissions for /dev/vfio/185 to rw-rw----
   
$ sudo opae.io init -d 0000:b1:00.4 <<Your username>>
[sudo] password for <<Your username>>: 
Unbinding (0x8086,0xbcce) at 0000:b1:00.4 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.4 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.4 is 186
Assigning /dev/vfio/186 to ceg
Changing permissions for /dev/vfio/186 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.5 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.5 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.5 is 315
Assigning /dev/vfio/315 to ceg
Changing permissions for /dev/vfio/315 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.6 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.6 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.6 is 316
Assigning /dev/vfio/316 to ceg
Changing permissions for /dev/vfio/316 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.7 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.7 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.7 is 317
Assigning /dev/vfio/317 to ceg
Changing permissions for /dev/vfio/317 to rw-rw----
```

Verify the new AFU is loaded.  The host_chan_mmio AFU GUID is "76d7ae9c-f66b-461f-816a-5428bcebdbc5".  
```sh
$ fpgainfo port
//****** PORT ******//
Object Id                        : 0xEC00001
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
Accelerator GUID                 : d15ab1ed-0000-0000-0210-000000000000
//****** PORT ******//
Object Id                        : 0xC0B1000000000000
PCIe s:b:d.f                     : 0000:B1:00.6
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : d15ab1ed-0000-0000-0110-000000000000
//****** PORT ******//
Object Id                        : 0xA0B1000000000000
PCIe s:b:d.f                     : 0000:B1:00.5
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 76d7ae9c-f66b-461f-816a-5428bcebdbc5
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
Object Id                        : 0x6098000000000000
PCIe s:b:d.f                     : 0000:B1:00.3
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 1aae155c-acc5-4210-b9ab-efbd90b970c4
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

#### **3.2.4. Run the host_chan_mmio example AFU**

 Now, navigate to the directory of the ```host_chan_mmio``` AFU containing the host application's source code, ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/sw```. Once there, compile the ```host_chan_mmio``` host application and execute it on the host server to excercise the functionality of the AFU.

> Note: If OPAE SDK libraries were not installed in the default systems directories under ```/usr```, you need to set the ```OPAE_LOC```, ```LIBRARY_PATH```, and ```LD_LIBRARY_PATH``` environment variables to the custom locations where the OPAE SDK libraries were installed.

```sh
# Move to the sw directory of the the host_chan_mmio AFU. This directory holds the source for the host application.
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/sw
$ export OPAE_LOC=/usr
$ export LIBRARY_PATH=$OPAE_LOC/lib:$LIBRARY_PATH
$ export LD_LIBRARY_PATH=$OPAE_LOC/lib64:$LD_LIBRARY_PATH
$ make

# Run the application
$  ./host_chan_mmio
AFU ID:  76d7ae9cf66b461f 816a5428bcebdbc5
AFU MMIO interface: AXI Lite
AFU MMIO read bus width: 64 bits
512 bit MMIO write supported: yes
AFU pClk frequency: 470 MHz

Testing 32 bit MMIO reads:
  PASS - 4 tests

Testing 32 bit MMIO writes:
  PASS - 5 tests

Testing 64 bit MMIO writes:
  PASS - 5 tests

Testing 512 bit MMIO writes:
  PASS
```

### **3.3. Building and running the hello_world example AFU**


The platform-independent [examples-afu](https://github.com/OFS/examples-afu.git) repository also provides some interesting example AFUs. In this section, you will compile and execute the PIM based ```hello_world``` AFU. The RTL of the ```hello_world``` AFU receives from the host application an address via memory mapped I/O (MMIO) write and generates a DMA write to the memory line at that address. The content written to memory is the string "Hello world!". The host application spins, waiting for the memory line to be updated. Once available, the software prints out the string.

The ```hello_world``` example AFU consists of the following files. The **hw** directory contains the RTL to implement the hardware functionality using CCIP, Avalon, and AXI interfaces. However, this guide will use the AXI version of the AFU to go through the compilation steps. The **sw** directory of the AFU contains the source code of the host application that communicates with the AFU hardware.

```sh
hello_world
├── hw
│   └── rtl
│       ├── avalon
│       │   ├── hello_world_avalon.sv
│       │   ├── ofs_plat_afu.sv
│       │   └── sources.txt
│       ├── axi
│       │   ├── hello_world_axi.sv
│       │   ├── ofs_plat_afu.sv
│       │   └── sources.txt
│       ├── ccip
│       │   ├── hello_world_ccip.sv
│       │   ├── ofs_plat_afu.sv
│       │   └── sources.txt
│       └── hello_world.json
├── README.md
└── sw
    ├── hello_world
    ├── hello_world.c
    ├── Makefile
    └── obj
        ├── afu_json_info.h
        └── hello_world.o
```

The following instructions can be used to compile other AFU samples accompanying this repository.

If not done already, download and clone the [examples-afu](https://github.com/OFS/examples-afu.git) repository.
```sh
$ cd $OFS_BUILD_ROOT 
$ git clone https://github.com/OFS/examples-afu.git
$ cd examples-afu
$ git checkout tags/ofs-2025.1-1
```

#### **3.3.1. Build the hello_world example AFU**

Compile the ```hello_word``` sample AFU. 
```sh
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world
$ afu_synth_setup --source hw/rtl/axi/sources.txt afu_dev
$ cd afu_dev
$ $OPAE_PLATFORM_ROOT/bin/afu_synth
Compiling ofs_top ofs_pr_afu
Generating hello_world.gbs
==================================
.
.
.
===========================================================================
 PR AFU compilation complete
 AFU gbs file is 'hello_world.gbs'
 Design meets timing
===========================================================================

```

#### **3.3.2. Download the hello_world example AFU**

To test the AFU in actual hardware, load the ```hello_world.gbs``` to the Intel® FPGA SmartNIC N6001-PL card. For this step to be successful, the PCIe Attach FIM must have already been loaded to the Intel® FPGA SmartNIC N6001-PL card following the steps described in Section 2 of this document.
If you are running on a Virtual Machine, refer to the [KVM User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_kvm/ug_kvm/) for passing the devices to the VM.

Verify Board and PCIe b.d.f. For the following example, the N6001 SKU2 PCIe b:d.f is B1:00.0, however this may be different in your system.
```sh
$ fpgainfo fme
Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: 3.15.0
Board Management Controller Build version: 3.15.0
//****** FME ******//
Interface                        : DFL
Object Id                        : 0xEF00000
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
...
```

Download AFU.
```sh
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/afu_dev
$ sudo fpgasupdate hello_world.gbs B1:00.0
  [sudo] password for <<Your username>>: 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

#### **3.3.3. Set up host to interface with example AFU**

Set up your Intel® FPGA SmartNIC N6001-PL board to work with the newly loaded ```hello_world.gbs``` file. 
```sh
# List the PF's available, the default N6001 FIM has 5 PF's
$ lspci -s B1:00
B1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.3 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.4 Processing accelerators: Intel Corporation Device bcce (rev 01)
```

Download AFU.
```sh
# Create the Virtual Functions (VFs) provided by the FIM, the default N6001 FIM has 3 VFs.  
# If your FIM uses only PFs, skip this step.
$ sudo pci_device B1:00.0 vf 3

# Verify the VFs have been added (device id: bccf)
$ lspci -s B1:00
B1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.3 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.4 Processing accelerators: Intel Corporation Device bcce (rev 01)
B1:00.5 Processing accelerators: Intel Corporation Device bccf
B1:00.6 Processing accelerators: Intel Corporation Device bccf
B1:00.7 Processing accelerators: Intel Corporation Device bccf
```

Bind PFs and VFs to VFIO driver (except PF0/B1:00.0, which is the FME PF).  
```sh
#Enter your username
$ sudo opae.io init -d 0000:b1:00.1 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 183
Assigning /dev/vfio/183 to ceg
Changing permissions for /dev/vfio/183 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.2 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 184
Assigning /dev/vfio/184 to ceg
Changing permissions for /dev/vfio/184 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.3 <<Your username>>
[sudo] password for <<Your username>>:
Unbinding (0x8086,0xbcce)  at 0000:b1:00.3 from virtio-pci
Binding (0x8086,0xbcce)  at 0000:b1:00.3 to vfio-pci
iommu group for (0x8086,0xbcce)  at 0000:b1:00.3 is 185
Assigning /dev/vfio/185 to ceg
Changing permissions for /dev/vfio/185 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.4 <<Your username>>
[sudo] password for <<Your username>>: 
Unbinding (0x8086,0xbcce) at 0000:v1:00.4 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.4 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.4 is 186
Assigning /dev/vfio/186 to ceg
Changing permissions for /dev/vfio/186 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.5 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.5 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.5 is 315
Assigning /dev/vfio/315 to ceg
Changing permissions for /dev/vfio/315 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.6 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.6 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.6 is 316
Assigning /dev/vfio/316 to ceg
Changing permissions for /dev/vfio/316 to rw-rw----

$ sudo opae.io init -d 0000:b1:00.7 <<Your username>>
[sudo] password for <<Your username>>:
Binding (0x8086,0xbccf) at 0000:b1:00.7 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.7 is 317
Assigning /dev/vfio/317 to ceg
Changing permissions for /dev/vfio/317 to rw-rw----
```

Verify the new AFU is loaded.  The hello_world AFU GUID is "c6aa954a-9b91-4a37-abc1-1d9f0709dcc3".
```sh
$ fpgainfo port

//****** PORT ******//
Object Id                        : 0xEE00000
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x00
//****** PORT ******//
Object Id                        : 0xE098000000000000
PCIe s:b:d.f                     : 0000:B1:00.7
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : d15ab1ed-0000-0000-0210-000000000000
//****** PORT ******//
Object Id                        : 0xC098000000000000
PCIe s:b:d.f                     : 0000:B1:00.6
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : d15ab1ed-0000-0000-0110-000000000000
//****** PORT ******//
Object Id                        : 0xA098000000000000
PCIe s:b:d.f                     : 0000:B1:00.5
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : c6aa954a-9b91-4a37-abc1-1d9f0709dcc3
//****** PORT ******//
Object Id                        : 0x8098000000000000
PCIe s:b:d.f                     : 0000:B1:00.4
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 44bfc10d-b42a-44e5-bd42-57dc93ea7f91
//****** PORT ******//
Object Id                        : 0x6098000000000000
PCIe s:b:d.f                     : 0000:B1:00.3
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 1aae155c-acc5-4210-b9ab-efbd90b970c4
//****** PORT ******//
Object Id                        : 0x4098000000000000
PCIe s:b:d.f                     : 0000:B1:00.2
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 56e203e9-864f-49a7-b94b-12284c31e02b
//****** PORT ******//
Object Id                        : 0x2098000000000000
PCIe s:b:d.f                     : 0000:B1:00.1
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x1771
Socket Id                        : 0x01
Accelerator GUID                 : 3e7b60a0-df2d-4850-aa31-f54a3e403501

```
#### **3.3.4. Run the hello_world example AFU**

Compile and execute the host application of the ```hello_world``` AFU. You should see the application outputs the "Hello world!" message in the terminal.

```sh
# Move to the sw directory of the hello_world AFU
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/sw
  
$ make

# Launch the host application
$ ./hello_world
  Hello world!
```

### **3.4. Modify the AFU user clocks frequency**


An OPAE compliant AFU specifies the frequency of the ```uclk_usr``` and ``` uclk_usr_div2 ``` clocks through the JSON file for AFU configuration located under the ```<afu_example>/hw/rtl``` directory of an AFU design. For instance, the AFU configuration file of the ```host_chan_mmio``` example is ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/hw/rtl/host_chan_mmio.json```.

The AFU specifies the frequency for uClk_usr in its platform configuration file using the following key:value pairs:

      "clock-frequency-high": [<float-value>|”auto”|”auto-<float-value>”]
      "clock-frequency-low": [<float-value>|”auto”|”auto-<float-value>”]

These ```key:value``` tuples are used to configure the PLL of the target platform that provides the user clocks through the AFU clocks interface. In addition, the specified frequency affects the timing closure process on the user clocks during AFU compilation. 

Setting the value field to a float number (e.g., 315.0 to specify 315 MHz) drives the AFU generation process to close timing within the bounds set by the low and high values and sets the AFU's JSON metadata to specify the user clock PLL  frequency values.

The following example shows the JSON file of the ```host_chan_mmio``` to set the AFU uClk to 500 MHz and uClk_div2 to 250 MHz.

```
{
   "version": 1,
   "afu-image": {
      "power": 0,
      "clock-frequency-high": 500,
      "clock-frequency-low": 250,
      "afu-top-interface":
         {
            "class": "ofs_plat_afu"
         },
      "accelerator-clusters":
         [
            {
               "name": "host_chan_mmio",
               "total-contexts": 1,
               "accelerator-type-uuid": "76d7ae9c-f66b-461f-816a-5428bcebdbc5"
            }
         ]
   }
}

```

Save the changes to ```host_chan_mmio.json``` file, then execute the ```afu_synth_setup``` script to create a new copy of the AFU files with the modified user clock settigns.

```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio
$ afu_synth_setup -s ./hw/rtl/test_mmio_axi1.txt afu_clks

Copying build from /home/<user_area>/ofs-agx7-pcie-attach/work_pr/pr_build_template/hw/lib/build...
Configuring Quartus build directory: build_n6001_afu_clks/build
Loading platform database: /home/<user_area>/ofs-agx7-pcie-attach/work_pr/pr_build_template/hw/lib/platform/platform_db/ofs_agilex_adp.json
Loading platform-params database: /usr/share/opae/platform/platform_db/platform_defaults.json
Loading AFU database: /usr/share/opae/platform/afu_top_ifc_db/ofs_plat_afu.json
Writing platform/platform_afu_top_config.vh
Writing platform/platform_if_addenda.qsf
Writing ../hw/afu_json_info.vh

```
Compile the ```host_chan_mmio``` AFU with the new frequency values.

```sh
$ cd afu_clks
$ $OPAE_PLATFORM_ROOT/bin/afu_synth
```

During the compilation phase, you will observe the Timing Analyzer uses the specified user clock frequency values as the target to close timing.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/AFU_Dev_Flow.png)


![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/usrclk_timing.png)


AFU developers must ensure the AFU hardware design meets timing. The compilation of an AFU that fails timing shows a message similar to the following.

```sh
.
.
.

Wrote host_chan_mmio.gbs

===========================================================================
 PR AFU compilation complete
 AFU gbs file is 'host_chan_mmio.gbs'

  *** Design does not meet timing
  *** See build/syn/board/n6001/syn_top/output_files/timing_report

===========================================================================

```

The previous output indicates the location of the timing reports for the AFU designer to identify the failing paths and perform the necessary design changes. Next, is a listing of the timing report files from a ```host_chan_mmio``` AFU that fails to meet timing after modifying the user clock frequency values.

```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/n6001/afu_clks
$ ls build/syn/board/n6001/syn_top/output_files/timing_report

clocks.rpt  clocks.sta.fail.summary  clocks.sta.pass.summary
```

> **Warning:** AFU developers must inform software developers of the maximum operating frequency (Fmax) of the user clocks to avoid any unexpected behavior of the accelerator and potentially of the overall system.


## **4. Simulating an AFU using ASE**


The Application Simulation Environment (ASE) is a hardware/software co-simulation environment for your AFU. See diagram below illustrating ASE operation:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_HighLevel.png)

ASE uses the simulator Direct Programming Interface (DPI) to provide HW/SW connectivity.  The PCIe connection to the AFU under testing is emulated with a transactional model.

The following list describes ASE operation:

- Attempts to replicate the transactions that will be seen in real system.
- Provides a memory model to AFU, so illegal memory accesses can be identified early.
- Not a cache simulator.
- Does not guarantee synthesizability or timing closure.
- Does not model system latency.
- No administrator privileges are needed to run ASE.  All code is user level.

The remainder of this section is a tutorial providing the steps on how to run ASE with either Synopsys® VCS® or Siemens® QuestaSim® using an example AFU and the AFU build tree previously created in this guide.





### **4.1. Set Up Steps to Run ASE**


In this section you will set up your server to support ASE by independently downloading and installing OPAE SDK and ASE. Then, set up the required environment variables.





#### **4.1.1. Install OPAE SDK**

The N6001 SKU2 card requires **2.14.0-3**. Follow the instructions provided in the Follow the instructions in the [Software Installation Guide: OFS for PCIe Attach FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach) to build and install the required OPAE SDK for the Intel® FPGA SmartNIC N6001-PL. Make sure to check out the cloned repository to tag **2.14.0-3** and branch **release/2.14.0**.

```sh
$ git checkout tags/2.14.0-3 -b release/2.14.0
```

#### **4.1.2 Install ASE Tools**


ASE is an RTL simulator for OPAE-based AFUs. The simulator emulates both the OPAE SDK software user space API and the AFU RTL interface. The majority of the FIM as well as devices such as PCIe and local memory are emulated with simple functional models.

ASE must be installed separatedly from the OPAE SDK. However, the recommendation is to install it in the same target directory as OPAE SDK.

1. If not done already, set the environment variables as described in section, [Set Up AFU Development Environment](#2-set-up-afu-development-environment).

2. Clone the ```opae-sim``` repository.
```sh

$ cd $OFS_BUILD_ROOT
$ git clone https://github.com/OFS/opae-sim.git
$ cd opae-sim  
$ git checkout tags/2.14.0-1 -b release/2.14.0
```

3. Create a build directory and build ASE to be installed under the default system directories along with OPAE SDK.
```sh 
$ mkdir build
$ cd build
$ cmake  -DCMAKE_INSTALL_PREFIX=/usr ..
$ make
```

Optionally, if the desire is to install ASE binaries in a different location to the system's default, provide the path to CMAKE through the CMAKE_INSTALL_PREFIX switch, as follows.
```sh
$ cmake -DCMAKE_INSTALL_PREFIX=<</some/arbitrary/path>> ..  
```

4. Install ASE binaries and libraries under the system directory ```/usr```.
```sh
$ sudo make install  
```


#### **4.1.3. Setup Required ASE Environment Variables**

The values set to the following environment variables assume the OPAE SDK and ASE were installed in the default system directories below ```/usr```. Setup these variables in the shell where ASE will be executed. You may wish to add these variables to the script you created to facilitate configuring your environment.

```sh
$ export OPAE_PLATFORM_ROOT=<path to PR build tree>
$ cd /usr/bin
$ export PATH=$PWD:$PATH
$ cd /usr/lib/python*/site-packages
$ export PYTHONPATH=$PWD
$ cd /usr/lib
$ export LIBRARY_PATH=$PWD
$ cd /usr/lib64
$ export LD_LIBRARY_PATH=$PWD
$ cd $OFS_BUILD_ROOT/ofs-platform-afu-bbb
$ export OFS_PLATFORM_AFU_BBB=$PWD

  ## For VCS, set the following:

$ export VCS_HOME=<Set the path to VCS installation directory>
$ export PATH=$VCS_HOME/bin:$PATH
$ export VCS_TARGET_ARCH=linux64
$ export VMR_MODE_FLAG=64

  ## For QuestaSIM, set the following:
$ export MTI_HOME=<path to Modelsim installation directory>
$ export PATH=$MTI_HOME/linux_x86_64/:$MTI_HOME/bin/:$PATH
```


### **4.2. Simulating the host_chan_mmio AFU**


The ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio``` is a simple example demonstrating both hardware and software access to an AFU. The ```host_chan_mmio``` example AFU consists of the following files:

```sh
host_chan_mmio
├── hw
│   └── rtl
│       ├── avalon
│       │   ├── afu_avalon512.sv
│       │   ├── afu_avalon.sv
│       │   ├── ofs_plat_afu_avalon512.sv
│       │   ├── ofs_plat_afu_avalon_from_ccip.sv
│       │   └── ofs_plat_afu_avalon.sv
│       ├── axi
│       │   ├── afu_axi512.sv
│       │   ├── afu_axi.sv
│       │   ├── ofs_plat_afu_axi512.sv
│       │   ├── ofs_plat_afu_axi_from_ccip.sv
│       │   └── ofs_plat_afu_axi.sv
│       ├── host_chan_mmio.json
│       ├── test_mmio_avalon0_from_ccip.txt
│       ├── test_mmio_avalon1.txt
│       ├── test_mmio_avalon2_512rw.txt
│       ├── test_mmio_axi0_from_ccip.txt
│       ├── test_mmio_axi1.txt
│       └── test_mmio_axi2_512rw.txt
└── sw
    ├── main.c
    ├── Makefile
```

This example AFU contains examples using both Avalon and AXI interface buses. This guide will use the AXI version of the ```host_chan_mmio``` AFU.

ASE uses client-server application architecture to deliver hardware/software co-simulation.  You require one shell for the hardware based simulation and another shell where the software application is running. The hardware is started first with a simulation compilation and simulator startup script, once the simulator has loaded the design, it will wait until the software process starts. Once the software process starts, the simulator proceeds.  Transaction logging and waveform capture is performed.



#### **4.2.1 Set Up and Run the HW Simulation Process**


You will run the ```afu_sim_setup``` script to create the scripts for running the ASE environment.  The ```afu_sim_setup``` script has the following usage:

```sh
usage: afu_sim_setup [-h] -s SOURCES [-p PLATFORM] [-t {VCS,QUESTA,MODELSIM}]
                     [-f] [--ase-mode ASE_MODE] [--ase-verbose]
                     dst

Generate an ASE simulation environment for an AFU. An ASE environment is
instantiated from the OPAE installation and then configured for the specified
AFU. AFU source files are specified in a text file that is parsed by
rtl_src_config, which is also part of the OPAE base environment.

positional arguments:
  dst                   Target directory path (directory must not exist).

optional arguments:
  -h, --help            show this help message and exit
  -s SOURCES, --sources SOURCES
                        AFU source specification file that will be passed to
                        rtl_src_config. See "rtl_src_config --help" for the
                        file's syntax. rtl_src_config translates the source
                        list into either Quartus or RTL simulator syntax.
  -p PLATFORM, --platform PLATFORM
                        FPGA Platform to simulate.
  -t {VCS,QUESTA,MODELSIM}, --tool {VCS,QUESTA,MODELSIM}
                        Default simulator.
  -f, --force           Overwrite target directory if it exists.
  --ase-mode ASE_MODE   ASE execution mode (default, mode 3, exits on
                        completion). See ase.cfg in the target directory.
  --ase-verbose         When set, ASE prints each CCI-P transaction to the
                        command line. Transactions are always logged to
                        work/ccip_transactions.tsv, even when not set. This
                        switch sets ENABLE_CL_VIEW in ase.cfg.
```

Run ```afu_sim_setup``` to create the ASE simulation environment for the ```host_chan_mmio``` example AFU. The ```'-t VCS'``` option indicates to prepare the ASE simulation environment for Synopsys® VCS®.

```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio

$ afu_sim_setup -s ./hw/rtl/test_mmio_axi1.txt -t VCS afu_sim

Copying ASE from /opae-sdk/install-opae-sdk/share/opae/ase...
#################################################################
#                                                               #
#             OPAE Intel(R) Xeon(R) + FPGA Library              #
#               AFU Simulation Environment (ASE)                #
#                                                               #
#################################################################

Tool Brand: VCS
Loading platform database: /ofs-agx7-pcie-attach/work_pr/build_tree/hw/lib/platform/platform_db/ofs_agilex_adp.json
Loading platform-params database: /usr/share/opae/platform/platform_db/platform_defaults.json
Loading AFU database: /usr/share/opae/platform/afu_top_ifc_db/ofs_plat_afu.json
Writing rtl/platform_afu_top_config.vh
Writing rtl/platform_if_addenda.txt
Writing rtl/platform_if_includes.txt
Writing rtl/ase_platform_name.txt
Writing rtl/ase_platform_config.mk and rtl/ase_platform_config.cmake
ASE Platform: discrete (FPGA_PLATFORM_DISCRETE)
```

The ```afu_sim_setup``` creates the ASE scripts in the directory ```host_chan_mmio_sim``` where the ```afu_sim_setup``` script was run.  Start the simulator as shown below:

```sh
$ cd afu_sim
$ make
$ make sim
```

This process launches the AFU hardware simulator. Before moving to the next section, pay attention to the simulator output highlighted in the image below.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_HW.png)

The simulation artifacts are stored in host_chan_mmio/work and consist of:

```sh
log_ase_events.tsv
log_ofs_plat_host_chan.tsv 
log_ofs_plat_local_mem.tsv 
log_pf_vf_mux_A.tsv 
log_pf_vf_mux_B.tsv 
```


#### **4.2.2 Set Up and Run the SW Process**


Open an additional shell to build and run the host application that communicates with the actual AFU hardware. Set up the same environment variable you have set up in the shell you have been working on until this point. 

Additionally, as indicated by the hardware simulator output that is currently executing in the "simulator shell", copy and paste the line ```"export ASE_WORKDIR=..."```, into the new "software shell". See the last image of the previous section.

```sh
$ export ASE_WORKDIR=$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_sim/work
```
Then, go to the sw directory of the ```host_chan_mmio``` AFU example to compile the host application.

```sh   
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/sw  
$ make

afu_json_mgr json-info --afu-json=../hw/rtl/host_chan_mmio.json --c-hdr=obj/afu_json_info.h
Writing obj/afu_json_info.h
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c main.c -o obj/main.o
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c test_host_chan_mmio.c -o obj/test_host_chan_mmio.o
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c ../../common/sw/connect.c -o obj/connect.o
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c ../../common/sw/csr_mgr.c -o obj/csr_mgr.o
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c ../../common/sw/hash32.c -o obj/hash32.o
cc -g -O2 -std=gnu99 -fstack-protector -fPIE -fPIC -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -I../../common/sw -I./obj -c ../../common/sw/test_data.c -o obj/test_data.o
cc -o host_chan_mmio obj/main.o obj/test_host_chan_mmio.o obj/connect.o obj/csr_mgr.o obj/hash32.o obj/test_data.o  -z noexecstack -z relro -z now -pie -luuid -lopae-c-ase
```

Now, launch the host application to exercise the AFU hardware running on the simulator shell. The next image shows the AFU hardware simulation process on the left side shell. The right hand shell shows the host application's output of a successful simulation.

```sh
$ with_ase ./host_chan_mmio
  [APP]  Initializing simulation session ...
Running in ASE mode
AFU ID:  76d7ae9cf66b461f 816a5428bcebdbc5
AFU MMIO interface: AXI Lite
AFU MMIO read bus width: 64 bits
512 bit MMIO write supported: yes
AFU pClk frequency: 470 MHz

Testing 32 bit MMIO reads:
  PASS - 4 tests

Testing 32 bit MMIO writes:
  PASS - 5 tests

Testing 64 bit MMIO writes:
  PASS - 5 tests

Testing 512 bit MMIO writes:
  PASS
  [APP]  Deinitializing simulation session
  [APP]         Took 1,003,771,568 nsec
  [APP]  Session ended
```

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_Run.png)
<br/><br/>


Finally, on the hardware simulation shell, you can view the wave forms by invoking the following command.

```sh
$ make wave
```

This brings up the VCS® simulator GUI and loads the simulation waveform files. Use the Hierarchy window to navigate to the **afu** instance located under, ```ase_top | ase_top_plat | ase_afu_main_pcie_ss | ase_afu_main_emul | afu_main | port_afu_instances | ofs_plat_afu | afu``` , as shown below.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_VCS_hier_2023_2.png)

Right click on the ```afu (afu)``` entry to display the drop-down menu. Then, click on ```Add to Waves | New Wave View``` to display the following waveforms window.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_VCS_AFU_Waveforms_2023_2.png)

</br></br>

### **4.3 Simulating the hello_world AFU**
 

In this section you will quickly simulate the PIM-based ```hello_world``` sample AFU accompanying the examples-afu repository.

1. Set the environment variables as described in section [4.1. Set Up Steps to Run ASE](#41-set-up-steps-to-run-ase).

2. Prepare an RTL simulation environment for the AXI version of the ```hello_world``` AFU.
  
Simulation with ASE requires two software processes, one to simulate the AFU RTL and the other to run the host software that excercises the AFU. To construct an RTL simulation environment under the directory ```simulation```, execute the following.

```sh

$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world
$ afu_sim_setup -s ./hw/rtl/axi/sources.txt -t VCS afu_sim

  
Copying ASE from /usr/local/share/opae/ase...
#################################################################
#                                                               #
#             OPAE Intel(R) Xeon(R) + FPGA Library              #
#               AFU Simulation Environment (ASE)                #
#                                                               #
#################################################################

Tool Brand: VCS
Loading platform database: /home/<user_area>/ofs-agx7-pcie-attach/work_pr/pr_build_template/hw/lib/platform/platform_db/ofs_agilex_adp.json
Loading platform-params database: /usr/share/opae/platform/platform_db/platform_defaults.json
Loading AFU database: /usr/share/opae/platform/afu_top_ifc_db/ofs_plat_afu.json
Writing rtl/platform_afu_top_config.vh
Writing rtl/platform_if_addenda.txt
Writing rtl/platform_if_includes.txt
Writing rtl/ase_platform_name.txt
Writing rtl/ase_platform_config.mk and rtl/ase_platform_config.cmake
ASE Platform: discrete (FPGA_PLATFORM_DISCRETE)
```

The ```afu_sim_setup``` script constructs an ASE environment in the ```hello_world_sim``` subdirectory. If the command fails, confirm that the path to the afu_sim_setup is on your PATH environment variable (in the OPAE SDK bin directory) and that your Python version is at least 2.7.

3. Build and execute the AFU RTL simulator.

```sh 
$ cd afu_sim
$ make
$ make sim  
```

The previous commands will build and run the Synopsys® VCS® RTL simulator, which prints a message saying it is ready for simulation. The simulation process also prints a message instructing you to set the ASE_WORKDIR environment variable in a second shell.

4. Open a second shell where you will build and execute the host software. In this new "software shell", set up the environment variables you have set up so far in the "hardware simulation" shell.

5. Also, set the ASE_WORKDIR environment variable following the instructions given in the "hardware simulation" shell.

```sh
$ export ASE_WORKDIR=$OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/afu_sim/work
```
6. Then, move to the **sw** directory of the ```hello_world``` AFU sample to build the host software.

```sh      
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/sw
$ make      
```

7. Run the ```hello_world``` host application to resume the work of the RTL simulation. The host software process and the RTL simulation execute in lockstep. If successful, you should see the **Hello world!** output.

```sh      
$ with_ase ./hello_world

[APP]  Initializing simulation session ...
Hello world!
[APP]  Deinitializing simulation session
[APP]         Took 43,978,424 nsec
[APP]  Session ended
```

The image below shows the simulation of the AFU hardware and the execution of the host application side-by-side.

</br>

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_Run_hello_world.png)

</br>

8. Finally, on the hardware simulation shell, you can view the wave forms by invoking the following command.

```sh
make wave
```

This brings up the DVE GUI and loads the simulation waveform files. Use the Hierarchy window to navigate to the **afu** instance located under, ```ase_top | ase_top_plat | ase_afu_main_pcie_ss | ase_afu_main_emul | afu_main | port_afu_instances | ofs_plat_afu | hello_afu```, as shown below.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_VCS_hier_hello_world_2023_2.png)

Right click on the ```hello_afu``` entry to display the drop-down menu. Then, click on ```Add to Waves | New Wave View``` to display the following waveforms window.

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ASE_VCS_AFU_Hello_World_Waveforms_2023_2.png)

</br></br>




## **5. Adding Remote Signal Tap Logic Analyzer to debug the AFU**


The OPAE SDK provides a remote Signal Tap facility. It also supports the following in system debug tools included with the Quartus Prime Pro Edition:

- In-system Sources and Probes
- In-system Memory Content Editor
- Signal Probe
- System Console

This section is a short guide on adding remote Signal Tap instances to an AFU for in system debugging. You can follow the steps in the following sections, in order of execution to create an instrumented AFU. The ```host_chan_mmio``` AFU is used in this guide as the target AFU to be instrumented.

You need a basic understanding of Signal Tap. Please see the [Signal Tap Logic Analyzer: Introduction & Getting Started](https://www.intel.com/content/www/us/en/programmable/support/training/course/odsw1164.html) Web Based Training for more information.

You will run with a Signal Tap GUI running locally on the server with the Intel® FPGA SmartNIC N6001-PL as shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/RSTP_local.png)

### **5.1. Adding RSTP to the host_chan_mmio AFU**


RSTP is added to an AFU by:

1. Defining signals to be instrumented in Signal Tap.  This creates a new *.stp file.
2. Modify ofs_top.qpf to include the new *.stp file
3. Modify ofs_top.qsf
4. Modify ofs_pr_afu.qsf 
5. Run $OPAE_PLATFORM_ROOT/bin/afu_synth to build the PR-able image containing the RSTP instance

You can use these detailed steps to add Signal Tap to your AFU.

1. Set path to platform root directory and create the host_chan_mmio AFU Quartus project for adding Signal Tap.:
```sh
$ export OPAE_PLATFORM_ROOT=<path to PR build tree>

 # we will now build a new host_chahnel_mmio example based on Signal Tap

$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio
$ afu_synth_setup -s ./hw/rtl/test_mmio_axi1.txt afu_stp
```

2. Navigate to host_chan_mmio AFU Quartus project and open the project using Quartus GUI.
```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top
$ quartus ofs_top.qpf &
```

3. Once the project is loaded in Quartus, run Analysis & Synthesis ```Processing | Start | Start Analysis & Synthesis```. When complete, review the project hierarchy as shown in the Project Navigator.  This example will add Signal Tap probe points to the AFU region.  Reviewing the code will give insight into the function of this block.  You can bring up the code in the Project Navigator by expanding afu_top - port_gasket - pr_slot - afu_main - port_afu_instances - ofs_plat_afu, then select instance afu, right click, select Locacte Node - Locate in Design File as shown below.
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_proj_nav_2023_1.png)

4. Bring up Signal Tap to create the *.stp file.  In the Quartus GUI, go to Tools - Signal Tap Logic Analyzer.  In the New File from Template pop up, click `Create` to accept the default template.  The Signal Tap Logic Analyzer window comes up.

5. Set up the clock for the Signal Tap logic instance by clicking `...` button as shown below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_clock.png)

6. In the Hierarchy Level, navigate to top - afu_top - pg_afu.port_gasket - pr_slot - afu_main - port_afu_instances - ofs_plat_afu, then select instance afu.
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_clk_bringup_hier_nav_2024_2.png)

7. Enter ```*clk*``` in the ```Named:``` box and click ```Search```.  This brings up matching terms.  Click ```clk```.  Verify your Node Finder is as shown below and then click ```Ok```:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_set_up_clk_2024_3.png)

8. Double click the ```Double-click to add nodes``` as shown below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_double_click.png)

9. The Node Finder comes up.  Once again navigate to top - afu_top - port_gasket - pr_slot - afu_main - port_afu_instances - ofs_plat_afu, then select instance afu and click ```Ok```.  Enter ```mmio64_reg*``` and click ```Search```. Then selcet signals to add to the STP instance as shown below:

![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_sig_select_2024_3.png)

10. Then click ```Insert``` and ```Close```.
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_final_setup_2023_3.png)

11. Save the newly created STP by clicking ```File - Save As``` and in the save as navigate to $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top and save the STP file as ```host_chan_mmio.stp``` as shown below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_save_stp_2023_3.png)

  Select ```Yes``` when asked to add host_chan_mmio.stp to current project.  Close Signal Tap window.

12. Edit ```ofs_pr_afu.qsf``` to add host_chan_mmio.stp file and enable STP.  Open $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top/ofs_pr_afu.qsf in an editor and add the lines shown below:
```sh
set_global_assignment -name VERILOG_MACRO "INCLUDE_REMOTE_STP"
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE host_chan_mmio.stp
set_global_assignment -name SIGNALTAP_FILE host_chan_mmio.stp
```
  Save the ofs_pr_afu.qsf and close Quartus.

13. The host_chan_mmio AFU Quartus project is ready to be built.  In your original build shell enter the following commands:
```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp
$ $OPAE_PLATFORM_ROOT/bin/afu_synth

...
...
Wrote host_chan_mmio.gbs

===========================================================================
 PR AFU compilation complete
 AFU gbs file is 'host_chan_mmio.gbs'
  Design meets timing
===========================================================================
```

14. Once compilation completes, the new host_chan_mmio.gbs file that contains the Signal Tap instance can be loaded.
```sh
 # For the following example, the N6001 SKU2 PCIe b:d.f is assumed to be b1:00.0,
 # however this may be different in your system

# Enusre FIM is loading prior to loading AFU
# Load AFU
$ sudo fpgasupdate host_chan_mmio.gbs b1:00.0
[2021-12-04 07:16:59,101] [WARNING ] Update starting. Please do not interrupt.
[2021-12-04 07:16:59,740] [INFO    ] 
Partial Reconfiguration OK
```

15. Use the OPAE SDK mmlink tool to create a TCP/IP connection to your Agilex™ card under test.  The mmlink command has the following format:
```sh
Usage:
mmlink
<Segment>             --segment=<SEGMENT NUMBER>
<Bus>                 --bus=<BUS NUMBER>           OR  -B <BUS NUMBER>
<Device>              --device=<DEVICE NUMBER>     OR  -D <DEVICE NUMBER>
<Function>            --function=<FUNCTION NUMBER> OR  -F <FUNCTION NUMBER>
<Socket-id>           --socket-id=<SOCKET NUMBER>  OR  -S <SOCKET NUMBER>
<TCP PORT>            --port=<PORT>                OR  -P <PORT>
<IP ADDRESS>          --ip=<IP ADDRESS>            OR  -I <IP ADDRESS>
<Version>             -v,--version Print version and exit

```

  Enter the command below to create a connection using port 3333:
```sh
$ sudo mmlink -P 3333 -B 0xb1

 ------- Command line Input START ----

 Socket-id             : -1
 Port                  : 3333
 IP address            : 0.0.0.0
 ------- Command line Input END   ----

PORT Resource found.
Server socket is listening on port: 3333

```

  Leave this shell open with the mmlink connection.

16. In this step you will open a new shell and enable JTAG over protocol.  You must have Quartus 25.1 Programmer loaded on the N6001 server for local debugging.
```sh
$ jtagconfig --add JTAG-over-protocol sti://localhost:0/intel/remote-debug/127.0.0.1:3333/0

# Verify connectivity with jtagconfig --debug

$ jtagconfig --debug
1) JTAG-over-protocol [sti://localhost:0/intel/remote-debug/127.0.0.1:3333/0]
   (JTAG Server Version 21.4.0 Build 67 12/06/2021 SC Pro Edition)
    020D10DD   VTAP10 (IR=10)
    Design hash    86099113E08364C07CC4
    + Node 00406E00  Virtual JTAG #0

  Captured DR after reset = (020D10DD) [32]
  Captured IR after reset = (155) [10]
  Captured Bypass after reset = (0) [1]
  Captured Bypass chain = (0) [1]
```

17. Start Quartus Signal Tap GUI, connect to target, load stp file by navigating to $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top. The Quartus Signal Tap must be the same version of Quartus used to compile the host_chan_mmio.gbs. Quartus Prime Pro Version 25.1 is used in the steps below:
```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top
$ quartus_stpw host_chan_mmio.stp &
```

  This command brings up Signal Tap GUI. Connect to the Signal Tap over protocol by selecting the `Hardware` button on the right side of the GUI and click the "Please Select" pull down as shown below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ST_HW_Select.png)

  JTAG over protocol selected:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/ST_JTAG_Selected.png)

  This connection process will take approximately 2-3 minutes for the Signal Tap instance to indicate "Ready to acquire".

18. Set the trigger condition for a rising edge on signal `awvalid` signal.

19. In the Signal Tap window, enable acquisition by pressing key `F5`, the Signal Tap GUI will indicate "Acquisition in progress". Create and bind the VFs, then run the host_chan_mmio application following [3.2. Loading and Running host_chan_mmio example AFU](#32-loading-and-running-hostchanmmio-example-afu), and observe that the Signal Tap instance has triggered. You should see signals being captured in the Signaltap GUI.

  See captured image below:
![](/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/images/stp_data_2023_2.png)

  To end your Signal Tap session, close the Signal Tap GUI, then in the mmlink shell, enter `ctrl c` to kill the mmlink process.  
  To remove the JTAG over protocol connection:
```sh
# This is assuming the JTAG over protocol is instance '1', as shown during jtagconfig --debug
$ jtagconfig --remove 1
```

## **6. Disabling the FLR (Function Level Reset) during AFU Debugging**


The `vfio-pci` driver implementation will automatically issue an FLR (Function Level Reset) signal every time a new host application is executed. This signal is triggered whenever an application opens a `/dev/vfio*` file and is expected behavior for the `vfio` driver architecture.

You may also encounter issues while debugging an AFU when executing the OPAE SDK tool `opae.io` with `peek/poke` subcommands, which will automatically set register values if they are connected to a reset. The OPAE SDK function `fpgaReset()` will also not accept devices bound to the `vfio-pci` driver. Both of these behaviors can be worked around if they are not desired.

You can use the following steps to enable / disable FLR for a specific device bound to the `vfio-pci` driver. In this example we will use an OFS enabled PCIe device at BDF af:00.0, and will disable FLR on a VF at address af:00.5.

Disable FLR:

```bash
cd /sys/bus/pci/devices/0000:ae:00.0/0000:af:00.5
echo "" > reset_method
cat reset_method
```

Enable FLR:

```bash
cd /sys/bus/pci/devices/0000:ae:00.0/0000:af:00.5
echo "flr" > reset_method
cat reset_method
```

If you wish to manually reset your currently configured AFU without resetting the entire FIM, you can use the OPAE SDK function `fpgaEnumerate()`. This will issue a reset on the AFU's VFIO DEVICE_GROUP. To avoid issuing an FLR to the entire FIM, you need to call this function after disabling FLR as shown above.

If you wish to debug your AFU's register space without changing any of its register values using `opae.io`, you need to execute a `opae.io` compatible python script. An example application is shown below:

```bash
opae.io --version
opae.io 1.0.0

sudo opae.io init -d BDF $USER
opae.io script sample.py
Value@0x0     = 0x4000000010000000
Value@0x12060 = 100

```

`Sample.py` contents:

```python
import sys

def main():
    # Check opae.io initialization
    if the_region is None :
        print("\'opae.io\' initialization has not been performed, please bind the device in question to vfio-pci.")
        sys.exit(1)
    v = the_region.read64(0x0)
    print("Value@0x0     = 0x{:016X}".format(v))
    the_region.write32(0x12060,100)
    v = the_region.read32(0x12060)
    print("Value@0x12060 = {:d}".format(v))

####################################

if __name__ == "__main__":
    main()
```


## **7. How to modify the PF/VF MUX configuration**


For information on how to modify the PF/VF mapping for your own design, refer to the [Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (P-tile, E-tile) FPGAs](https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/).



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


[OFS-N6001 release]: https://github.com/OFS/ofs-n6001/releases

[FPGA Device Feature List (DFL) Framework Overview]: https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#fpga-device-feature-list-dfl-framework-overview
[ofs-platform-afu-bbb]: https://github.com/OFS/ofs-platform-afu-bbb
[intel-fpga-bbb]: https://github.com/OPAE/intel-fpga-bbb.git
[Connecting an AFU to a Platform using PIM]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md
[AFU Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial
[AFU types]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types
[Host Channel]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md
[Local Memory]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md
[OPAE C API]: https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/prog_guide/readme/#opae-c-api-programming-guide
[example AFUs]: https://github.com/OFS/examples-afu.git
[examples AFU]: https://github.com/OFS/examples-afu.git
[PIM Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial
[Non-PIM AFU Development]: https://github.com/OFS/examples-afu/tree/main/tutorial
[Intel FPGA IP Subsystem for PCI Express IP User Guide]: https://github.com/OFS/ofs.github.io/blob/main/docs/hw/common/user_guides/ug_qs_pcie_ss.pdf
[Memory Subsystem Intel FPGA IP User Guide]: https://www.intel.com/content/www/us/en/secure/content-details/686148/memory-subsystem-intel-fpga-ip-user-guide-for-intel-agilex-ofs.html?wapkw=686148&DocID=686148
[OPAE.io]: https://opae.github.io/latest/docs/fpga_tools/opae.io/opae.io.html
[OPAE GitHub]: https://github.com/OFS/opae-sdk

[Intel FPGA Download Cable II]: https://www.intel.com/content/www/us/en/products/sku/215664/intel-fpga-download-cable-ii/specifications.html

[Intel FPGA Download Cable Driver for Linux]: https://www.intel.com/content/www/us/en/support/programmable/support-resources/download/dri-usb-b-lnx.html 

[README_ofs_n6001_eval.txt]: https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.3-1

[FIM MMIO Regions]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/#6-mmio-regions


[evaluation script]: https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.3-1
[OFS]: https://github.com/OFS
[OFS GitHub page]: https://ofs.github.io
[DFL Wiki]: https://github.com/OPAE/linux-dfl/wiki
[release notes]: https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2025.1-1

[Setting Up Required Environment Variables]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#431-setting-up-required-environment-variables

[4.0 OPAE Software Development Kit]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit

[Signal Tap Logic Analyzer: Introduction & Getting Started]: https://www.intel.com/content/www/us/en/programmable/support/training/course/odsw1164.html
[Quartus Pro Prime Download]: https://www.intel.com/content/www/us/en/software-kit/839515/intel-quartus-prime-pro-edition-design-software-version-24-3-for-linux.html

[PCIe Subsystem Intel FPGA IP User Guide for Agilex™ OFS]: https://www.intel.com/content/www/us/en/secure/content-details/690604/pcie-subsystem-intel-fpga-ip-user-guide-for-intel-agilex-ofs.html?wapkw=690604&DocID=690604

[Memory Subsystem Intel FPGA IP User Guide for Agilex™ OFS]: https://www.intel.com/content/www/us/en/secure/content-details/686148/memory-subsystem-intel-fpga-ip-user-guide-for-intel-agilex-ofs.html?wapkw=686148&DocID=686148

[Ethernet Subsystem Intel FPGA IP User Guide]: https://www.intel.com/content/www/us/en/docs/programmable/773413/24-1-25-0-0/introduction.html

[Analyzing and Optimizing the Design Floorplan]: https://www.intel.com/content/www/us/en/docs/programmable/683641/21-4/analyzing-and-optimizing-the-design-03170.html 

[Partial Reconfiguration Design Flow - Step 3 - Floorplan the Design]: https://www.intel.com/content/www/us/en/docs/programmable/683834/21-4/step-3-floorplan-the-design.html

[Security User Guide: Intel Open FPGA Stack]: https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/

[Pin-Out Files for Altera FPGAs]: https://www.intel.com/content/www/us/en/support/programmable/support-resources/devices/lit-dp.html

[E-Tile Channel Placement Tool]: https://www.intel.com/content/www/us/en/content-details/652292/intel-e-tile-channel-placement-tool.html?wapkw=e-tile%20channel%20placement%20tool&DocID=652292

[Introduction]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1-introduction
[About This Document]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#11-about-this-document
[Knowledge Pre-Requisites]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#111-knowledge-pre-requisites
[FIM Development Theory]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#12-fim-development-theory
[Default FIM Features]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#121-default-fim-features
[Top Level]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1211-top-level
[Interfaces]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1212-interfaces
[Subsystems]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1213-subsystems
[Host Exercisers]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1214-host-exercisers
[Module Access via APF/BPF]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1215-module-access-via-apf-bpf
[Customization Options]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#122-customization-options
[Development Environment]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#13-development-environment
[Development Tools]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#131-development-tools
[Install Quartus Prime Pro Software]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1311-walkthrough-install-quartus-prime-pro-software
[Install Git Large File Storage Extension]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1312-walkthrough-install-git-large-file-storage-extension
[FIM Source Files]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#132-fim-source-files
[Clone FIM Repository]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1321-walkthrough-clone-fim-repository
[Environment Variables]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#133-environment-variables
[Set Development Environment Variables]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#1331-walkthrough-set-development-environment-variables
[Set Up Development Environment]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#134-walkthrough-set-up-development-environment
[FIM Compilation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2-fim-compilation
[Compilation Theory]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#21-compilation-theory
[FIM Build Script]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#211-fim-build-script
[OFSS File Usage]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#212-ofss-file-usage
[Platform OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2121-platform-ofss-file
[OFS IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2122-ofs-ip-ofss-file
[PCIe IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2123-pcie-ip-ofss-file
[IP OPLL IOFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2124-ip-opll-iofss-file
[Memory IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2125-memory-ip-ofss-file
[HSSI IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2126-hssi-ip-ofss-file
[OFS Build Script Outputs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#213-ofs-build-script-outputs
[Compilation Flows]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#22-compilation-flows
[Flat FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#221-flat-fim
[In-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#222-in-tree-pr-fim
[Out-of-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#223-out-of-tree-pr-fim
[HE_NULL FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#223-he_null-fim
[Compile OFS FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#225-walkthrough-compile-ofs-fim
[Manually Generate OFS Out-Of-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#226-walkthrough-manually-generate-ofs-out-of-tree-pr-fim
[Compilation Seed]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#227-compilation-seed
[Change the Compilation Seed]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#2271-walkthrough-change-the-compilation-seed
[FIM Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#3-fim-simulation
[Simulation File Generation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#31-simulation-file-generation
[Individual Unit Tests]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#32-individual-unit-tests
[Run Individual Unit Level Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#321-walkthrough-run-individual-unit-level-simulation
[Regression Unit Tests]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#33-regression-unit-tests
[Run Regression Unit Level Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#331-walkthrough-run-regression-unit-level-simulation
[FIM Customization]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#4-fim-customization
[Adding a new module to the FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#41-adding-a-new-module-to-the-fim
[Hello FIM Theory of Operation]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#411-hello-fim-theory-of-operation
[Hello FIM Board Peripheral Fabric (BPF)]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#4111-hello-fim-board-peripheral-fabric-bpf
[Hello FIM CSR]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#4112-hello-fim-csr
[Add a new module to the OFS FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#412-walkthrough-add-a-new-module-to-the-ofs-fim
[Modify and run unit tests for a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#413-walkthrough-modify-and-run-unit-tests-for-a-fim-that-has-a-new-module
[Modify and run UVM tests for a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#414-walkthrough-modify-and-run-uvm-tests-for-a-fim-that-has-a-new-module
[Hardware test a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#415-walkthrough-hardware-test-a-fim-that-has-a-new-module
[Debug the FIM with Signal Tap]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#416-walkthrough-debug-the-fim-with-signal-tap
[Preparing FIM for AFU Development]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#42-preparing-fim-for-afu-development
[Compile the FIM in preparation for designing your AFU]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#421-walkthrough-compile-the-fim-in-preparation-for-designing-your-afu
[Partial Reconfiguration Region]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#43-partial-reconfiguration-region
[Resize the Partial Reconfiguration Region]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#431-walkthrough-resize-the-partial-reconfiguration-region
[PCIe Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#44-pcie-configuration
[PF/VF MUX Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#441-pfvf-mux-configuration
[PCIe-SS Configuration Registers]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#442-pcie-ss-configuration-registers
[PCIe Configuration Using OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#443-pcie-configuration-using-ofss
[Modify the PCIe Sub-System and PF/VF MUX Configuration Using OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#4431-walkthrough-modify-the-pcie-sub-system-and-pfvf-mux-configuration-using-ofss
[PCIe Sub-System configuration Using IP Presets]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#444-pcie-sub-system-configuration-using-ip-presets
[Modify PCIe Sub-System and PF/VF MUX Configuration Using IP Presets]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#4441-walkthrough-modify-pcie-sub-system-and-pfvf-mux-configuration-using-ip-presets
[Minimal FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#45-minimal-fim
[Create a Minimal FIM]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#451-walkthrough-create-a-minimal-fim
[Migrate to a Different Agilex Device Number]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#46-migrate-to-a-different-agilex-device-number
[Migrate to a Different Agilex Device Number]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#461-walkthrough-migrate-to-a-different-agilex-device-number
[Modify the Memory Sub-System]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#47-modify-the-memory-sub-system
[Modify the Memory Sub-System Using IP Presets With OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#471-walkthrough-modify-the-memory-sub-system-using-ip-presets-with-ofss
[Add or remove the Memory Sub-System]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#472-walkthrough-add-or-remove-the-memory-sub-system
[Modify the Ethernet Sub-System]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#48-modify-the-ethernet-sub-system
[Modify the Ethernet Sub-System Channels With Pre-Made HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#481-walkthrough-modify-the-ethernet-sub-system-channels-with-pre-made-hssi-ofss
[Add Channels to the Ethernet Sub-System Channels With Custom HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#482-walkthrough-add-channels-to-the-ethernet-sub-system-channels-with-custom-hssi-ofss
[Modify the Ethernet Sub-System With Pre-Made HSSI OFSS Plus Additional Modifications]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#483-walkthrough-modify-the-ethernet-sub-system-with-pre-made-hssi-ofss-plus-additional-modifications
[Modify the Ethernet Sub-System Without HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#484-walkthrough-modify-the-ethernet-sub-system-without-hssi-ofss
[Modifying the HPS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#49-modifying-the-hps
[Remove the HPS]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#491-walkthrough-remove-the-hps
[FPGA Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#5-fpga-configuration
[Set up JTAG]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#51-walkthrough-set-up-jtag
[Program the FPGA via JTAG]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#52-walkthrough-program-the-fpga-via-jtag
[Remote System Update]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#53-remote-system-update
[Program the FPGA via RSU]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#531-walkthrough-program-the-fpga-via-rsu
[Appendix]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#appendix
[Appendix A: Resource Utilization Tables]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#appendix-a-resource-utilization-tables
[Appendix B: Glossary]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/#appendix-b-glossary


## Notices & Disclaimers

Altera® Corporation technologies may require enabled hardware, software or service activation. No product or component can be absolutely secure. Performance varies by use, configuration and other factors. Your costs and results may vary. You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Altera or Intel products described herein. You agree to grant Altera Corporation a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein. No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Altera or Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document. The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request. Altera disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade. You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. © Altera Corporation. Altera, the Altera logo, and other Altera marks are trademarks of Altera Corporation. Other names and brands may be claimed as the property of others.

OpenCL* and the OpenCL* logo are trademarks of Apple Inc. used by permission of the Khronos Group™.
