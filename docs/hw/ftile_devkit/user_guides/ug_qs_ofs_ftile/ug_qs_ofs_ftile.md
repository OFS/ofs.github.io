# Getting Started Guide: Open FPGA Stack for Intel Agilex 7 FPGAs Targeting the Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) 

Last updated: **February 16, 2024** 

## 1.0 About This Document

The purpose of this document is to help users get started in evaluating the 2023.3 version of the PCIe Attach release targeting the F-tile Development Kit. After reviewing this document, a user shall be able to:

* Set up a server environment according to the Best Known Configuration (BKC)
* Load and verify firmware targeting the FIM and AFU regions of the AGFB027R24C2E2VR2 FPGA
* Verify full stack functionality offered by the PCIe Attach OFS solution
* Learn where to find additional information on other PCIe Attach ingredients

### 1.1 Audience

The information in this document is intended for customers evaluating the PCIe Attach shell targeting the Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile). This platform is a Development Kit  intended to be used as a starting point for evaluation and development of the Intel Agilex 7 FPGA F-Series with two F-Tiles.

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


#### Table 2: Software and Component Version Summary for OFS PCIe Attach targeting the F-tile Development Kit

The OFS 2023.3 PCIe Attach release targeting the F-tile Development Kit is built upon tightly coupled software and Operating System version(s). The repositories listed below are used to manually build the Shell and the AFU portion of any potential workloads. Use this section as a general reference for the versions which compose this release. Specific instructions on building the FIM or AFU are discussed in their respective documents.

| Component | Version | Download Link |
| ----- | ----- | ----- |
| Quartus | Quartus Prime Pro Version 23.3 | https://www.intel.com/content/www/us/en/software-kit/782411/intel-quartus-prime-pro-edition-design-software-version-23-3-for-linux.html, patches: 0.13 patch (Generic Serial Flash Interface IP), 0.21 patch (PCIe) |
| Host Operating System |  RedHat® Enterprise Linux® (RHEL) 8.6 | https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.6/x86_64/product-software|
| OneAPI-ASP| ofs-2023.3-2 | https://github.com/OFS/oneapi-asp/releases/tag/ofs-2023.3-2, patches: 0.02 |
| OFS Platform AFU BBB| ofs-2023.3-2 | https://github.com/OFS/ofs-platform-afu-bbb/releases/tag/ofs-2023.3-2 |
| OFS FIM Common Resources| 2023.3| https://github.com/OFS/ofs-fim-common/releases/tag/ofs-2023.3-2 |
| AFU Examples| tag: ofs-2023.3-2| https://github.com/OFS/examples-afu/releases/tag/ofs-2023.3-2|
| OPAE-SIM | tag: 2.10.0-1 | https://github.com/OPAE/opae-sim |

#### Table 3: Programmable Firmware Version Summary for OFS PCIe Attach targeting the F-tile Development Kit

OFS releases include pre-built binaries for the FPGA, OPAE SDK and Linux DFL which can be programmed out-of-box (OOB) and include known identifiers shown below. Installation of artifacts provided with this release will be discussed in their relevant sections.

| Component | Version|  Link|
| ----- | ----- | ----- |
| FIM (shell) | Pr Interface ID: 5bcd682f-5093-5fc7-8cd2-ae8073e19452  | https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2 |
| Host OPAE SDK| https://github.com/OPAE/opae-sdk, tag: 2.10.0-1| https://github.com/OFS/opae-sdk/releases/tag/2.10.0-1|
| Host Linux DFL Drivers| https://github.com/OPAE/linux-dfl, tag: ofs-2023.3-6.1-3 | https://github.com/OFS/linux-dfl/releases/tag/ofs-2023.3-6.1-3|

#### Table 4: Hardware BKC for OFS PCIe Attach targeting the F-tile Development Kit

The following table highlights the hardware which composes the Best Known Configuation (BKC) for the OFS 2023.3 PCIe Attach release targeting F-tile Development Kit.

*Note: The Dell R750 server product line is known not to work with this release.*

| Component | Link |
| ----- | ----- |
| Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) | https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html |
| Intel FPGA Download Cable II| https://www.intel.com/content/www/us/en/products/sku/215664/intel-fpga-download-cable-ii/specifications.html|
| SuperMicro SYS-220HE-FTNR| https://www.supermicro.com/en/products/system/hyper/2u/sys-220he-ftnr |

### 1.2 Server Requirements

#### 1.2.1 Host Server Specifications

The host server must meet the following specifications:

- The server platform must contain 64 GB of RAM to run certain demos, and to compile FIM Images
- The server platform must be able to fit, power, and cool an Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) as described by the [product page](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/agf027-and-agf023.html)
- The server should be able to run PCIe at Gen 4 speeds to properly test designs and demos

#### 1.2.2 Host BIOS

These are the host BIOS settings known to work with the F-tile Development Kit. Information about the server's currently loaded firmware and BIOS settings can be found through its remote access controller, or by manually entering the BIOS by hitting a specific key during power on. Your specific server platform will include instructions on proper BIOS configuration and should be followed when altering settings.

- PCIe slot width must be set to x16
- PCIe slot speed must be set to 4
- PCIe slot must have iommu enabled
- Intel VT for Directed I/O (VT-d) must be enabled

Specific BIOS paths are not listed here as they can differ between BIOS vendors and versions.

