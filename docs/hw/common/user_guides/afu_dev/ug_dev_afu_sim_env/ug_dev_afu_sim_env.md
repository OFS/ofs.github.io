# **AFU Simulation Environment User Guide**

Last updated: **March 20, 2024** 

## **1. Intended Audience**

The *Accelerator Functional Unit (AFU) Simulation Environment (ASE) User Guide* addresses both beginning and experienced developers. To be successful, you should have knowledge and experience in the following areas:

* C/C++
* Verilog/SystemVerilog
* RTL simulators such as Synopsys® VCS® or Siemens® QuestaSim®

Alternatively, you can create a team that includes developers who specialize in either RTL or software development.
Previous FPGA place and route (PAR) experience is not required to be successful, but PAR experience is also a useful skill.

## **2. Introduction** ##

The ASE provides a consistent transaction-level hardware interface and software API that allows you to develop a production-quality Accelerated Functional Unit (AFU) and host software application.  The ASE supports both the Intel® Xeon® Processor with Integrated FPGA and the Intel Acceleration Stack for programmable FPGA acceleration card for Intel® Xeon® processors.

To use the ASE Environment you must have source code in a language that RTL simulators can interpret. The following languages are possible:

* Verilog
* SystemVerilog
* VHDL

**Note: The ASE supports one AFU and one application at a time. The ASE does not support multiple-slot simulation.**

![](./images/platform.png)

### **2.1. AFU Simulation Environment (ASE) Overview** ###
ASE is a dual-process simulator. One process runs an AFU RTL simulation. The other process connects to software that runs on the RTL AFU simulation. This unified simulation environment reduces AFU hardware and software development time. The OPAE software distribution includes the ASE.

![](./images/ase_overview_rev1.png)

The ASE provides two interfaces:

* Software: OPAE API implemented in the C programming language.

* Hardware: PCIe SS TLP specification implemented in SystemVerilog.

Use these interfaces to deploy your IP on an OFS Integrated FPGA Platform.

### **2.2. ASE Capabilities** ###

* The ASE provides a protocol checker to ensure protocol correctness. The ASE also provides methods to identify potential issues early, before in-system deployment.

* The ASE can help identify certain lock conditions and Configuration and Status Registers (CSR) address mapping and pointer math errors.

* The ASE tracks memory requested from the accelerator. The memory model immediately flags illegal memory transactions to locations outside of requested memory spaces. Consequently, you can fix incorrect memory accesses early, during the simulation phase.

* The ASE does not guarantee that you can synthesize an AFU. After you verify the AFU RTL functionality in the ASE, use the ASE and the Quartus&reg; Prime Pro Edition software iteratively to generate the Accelerator Function (AF).

* The ASE does not require administrator privileges. After installing all the required tools, you can run the ASE on a plain vanilla user Linux machine.

### **2.3. ASE Limitations** ###

When using ASE in the application development cycle, consider the following limitations:

* The ASE is a transaction-level simulator. It does not model either Intel UPI- or PCIe-specific packet structures and protocol layers.

* The ASE does not simulate caching and is not a cache simulator. It cannot reliably simulate cache collisions or capacity issues.

* Although ASE models some latency parameters, it cannot model real-time system-specific latency. It is also not an accurate timing simulation of the design or latency and bandwidth of the real system. The ASE models enable you to develop functionally correct accelerators.

* The ASE does not simulate multi-AFU or multi-socket configurations.

### **2.4 ASE-Based AFU Design Workflow** ###

![](./images/workflow_rev1.png)

AFU development using the ASE includes the following four stages:

1. Learning/Training: Learn to use ASE and understand the interface specifications and platform. Review sample code to get an understanding of the PCIe TLP specification and OPAE API function calls. Run samples in an ASE simulation.

2. Development Phase: Use the ASE to develop AFU RTL and software application in a single workflow. Develop RTL from the specification or by modifying existing sample RTL. The ASE includes a behavioral model of the FPGA Interface Manager (FIM) IP that provides immediate feedback on functionality during the development phase. The ASE flags errors in PCIe TLP protocols, transactions, and memory accesses. Consequently, you can fix these errors before moving to the time-consuming bitstream generation phase.

