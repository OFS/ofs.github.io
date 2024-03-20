# Software Installation Guide: Open FPGA Stack for PCIe Attach
Last updated: **March 20, 2024** 

## 1.0 About This Document

The purpose of this document is to help users get started in setting up their local environments and installing the most recent release of the PCIe Attach software stack on the host. This document will not cover the process of board installation or platform bring-up. After reviewing this document, a user shall be able to:

* Set up a server environment according to the Best Known Configuration (BKC)
* Build and install the OPAE Software Development Kit (SDK) on the host
* Build and install the Linux DFL driver stack on the host

### 1.1 Audience

The information in this document is intended for customers evaluating a PCIe Attach shell. The PCIe Attach shell design is supported on a number of board offerings, including the Agilex® 7 FPGA F-Series Development Kit (2x F-Tile), Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile), Intel® FPGA SmartNIC N6000/1-PL, and Intel® FPGA PAC D5005.

*Note: Code command blocks are used throughout the document. Comments are preceded with '#'. Full command output may not be shown for the sake of brevity.*

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


#### Table 2: Software and Component Version Summary for OFS PCIe Attach

The OFS PCIe Attach release is built upon tightly coupled software and Operating System version(s). The repositories listed below are where the source code resides for each of the components discussed in this document.

| Component | Version | Download Link |
| ----- | ----- | ----- |
| Host Operating System |  RedHat® Enterprise Linux® (RHEL) 8.6 | [link](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.6/x86_64/product-software) |
| OPAE SDK| [ 2.12.0-4 ]( https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4 ) | [ 2.12.0-4 ]( https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4 )|
| Linux DFL | [ofs-2024.1-6.1-2](https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2 ) | [ofs-2024.1-6.1-2](https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2) |

#### Table 3: Release Page(s) for each PCIe Attach Platform

This is a comprehensive list of the platform(s) whose software build and installation steps are covered in this document.

|Platform|Release Page Link|
| ----- | ----- |
| Stratix 10® FPGA | https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1 |
| Intel® FPGA SmartNIC N6001-PL |https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1 |
| Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) | https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1|
| Agilex® 7 FPGA I-Series Development Kit (2x R-Tile and 1xF-Tile)|https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1 |

### 1.2 Server Requirements

#### 1.2.1 Host BIOS

These are the host BIOS settings required to work with the OFS stack, which relies on SR-IOV for some of its functionality. Information about any given server's currently loaded firmware and BIOS settings can be found through its remote access controller, or by manually entering the BIOS by hitting a specific key during power on. Your specific server platform will include instructions on proper BIOS configuration and should be followed when altering settings. Ensure the following has been set:

- Intel VT for Directed I/O (VT-d) must be enabled

Specific BIOS paths are not listed here as they can differ between BIOS vendors and versions.

#### 1.2.2 Host Server Kernel and GRUB Configuration

While many host Linux kernel and OS distributions may work with this design, only the following configuration(s) have been tested. You will need to download and install the OS on your host of choice; we will build the required kernel alongside the Linux DFL driver set.

* OS: RedHat® Enterprise Linux® (RHEL) 8.6
* Kernel: 6.1-lts

### 2.0 OFS Software Overview

The responsibility of the OFS kernel drivers is to act as the lowest software layer in the FPGA software stack, providing a minimalist driver implementation between the host software and functionality that has been implemented on the development platform. This leaves the implementation of IP-specific software in user-land, not the kernel. The OFS software stack also provides a mechanism for interface and feature discovery of FPGA platforms.

