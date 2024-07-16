# Software Installation Guide: Intel Agilex 7 SoC Attach FPGAs

Last updated: **July 16, 2024** 

## 1.0 About this Document

The purpose of this document is to help users get started in setting up their local environments and installing the most recent release of the OFS SoC Attach software stack on the host and platform. After reviewing this document, a user shall be able to:

- Set up their server environment according to the Best Known Configuration (BKC)
- Build and install the OPAE Software Development Kit (SDK) on the host
- Build and load a Yocto image with the OPAE SDK and Linux DFL Drivers included on the SoC

This document does **not** cover first time setup of the IPU Platform F2000X-PL platform.

### 1.1 Audience

The information in this document is intended for customers evaluating an SoC Attach release. This document will cover key topics related to initial bring up of the IPU Platform F2000X-PL software stack, with links for deeper dives on the topics discussed therein.

*Note: Code command blocks are used throughout the document. Comments are preceded with '#'. Full command output may not be shown for the sake of brevity.*

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

#### Table 2: Software Component Version Summary for SoC Attach

| Name| Location|
| -----| -----|
| META-OFS| https://github.com/OFS/meta-ofs, tag: ofs-2024.1-2|
| Host Operating System| Ubuntu 22.04 LTS| [Official Release Page](https://ubuntu.com/download/desktop)|
| Host OPAE SDK| 2.12.0-5| [https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5)|
| SoC OS | meta-intel-ese Reference Distro 1.0-ESE (kirkstone)| [ofs-2024.1-1 Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| SoC Kernel Version| 6.1.78-dfl| [ofs-2024.1-1 Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| SoC OPAE SDK| 2.12.0-5| [https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5)|
| SoC Linux DFL| ofs-2024.1-6.1-2| [https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2](https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2)|

Not all components shown in Table 2 will have an update available upon release. The OPAE SDK and Linux DFL software stacks are incorporated into a Yocto image and do not need to be downloaded separately.

## 2.0 Updating the IPU Platform F2000X-PL

Every IPU Platform F2000X-PL ships with pre-programmed firmware for the FPGA **user1**, **user2**, and **factory** images, the Cyclone 10 **BMC RTL and FW**, the **SoC NVMe**, and the **SoC BIOS**. In this software installation guide, we will only be focusing on the building and loading of a new SoC NVMe image. Board setup and configuration for the IPU Platform F2000X-PL is discussed in the [Getting Started Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/).

## 3.0 Compiling a Custom Yocto SoC Image

Current Yocto image architecture for SoC Attach is based off of the [IOTG Yoct-based ESE BSP](https://github.com/intel/iotg-yocto-ese-manifest), with the addition of the [Linux DFL kernel](https://github.com/OFS/linux-dfl) including the [latest DFL drivers for FPGA devices](https://docs.kernel.org/fpga/dfl.html) alongside the [OPAE SDK](https://github.com/OFS/opae-sdk) user space software. The image targets x86_64 SoC FPGA devices but should boot on most UEFI-based machines. The source code and documentation for this image is hosted on the [meta-ofs](https://github.com/OFS/meta-ofs) repository.

Build requirements exceed 100 GiB of disk space, depending on which image is built. As a reference point, on a system with two Intel(R) Xeon(R) E5-2699 v4 for a total of 44 CPU cores, the initial, non-incremental build takes less than an hour of `wall` time.

The `repo` tool is needed to clone the various Yocto layer repositories used in this example.

**Note:** If you are behind a firewall that prevents you from accessing references using the `git://` protocol, you can use the following to redirect Git to use the corresponding `https` repositories for Yocto only: `git config --global url.https://git.yoctoproject.org/.insteadOf git://git.yoctoproject.org/`.

To compile the image as-is, use the following steps (as provided in meta-ofs):

1. Create and initialize the source directory.
    
    ```bash
    mkdir ofs-yocto && cd ofs-yocto
    git clone --recurse-submodules --shallow-submodules https://github.com/OFS/meta-ofs
    cd meta-ofs
    git checkout tags/ofs-2024.1-2
    ```

2. Build packages and create an image.
    
    ```bash
    cd examples/iotg-yocto-ese
    TEMPLATECONF=$PWD/conf source openembedded-core/oe-init-build-env build
    bitbake mc:x86-2022-minimal:core-image-full-cmdline
    ```

The resulting GPT disk image is available in uncompressed (.wic) and compressed form (.wic.gz) in `meta-ofs/examples/iotg-yocto-ese/build/tmp-x86-2021-minimal-glibc/deploy/images/intel-corei7-64/`. With no changes the uncompressed image size is ~21 GB.

The image type [`core-image-full-cmdline`](https://docs.yoctoproject.org/ref-manual/images.html) includes the familiar GNU core utilities, as opposed to `core-image-minimal` which uses BusyBox instead.

The example build configuration files under build/conf/ are symlinked from [examples/iotg-yocto-ese/](https://github.com/OFS/meta-ofs/tree/main/examples/iotg-yocto-ese). To customize the image, start by modifying [local.conf](https://github.com/OFS/meta-ofs/blob/a06f9683039a45f445fbf07d183497766ec94877/examples/iotg-yocto-ese/conf/local.conf.sample#L6) and [bblayers.conf](https://github.com/OFS/meta-ofs/blob/a06f9683039a45f445fbf07d183497766ec94877/examples/iotg-yocto-ese/conf/bblayers.conf.sample#L4).

The uncompressed Yocto image can be loaded onto a flash drive as discussed in section [1.5.5 Creating a Bootable USB Flash Drive for the SoC](#155-creating-a-bootable-usb-flash-drive-for-the-soc) and written to NVMe as the default boot target for the SoC as demonstrated in section [2.1 Updating the F2000X-PL ICX-D SoC NVMe](#21-updating-the-f2000x-pl-icxd-soc-nvme).

## 4.0 Verifying the ICX-D SoC Software Stack

The reference SoC Attach FIM and unaltered FIM compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. Full supported functionality of the HEMs is documented in this platform's associated [Getting Started Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/) and will not be covered here.

## 5.0 Setting up the Host

External SoC Attach supports testing Host to FPGA latency, MMIO latency, and MMIO bandwidth. This testing is accomplished using the utility `host_exerciser` on the host, which is included as a part of OPAE. This section will cover the installation and verification flow for a host interacting with the SoC Attach workload.

Review [Section 1.2 Server Requirements](#12-server-requirements) of the [Board Installation Guide: OFS For Agilex® 7 SoC Attach IPU F2000X-PL](https://ofs.github.io/ofs-2024.2-1/hw/common/board_installation/f2000x_board_installation/f2000x_board_installation) for a list of changes required on the host to support an IPU Platform F2000X-PL and for a list of supported OS distributions. Installation will require an active internet connection to resolve dependencies.

The following software checks may be run on the host to verify the FPGA has been detected and has auto-negotiated the correct PCIe link width/speed. These commands do not require any packages to be installed. We are using PCIe BDF `b1:00.0` as an example address.

```bash
# Check that the board has enumerated successfully.
# Your PCIe BDF may differ from what is shown below.
$ lspci | grep accel
b1:00.0 Processing accelerators: Intel Corporation Device bcce 
b1:00.1 Processing accelerators: Intel Corporation Device bcce

# Check PCIe link status and speed. Width should be x16, and speed whould be 16GT/s
sudo lspci -s b1:00.0 -vvv | grep LnkSta | grep -o -P 'Width.{0,4}'
sudo lspci -s b1:00.0 -vvv | grep LnkSta | grep -o -P 'Speed.{0,7}'

sudo lspci -s b1:00.1 -vvv | grep LnkSta | grep -o -P 'Width.{0,4}'
sudo lspci -s b1:00.1 -vvv | grep LnkSta | grep -o -P 'Speed.{0,7}'
```

### 6.0 Installing the OPAE SDK On the Host

The OPAE SDK software stack sits in user space on top of the OFS kernel drivers. It is a common software infrastructure layer that simplifies and streamlines integration of programmable accelerators such as FPGAs into software applications and environments. OPAE consists of a set of drivers, user-space libraries, and tools to discover, enumerate, share, query, access, manipulate, and reconfigure programmable accelerators. OPAE is designed to support a layered, common programming model across different platforms and devices. To learn more about OPAE, its documentation, code samples, an explanation of the available tools, and an overview of the software architecture, visit the [opae.io](https://opae.github.io/2.1.0/docs/fpga_tools/opae.io/opae.io.html) page, and the [Software Reference Manual](../../../common/reference_manual/ofs_sw/mnl_sw_ofs.md)

The OPAE SDK source code is contained within a single [GitHub repository](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-5) hosted at the OPAE Github. This repository is open source and does not require any permissions to access. If you wish to install pre-built artifacts instead of building the release yourself, skip steps 3 and 4.

1. Before Installing the newest version of OPAE you must remove any prior OPAE framework installations.

    ```bash
    $ sudo apt-get remove opae*
    ```

2. The following system and Python3 package dependencies must be installed before OPAE may be built.

    ```bash
    $ sudo apt-get install bison flex git ssh pandoc devscripts debhelper cmake python3-dev libjson-c-dev uuid-dev libhwloc-dev doxygen libtbb-dev libncurses-dev libspdlog-dev libspdlog1 python3-pip libedit-dev pkg-config libcli11-dev libssl-dev dkms libelf-dev gawk openssl libudev-dev libpci-dev  libiberty-dev autoconf llvm
    
    $ python3 -m pip install setuptools pybind11 jsonschema
    ```

3. Clone the OPAE SDK repo. In this example we will use the top level directory `OFS` for our package installs.

    ```bash
    $ mkdir OFS && cd OFS
    $ git init
    $ git clone https://github.com/OFS/opae-sdk
    $ cd opae-sdk
    $ git checkout tags/2.12.0-5
    
    # Verifying we are on the correct release tag
    $ git describe --tags
    2.12.0-5
    ```

4. Navigate to the automatic DEB package build script location and execute.

    ```bash
    $ cd OFS/opae-sdk/packaging/opae/deb 
    $ ./create
    
    # Verify all packages are present
    $ ls | grep opae.*.deb
    opae_2.12.0-5_amd64.deb
    opae-dbgsym_2.12.0-5_amd64.ddeb
    opae-devel_2.12.0-5_amd64.deb
    opae-devel-dbgsym_2.12.0-5_amd64.ddeb
    opae-extra-tools_2.12.0-5_amd64.deb
    opae-extra-tools-dbgsym_2.12.0-5_amd64.ddeb
    ```

5. Install your newly built OPAE SDK packages.

    ```bash
    $ cd OFS/opae-sdk/packaging/opae/deb
    $ sudo dpkg -i opae*.deb
    ```

    The OPAE SDK version installed the host are identical to those installed on the SoC. A set of pre-compiled OPAE SDK artifacts are included in this release. These can be downloaded from [ofs-2024.1-1 Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1) and installed without building/configuring.

    ```bash
    $ tar xf opae-*.tar.gz
    $ sudo dpkg -i opae*.deb
    ```

6. Enable *iommu=on*, *pcie=realloc*, and set *hugepages* as host kernel parameters.
    
    ```bash
    # Check if parameters are already enabled
    $ cat /proc/cmdline
    ```

    If you do not see *intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200*, then add them manually.

    ```bash
    $ sudo vim /etc/default/grub

    # Edit the value for GRUB_CMDLINE_LINUX, add the values at the end of the variable inside of the double quotes. Example: GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel00-swap rd.lvm.lv=rhel00/root rd.lvm.lv=rhel00/swap rhgb quiet intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200"

    # Save your changes, then apply them with the following

    $ sudo grub2-mkconfig
    $ sudo reboot now
    ```

After rebooting, check that `proc/cmdline` reflects your changes.

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
<!-- include ./docs/hw/f2000x/doc_modules/links.md -->
<!-- include ./docs/hw/doc_modules/links.md -->