3. Bitstream Generation: Once AFU RTL and software are functionally correct, open the AFU RTL in the Intel Quartus Prime Pro Edition software. Run the place and route (PAR) tools for your platform.

  Use the Synthesis reports to correct problems in the AFU RTL. Then, return to the development phase and revalidate in ASE.
  Bitstream generation can take hours depending on design complexity, area, and so on. After successful bitstream generation,
  perform timing analysis to check for timing corners, setup and hold violations, clock closure, and so on. After correcting
  failures found during timing analysis, revalidate in the ASE environment. When the AFU is error-free, generate the Accelerator
  Function (AF) bitstream that represents the AFU.

4. In-system Deployment: Test the AF in system hardware. Use Signal Tap to debug problems. Develop platform-specific software optimizations.

![](portability_rev1.PNG)

The AFU RTL code and OPAE software code you create in the ASE is compatible with the Quartus Prime PAR software if the following two conditions are true:

* The AFU RTL code is synthesizable.
* The AFU RTL code meets timing.

In the simulation environment, complete the following steps to create an AF bitstream and program the hardware:
1. Compile the AFU RTL in either the Synopsys® VCS® or in the Siemens® QuestaSim® simulators.
2. Compile the software application for an ASE-specific implementation of the OPAE API.
3. Synthesize the AFU RTL in the Quartus Prime Pro software to generate a bitstream.
4. Program the hardware using this bitstream.

**Note: The ASE only operates using the AFU RTL source code. It cannot take the AF bitstream as input.**

## **3. System Requirements** ##

The OPAE software release includes the ASE. The current OPAE ASE release supports both Acceleration Stack for the Intel® Xeon® Processor with Integrated FPGA and Acceleration Stack for a programmable FPGA acceleration card for Intel® Xeon® processors.

The ASE is available only on 64-bit Linux operating systems with one of the following simulators:
* Synopsys® VCS® Simulator (S-2021.09-SP1 or newer)
* Siemens® QuestaSim® Simulator (2023.4 or newer)

Consult your RTL simulator vendor for Synopsys® or Siemens® for specific simulation requirements.

The ASE uses Inter-Process Communication (IPC) constructs. Under most circumstances these constructs operate without glitches.
The following Linux locations should exist and be writeable. In most Linux distributions, ```/dev/shm``` comes pre-mounted as a default option.

Here are the other ASE requirements:

* C-Compiler: gcc 7.4.0 or above

    * Boost Development libraries
    * UUID Development libraries
    * JSON Development libraries
    * Please see the dependencies of the OPAE System library build process

* CMake: version 3.15 or above
* Python: version3.6.8 or above
* Intel Quartus Prime Pro 23.4: The ASE must find the ```$QUARTUS_HOME/eda/sim_lib/``` directory. You specify this directory during project definition in the Intel Quartus Prime Pro Edition software.

The ASE provides the ```env_check.sh``` bash script in the ```/opae-sim/ase/scripts``` directory. Run this script to verify the your installation.

Check the RTL simulator product information for supported operating systems, installation notes, and other related information.
The RTL simulator must be able to perform the following functions:

* Compilation of the SystemVerilog Direct Programming Interface (DPI) constructs
* Compilation of the standard examples that are included in the installation
* Support for SystemC

## **4. Package Description** ##

The opae-sim source directory tree is:

```shell

    OPAE_SIM_BASEDIR
        |-- ase
        |   |-- api
        |   |   |-- src
        |   |-- cmake
        |   |-- in
        |   |-- rtl
        |   |-- scripts
        |   |-- sw

```

This directory tree shows the package structure of the ASE distribution. The following directories implement and run the ASE simulator:

* ```ase```: This is the ASE simulator implementation directory. It contains the following subdirectories:
    * ```api/src```: This directory contains the OPAE Intel ASE implementation as a compiled library. You can link statically or dynamically to this library.
    * ```rtl```: This directory contains the RTL components of the ASE. You can compile this RTL for either platform.
    * ```scripts```: This directory contains several useful scripts. Refer to the ASE Scripts Section for more information.
    * ``` sw```: This directory contains the software components of the ASE. All simulations require the software components.
      The GNU Compiler Collection (GCC) compiles these components.
      
