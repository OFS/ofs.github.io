# OFS Getting Started Guide for Intel Agilex 7 SoC Attach FPGAs

Last updated: **March 20, 2024** 

## 1.0 About this Document

The purpose of this document is to help users get started in evaluating the 2024.1 version of the SoC Attach release targeting the Intel® Infrastructure Processing Unit (Intel® IPU) Platform F2000X-PL. After reviewing this document, a user shall be able to:

- Set up their server environment according to the Best Known Configuration (BKC)
- Build a Yocto image with the OPAE SDK and Linux DFL Drivers included
- Load and verify firmware targeting the SR and PR regions of the board, the BMC, and the ICX-D SoC NVMe and BIOS
- Verify full stack functionality offered by the SoC Attach OFS solution
- Know where to find additional information on other SoC Attach ingredients

### 1.1 Audience

The information in this document is intended for customers evaluating the Intel® IPU Platform F2000X-PL. The card is an acceleration development platform (ADP) intended to be used as a starting point for evaluation and development. This document will cover key topics related to initial bring up and development of the Intel® IPU Platform F2000X-PL, with links for deeper dives on the topics discussed therein.

*Note:* Code command blocks are used throughout the document. Commands that are intended for you to run are preceded with the symbol '$', and comments with '#'. Full command output may not be shown.

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