In addition to BIOS settings required to support the operation of an OFS PCIe Attach solution targeting the F-tile Development Kit, server fan speed may need to be adjusted in the BIOS settings depending on local air temperature and air flow. The OFS PCIe Attach design does not automatically communicate cooling curve information with the on-board server management interface. Increasing air flow will mitigate possible thermal runaway and thermal throttling that may occur as a result.

#### 1.2.3 Host Server Kernel and GRUB Configuration

While many host Linux kernel and OS distributions may work with this design, only the following configuration(s) have been tested:

OS: RedHat® Enterprise Linux® (RHEL) 8.6 <br>
Kernel: 6.1-lts

### 1.3 Preparing the F-tile Development Kit for Installation into a Server

1. The DK-DEV-AGF027F1ES (or it is called the F - tile Dev Kit, or FM86 Dev Kit) has LED light pipes on top of the QSFP cages.
    
    ![ftile_qsfp_light_pipe](./images/ftile_qsfp_light_pipe.png)
    
    These light pipes interfere with the server PCIe slot faceplate.
    
    ![ftile_qsfp_light_pipe_interference_r750](./images/ftile_qsfp_light_pipe_interference_r750.png)

2. The light pipes can be easily removed by prying them off using a small screwdriver for leverage, then pushing the light pipes back to remove the retaining clips from the QSFP cage.
        
    ![ftile_qsfp_light_pipe_removal_part1](./images/ftile_qsfp_light_pipe_removal_part1.png)
    
    ![ftile_qsfp_light_pipe_removal_part2](./images/ftile_qsfp_light_pipe_removal_part2.png)
    
    ![ftile_qsfp_light_pipe_removal_part3](./images/ftile_qsfp_light_pipe_removal_part3.png)

3. Board switch definitions can be found in the [Intel Agilex® 7 F-Series FPGA (Two F-Tiles) Development Kit User Guide](https://www.intel.com/content/www/us/en/docs/programmable/739942/current/overview.html).
        
    ![ftile_board_switches_diagram](./images/ftile_board_switches_diagram.png)
    
    See the image below for SW1, SW4 and SW3.
    
    ![](./images/ftile_board_switches_picture.png)
    
    Before inserting into a server, set SW5 to 'ON'.
    
    ![ftile_board_sw5_on](./images/ftile_board_sw5_on.png)

4. Below shows a card installed into a PCIe riser with the light pipes removed.
    
    ![ftile_final_installation_r750](./images/ftile_final_installation_r750.png)

### 1.4 F-tile Development Kit JTAG Setup


The Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) has an on-board FPGA Download Cable II module which is used to program the FPGA via JTAG.

Perform the following steps to establish a JTAG connection with the fseries-dk.

Pre-requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [OFS Agilex PCIe Attach Getting Started Guide] for instructions on setting up a deployment environment.

* This walkthrough requires a workstation with Quartus Prime Pro Version 23.3 tools installed, specifically the `jtagconfig` tool.

Steps:

1. Refer to the following figure for Steps 2 and 3.

  ![agilex_ftile_dev_kit](images/agilex_ftile_dev_kit.png)

2. Locate Single DIP Switch **SW2** and 4-position DIP switch **SW3** on the fseries-dk. These switches control the JTAG setup for the board. Ensure that both **SW2** and **SW3.3** are set to `ON`.

3. Locate the **J10** Micro-USB port on the fseries-dk. Connect a Micro-USB to USB-A cable between the **J10** port and the workstation that has Quartus Prime Pro tools installed.

4. Use the `jtagconfig` tool to check that the JTAG chain contains the AGFB027R24C2E2VR2 device.

    ```bash
    <QUARTUS_INSTALL_DIR>/23.3/quartus/bin/jtagconfig
    ```

    Example expected output:

    ```bash
    1) Agilex F-Series FPGA Dev Kit [1-6]
    0343B0DD   AGFB027R24C(.|R2|R0)/..
    020D10DD   VTAP10
    ```

This concludes the walkthrough for establishing a JTAG connection on the fseries-dk.

### 1.5 Upgrading the F-tile Development Kit FIM via JTAG

