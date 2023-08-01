# Platform Evaluation Script: Open FPGA Stack for Intel Agilex FPGA



## **1 Overview**


### **1.1 About this Document**


This document serves as a set-up and user guide for the checkout and evaluation of an Intel® FPGA SmartNIC N6001-PL development platform using Open FPGA Stack (OFS). After reviewing the document, you will be able to:

-   Set-up and modify the script to the your environment

-   Compile and simulate an OFS reference design

-   Run hardware and software tests to evaluate the complete OFS flow


#### **Table 1-2: Software Version Summary**

| Component | Version |  Description |
| --------- | ------- | -------|
| FPGA Platform | [Intel® FPGA SmartNIC N6001-PL](https://www.intel.com/content/www/us/en/products/details/fpga/platforms/smartnic/n6000-pl-platform.html)| Intel platform you can use for your custom board development |
| OFS FIM Source Code| [Branch: https://github.com/OFS/ofs-n6001](https://github.com/OFS/https://github.com/OFS/ofs-n6001), [Tag: ofs-2023.1-1](https://github.com/OFS/https://github.com/OFS/ofs-n6001/releases/tag/ofs-2023.1-1) | OFS Shell RTL for Intel Agilex FPGA (targeting Intel® FPGA SmartNIC N6001-PL) |
| OFS FIM Common| [Branch: https://github.com/OFS/ofs-fim-common/2023.1](https://github.com/OFS/ofs-fim-common), [Tag: https://github.com/OFS/ofs-fim-common/2023.1](https://github.com/OFS/ofs-fim-common/releases/tag/https://github.com/OFS/ofs-fim-common/2023.1) | Common RTL across all OFS-based platforms |
| AFU Examples| [Branch: examples-afu](https://github.com/OFS/examples-afu) , [Tag:ofs-examples-https://github.com/OFS/examples-afu/releases/tag/ofs-2023.1-1](https://github.com/OFS/examples-afu/releases/tag/https://github.com/OFS/examples-afu/releases/tag/ofs-2023.1-1) | Tutorials and simple examples for the Accelerator Functional Unit region (workload region)|
| OPAE SDK | [Branch: 2.5.0-3](https://github.com/OFS/opae-sdk/tree/2.5.0-3), [Tag: 2.5.0-3](https://github.com/OFS/opae-sdk/releases/tag/2.5.0-3) | Open Programmable Acceleration Engine Software Development Kit |
| Kernel Drivers | [Branch: ofs-2023.1-6.1-1](https://github.com/OFS/linux-dfl/tree/ofs-2023.1-6.1-1), [Tag: ofs-2023.1-6.1-1](https://github.com/OFS/linux-dfl/releases/tag/ofs-2023.1-6.1-1) | OFS specific kernel drivers|
| OPAE Simulation| [Branch: opae-sim](https://github.com/OFS/opae-sim), [Tag: 2.5.0-3](https://github.com/OFS/opae-sim/releases/tag/2.5.0-3) | Accelerator Simulation Environment for hardware/software co-simulation of your AFU (workload)|
| Intel Quartus Prime Pro Edition Design Software | 23.1 [Intel® Quartus® Prime Pro Edition Linux] | Software tool for Intel FPGA Development|
| Operating System | [RHEL 8.6](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.2/x86_64/product-software) |  Operating system on which this script has been tested |

A download page containing the release and already-compiled FIM binary artifacts that you can use for immediate evaluation on the Intel® FPGA SmartNIC N6001-PL can be found on the [OFS ofs-2023.1-1](https://github.com/OFS/ofs-n6001/releases/tag/ofs-2023.1-1) official release drop on GitHub.

<br>

## **2 Introduction to OFS Evaluation Script**


By following the setup steps and using the OFS evaluation script you can quickly evaluate many features that the OFS framework provides and also leverage this script for your own development.  

### **2.1 Pre-Requisites**

This script uses the following set of software tools which should be installed using the directory structure below. Tool versions can vary.

* Intel Quartus<sup>&reg;</sup> Prime Pro Software
* Synopsys<sup>&reg;</sup> VCS Simulator
* Siemens<sup>&reg;</sup> Questa<sup>&reg;</sup> Simulator

**Figure 2-1 Folder Hierarchy for Software Tools**

![](images/ofs_n6001_tools_menu.png)

1. You must create a directory named "ofs-X.X.X" where the X represents the current release number, for example ofs-2023.1-1. 

2. You must clone the required OFS repositories as per Figure 2-2.  Please refer to the BKC table for locations. Please go [OFS Getting Started User Guide] for the instructions for the BKC installation.

3. Once the repositories are cloned, copy the evaluation script (ofs_n6001_eval.sh) which is located at [eval_scripts] beneath the $IOFS_BUILD_ROOT directory location as shown in the example below:

**Figure 2-2 Directory Structure for OFS Project**

```sh
## ofs-2023.1-1
##  -> examples-afu
##  -> linux-dfl
##  -> ofs-n6001
##  -> oneapi-asp
##  -> oneAPI-samples
##  -> opae-sdk
##  -> opae-sim
##  -> ofs_n6001_eval.sh
```

4. Open the README file named (README_ofs_n6001_eval.txt) which is located at [eval_scripts] which informs the user which sections to modify in the script prior to building the FIM and running hardware, software and simulation tests.

### **2.2 n6001 Evaluation Script modification**


To adapt this script to the user environment please follow the instructions below which explains which line numbers to change in the ofs_n6001_eval.sh script 

### **User Directory Creation**

The user must create the top-level source directory and then clone the OFS repositories
    
    mkdir ofs-2023.1-1

In the example above we have used ofs-2023.1-1 as the directory name

### **Set-Up Proxy Server (lines 65-67)**

Please enter the location of your proxy server to allow access to external internet to build software packages.

Note: Failing to add proxy server will prevent cloning of repositories and the user will be unable to build the OFS framework.
    
    export http_proxy=<user_proxy>
    export https_proxy=<user_proxy>
    export no_proxy=<user_proxy>

### **License Files (lines 70-72)**

Please enter the the license file locations for the following tool variables

    export LM_LICENSE_FILE=<user_license>
    export DW_LICENSE_FILE=<user_license>
    export SNPSLMD_LICENSE_FILE=<user_license>

### **Tools Location (line 85, 86, 87, 88)**

Set Location of Quartus, Synopsys, Questasim and oneAPI Tools

    export QUARTUS_TOOLS_LOCATION=/home
    export SYNOPSYS_TOOLS_LOCATION=/home
    export QUESTASIM_TOOLS_LOCATION=/home
    export ONEAPI_TOOLS_LOCATION=/opt

### **Quartus Tools Version (line 93)**

Set version of Quartus

    export QUARTUS_VERSION=23.1

In the example above "23.1" is used as the Quartus tools version

### **OPAE Tools (line 106)**

change OPAE SDK VERSION<br>

    export OPAE_SDK_VERSION=2.5.0-3

In the example above "2.5.0-3" is used as the OPAE SDK tools version

### **PCIe (Bus Number) (lines 231 and 238)**

The Bus number must be entered by the user after installing the hardware in the chosen server, in the example below "b1" is the Bus Number for a single card as defined in the evaluation script.

    export ADP_CARD0_BUS_NUMBER=b1

 The evaluation script uses the bus number as an identifier to interrogate the card. The command below will identify the accelerater card plugged into a server. 

    lspci | grep acc
    
    b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)<br>
    b1:00.1 Processing accelerators: Intel Corporation Device bcce<br>
    b1:00.2 Processing accelerators: Intel Corporation Device bcce<br>
    b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device<br>
    b1:00.4 Processing accelerators: Intel Corporation Device bcce<br>

The result identifies the card as being assigned "b1" as the bus number so the entry in the script changes to

    export ADP_CARD0_BUS_NUMBER=b1

The user can also run the following command on the ofs_n6001_eval.sh script to automatically change the bus number to b1 in the ofs_n6001_eval.sh script.

grep -rli 'b1' * | xargs -i@ sed -i 'b1' @

if the bus number is 85 for example 

    85:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)<br>
    85:00.1 Processing accelerators: Intel Corporation Device bcce<br>
    85:00.2 Processing accelerators: Intel Corporation Device bcce<br>
    85:00.3 Processing accelerators: Red Hat, Inc. Virtio network device<br>
    85:00.4 Processing accelerators: Intel Corporation Device bcce<br>

the command to change to 85 in the evaluation script would be

grep -rli 'b1' * | xargs -i@ sed -i '85' @

The ofs_n6001_eval.sh script has now been modified to the server set-up and the user can proceed to build, compile and simulate the OFS stack

<br>

## **3 n6001 Evaluation Script**


### **3.1 Overview**


The figure below shows a snapshot of the full evaluation script menu showing all 62 options and each one one of 11 sub-menus which focus on different areas of evaluation. Each of these menu options are described in the next section.

**Figure 3-1 ofs_n6001_eval.sh Evaluation Menu**

![](images/ofs_n6001_adp_eval_menu.png)

### **3.1.1 ADP TOOLS MENU**


By selecting "List of Documentation for ADP n6001 Project," a list of links to the latest OFS documentation appears. Note that these links will take you to documentation for the most recent release which may not correspond to the release version you are evaluating. To find the documentation specific to your release, ensure you clone the intel-ofs-docs tag that corresponds to your OFS version.

By selecting "Check Versions of Operating System and Quartus Premier Design Suite", the tool verifies correct Operating System, Quartus version, kernel parameters, license files and paths to installed software tools.

![](images/ofs_n6001_adp_tools_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Example Output</th>
        </tr>
    </thead>
    <tbody>
        <tr>
             <td>1 - List of Documentation for ADP n6001 Project</td>
            <td> Open FPGA Stack Overview<br>
                 Guides you through the setup and build steps to evaluate the OFS solution<br>
                https://ofs.github.io<br>
</td>        
        </tr>
        <tr>
            <td>2 - Check versions of Operating System and Quartus Premier Design Suite (QPDS)</td>
            <td>Checking Linux release<br>
                Linux version 5.15.52-dfl (guest@hw-rae-svr4-l) (gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-4), GNU ld version 2.30-79.el8) #1 SMP Fri Sep 23 17:19:37 BST 2022<br>
                <br>
                Checking RedHat release<br>
                CentOS Linux release 8.3.2011<br>
                <br>
                Checking Ubuntu release<br>
                cat: /etc/lsb-release: No such file or directory<br>
                <br>
                Checking Kernel parameters<br>
                BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.15.52-dfl root=/dev/mapper/cl-root ro crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet intel_iommu=on pcie=realloc hugepagesz=2M hugepages=200<br>
                <br>
                Checking Licenses<br>
                LM_LICENSE_FILE is set to port@socket number:port@socket number<br>
                DW_LICENSE_FILE is set to port@socket number:port@socket number<br>
                SNPSLMD_LICENSE_FILE is set to port@socket number:port@socket number<br>
                <br>
                Checking Tool versions<br>
                QUARTUS_HOME is set to /home/intelFPGA_pro/23.1/quartus<br>
                QUARTUS_ROOTDIR is set to /home/intelFPGA_pro/23.1/quartus<br>
                IMPORT_IP_ROOTDIR is set to /home/intelFPGA_pro/23.1/quartus/../ip<br>
                QSYS_ROOTDIR is set to /home/intelFPGA_pro/23.1/quartus/../qsys/bin<br>
                <br>
                Checking QPDS Patches<br>
                Quartus Prime Shell<br>
                Version 23.1 Build XXX XX/XX/XXXX Patches X.XX SC Pro Edition<br>
                Copyright (C) XXXX  Intel Corporation. All rights reserved.<br>
                <br>
               </td>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.2 ADP HARDWARE MENU**


Identifies card by PCIe number, checks power, temperature and current firmware configuration. 

![](images/ofs_n6001_adp_hardware_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Example Output</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>3 - Identify Acceleration Development Platform (ADP) n6001 Hardware via PCIe</td>
            <td>PCIe card detected as<br>
                b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)<br>
                b1:00.1 Processing accelerators: Intel Corporation Device bcce<br>
                b1:00.2 Processing accelerators: Intel Corporation Device bcce<br>
                b1:00.4 Processing accelerators: Intel Corporation Device bcce<br>
                Host Server is connected to SINGLE card configuration<br>
                <br>
</td>        
        </tr>
        <tr>
            <td>4 - Identify the Board Management Controller (BMC) Version and check BMC sensors</td>
            <td>Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Board Management Controller Build version: 3.2.0<br>
                //****** BMC SENSORS ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>5 - Identify the FPGA Management Engine (FME) Version</td>
            <td>Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Management Controller Build version: 3.2.0<br>
                //****** FME ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
                Boot Page                        : user1<br>
                Factory Image Info               : a7c6879683182ce61084c420e51f50b6<br>
                User1 Image Info                 : 8a7440ddff52e0e27dbb989d5eb954f4<br>
                User2 Image Info                 : a7c6879683182ce61084c420e51f50b6<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>6 - Check Board Power and Temperature</td>
            <td>Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Board Management Controller Build version: 3.2.0<br>
                //****** POWER ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
                ( 1) VCCRT_GXER_0V9 Voltage      : 0.91 Volts<br>
                etc ......................<br>
            <br>
                Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Board Management Controller Build version: 3.2.0<br>
                //****** TEMP ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
                ( 1) FPGA E-Tile Temperature [Remote] : 33.50 Celsius<br>
                etc ......................<br>
                <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>7 - Check Accelerator Port status</td>
            <td>//****** PORT ******//
                Object Id                        : 0xED00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>8 - Check MAC and PHY status</td>
            <td>Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Board Management Controller Build version: 3.2.0<br>
                //****** MAC ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
                Number of MACs                   : 255<br>
                mac info is not supported<br>
            <br>
                Intel Acceleration Development Platform N6001<br>
                Board Management Controller NIOS FW version: 3.2.0<br>
                Board Management Controller Build version: 3.2.0<br>
                //****** PHY ******//<br>
                Object Id                        : 0xEE00000<br>
                PCIe s:b:d.f                     : 0000:B1:00.0<br>
                Vendor Id                        : 0x8086<br>
                Device Id                        : 0xBCCE<br>
                SubVendor Id                     : 0x8086<br>
                SubDevice Id                     : 0x1771<br>
                Socket Id                        : 0x00<br>
                Ports Num                        : 01<br>
                Bitstream Id                     : 0x50102027135A894<br>
                Bitstream Version                : 5.0.1<br>
                Pr Interface Id                  : 7dbb989d-5eb9-54f4-8a74-40ddff52e0e2<br>
            <br>
                //****** HSSI information ******//<br>
                HSSI version                     : 1.0<br>
                Number of ports                  : 8<br>
                Port0                            :25GbE        DOWN<br>
                Port1                            :25GbE        DOWN<br>
                Port2                            :25GbE        DOWN<br>
                Port3                            :25GbE        DOWN<br>
                Port4                            :25GbE        DOWN<br>
                Port5                            :25GbE        DOWN<br>
                Port6                            :25GbE        DOWN<br>
                Port7                            :25GbE        DOWN<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.3 ADP PF/VF MUX MENU**


This menu reports the number of PF/VF functions in the reference example and also allows you to reduce the number to 1PF and 1VF to reduce resource utilisation and create a larger area for your workload development. This selection is optional and if the user wants to implement the default number of PF's and VF's then option 9, 10 and 11 should not be used.  Additionally the code used to make the PF/VF modification can be leveraged to increase or modify the number of PF/VFs in the existing design within the limits that the PCIe Subsystem supports (8PF/2K VFs)

![](images/ofs_n6001_adp_pf_vf_mux_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>9 - Check PF/VF Mux Configuration</td>
            <td> This menu selection displays the current configuration of the pcie_host.ofss file which is located at the following directory $OFS_ROOTDIR/tools/pfvf_config_tool<br>
            <br>
                [ProjectSettings]<br>
                platform = n6001<br>
                family = Agilex<br>
                fim = base_x16<br>
                Part = AGFB014R24A2E2V<br>
                IpDeployFile = pcie_ss.sh<br>
                IpFile = pcie_ss.ip<br>
                OutputName = pcie_ss<br>
                ComponentName = pcie_ss<br>
                is_host = True<br>
                <br>
                [pf0]<br>
                num_vfs = 3<br>
                pg_enable = True<br>
                <br>
                [pf1]<br>
                <br>
                [pf2]<br>
                <br>
                [pf3]<br>
                <br>
                [pf4]<br>
<br>
            <br>
</td>        
        </tr>
        <tr>
            <td>10 - Modify PF/VF Mux Configuration</td>
            <td>As an example this menu selection modifies the pcie_host.ofss file to 1 PF located in the following directory $OFS_ROOTDIR/tools/pfvf_config_tool<br>
            This option also displays the the modified pcie_host.ofss file<br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>11 - Build PF/VF Mux Configuration</td>
            <td>If option 10 is not used then then the default number of PF's and VF's is used to build the FIM, if option 10 is selected then only 1 VF is built to reduce logic utilisation<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>


### **3.1.4 ADP FIM/PR BUILD MENU**


Builds FIM, Partial Reconfiguration Region and Remote Signal Tap

![](images/ofs_n6001_adp_fim_pr_build_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>12 - Check ADP software versions for ADP n6001 Project</td>
            <td>OFS_ROOTDIR is set to /home/user_area/ofs-X.X.X/ofs-n6001<br>
                OPAE_SDK_REPO_BRANCH is set to release/X.X.X<br>
                OPAE_SDK_ROOT is set to /home/user_area/ofs-X.X.X/ofs-n6001/../opae-sdk<br>
                LD_LIBRARY_PATH is set to /home/user_area/ofs-X.X.X/ofs-n6001/../opae-sdk/lib64:<br>
<br>
            <br>
</td>        
        </tr>
        <tr>
            <td>13 - Build FIM for n6001 Hardware</td>
            <td>This option builds the FIM based on the setting for the $ADP_PLATFORM, $FIM_SHELL environment variable. Check this variable in the following file ofs_n6001_eval.sh<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>14 - Check FIM Identification of FIM for n6001 Hardware</td>
            <td>The FIM is identified by the following file fme-ifc-id.txt located at $OFS_ROOTDIR/$FIM_WORKDIR/syn/syn_top/<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>15 - Build Partial Reconfiguration Tree for n6001 Hardware</td>
            <td>This option builds the Partial Reconfiguration Tree which is needed for AFU testing/development and also for the oneAPI build flow <br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>16 - Build Base FIM Identification(ID) into PR Build Tree template</td>
            <td>This option copies the contents of the fme-ifc-id.txt into the Partial Reconfiguration Tree to allow the FIM amd Partial Reconfiguration Tree to match and hence allow subsequent insertion of AFU and oneAPI workloads<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>17 - Build Partial Reconfiguration Tree for n6001 Hardware with Remote Signal Tap</td>
            <td>This option builds the Partial Reconfiguration Tree which is needed for AFU testing/development and also for the oneAPI build flow for the Remote Signal Tap flow<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>18 - Build Base FIM Identification(ID) into PR Build Tree template with Remote Signal Tap</td>
            <td>This option copies the contents of the fme-ifc-id.txt into the Partial Reconfiguration Tree for Remote Signal Tap to allow the FIM amd Partial Reconfiguration Tree to match and hence allow subsequent insertion of AFU and oneAPI workloads<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.5 ADP HARDWARE PROGRAMMING/DIAGNOSTIC MENU**


The following submenu allows you to:
* Program and check flash 
* Perform a remote system update (RSU) of the FPGA image into the FPGA
* Bind virtual functions to VFIO PCIe driver 
* Run host exerciser (HE) commands such as loopback to test interfaces VFIO PCI driver binding
* Read the control and status registers (CSRs) for bound modules that are part of the OFS reference design.

![](images/ofs_n6001_adp_hardware_programming_diagnostic_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>19 - Program BMC Image into n6001 Hardware</td>
            <td>The user must place a new BMC flash file in the following directory $OFS_ROOTDIR/bmc_flash_files. Once the user executes this option a new BMC image will be programmed. A remote system upgrade command is initiated to store the new BMC image<br>
            <br>
</td>        
        </tr>
        <tr>
            <td>20 - Check Boot Area Flash Image from n6001 Hardware</td>
            <td>This option checks which location area in FLASH the image will boot from, the default is user1<br>
            <br>
            Boot Page : user1<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>21 - Program FIM Image into user1 area for n6001 Hardware</td>
            <td>This option programs the FIM image "ofs_top_page1_unsigned_user1.bin" into user1 area in flash<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>22 - Initiate Remote System Upgrade (RSU) from user1 Flash Image into n6001 Hardware</td>
            <td>This option initiates a Remote System Upgrade and soft reboots the server and re-scans the PCIe bus for the new image to be loaded<br>
            <br>
            2022-11-10 11:26:24,307 - [[pci_address(0000:b1:00.0), pci_id(0x8086, 0xbcce)]] performing RSU operation<br>
            2022-11-10 11:26:24,310 - [[pci_address(0000:b0:02.0), pci_id(0x8086, 0x347a)]] removing device from PCIe bus<br>
            2022-11-10 11:26:24,357 - waiting 10 seconds for boot<br>
            2022-11-10 11:26:34,368 - rescanning PCIe bus: /sys/devices/pci0000:b0/pci_bus/0000:b0<br>
            2022-11-10 11:26:35,965 - RSU operation complete<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>23 - Check PF/VF Mapping Table, vfio-pci driver binding and accelerator port status</td>
            <td>This option checks the current vfio-pci driver binding for the PF's and VF's<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>24 - Unbind vfio-pci driver</td>
            <td>This option unbinds the vfio-pci driver for the PF's and VF's<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>25 - Create Virtual Functions (VF) and bind driver to vfio-pci n6001 Hardware</td>
            <td>This option creates vfio-pci driver binding for the PF's and VF's<br>
            Once the VF's have been bound to the driver the user can select menu option 23 to check that the new drivers are bound<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>26 - Verify FME Interrupts with hello_events</td>
            <td>The hello_events utility is used to verify FME interrupts. This tool injects FME errors and waits for error interrupts, then clears the errors<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>27 - Run HE-LB Test</td>
            <td>This option runs 5 tests<br>
            <br>
            1) checks and generates traffic with the intention of exercising the path from the AFU to the Host at full bandwidth<br>
            2) run a loopback throughput test using one cacheline per request<br>
            3) run a loopback read test using four cachelines per request<br>
            4) run a loopback write test using four cachelines per request<br>
            5) run a loopback throughput test using four cachelines per request<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>28 - Run HE-MEM Test</td>
            <td>This option runs 2 tests<br>
            <br>
            1) Checking and generating traffic with the intention of exercising the path from FPGA connected DDR; data read from the host is written to DDR, and the same data is read from DDR before sending it back to the host<br>
            2) run a loopback throughput test using one cacheline per request<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>29 - Run HE-HSSI Test</td>
            <td>This option runs 1 test<br> 
            <br>
            HE-HSSI is responsible for handling client-side ethernet traffic. It wraps the 10G and 100G HSSI AFUs, and includes a traffic generator and checker. The user-space tool hssi exports a control interface to the HE-HSSI's AFU's packet generator logic<br>
            <br>
            1) Send traffic through the 10G AFU
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>30 - Run Traffic Generator AFU Test</td>
            <td>This option runs 3 tests<br> 
            <br>
            TG AFU has an OPAE application to access & exercise traffic, targeting a specific bank<br>
            <br>
            1) Run the preconfigured write/read traffic test on channel 0<br>
            2) Target channel 1 with a 1MB single-word write only test for 1000 iterations<br>
            3) Target channel 2 with 4MB write/read test of max burst length for 10 iterations<br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>31 - Read from CSR (Command and Status Registers) for n6001 Hardware</td>
            <td>This option reads from the following CSR's<br>
            HE-LB Command and Status Register Default Definitions<br>
            HE-MEM Command and Status Register Default Definitions<br>
            HE-HSSI Command and Status Register Default Definitions<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.6  ADP HARDWARE AFU TESTING MENU**