#### Table 2: Related Documentation
| Name| Location|
| -----| -----|
| Platform Evaluation Script: Open FPGA Stack for Intel Agilex 7 FPGA| [link](https://ofs.github.io/hw/f2000x/user_guides/ug_eval_ofs/ug_eval_script_ofs_f2000x/)|
| FPGA Interface Manager Technical Reference Manual for Intel Agilex 7 SoC Attach: Open FPGA Stack| [link](https://ofs.github.io/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs)|
| Software Reference Manual: Open FPGA Stack| [link](https://ofs.github.io/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/)|
| Intel® FPGA Interface Manager Developer Guide: Intel Agilex 7 SoC Attach: Open FPGA Stack| [link](https://ofs.github.io/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/)|
| Intel® Accelerator Functional Unit Developer Guide: Open FPGA Stack for Intel® Agilex® 7 FPGAs SoC Attach| [link](https://ofs.github.io/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/)|
| Security User Guide: Intel Open FPGA Stack| [link](https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/) |
| Virtual machine User Guide: Open FPGA Stack + KVM| [link](https://ofs.github.io/hw/common/user_guides/ug_kvm/ug_kvm/)|
| Docker User Guide: Open FPGA Stack: Intel® Open FPGA Stack| [link](https://ofs.github.io/hw/common/user_guides/ug_docker/ug_docker/)|
| Release Notes| [link](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2023.1-1) - under "Important Notes"|
| Board Management Controller User Guide v1.1.9 (Pre-Release): Intel IPU Platform F2000X-PL| Work with your Intel sales representative for access|

#### Table 3: Related Repositories

| Name| Location|
| -----| -----|
| Intel-FPGA-BBB | https://github.com/OPAE/intel-fpga-bbb.git |
| OFS-PLATFORM-AFU-BBB| https://github.com/OFS/ofs-platform-afu-bbb.git, tag: ofs-2024.1-1 |
| AFU-EXAMPLES| https://github.com/OFS/examples-afu.git, tag: ofs-2024.1-1|
| OPAE-SDK| https://github.com/OFS/opae-sdk.git, tag: 2.12.0-4 |
| LINUX-DFL| https://github.com/OFS/linux-dfl.git, tag: ofs-2024.1-6.1-2|
| META-OFS| https://github.com/OFS/meta-ofs, tag: ofs-2024.1-2|

#### Table 4: Software and Firmware Component Version Summary for SoC Attach

| Component| Version| Download link (where applicable)|
| -----| -----| -----|
| Available FIM Version(s)|PR Interface ID: 3dac7126-3ce7-5fe8-b629-932096abb09b (TBD) |[2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1) |
| Host Operating System| Ubuntu 22.04| [Official Release Page](https://ubuntu.com/download/desktop)|
| Host OPAE SDK| 2.12.0-4| [https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4)|
| SoC OS | meta-intel-ese Reference Distro 1.0-ESE (kirkstone)| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| SoC Kernel Version| 5.15.92-dfl-66b0076c2c-lts (TBD)| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| SoC OPAE SDK| 2.12.0-4| [https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4](https://github.com/OFS/opae-sdk/releases/tag/2.12.0-4)|
| SoC Linux DFL| ofs-2024.1-6.1-2| [https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2](https://github.com/OFS/linux-dfl/releases/tag/ofs-2024.1-6.1-2)|
| SoC BMC and RTL| 1.2.4| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| SoC BIOS| 0ACRH608_REL| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|

Not all components shown in Table 4 will have an update available upon release. The OPAE SDK and Linux DFL software stacks are incorporated into a Yocto image and do not need to be downloaded separately. Updates required for the 2024.1 OFS SoC Attach Release for Intel IPU Platform F2000X-PL are shown under Table 9 in section [2.0 Updating the Intel® IPU Platform F2000X-PL](#20-updating-the-Intel® IPU Platform F2000X-PL).

### 1.2 Board Installation and Server Requirements

The F2000X-PL device physical setup procedure and required server settings are detailed in this device's [Board Installation Guidelines](../../../common/board_installation/f2000x_board_installation/f2000x_board_installation.md). Please review this document and follow proper procedure when installing your device. The rest of this document will assume you have completed basic platform bring-up.

## 2.0 Updating the Intel® IPU Platform F2000X-PL

Every Intel® IPU Platform F2000X-PL ships with pre-programmed firmware for the FPGA **user1**, **user2**, and **factory** images, the Cyclone 10 **BMC RTL and FW**, the **SoC NVMe**, and the **SoC BIOS**. The combination of FW images in *Table 4* compose the official 2024.1 OFS SoC Attach Release for Intel IPU Platform F2000X-PL. Upon initial receipt of the board from manufacturing you will need to update two of these regions of flash to conform with the best known configuration for SoC Attach.  As shown in Table 9, not all devices require firmware updates. To instruct users in the process of updating on-board Intel® IPU Platform F2000X-PL firmware, examples are provided in this guide illustrating the firmware update process for all devices.  

#### Table 9: Intel® IPU Platform F2000X-PL FW Components

| HW Component| File Name | Version | Update Required (Yes/No) |Download Location|
| ----- | ----- | ----- | ----- | ----- |
| FPGA SR Image<sup>1</sup> | user1: ofs_top_page1_unsigned_user1.bin<br>user2: ofs_top_page2_unsigned_user2.bin<br>factory: ofs_top_page0_unsigned_factory.bin |PR Interface ID: 3dac7126-3ce7-5fe8-b629-932096abb09b (TBD) | Yes| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| FPGA PR IMAGE<sup>2</sup>| ofs_pr_afu.green_region_unsigned.gbs | N/A | Yes | Compiled with FIM|
| ICX-D NVMe | core-image-full-cmdline-intel-corei7-64-20240227185330.rootfs.wic| N/A | Yes | [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| BMC RTL and FW | AC_BMC_RSU_user_retail_1.2.4_unsigned.rsu| 1.2.4| No | [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|
| BIOS Version | 0ACRH608_REL.BIN | 0ACRH608_REL| Yes| [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1)|

If a component does not have a required update, it will not have an entry on [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1).

<sup>1</sup>To check the PR Interface ID of the currently programmed FIM and the BMC RTL and FW version, use `fpgainfo fme` from the SoC.
<sup>2</sup>Must be programmed if using AFU-enabled exercisers, not required otherwise.

```bash
$ fpgainfo fme
Intel IPU Platform F2000X-PL
**Board Management Controller NIOS FW version: 1.2.4**
**Board Management Controller Build version: 1.2.4**
//****** FME ******//
Object Id                        : 0xEF00000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Ports Num                        : 01
**Bitstream Id                     : 0x5010302F9FB46B7 (TBD)**
Bitstream Version                : 5.0.1
**Pr Interface Id                  : 3dac7126-3ce7-5fe8-b629-932096abb09b (TBD)**
Boot Page                        : user1
User1 Image Info                 : 9e3db8b6a4d25a4e3e46f2088b495899
User2 Image Info                 : None
Factory Image Info               : None
```

### 2.1 Updating the F2000X-PL ICX-D SoC NVMe

The Intel® IPU Platform F2000X-PL ships with a Yocto image pre-programmed in NVMe, which is not the same as the SoC Attach OFS image that we will be using. The latter provides only the OPAE SDK and Linux DFL drivers and is fully open source. This section will show how you can use an attached USB drive to load a new image into flash. You will use a serial terminal to install the new image - Minicom and PuTTy terminal emulators have both been tested. `minicom` is used for demonstration purposes as the serial terminal to access the ICX-D SoC UART connection in this section. Information on compiling your own Yocto image for use with the Intel® IPU Platform F2000X-PL is discussed in section [4.0 Compiling a Custom Yocto SoC Image](#40-compiling-a-custom-yocto-soc-image).

**Note:** Username and password for the default SoC NVMe boot image are "root" and "root@123".

1. First, make sure to complete the steps in section [1.5.5 Creating a Bootable USB Flash Drive for the SoC](#155-creating-a-bootable-usb-flash-drive-for-the-soc), and attach the USB drive either directly into the rear of the Intel® IPU Platform F2000X-PL, or into a USB Hub that itself is connected to the board.

2. Ensure your Minicom terminal settings match those shown below. You must direct Minicom to the USB device created in `/dev` associated with your RS-232 to USB Adapter cable. This cable must be attached to a server that is *separate* from the one housing your Intel® IPU Platform F2000X-PL. Check the server logs in `dmesg` to figure out which device is associated with your cable: `[    7.637291] usb 1-4: FTDI USB Serial Device converter now attached to ttyUSB0`. In this example the special character file `/dev/ttyUSB0` is associated with our cable, and can be connected to using the following command: `sudo minicom --color=on -D /dev/ttyUSB0`.
    
    ![](./images/minicom_settings.PNG)

3. Change the SoC boot order to boot from USB first. Reboot the server. From your
    serial Minicom terminal, watch your screen and
    press 'ESC' key to go into BIOS setup mode. Once BIOS setup comes
    up as shown below, click the right arrow key six times to move from
    'Main' set up menu to 'Boot' setup:
    
     Main setup menu:
    
    ![](./images/mainmenu1.png)
    
    ![](./images/mainmenu2.png)
    
     Your order of boot devices may differ. You need to move the USB flash
     up to Boot Option \#1 by first using the down arrow key to highlight
     the USB device then use '+' key to move the USB device to \#1 as
     shown below:
    
    ![](./images/mainmenu3.png)
    
    Press 'F4' to save and exit.

4. You will boot into Yocto automatically. Log in with username `root` and an empty password using Minicom. Take note of the IP address of the board, you can use this to log in without needing the serial cable.
    
     ![](./images/yocto_login.PNG)
    
    Verify that you have booted from the USB and not the on-board NVMe `lsblk -no pkname $(findmnt -n / | awk '{ print $2 }')`. You should see a device matching `/dev/sd*`, and *not* `nvme*n*p*`. If you see `nvme*n*p*`, then review the previous steps.
    
    Record the IP address of the SoC at this time `ip -4 addr`. This will be used to log in remotely using SSH.

5. Check that 4 partitions created in [1.5.5 Creating a Bootable USB Flash Drive for the SoC](#1.5.5-creating-a-bootable-usb-flash-drive-for-the-soc) are visible to the SoC in `/dev/sd*`:
    
    ```bash
    $ lsblk -l
    root@intel-corei7-64:/mnt# lsblk -l
    NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
    sda         8:0    1 117.2G  0 disk
    sda1        8:1    1  38.5M  0 part /boot
    sda2        8:2    1    20G  0 part /
    sda3        8:3    1    44M  0 part [SWAP]
    sda4        8:4    1  97.1G  0 part /mnt
    nvme0n1   259:0    0  59.6G  0 disk
    nvme0n1p1 259:1    0   300M  0 part
    nvme0n1p2 259:2    0  22.1G  0 part
    nvme0n1p3 259:3    0    44M  0 part
    ```
    
    Mount partition 4, and `cd` into it.
    
    ```bash
    $ mount /dev/sda4 /mnt`
    $ cd /mnt
    ```

6. Install the Yocto release image in the SoC NVMe.
    
    ```bash
    $ dd if=core-image-full-cmdline-intel-corei7-64-20240227185330.rootfs.wic of=/dev/nvme0n1 bs=1M status=progress conv=sync
    $ sync
    $ sgdisk -e /dev/nvme0n1
    ```
    
    The transfer from USB to NVMe will take several minutes.

7. Reboot the SoC and update the SoC BIOS to boot from NVMe. Follow steps 2 and 3 from this section again, and this time move the NVME back to the front of the boot order. The NVMe is named `UEFI OS (PCIe SSD)` by the BIOS. Press F4 to save and exit.
    
    You can use `wget` to retrieve a new version of the Yocto release image from [meta-ofs](https://github.com/OFS/meta-ofs/releases/tag/ofs-2024.1-2) once the SoC's network connection is up. Use `wget` to copy the image to the SoC over the network under `/mnt`. You may need to delete previous Yocto images to save on space: `$ wget --no-check-certificate --user <Git username> --ask-password https://github.com/OFS/meta-ofs/releases/download/ofs-2024.1-2/core-image-full-cmdline-intel-corei7-64-20240227185330.rootfs.wic.gz`. Uncompress the newly retrieved file: `gzip -d core-image-full-cmdline-intel-corei7-64-20240227185330.rootfs.wic.gz`. This may take several minutes.

#### 2.1.1 Setting the Time

1. Use Linux command to set system time using format: `date --set="STRING"`.
    
    ```bash
    date -s "26 APRIL 2023 18:00:00"
    ```

2. Set HWCLOCK to current system time:
    
    ```bash
    hwclock --systohc
    ```
        
    Verify time is set properly
    
    ```bash
    date
    ...
    hwclock --show
    ...
    ```

## 3.0 Updating the Intel® IPU Platform F2000X-PL

### 3.1 Preparing the Intel® IPU Platform F2000X-PL SoC for Updates

Updating the Intel® IPU Platform F2000X-PL firmware often requires reboots of the SoC or reconfiguration of the FPGA region. If there are processes connected from the host to the SoC that do not expect the downtime to occur, or if the host is not tolerant to a surprise PCie link down, the following instructions can be used to properly orchestrate updates with the host when reboots occur.

**Note:** Intel IPU Platform F2000X-PL FPGA and BMC updates are initiated by commands issued on the IPU SoC. Issue the following commands from the host to remove any processes that would be impacted by this update. The instructions on properly removing the IPU from PCIe bus require the OPAE SDK to be installed on the host. Refer to section [6.0 Setting up the Host](#60-setting-up-the-host) for this process.

1. From a host terminal shell, find PCIe Bus/Device/Function (BDF) address of your Intel IPU Platform F2000X-PL. Run the command `lspci | grep bcce` to print all boards with a DID that matches bcce.

    ```bash
    $ lspci | grep bcce
    31:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
    31:00.1 Processing accelerators: Intel Corporation Device bcce (rev 01)
    # In this example, 31:00.0 is the proper PCIe BDF of our device
    ```

2. Shut down all VMs and software applications attached to any PFs/VFs on the host
3. Issue the command `sudo pci_device <<PCIe BDF>> unplug` on the host to remove the PCIe device from the PCIe bus
4. Shut down all software applications on the SoC accessing non-management PFs/VFs
5. Issue your update command on the SoC, which will cause an SoC reboot and surprise PCIe link down on the host (ex. `reboot`, `rsu bmc/bmcimg/fpga`)
6. Once you have completed all firmware updates, you may restart application software on the SoC
7. Issue command `sudo pci_device <<PCIe BDF>> plug` on the host to rescan the PCIe bus and rebind the device to its native driver
8. Restart software applications on the host

### 3.2 Updating FIM, BMC and AFU with `fpgasupdate`

The `fpgasupdate` tool updates the Intel<sup>&reg;</sup> C10 10 BMC image and firmware, root entry hash, FPGA Static Region (SR) and user image (PR). The `fpgasupdate` will only accept images that have been formatted using PACSign. If a root entry hash has been programmed onto the board, then the image will also need to be signed using the correct keys. Please refer to the [Security User Guide: Intel Open FPGA Stack](https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/) for information on creating signed images and on programming and managing the root entry hash. This repository requires special permissions to access - please reach out to your Intel representative to request. The `fpgasupdate` tool is used to program images into flash memory. The `rsu` tool is used to configure the FPGA/BMC with an image that is already stored in flash memory, or to switch between **user1** and **user2** images. All images received from an official Intel release will be "unsigned", as described in the [Security User Guide: Intel Open FPGA Stack](https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/).

**Note:** 'Unsigned' in this context means the image has passed through `PACsign` and has had the proper security blocks prepended using a set of 'dummy' keys. FIMs with image signing enabled will require all programmable images to pass through `PACsign` even if the currently programmed FIM/BMC do not require specific keys to authenticate.

There are two regions of flash you may store FIM images for general usage, and one backup region. These locations are referred to as **user1**, **user2**, and **factory**. The factory region is not programmed by default and can only be updated once keys have been provisioned. The BMC FW and RTL will come pre-programmed with version 1.1.9.

Updating the FIM from the SoC requires the SoC be running a Yocto image that includes the OPAE SDK and Linux DFL drivers. Updating the FIM using `fpgasupdate` also requires an OFS enabled FIM to be configured on the F2000X-PL, which it will ship with from manufacturing. You need to transfer any update files to the SoC over SSH. The OPAE SDK utility `fpgasupdate` will be used to update all ofthe board's programmable firmware . This utility will accept files of the form \*.rsu, \*.bin, and \*.gbs, provided the proper security data blocks have been prepended by PACSign. The default configuration the IPU platform ships with will match the below:

```bash
$ fpgainfo fme
Intel IPU Platform F2000X-PL
**Board Management Controller NIOS FW version: 1.2.4**
**Board Management Controller Build version: 1.2.4**
//****** FME ******//
Object Id                        : 0xEF00000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Ports Num                        : 01
**Bitstream Id                     : 0x5010302F9FB46B7 (TBD)**
Bitstream Version                : 5.0.1
**Pr Interface Id                  : 3dac7126-3ce7-5fe8-b629-932096abb09b (TBD)**
Boot Page                        : user1
User1 Image Info                 : 9e3db8b6a4d25a4e3e46f2088b495899
User2 Image Info                 : None
Factory Image Info               : None
```

To load a new update image, you need to pass the IPU's PCIe BDF and the file name to `fpgasupdate` on the SoC. The below example will update the **user1** image in flash:

```bash
$ fpgasupdate ofs_top_page1_unsigned_user1.bin 15:00.0
```

After loading an update image, `rsu fpga/bmc/bmcimg` can be used to reload the firmware and apply the change, as discussed below. An RSU of the BMC will always cause a reload of both the BMC and FPGA images.

### 3.3 Loading images with `rsu`

 RSU performs a Remote System Update operation on an Intel® IPU Platform F2000X-PL, given its PCIe address. An `rsu` operation sends an instruction to the device to trigger a power cycle of the card only if run with `bmcimg`. `rsu` will force reconfiguration from flash for either the BMC or FPGA. PCIe Advanced Error Reporting (AER) is temporarily disabled for the card when RSU is in progress

The Intel® IPU Platform F2000X-PL contains two regions of flash you may store FIM images. These locations are referred to as **user1** and **user2**. After an image has been programmed to either of these regions in flash using fpgasupdate, you may perform an `rsu` to reconfigure the Agilex 7 FPGA with the new image stored in flash. This operation will indicate to the BMC which region to configure the FPGA device from after power-on.

If the factory image has been updated, Intel strongly recommends you immediately RSU to the factory image to ensure the image is functional.

You can determine which region of flash was used to configure their FPGA device using the command `fpgainfo fme` and looking at the row labelled **Boot Page**.

When loading a new FPGA SR image, use the command `rsu fpga`. When loading a new BMC image, use the command `rsu bmc`. When using the RSU command, you may select which image will be configured to the selected device. For example, when performing an RSU for the Intel Agilex 7 FPGA, you may select to configure the **user1**, **user2**, or **factory** image. When performing an RSU for the C10 BMC, you may select to configure the user or factory image. You may also use RSU to reconfigure the SDM on devices that support it. The RSU command sends an instruction to the BMC to reconfigure the selected device from an image stored in flash.

```bash
$ rsu fpga --page=user1 15:00.0
```

Useage:

```bash
rsu bmc --page=(user|factory) [PCIE_ADDR]
rsu fpga --page=(user1|user2|factory) [PCIE_ADDR]
rsu sdm [PCIE_ADDR]
```

You can use RSU to change which page in memory the FPGA will boot from by default.

Synopsis:

```bash
rsu fpgadefault --page=(user1|user2|factory) --fallback=<csv> 15:00.0
```

Use to set the default FPGA boot sequence. The `--page` option determines the primary FPGA boot image. The `--fallback` option allows a comma-separated list of values to specify fallback images.

### 3.4 Updating the ICX-D SoC BIOS

The ICX-D SoC NVMe comes pre-programmed with BIOS v7 (0ACRH007). This version will need to be replaced with 0ACRH608_REL. BIOS update files come in the form 0ACRH\<\<version\>\>.bin, and can be downloaded on [2023.3 OFS Release for Agilex 7 SoC Attach Reference Shell](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1). This update process is in-band, and requires you to download and install a BIOS UEFI utility from AMI called "APTIO V AMI Firmware Update Utility", available [here](https://www.ami.com/bios-uefi-utilities/#aptiov). This package will install a utility in the UEFI shell called AfuEfix64.efi which will be used to overwrite the ICX-D BIOS.

1. Check your BIOS Version. Reboot the SoC and wait for the BIOS version to be shown. In this example, the BIOS will need to be updated.
    
    ![](./images/bios_setup_splash.PNG)

2. Download both the ICX-D SoC Update image and [APTIO V AMI Firmware Update Utility](https://www.ami.com/bios-uefi-utilities/#aptiov). Unzip the BIOS update image and locate your BIOS update binary. Unzip Aptio_V_AMI_Firmware_Update_Utility.zip, and then navigate to Aptio_V_AMI_Firmware_Update_Utility\afu\afuefi\64 and unzip AfuEfi64.zip. The file we need from this package is called AfuEfix64.efi.
    
    ![](./images/ami_webpage.png)

3. Copy both files over to the SoC into /boot/EFI using the SoC's IP.
    
    ```bash
    $ scp 0ACRH608_REL.BIN root@XX.XX.XX.XX:/boot/EFI
    $ scp AfuEfix64.efi root@XX.XX.XX.XX:/boot/EFI
    ```

4. Reboot the SoC from a TTY Serial terminal. Watch your screen and press 'ESC' key to go into BIOS setup mode. Select 'Built-in EFI Shell'.
    
    ![](./images/uefi_builtin_shell.png)

5. At EFI prompt enter the following:
    
    ```bash
    Shell> FS0:
    FS0:> cd EFI
    FS0:\EFI\> AfuEfix64.efi 0ACRH608_REL.BIN /p /n /b
    ```
    
    Press 'E'. When the update has completed type 'reset -w' to reboot.
    
    ![](./images/afutool.png)

6. Watch your screen and press 'ESC' key to go into BIOS setup mode. Verify BIOS version matches expectation.
    
    [](./images/correctbios_Version.png)

7. Click the right arrow key six times to move from 'Main' set up menu to 'Boot' setup. Select NVMe as the primary boot source.
    
    [](./images/post_bios_update_nvme.png)

## 4.0 Compiling a Custom Yocto SoC Image

Custom Yocto image compilation steps are shown in the [Software Installation Guide: SoC Attach](../../../common/sw_installation/soc_attach/sw_install_soc_attach.md).

## 5.0 Verifying the ICX-D SoC OPAE SDK

The reference SoC Attach FIM and unaltered FIM compilations contain Host Exerciser Modules (HEMs). These are used to exercise and characterize the various host-FPGA interactions, including Memory Mapped Input/Output (MMIO), data transfer from host to FPGA, PR, host to FPGA memory, etc. Full supported functionality of the HEMs is documented in the [host_exerciser](https://opae.github.io/latest/docs/fpga_tools/host_exerciser/host_exerciser.html) opae.io GitHub page. SoC Attach supports HEMs run both with and without an AFU image programmed into the board's one supported PR region. This image is available on the offial [SoC Attach GitHub Page](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1), and is programmed using `fpgasupdate` as shown in section 3.2. A few select examples run from the SoC and their expected results will be shown below.

### 5.1 Checking Telemetry with `fpgainfo`

The `fpgainfo` utility displays FPGA information derived from sysfs files.

The command argument is one of the following: `errors`, `power`, `temp`, `port`, `fme`, `bmc`, `phy`, `mac`, and `security`. Some commands may also have other arguments or options that control their behavior.

For systems with multiple FPGA devices, you can specify the BDF to limit the output to the FPGA resource with the corresponding PCIe configuration. If not specified, information displays for all resources for the given command.

An example output for `fpgainfo fme` is shown below. Your IDs may not match what is shown here:

```bash
$ fpgainfo fme
Intel IPU Platform F2000X-PL
Board Management Controller NIOS FW version: 1.1.9
Board Management Controller Build version: 1.1.9
//****** FME ******//
Object Id                        : 0xEF00000
PCIe s:b:d.f                     : 0000:15:00.0
Vendor Id                        : 0x8086
Device Id                        : 0xBCCE
SubVendor Id                     : 0x8086
SubDevice Id                     : 0x17D4
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 0x50103023DFBFC8E
Bitstream Version                : 5.0.1
Pr Interface Id                  : bf74e494-ad12-5509-98ab-4105d27979f3
Boot Page                        : user1
User1 Image Info                 : 98ab4105d27979f3bf74e494ad125509
User2 Image Info                 : None
Factory Image Info               : None
```

### 5.2 Host Exercisers

Of these five tests listed below, the first three do not require an AFU be loaded into the board's PR region. They exercise data paths that pass exclusively through the FIM. The latter three tests exercise data through the AFU data path, and require [SoC Attach release AFU Image](https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2024.1-1) to be configured using `fpgasupdate`.

* Run HE-MEM with 2 cachelines per request in `mem` mode, exercising the FPGA's connection to DDR. No AFU required.
    
    **Note**: If you see the error message `Allocate SRC Buffer, Test mem(1): FAIL`, then you may need to manually allocate 2MiB Hugepages using the following: `echo 20 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`
    
    ```bash
    # Create VF device
    $ pci_device <PCIe Bus>00.0 vf 3
    # Bind VF0 to vfio-pci
    $ opaei.io init -d <PCIe Bus>:00.1 <username>:<username>
    # Check for HE-MEM Accelerator GUID 8568ab4e-6ba5-4616-bb65-2a578330a8eb
    $ fpgainfo port -B <PCIe Bus>:00.0
    # Run desired HE-MEM test(s)
    $ host_exerciser --cls cl_1 --mode lpbk mem
    starting test run, count of 1
    API version: 2
    AFU clock: 470 MHz
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
        Number of clocks: 9948
        Total number of Reads sent: 1024
        Total number of Writes sent: 1024
        Bandwidth: 3.096 GB/s
        Test mem(1): PASS
    ```

* Generate traffic with HE-HSSI. No AFU required.
    
    ```bash
    # Create VF device
    $ pci_device <PCIe Bus>00.0 vf 3
    # Bind VF2 to vfio-pci
    $ opaei.io init -d <PCIe Bus>:00.2 <username>:<username>
    # Check for HE-HSSI Accelerator GUID 823c334c-98bf-11ea-bb37-0242ac130002
    $ fpgainfo port -B <PCIe Bus>:00.0
    # Show number of configured ports
    $ fpgainfo phy | grep Port
    # Generate traffic for specific port number
    $ hssi --pci-address <PCIe Bus>:00.2 hssi_10g --num-packets 100 --port <port number>
    10G loopback test
      Tx/Rx port: 1
      Tx port: 1
      Rx port: 1
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
    ...
    ```
    
    This command will generate a log file in the directory is was run from. Check TxPackets and RxPackets for any loss. Two more supported HSSI commands are `hssistats`, which provides MAC statistics, and `hssimac`, which provides maximum TX and RX frame size.

* Test memory traffic generation using MEM-TG. This will exercise and test available memory channels with a configurable memory pattern. Does not require an AFU image.
    
    ```bash
    # Create VF device
    $ pci_device <PCIe Bus>00.0 vf 3
    # Bind VF2 to vfio-pci
    $ opaei.io init -d <PCIe Bus>:00.3 <username>:<username>
    # Check for MEM-TG Accelerator GUID 4dadea34-2c78-48cb-a3dc-5b831f5cecbb
    $ fpgainfo port -B <PCIe Bus>:00.0
    # Example MEM-TG Test
    $  mem_tg --loops 500 -w 1000 -r 0 -b 0x1 --stride 0x1 -m 0 tg_test
    ```

* HE-LPBK is designed to demo how AFUs move data between host memory and the FPGA. Will check latency, MMIO latency, MMIO bandwidth, and PCIe bandwidth.  LPBK workload requires the SoC Attach AFU be loaded into the board's PR slot.
    
    ```bash
    # Create VF device
    $ pci_device <PCIe Bus>00.0 vf 3
    # Bind VF1 to vfio-pci
    $ opaei.io init -d <PCIe Bus>:00.1 <username>:<username>
    # Check for LPBK GUID 56e203e9-864f-49a7-b94b-12284c31e02b
    $ fpgainfo port -B <PCIe Bus>:00.0
    # Example loopback test
    $  host_exerciser --mode lpbk lpbk
    ```

* Exercise He-HSSI subsystem from the AFU. This test will generate and receieve packets from any of the 8 available ports. This HSSI workload requires the SoC Attach AFU be loaded into the board's PR slot.
    
    ```bash
    # Create VF device
    $ pci_device <PCIe Bus>00.0 vf 3
    # Bind VF6 to vfio-pci
    $ opaei.io init -d <PCIe Bus>:00.2 <username>:<username>
    # Check for HSSI GUID 823c334c-98bf-11ea-bb37-0242ac130002
    $ fpgainfo port -B <PCIe Bus>:00.0
    # Geneate traffic for specific port
    $  hssi --pci-address <bus_num>:00.6 hssi_10g --num-packets 100 --port <port_num>
    ```
    
    This command will generate a log file in the directory is was run from. Check TxPackets and RxPackets for any loss. Two more supported HSSI commands are `hssistats`, which provides MAC statistics, and `hssimac`, which provides maximum TX and RX frame size.

### 5.3 Additional OPAE SDK Utilities

This section will discuss OPAE SDK utilities that were not covered by previous sections. These commands are all available on the ICX-D SoC Yocto image by default. A full description and syntax breakdown for each command is located on the official [OPAE SDK](https://opae.github.io/latest/) github.io repo.

#### Table 6: OPAE SDK Utilities

| Utility| Description|
| -----| -----|
| fpgasupdate| [3.2 Updating FIM, BMC and AFU with `fpgasupdate`](#32-updating-fim,-bmc-and-afu-with-fpgasupdate)|
| rsu| [Section 3.3 Loading images with `rsu`](#33-loading-images-with-rsu)|
| host_exerciser| [Section 5.2 Host Exercisers](#52-host-exercisers)|
| hssi| [Section 5.2 Host Exercisers](#52-host-exercisers)|
| hssistats| [Section 5.2 Host Exercisers](#52-host-exercisers)|
| hssimac| [Section 5.2 Host Exercisers](#52-host-exercisers)|
| mem_tg| [Section 5.2 Host Exercisers](#52-host-exercisers)|
|**usrclk**| `userclk` tool is used to set high and low clock frequency to an AFU.|
|**mmlink**| Remote signaltap is software tool used for debug RTL (AFU), effectively a signal trace capability that Quartus places into a green bitstream. Remote Signal Tap provides access the RST part of the Port MMIO space, and then runs the remote protocol on top.|
|**opaevfio**|The `opaevfio` command enables the binding/unbinding of a PCIe device to/from the vfio-pci device driver. See https://kernel.org/doc/Documentation/vfio.txt for a description of vfio-pci.|
|**opae.io**| An interactive Python environment packaged on top of libopaevfio.so, which provides user space access to PCIe devices via the vfio-pci driver. The main feature of opae.io is its built-in Python command interpreter, along with some Python bindings that provide a means to access Configuration and Status Registers (CSRs) that reside on the PCIe device.|
|**bitstreaminfo**| Prints bitstream metadata.|
|**fpgaconf**| Lower level programming utility that is called automatically by `fpgasupdate`. `fpgaconf` writes accelerator configuration bitstreams (also referred to as "green bitstreams") to an FPGA device recognized by OPAE. In the process, it also checks the green bitstream file for compatibility with the targeted FPGA and its current infrastructure bitstream (the "blue bistream").|
|**fpgad**| Periodically monitors/reports the error status reflected in the device driver's error status sysfs files. Establishes the channel by which events are communicated to the OPAE application. Programs a NULL bitstream in response to AP6 event. `fpgad` is required to be running before API calls fpgaRegisterEvent and fpgaUnregisterEvent will succeed.|

## 6.0 Setting up the Host

The steps to set up the host and build and install the OPAE SDK are shown in the [Software Installation Guide: SoC Attach](../../../common/sw_installation/soc_attach/sw_install_soc_attach.md).

### 6.1 Verifying the SoC Attach Solution on the Host

The SoC Attach workload supports testing MMIO HW and Latency and PCIe BW and latency out of box. Execution of the `host_exerciser` binary on the host requires the OPAE SDK to be installed as shown in section [6.1 Installing the OPAE SDK On the Host](#61-installing-the-opae-sdk-on-the-host). You will also need to have a proper SoC Attach FIM configured on your board as shown in section [3.2 Updating FIM, BMC and AFU with `fpgasupdate`](#32-updating-fim-bmc-and-afu-with-fpgasupdate).

1. Initialize PF attached to HSSI LPBK GUID with *vfio-pci* driver.
    
    ```bash
    $ sudo opae.io init -d 0000:b1:00.0 <username>:<username>
    $ sudo opae.io init -d 0000:b1:00.1 <username>:<username>
    ```
    
2. Run `host_exerciser` loopback tests (only *lpbk* is supported). There are more methods of operation than are shown below - read the HE help message for more information.

```bash
# Example lpbk tests.
$ sudo host_exerciser lpbk
$ sudo host_exerciser --mode lpbk lpbk
$ sudo host_exerciser --cls cl_4  lpbk
$ sudo host_exerciser --perf true --cls cl_4  lpbk
# Number of cachelines per request 4.
$ sudo host_exerciser --mode lpbk --cls cl_4 lpbk
$ sudo host_exerciser --perf true --mode lpbk --cls cl_4 lpbk
# vNumber of cachelines per request 4.
$ sudo host_exerciser --mode read --cls cl_4 lpbk
$ sudo host_exerciser --perf true --mode read --cls cl_4 lpbk
# Number of cachelines per request 4.
$ sudo host_exerciser --mode write --cls cl_4 lpbk
$ sudo host_exerciser --perf true --mode write --cls cl_4 lpbk
# Number of cachelines per request 4.
$ sudo host_exerciser --mode trput --cls cl_4 lpbk
$ sudo host_exerciser --perf true --mode trput --cls cl_4 lpbk
# Enable interleave requests in throughput mode
$ sudo host_exerciser --mode trput --interleave 2 lpbk
$ sudo host_exerciser --perf true --mode trput --interleave 2 lpbk
#with delay option.
$ sudo host_exerciser --mode read --delay true lpbk
$ sudo host_exerciser --mode write --delay true lpbk
# Test all modes of operation
$ host_exerciser --testall=true lpbk
```

### 6.2 FPGA Device Access Permissions

Access to FPGA accelerators and devices is controlled using file access permissions on the Intel® FPGA device files, /dev/dfl-fme.* and /dev/dfl-port.*, as well as to the files reachable through /sys/class/fpga_region/.

In order to allow regular (non-root) users to access accelerators, you need to grant them read and write permissions on /dev/dfl-port.* (with * denoting the respective socket, i.e. 0 or 1). E.g.:


```bash
sudo chmod a+rw /dev/dfl-port.0
```


### 6.3 Memlock limit

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


