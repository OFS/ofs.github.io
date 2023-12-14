# **AFU Development Guide: OFS for Intel® Intel® Agilex® 7 FPGA PCIe Attach FPGAs**

Last updated: **December 14, 2023** 

## **1. Introduction**


This document is a design guide for the creation of an Accelerator Functional Unit (AFU) using Open FPGA Stack (OFS) for Intel® Agilex® 7 FPGAs PCIe Attach. The AFU concept consists of separating out the FPGA design development process into two parts, the construction of the foundational FPGA Interface Manager (FIM), and the development of the Acceleration Function Unit (AFU), as shown in the diagram below.

![](./images/FIM_top_intro.png)

This diagram shows the separation of FPGA board interface development from the internal FPGA workload creation.  This separation starts with the FPGA Interface Manager (FIM) which consists of the external interfaces and board management functions.  The FIM is the base system layer and is typically provided by board vendors. The FIM interface is specific to a particular physical platform.  The AFU makes use of the external interfaces with user defined logic to perform a specific application.  By separating out the lengthy and complicated process of developing and integrating external interfaces for an FPGA into a board allows the AFU developer to focus on the needs of their workload.  OFS for Intel® Agilex® 7 FPGAs PCIe Attach provides the following tools for rapid AFU development:

- Scripts for both compilation and simulation setup
- Optional Platform Interface Manager (PIM) which is a set of SystemVerilog shims and scripts for flexible FIM to AFU interfacing
- Acceleration Simulation Environment (ASE) which is a hardware/software co-simulation environment scripts for compilation and Acceleration
- Integration with Open Programmable Acceleration Engine (OPAE) SDK for rapid software development for your AFU application
  

Please notice in the above block diagram that the AFU region consists of static and partial reconfiguration (PR) regions where the PR region can be dynamically reconfigured while the remaining FPGA design continues to function.  Creating AFU logic for the static region is described in [FPGA Interface Manager Developer Guide for Intel® Agilex® 7 PCIe Attach](https://ofs.github.io/ofs-2023.3/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/).  This guide covers logic in the AFU Main region.

### **1.1. Document Organization**


This document is organized as follows:

- Description of design flow
- Interfaces and functionality provided in the Intel® Agilex® 7 FPGAs PCIe Attach FIM
- Setup of the AFU Development environment
- Synthesize the AFU example
- Testing the AFU example on the Intel® FPGA SmartNIC N6001-PL card
- Hardware/Software co-simulation using ASE
- Debugging an AFU with Remote Signal Tap

This guide provides theory followed by tutorial steps to solidify your AFU development knowledge.


> **_NOTE:_**  
>
>**This guide uses the Intel® FPGA SmartNIC N6001-PL as the platform for all tutorial steps. Additionally, this guide and the tutorial steps can be used with other platforms, such as the Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile).**
>
>**Some of the document links in this guide are specific to the  Intel® FPGA SmartNIC N6001-PL.   If using a different platform, please use the associated documentation for your platform as there could be differences in building the FIM and downloading FIM images.**  
>

If you have worked with previous Intel Programmable Acceleration products, you will find out that OFS for Intel® Agilex® 7 FPGAs PCIe Attach is similar. However, there are differences and you are advised to carefully read and follow the tutorial steps to fully understand the design tools and flow.


### **1.2. Prerequisite**


This guide assumes you have the following FPGA logic design-related knowledge and skills:

* FPGA compilation flows including the Intel® Quartus® Prime Pro Edition design flow
* Static Timing closure, including familiarity with the Timing Analyzer tool in Intel® Quartus® Prime Pro Edition software, applying timing constraints, Synopsys* Design Constraints (.sdc) language and Tcl scripting, and design methods to close on timing critical paths.
* RTL and coding practices to create synthesizable logic.
* Understanding of AXI and Avalon memory mapped and streaming interfaces.
* Simulation of complex RTL using industry standard simulators (Synopsys® VCS® or Siemens® QuestaSim®).
* Signal Tap Logic Analyzer tool in the Intel® Quartus® Prime Pro Edition software.