### **4.1. ASE Scripts** ###

The ASE distribution under the ```ase/scripts``` includes several scripts. Use these scripts to initialize, set up, and clean an existing ASE simulation environment.

#### **4.1.1. Simulation Tool Set Up** ####

Use ```ase/scripts/ase_setup_template.sh``` as a template script to set up the required tools. This script has many empty placeholders for site- and environment-specific information. Consult your Electronic Design Automation (EDA) tools  administrator, or the RTL simulator user guides for help setting up the tools.

#### **4.1.2. ASE Environment Check** ####

This script checks the status of the OS distribution, distro, and available system libraries. This check is a non-exhaustive. It looks for only the most important dependencies, such as the GCC version, GLIBC version, and so on.

```bash

    $ ./ase/scripts/env_check.sh

```

#### **4.1.3. AFU Simulation Using the ASE** ####

Before configuring the ASE, follow the instructions for building the OPAE SDK and ensure that either the OPAE installed ```bin``` or the OPAE build tree ```bin``` directory is on your shell's ```PATH```.

To simulate an AFU, replicate the ASE source tree and add the AFU-specific configuration. The OPAE installation includes several scripts to accomplish this task. The primary script, ```afu_sim_setup```, is in the OPAE ```bin``` directory.

##### **4.1.3.1. afu_sim_setup** #####

The ```afu_sim_setup``` script reads a file containing a list of RTL sources (\<rtl_sources.txt\>) and configures a simulation environment for the specified sources. The ```afu_sim_setup``` command copies your base ASE environment to the \<target dir\>.

```bash

    $ afu_sim_setup --sources=<rtl_sources.txt> <target dir>

```
* The only required argument to the `afu_sim_setup` command is the directory for the new AFU environment. Here are the usage:
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



* ```--help``` The ```help``` argument lists all the arguments to ```afu_sim_setup```.
* ```--platform```: The ```platform```argument specifies any platform defined in the platform database, including both
  the Integrated FPGA Platform or the Intel PAC. This argument is generally not required when a hardware platform
  release is installed. In that case, the OPAE_PLATFORM_ROOT environment variable points to the hardware release,
  which defines the platform.

`afu_sim_setup` is a wrapper for the following scripts. You can also access both of these scripts directly:

*  ```rtl_src_config```: This script transforms the list of RTL sources into simulator configuration files.

* `generate_ase_environment.py`: This script instantiates your simulated platform configuration.

##### **4.1.3.2. rtl_src_config.py** #####
The ```rtl_src_config``` script maps a simple text file containing a list of RTL source files to an ASE configuration file for simulation or an Quartus Prime Pro configuration file for synthesis. ```rtl_src_config``` also defines preprocessor variables. Source configuration files may be hierarchical, with one file including another. ```rtl_src_config``` can construct ASE-based simulation trees or Quartus build trees.

Run ```rtl_src_config --help``` for a list of options and the required command syntax.

##### **4.1.3.3. generate_ase_environment.py** #####

The ```/scripts/generate_ase_environment.py``` generates platform configuration files. ```afu_sim_setup``` invokes it automatically. A legacy mode in ```generate_ase_environment.py``` performs a brute-force check of the specified AFU RTL directories, attempting to define a compilation. This brute-force mode is imperfect and lists every file ending in ```.sv, .vs, .vhd, or .v``` and directories separated by ```+```. It also may fail when compilation is order-dependent.

Run ```generate_ase_environment.py --help``` for a list of arguments.

The Synopsys and Siemens RTL simulators generate the following scripts.

* Synopsys: Creates ```synopsys_sim.setup``` and ```vcs_run.tcl``` in the configuration directory.
* Siemens: Creates ```vsim_run.tcl``` in the configuration directory.

The run-time simultation uses the ```.tcl``` files.

