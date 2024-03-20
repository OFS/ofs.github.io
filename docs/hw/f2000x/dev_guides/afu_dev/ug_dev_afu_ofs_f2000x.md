# **AFU Developer Guide: OFS for Agilex® 7 FPGA SoC Attach FPGAs**

Last updated: **March 20, 2024** 

## **1. Introduction**


This document is a design guide for the creation of an Accelerator Functional Unit (AFU) using Open FPGA Stack (OFS) for Agilex® 7 FPGAs SoC Attach. The AFU concept consists of separating out the FPGA design development process into two parts, the construction of the foundational FPGA Interface Manager (FIM), and the development of the Acceleration Function Unit (AFU), as shown in the diagram below.

![](./images/FIM_top_intro.png)

This diagram shows the separation of FPGA board interface development from the internal FPGA workload creation.  This separation starts with the FPGA Interface Manager (FIM) which consists of the external interfaces and board management functions.  The FIM is the base system layer and is typically provided by board vendors. The FIM interface is specific to a particular physical platform.  The AFU makes use of the external interfaces with user defined logic to perform a specific application.  By separating out the lengthy and complicated process of developing and integrating external interfaces for an FPGA into a board allows the AFU developer to focus on the needs of their workload.  OFS for Agilex® 7 FPGAs SoC Attach provides the following tools for rapid AFU development:

- Scripts for both compilation and simulation setup
- Optional Platform Interface Manager (PIM) which is a set of SystemVerilog shims and scripts for flexible FIM to AFU interfacing
- Acceleration Simulation Environment (ASE) which is a hardware/software co-simulation environment scripts for compilation and Acceleration
- Integration with Open Programmable Acceleration Engine (OPAE) SDK for rapid software development for your AFU application
  

Please notice in the above block diagram that the AFU region consists of static and partial reconfiguration (PR) regions where the PR region can be dynamically reconfigured while the remaining FPGA design continues to function.  Creating AFU logic for the static region is described in [Shell Developer Guide: OFS for Agilex® 7 SoC Attach]. This guide covers logic in the AFU Main region.

### **1.1. Document Organization**


This document is organized as follows:

- Description of design flow
- Interfaces and functionality provided in the Agilex® 7 FPGAs SoC Attach FIM
- Setup of the AFU Development environment
- Synthesize the AFU example
- Testing the AFU example on the Intel® IPU Platform F2000X-PL card
- Hardware/Software co-simulation using ASE
- Debugging an AFU with Remote Signal Tap

This guide provides theory followed by tutorial steps to solidify your AFU development knowledge.

> **_NOTE:_**  
>
>**This guide uses the Intel® Infrastructure Processing Unit (Intel® IPU) Platform F2000X-PL as the platform for all tutorial steps. Additionally, this guide and the tutorial steps can be used with other Agilex® 7 FPGAs SoC Attach platforms..**
>
>**Some of the document links in this guide are specific to the Intel® IPU Platform F2000X-PL .   If using a different platform, please use the associated documentation for your platform as there could be differences in building the FIM and downloading FIM images.**  
>

If you have worked with previous Altera® Programmable Acceleration products, you will find out that OFS for Agilex® 7 FPGAs SoC Attach is similar. However, there are differences and you are advised to carefully read and follow the tutorial steps to fully understand the design tools and flow.


### **1.2. Prerequisite**


This guide assumes you have the following FPGA logic design-related knowledge and skills:

* FPGA compilation flows including the Quartus® Prime Pro Edition design flow
* Static Timing closure, including familiarity with the Timing Analyzer tool in Quartus® Prime Pro Edition software, applying timing constraints, Synopsys* Design Constraints (.sdc) language and Tcl scripting, and design methods to close on timing critical paths.
* RTL and coding practices to create synthesizable logic.
* Understanding of AXI and Avalon memory mapped and streaming interfaces.
* Simulation of complex RTL using industry standard simulators (Synopsys® VCS® or Siemens® QuestaSim®).
* Signal Tap Logic Analyzer tool in the Quartus® Prime Pro Edition software.

You are strongly encouraged to review the [Shell Developer Guide: OFS for Agilex® 7 SoC Attach].

### **1.3. Acceleration Functional Unit (AFU) Development Flow**


The AFU development flow is shown below:
![](./images/AFU_Dev_Flow.png)

#### **1.3.1. Understanding Platform Capabilities**


The block diagram of the F2000x Board is shown below:

![](./images/F2000x_Board.png)

The F2000x FIM provided with this release is shown below:

![](./images/F2000x_FIM.png)

This release F2000x FIM provides the following features:

- Host interface
  - PCIe Gen4 x 16
  - 2 - PFs 
  - MSI-X interrupts
  - Logic to demonstrate simple PCIe loopback
- Network interface
  - 2 - QSFP28/56 cages
  - 8 X 25 GbE with exerciser logic demonstrating traffic generation/monitoring
- External Memory - DDR4 - 2400
  - 4 Banks - 4 GB organized as 1 Gb x 32 with 1 Gb x 8 ECC
  - Memory exerciser logic demonstrating external memory operation
- Board Management
  - SPI interface
  - FPGA management and configuration
  - Example logic showing DFH operation
- Partial reconfiguration control logic
- SoC - Xeon Icelake-D subsystem with embedded Linux
  - PCIe Gen4 x 16 interface to FPGA
  - 1 - PF, 3 - VF, AXI-S TLP packets
  - DDR Memory
    - 2 Banks - 8 GB organized as 1 Gb x 64 with 1 Gb x 8 ECC
    - NVMe SSD - 64 GB

#### **1.3.2. High Level Data Flow**


The OFS high level data flow is shown below:

![](./images/OFS_DataFlow.png)

#### **1.3.3. Considerations for PIM Usage**


When creating an AFU, a designer needs to decide of what type of interfaces the AFU will provide to the platform (FIM).  The AFU can use the native interfaces (i.e. PCIe TLP commands) provided by the FIM or standard memory mapped interfaces (i.e. AXI-MM or AVMM) by using the PIM.  The PIM is an abstraction layer consisting of a collection of SystemVerilog interfaces and shims to enable partial AFU portability across hardware despite variations in hardware topology and native interfaces. The PIM adds a level of logic between the AFU and the FIM converting the native interfaces from the FIM to match the interfaces provided by the AFU.

![](./images/pim_based_afu.png)

The following resources are available to assist in creating an AFU:

[PIM Core Concepts](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md) provides details on using the PIM and its capabilities. 