This submenu tests partial reconfiguration by building and loading an memory-mapped I/O example AFU/workload, executes software from host, and tests remote signal tap.

![](images/ofs_n6001_adp_harwdare_afu_testing_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>32 - Build and Compile host_chan_mmio example</td>
            <td>This option builds the host_chan_mmio example from the following repo $OFS_PLATFORM_AFU_BBB/plat_if_tests/$AFU_TEST_NAME, where AFU_TEST_NAME=host_chan_mmio. This produces a GBS (Green Bit Stream) ready for hardware programming<br>
            <br>
</td>        
        </tr>
        <tr>
            <td>33 - Execute host_chan_mmio example</td>
            <td>This option builds the host code for host_chan_mmio example and programs the GBS file and then executes the test<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>34 - Modify host_chan_mmio example to insert Remote Signal Tap</td>
            <td>This option inserts a pre-defined host_chan_mmio.stp Signal Tap file into the OFS code to allow a user to debug the host_chan_mmio AFU example<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>35 - Build and Compile host_chan_mmio example with Remote Signal Tap</td>
            <td>This option builds the host_chan_mmio example from the following repo $OFS_PLATFORM_AFU_BBB/plat_if_tests/$AFU_TEST_NAME, where AFU_TEST_NAME=host_chan_mmio. This produces a GBS(Green Bit Stream) ready for hardware programming with Remote Signal tap enabled<br>
            <br>
        </tr>
</td>        
        </tr>
        <tr>
            <td>36 - Execute host_chan_mmio example with Remote Signal Tap</td>
            <td>This option builds the host code for host_chan_mmio example and programs the GBS file and then executes the test. The user must open the Signal Tap window when running the host code to see the transactions in the Signal Tap window<br>
            <td><br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.7 ADP HARDWARE AFU BBB TESTING MENU**


This submenu tests partial reconfiguration using a hello_world example AFU/workload, executes sw from host

![](images/ofs_n6001_adp_harwdare_afu_bbb_testing_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>37 - Build and Compile hello_world example</td>
            <td>This option builds the hello_ world example from the following repo $FPGA_BBB_CCI_SRC/samples/tutorial/afu_types/01_pim_ifc/$AFU_BBB_TEST_NAME, where AFU_BBB_NAME=hello_world. This produces a GBS(Green Bit Stream) ready for hardware programming<br>
            <br>
</td>        
        </tr>
        <tr>
            <td>38 - Execute hello_world example</td>
            <td>This option builds the host code for hello_world example and programs the GBS file and then executes the test<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.8 ADP ONEAPI PROJECT MENU**


Builds oneAPI kernel, executes sw from host and runs diagnostic tests

![](images/ofs_n6001_adp_oneapi_project_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Result</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>39 - Check oneAPI software versions for n6001 Project</td>
            <td>This option checks the setup of the oneAPI software and adds the relevant oneAPI environment variables to the terminal. This option also informs the user to match the oneAPI software version to the oneAPI-samples version<br>
            <br>
        <tr>
</td>        
        <tr>
            <td>40 - Build and clone shim libraries required by oneAPI host</td>
            <td>This option builds the oneAPI directory structure<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>41 - Install oneAPI Host Driver</td>
            <td>This option Installs the oneAPI Host driver at the following location /opt/Intel/OpenCLFPGA/oneAPI/Boards/, and requires sudo permission<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>42 - Uninstall oneAPI Host Driver</td>
            <td>This option Uninstall's the oneAPI Host driver, and requires sudo permissions<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>43 - Diagnose oneAPI Hardware</td>
            <td>This option Checks ICD (Intel Client Driver) and FCD (FPGA Client Driver), oneAPI library locations and detects whether oneAPI BSP is loaded into the FPGA<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>44 - Build oneAPI BSP ofs_n6001 Default Kernel (hello_world)</td>
            <td>This option Builds the oneAPI BSP using hello_world kernel<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>45 - Build oneAPI MakeFile Environment</td>
            <td>This option Builds the oneAPI environment using a Makefile for kernel insertion <br>
            <br>
        </tr>
</td>        
        <tr>
            <td>46 - Compile oneAPI Sample Application (board_test) for Emulation</td>
            <td>This option compiles the board_test kernel for Emulation<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>47 - Run oneAPI Sample Application (board_test) for Emulation</td>
            <td>This option executes the board_test kernel for Emulation<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>48 - Generate oneAPI Optimization report for (board_test)</td>
            <td>This option generates an optimization report for the board_test kernel<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>49 - Check PF/VF Mapping Table, vfio-pci driver binding and accelerator port status</td>
            <td>This option checks the current vfio-pci driver binding for the PF's and VF's<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>50 - Unbind vfio-pci driver</td>
            <td>This option unbinds the vfio-pci driver for the PF's and VF's<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>51 - Create Virtual Function (VF) and bind driver to vfio-pci n6001 Hardware</td>
            <td>This option creates vfio-pci driver binding for the PF's and VF's<br>
            Once the VF's have been bound to the driver the user can select menu option 45 to check that the new drivers are bound<br><br>
            <br>
        </tr>
</td>        
        <tr>
            <td>52 - Program OpenCL BSP ofs_n6001 Default Kernel (hello_world)</td>
            <td>This option programs the FPGA with a aocf file based on the hello_world kernel<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>53 - Compile oneAPI Sample Application (board_test) for Hardware</td>
            <td>This option compiles the board_test kernel for Hardware<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>54 - Run oneAPI Sample Application (board_test) for Hardware</td>
            <td>This option builds the host code for board_test kernel and executes the program running through kernel and host bandwidth tests<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>

### **3.1.9 ADP UNIT TEST PROJECT MENU**


Builds, compiles and runs standalone simulation block tests.  More unit test examples are found at the following location ofs_n6001/sim/unit_test 

![](images/ofs_n6001_adp_unit_test_project_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Result</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>55 - Generate Simulation files for Unit Test</td>
            <td>This option builds the simulation file set for running a unit test simulation<br>
            <br>
        </tr>
</td>        
        <tr>
            <td>56 - Simulate Unit Test dfh_walker and log waveform</td>
            <td>This option runs the dfh_walker based on the environment variable "UNIT_TEST_NAME=dfh_walker" in the evaluation script. A user can change the test being run by modifying this variable<br>
            <br>
        </tr>
</tr>
     </tbody>
</table>


### **3.1.10 ADP UVM PROJECT MENU**


Builds, compiles and runs full chip simulation tests.  The user should execute the options sequentially ie 68,69, 70 and 71

![](images/ofs_n6001_adp_uvm_project_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>57 - Check UVM software versions for n6001 Project</td>
            <td>DESIGNWARE_HOME is set to /home/synopsys/vip_common/vip_Q-2020.03A<br>
                UVM_HOME  is set to /home/synopsys/vcsmx/S-2021.09-SP1/linux64/rhel/etc/uvm<br>
                VCS_HOME is set to /home/synopsys/vcsmx/S-2021.09-SP1/linux64/rhel<br>
                VERDIR is set to /home/user_area/ofs-X.X.X/ofs-n6001/verification<br>
                VIPDIR is set to /home/user_area/ofs-X.X.X/ofs-n6001/verification<br>
            <br>
</td>        
        <tr>
            <td>58 - Compile UVM IP</td>
            <td>This option cmpiles the UVM IP <br>
            <br>
        <tr>
</td>        
        <tr>
            <td>59 - Compile UVM RTL and Testbench</td>
            <td>This option compiles the UVM RTL and Testbench<br>
            <br>
        <tr>
</td>        
        <tr>
            <td>60 - Simulate UVM dfh_walking_test and log waveform</td>
            <td>This option runs the dfh_walking test based on the environment variable "UVM_TEST_NAME=dfh_walking_test" in the evaluation script. A user can change the test being run by modifying this variable<br>
            <br>
        <tr>
            <td>61 - Simulate all UVM test cases (Regression Mode)</td>
            <td>This option runs the n6001 regression mode, cycling through all UVM tests defined in verification/tests/test_pkg.svh file<br>
            <br>
        <tr>
</tr>
     </tbody>
</table>

### **3.1.11 ADP BUILD ALL PROJECT MENU**


Builds the complete OFS flow, good for regression testing and overnight builds

For this menu a user can run a sequence of tests (compilation, build and simulation) and executes them sequentially. After the script is successfully executed, a set of binary files is produced which a you can use to evaluate your hardware. Log files are also produced which checks whether the tests passed.

A user can run a sequence of tests and execute them sequentially. In the example below when the user selects option 62 from the main menu the script will execute 24 tests ie (main menu options 2, 9, 12, 13, 14, 15, 16, 17, 18, 32, 34, 35, 37, 39, 40, 44, 45, 53, 55, 56, 57, 58, 59 and 60. These 24 menu options are chosen to build the complete OFS flow covering build, compile and simulation.

![](images/ofs_n6001_adp_build_all_project_menu.png)

<table>
    <thead>
        <tr>
            <th>Menu Option</th>
            <th>Result</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>62 - Build and Simulate Complete n6001 Project</td>
            <td>Generating Log File with date and timestamp<br>
                Log file written to /home/guest/ofs-2.3.1/log_files/n6001_log_2022_11_10-093649/ofs_n6001_eval.log<br>
            <br>
</tr>
     </tbody>
</table>

## **Definition of Multi-Test Set-up**

Menu Option 62 above in the evaluation script can be refined to tailor it to the users need and is principally defined by the variable below

MULTI_TEST[A,B]=C

where

A= Total Number of menu options in script<br>
B= Can be changed to a number to select the test order<br>
C= Menu Option in Script<br>

Example 1<br>
MULTI_TEST[62,0]=2

A= 62 is the total number of options in the script
B= 0 indicates that this is the first test to be run in the script
C= Menu option in Script ie 2- List of Documentation for ADP n6001 Project

Example 2<br>
MULTI_TEST[62,0]=2<br>
MULTI_TEST[62,1]=9<br>

In the example above two tests are run in order ie 0, and 1 and the following menu options are executed ie 2- List of Documentation for ADP n6001 Project and 9 - Check ADP software versions for ADP n6001 Project

The user can also modify the build time by de-selecting options they do not wish to use, see below for a couple of use-case scenarios.

## **Default User Case**

A user can run a sequence of tests and execute them sequentially. In the example below when the user selects option 62 from the main menu the script will execute 24 tests ie (main menu options 2, 9, 12, 13, 14, 15, 16, 17, 18, 32, 34, 35, 37, 39, 40, 44, 45, 53, 55, 56, 57, 58, 59 and 60. All other tests with an "X" indicates do not run that test.

![](images/ofs_n6001_default_build.png)

## **User Case for ADP FIM/PR BUILD MENU**

In the example below when the user selects option 62 from the main menu the script will only run options from the ADP FIM/PR BUILD MENU (7 options, main menu options 12, 13, 14, 15, 16, 17 and 18). All other tests with an "X" indicates do not run that test.

![](images/ofs_n6001_user_case1_build.png)

<br>

## **4 n6001 Common Test Scenarios**


This section will describe the most common compile build scenarios if a user wanted to evaluate an acceleration card on their server. The Pre-requisite column indcates the menu comamnds that must be run befere executing the test eg To run Test 5 then a user needs to have run option 13, 15 and 16 before running options 23, 24, 25, 32 and 33.

<table>
    <thead>
        <tr>
            <th>Test</th>
            <th>Test Scenario</th>
            <th>Pre-Requisite Menu Option</th>
            <th>Menu Option</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <tr>
            <td>Test 1</td>
            <td>FIM Build</td>
            <td>-<br>
            <td>13<br>
            <br>
        <tr>
            <tr>
            <td>Test 2</td>
            <td>Partial Reconfiguration Build</td>
            <td>13<br>
            <td>15, 16<br>
            <br>
        <tr>
            <tr>
            <td>Test 3</td>
            <td>Program FIM and perform Remote System Upgrade</td>
            <td>13<br>
            <td>21, 22<br>
            <br>
        <tr>
            <tr>
            <td>Test 4</td>
            <td>Bind PF and VF to vfio-pci drivers</td>
            <td>-<br>
            <td>23, 24, 25<br>
            <br>
        <tr>
            <tr>
            <td>Test 5</td>
            <td>Build, compile and test AFU on hardware</td>
            <td>13, 15, 16<br>
            <td>23, 24, 25, 32, 33<br>
            <br>
        <tr>
            <tr>
            <td>Test 6</td>
            <td>Build, compile and test AFU Basic Building Blocks on hardware</td>
            <td>13, 15, 16<br>
            <td>23, 24, 25, 37, 38<br>
            <br>
        <tr>
            <tr>
            <td>Test 7</td>
            <td>Build, compile and test oneAPI on hardware</td>
            <td>13, 15, 16<br>
            <td>39, 40, 41, 44, 45, 49, 50, 51, 52, 53, 54<br>
            <br>
        <tr>
            <tr>
            <td>Test 8</td>
            <td>Build and Simulate Unit Tests</td>
            <td>-<br>
            <td>55, 56<br>
            <br>
        <tr>
            <tr>
            <td>Test 9</td>
            <td>Build and Simulate UVM Tests</td>
            <td>-<br>
            <td>57, 58, 59, 60<br>
            <br>
        <tr>
</tr>
     </tbody>
</table>

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
 