Details on generated files:
* ```vlog_files.list```: Lists all the Verilog and SystemVerilog files found in the AFU directory path.
* ```vhdl_files.list```: Lists all the VHDL files found in the AFU directory path.
* ```ase_sources.mk```: Ties the above two files into ```DUT_VLOG_SRC_LIST``` and ```DUT_VHD_SRC_LIST``` Makefile variables.
  * ```ASE_PLATFORM```: Sets the platform type to the default type or the type you specify.
  * Set additional VCS or QUESTA options using the ```SNPS_{VLOGAN,VHDLAN,VCS}_OPT``` or ```MENT_{VLOG,VCOM,VSIM}_OPT``` options
    in the Makefile.

The simulation files use absolute paths when possible. To improve portability across users and groups, substitute environment variables in the generated files that build and run the simulator.

**Note: You should manually check this file for correctness before using it in the simulation.**

#### **4.1.4. Cleaning the ASE Environment**  ####

Use the ASE cleanup script located in ```scripts/ipc_clean.py``` to kill zombie simulation processes and temporary files left behind by failed simulation processes or crashes.

```bash

    $ ./ase/scripts/ipc_clean.py

    ############################################################
    #                                                          #
    #                ASE IPC Cleanup script                    #
    #                                                          #
    ############################################################
    IPC mounts seem to be readable... will attempt cleaning up IPC constructs by user ' user_foo '
    Removing .ase_ready file ...
    Type 'y' to clean up all zombie ase_simv processes : y
    Going ahead with cleaning up ASE processes opened by  user_foo
    $


```
## **5. ASE Usage** ##

The AFU ASE is a server-client simulation environment. The AFU RTL is the server process. The software application compiled and linked to the  OPAE ASE library is the client process. Communication between server and client uses named pipes. The ASE abstracts most of the simulation infrastructure. You do not need to modify it.

![](./images/ase_server_client_process.png)


**Server Process**:
* The server process interfaces to 3rd-Party RTL Simulator packages. The server process currently supports Questasim and Synopsys VCS via the SystemVerilog-DPI library and simulator software interface.
* Named pipes implement communication to the client.  Named pipes also implement control, status and session management. The server process includes a pipe event monitoring engine.
* SystemVerilog manages the PCIe interface. All PCIe events are logged and time stamped.
* The buffer allocation calls map to POSIX Shared Memory (```/dev/shm```). The server-client processes share information about these buffers using named pipes.

**Note: The Physical addresses generated in ASE are not realistic and are not replicable in-system.**

**Client Process**:
* The client implements an OPAE interface and a library to access the ASE platform functionality including MMIO, Buffer management, and session control. The features available depend on the platform you specify at build time. These functions are available using the OPAE API.
* The client process also provides a physical memory model that simulates the RTL AFU access to physical addresses. The physical memory model simulates address translation from virtual addresses to physical addresses.
* A compiled program compiles and links to the ASE implementation of OPAE library. All OPAE calls route to ASE instead of the OPAE platform driver.

Separate build scripts build the server and client processes.

* Server: A makefile in the ```ase``` directory compiles the ASE server process, containing the ASE Software, SystemVerilog engines and the AFU RTL logic code.
* Client: The main ```cmake``` script in the root of the distribution builds the OPAE library implementations for the System and ASE.  The cmake script installs the library in the  ```lib``` directory.

### **5.1. ASE Build Instructions** ###

In this section you will set up your server to support ASE by independently downloading and installing OPAE SDK and ASE. Then, set up the required environment variables.

#### **5.1.1. Install OPAE SDK**

Follow the instructions documented in the Software Installation Guide to build and install the required OPAE SDK.

#### **5.1.2. Setup Required ASE Environment Variables**

The values set to the following environment variables assume the OPAE SDK and ASE were installed in the default system directories below ```/usr```. Setup these variables in the shell where ASE will be executed. You may wish to add these variables to the script you created to facilitate configuring your environment.