You are strongly encouraged to review the [FPGA Interface Manager Developer Guide for Intel® Agilex® 7 PCIe Attach](https://ofs.github.io/ofs-2023.3/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/).

### **1.3. Acceleration Functional Unit (AFU) Development Flow**


The AFU development flow is shown below:
![](./images/AFU_Dev_Flow.png)

#### **1.3.1. Understanding Platform Capabilities**


The block diagram of the N6001 Board is shown below:

![](./images/N6000_Block.png)

The N6001 FIM provided with this release is shown below:

![](./images/N6000_Base_x16_BlockDia.png)

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

![](./images/OFS_DataFlow.png)

#### **1.3.3. Considerations for PIM Usage**


When creating an AFU, a designer needs to decide what type of interfaces the platform (FIM) should provide to the AFU.  The FIM can provide the native interfaces (i.e. PCIe TLP commands) or standard memory mapped interfaces (i.e. AXI-MM or AVMM) by using the PIM.  The PIM is an abstraction layer consisting of a collection of SystemVerilog interfaces and shims to enable partial AFU portability across hardware despite variations in hardware topology and native interfaces. The PIM adds a level of logic between the AFU and the FIM converting the native interfaces from the FIM to match the interfaces provided by the AFU.

![](./images/pim_based_afu.png)

The following resources are available to assist in creating an AFU:

[PIM Core Concepts](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md) provides details on using the PIM and its capabilities. 

[Connecting an AFU to a Platform using PIM](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md) guides you through the steps needed to connect a PIM Based AFU to the FIM. 

The [AFU Tutorial](https://github.com/OFS/examples-afu/tree/main/tutorial) provides several AFU examples.  These examples can be run with the current OFS FIM package.  There are three [AFU types](https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types) of examples provided (PIM based, hybrid and native).  Each example provides the following:

* RTL, which includes the following interfaces: 
   * [Host Channel](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md): 
     * Host memory, providing a DMA interface.
     * MMIO, providing a CSR interface.  
   * [Local Memory](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md)
* Host software example interfacing to the CSR interface and host memory interface, using the [OPAE C API](https://ofs.github.io/ofs-2023.3/sw/fpga_api/prog_guide/readme/#opae-c-api-programming-guide).
* Accelerator Description File .json file
* Source file list

#### **1.3.4. AFU Interfaces Included with Intel® FPGA SmartNIC N6001-PL**


The figure below shows the interfaces available to the AFU in this architecture. It also shows the design hierarchy with module names from the fim (top.sv) to the PR region AFU (afu_main.sv).
One of the main differences from the Stratix 10 PAC OFS architecture to this one is the presence of the static port gasket region (port_gasket.sv) that has components to facilitate the AFU and also consists of the PR region (afu_main.sv) via the PR slot. The Port Gasket contains all the PR specific modules and logic, e.g., PR slot reset/freeze control, user clock, remote STP etc. Architecturally, a Port Gasket can have multiple PR slots where user workload can be programmed into. However, only one PR slot is supported for OFS Release for Intel Agilex. Everything in the Port Gasket until the PR slot should be provided by the FIM developer. The task of the AFU developer is to add their desired application in the afu_main.sv module by stripping out unwanted logic and instantiating the target accelerator.
As shown in the figure below, here are the interfaces connected to the AFU (highlighted in green) via the PCIe Attach FIM:

1. AXI Streaming (AXI-S) interface to the Host via PCIe Gen4x16
2. AXI Memory Mapped Channels (4) to the DDR4 EMIF interface
3. AXI Streaming (AXI-S) interface to the HSSI 25 Gb Ethernet

![](./images/N6000_AFU_IF.png)

## **2. Set Up AFU Development Environment**


This section covers the setup of the AFU development environment.


### **2.1. AFU development environment overview**


A typical development and hardware test environment consists of a development server or workstation with FPGA development tools installed and a separate server with the target OFS compatible FPGA PCIe card installed.  The typical usage and flow of data between these two servers is shown below:

![](./images/AFU_Dev_Deploy.png)

Note: both development and hardware testing can be performed on the same server if desired.

This guide uses Intel® FPGA SmartNIC N6001-PL as the target OFS compatible FPGA PCIe card for demonstration steps.  The Intel® FPGA SmartNIC N6001-PL must be fully installed following the [Getting Started User Guide: OFS for Intel® Agilex® 7 PCIe Attach FPGAs](https://ofs.github.io/ofs-2023.3/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/). If using a different OFS FPGA PCIe card, contact your supplier for instructions on how to install and operate user developed AFUs.

The following is a summary of the steps to set up for AFU development:

1. Install Quartus Prime Pro Version 23.3 for Linux with Agilex device support and required Quartus patches.
2. Make sure support tools are installed and meet version requirements.
3. Install OPAE SDK.
4. Download the Basic Building Blocks repository.
5. Build or download the relocatable AFU PR-able build tree based on your Intel® Agilex FPGA PCIe Attach FIM.
6. Download FIM to the Intel® Agilex FPGA PCIe Attach platform.

Building AFUs with OFS for Agilex requires the build machine to have at least 64 GB of RAM. 


### **2.2. Installation of Quartus and required patches**

**Intel Quartus Prime Pro Version 23.3** is verified to work with the latest OFS release ofs-2023.3-1.  However, you have the option to port and verify the release on newer versions of Intel Quartus Prime Pro software.

Use RedHatEnterprise Linux® (RHEL) 8.6 for compatibility with your development flow and also testing your FIM design in your platform. 

Prior to installing Quartus:

1. Ensure you have at least 64 GB of free space for Quartus Prime Pro installation and your development work.
  * Intel® recommends that your system be configured to provide virtual memory equal in size or larger than the recommended physical RAM size that is required to process your design.
  * The disk space may be significantly more based on the device families included in the install. Prior to installation, the disk space should be enough to hold both zipped tar files and uncompressed installation files. After successful installation, delete the downloaded zipped files and uncompressed zip files to release the disk space.

2. Perform the following steps to satisfy the required dependencies.

  ```bash
  $ sudo dnf install -y gcc gcc-c++ make cmake libuuid-devel rpm-build autoconf automake bison boost boost-devel libxml2 libxml2-devel make ncurses grub2 bc csh flex glibc-locale-source libnsl ncurses-compat-libs 
  ```

  Apply the following configurations.

  ```bash
  $ sudo localedef -f UTF-8 -i en_US en_US.UTF-8 
  $ sudo ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5 
  $ sudo ln -s /usr/bin/python3 /usr/bin/python
  ```

3. Create the default installation path: <home directory>/intelFPGA_pro/<version number>, where <home directory> is the default path of the Linux workstation, or as set by the system administrator and <version> is your Quartus version number.

  The installation path must satisfy the following requirements:

  * Contain only alphanumeric characters
  * No special characters or symbols, such as !$%@^&*<>,
  * Only English characters
  * No spaces

4. Download your required Quartus Prime Pro Linux version [here](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime/resource.html).

5. Install required Quartus patches. The Quartus patch `.run` files can be found in the **Assets** tab on the [OFS Release GitHub page](https://github.com/OFS/ofs-agx7-pcie-attach/ofs-2023.3). The patches for this release are 0.13 patch (Generic Serial Flash Interface IP), 0.21 patch (PCIe).

6. After running the Quartus Prime Pro installer, set the PATH environment variable to make utilities `quartus`, `jtagconfig`, and `quartus_pgm` discoverable. Edit your bashrc file `~/.bashrc` to add the following line:

  ```bash
  export PATH=<Quartus install directory>/quartus/bin:$PATH
  export PATH=<Quartus install directory>/qsys/bin:$PATH
  ```

  For example, if the Quartus install directory is /home/intelFPGA_pro/23.3 then the new line is:

  ```bash
  export PATH=/home/intelFPGA_pro/23.3/quartus/bin:$PATH
  export PATH=/home/intelFPGA_pro/23.3/qsys/bin:$PATH
  ```

7. Verify, Quartus is discoverable by opening a new shell:

  ```
  $ which quartus
  /home/intelFPGA_pro/23.3/quartus/bin/quartus
  ```




### **2.3. Installation of Support Tools**


Make sure support tools are installed and meet version requirements.

The OFS provided Quartus build scripts require the following tools. Verify these are installed in your development environment.


| Item              |  Version            |
| ----              |  ----               |
| Python            | 3.6.8        |
| GCC               | 7.4.0         |
| cmake             | 3.15      |
| git               | 1.8.3.1     |
| perl              | 5.8.8                |


### **2.4. Installation of OPAE SDK**


Follow the instructions in the Getting Started Guide: Open FPGA Stack for Intel® FPGA SmartNIC N6001-PL, section [4.0 OPAE Software Development Kit](https://ofs.github.io/ofs-2023.3/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit) to build and install the required OPAE SDK for the Intel® FPGA SmartNIC N6001-PL.

Working with the Intel® Intel® FPGA SmartNIC N6001-PL card requires **opae-2.10.0-1**. Follow the instructions in the Getting Started Guide: Intel® Open FPGA Stack for Intel® FPGA SmartNIC N6001-PL section [4.0 OPAE Software Development Kit](https://ofs.github.io/ofs-2023.3/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit). Make sure to check out the cloned repository to tag **2.10.0-1** and branch **release/2.10.0**.

```sh
$ git checkout tags/2.10.0-1 -b release/2.10.0
```

> Note: The tutorial steps provided in the next sections assume the OPAE SDK is installed in default system locations, under the directory, ```/usr```. In most system configurations, this will allow the OS and tools to automatically locate the OPAE binaries, scripts, libraries and include files required for the compilation and simulation of the FIM and AFUs.


### **2.5. Download the Basic Building Blocks repositories**


The ```ofs-platform-afu-bbb``` repository contains the PIM files as well as example PIM-based AFUs that can be used for testing and demonstration purposes. This guide will use the ```host_chan_mmio``` AFU example in the [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) repository and the ```hello_world``` sample accompanying the [examples AFU](https://github.com/OFS/examples-afu.git) repository to demonstrate how to synthesize, load, simulate, and test a PIM-based AFU using the Intel® FPGA SmartNIC N6001-PL card with the PCIe Attach FIM.

Execute the next commands to clone the BBB repository.

```sh
  # Create top level directory for AFU development
$ mkdir OFS_BUILD_ROOT
$ cd OFS_BUILD_ROOT
$ export OFS_BUILD_ROOT=$PWD
  
  # Clone the ofs-platform-afu-bbb repository.
$ cd $OFS_BUILD_ROOT
$ git clone https://github.com/OFS/ofs-platform-afu-bbb.git
  
  # Verify retrieval
$ cd $OFS_BUILD_ROOT/ofs-platform-afu-bbb
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

Or you can build your own FIM and generated the PR build tree during the process.

To download and untar the pr_build_template:

```sh
$ cd $OFS_BUILD_ROOT
$ mkdir pr_build_template
$ cd pr_build_template
$ wget https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2023.3-1/pr_template-n6001.tar.gz
$ tar -zxvf pr_template-n6001.tar.gz
$ export OPAE_PLATFORM_ROOT=$PWD

```

To build your own FIM and generate the PR build tree for the Intel® FPGA SmartNIC N6001-PL platform, refer the [FPGA Interface Manager Developer Guide for Intel® Agilex® 7 PCIe Attach](https://ofs.github.io/ofs-2023.3/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/) and follow the Out-of-Tree PR FIM build flow.  If you are using a different platform, refer to the FPGA Interface Manager Developer Guide for your platform and follow the Out-of-Tree PR FIM build flow.

### **2.7. Download FIM to FPGA**


The AFU requires that the FIM from which the AFU is derived be loaded onto the FPGA.   

If you are using the Intel® FPGA SmartNIC N6001-PL release package, download the associated FIM files:
```sh
$ cd $OFS_BUILD_ROOT
$ wget https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2023.3-1/n6001-images.tar.gz
$ tar -zxvf n6001-images.tar.gz
$ cd n6001-images

```

If you are generating your own FIM, use the unsigned FPGA binary images from your FIM build. 

To downlaod the FIM to the Intel® FPGA SmartNIC N6001-PL platform:
```sh
$ sudo fpgasupdate ofs_top_page1_unsigned_user1.bin <N6001 SKU2 PCIe b:d.f>
$ sudo fpgasupdate ofs_top_page2_unsigned_user2.bin <N6001 SKU2 PCIe b:d.f>
$ sudo rsu fpga --page=user1 <N6001 SKU2 PCIe b:d.f>

```

If you are using a different platform, refer to the documentation for your platform to download the FIM images onto your Intel® Agilex® PCIe Attach Platform.

### **2.8. Set up required Environment Variables**


Set the required environment variables as shown below. These environment variables must be set prior to simulation or compilation tasks. You can create a simple script to set these variables and save time going forward.

```sh
# If not already done, export OFS_BUILD_ROOT to the top level directory for AFU development
$ export OFS_BUILD_ROOT=<path to ofs build directory>

# If not already done, export OPAE_PLATFORM_ROOT to the PR build tree directory
$ export OPAE_PLATFORM_ROOT=<path to pr build tree>
 
# Quartus Tools
# Note, QUARTUS_HOME is your Quartus installation directory, e.g. $QUARTUS_HOME/bin contains Quartus executable.
$ export QUARTUS_HOME=<user_path>/intelFPGA_pro/23.3/quartus
$ export QUARTUS_ROOTDIR=$QUARTUS_HOME
$ export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
$ export QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR
$ export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export QSYS_ROOTDIR=$QUARTUS_ROOTDIR/../qsys
$ export PATH=$QUARTUS_HOME/bin:$QSYS_ROOTDIR/bin:$QUARTUS_HOME/../sopc_builder/bin/:$PATH

# OPAE SDK release
$ export OPAE_SDK_REPO_BRANCH=release/2.10.0
      
# The following environment variables are required for compiling the AFU examples. 

# Location to clone the ofs-platform-afu-bbb repository which contains PIM files and AFU examples.
$ export OFS_PLATFORM_AFU_BBB=$OFS_BUILD_ROOT/ofs-platform-afu-bbb 

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

To load the image, perform the following steps:

```sh
 $ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev
 $ sudo fpgasupdate host_chan_mmio.gbs <N6001 SKU2 PCIe b:d.f>
[sudo] password for <<Your username>>: 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

Set up your board to work with the newly loaded AFU.

```sh
# For the following example, the N6001 SKU2 PCIe b:d.f is assumed to be B1:00.0,
# however this may be different in your system

# Create the Virtual Functions (VFs):
$ sudo pci_device b1:00.0 vf 3
 
# Verify:
 $ lspci -s b1:00
 b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
 b1:00.1 Processing accelerators: Intel Corporation Device bcce
 b1:00.2 Processing accelerators: Intel Corporation Device bcce
 b1:00.3 Processing accelerators: Intel Corporation Device bcce
 b1:00.4 Processing accelerators: Intel Corporation Device bcce
 b1:00.5 Processing accelerators: Intel Corporation Device bccf
 b1:00.6 Processing accelerators: Intel Corporation Device bccf
 b1:00.7 Processing accelerators: Intel Corporation Device bccf

# Bind VFs to VFIO driver.  Enter your username 
 
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


# Verify the new AFU is loaded.  The host_chan_mmio AFU GUID is "76d7ae9c-f66b-461f-816a-5428bcebdbc5".

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


The platform-independent [examples AFU](https://github.com/OFS/examples-afu.git) repository also provides some interesting example AFUs. In this section, you will compile and execute the PIM based ```hello_world``` AFU. The RTL of the ```hello_world``` AFU receives from the host application an address via memory mapped I/O (MMIO) write and generates a DMA write to the memory line at that address. The content written to memory is the string "Hello world!". The host application spins, waiting for the memory line to be updated. Once available, the software prints out the string.

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

1. If not done already, download and clone the [examples AFU](https://github.com/OFS/examples-afu.git) repository.
```sh
$ cd $OFS_BUILD_ROOT 
$ git clone https://github.com/OFS/examples-afu.git
```

2. Compile the ```hello_word``` sample AFU. 
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

3. To test the AFU in actual hardware, load the ```hello_world.gbs``` to the Intel® FPGA SmartNIC N6001-PL card. For this step to be successful, the PCIe Attach FIM must have already been loaded to the Intel® FPGA SmartNIC N6001-PL card following the steps described in Section 2 of this document.
```sh
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/afu_dev
$ sudo fpgasupdate hello_world.gbs <N6001 SKU2 PCIe b:d.f>
  [sudo] password for <<Your username>>: 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

Set up your Intel® FPGA SmartNIC N6001-PL board to work with the newly loaded ```hello_world.gbs``` file.

```sh
 # For the following example, the Intel® FPGA SmartNIC N6001-PL PCIe b:d.f is assumed to be B1:00.0,
 # however this may be different in your system

 # Create the Virtual Functions (VFs):
 $ sudo pci_device b1:00.0 vf 3
 
 # Verify:
 $ lspci -s b1:00
 b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
 b1:00.1 Processing accelerators: Intel Corporation Device bcce
 b1:00.2 Processing accelerators: Intel Corporation Device bcce
 b1:00.3 Processing accelerators: Intel Corporation Device bcce
 b1:00.4 Processing accelerators: Intel Corporation Device bcce
 b1:00.5 Processing accelerators: Intel Corporation Device bccf
 b1:00.6 Processing accelerators: Intel Corporation Device bccf
 b1:00.7 Processing accelerators: Intel Corporation Device bccf

 # Bind VFs to VFIO driver.  Enter <<Your username>>
 
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

# < Verify the new AFU is loaded.  The hello_world AFU GUID is "c6aa954a-9b91-4a37-abc1-1d9f0709dcc3".

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

4. Compile and execute the host application of the ```hello_world``` AFU. You should see the application outputs the "Hello world!" message in the terminal.

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

![](./images/AFU_Dev_Flow.png)


![](images/usrclk_timing.png)


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

![](./images/ASE_HighLevel.png)

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


Follow the instructions documented in the Getting Started Guide: Open FPGA Stack for Intel® Agilex® 7 FPGAs Targeting the Intel® FPGA SmartNIC N6001-PL, section [4.0 OPAE Software Development Kit](https://ofs.github.io/ofs-2023.3/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit) to build and install the required OPAE SDK for the Intel® FPGA SmartNIC N6001-PL card.

The N6001 SKU2 card requires **2.10.0-1**. Follow the instructions provided in the Getting Started Guide: Open FPGA Stack for Intel® Agilex® 7 FPGAs Targeting the Intel® FPGA SmartNIC N6001-PL, section [4.0 OPAE Software Development Kit](https://ofs.github.io/ofs-2023.3/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit). However, just make sure to check out the cloned repository to tag **2.10.0-1** and branch **release/2.10.0**.

```sh
$ git checkout tags/2.10.0-1 -b release/2.10.0
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
$ git checkout tags/2.10.0-1 -b release/2.10.0
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

$ afu_sim_setup -s $./hw/rtl/test_mmio_axi1.txt -t VCS afu_sim

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

![](./images/ASE_HW.png)

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

![](./images/ASE_Run.png)
<br/><br/>


Finally, on the hardware simulation shell, you can view the wave forms by invoking the following command.

```sh
$ make wave
```

This brings up the VCS® simulator GUI and loads the simulation waveform files. Use the Hierarchy window to navigate to the **afu** instance located under, ```ase_top | ase_top_plat | ase_afu_main_pcie_ss | ase_afu_main_emul | afu_main | port_afu_instances | ofs_plat_afu | afu``` , as shown below.

![](./images/ASE_VCS_hier_2023_2.png)

Right click on the ```afu (afu)``` entry to display the drop-down menu. Then, click on ```Add to Waves | New Wave View``` to display the following waveforms window.

![](./images/ASE_VCS_AFU_Waveforms_2023_2.png)

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

![](./images/ASE_Run_hello_world.png)

</br>

8. Finally, on the hardware simulation shell, you can view the wave forms by invoking the following command.

```sh
make wave
```

This brings up the DVE GUI and loads the simulation waveform files. Use the Hierarchy window to navigate to the **afu** instance located under, ```ase_top | ase_top_plat | ase_afu_main_pcie_ss | ase_afu_main_emul | afu_main | port_afu_instances | ofs_plat_afu | hello_afu```, as shown below.

![](./images/ASE_VCS_hier_hello_world_2023_2.png)

Right click on the ```hello_afu``` entry to display the drop-down menu. Then, click on ```Add to Waves | New Wave View``` to display the following waveforms window.

![](./images/ASE_VCS_AFU_Hello_World_Waveforms_2023_2.png)

</br></br>




## **5. Adding Remote Signal Tap Logic Analyzer to debug the AFU**


The OPAE SDK provides a remote Signal Tap facility. It also supports the following in system debug tools included with the Intel Quartus Prime Pro Edition:

- In-system Sources and Probes
- In-system Memory Content Editor
- Signal Probe
- System Console

This section is a short guide on adding remote Signal Tap instances to an AFU for in system debugging. You can follow the steps in the following sections, in order of execution to create an instrumented AFU. The ```host_chan_mmio``` AFU is used in this guide as the target AFU to be instrumented.

You need a basic understanding of Signal Tap. Please see the [Signal Tap Logic Analyzer: Introduction & Getting Started](https://www.intel.com/content/www/us/en/programmable/support/training/course/odsw1164.html) Web Based Training for more information.

You will run with a Signal Tap GUI running locally on the server with the Intel® FPGA SmartNIC N6001-PL as shown below:

![](./images/RSTP_local.png)

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
![](./images/stp_proj_nav_2023_1.png)

4. Bring up Signal Tap to create the *.stp file.  In the Quartus GUI, go to Tools - Signal Tap Logic Analyzer.  In the New File from Template pop up, click `Create` to accept the default template.  The Signal Tap Logic Analyzer window comes up.

5. Set up the clock for the Signal Tap logic instance by clicking `...` button as shown below:
![](./images/stp_clock.png)

6. The Node Finder comes up and you will click `...` as shown below to bring up the hierarchy navigator:
![](./images/stp_clk_bringup_hier_nav.png)

7. In the Select Hierarchy Level, navigate to top - afu_top - pg_afu.port_gasket - pr_slot - afu_main - port_afu_instances - ofs_plat_afu, then select instance afu and click ```Ok```.

8. Enter ```*clk*``` in the ```Named:``` box and click ```Search```.  This brings up matching terms.  Click ```clk``` and ```>```.  Verify your Node Finder is as shown below and then click ```Ok```:
![](./images/stp_set_up_clk_2023_3.png)

9. Double click the ```Double-click to add nodes``` and once again, click ```...``` and navigate to top - afu_top - port_gasket - pr_slot - afu_main - port_afu_instances - ofs_plat_afu, then select instance afu and click ```Ok```.  Enter ```mmio64_reg*``` and click ```Search```. Then click ```>>``` to add these signals to the STP instance as shown below:
![](./images/stp_sig_select_2023_3.png)

    Then click ```Insert``` and ```Close```.
![](./images/stp_final_setup_2023_3.png)

10. Save the newly created STP by clicking ```File - Save As``` and in the save as navigate to $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top and save the STP file as ```host_chan_mmio.stp``` as shown below:

![](./images/stp_save_stp_2023_3.png)


Select ```Yes``` when asked to add host_chan_mmio.stp to current project.  Close Signal Tap window.

11. Edit ```ofs_top.qsf``` to add host_chan_mmio.stp file and enable STP.  Open $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top/ofs_top.qsf in an editor and add the lines shown below:

```sh
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE host_chan_mmio.stp
set_global_assignment -name SIGNALTAP_FILE host_chan_mmio.stp
```

And also ensure "INCLUDE_REMOTE_STP" is enabled in ```ofs_top.qsf```.

```sh
# At most one of INCLUDE_REMOTE_STP and INCLUDE_JTAG_PR_STP should be
# set. If both are defined, JTAG-based SignalTap takes precedence.
# Remote STP uses mmlink. JTAG_PR_STP is on node 0 of the FPGA chain.
set_global_assignment -name VERILOG_MACRO "INCLUDE_REMOTE_STP"       # Includes Remote SignalTap support in PR Region
#set_global_assignment -name VERILOG_MACRO "INCLUDE_JTAG_PR_STP"      # Includes JTAG-based SignalTap via programming cable in the PR region
```

Save the ofs_top.qsf.

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

15. Use the OPAE SDK mmlink tool to create a TCP/IP connection to your Intel Agilex card under test.  The mmlink command has the following format:

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

16. In this step you will open a new shell and enable JTAG over protocol.  You must have Quartus 23.3 Programmer loaded on the N6001 server for local debugging.

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

17. Start Quartus Signal Tap GUI, connect to target, load stp file by navigating to $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top. The Quartus Signal Tap must be the same version of Quartus used to compile the host_chan_mmio.gbs. Quartus Prime Pro Version 23.3 is used in the steps below:

```sh
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_stp/build/syn/board/n6001/syn_top
$ quartus_stpw host_chan_mmio.stp &
```

This command brings up Signal Tap GUI. Connect to the Signal Tap over protocol by selecting the `Hardware` button on the right side of the GUI and click the "Please Select" pull down as shown below:

![](./images/ST_HW_Select.png)

JTAG over protocol selected:

![](./images/ST_JTAG_Selected.png)

This connection process will take approximately 2-3 minutes for the Signal Tap instance to indicate "Ready to acquire".

18. Set the trigger condition for a rising edge on signal `awvalid` signal.

19. In the Signal Tap window, enable acquisition by pressing key `F5`, the Signal Tap GUI will indicate "Acquisition in progress". Create and bind the VFs, then run the host_chan_mmio application following [3.2. Loading and Running host_chan_mmio example AFU](#32-loading-and-running-hostchanmmio-example-afu), and observe that the Signal Tap instance has triggered. You should see signals being captured in the Signaltap GUI.

See captured image below:

![](./images/stp_data_2023_2.png)

To end your Signal Tap session, close the Signal Tap GUI, then in the mmlink shell, enter `ctrl c` to kill the mmlink process.  
To remove the JTAG over protocol connection:

```sh
# This is assuming the JTAG over protocol is instance '1', as shown during jtagconfig --debug
$ jtagconfig --remove 1
```

## **6. How to modify the PF/VF MUX configuration**


For information on how to modify the PF/VF mapping for your own design, refer to the [FPGA Interface Manager Developer Guide for Intel® Agilex® 7 PCIe Attach](https://ofs.github.io/ofs-2023.3/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/).




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