Intel provides a pre-built FIM that can be used out-of-box for platform bring-up. This shell design is available on the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2). After programming the shell and installing both the OPAE SDK and Linux DFL kernel drivers (as shown in sections [3.0 OFS DFL Kernel Drivers](#30-ofs-dfl-kernel-drivers) and [4.0 OPAE Software Development Kit](#4-opae-software-development-kit)), you can confirm the correct FIM has been configured by checking the output of `fpgainfo fme` against the following table:

#### Table 5: FIM Version

|Identifier|Value|
|-----|-----|
|Pr Interface ID|5bcd682f-5093-5fc7-8cd2-ae8073e19452|
|Bitstream ID|360571655976424377|

You will need to download and unpack the artifact images for this release before upgrading your device. The file `ofs_top_hps.sof` is the base OFS FIM file. This file is loaded into the FPGA using the development kit built in USB Blaster. Please be aware this FPGA is not loaded into non-volatile storage, therefore if the server is power cycled, you will need to reload the FPGA .sof file.

```bash
wget https://github.com/OFS/ofs-agx7-pcie-attach/releases/download/ofs-2023.3-2/fseries-images_ofs-2023-3-2.tar.gz
tar xf fseries-dk-images.tar.gz
cd fseries-dk-images/

```

This walkthrough describes the steps to program the Agilex FPGA on the Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) with a `SOF` image via JTAG.

Pre-Requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [Getting Started Guide: Open FPGA Stack for Intel® Agilex® 7 SoC Attach FPGAs (Intel Agilx 7 FPGA F-Series Development Kit (2xF-Tile))](https://ofs.github.io/ofs-2023.2/hw/ftile_devkit/user_guides/ug_qs_ofs_ftile/ug_qs_ofs_ftile/) for instructions on setting up a deployment environment.

* This walkthrough requires a `SOF` image which will be programmed to the Agilex FPGA. Refer to the [Walkthrough: Compile OFS FIM] Section for step-by-step instructions for generating a `SOF` image.

* This walkthrough requires a JTAG connection to the fseries-dk. Refer to the [Walkthrough: Set up JTAG] section for step-by-step instructions.

* This walkthrough requires a Full Quartus Installation or Standalone Quartus Prime Programmer & Tools running on the machine where the Intel Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) is connected via JTAG.

Steps:

1. Start in your deployment environment.

2. If the card is already programmed with an OFS enabled design, determine the PCIe B:D.F of the card using OPAE command `fpgainfo fme`. In this example, the PCIe B:D.F is `B1:00.0`.

  ```bash
  sudo fpgainfo fme
  ```

  Example output:

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
  Bitstream Id                     : 0x5010202A8769764
  Bitstream Version                : 5.0.1
  Pr Interface Id                  : b541eb7c-3c7e-5678-a660-a54f71594b34
  Boot Page                        : N/A
  ```

  >**Note:** The errors related to the BMC are the result of the OFS BMC not being present on the fseries-dk design. These will be removed in a future release.

3. Remove the card from PCIe prior to programming. This will disable AER for the PCIe root port to prevent a surprise link-down event during programming.

  ```bash
  sudo pci_device b1:00.0 unplug
  ```

4. Switch to the machine with JTAG connection to the fseries-dk, if different than your deployment machine.

5. Open the Quartus programmer GUI

  ```bash
  quartus_pgmw
  ```

  ![quartus_pgmw](/docs/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw.png)

1. Click **Hardware Setup** to open the Hardware Setup dialog window.

  1. In the **Currently selected hardware** field select the fseries-dk.

  2. In the **Hardware frequency** field enter `16000000` Hz

      ![quartus_pgmw_hardware_setup](/docs/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_hardware_setup.png)

  3. Click **Close**

2. In the **Quartus Prime Programmer** window, click **Auto Detect**.

3. If prompted, select the AGFB027R24C2E2VR2 device. The JTAG chain should show the device.

  ![quartus_pgmw_device_chain](/docs/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_device_chain.png)

9. Right click the AGFB027R24C2E2VR2 row and selct **Change File**.

  ![quartus_pgmw_change_file](/docs/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_change_file.png)

1.  In the **Select New Programming File** window that opens, select  `ofs_top_hps.sof` and click **Open**.

2.  Check the **Program/Configure** box for the AGFB027R24C2E2VR2 row, then click **Start**. Wait for the **Progress** bar to show `100% (Success)`.

  ![quartus_pgmw_success](/docs/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_success.png)

12. Close the Quartus Programmer GUI.

13. Switch to the deployment environment, if different than the JTAG connected machine.

14. Replug the board PCIe

  ```bash
  sudo pci_device b1:00.0 plug
  ```

15. Run `fpgainfo fme` to verify communication with the board, and to check the PR Interface ID.

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
  Bitstream Id                     : 360571655976424377
  Bitstream Version                : 5.0.1
  Pr Interface Id                  : d8fd88a7-8683-57ba-8be6-a1e058b7d4ed
  Boot Page                        : N/A
  ```

  >**Note:** The errors related to the BMC are the result of the OFS BMC not being present on the fseries-dk design. These will be removed in a future release.

### 1.6 F-tile Development Kit Installation Procedure

The following instructions will help ensure safe installation of the F-tile Development Kit into a supported server platform. Safety and Regulatory information can be found under the [product page](https://www.intel.com/content/www/us/en/docs/programmable/739942/current/safety-and-regulatory-information.html) for this development kit. It is assumed you have previously removed the light pipes mounted above the platform's QSFP cages before attempting to slot into a server mounted riser.

1. Position the board over the selected connector on the motherboard
2. Press down gently and firmly seat the card in a PCIe slot. Depending on the server model being used, you may need to secure a retention screw or rotate retention clips over the development kit's faceplate.
3. Do not bend the card while inserting in a slot. Do not apply too much pressure while inserting.
4. Plug a standard 2x4 auxiliary power cord available from the server's ATX power supply or from the riser itself to the respective matching power connected on the board (J11). Both the PCIe slot and auxiliary PCIe power cable are required to power the entire board.
5. If you haven't already, follow the instructions in section [1.5 F-tile Development Kit JTAG Setup](#15--envftile_dk_model--jtag-setup) and connect a USB Blaster II Cable from the board to the server housing it.

The EMIF subsystem and base FIM in this release do not work with the RDIMM memory installed in the Agilex 7 FPGA F-Series Development Kit. The RDIMM memory must be removed and replaced. The following RDIMM memory module(s) are known to work with this platform:

| Amount | Type | Link|
| --- | --- | --- |
|2 |DDR4-2400| https://memory.net/product/mta9asf1g72az-2g3-micron-1x-8gb-ddr4-2400-udimm-pc4-19200t-e-single-rank-x8-module/ |

## 2.0 OFS Stack Architecture Overview for Reference Platform

### 2.1 Hardware Components

The OFS hardware architecture decomposes all designs into a standard set of modules, interfaces, and capabilities. Although the OFS infrastructure provides a standard set of functionality and capability, the user is responsible for making the customizations to their specific design in compliance with the specifications outlined in the [FPGA Interface Manager Technical Reference Manual: Intel Open FPGA Stack for Intel Agilex FPGA](/hw/n6001/reference_manuals/mnl_fim_ofs_n6001.md).

OFS is a hardware and software infrastructure that provides an efficient approach to developing a customer FPGA-based platform or workload using an Intel, 3rd party, or custom board.

#### 2.1.1 FPGA Interface Manager

![F-tile-PCIe-Attach](./images/F-tile-PCIe-Attach.png)

The FPGA Interface Manager (FIM), or shell of the FPGA provides platform management functionality, clocks, resets, and interface access to the host and peripheral features on the acceleration platform. The OFS architecture for Intel Agilex 7 FPGA provides modularity, configurability, and scalability. The primary components of the FPGA Interface Manager or shell of the reference design are:

* PCIe Subsystem - a hierarchical design that targets the P-tile PCIe hard IP and is configured to support Gen4 speeds and Arm AXI4-Stream Data Mover functional mode.
* Ethernet Subsystem - provides portability to different Ethernet configurations across platforms and generations and reusability of the hardware framework and software stack.
* Memory Subsystem - composed of 5 DDR4 channels; two HPS DDR4 banks, x40 (x32 Data and x8 ECC), 1200 MHz, 1GB each, and four Fabric DDR4 banks, x32 (no ECC), 1200 MHz, 4GB
* Hard Processor System - 64-bit quad core ARM® Cortex*-A53 MPCore with integrated peripherals.
* Reset Controller
* FPGA Management Engine - Provides a way to manage the platform and enable acceleration functions on the platform.
* AFU Peripheral Fabric for AFU accesses to other interface peripherals
* Board Peripheral Fabric for master to slave CSR accesses from Host or AFU
* Platform Management Controller Interface (PMCI) to the board management controller

The FPGA Management Engine (FME) provides management features for the platform and the loading/unloading of accelerators through partial reconfiguration. Each feature of the FME exposes itself to the kernel-level OFS drivers on the host through a Device Feature Header (DFH) register that is placed at the beginning of Control Status Register (CSR) space. Only one PCIe link can access the FME register space in a multi-host channel design architecture at a time.

*Note: For more information on the FIM and its external connections, refer to the [FPGA Interface Manager Technical Reference Manual: Intel Open FPGA Stack for Intel Agilex FPGA](/hw/n6001/reference_manuals/mnl_fim_ofs_n6001.md).*

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

*Note: For more information on the Platform Interface Manager and AFU development and testing, refer to the [AFU Development Guide: OFS for Intel® Agilex® PCIe Attach FPGAs](/hw/n6001/dev_guides/ug_dev_afu_ofs_n6001.md).*

### 2.2 OFS Software Overview

The responsibility of the OFS kernel drivers is to act as the lowest software layer in the FPGA software stack, providing a minimalist driver implementation between the host software and functionality that has been implemented on the development platform. This leaves the implementation of IP-specific software in user-land, not the kernel. The OFS software stack also provides a mechanism for interface and feature discovery of FPGA platforms.

The OPAE SDK is a software framework for managing and accessing programmable accelerators (FPGAs). It consists of a collection of libraries and tools to facilitate the development of software applications and accelerators. The OPAE SDK resides exclusively in user-space, and can be found on the [OPAE SDK Github](https://github.com/OFS/opae-sdk/releases/tag/2.10.0-1).

The OFS drivers decompose implemented functionality, including external FIM features such as HSSI, EMIF and SPI, into sets of individual Device Features. Each Device Feature has its associated Device Feature Header (DFH), which enables a uniform discovery mechanism by software. A set of Device Features are exposed through the host interface in a Device Feature List (DFL). The OFS drivers discover and "walk" the Device Features in a Device Feature List and associate each Device Feature with its matching kernel driver.

In this way the OFS software provides a clean and extensible framework for the creation and integration of additional functionalities and their features.

*Note: A deeper dive on available SW APIs and programming model is available in the [Software Reference Manual: Intel® Open FPGA Stack](/hw/common/reference_manual/ofs_sw/mnl_sw_ofs.md), on [kernel.org](https://docs.kernel.org/fpga/dfl.html?highlight=fpga), and through the [Linux DFL wiki pages](https://github.com/OFS/linux-dfl/wiki).*

## 3.0 OFS DFL Kernel Drivers

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks like DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality. An in depth look at the various aspects of the driver architecture such as the API, an explanation of the DFL framework, and instructions on how to port DFL driver patches to other kernel distributions can be found on https://github.com/OPAE/linux-dfl/wiki.

An in-depth review of the Linux device driver architecture can be found on [opae.github.io](https://opae.github.io/latest/docs/drv_arch/drv_arch.html).

The DFL driver suite can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2).

### 3.1 OFS DFL Kernel Driver Installation Environment Setup

All OFS DFL kernel driver primary release code resides in the [Linux DFL GitHub repository](https://github.com/OFS/linux-dfl). This repository is open source and should not require any permissions to access. It includes a snapshot of the Linux kernel with the OFS driver included in `/drivers/fpga/*`. Downloading, configuration, and compilation will be discussed in this section. Refer back to section [1.2.3 Host Server Kernel and GRUB Configuration](#123-host-server-kernel-and-grub-configuration) for a list of supported Operating System(s).

You can choose to install the DFL kernel drivers by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2), skip to section [3.3 Installing the OFS DFL Kernel Drivers from Pre-Built Packages](#33-installing-the-ofs-dfl-kernel-drivers-from-pre-built-packages). Regardless of your choice you will need to follow the steps in this section to prepare your server for installation.

This installation process assumes the user has access to an internet connection to clone specific GitHub repositories, and to satisfy package dependencies.

1. It is recommended you lock your Red Hat release version to 8.6 to prevent accidental upgrades. Update installed system packages to their latest versions.

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
    
    sudo dnf install python3 python3-pip python3-devel python3-jsonschema python3-pyyaml git gcc gcc-c++ make cmake libuuid-devel json-c-devel hwloc-devel tbb-devel cli11-devel spdlog-devel libedit-devel systemd-devel doxygen python3-sphinx pandoc rpm-build rpmdevtools python3-virtualenv yaml-cpp-devel libudev-devel libcap-devel numactl-devel
    
    python3 -m pip install --user jsonschema virtualenv pudb pyyaml setuptools pybind11

    # If setuptools and pybind11 were already installed

    python3 -m pip install --upgrade --user pybind11 setuptools
    ```

### 3.2 Building and Installing the OFS DFL Kernel Drivers from Source

It is recommended you create an empty top level directory for your OFS related repositories to keep the working environment clean. All steps in this installation will use a generic top-level directory at `/home/OFS/`. If you have created a different top-level directory, replace this path with your custom path.

1\. Initialize an empty git repository and clone the DFL driver source code:

    ```bash
    mkdir /home/OFS/
    cd /home/OFS/
    git init
    git clone https://github.com/OFS/linux-dfl
    cd /home/OFS/linux-dfl
    git checkout tags/ofs-2023.3-6.1-3
    ```

    *Note: The linux-dfl repository is roughly 5 GB in size.*

2\. Verify that the correct tag/branch have been checked out.
    
    ```bash
    git describe --tags
    ofs-2023.3-6.1-3
    ```
    
    *Note: If two different tagged releases are tied to the same commit, running git describe tags may report the other release's tag. This is why the match is made explicit.*

3\. Copy an existing kernel configuration file from `/boot` and apply the minimal required settings changes.
    
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
    make olddefconfig
    ```

4\. The above command may report errors resembling `symbol value 'm' invalid for CHELSIO_IPSEC_INLINE`. These errors indicate that the nature of the config has changed between the currently executing kernel and the kernel being built. The option "m" for a particular kernel module is no longer a valid option, and the default behavior is to simply turn the option off. However, the option can likely be turned back on by setting it to 'y'. If the user wants to turn the option back on, change it to 'y' and re-run "make olddefconfig":
    
    ```bash
    cd /home/OFS/linux-dfl
    echo 'CONFIG_CHELSIO_IPSEC_INLINE=y' >> .config
    make olddefconfig
    ```
    
    *Note: To use the built-in GUI menu for editing kernel configuration parameters, you can opt to run `make menuconfig`.*
    
5\. Linux kernel builds take advantage of multiple processors to parallelize the build process. Display how many processors are available with the `nproc` command, and then specify how many make threads to utilize with the -j option. Note that number of threads can exceed the number of processors. In this case, the number of threads is set to the number of processors in the system.
    
    ```bash
    cd /home/OFS/linux-dfl
    make -j $(nproc)
    ```
    
6\. You have two options to build the source:

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
    make INSTALL_MOD_STRIP=1 binrpm-pkg
    ```
    
    By default, a directory is created in your home directory called `rpmbuild`. This directory will house all the kernel packages which have been built. You need to navigate to the newly built kernel packages and install them. The following files were generated using the build command executed in the previous step:
    
    ```bash
    cd ~/rpmbuild/RPMS/x86_64
    ls
    kernel-6.1.41_dfl.x86_64.rpm  kernel-headers-6.1.41_dfl.x86_64.rpm
    sudo dnf localinstall kernel*.rpm
    ```
    
7\. The system will need to be rebooted in order for changes to take effect. After a reboot, select the newly built kernel as the boot target. This can be done pre-boot using the command `grub2-reboot`, which removes the requirement for user intervention. After boot, verify that the currently running kernel matches expectation.
    
    ```bash
    uname -r
    6.1.41-dfl
    ```

8\. Verify the DFL drivers have been successfully installed by reading version information directly from `/lib/modules`. Recall that the name of the kernel built as a part of this section is 6.1.41-dfl. If the user set a different name for their kernel, change this path as needed:
    
    ```bash
    cd /usr/lib/modules/6.1.41-dfl/kernel/drivers/fpga
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

9\. Two kernel parameters must be added to the boot command line for the newly installed kernel. First, open the file `grub`:
    
    ```bash
    sudo vim /etc/default/grub
    ```

10\. In the variable *GRUB_CMDLINE_LINUX* add the following parameters in bold: GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet **intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200**".
    
    *Note: If you wish to instead set hugepages on a per session basis, you can perform the following steps. These settings will be lost on reboot.*
    
    ```bash
    mkdir -p /mnt/huge 
    mount -t hugetlbfs nodev /mnt/huge 
    echo 2048 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages 
    echo 2048 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages 
    ```
    
11\. Save your edits, then apply them to the GRUB2 configuration file.
    
    ```bash
    sudo grub2-mkconfig
    ```

12\. Warm reboot. Your kernel parameter changes should have taken affect.
    
    ```bash
    cat /proc/cmdline
    BOOT_IMAGE=(hd1,gpt2)/vmlinuz-6.1.41-dfl root=/dev/mapper/cl-root ro crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200 rhgb quiet
    ```

    A list of all DFL drivers and their purpose is maintained on the [DFL Wiki](https://github.com/OFS/linux-dfl/wiki/FPGA-DFL-Driver-Modules#fpga-driver-modules).

### 3.3 Installing the OFS DFL Kernel Drivers from Pre-Built Packages

To use the pre-built Linux DFL packages, you first need to download the files from the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2). You can choose to either install using the SRC RPMs, or to use the pre-built RPM packages targeting the official supported release platform.

```bash
tar xf kernel-6.1.41_dfl-1.x86_64-<<version>>.tar.gz

sudo dnf localinstall kernel-6.1.41_dfl_<<version>>.x86_64.rpm \
kernel-devel-6.1.41_dfl_<<version>>.x86_64.rpm \
kernel-headers-6.1.41_dfl_<<version>>.x86_64.rpm

### OR

sudo dnf localinstall kernel-6.1.41_dfl_<<version>>.src.rpm
```

## 4.0 OPAE Software Development Kit

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit [opae.github.io](https://opae.github.io/latest/index.html).

The OPAE SDK source code is contained within a single GitHub repository hosted at the [OPAE Github](https://github.com/OFS/opae-sdk/releases/tag/2.10.0-1). This repository is open source and does not require any permissions to access.

You can choose to install the OPAE SDK by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2), skip to section [4.3 Installing the OPAE SDK with Pre-built Packages](#44-installing-the-opae-sdk-with-pre-built-packages). Regardless of your choice you will need to follow the steps in this section to prepare your server for installation.

You may also choose to use the supplied Python 3 installation script. This script ships with a README detailing execution instructions on the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2).

### 4.1 OPAE SDK Installation Environment Setup

This installation process assumes you have access to an internet connection in order to pull specific GitHub repositories, and to satisfy package dependencies.

#### Table 6: OPAE Package Description
        
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
    git checkout tags/2.10.0-1
    ```

3. Verify that the correct tag/branch have been checkout out.

    ```bash
    git describe --tags
    2.10.0-1
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
    
    dnf install --enablerepo=codeready-builder-for-rhel-8-x86_64-rpms -y python3 python3-pip python3-devel python3-jsonschema python3-pyyaml git gcc gcc-c++ make cmake libuuid-devel json-c-devel hwloc-devel tbb-devel cli11-devel spdlog-devel libedit-devel systemd-devel doxygen python3-sphinx pandoc rpm-build rpmdevtools python3-virtualenv yaml-cpp-devel libudev-devel libcap-devel make
    
    pip3 install --upgrade --prefix=/usr pip setuptools pybind11
    
    ./opae-sdk/packaging/opae/rpm/create unrestricted
    
    exit
    ```
    
    The following packages will be built in the same directory as `create`:


5. Install the packages you just created.
    
    ```bash
    cd /home/OFS/opae-sdk/packaging/opae/rpm
    rm -rf opae-2.10.0-1.el8.src.rpm 
    sudo dnf localinstall -y opae*.rpm
    ```

6. Check that all packages have been installed and match expectation:
    
    ```bash
    rpm -qa | grep opae
    opae-2.8.0-1.el8.x86_64.rpm
    opae-debuginfo-2.8.0-1.el8.x86_64.rpm
    opae-debugsource-2.8.0-1.el8.x86_64.rpm
    opae-devel-2.8.0-1.el8.x86_64.rpm
    opae-devel-debuginfo-2.8.0-1.el8.x86_64.rpm
    opae-extra-tools-2.8.0-1.el8.x86_64.rpm
    opae-extra-tools-debuginfo-2.8.0-1.el8.x86_64.rpm
    ```

### 4.2 Installing the OPAE SDK with Pre-Built Packages

You can skip the entire build process and use a set of pre-built binaries supplied by Intel. Visit the [OFS 2023.3 Release Page](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2023.3-2) and navigate to the bottom of the page, under the Assets tab you will see a file named opae-2.10.0-1.x86_64-<<date>>_<<build>>.tar.gz. Download this package and extract its contents:

```bash
tar xf opae-2.10.0-1.x86_64-<<date>>_<<build>>.tar.gz
```

For a fast installation you can delete the source RPM as it isn't necessary, and install all remaining OPAE RPMs:

```bash
rm opae-*.src.rpm
sudo dnf localinstall opae*.rpm
```

### 4.3 FPGA Device Access Permissions

Access to FPGA accelerators and devices is controlled using file access permissions on the Intel® FPGA device files, /dev/dfl-fme.* and /dev/dfl-port.*, as well as to the files reachable through /sys/class/fpga_region/.

In order to allow regular (non-root) users to access accelerators, you need to grant them read and write permissions on /dev/dfl-port.* (with * denoting the respective socket, i.e. 0 or 1). E.g.:


```bash
sudo chmod a+rw /dev/dfl-port.0
```


### 4.4 Memlock limit

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


### 4.5 OPAE Tools Overview

The following section offers a brief introduction including expected output values for the utilities included with OPAE. A full explanation of each command with a description of its syntax is available in the [opae-sdk GitHub repo](https://github.com/OPAE/opae-sdk/blob/2.10.0-1/doc/src/fpga_tools/readme.md).

A list of all tools included in the OPAE SDK release can be found on the [OPAE FPGA Tools](https://ofs.github.io/ofs-2023.1/sw/fpga_tools/fpgadiag/) tab of ofs.github.io.

#### 4.5.1 Board Management with fpgainfo

The **fpgainfo** utility displays FPGA information derived from sysfs files.

Displays FPGA information derived from sysfs files. The command argument is one of the following: errors, power, temp, port, fme, bmc, phy or mac, security. Some commands may also have other arguments or options that control their behavior.

For systems with multiple FPGA devices, you can specify the BDF to limit the output to the FPGA resource with the corresponding PCIe configuration. If not specified, information displays for all resources for the given command.

*Note: Your Bitstream ID and PR Interface Id may not match the below examples.*

The following examples walk through sample outputs generated by `fpgainfo`. As the F-tile Development Kit does not contain a traditional BMC as used by other OFS products, those lines in `fpgainfo`'s output will not return valid objects. The subcommand `fpgainfo bmc` will likewise fail to report telemetry data.

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
Bitstream Id                     : 0x501020241BF165B
Bitstream Version                : 5.0.1
Pr Interface Id                  : b4eda250-cdb7-5891-a06e-13d28d09bc32
Boot Page                        : N/A
```

#### 4.5.2 Updating with fpgasupdate

The **fpgasupdate** tool is used to program AFU workloads into an open slot in a FIM. The **fpgasupdate** tool only accepts images that have been formatted using PACsign.

As the F-tile Development Kit does not contain a traditional BMC, you do not have access to a factory, user1, and user2 programmed image for both the FIM and BMC FW and RTL. Only the programming of a GBS workload is supported for this release.

The process of programming a SOF with a new FIM version is shown in section [1.5 F-tile Development Kit JTAG Setup](#15--envftile_dk_model--jtag-setup)

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

#### 4.5.3 Verify FME Interrupts with hello_events

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

#### 4.5.4 Host Exercisor Modules

The reference FIM and unchanged FIM compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. There are three HEMs present in the Intel OFS Reference FIM - HE-LPBK, HE-MEM, and HE-HSSI. These exercisers are tied to three different VFs that must be enabled before they can be used.
Execution of these exercisers requires you bind specific VF endpoint to **vfio-pci**. The host-side software looks for these endpoints to grab the correct FPGA resource.

Refer to the Intel [FPGA Interface Manager Technical Reference Manual: Intel Open FPGA Stack for Intel Agilex FPGA](/hw/n6001/reference_manuals/mnl_fim_ofs_n6001.md) for a full description of these modules.

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

##### 4.5.4.1 HE-MEM / HE-LB

The host exerciser used to exercise and characterize the various host-FPGA interactions eg. MMIO, Data transfer from host to FPGA , PR, host to FPGA memory etc. The Host Exerciser Loopback (HE-LBK) AFU can move data between host memory and FPGA.

HE-LBK supports:
- Latency (AFU to Host memory read)
- MMIO latency (Write+Read)
- MMIO BW (64B MMIO writes)
- BW (Read/Write, Read only, Wr only)

The Host Exerciser Loopback Memory (HE-MEM) AFU is used to exercise use of FPGA connected DDR, data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host.

**HE-LB** is responsible for generating traffic with the intention of exercising the path from the AFU to the Host at full bandwidth. **HE-MEM** is used to exercise use of FPGA connected DDR; data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host. **HE-MEM** uses external DDR memory (i.e. EMIF) to store data. It has a customized version of the AVMM interface to communicate with the EMIF memory controller. Both exercisers rely on the user-space tool host_exerciser. When using the F-tile Development Kit SmartNIC Platform, optimal performance requires the exercisers be run at 400 MHz.

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

##### 4.5.4.2 Traffic Generator AFU Test Application

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

##### 4.5.4.3 HE-HSSI

HE-HSSI is responsible for handling client-side ethernet traffic. It wraps the 10G and 100G HSSI AFUs and includes a traffic generator and checker. The user-space tool `hssi` exports a control interface to the HE-HSSI's AFU's packet generator logic.

The `hssi` application provides a means of interacting with the 10G and with the 100G HSSI AFUs. In both 10G and 100G operating modes, the application initializes the AFU, completes the desired transfer as described by the mode- specific options, and displays the ethernet statistics by invoking `ethtool --statistics INTERFACE`.

Due to Ethernet differential pair routing on the ES version of the Intel Agilex® 7 F-Series FPGA (Two F-Tiles) Development Kit, some differential pairs were swapped to improve signal routing.  To account for the pair swap, there is a requirement to run a script to invert the differential traces.  If you run the command “fpgainfo phy B:d.f” when the Ethernet ports are connected to known good sources and observe the following three ports are down as shown below:

```bash
sudo fpgainfo phy b1:00.0
Intel Acceleration Development Platform N6001
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
Bitstream Version                : 5.0.1
Pr Interface Id                  : b4eda250-cdb7-5891-a06e-13d28d09bc32
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

Create the following script called “set_tx_inverse_polarity.sh” to set make Transceiver PAM register settings:

```bash
#!/bin/sh

# Port 3
base_addr=$(printf "%08d" "0x500000")
address=`expr $base_addr + 589884`
#address=`expr $base_addr + 589884`
offset=`expr $address/4`

hex_number=$(printf "0x%06x" "$(($offset))")
echo $hex_number
cmd_sts=$(printf "%32x" "$(($offset2))")
csraddr="${hex_number}0500000002"
csraddr1="${hex_number}0600000001"
data=1a040
echo $csraddr
sudo opae.io poke  0x140b0 0x0001a26500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
sleep 1

sudo opae.io poke  0x140b0 0x0001226500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
# Port 6

base_addr=$(printf "%08d" "0xb00000")
address=`expr $base_addr + 589884`
#address=`expr $base_addr + 589884`
offset=`expr $address/4`

hex_number=$(printf "0x%06x" "$(($offset))")
echo $hex_number
cmd_sts=$(printf "%32x" "$(($offset2))")
csraddr="${hex_number}0500000002"
csraddr1="${hex_number}0600000001"
data=1a040
echo $csraddr
sudo opae.io poke  0x140b0 0x0001a16500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
sleep 1

sudo opae.io poke  0x140b0 0x0001216500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
# Port 7

base_addr=$(printf "%08d" "0x1100000")
address=`expr $base_addr + 589884`
#address=`expr $base_addr + 589884`
offset=`expr $address/4`

hex_number=$(printf "0x%06x" "$(($offset))")
echo $hex_number
cmd_sts=$(printf "%32x" "$(($offset2))")
csraddr="${hex_number}0500000002"
csraddr1="${hex_number}0600000001"
data=1a040
echo $csraddr
sudo opae.io poke  0x140b0 0x0001a26500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
sleep 1

sudo opae.io poke  0x140b0 0x0001226500000000
sleep 1
sudo opae.io poke  0x140a8 $csraddr
sleep 1
sudo opae.io peek  0x140a8
```

The script set_tx_inverse_polarity.sh requires the VFIO driver on PF0 to access the Transceiver registers.  You will use the opae.io command prior to running set_tx_inverse_polarity.sh to bind the VFIO driver.  Once the script completes, release the VFIO driver with opae.io release.  

The listing below shows the script being run:

```bash
sudo opae.io init -d 0000:b1:00.0 $USER
Unbinding (0x8086,0xbcce) at 0000:b1:00.0 from dfl-pci
Binding (0x8086,0xbcce) at 0000:b1:00.0 to vfio-pci
iommu group for (0x8086,0xbcce) at 0000:b1:00.0 is 8

sh set_tx_inverse_polarity.sh
0x16400f
0x16400f0500000002
0x16400f0500000006
0x16400f0500000006
0x2e400f
0x2e400f0500000002
0x2e400f0500000006
0x2e400f0500000006
0x46400f
0x46400f0500000002
0x46400f0500000006
0x46400f0500000006

sudo opae.io release -d 0000:b1:00.0
Releasing (0x8086,0xbcce) at 0000:b1:00.0 from vfio-pci
Rebinding (0x8086,0xbcce) at 0000:b1:00.0 to dfl-pci

sudo fpgainfo phy b1:00.0
Intel Acceleration Development Platform N6001
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
Bitstream Version                : 5.0.1
Pr Interface Id                  : 767712e5-b1d0-5777-aea9-592572a6817f
QSFP0                            : Connected
QSFP1                            : Connected
//****** HSSI information ******//
HSSI version                     : 2.0
Number of ports                  : 8
Port0                            :25GbE        UP
Port1                            :25GbE        UP
Port2                            :25GbE        UP
Port3                            :25GbE        UP
Port4                            :25GbE        UP
Port5                            :25GbE        UP
Port6                            :25GbE        UP
Port7                            :25GbE        UP
```

The following example walks through the process of binding the VF corresponding with the HE-HSSI exerciser to vfio-pci, sending traffic, and verifying that traffic was received.

###### Table 8: Accelerator PF/VF and GUID Mappings

| Component| VF| Accelerator GUID|
| -----| -----| -----|
| F Series Dev Kit base PF| XXXX:XX:XX.0| N/A|
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
    IIntel Acceleration Development Platform N6001
    Board Management Controller NIOS FW version: 3.15.0
    Board Management Controller Build version: 3.15.0
    //****** FME ******//
    Object Id                        : 0xED00001
    PCIe s:b:d.f                     : 0000:B1:00.0
    Vendor Id                        : 0x8086
    Device Id                        : 0xBCCE
    SubVendor Id                     : 0x8086
    SubDevice Id                     : 0x1771
    Socket Id                        : 0x00
    Ports Num                        : 01
    Bitstream Id                     : 00x50102023508A422
    Bitstream Version                : 5.0.1
    Pr Interface Id                  : 1d6beb4e-86d7-5442-a763-043701fb75b7
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