```sh
$ export QUARTUS_ROOTDIR=<path to Quartus Root Dir>
$ export PATH=$QUARTUS_ROOTDIR/bin:$PATH
$ export OPAE_PLATFORM_ROOT=<path to PR build tree>
$ export PATH=/usr/bin:$PATH
$ cd /usr/lib/python*/site-packages
$ export PYTHONPATH=$PWD
$ export LIBRARY_PATH=/usr/lib
$ export LD_LIBRARY_PATH=/usr/lib64
$ export OFS_PLATFORM_AFU_BBB=<path to ofs-platform-afu_bbb directory> 

  ## For VCS, set the following:
$ export VCS_HOME=<Set the path to VCS installation directory>
$ export PATH=$VCS_HOME/bin:$PATH
$ export SNPSLMD_LICENSE_FILE=<License File Server>
$ export DW_LICENSE_FILE=<DesignWare License File Server>

  ## For QuestaSIM, set the following:
$ export MTI_HOME=<path to QuestaSIM installation directory>
$ export PATH=$MTI_HOME/linux_x86_64/:$MTI_HOME/bin/:$PATH
$ export LM_LICENSE_FILE=<>
```
   
#### **5.1.3. Install ASE Tools**

ASE is an RTL simulator for OPAE-based AFUs. The simulator emulates both the OPAE SDK software user space API and the AFU RTL interface. The majority of the FIM as well as devices such as PCIe and local memory are emulated with simple functional models.

ASE must be installed separatedly from the OPAE SDK. However, the recommendation is to install it in the same target directory as OPAE SDK.  The following steps assume the OPAE SDK was installed in the default system directories below ```/usr```, if installed in a different directory, refer to https://github.com/OFS/opae-sim for build options.

1. Clone the ```opae-sim``` repository.
```sh

$ cd $OFS_BUILD_ROOT
$ git clone https://github.com/OFS/opae-sim.git
$ cd opae-sim  
$ git checkout tags/2.12.0-1 -b release/2.12.0
```

2. Create a build directory and build ASE to be installed under the default system directories along with OPAE SDK.
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

3. Install ASE binaries and libraries under the system directory ```/usr```.
```sh
$ sudo make install  
```

#### **5.1.4. ASE Simulator (Server) Build Instructions**

ASE uses a platform differentiation key in the simulator Makefile to enable different platform features and produces asimulator configuration based on the differentiation key. These keys are set automatically by ```afu_sim_setup```.

```sh
$ afu_sim_setup -s ./hw/rtl/sources.txt -t VCS afu_sim


Copying ASE from /usr/local/share/opae/ase...
#################################################################
#                                                               #
#             OPAE Intel(R) Xeon(R) + FPGA Library              #
#               AFU Simulation Environment (ASE)                #
#                                                               #
#################################################################

Tool Brand: VCS
Loading platform database: /home/user/OFS_BUILD_ROOT/ofs-agx7-pcie-attach/work_pr/pr_build_template/hw/lib/platform/platform_db/ofs_agilex_adp.json
Loading platform-params database: /usr/share/opae/platform/platform_db/platform_defaults.json
Loading AFU database: /usr/share/opae/platform/afu_top_ifc_db/ofs_plat_afu.json
Writing rtl/platform_afu_top_config.vh
Writing rtl/platform_if_addenda.txt
Writing rtl/platform_if_includes.txt
Writing rtl/ase_platform_name.txt
Writing rtl/ase_platform_config.mk and rtl/ase_platform_config.cmake
ASE Platform: discrete (FPGA_PLATFORM_DISCRETE)

```

Change directory to the targeted simuation directory `dst` and `make` simulation project. 

```sh
$ cd afu_sim
$ make
#################################################################
#                                                               #
#             OPAE Intel(R) Xeon(R) + FPGA Library              #
#               AFU Simulation Environment (ASE)                #
#                                                               #
#################################################################

SIMULATOR=VCS
CC=gcc
FPGA_FAMILY=agilex7

ASE platform set to DISCRETE mode
Local memory model set to BASIC
mkdir -p work/verilog_libs
cd work; quartus_sh --simlib_comp -family agilex7 -tool vcsmx -language verilog -gen_only -cmd_file quartus_vcs_verilog.sh; chmod a+x quartus_vcs_verilog.sh
...    
```


