<h1>Simulation User Guide: Open FPGA Stack for Intel Stratix</h1>


## **Table of Contents**

[**1 Overview**](#overview)
* [**1.1 About this Document**](#about_doc)
* [**1.2 Glossary**](#glossary)

[**2 Introduction to the UVM**](#intro_to_uvm)

[**3 Testbench Architecture**](#testbench_architecture_uvm)

[**4 Testbench Infrastructure**](#testbench_infrastructure_uvm)
* [**4.1 Traffic Flow**](#traffic_flow_uvm)
* [**4.2 Link Up and Enumeration**](#link_up_enumeration_uvm)
    * [**4.2.1 Link Up**](#link_up_uvm)
    * [**4.2.2 Enumeration**](#enumeration_uvm)
    * [**4.2.3 PF/VF BAR**](#pf_vf_uvm)
* [**4.3 MMIO APIs**](#mmio_api_uvm)
* [**4.4 RAL**](#ral_uvm)
* [**4.5 VIP DUT Connection**](#vip_dut_uvm)

[**5 Test Plan**](#testplan_uvm)
* [**5.1 MMIO Path**](#mmio_uvm)
* [**5.2 HE-LB**](#he_lb_uvm)
* [**5.3 HE-MEM**](#he_mem_uvm)
* [**5.4 HS-HSSI**](#he_hssi_uvm)
    * [**5.4.1 Indirect Registers**](#indirect_registers_uvm)
    * [**5.4.2 TX Loopback**](#tx_loopback_uvm)
* [**5.5 Interrupt Test**](#interrupt_uvm)
* [**5.6 Performance Test**](#performance_uvm)
* [**5.7 CSR Test**](#csr_uvm)
    * [**5.7.1 Reset Value Check**](#reset_uvm)
    * [**5.7.2 RW Attribute CSR**](#rw_uvm)
    
[**6 Checking Mechanism**](#checking_uvm)
* [**6.1 Protocol Violation**](#protocol_uvm)
* [**6.2 Data Checking**](#data_checking_uvm)
* [**6.3 Counter Checking**](#counter_checking_uvm)
* [**6.4 AFU Error CSR**](#afu_error_uvm)

[**7 UVM Set-up**](#uvm_setup)<br>
* [**7.1 UVM Prerequiste**](#uvm_prereq)<br>
* [**7.2 License Requirements**](#uvm_license)<br>
* [**7.3 Software Tools Requirements**](#uvm_software)<br>
* [**7.4 Creating Software Tools script**](#uvm_modification)<br>

[**8 Running a UVM Simulation Test and Analysing Results**](#uvm_test)<br>
* [**8.1 Simulation**](#uvm_simulation)<br>
* [**8.2 File Structure**](#uvm_file_structure)<br>
* [**8.3 UVM Test Suite**](#uvm_test_suite)<br>
* [**8.4 IP Compile**](#uvm_ip_compile)<br>
* [**8.5 RTL & Test Bench Compile**](#uvm_rtl_testbench)<br>
* [**8.6 IP, RTL & Test Bench Compile**](#uvm_ip_rtl_testbench)<br>
* [**8.7 UVM Regression**](#uvm_regress)<br>
* [**8.8 UVM Waveform and Transcript Analysis**](#uvm_prereq)<br>

[**9 Modifying UVM Testbench**](#uvm_testbench_modification)<br>
* [**9.1 Modifying UVM environment when targeting different device**](#uvm_new_device)<br>
* [**9.2 Modifying UVM environment when adding a new interface**](#uvm_new_interface)<br>
* [**9.3 Adding a new UVM test**](#uvm_new_test)<br>
<br>

## **1 Overview**
<a name="overview"></a>

### **1.1 About this Document**
<a name="about_doc"></a>

This document serves as a set-up and user guide for the UVM simulation tool using Intel OFS. After reviewing the document, you will be able to:

    • Set-up the UVM verification tool suite
    • Run pre-existing UVM unit tests and also create new UVM tests for your design


### **1.2 Glossary**
<a name="glossary"></a>

This table defines some of the common terms used when discussing OFS.

| Acronym    | Expansion                                                      | Description                                                                                                                                                                                                                                                                           |
|:----------:|:--------------------------------------------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AFU        | Accelerator Functional Unit                                    | Hardware Accelerator implemented in FPGA logic which offloads a computational operation for an application from the CPU to improve performance.  <b>Note:</b>  An AFU region is the part of the design where an AFU may reside.  This AFU may or may not be a partial reconfiguration region. |
| BBB        | Basic Building Block                                           | Features within an AFU or part of an FPGA interface that can be reused across designs.  These building blocks do not have stringent interface requirements like the FIM's AFU and host interface requires.  All BBBs must have a (globally unique identifier) GUID.                   |
| FIM        | FPGA Interface Manager                                         | Provides platform management, functionality, clocks, resets and standard interfaces to host and AFUs.  The FIM resides in the static region of the FPGA and contains the FPGA Management Engine (FME) and I/O ring.                                       |
| FME        | FPGA Management Engine                                         | Provides a way to manage the platform and enable acceleration functions on the platform.                                                                                                                                                                                              |
|OFS    | Open FPGA Stack |A modular collection of hardware platform components, open source software, and broad ecosystem support that provides a standard and scalable model for AFU and software developers to optimize and reuse their designs.         |
| OPAE SDK   | Open Programmable Acceleration Engine Software Development Kit | A collection of APIs, software tools and upstreamed Linux* drivers to facilitate the development of software applications that allow the host to manage the FPGA accelerator card in an abstracted way.                                                                                                                                                     |
|OPAE        | Open Programmable Acceleration Engine Software Development Kit (OPAE SDK)    | A collection of libraries and tools to facilitate the development of software applications and accelerators using OPAE.|
| PIM        | Platform Interface Manager                                     | An interface manager that comprises two components: a configurable platform specific interface for board developers and a collection of shims that AFU developers can use to handle clock crossing, response sorting, buffering and different protocols.                              |
| Intel<sup>&reg;</sup> FPGA PAC D5005        | Intel FPGA Programmable Acceleration Card D5005                    | A high performance PCI Express* (PCIe*)-based FPGA acceleration card for data centers.  This card is the target platform for the initial OFS release.                              |
| Intel<sup>&reg;</sup> UPI | Intel<sup>&reg;</sup> Ultra Path Interconnect                                 | A coherent interconnect for scalable systems containing multiple processors in a single shared address space.                                                                                                                                                                         |
| UVM | Universal Verification Methadology                                 | A modular, reusable, and scalable testbench structure via an API framework.                                                                                                                                                                         |
| TB | Testbench                                 | Testbench or Verification Environment is used to check the functional correctness of the Design Under Test (DUT) by generating and driving a predefined input sequence to a design, capturing the design output and comparing with-respect-to expected output.                                                                                                                                                                         |
| AVST | Avalon Streaming                                 | Avalon Streaming.                                                                                                                                                                         |
| AXI | Advanced eXtenxible Interface                                 | Advanced eXtenxible Interface.                                                                                                                      |
| MCTP | MCTP                                 | Management Component Transport Protocol (MCTP) is a protocol designed by the Distributed Management Task Force (DMTF) to support communications between different intelligent hardware components that make up a platform management subsystem, providing monitoring and control functions inside a managed computer system.                                                                                                                                                                         |
| PMCI | PMCI                                 | Platform Management Component Intercommunications.                                                                                                                                                                         |
| CSR | Command/status registers (CSR) and software interface                                 | OFS uses a defined set of CSR's to expose the functionality of the FPGA to the host software.  |
| RAL | Register Abstraction Layer                                  | Design registers can be accessed independently of the physical bus interface. i.e. by calling read/write methods.
<br><br>

## **2 Introduction to UVM**
<a name="intro_to_uvm"></a>

OFS (Open FPGA Stack) provides a UVM (Universal Verification Methodology) environment for the FIM (FPGA Interface Manager) with a modular, reusable, and scalable testbench structure via an API framework.

The framework consists of a FIM Testbench which is UVM compliant and integrates third party VIPs from Synopsys for PCI Express, AXI4-Streaming interface and AXI4-Memory Mapped interface for comprehensive verification. The user will need to acquire licenses for these VIPs to use this Testbench. UVM RAL (Register Abstaction Layer) is used for CSR (Command and Status Registers) verification.

The qualified verification IPs will help to detect incorrect protocol behavior, help to focus on FIM features and accelerate the verification process.

Verification components include:

    • FIM monitor to detect correct design behavior
    • FIM assertions for signal level integrity testing
    • Arm AMBA AXI4 scoreboards to check data integrity
    • FIM coverage to collect functional data

## **3 Testbench Architecture**
<a name="testbench_architecture_uvm"></a>

The testbench connects to the full chip that includes major RTL blocks depicted in Figure 1.

<img src="images/ofs-uvm_testbench_architecture.png" alt="drawing" style="width:450px">

**Figure 1 Testbench Diagram**

The major interface is between the Xeon and FPGA where PCIe Verification IP is connected to PCIe Subsystem. Therefore, as a full chip simulation environment, PCIe host VIP is the sole VIP/BFM used. PCIe host VIP connects to PCIe device which resides in FPGA in serial mode.
<br><br>

## **4 Testbench Infrastructure**
<a name="testbench_infrastructure_uvm"></a>

## **4.1 Traffic Flow**
<a name="traffic_flow_uvm"></a>

PCIe Host, as the master of FPGA, initiates MMIO read/write requests to FPGA to program registers. The PCIe host also passively receives memory requests from FPGA to read from or write to host memory. 

## **4.2 Link Up and Enumeration**
<a name="link_up_enumeration_uvm"></a>

With serial mode connection between PCIe host and device, link training and enumeration has to be done before the regular traffic starts. 

## **4.2.1 Link Up**
<a name="link_up_uvm"></a>

Linkup sequence(pcie_device_bring_up_link_sequence) is part of configure sequence(ofs_config_seq), which is started in UVM configure phase. 

## **4.2.2 Enumeration**
<a name="enumeration_uvm"></a>

PCIe host driver needs to retrieve information from the device hard IP and program necessary configuration space registers, such as PF/VF BAR values. This is done in enumerate_seq, which follows link up sequence in configure sequence(ofs_config_seq). 

## **4.2.3 PF/VF BAR**
<a name="pf_vf_uvm"></a>

PF0 BAR0 is set in the base sequence and can be randomized. During enumeration, PF0 BAR0, along with PCIe device hard IP configuration, derives other PF and VF BAR values. These BAR values are stored into base sequence variables and can be used throughout any test sequences that extend the base sequence. 

## **4.3 MMIO APIs**
<a name="mmio_api_uvm"></a>

The base sequence provides APIs for 32-bit and 64-bit MMIO read/write accesses, as well as blocking or non-blocking for MMIO read as described in Table 1. The users can use MMIO APIs without knowing the underlining PCIe sequence items. 

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>API</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>32-bit MMIO Write</td>
            <td>task mmio_write32(input bit [63:0] addr_, input bit [31:0] data_);</td>        
        </tr>
        <tr>
            <td>64-bit MMIO Write</td>
            <td>task mmio_write64(input bit [63:0] addr_, input bit [63:0] data_);</td>        
        </tr>
        <tr>
            <td>32-bit MMIO Read</td>
            <td>task mmio_read32(input bit [63:0] addr_, output bit [31:0] data_, input blocking_ = 1);</td>        
        </tr>
        <tr>
            <td>64-bit MMIO Read</td>
            <td>task mmio_read64(input  bit [63:0] addr_, output bit [63:0] data_, input blocking_ = 1);</td>        
        </tr>
</tr>
     </tbody>
</table>

**Table 1 MMIO APIs**

## **4.4 RAL**
<a name="ral_uvm"></a>

UVM RAL is integrated in the testbench providing alternative ways of accessing CSRs in test sequences. RAL is generated from an excel format CSR specification where register name, field, offset, bitmap, attribute, and description are specified.

## **4.5 VIP DUT Connection**
<a name="vip_dut_uvm"></a>

PCIe host verification IP and DUT connection is achieved by connecting 16 bits lanes. The module for connection from VIP is svt_pcie_device_agent_serdes_x16_x8g_hdl.
<br><br> 

## **5 Test Plan**
<a name="testplan_uvm"></a>  

The test plan consists of four major categories: MMIO path, HE-LB, HE-MEM, HE-HSSI and interrupt tests. 

## **5.1 MMIO Path**
<a name="mmio_uvm"></a>   

The tests under this category exercise MMIO path including all destination functions or blocks as well as PF/VF mux and different fabrics. 

## **5.2 HE-LB**
<a name="he_lb_uvm"></a>

The tests under this category target HE-LB function only. Software which test sequences needs to configure HE-LB CSRs before starting it. These CSRs include SRC_ADDR, DST_ADDR, DSM_ADDR, NUM_LINES, CFG etc.   

If HE-LB is configured to have memory read transactions, PCIe host memory has to be initialized before HE-LB is started. This is done by svt_pcie_mem_target_service sequence. In other words, PCIe host VIP programs its internal memory model entries in backdoor way. The same process applies to DSM memory entry. 

Once HE-LB is started, HE-LB will function based on what it is programmed to do. When HE-LB is done with all necessary memory transactions, it will perform a final memory write to DSM memory entry. Since the software does not know when hardware is done, software polls DSM memory entry periodically until the DSM status bit is asserted. 

For loopback mode, data is compared between source buffer and destination buffer in host memory. 

RTL statistic counters are also compared against the corresponding variables inside the test sequence at the end of the simulation. 

## **5.3 HE-MEM**
<a name="he_mem_uvm"></a> 

HE-MEM tests are duplicates from HE-LB with MMIO to CSRs targeting HE-MEM instead of HE-LB. 

The DDR simulation model is inside memory controller IP when being generated.  

## **5.4 HE-HSSI**
<a name="he_hssi_uvm"></a> 

HE-HSSI has indirect registers that are associated with HSSI subsystem, MMIO for indirect registers is different from other functions. 

## **5.4.1 Indirect Registers**
<a name="indirect_registers_uvm"></a> 

To obtain access to indirect registers, either reading or writing, a MMIO write must be performed.

## **5.4.2 TX Loopback**
<a name="tx_loopback_uvm"></a> 

In TX loopback, HE-HSSI initiates ethernet packets to HSSI subsystem and the packets are looped back to HE-HSSI. The loopback is achieved by hard-wiring HSSI TX and RX lanes. This is done inside RTL and for simulation purposes only. 

## **5.5 Interrupt Test**
<a name="interrupt_uvm"></a>

The test plan covers the basic interrupt flow for FME error, PORT error and user AFU interrupts. The MSI-X table must be programmed in PF0 BAR4. Corresponding PBA bit is expected to be asserted. 

## **5.6 Performance Test**
<a name="performance_uvm"></a>

Performance tests are derived from HE-LB tests and they are directed tests. At the end of the simulation, performance number is calculated and printed to terminal and a log file. 

## **5.7 CSR Test**
<a name="csr_uvm"></a>

CSR consists of two parts. 

## **5.7.1 Reset Value Check**
<a name="reset_uvm"></a>

Front-door MMIO read data is compared against RAL register reset value out of reset. 

## **5.7.2 RW Attribute CSR**
<a name="rw_uvm"></a> 

MMIO write-read-compare is performed after reset value check for RW attribute CSRs.
<br><br>

## **6 Checking Mechanism**
<a name="checking_uvm"></a> 

Since there is only PCIe host verification component in testbench, data checking is done by a self-checking mechanism in the test sequence.  

## **6.1 Protocol Violation**
<a name="protocol_uvm"></a>  

PCIe host VIP has built-in protocol checking on TLP received from FPGA. Abnormal responses are also flagged by the VIP. 

Internal AXI Streaming interface has integrated RTL assertion to check AXI Streaming protocol violations. 

## **6.2 Data Checking**
<a name="data_checking_uvm"></a> 

Data checking is done by self-checking inside a test sequence. MMIO write/read/compare to read-writable CSRs is done inside a sequence. 

For memory transactions initiated by functions, backdoor reads from host memory on source buffer and destination buffer is done inside a sequence. Data is compared in case of loopback mode. 

## **6.3 Counter Checking**
<a name="counter_checking_uvm"></a>  

RTL statistic counters records the number of transactional information that can be read at the end of the simulation and compared against the test expected number. 

## **6.4 AFU Error CSR**
<a name="afu_error_uvm"></a>  

AFU interface handler provides an error log for illegal transactions that can be read at the end of the simulation.
<br><br>

## **7 UVM set-up**
<a name="uvm_set_up"></a>

 To run the tutorial steps in this guide requires the following development environment:

| Item                      | Version|
| ------------------------- | ----------|
| Intel Quartus Prime Pro   | Intel Quartus Prime Pro 22.3|
| Simulator (VCS)           | Synopsys VCS P-2019.06-SP2-5 or newer for UVM simulation of top level FIM|
| Simulator (Questasim)     | Questasim 2021.4 or newer for UVM simulation of top level FIM|

## **7.1 UVM Prerequisite**
<a name="uvm_prereq"></a>

Retrieve Intel OFS repositories.

The OFS FIM source code is included in the OTCShare GitHub repository. Create a new directory to use as a clean starting point to store the retrieved files.  The following is a short description of each repository, followed by the git commands for cloning.  The instructions section uses the HTTPS git method for cloning repositories.  Cloning the repo using the HTTPS method requires a personal access token.  Please see this blog post for information about obtaining a personal access token [Token authentication requirements for Git operations](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/).

Navigate to location for storage of OFS source, create the top-level source directory and clone OFS repositories.

    $ mkdir iofs_fim_build_root
    $ cd iofs_fim_build_root
    $ export IOFS_BUILD_ROOT=$PWD
    $ git clone git clone --recurse-submodules https://github.com/OFS/ofs-d5005.git
    
    Cloning into 'ofs-d5005' ...
    Username for 'https://github.com': <<Enter your git hub username>>
    Password for 'https://<<Your username>>': <<Enter your personal access token>>
    remote: Enumerating objects:  ....
    ...
    ...
    Resolving deltas  ..., done.

    $ cd ofs-d5005
    $ git checkout tags/XXXX

Verify that the correct tag/branch have been checked out        

    $ git describe --tags

    $ XXXX

## **7.2 License Requirements**
<a name="uvm_license"></a>

The FIM Testbench is UVM compliant and integrates third party VIPs from Synopsys for PCI Express, AXI4-Streaming interface and AXI4-Memory Mapped interface for comprehensive verification. The user will need to acquire licenses for these VIPs to use this TB. UVM RAL (Register Abstraction Layer) is used for CSR Verification.

The Qualified Verification IPs will help to detect incorrect protocol behavior easily, help to focus on BBS features and accelerate the verification process.

    • VCS & DVE
    • SNPS-Assertions
    • Verdi
    • VerdiCoverage
    • VerdiSimDB
    • VerdiTransactionDebugUltra
    • VIP-AMBA-AXI-SVT
    • VIP-AMBA-STREAM-SVT
    • VIP-PCIE-SVT
    • VIP-PCIE-TS-SVT
    • VIP-PCIE-G3-OPT-SVT

## **7.3 Software Tools Requirements**
<a name="uvm_software"></a>

The following tools are required for successful UVM set-up

    • Python 3.7 and later
    • Synopsys PCIE and AMBA AXI UVM VIP Q-2020.03A License
    • Synopsys Verdi R-2020.12-SP2 License

Note: Makefile can be modified to use DVE instead of Verdi

    • VCS R-2020.12-SP2 License

## **7.4 Creating a Software Tools Script**
<a name="uvm_modification"></a>

The UVM tool set-up is best done by creating a simple set-up script so all applicable tools are sourced before running the tests.

The following environment variables can be pasted into a script and used prior to running the UVM verification environment

## License Files
    export LM_LICENSE_FILE=
    export SNPSLMD_LICENSE_FILE=

The license environment variables LM_LICENSE_FILE and SNPSLMD_LICENSE_FILE can point to a server license on your system.

## General Environment Variables
    export IOFS_BUILD_ROOT=$PWD
    export OFS_ROOTDIR=<user_path>/ofs-d5005
    export WORKDIR=$OFS_ROOTDIR

## Quartus Tools
    export QUARTUS_HOME=<user_path>/intelFPGA_pro/22.3/quartus
    export QUARTUS_ROOTDIR=$QUARTUS_HOME
    export QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
    export QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR
    export IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip
    export QSYS_ROOTDIR=$QUARTUS_ROOTDIR/../qsys/bin
    export PATH=$QUARTUS_HOME/bin:$QUARTUS_HOME/qsys/bin:$QUARTUS_HOME/sopc_builder/bin/:$PATH

## Synopsys Verification Tools
    export DESIGNWARE_HOME=<user_path>/synopsys/vip_common/vip_Q-2020.03A
    export PATH=$DESIGNWARE_HOME/bin:$PATH
    export UVM_HOME=<user_path>/synopsys/vcsmx/R-2020.12-SP2/linux64/rhel/etc/uvm
    export VCS_HOME=<user_path>/synopsys/vcsmx/R-2020.12-SP2/linux64/rhel
    export PATH=$VCS_HOME/bin:$PATH
    export VERDIR=$OFS_ROOTDIR/verification
    export VIPDIR=$VERDIR

## QuestaSIM Verification Tools
    export MTI_HOME=<user_path>/mentor/questasim/2021.4/linux64
    export PATH=$MTI_HOME/linux_x86_64/:$MTI_HOME/bin/:$PATH
    export QUESTA_HOME=$MTI_HOME
 
<br>

## **8 Running a UVM Simulation Test and Analysing Results**
<a name="uvm_test"></a>

## **8.1 Simulation**
<a name="uvm_simulation"></a>
The default simulator used in this document is Synopsys VCS-MX but there will be references to Questasim. Users can refer to the options and adopt the options for other simulators. 

The script is a makefile that calls vlogan, vcs and simv for compilation, elaboration and simulation, respectively

## **8.2 File Structure**
<a name="uvm_file_structure"></a>
After cloning the repo, the verification and ofs-common directories contain all UVM verification related files. The directory structure is shown in Figure 2 below.

<img src="images/ofs-uvm_directory_structure.png" alt="drawing" style="width:450px">

**Figure 2 UVM Verification Directory File Structure**

ofs-d5005/ofs-common/verification/fpga_family/stratix10/testbench has a testbench, uvm env, virtual sequencer, RAL etc. 

ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests contains all uvm tests and sequences. 

Users can run the simulation under "ofs-d5005/verification/scripts" directory and the simulation result is outputted to a "sim" directory for Synopsys VCS or sim_msim for Questasim.

The simulation result folder is named after the test name with increasing suffix number. If user runs the same test multiple times, the suffix is incremented by 1 each time.

## **8.3 UVM Test Suite**
<a name="uvm_test_suite"></a>

The UVM environment contains a variety of tests that have been developed to test out the FIM portion of OFS.

The table below lists out the "Test Name" which will be used on the command line to execute the test, the "Test Scenario" and the "Checking Crieria".

Tests are located at ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests

<table>
    <thead>
        <tr>
            <th>Test Name</th>
            <th>DUT Scope</th>
            <th>Test Scenario</th>
            <th>Checking Criteria</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>ofs_dfh_walking_test</td>
            <td>DFH</td>
            <td>DHF walking</td>
            <td>offset checking, eol checking</td>
        </tr>
        <tr>
            <td>ofs_flr_reset_test</td>
            <td>FLR Reset</td>
            <td>FLR reset to all PFs</td>
            <td>Reset checking</td>
        </tr>
        <tr>
            <td>ofs_flr_vf0_reset_test</td>
            <td>FLR Reset</td>
            <td>FLR reset to VF0</td>
            <td>Reset checking</td>
        </tr>
        <tr>
            <td>ofs_flr_vf1_reset_test</td>
            <td>FLR Reset</td>
            <td>FLR reset to VF1</td>
            <td>Reset checking</td>
        </tr>
        <tr>
            <td>ofs_flr_vf2_reset_test</td>
            <td>FLR Reset</td>
            <td>FLR reset to VF2</td>
            <td>Reset checking</td>
        </tr>
        <tr>
            <td>ofs_fme_csr_test</td>
            <td>FME CSR</td>
            <td>CSR accesses</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_fme_hemem_intr_test</td>
            <td>Interrupt</td>
            <td>FME and HE MEM interrupt</td>
            <td>Interrupts assertion, PBA bits check</td>
        </tr>
        <tr>
            <td>ofs_fme_intr_test</td>
            <td>Interrupt</td>
            <td>FME error interrupt</td>
            <td>Interrupts assertion, PBA bits check</td>
        </tr>
        <tr>
            <td>ofs_he_hssi_csr_test</td>
            <td>HE-HSSI</td>
            <td>CSR accesses for HSSI</td>
            <td>data checking</td>
        </tr>
         <tr>
            <td>ofs_he_hssi_err_test</td>
            <td>HE-HSSI</td>
            <td>Error Cases</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_hssi_rx_lpbk_test</td>
            <td>HE-HSSI</td>
            <td>RX loopback</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_he_hssi_tx_lpbk_test</td>
            <td>HE-HSSI</td>
            <td>TX loopback</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_cont_test</td>
            <td>HE-LPBK</td>
            <td>Continuous mode/LPBK mode, random num_lines, addresses, req_len</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_long_rst_test</td>
            <td>HE-MEM</td>
            <td>Multiple iterations of he_lpb_seq with soft reset HE-LB in middle</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_long_test</td>
            <td>HE-MEM</td>
            <td>Multiple iterations of he_lpb_seq with STOP HE-LB in middle</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_port_rst_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode.  Randomize num_lines, addresses, req_len with port rst</td>
            <td>data checking</td>
        </tr>
       <tr>
            <td>ofs_he_lpbk_rd_cont_test</td>
            <td>HE-LPBK</td>
            <td>Read only mode/ Continuous mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_rd_test</td>
            <td>HE-LPBK</td>
            <td>Read only mode. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_reqlen1_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode. 128 CLs, req_len = 1CL, random addresses</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_reqlen2_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode. 128 CLs, req_len = 2CL, random addresses.</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_reqlen4_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode. 128 CLs, req_len = 4CL, random addresses</td>
            <td>data checking, counter checking</td>
        <tr>
        <tr>
            <td>ofs_he_lpbk_reqlen8_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode. 128 CLs, req_len = 8CL, random addresses</td>
            <td>data checking, counter checking</td>
        <tr>
        <tr>
            <td>ofs_he_lpbk_test</td>
            <td>HE-LPBK</td>
            <td>Loopback mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_thruput_contmode_test</td>
            <td>HE-LPBK</td>
            <td>Continuous mode, Read/Write mode. 50/50. Randomize num_lines, addresses req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_thruput_test</td>
            <td>HE-LPBK</td>
            <td>Read/Write mode. 50/50. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_wr_cont_test</td>
            <td>HE-LPBK</td>
            <td>Write only mode/ Continuous mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_lpbk_wr_test</td>
            <td>HE-LPBK</td>
            <td>Write only mode. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_cont_test</td>
            <td>HE-MEM</td>
            <td>Continuous mode/LPBK mode, random num_lines, addresses, req_len</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_long_rst_test</td>
            <td>HE-LPBK</td>
            <td>Multiple iterations of he_lpb_seq with soft reset HE-LB in middle</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_long_test</td>
            <td>HE-LPBK</td>
            <td>Multiple iterations of he_lpb_seq with STOP HE-LB in middle</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_reqlen1_test</td>
            <td>HE-MEM</td>
            <td>Loopback mode. 128 CLs, req_len = 1CL, random addresses.</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_reqlen2_test</td>
            <td>HE-MEM</td>
            <td>Loopback mode. 128 CLs, req_len = 2CL, random addresses.</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_reqlen4_test</td>
            <td>HE-MEM</td>
            <td>Loopback mode. 128 CLs, req_len = 4CL, random addresses</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_lpbk_test</td>
            <td>HE-MEM</td>
            <td>Loopback mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_rd_cont_test</td>
            <td>HE-MEM</td>
            <td>Read only mode/ Continuous mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_rd_test</td>
            <td>HE-MEM</td>
            <td>Read only mode. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_thruput_contmode_test</td>
            <td>HE-MEM</td>
            <td>Continuous mode, Read/Write mode. 50/50. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_thruput_test</td>
            <td>HE-MEM</td>
            <td>Read/Write mode. 50/50. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_wr_cont_test</td>
            <td>HE-MEM</td>
            <td>Write only mode/ Continuous mode. Randomize num_lines, addresses, req_len</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_mem_wr_test</td>
            <td>HE-MEM</td>
            <td>Write only mode. Randomize num_lines, addresses, req_len</td>
            <td>counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_random_long_test</td>
            <td>All HE's</td>
            <td>Enable all HEs and randomize modes for multiple iterations</td>
            <td>data checking if in lpbk mode, counter checking</td>
        </tr>
        <tr>
            <td>ofs_he_random_test</td>
            <td>All HEs</td>
            <td>Enable all HEs and randomize modes</td>
            <td>data checking if in lpbk mode, counter checking</td>
        </tr>
        <tr>
            <td>ofs_hehssi_csr_test</td>
            <td>HE-HSSI</td>
            <td>CSR accesses for Traffic Control Mail box registers</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_helb_csr_test</td>
            <td>HE-LPBK</td>
            <td>CSR accesses</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_helb_rd_1cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 1CL; 1024 CLs; Read only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_rd_2cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 2CL; 1024 CLs; Read only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_rd_4cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 4CL; 1024 CLs; Read only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_thruput_1cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 1CL; 1024 CLs; Thruput mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_thruput_2cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 2CL; 1024 CLs; Thruput mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_thruput_4cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 4CL; 1024 CLs; Thruput mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_wr_1cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 1CL; 1024 CLs; Write only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_wr_2cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 2CL; 1024 CLs; Write only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_helb_wr_4cl_test</td>
            <td>Performance</td>
            <td>HE-LB; ReqLen = 4CL; 1024 CLs; Write only mode</td>
            <td>data checking, counter checking</td>
        </tr>
        <tr>
            <td>ofs_hemem_csr_test</td>
            <td>HE-MEM</td>
            <td>CSR accesses</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_hemem_intr_test</td>
            <td>Interrupt</td>
            <td>HE MEMN Interrupt</td>
            <td>Interrupts assertion, PBA bits check</td>
        </tr>
        <tr>
            <td>ofs_malformedtlp_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
        <tr>
            <td>ofs_maxpayloaderror_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
        <tr>
            <td>ofs_MaxTagError_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3.Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
        <tr>
            <td>ofs_mini_smoke_test</td>
            <td>All HEs</td>
            <td>shorter simpler version of random test for turn-in sanity check</td>
            <td>data checking if in lpbk mode, counter checking</td>
        </tr>
        <tr>
            <td>ofs_mmio_64b_bar_test</td>
            <td>PCIe MMIO Path</td>
            <td>64-bit bar addess for MMIO</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_mmio_stress_nonblocking_test</td>
            <td>PF/VF Mux/Demux</td>
            <td>Stressing MMIO on PF/VF Mux/Demux with non-blocking MMIO reads</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_mmio_stress_test</td>
            <td>PF/VF Mux/Demux</td>
            <td>Stressing MMIO on PF/VF Mux/Demux</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_mmio_test</td>
            <td>PCIe MMIO Path</td>
            <td>MMIO targeting PF0(ST2MM, FME, PMCI, HSSI SS), PF1, PF1.VF1, PF1.VF2</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_mmio_unimp_test</td>
            <td>PCIe MMIO Path</td>
            <td>MMIO acccess to unimplemented addresses</td>
            <td>MMIO checking</td>
        </tr>
        <tr>
            <td>ofs_MMIODataPayloadOverrun_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
        <tr>
            <td>ofs_MMIOInsufficientData_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
        <tr>
            <td>ofs_MMIOTimedout_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR  CSR by writing one to the bits that are set9. Read the AFU_INTF_FIRST_ERROR  CSR. Be sure all bits are cleared<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing.</td>
        </tr>
         <tr>
            <td>ofs_msix_csr_test</td>
            <td>MSIX CSR</td>
            <td>CSR accesses</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_pmci_csr_test</td>
            <td>PMCI CSR</td>
            <td>CSR accesses</td>
            <td>data checking</td>
        </tr>
        <tr>
            <td>ofs_port_gasket_csr_test</td>
            <td>PORT GASKET</td>
            <td>Port Gasket CSR test</td>
            <td>port csr checking</td>
        </tr>
         <tr>
            <td>ofs_TxMWrDataPayloadOverrun_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing</td>
        </tr>
        <tr>
            <td>ofs_TxMWrInsufficientData_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be returned on reads. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing</td>
        </tr>
        <tr>
            <td>ofs_UnexpMMIORspErr_test</td>
            <td>Protocol Checker</td>
            <td>Checks for different PCIe Protocol error generation (upstram/downstream) and check the clear mechanism of AFU for these detected protocol errors.<br>
            1. Apply the error<br>
            2. Wait 5us 1us<br>
            3. Set the port reset bit true and then false again (within 1us) (You will not be able to perform a read-modify-write because F's will be retuened on resds. Write a 0x5 to set and a 0x4 to clear)<br>
            4. Wait 124us 135us (or 7.5us 28us if MMIO_TIMEOUT_CYCLES is 512.)<br>
            5. Read bit 31 of the AFU_INTF_ERROR, BlockingTraffic. If it is set it means that we did not wait long enough in step 4<br>
            6. Read the AFU_INTF_ERROR  register, Be sure only the expected error(s) are set<br>
            7. Read the AFU_INTF_FIRST_ERROR CSR. Be sure only one error bit is set and it is the expected one<br>
            8. Clear the errors in the AFU_INTF_ERROR CSR by writing one to the bits that are set<br>
            9. Read the AFU_INTF_FIRST_ERROR CSR. Be sure all bits are cleared</td>
            <td>Check AFU_INTF_ERROR and AFU_INTF_FIRST_ERROR register is getting set with correct error vector. After clearing the error register,check if normal transcation are completing</td>
        </tr>
</tr>
     </tbody>
</table>   

<br><br>

The next section describes how to compile and build the UVM environment prior to running each UVM test and analyinsg the results in the log files 

## **8.4 IP Compile**
<a name="uvm_test"></a>

## **Synopsys VCS**
To compile all IPs for the Synopsys VCS simulater:

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_VCS.mk cmplib
## **Questasim**
To compile all IPs for the Questasim simulater:

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_MSIM.mk cmplib 

## **8.5 RTL & Test Bench Compile**
<a name="uvm_rtl_testbench"></a>

The RTL file list for compilation is located here: verification/scripts/rtl_comb.f

The TB file list for compilation is located here: verification/scripts/ver_list.f

## **Synopsys VCS**
To compile RTL and Testbench for the Synopsys VCS simulater

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_VCS.mk build DUMP=1
## **Questasim**
To compile RTL and Testbench for the Questasim simulater

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_MSIM.mk build DUMP=1

## **8.6 IP and RTL & Test Bench Compile**
<a name="uvm_ip_rtl_testbench"></a>

## **Synopsys VCS**
If the user wants to compile all IPs and RTL Testbench in one command for Synopsys VCS then follow the procedure below

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_VCS.mk build_all DUMP=1
## **Questasim**
If the user wants to compile all IPs and RTL Testbench in one command for Questasim then follow the procedure below

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_MSIM.mk build_all DUMP=1

## **Synopsys VCS**
To run a simulation for Synopsys VCS:

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_VCS.mk run TESTNAME=ofs_mmio_test DUMP=1
## **Questasim**
To run a simulation for Questasim:

        cd ofs-d5005/verification/scripts

        gmake -f Makefile_MSIM.mk run TESTNAME=ofs_mmio_test DUMP=1 

## **Synopsys VCS**
To dump the waveform, "DUMP=1" must be added into the command line for Synopsys VCS build and simulation. 

        ofs-d5005/verification/scripts  gmake -f Makefile_VCS.mk build DUMP=1

        ofs-d5005/verification/scripts  gmake -f Makefile_VCS.mk run TESTNAME=<test_case_name> DUMP=1
Or

        ofs-d5005/verification/scripts  gmake -f Makefile_VCS.mk build_run TESTNAME=<test_case_name> DUMP=1

## **Questasim**
To dump the waveform, "DUMP=1" must be added into the command line for Questasim build and simulation. 

        ofs-d5005/verification/scripts  gmake -f Makefile_MSIM.mk build DUMP=1

        ofs-d5005/verification/scripts  gmake -f Makefile_MSIM.mk run TESTNAME=<test_case_name> DUMP=1
Or

        ofs-d5005/verification/scripts  gmake -f Makefile_MSIM.mk build_run TESTNAME=<test_case_name> DUMP=1

There are some optimizations in the Table below for convenience if you want to bypass some commands for both Synopsys VCS and Questasim:

<table>
    <thead>
        <tr>
            <th>Command (Synopsys VCS)</th>
            <th>Command (Questasim)</th>
            <th>Details</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>gmake -f Makefile_VCS.mk build_all DUMP=1</td>
            <td>gmake -f Makefile_MSIM.mk build_all DUMP=1</td>                        
            <td>compile IP + compile RTL</td>        
        </tr>
        <tr>
            <td>gmake -f Makefile_VCS.mk build_run TESTNAME=<test_case_name> DUMP=1</td>
            <td>gmake -f Makefile_MSIM.mk build_run TESTNAME=<test_case_name> DUMP=1</td>
            <td>compile RTL + run test</td>        
        </tr>
        <tr>
            <td>gmake -f Makefile_VCS.mk do_it_all TESTNAME=<test_case_name> DUMP=1</td>
            <td>gmake -f Makefile_MSIM.mk do_it_all TESTNAME=<test_case_name> DUMP=1</td>
            <td>compile IP, RTL and run test</td>        
        </tr>
        <tr>
            <td>gmake -f Makefile_VCS.mk rundb TESTNAME=<test_case_name> DUMP=1</td>
            <td>gmake -f Makefile_MSIM.mk rundb TESTNAME=<test_case_name> DUMP=1</td>
            <td>run test in sim dir + over-writes content</td>        
        </tr>
</tr>
     </tbody>
</table>

## **8.7 UVM Regression Test**
<a name="uvm_regress"></a>

    cd $VERDIR/scripts

    For Regression in VCS with top/test package, execute the following command 
        "perl $OFS_ROOTDIR/ofs-common/verification/fpga_family/stratix/scripts/regress_run_d5005.pl vcs"

    Results are created in a sim directory ($VERDIR/sim) with individual testcase log dir
    
    For Regression in MSIM with top/test package, execute the following command 
        "perl $OFS_ROOTDIR/ofs-common/verification/fpga_family/stratix/scripts/regress_run_d5005.pl msim"

   Results are created in a sim directory ($VERDIR/sim_msim) with individual testcase log dir

## **8.8 UVM Waveform and Transcript Analysis**
<a name="uvm_waveform_transcript"></a>

## **Synopsys VCS**
Running Synopsys VCS UVM tests will generate a ofs-d5005/verification/sim directory

    • All build time logs are at ofs-d5005/verification/sim

    • Each testcase will have separate directory inside sim ofs-d5005/verification/sim/<test_case_name>

There are two tracker or log files that are available: runsim.log and trans.log. 

runsim.log is the simulation log file generated from Synopsys VCS. The test sequence prints useful information for debugging purpose, such as the base address for each function or block. For HE-LB and HE-MEM, key information such as SRC_ADDR, DST_ADDR, NUM_LINES, mode, req_len etc is printed out as shown in Figure 2

<img src="images/ofs-uvm_runsim_log.png" alt="drawing" style="width:450px">

**Figure 2 runsim.log**

trans.log is generated from PCIe host VIP. trans.log records all transaction information coming in or going out of the VIP. Users can find traffic direction(DIR), TLP type, Tag, Address or BDF, 3 or 4 dword header of the TLP as shown in Figure 3

<img src="images/ofs-uvm_trans_log.png" alt="drawing" style="width:450px">

**Figure 3 trans.log**

The waveform generated is named as "inter.vpd". To open the waveform, go to simulation result directory and run 

        dve -full64 -vpd inter.vpd &

## **Questasim**
Running Questasim UVM tests will generate a ofs-d5005/verification/sim_msim directory

    • All build time logs are at ofs-d5005/verification/sim_msim

    • Each testcase will have separate directory inside sim ofs-d5005/verification/sim_msim/<test_case_name>

There are two tracker or log files that are available: runsim.log and trans.log. 

runsim.log is the simulation log file generated from Questasim. The test sequence prints useful information for debugging purpose, such as the base address for each function or block. For HE-LB and HE-MEM, key information such as SRC_ADDR, DST_ADDR, NUM_LINES, mode, req_len etc is printed out as shown in Figure 3

<img src="images/ofs-uvm_runsim_log.png" alt="drawing" style="width:450px">

**Figure 4 runsim.log**

trans.log is generated from PCIe host VIP. trans.log records all transaction information coming in or going out of the VIP. Users can find traffic direction(DIR), TLP type, Tag, Address or BDF, 3 or 4 dword header of the TLP as shown in Figure 5

<img src="images/ofs-uvm_trans_log.png" alt="drawing" style="width:450px">

**Figure 5 trans.log**

The waveform generated is named as "vsim.wlf". To open the waveform, go to simulation result directory and run 

        vsim -view vsim.wlf &    

## **9 Modifying UVM Testbench**
<a name="uvm_testbench_modification"></a>

The next section describe what needs to be considered when modifying the UVM, targeting a different device, adding a new interface to the testbench and creating a new UVM test for a customised OFS Accelerator platform.

## **9.1 Modifying UVM environment when targeting different device**
<a name="uvm_new_device"></a>

A new device may have different design feature or flow. The base address must be allocated for the new device. The MMIO targeting the new device must be based on the base address. If it is a new PF or VF, PCIe HIP must be regenerated and enumeration sequence must be updated accordingly. 

## **9.2 Modifying UVM environment when adding a new interface**
<a name="uvm_new_interface"></a>

Adding a new interface requires signal connections in the testbench. An additional BFM or verification IP is needed to drive the new interface. The main testbench file ofs_tb_top.sv is found at the following location

        $OFS_ROOTDIR/ofs-common/verification/fpga_family/stratix10//testbench

## **9.3 Adding a new UVM test**
<a name="uvm_new_test"></a>

In the following exmaple we will modify an existing test "ofs_he_lpbk" and name it "ofs_he_lpbk_new", and rebuild the test to check it. Please follow the steps below 

1) Create a new test sequence file under ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests/sequences

        ofs_he_lpbk_seq_new.svh

2) Modify ifndef, define and endif statements in new test sequence case i.e ofs_he_lpbk_seq_new.svh file

        `ifndef OFS_HE_LPBK_SEQ_NEW_SVH 
        `define OFS_HE_LPBK_SEQ_NEW_SVH
        `endif // OFS_HE_LPBK_SEQ_NEW_SVH
    
    also replace all occurences of ofs_he_lpbk_seq with ofs_he_lpbk_seq_new in the ofs_he_lpbk_seq_new.svh file

3) Append the new sequence name into ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests/sequences/ofs_seq_lib.svh file

        `include "ofs_he_lpbk_seq_new.svh"

4) Create a new test under ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests

        ofs_he_lpbk_test_new.svh

5) Modify ifndef, define and endif statements in new test case i.e ofs_he_lpbk_test_new.svh file

        `ifndef OFS_HE_LPBK_TEST_NEW_SVH 
        `define OFS_HE_LPBK_TEST_NEW_SVH
        `endif // OFS_HE_LPBK_TEST_NEW_SVH

    also replace all occurences of ofs_he_lpbk_test with ofs_he_lpbk_test_new in the ofs_he_lpbk_test_new.svh file

6) Append the new test name into ofs-d5005/ofs-common/verification/fpga_family/stratix10/tests/ofs_test_pkg.svh file

        `include "ofs_he_lpbk_test_new.svh"

7) Rebuild UVM test suite for either Synopsys VCS or Questasim simulater

        cd ofs-d5005/verification/scripts
        gmake -f Makefile_VCS.mk build_all

    or

        cd ofs-d5005/verification/scripts
        gmake -f Makefile_MSIM.mk build_all

8) Execute new test for either Synopsys VCS or Questasim simulater

        cd ofs-d5005/verification/scripts
        gmake -f Makefile_VCS.mk run TESTNAME=ofs_he_lpbk_test_new

    or

        cd ofs-d5005/verification/scripts
        gmake -f Makefile_MSIM.mk run TESTNAME=ofs_he_lpbk_test_new

9) Check new test and log files
        cd ofs-d5005/verification/sim/ofs_he_lpbk_test_new
        
        open runsim.log


# Notices & Disclaimers
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
