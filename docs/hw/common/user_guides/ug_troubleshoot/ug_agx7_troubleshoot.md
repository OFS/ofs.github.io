# Troubleshooting Guide for OFS Agilex™ 7 PCIe Attach FPGAs

Last updated: **February 26, 2025** 





## **1 Introduction**

### **1.1 About This Document**

This document serves as a guide for troubleshooting the implementation of OFS designs. It describes how to identify and resolve common issues that may be encountered when using OFS designs. This document is structured to mirror the flows described in [FPGA Developer Journey Guide] and [Software Developer Journey Guide].

#### **1.1.1 Knowledge Pre-Requisites**

It is recommended that you have the following knowledge and skills before using this developer guide.

* Basic understanding of OFS and the difference between OFS designs. Refer to the [OFS Welcome Page](https://ofs.github.io/ofs-2024.3-1).
* Review the [release notes](https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.3-1) for the Agilex 7 PCIe Attach Reference Shells, with careful consideration of the **Known Issues**.
* FPGA compilation flows using Quartus® Prime Pro Edition.
* Static Timing closure, including familiarity with the Timing Analyzer tool in Quartus® Prime Pro Edition, applying timing constraints, Synopsys* Design Constraints (.sdc) language and Tcl scripting, and design methods to close on timing critical paths.
* RTL (System Verilog) and coding practices to create synthesized logic.
* RTL simulation tools.
* Quartus® Prime Pro Edition Signal Tap Logic Analyzer tool software.

#### **1.1.2 Known Issues**

The following table describes the known issues in the OFS 2024.3 release.

| ID | Known Issues | Workaround | Status | Platform Target Affected |
| --- | --- | --- | --- | --- |
| 14024332744 | DRC High Severity Warnings reported in default OFS shell compilation reports | None; you may ignore these warnings. | Planned to be fixed in a future release | All |
| - | The Unit Test `hssi_test` hangs for F-tile HSSI configurations | None | Planned to be fixed in a future release | F-Series Development Kit \| I-Series Development Kit |
| 16024552556 | Partial Reconfiguration Region Root Key Hash (RKH) reports incorrect value after SR RKH update. | Update the PR RKH after updating the SR RKH for the PR SDM root entry hash to report the proper PR RKH value. | Planned to be fixed in a future release | N6000 \| N6001 |
| 16024552556 | Static Region Root Key Hash (SR RKH) fails programming when using vabtool; reports error `Could not glob sdm SR provision status. Sysfs node not found` | Increase the delay when running the rsu command in the [vabtool](https://github.com/OFS/opae-sdk/blob/master/binaries/vabtool/vabtool) file by changing line 338 from `--wait 20` to `--wait 100`. Note that it can take up to 60 seconds after the rsu command for the SR and PR hash to update. | Planned to be fixed in a future release | N6000 \| N6001 |
| 14024356807 | High peak memory usage above 100+ GB during OFS compilation causes compilation to fail on systems that do not have sufficient RAM | It is suggested that your system has at least 128 GB of RAM for OFS design compilations. | Planned improvement in future release | All |
| 14024356732 | Dangling PTP Signals in the reference FIM RTL | None. These signals are provided as a reference, but are not used in the OFS reference designs and can be ignored. | Planned to be removed in a future release of OFS | All |
| 14024311787 | Hold time violation inside Memory Subsystem in fseries-dk. | None. Customers using the External Memory Interfaces for Agilex<sup>&trade;</sup> Agilex 7 F-series devices may notice minor hold-time violations in the periphery-to-core transfer of the “Report DDR” timing report when placing the address-command pins in the bottom half of the device (Banks 2A/2B/2E/2F/2C/2D), in Quartus Prime Pro versions 24.1-24.3.1.  These violations can be safely ignored provided there are fewer than 10 violations per memory interface, the violations only appear for the Fast timing conditions, and the violations do not exceed 30ps in magnitude. | Planned fix in a future Quartus version | F-Series Development Kit |
| 14024366703 | UVM tests `mem_tg_cst_test` and `mem_tg_traffic_gen_test` are not supported. | None | Planned fix in a future release of OFS | N6001 \| F-Series Development Kit |
| - | UVM is not supported for fseries-dk 200G and 400G configurations | None | Planned fix in a future release of OFS | F-Series Development Kit |
| 14020476585 | The Quartus fitter fails when building the PCIe Attach F-tile FIM with ECC enabled on Memory channels 0 and 1 | None | Planned fix in a future release of OFS | F-Series Development Kit |
| 14021039281 | Currently there are three errors included as part of the output from the OPAE SDK command "fpgainfo errors all" that are not applicable to current platforms. These include PCIe0 Errors, PCIe1 Errors, and First Malformed Req. All three outputs may be safely ignored. | None | Planned fix in a future release of OFS. | All |
| - | R-tile Agilex™ PCIe Attach Reference FIM does not support UVM simulation.  Only unit test simulation is available. | None | Planned fix in a future release of OFS | I-Series Development Kit |
| - | The UVM Copy Engine tests fail to build which results in all CE UVM tests to fail. | None | Planned fix in a future release of OFS | N6001 \| F-Series Development Kit |
| 16024716667 | The UVM simulation gets stuck on HSSI tx_pkx and rx_pkg tests when targeting the F-series Development Kit. | None | Planned fix in a future release of OFS | F-Series Development Kit |
| 14021146060 | The R-Tile PCIe attach design requires a 16550 UART IP license file to be installed in Quartus Prime Pro even though it is not used in the design. | None | Planned fix in a future release of OFS | I-Series Development Kit |
| 14020129685 | The hssi bandwidth reporting is currently not supported when FIM Ethernet configuration uses 100GbE. | None | Planned fix in a future release of OFS. | Intel® FPGA SmartNIC N6000/1-PL |
| 14018364039 | The OPAE command fpgainfo bmc and fpgainfo temp display a "CVL" field that is not utilized by the N6001 design. | None. Ignore "CVL" listings. | No future fix | Intel® FPGA SmartNIC N6001-PL |
| 14021023150 | The fpgainfo phy command reports QSFP as not connected even if Ethernet ports are up because QSFP status is not routed to the FPGA in the Development Kit. | Refer to the Port<x> Status listed in the command to observe the link status. | No future fix | F-Tile Development Kit \| I-Series Development Kit |
| 15016269892 | PCIe Link Speed does not downgrade to Gen3 or Gen4 on I-Series DevKit FIM when built with the Gen5 configuration. | If PCIe Gen4 is required, generate the iseries-dk FIM with PCIe Gen4. This can be done with the [$OFS_ROOTDIR/tools/ofss_config/pcie/pcie_host_gen4.ofss](https://github.com/OFS/ofs-agx7-pcie-attach/blob/release/ofs-2024.3/tools/ofss_config/pcie/pcie_host_gen4.ofss) There is no provided fix for Gen3. | No future fix | I-Series Development Kit |


## **2 Troubleshooting the OFS FPGA Developer Flow**









### **2.5 Building the Shell**

#### **2.5.1 Issue: FIM build fails with fitter error**

##### **Potential Root Cause #1:**

* Description: A fitter error occurs when attempting to build the minimal FIM with HSSI enabled. The minimal FIM has an optimized floorplan which can not compensate for the HSSI being enabled.
* Applicable Boards: n6001, iseries-dk
* Symptoms: The following is an example error that may be seen:

  ```
  Error (21951): Fitter is having difficulty packing from clock region sectors (0,2) to (5,7) due to high LAB utilization. 2050 LABs are required but only 1419 LABs are available exclusively for that region.
  ```

* Status: Expected Behavior
* Troubleshooting Steps:
  1. Ensure the `no_hssi` option is used when building the shell. For example:

    ```
    ./ofs-common/scripts/common/syn/build_top.sh -p --ofss tools/ofss_config/pcie/pcie_host_2link_1pf_1vf.ofss iseries-dk:no_hssi work_iseries_dk_minimal_fim
    ```

#### **2.5.2 Issue: OFS Build Script Fails**

##### **Potential Root Cause #1:**

* Description: When running the `build_top.sh` script, it fails during the IP Deploy because it is attempting to use a display.
* Applicable Designs: All
* Symptoms: The following errors may be seen:

  ```
  !!FAIL!! IP Deploy Failed!!
  ```

  ```
  Error: apply_component_preset iseries-dk: Can't connect to X11 window server using 'localhost:10.0' as the value of the DISPLAY variable.
  ```

* Status: Known Issue
* Workaround:

  1. Check the value of your `$DISPLAY` environment variable

    ```bash
    echo $DISPLAY
    ```

    Example Output:

    ```bash
    localhost:10.0
    ```

  2. Unset the `DISPLAY` environment variable before running the build script.

    ```bash
    unset DISPLAY
    ```

  3. After the build script completes, you may set the `DISPLAY` environment variable to continue access to the display.

    ```bash
    export DISPLAY=localhost:10.0
    ```



### **2.7 Deploying the Shell**

#### **2.7.1 Issue: Static Region Root Key Hash (SR RKH) fails programming when using vabtool**

##### **Potential Root Cause #1:**

* Description: The Static Region Root Key Hash (SR RKH) may fail programming when using vabtool because the default delay during the operation is not sufficient.
* Applicable Boards: N6000, N6001 
* Symptoms: When running vabtool, for example:

  ```bash
  vabtool sr_key_provision 0000:b1:00.0 sr_rkh.bin ofs_top_hps_csk7_quartus_pac_signed.bin -y
  ```

  You may see the following error:

  ```bash
  /usr/bin/vabtool: line 347: fatal: Could not glob sdm SR provision status. Sysfs node not found.: syntax error in expression (error token is ": Could not glob sdm SR provision status. Sysfs node not found.")
  vabtool sr_status is:fatal: 0000:b1:00.0 is not a valid device.
  ```

* Status: Known Issue with planned future fix
* Workaround: Increase the delay when running the rsu command in the [vabtool](https://github.com/OFS/opae-sdk/blob/master/binaries/vabtool/vabtool) file:
  1. Change line 338 from `--wait 20` to `--wait 100`. Note that you may need to wait for up to 60 seconds after the rsu command for the SR and PR hash to update.

#### **2.7.2 Issue: Board does not enumerate on PCIe**

##### **Potential Root Cause #1:**

* Description: The I-Series development kit shell reference design can be configured for PCIe 1x16 or bifurcated 2x8. If the iseries-dk PCIe is not enumerating after programming the board, it may be because the server BIOS PCIe settings are configured differently than the PCIe subsystem in the design.
* Applicable Boards: iseries-dk
* Symptoms: After programming the iseries-dk, the fpgainfo command may report the following:

  ```
  $ fpgainfo fme
  main.c:263:main() **ERROR** : No FPGA resources found.
  ```

  The board is not reported when running `lspci`

* Status: Expected Behavior
* Troubleshooting Steps: 
  1. PCIe slot width must be set to your design's width (1x16, 2x8)
  2. PCIe slot generation must be set to your design's supported generation (4, 5)
  3. PCIe slot must have iommu enabled
  4. Intel VT for Directed I/O (VT-d) must be enabled

  Note that using 'auto' for PCIe training in the BIOS can potentially cause enumeration issues. It is recommended to manually set your PCIe slot bifurcation settings to exactly match those in the design.

## **3 Troubleshooting the OFS Software Developer Flow**









### **3.5 Deploying the Software Application**

#### **3.5.1 Issue: The FPGA can not be found by OPAE after configuration**

##### **Potential Root Cause #1:**

* Description: The OPAE version may be out of date. If the OPAE version is older than what the OFS design was built for, the design may not be recognized by OPAE.
* Applicable Boards: All
* Symptoms: After configuring the FPGA, you may see the expected PCIe endpoints. For example:
    
  ```
  lspci | grep bcce
  84:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
  84:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
  84:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
  85:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
  85:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
  85:00.2 Processing accelerators: Intel Corporation Device bcce (rev 01)
  ```

  However, the `fpgainfo fme` command shows no FPGA resources found. For example:

  ```
  $ fpgainfo fme
  main.c:263:main() **ERROR** : No FPGA resources found.
  ```

* Status: Expected Behavior
* Troubleshooting Steps:
  1. Update OPAE on the server to match the version of OPAE the OFS release was built for. The target OPAE version for each release can be found on the release page of each release.

#### **3.5.2 Issue: The hssi tool does not report bandwidth**

#####  **Potential Root Cause #1: **

* Description: Designs with 100GbE HSSI configurations don't support bandwidth reporting. Thus, the hssi bandwidth reporting is currently not supported when FIM Ethernet configuration uses 100GbE.
* Applicable Boards: N6001, N6000
* Symptoms: When running the `hssi` command, you may see the following message instead of reported bandwidth:

  ```
  mbox_write timed out [a]
  ```

* Status: Known Issue
* Workaround Steps: None. Planned fix in a future release of OFS.

## **4 Troubleshooting OFS Workloads**









### **4.5 Deploying the Workload**

#### **4.5.1 Issue: An error occurs when programming the GBS using fpgasupdate**

##### **Potential Root Cause #1:**

* Description: A GBS reconfiguration error may occur when programming a GBS using `fpgasupdate` if the version of Quartus programmer that was used to program the FPGA shell bitstream does not match the version of Quartus used to build that bitstream.
* Applicable Boards: All
* Symptoms: The following errors may be seen when using `fpgasupdate` to program a GBS.

    ```
    sudo fpgasupdate hello_world.gbs 84:00.0
    ```

    ```
    [ERROR] reconfc:353:xfpga_fpgaReconfigureSlot() **ERROR** : Failed to reconfigure bitstream: Connection timed out
    Error writing bitstream to FPGA: exception
    Partial Reconfiguration failed
    ```

* Status: Expected Behavior
* Troubleshooting Steps:
    1. Ensure you are using the same version of Quartus and Quartus Programmer when building the the shell, building the GBS, and configuring the shell in the FPGA. The version of Quartus used for each OFS release can be found in the release notes for that release.



## **Appendix**

### **Appendix A: Glossary**

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


## Notices & Disclaimers

Altera® Corporation technologies may require enabled hardware, software or service activation. No product or component can be absolutely secure. Performance varies by use, configuration and other factors. Your costs and results may vary. You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Altera or Intel products described herein. You agree to grant Altera Corporation a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein. No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Altera or Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document. The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request. Altera disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade. You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. © Altera Corporation. Altera, the Altera logo, and other Altera marks are trademarks of Altera Corporation. Other names and brands may be claimed as the property of others.

OpenCL* and the OpenCL* logo are trademarks of Apple Inc. used by permission of the Khronos Group™.