#### **5.1.4. ASE Runtime Instructions**
The ASE server-client simulator makes the server before the client. Use two terminal windows to start the simulation.

* Terminal 1: In the simulation directroy `dst`, run `make sim`. The ASE initializes and the AFU issues a reset and then waits for incoming transactions.
The software application must wait until the "Ready for Simulation" message displays.

Specify the environment variable ```ASE_WORKDIR``` Terminal 1.

```sh
  
# Invoke the simulator
$ make sim
#################################################################
#                                                               #
#             OPAE Intel(R) Xeon(R) + FPGA Library              #
#               AFU Simulation Environment (ASE)                #
#                                                               #
#################################################################

SIMULATOR=VCS
CC=gcc
FPGA_FAMILY=agilex7

ASE platform set to DISCRETE mode

    .
    .
    .
  [SIM]  Transaction Logger started
  [SIM]  Simulator started...
  [SIM]  +CONFIG /home/user/OFS_BUILD_ROOT/example_afu/afu_sim/ase.cfg file found !
  [SIM]  +SCRIPT /home/user/OFS_BUILD_ROOT/example_afu/afu_sim/ase_regress.sh file found !
  [SIM]  ASE running with seed =>           0
  [SIM]  PID of simulator is 1822681
  [SIM]  Reading /home/user/OFS_BUILD_ROOT/example_afu/afu_sim/ase.cfg configuration file
  [SIM]  ASE was started in Mode 3 (Server-Client with Sw SIMKILL (long runs)
  [SIM]  ASE Mode: Server-Client mode with SW SIMKILL (long runs)
  [SIM]  Inactivity kill-switch     ... DISABLED
  [SIM]  Reuse simulation seed      ... ENABLED
  [SIM]  ASE Seed                   ... 1234
  [SIM]  ASE Transaction view       ... DISABLED
  [SIM]  User Clock Frequency       ... 312.500000 MHz, T_uclk = 3200 ps
  [SIM]  Amount of physical memory  ... 128 GB
  [SIM]  Current Directory located at =>
  [SIM]  /home/user/OFS_BUILD_ROOT/example_afu/afu_sim/work
  [SIM]  Creating Messaging IPCs...
  [SIM]  Information about allocated buffers => workspace_info.log
  [SIM]  Sending initial reset...
    .
    .
    .
  [SIM]  ASE lock file .ase_ready.pid written in work directory
  [SIM]  ** ATTENTION : BEFORE running the software application **
  [SIM]  Set env(ASE_WORKDIR) in terminal where application will run (copy-and-paste) =>
  [SIM]  $SHELL   | Run:
  [SIM]  ---------+---------------------------------------------------
  [SIM]  bash/zsh | export ASE_WORKDIR=/home/user/OFS_BUILD_ROOT/example_afu/afu_sim/work
  [SIM]  tcsh/csh | setenv ASE_WORKDIR /home/user/OFS_BUILD_ROOT/example_afu/afu_sim/work
  [SIM]  For any other $SHELL, consult your Linux administrator
  [SIM]
  [SIM]  Ready for simulation...
  [SIM]  Press CTRL-C to close simulator...


```

You can close Terminal 1 `make sim` by issuing a `SIGTERM` to the relevant `ase_simv` process or by typing  `CTRL-C`.

* Terminal 2: First set the environment variable `ASE_WORKDIR` as specified in Terminal 1. In this example `ASE_WORKDIR` is set to `/home/user/OFS_BUILD_ROOT/example_afu/afu_sim/work`.  Then, start the software application using `with_ase`, which will run the binary using the ASE simulation library instead of the standard libopae-c.

```sh

    # Set ASE_WORKDIR environment variable
    $ export ASE_WORKDIR=/home/user/OFS_BUILD_ROOT/example_afu/afu_sim/work

    # Run the application
    $ with_ase ./hello_fpga

```


**Note: After the application exits, the simulation is complete. Close the simulator to allow the waveform dump process to complete. In Terminal 1, type the ``CTRL-C`` command.**