[PIM Based AFU Developer User Guide](https://ofs.github.io/ofs-2024.1-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/) provides details on interfacing your AFU to the FIM using the PIM.

The [examples AFU](https://github.com/OFS/examples-afu.git) repo provides several AFU examples.  These examples can be run with the current OFS FIM package.  There are three [AFU types](https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types) of examples provided (PIM based, hybrid and native).  Each example provides the following:

* RTL, which includes the following interfaces: 
   * [Host Channel](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md): 
     * Host memory, providing a DMA interface.
     * MMIO, providing a CSR interface.  
   * [Local Memory](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md)
* Host software example interfacing to the CSR interface and host memory interface, using the [OPAE C API](https://ofs.github.io/ofs-2024.1-1/sw/fpga_api/prog_guide/readme/#opae-c-api-programming-guide).
* Accelerator Description File .json file
* Source file list

#### **1.3.4. AFU Interfaces Included with Intel® IPU Platform F2000X-PL**


The figure below shows the interfaces available to the AFU in this architecture. It also shows the design hierarchy with module names from the fim (top.sv) to the PR region AFU (afu_main.sv).
One of the main differences from the Stratix 10 PAC OFS architecture to this one is the presence of the static port gasket region (port_gasket.sv) that has components to facilitate the AFU and also consists of the PR region (afu_main.sv) via the PR slot. The Port Gasket contains all the PR specific modules and logic, e.g., PR slot reset/freeze control, user clock, remote STP etc. Architecturally, a Port Gasket can have multiple PR slots where user workload can be programmed into. However, only one PR slot is supported for OFS Release for Agilex. Everything in the Port Gasket until the PR slot should be provided by the FIM developer. The task of the AFU developer is to add their desired application in the afu_main.sv module by stripping out unwanted logic and instantiating the target accelerator.
As shown in the figure below, here are the interfaces connected to the AFU (highlighted in green) via the SoC Attach FIM:

1. AXI Streaming (AXI-S) interface to the Host via PCIe Gen4x16
2. AXI Memory Mapped Channels (4) to the DDR4 EMIF interface
3. AXI Streaming (AXI-S) interface to the HSSI 25 Gb Ethernet

![](./images/N6000_AFU_IF.png)

## **2. Set Up AFU Development Environment**


This section covers the setup of the AFU development environment.

### **2.1. Prepare AFU development environment**


A typical development and hardware test environment consists of a development server or workstation with FPGA development tools installed and a separate server with the target OFS compatible FPGA PCIe card installed.  The typical usage and flow of data between these two servers is shown below:

![](./images/AFU_Dev_Deploy.png)

Note: both development and hardware testing can be performed on the same server if desired.

This guide uses Intel® IPU Platform F2000X-PL as the target OFS compatible FPGA PCIe card for demonstration steps.  The Intel® IPU Platform F2000X-PL must be fully installed following the [Board Installation Guide: Open FPGA Stack for Agilex® 7 SoC Attach FPGAs]. If using a different OFS FPGA PCIe card, contact your supplier for instructions on how to install and operate user developed AFUs.

The following is a summary of the steps to set up for AFU development:

1. Install Quartus<sup>&reg;</sup> Prime Pro Edition Version 23.4 for Linux with Agilex device support and required Quartus patches.
2. Make sure support tools are installed and meet version requirements.
3. Install OPAE SDK.
4. Download the Basic Building Blocks repository.
5. Build or download the relocatable AFU PR-able build tree based on your Agilex FPGA PCIe Attach FIM.
6. Download FIM to the Agilex FPGA PCIe Attach platform.

Building AFUs with OFS for Agilex requires the build machine to have at least 64 GB of RAM. 

### **2.2. Installation of Quartus and required patches**


**Intel Quartus<sup>&reg;</sup> Prime Pro Edition Version 23.4** is verified to work with the latest OFS release release/ofs-2024.1.  However, you have the option to port and verify the release on newer versions of Intel Quartus Prime Pro software.

Use Ubuntu 22.04 for compatibility with your development flow and also testing your FIM design in your platform. 

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

5. Install required Quartus patches. The Quartus patch `.run` files can be found in the **Assets** tab on the [OFS Release GitHub page](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1). The patches for this release are 0.17 patch (PCIe).

6. After running the Quartus Prime Pro installer, set the PATH environment variable to make utilities `quartus`, `jtagconfig`, and `quartus_pgm` discoverable. Edit your bashrc file `~/.bashrc` to add the following line:

  ```bash
  export PATH=<Quartus install directory>/quartus/bin:$PATH
  export PATH=<Quartus install directory>/qsys/bin:$PATH
  ```

  For example, if the Quartus install directory is /home/intelFPGA_pro/23.4 then the new line is:

  ```bash
  export PATH=/home/intelFPGA_pro/23.4/quartus/bin:$PATH
  export PATH=/home/intelFPGA_pro/23.4/qsys/bin:$PATH
  ```

7. Verify, Quartus is discoverable by opening a new shell:

  ```
  $ which quartus
  /home/intelFPGA_pro/23.4/quartus/bin/quartus
  ```




### **2.3. Installation of Support Tools**


Make sure support tools are installed and meet version requirements.

The OFS provided Quartus build scripts require the following tools. Verify these are installed in your development environment.


| Item              |  Version            |
| ----              |  ----               |
| Python            | 3.6.8        |
| GCC               | 7.2.0         |
| cmake             | 3.15      |
| git               | 1.8.3.1     |
| perl              | 5.8.8                |


### **2.4. Installation of OPAE SDK**

Working with the Intel® IPU Platform F2000X-PL card requires **opae-2.12.0-4**. Follow the instructions in the [Software Installation Guide: Open FPGA Stack for Agilex® 7 SoC Attach FPGAs] to build and install the required OPAE SDK for the Intel® IPU Platform F2000X-PL. Make sure to check out the cloned repository to tag **2.12.0-4** and branch **release/2.12.0**.

```sh
$ git checkout tags/2.12.0-4 -b release/2.12.0
```

> Note: The tutorial steps provided in the next sections assume the OPAE SDK is installed in default system locations, under the directory, ```/usr```. In most system configurations, this will allow the OS and tools to automatically locate the OPAE binaries, scripts, libraries and include files required for the compilation and simulation of the FIM and AFUs.


### **2.5. Download the Basic Building Blocks repositories**

The ```ofs-platform-afu-bbb``` repository contains the PIM files as well as example PIM-based AFUs that can be used for testing and demonstration purposes. This guide will use the ```host_chan_mmio``` AFU example in the [ofs-platform-afu-bbb](https://github.com/OFS/ofs-platform-afu-bbb) repository and the ```hello_world``` sample in the [examples AFU](https://github.com/OFS/examples-afu.git) repository to demonstrate how to synthesize, load, simulate, and test a PIM-based AFU using the Intel® IPU Platform F2000X-PL card with the SoC Attach FIM.

Execute the next commands to clone the BBB repositories.

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

You can use the Intel® IPU Platform F2000X-PL release package and download the PR build tree and FIM images, to develop your AFU.  These are located at [OFS-F2000X-PL release](https://github.com/OFS/ofs-f2000x-pl/releases/ofs-2024.1-1)  

Or you can build your own FIM and generate the PR build tree during the process.

To download and untar the pr_build_template:

```sh
$ wget https://github.com/OFS/ofs-f2000x-pl/releases/download/ofs-2024.1-1/f2000x-images_ofs-2024-1-1.tar.gz
$ tar -zxvf f2000x-images_ofs-2024-1-1.tar.gz
$ cd f2000x-images_ofs-2024-1-1/
$ mkdir pr_build_template
$ tar -zxvf pr_template-f2000x.tar.gz -C ./pr_build_template
$ cd pr_build_template
$ export OPAE_PLATFORM_ROOT=$PWD

```

To build your own FIM and generate the PR build tree for the Intel® IPU Platform F2000X-PL platform, refer the [Shell Developer Guide: OFS for Agilex® 7 SoC Attach] and follow the Out-of-Tree PR FIM build flow.  If you are using a different platform, refer to the Shell Developer Guide for your platform and follow the Out-of-Tree PR FIM build flow.

### **2.7. Download FIM to FPGA**


The AFU requires that the FIM from which the AFU is derived be loaded onto the FPGA.   

If you are using the Intel® IPU Platform F2000X-PL release package downloaded in the previous section, copy the associated FIM files to the SoC:
```sh
# On Development Host
$ cd $OFS_BUILD_ROOT/f2000x-images_ofs-2024-1-1/
$ scp ofs_top_page1_unsigned_user1.bin <user>@<SoC IP address>:</remote/directory>
$ scp ofs_top_page2_unsigned_user2.bin <user>@<SoC IP address>:</remote/directory>

```

If you are generating your own FIM, use the unsigned FPGA binary images from your FIM build and copy over to the SoC. 

To downlaod the FIM to the Intel® IPU Platform F2000X-PL platform:
```sh
# On SoC
$ sudo fpgasupdate ofs_top_page1_unsigned_user1.bin 
$ sudo fpgasupdate ofs_top_page2_unsigned_user2.bin 
$ sudo rsu fpga --page=user1 

```

If you are using a different platform, refer to the documentation for your platform to download the FIM images onto your Agilex® SoC Attach Platform.

### **2.8. Set up required Environment Variables**


Set the required environment variables as shown below. These environment variables must be set prior to simulation or compilation tasks. You can create a simple script to set these variables and save time going forward.

```sh
# If not already done, export OFS_BUILD_ROOT to the top level directory for AFU development
$ export OFS_BUILD_ROOT=<path to ofs build directory>

# If not already done, export OPAE_PLATFORM_ROOT to the PR build tree directory
$ export OPAE_PLATFORM_ROOT=<path to pr build tree>
 
# Quartus Tools
# Note, QUARTUS_HOME is your Quartus installation directory, e.g. $QUARTUS_HOME/bin contains Quartus executable.
$ export QUARTUS_HOME=<user_path>/intelFPGA_pro/23.4/quartus
$ export QUARTUS_ROOTDIR=$QUARTUS_HOME
$ export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
$ export QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR
$ export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
$ export QSYS_ROOTDIR=$QUARTUS_ROOTDIR/../qsys
$ export PATH=$QUARTUS_HOME/bin:$QSYS_ROOTDIR/bin:$QUARTUS_HOME/sopc_builder/bin/:$PATH

# OPAE SDK release
$ export OPAE_SDK_REPO_BRANCH=release/2.12.0
      
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

Execute ```afu_synth_setup``` as follows to create the synthesis environment for a ```host_chan_mmio``` AFU that fits the SoC Attach FIM previously constructed.

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

The previous output indicates the successful compilation of the AFU and the compliance with the timing requirements. Analyze the reports generated in case the design does not meet timing. The timing reports are stored in the directory, ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev/build/syn/syn_top/output_files/timing_report```.


Once the compilation finishes successfully, load the new ```host_chan_mmio.gbs``` bitstream file into the partial reconfiguration region of the target Intel® IPU Platform F2000X-PL board. Keep in mind, that the loaded image is dynamic - this image is not stored in flash and if the card is power cycled, then the PR region is re-loaded with the default AFU.

To load the image, perform the following steps:

```sh
# On Development Host
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/afu_dev
# Copy FIM files to SoC
$ scp host_chan_mmio.gbs <user>@<SoC IP address>:</remote/directory>
```

```sh 
# On SoC
$ cd </remote/directory>
$ fpgasupdate host_chan_mmio.gbs 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

Set up your board to work with the newly loaded AFU.

```sh
# On SoC

# Verify PCIe b.d.f
# For the following example, the F2000x SKU2 PCIe b:d.f is 15:00.0,
# however this may be different in your system
$  fpgainfo fme
Intel IPU Platform F2000X-PL
Board Management Controller NIOS FW version: 1.2.4
Board Management Controller Build version: 1.2.4
//****** FME ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Ports Num                        : 01
...

# Create the Virtual Functions (VFs) provided by the FIM, the default FIM has 3 VFs
$ pci_device 15:00.0 vf 3
 
# Verify the VFs have been added (device id: bccf)
$ lspci -s 15:00
15:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
15:00.1 Processing accelerators: Intel Corporation Device bccf
15:00.2 Processing accelerators: Intel Corporation Device bccf
15:00.3 Processing accelerators: Intel Corporation Device bccf


# Bind VFs to VFIO driver. 
 
$  opae.io init -d 0000:15:00.1 
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.1 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.1 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.1 is 52
 
$ opae.io init -d 0000:15:00.2
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.2 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.2 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.2 is 53
 
$  opae.io init -d 0000:15:00.3
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.3 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.3 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.3 is 54

# Verify the new AFU is loaded.  The host_chan_mmio AFU GUID is "76d7ae9c-f66b-461f-816a-5428bcebdbc5".

$ fpgainfo port
//****** PORT ******//
Object Id                        : 0xF100000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
//****** PORT ******//
Object Id                        : 0x6015000000000000
PCIe s:b:d.f                     : 0000:15:00.3
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : d15ab1ed-0000-0000-0210-000000000000
//****** PORT ******//
Object Id                        : 0x4015000000000000
PCIe s:b:d.f                     : 0000:15:00.2
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : d15ab1ed-0000-0000-0110-000000000000
//****** PORT ******//
Object Id                        : 0x2015000000000000
PCIe s:b:d.f                     : 0000:15:00.1
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : 76d7ae9c-f66b-461f-816a-5428bcebdbc5

```

 Now, navigate to the directory of the ```host_chan_mmio``` AFU containing the host application's source code, ```$OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/sw```. Once there, compile the ```host_chan_mmio``` host application and execute it on the host server to excercise the functionality of the AFU.

> Note: If OPAE SDK libraries were not installed in the default systems directories under ```/usr```, you need to set the ```OPAE_LOC```, ```LIBRARY_PATH```, and ```LD_LIBRARY_PATH``` environment variables to the custom locations where the OPAE SDK libraries were installed.

```sh
# On Development Host, move to the sw directory of the the host_chan_mmio AFU. This directory holds the source for the host application.
$ cd $OFS_PLATFORM_AFU_BBB/plat_if_tests/host_chan_mmio/sw
$ export OPAE_LOC=/usr
$ export LIBRARY_PATH=$OPAE_LOC/lib:$LIBRARY_PATH
$ export LD_LIBRARY_PATH=$OPAE_LOC/lib64:$LD_LIBRARY_PATH
$ make
# Copy application to SoC
$ scp host_chan_mmio <user>@<SoC IP address>:</remote/directory>
```

```sh
# On SoC, Run the application
$ cd </remote/directory>
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
$ ${OPAE_PLATFORM_ROOT}/bin/afu_synth
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

3. To test the AFU in actual hardware, load the ```hello_world.gbs``` to the Intel® IPU Platform F2000X-PL card. For this step to be successful, the SoC Attach FIM must have already been loaded to the Intel® IPU Platform F2000X-PL card following the steps described in Section 2 of this document.

```sh
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/afu_dev/
# Copy FIM files to SoC
$ scp hello_world.gbs <user>@<SoC IP address>:</remote/directory>
```

```sh 
# On SoC
$ cd </remote/directory>
$ fpgasupdate hello_world.gbs 
[2022-04-15 20:22:18.85] [WARNING ] Update starting. Please do not interrupt.
[2022-04-15 20:22:19.75] [INFO    ] 
Partial Reconfiguration OK
[2022-04-15 20:22:19.75] [INFO    ] Total time: 0:00:00.90
```

Set up your Intel® IPU Platform F2000X-PL board to work with the newly loaded ```hello_world.gbs``` file.

```sh
# On SoC

# Verify PCIe b.d.f
# For the following example, the F2000x SKU2 PCIe b:d.f is 15:00.0,
# however this may be different in your system
$  fpgainfo fme
Intel IPU Platform F2000X-PL
Board Management Controller NIOS FW version: 1.2.4
Board Management Controller Build version: 1.2.4
//****** FME ******//
Object Id                        : 0xF000000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Ports Num                        : 01
...

# Create the Virtual Functions (VFs) provided by the FIM, the default FIM has 3 VFs
$ pci_device 15:00.0 vf 3
 
# Verify the VFs have been added (device id: bccf)
$ lspci -s 15:00
15:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
15:00.1 Processing accelerators: Intel Corporation Device bccf
15:00.2 Processing accelerators: Intel Corporation Device bccf
15:00.3 Processing accelerators: Intel Corporation Device bccf


# Bind VFs to VFIO driver.
 
$ opae.io init -d 0000:15:00.1
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.1 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.1 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.1 is 52
 
$ opae.io init -d 0000:15:00.2
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.2 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.2 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.2 is 53
 
$ opae.io init -d 0000:15:00.3
opae.io 0.2.5
Unbinding (0x8086,0xbccf) at 0000:15:00.3 from dfl-pci
Binding (0x8086,0xbccf) at 0000:15:00.3 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:15:00.3 is 54

# Verify the new AFU is loaded.  The hello_world AFU GUID is "c6aa954a-9b91-4a37-abc1-1d9f0709dcc3".

$ fpgainfo port
//****** PORT ******//
Object Id                        : 0xF100000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
//****** PORT ******//
Object Id                        : 0x6015000000000000
PCIe s:b:d.f                     : 0000:15:00.3
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : d15ab1ed-0000-0000-0210-000000000000
//****** PORT ******//
Object Id                        : 0x4015000000000000
PCIe s:b:d.f                     : 0000:15:00.2
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : d15ab1ed-0000-0000-0110-000000000000
//****** PORT ******//
Object Id                        : 0x2015000000000000
PCIe s:b:d.f                     : 0000:15:00.1
Vendor Id                        : 0x8086
Device Id                        : 0xBCCF
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Accelerator GUID                 : c6aa954a-9b91-4a37-abc1-1d9f0709dcc3

```

4. Compile and execute the host application of the ```hello_world``` AFU. You should see the application outputs the "Hello world!" message in the terminal.

```sh
# On Development Host, move to the sw directory of the hello_world AFU and build application
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/sw
$ make
# Copy application to SoC
$ scp hello_world <user>@<SoC IP address>:</remote/directory>
```

```sh
# On SoC, Run the application
$ cd </remote/directory>
$ ./hello_world
Hello world!
```

### **3.4. Modify the AFU user clocks frequency**

AFU user clocks are currently not supported in F2000x base FIM configuration.


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


The F2000x SKU2 card requires **2.12.0-4**. Follow the instructions in the [Software Installation Guide: Open FPGA Stack for Agilex® 7 SoC Attach FPGAs] to build and install the required OPAE SDK for the Intel® IPU Platform F2000X-PL. Make sure to check out the cloned repository to tag **2.12.0-4** and branch **release/2.12.0**.

```sh
$ git checkout tags/2.12.0-4 -b release/2.12.0
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
$ git checkout tags/2.12.0-1 -b release/2.12.0 
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

```
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

```
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
Loading platform database: /ofs-f2000x-pl/work_pr/build_tree/hw/lib/platform/platform_db/ofs_agilex_adp.json
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

```
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

This brings up the Synopsys® VCS® simulator GUI and loads the simulation waveform files. Use the Hierarchy window to navigate to the **afu** instance located under, ```ase_top | ase_top_plat | ase_afu_main_pcie_ss | ase_afu_main_emul | afu_main | port_afu_instances | ofs_plat_afu | afu``` , as shown below.

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
Loading platform database: /home/<user_area>/ofs-f2000x-pl/work_pr/pr_build_template/hw/lib/platform/platform_db/ofs_agilex_adp.json
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
$ cd $OFS_BUILD_ROOT/examples-afu/tutorial/afu_types/01_pim_ifc/hello_world/afu_sim
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


Remote Signal Tap is currently not supported in F2000x base FIM configuration.


## **6. How to modify the PF/VF MUX configuration**


For information on how to modify the PF/VF mapping for your own design, refer to the [Shell Developer Guide: OFS for Agilex® 7 SoC Attach].

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