The OPAE SDK is a software framework for managing and accessing programmable accelerators (FPGAs). It consists of a collection of libraries and tools to facilitate the development of software applications and accelerators. The OPAE SDK resides exclusively in user-space, and can be found on the [OPAE SDK Github](https://github.com/OFS/opae-sdk).

The OFS drivers decompose implemented functionality, including external FIM features such as HSSI, EMIF and SPI, into sets of individual Device Features. Each Device Feature has its associated Device Feature Header (DFH), which enables a uniform discovery mechanism by software. A set of Device Features are exposed through the host interface in a Device Feature List (DFL). The OFS drivers discover and "walk" the Device Features in a Device Feature List and associate each Device Feature with its matching kernel driver.

In this way the OFS software provides a clean and extensible framework for the creation and integration of additional functionalities and their features.

*Note: A deeper dive on available SW APIs and programming model is available in the [Software Reference Manual: Open FPGA Stack](/hw/common/reference_manual/ofs_sw/mnl_sw_ofs.md), on [kernel.org](https://docs.kernel.org/fpga/dfl.html?highlight=fpga), and through the [Linux DFL wiki pages](https://github.com/OFS/linux-dfl/wiki).*

## 3.0 OFS DFL Kernel Drivers

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks like DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality. An in depth look at the various aspects of the driver architecture such as the API, an explanation of the DFL framework, and instructions on how to port DFL driver patches to other kernel distributions can be found on [https://github.com/OPAE/linux-dfl/wiki](https://github.com/OPAE/linux-dfl/wiki).

An in-depth review of the Linux device driver architecture can be found on [opae.github.io](https://opae.github.io/latest/docs/drv_arch/drv_arch.html).

The DFL driver suite can be automatically installed using a supplied Python 3 installation script. This script ships with a README detailing execution instructions, and currently only supported the PCIe Attach release. Its usage is detailed in the relevant Quick Start Demonstration Guideline for your platform and will not be covered here.

### 3.1 OFS DFL Kernel Driver Installation Environment Setup

All OFS DFL kernel driver primary release code resides in the [Linux DFL GitHub repository](https://github.com/OFS/linux-dfl). This repository is open source and does not require any special permissions to access. It includes a snapshot of the Linux kernel with *most* of the OFS DFL drivers included in `/drivers/fpga/*`. Download, configuration, and compilation will be discussed in this section. Refer back to section [1.2.2 Host Server Kernel and GRUB Configuration](#122-host-server-kernel-and-grub-configuration) for a list of supported Operating System(s).

You can choose to install the DFL kernel drivers by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on your platform's release page, skip to section [3.3 Installing the OFS DFL Kernel Drivers from Pre-Built Packages](#33-installing-the-ofs-dfl-kernel-drivers-from-pre-built-packages). Regardless of your choice you will need to follow the two steps in this section to prepare your server environment for installation.

This installation process assumes the user has access to an internet connection to clone specific GitHub repositories, and to satisfy package dependencies.

1. It is recommended you lock your Red Hat release version to 8.6 to prevent accidental upgrades. Update installed system packages to their latest versions. We need to enable the code-ready-builder and EPEL repositories.

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
    
    sudo dnf install python3 python3-pip python3-devel python3-jsonschema python3-pyyaml git gcc gcc-c++ make cmake libuuid-devel json-c-devel hwloc-devel tbb-devel cli11-devel spdlog-devel libedit-devel systemd-devel doxygen python3-sphinx pandoc rpm-build rpmdevtools python3-virtualenv yaml-cpp-devel libudev-devel libcap-devel numactl-devel bison flex
    
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
    git checkout tags/ofs-2024.1-6.1-2
    ```

    *Note: The linux-dfl repository is roughly 5 GB in size.*

2\. Verify that the correct tag/branch have been checked out.

    ```bash
    git describe --tags
    ofs-2024.1-6.1-2
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

*Note:* If you wish to add an identifier to the kernel build, edit .config and make your additions to the line CONFIG_LOCALVERSION="<indentifier>".

4\. The above command may report errors resembling `symbol value 'm' invalid for CHELSIO_IPSEC_INLINE`. These errors indicate that the nature of the config has changed between the currently executing kernel and the kernel being built. The option "m" for a particular kernel module is no longer a valid option, and the default behavior is to simply turn the option off. However, the option can likely be turned back on by setting it to 'y'. If the user wants to turn the option back on, change it to 'y' and re-run "make olddefconfig":
    
    ```bash
    cd /home/OFS/linux-dfl
    echo 'CONFIG_CHELSIO_IPSEC_INLINE=y' >> .config
    make olddefconfig
    ```
    
    *Note: To use the built-in GUI menu for editing kernel configuration parameters, you can opt to run `make menuconfig`.*
    
5\. Linux kernel builds take advantage of multiple processors to parallelize the build process. Display how many processors are available with the `nproc` command, and then specify how many make threads to utilize with the `-j` option. Note that number of threads can exceed the number of processors. In this case, the number of threads is set to the number of processors in the system.
    
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
    make INSTALL_MOD_STRIP=1 binrpm-pkg -j `nproc`
    ```

    If the kernel development package is necessary for other software you plan on installing outside of OFS, you should instead use the build target `rpm-pkg`. 
    
    By default, a directory is created in your home directory called `rpmbuild`. This directory will house all the kernel packages which have been built. You need to navigate to the newly built kernel packages and install them. The following files were generated using the build command executed in the previous step:

    ```bash
    cd ~/rpmbuild/RPMS/x86_64
    ls
    kernel-6.1.78_dfl.x86_64.rpm  kernel-headers-6.1.78_dfl.x86_64.rpm
    sudo dnf localinstall kernel*.rpm
    ```

7\. The system will need to be rebooted in order for changes to take effect. After a reboot, select the newly built kernel as the boot target. This can be done pre-boot using the command `grub2-reboot`, which removes the requirement for user intervention. After boot, verify that the currently running kernel matches expectation.

    ```bash
    uname -r
    6.1.78-dfl
    ```

8\. Verify the DFL drivers have been successfully installed by reading version information directly from `/lib/modules`. Recall that the name of the kernel built as a part of this section is 6.1.78-dfl. If the user set a different name for their kernel, change this path as needed:

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

9\. Four kernel parameters must be added to the boot command line for the newly installed kernel. First, open the file `grub`:

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
    BOOT_IMAGE=(hd1,gpt2)/vmlinuz-6.1.78-dfl root=/dev/mapper/cl-root ro crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200 rhgb quiet
    ```

A list of all DFL drivers and their purpose is maintained on the [DFL Wiki](https://github.com/OFS/linux-dfl/wiki/FPGA-DFL-Driver-Modules#fpga-driver-modules).

### 3.3 Installing the OFS DFL Kernel Drivers from Pre-Built Packages

To use the pre-built Linux DFL packages, you first need to download the files from your chosen platform's release page. You can choose to either install using the SRC RPMs, or to use the pre-built RPM packages targeting the official supported release platform.

```bash
tar xf kernel-6.1.78_dfl-1.x86_64-*.tar.gz

sudo dnf localinstall kernel-6.1.78_dfl_*.x86_64.rpm \
kernel-devel-6.1.78_dfl_*.x86_64.rpm \
kernel-headers-6.1.78_dfl_*.x86_64.rpm

### OR

sudo dnf localinstall kernel-6.1.78_dfl_*.src.rpm
```

## 4.0 OPAE Software Development Kit

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit [opae.github.io](https://opae.github.io/latest/index.html).

The OPAE SDK source code is contained within a single GitHub repository hosted at the [OPAE Github](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4). This repository is open source and does not require any permissions to access.

You can choose to install the OPAE SDK by either using pre-built binaries created for the BKC OS, or by building them on your local server. If you decide to use the pre-built packages available on your chosen platform's release page, skip to section [4.3 Installing the OPAE SDK with Pre-built Packages](#44-installing-the-opae-sdk-with-pre-built-packages). Regardless of your choice you will need to follow the steps in this section to prepare your server for installation.

You may also choose to use the supplied Python 3 installation script. This script ships with a README detailing execution instructions and is available on the PCIe Attach's platform release page. It can be used to automate installation of the pre-built packages, or to build from source.

### 4.1 OPAE SDK Installation Environment Setup

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
    git checkout tags/2.12.0-4
    ```

3. Verify that the correct tag/branch have been checkout out.

    ```bash
    git describe --tags
    2.12.0-4
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
    rm -rf opae-*.src.rpm 
    sudo dnf localinstall -y opae*.rpm
    ```

6. Check that all packages have been installed and match expectation:
    
    ```bash
    rpm -qa | grep opae
    opae-2.12.0-4.el8.x86_64.rpm
    opae-debuginfo-2.12.0-4.el8.x86_64.rpm
    opae-debugsource-2.12.0-4.el8.x86_64.rpm
    opae-devel-2.12.0-4.el8.x86_64.rpm
    opae-devel-debuginfo-2.12.0-4.el8.x86_64.rpm
    opae-extra-tools-2.12.0-4.el8.x86_64.rpm
    opae-extra-tools-debuginfo-2.12.0-4.el8.x86_64.rpm
    ```

### 4.2 Installing the OPAE SDK with Pre-Built Packages

You can skip the entire build process and use a set of pre-built binaries supplied by Intel. Visit your chosen platform's release page. Ender the Assets tab you will see a file named opae-2.12.0-4.x86_64-\<\<date\>\>_\<\<build\>\>.tar.gz. Download this package and extract its contents:

```bash
tar xf opae-2.12.0-4.x86_64-*.tar.gz
```

For a fast installation you can delete the source RPM as it isn't necessary, and install all remaining OPAE RPMs:

```bash
rm opae-*.src.rpm
sudo dnf localinstall opae*.rpm
```

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