```sh
  [SIM]  Closing message queue and unlinking...
  [SIM]  Session code file removed
  [SIM]  Removing message queues and buffer handles ...
  [SIM]  Cleaning session files...
  [SIM]  Simulation generated log files
  [SIM]          Transactions file       | $ASE_WORKDIR/log_ase_events.tsv
  [SIM]          Workspaces info         | $ASE_WORKDIR/workspace_info.log
  [SIM]
  [SIM]  Tests run     => 0
  [SIM]
  [SIM]  Sending kill command...
  [SIM]  Simulation kill command received...
$finish called from file "/home/user//OFS_BUILD_ROOT/examples_afu/afu_sim/rtl/pcie_ss_tlp/ase_pcie_ss_emulator.sv", line 388.
$finish at simulation time          16396997500
           V C S   S i m u l a t i o n   R e p o r t
Time: 16396997500 ps
CPU Time:    506.240 seconds;       Data structure size:   4.3Mb
Wed Mar 13 18:26:28 2024

```

Upon completion, the simulation generates the following files:

* Waveform dump: `make wave` opens the waveform for the selected tool.

    * `$ASE_WORKDIR/inter.vpd`: VCS Waveform file
    * `$ASE_WORKDIR/vsim.wlf`: Questa waveform file.

* `$ASE_WORKDIR/log_ase_events.tsv`: Events log listing all events observed between the host and afu interface. The timestamps indicate the corresponding time interval in the waveform dump VPD file.
* `$ASE_WORKDIR/workspace_info.log`: Information about buffers the simulation opened.

### **5.2. ASE Makefile Targets** ###
|       COMMAND      |               DESCRIPTION                    |
|:-------------------|:-------------------------------------------- |
| make               | Build the HW Model using RTL supplied |
| make sim           | Run simulator <br>- ASE can be run in one of 4 modes set in ase.cfg <br>- A regression mode can be enabled by writing ASE_MODE = 4 in ase.cfg and supplying an ase_regress.sh script |    
| make wave          | Open the waveform (if created) to be run after simulation completes |   
| make clean         | Clean simulation files |                 
| make distclean     | Clean ASE sub-distribution |                                         


### **5.3. ASE Makefile Variables** ####
|  Makefile switch     |               DESCRIPTION |                       
|: --------------------|:--------------------------| 
| ASE_CONFIG          | Directly input an ASE configuration file path (ase.cfg) |                
| ASE_SCRIPT          | Directly input an ASE regression file path (ase_regress.sh, for ASE_MODE=4) |
| SIMULATOR           | Directly input a simulator brand (select between 'VCS' or 'QUESTA')  | 
| ASE_DISABLE_CHECKER | Legacy - Disable CCI-P protocol checker module (set to '1' might speed up simulation) <br>**WARNING** => NO warnings on hazards,  protocol checks, timeouts will be  generated. This option must be ONLY used if the design is already CCI-P compliant and fast simulation of app-specific logic is needed |



### **5.4. ASE Runtime Configuration Options** ###

The ASE configuration file configures simulator behavior. An example configuration script is available at ```ase/ase.cfg```


| Switch Name              | Default                            | Description |
|:-------------------------|:-----------------------------------|:------------|
| ASE_MODE               | 1                                  | ASE mode has the following valid values: <br>1 : Standard Server-Client Mode<br>2 : Simulator stops after `ASE_TIMEOUT` clocks<br>3 : Software shuts down simulator when client application releases session<br> 4 : Regression mode invoked by script<br>>=5 : Ignored (revert to `ASE_MODE=1`) |
| ASE_TIMEOUT            | 50000 (only if `ASE_MODE=2`)        | Watchdog timer shuts down simulator after `ASE_TIMEOUT` clocks of CCI-P interface inactivity. |
| ASE_NUM_TESTS          | 4 (only if `ASE_MODE=4`)          | Number of tests in regression mode. If incorrectly set,  the simulator may exit pre-maturely or stall waiting for tests to get started. |
| ENABLE_REUSE_SEED      | 1                                  | When set to 1, reuses the simulation seed, so that CCI-P transactions replay with the previous addresses. <br>When set to 0, obtains a new seed. |
| ASE_SEED                | 1234 (only if `ENABLE_REUSE_SEED=1`) | ASE seed setting, enabled when `ENABLE_REUSE_SEED` is set to 1, otherwise the simulations uses a different seed. <br>At the end of the simulation, the ASE writes the current seed to  `$ASE_WORKDIR/ase_seed.txt`. |
| ENABLE_CL_VIEW         | 1                                  | The ASE prints all CCI-P transactions. On long simulation runs, setting `ENABLE_CL_VIEW` to 0 may reduce simulation time. |
| USR_CLK_MHZ            | 312.50000                          | Configurable User Clock (Read by simulator as float)   |
| PHYS_MEMORY_AVAILABLE_GB | 128                                 | Restricts ASE address generation the specified memory range. |


### **5.5. Logging Verbosity Control** ###

ASE provides the following three levels for logging message verbosity. By default, these messages print to `stdout`:

* ASE_INFO: Prints mandatory information messages required to specify operation.
* ASE_ERR: Prints error messages during operation.
* ASE_MSG: Prints general messages indicating check points in the ASE. Suppress these messages by setting the environment variable `ASE_LOG` to `0`.

Two log levels are supported in ASE, controlled by env(ASE_LOG)

* ASE_LOG=0  | ASE_LOG_SILENT  : Only INFO, ERR messages are posted
* ASE_LOG!=0 | ASE_LOG_MESSAGE : All MSG, INFO, ERR messages are posted

The following command include the ASE_MSG category:

```sh

    $ ASE_LOG=1 with_ase ./hello_fpga

```
You cannot suppress warnings and errors.

### **5.6. Troubleshooting and Error Reference** ###

The following list of ASE errors and warnings is not comprehensive:

| Observation               | Problem           | Next Steps           |
|:--------------------------|:------------------|:---------------------|
| Either all transactions are not seen or simulation ends earlier than expected. | ASE Simulation inactivity is too short for the application use-case to be successfully simulated in the ASE. | If using `ASE_MODE=2` (Daemon with timeout), in the `ase.cfg` file, increase the `ASE_TIMEOUT` setting or  disable `ASE_TIMEOUT`. |
| ASE simulation build error - compilation, or linking failed | GCC version might be too old. | Use the `./scripts/env_check.sh` script to identify issues. |
| Synopsys VCS-MX dumped stack while compiling or running | Possible corruption of compiled objects or problems with incremental compilation. | Clean the ASE environment using <br>`$ make clean` <br> If this command fails, clean the distribution with <br>`$ ./distclean.sh`<br>then rebuild the simulation. |
| ERROR: Too many open files | Past ASE simulation runs did not close cleanly and may have left behind open IPC instances. | Use the  `./scripts/ipc_clean.py` script to clean IPC instances. <br>Check if the System Requirements have been met. <br>If problems continue, increase resource limits for your Linux distribution. |
| ` $ASE_WORKDIR` environment variable has not been set up | Application cannot find a valid simulation session | Follow the steps printed when the ASE simulation starts. These instructions are in green text. |
| ` .ase_timestamp` cannot be opened at `<DIRECTORY>` | Simulator may not have been started yet. Note that when started, the simulator prints: <br>Ready for Simulation<br>`$ASE_WORKDIR` may not set up correctly. | Check the ASE\_WORKDIR  environment variable. <br>`$ echo $ASE_WORKDIR ` <br>Wait for simulator to print:<br> `Ready for Simulation` |
| `ase_sources.mk: No such file or directory` | ASE Environment has not been generated. | Generate an AFU RTL listing (in `vlog_files.list` and ` ase_sources.mk`) configuration. <br> You can use `./scripts/generate_ase_environment.py`to generate these files. |
| An ASE instance is probably still running in current directory. | An ASE simulation is already running in the `$ASE_WORKDIR` directory. | If the simulation process is unusable or unreachable, use the `./scripts/ipc_clean.py` script to clean the simulation temporary files using: <br>`$ make clean`. <br> Then rebuild the simulator. |

