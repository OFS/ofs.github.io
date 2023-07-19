# Docker User Guide: Intel® Open FPGA Stack

Last updated: **July 19, 2023** 

## Terms and Acronyms

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
 

## 1 Introduction

This document is intended to help you get started in evaluating  Open FPGA Stack (Intel® OFS) using Docker for the Intel® Platforms. The Intel FPGA platforms  can be used as a starting point for evaluation and development. This document covers critical topics related to the initial setup of the Docker solution included with the OFS release.

After reviewing the document, you shall be able to:

* Set up the Intel® Quartus™ Prime Pro Edition Software in a host server

* Set up the Docker engine

* Build and load your Docker image to the Docker engine

* Run a Docker container with OFS preloaded



The  Open FPGA Stack (**OFS**) Docker image has two main personas:

* **Development:** You can develop, simulate, and build any component of the OFS. The Docker image enables you to use your laptop or server without having drivers, FPGA  Platform, or specific Linux* distribution installed in your host computer. You can follow the development flow provided to run Docker on Linux.  

* **Deployment:** You can program, load binaries, or execute real-time testing using the OPAE and OFS. To do so, the host computer must have the specified software distribution and drivers installed. 

### 1.2 Background Information
A container is a fully functional and portable cloud or non-cloud computing environment that includes an application, associated libraries, and other dependencies. Docker containers do not require a hardware hypervisor, instead using the application layer of the host computer, which means they tend to be smaller, faster to setup, and require fewer resources when compared to a virtual machine (VM).

The OFS provides the flexibility to support various orchestration or management systems, including bare metal, VM, and Docker.

### 1.3 Relevant information 

* [What is a container?](https://www.docker.com/resources/what-container/)
* [Docker vs. Virtual Machines](https://cloudacademy.com/blog/docker-vs-virtual-machines-differences-you-should-know/) 
* Does the Docker container have its own Kernel?
  * No, Docker image or Container uses the application layer of the host computer; this functionality is the main reason for docker having lightweight and fast applications.
* [Does Docker run on Linux, macOS, and Windows?](https://docs.docker.com/engine/faq/#does-docker-run-on-linux-macos-and-windows)
* Intel Docker Image can use the PCIe card from the host server?
  * Yes, The drivers and additional information could be shared, but this could create potential security concerns (ensure your system is secure).
* [Docker security](https://docs.docker.com/engine/security/)
* [Docker subscription](https://docs.docker.com/subscription/)

## 2.0 Prerequisites and Scope

The OFS release targeting the compatible OFS Platform's is built upon tightly coupled software and firmware versions. Use this section as a general reference for the versions in this release.

The following table highlights the hardware that comprises the Best-Known Configuration (BKC) for the OFS release. For a detailed explanation and safety information regarding the setup go to [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide. This site walks you through the BIOS configuration changes needed to enable the OFS Platform's.



## 3.0 Development Installation

Docker engines have cross-compatibility with multiple systems, but the host server does not require any specific distribution. However, the Intel<sup>&reg;</sup> Quartus<sup>&reg;</sup> Prime Pro Edition Version 23.1 requires a specific version. For this guide, [Red Hat Linux ](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.2/x86_64/product-software) is used for general instructions. 

The OFS Docker image includes all the libraries and tools required by the OFS and OPAE SDK (Python, Perl, CMake, and so on).

### 3.1 Intel Quartus Prime Software Installation

<a name="3.1"></a>

Building AFUs with OFS for Intel Agilex FPGA requires the build machine to have at least 64 GB of RAM.

Go to [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide for a list of detailed steps for the Intel<sup>&reg;</sup> Quartus<sup>&reg;</sup> Prime Pro Edition Version 23.1 installation.  

### 3.2 Docker Engine installation
## Redhat 8.2

The Docker installation steps for Redhat 8.2 are the following:

1. Remove old versions; older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them, along with associated dependencies. Also, uninstall `Podman` and the related dependencies if installed already.

   ```sh
    sudo yum remove docker \
                     docker-client \
                     docker-client-latest \
                     docker-common \
                     docker-latest \
                     docker-latest-logrotate \
                     docker-logrotate \
                     docker-engine \
                     podman \
                     runc
   ```

2. Add the Docker repository to your system:

   ```sh
   sudo yum install -y yum-utils
   sudo yum-config-manager \
       --add-repo \
       https://download.docker.com/linux/rhel/docker-ce.repo
   ```

3. Install the *latest version* of Docker Engine, containerd, and Docker Compose, or go to the next step to install a specific version.

   ```sh
   sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

4. Start the Docker daemon:

   ```sh
   sudo systemctl start docker
   ```


5. Enable the Docker daemon to start on boot:

   ```sh
   sudo systemctl enable --now docker
   sudo systemctl enable --now containerd
   ```

6. Verify that Docker is installed and running:

   ```sh
   sudo systemctl status docker
   ```

   You should see a message indicating that the Docker daemon is active and running.

   Note: If you want to use Docker as a non-root user, you should add your user to the `docker` group:

   ```sh
   sudo usermod -aG docker your-user
   ```

   You will need to log out and back in for the changes to take effect.

7. Ensure your proxies are setup in case you needed

   ```sh
   sudo mkdir -p /etc/systemd/system/docker.service.d 
   
   nano /etc/systemd/system/docker.service.d/http-proxy.conf
   
   [Service] 
   Environment="HTTP_PROXY=http://proxy.example.com:80/"
   Environment="HTTPS_PROXY=https://proxy.example.com:443/"
   
   #save and close 
   
   sudo systemctl daemon-reload
   sudo systemctl restart docker
   ```

   



## Ubuntu 22.04

The Docker installation steps for Ubuntu are the following:

1. Remove old versions; older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them, along with associated dependencies. 

   ```sh
   sudo apt-get remove docker docker-engine docker.io containerd runc
   ```

2. Install packages to allow apt to use a repository

   ```sh
   sudo apt-get update
   sudo apt-get install \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
   ```

3. Add Docker's official GPG key:

   ```sh
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   ```

4. The following command to set up the repository:

   ```sh
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. Update the package manager index again:

   ```sh
   sudo apt-get update
   ```

6. Install Docker:

   ```sh
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```

7. Start the Docker daemon:

   ```sh
   sudo systemctl start docker
   ```

8. Enable the Docker daemon to start on boot:

   ```sh
   sudo systemctl enable --now docker
   sudo systemctl enable --now containerd
   ```

9. Verify that Docker is installed and running:

   ```sh
   sudo systemctl status docker
   ```

   You should see a message indicating that the Docker daemon is active and running.

   Note: If you want to use Docker as a non-root user, you should add your user to the `docker` group:

   ```sh
   sudo usermod -aG docker your-user
   ```

   You will need to log out and back in for the changes to take effect.

10. Ensure your proxies are setup in case you needed

    ```sh
    sudo mkdir -p /etc/systemd/system/docker.service.d 
    
    nano /etc/systemd/system/docker.service.d/http-proxy.conf
    
    [Service] 
    Environment="HTTP_PROXY=http://proxy.example.com:80/"
    Environment="HTTPS_PROXY=https://proxy.example.com:443/"
    
    #save and close 
    
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```

    

### 3.3 Load Docker Image installation
The Dockerfile is released in conjunction with the OFS stack release, and The file needs to be loaded into your host computer to start a docker container.

### Build the image

1. You can download the Dockefile from [OFS GitHub Docker](https://github.com/OFS/ofs.github.io/tree/main/docs/hw/common/user_guides/ug_docker).

2. Inside the Dockerfile folder, you will find the DockerFile edit and modify the following lines:

   ```sh
   ENV no_proxy=   #you could use  github.com here
   ENV http_proxy= #setup proxy
   ENV https_proxy=  #setup proxy
   ENV GITUSER= #setup github user
   ENV GITTOKEN= #setup github token
   ENV REDUSER= #redhat user 
   ENV REDPASS= #redhat password
   ENV DW_LICENSE_FILE= #DW license
   ENV SNPSLMD_LICENSE_FILE= #Synopsys license
   ENV LM_LICENSE_FILE= #Quartus License
   ```

   Save the file 

3. Create and load the image:

   ```sh
   cd Docker_file
   docker build -t ofs:latest . --no-cache
   ```

4. Use the following command to ensure the image is loaded correctly:

   ```sh
   sudo docker images
   REPOSITORY    TAG                       IMAGE ID       CREATED          SIZE
   ofs           latest                    fc80175d13a0   ∞ seconds ago   2.55GB
   ```



### Volumen creation

 1. Docker requires a volume to move data from the host computer (Persistent data) to the docker container and vice versa. To create a docker volume, use the following command:

    ```sh
    docker volume create --name DataOFS
    ```

    For more information about Docker volume go [here](https://docs.docker.com/storage/volumes/).

    **Tip:** Remember, The docker container has a limited lifecycle; the files and data are lost when the docker is Stopped-> Deleted.

2. Check where the docker volume is mapped in your host server:

   ```sh
   docker volume inspect DataOFS
   [
       {
           "CreatedAt": "2022-08-03T09:38:52-07:00",
           "Driver": "local",
           "Labels": {},
           "Mountpoint": "/var/lib/docker/volumes/DataOFS/_data",
           "Name": "DataOFS",
           "Options": {},
           "Scope": "local"
       }
   ]
   ```

3. Inside of your docker container, you can use cp command to copy from your docker to your host:

   ```sh
   cp /atmydocker/myfile.txt /dataofs
   ```

   The docker container path is /dataofs the host path is /var/lib/docker/volumes/DataOFS/_data.

### 3.4 Create a container 
Now you are ready to start the container, and you should be prepared to run it:
1. First, Let's create the template for the run  command, copy your Quartus installation path and paste it under -v (Don't Run the command yet):

   ```sh 
   docker run --rm -itd --name myOFS -v=<yourintallationfolder>:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   ```

   **Tip**: you can change *myOFS* with any other value. The value is the given name of the container.

2. Using the previous example now, you can execute the docker run command.
   ```sh
   docker run --rm -itd --name myOFS -v=/home/intelFPGA_pro/23.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   bdc1289fb0813bb325b55dd11df4eeec252143d6745a6e5772638fbc107d0949
   ```
3. Now the docker container should be available.

   ```sh 
   # sudo docker ps
   CONTAINER ID   IMAGE                         COMMAND       CREATED          STATUS   PORTS     NAMES
   bdc1289fb081   ofs:latest                    "/bin/bash"   46 seconds ago   Up 45 seconds      myOFS
   ```

Your Container ID is bdc1289fb081. 

### 3.5 Evaluate OFS container

The OFS container has two possible ways to interact with the container:

* **Interactive mode:** 

  This mode it takes you straight inside the container and uses the command terminal as a regular Linux console. 

  1. Enable the interactive mode:

     ```sh
     docker attach myOFS
     [root@bdc1289fb081 /]#
     ```

     The container id is shown when you are in interactive mode [root@**bdc1289fb081** /]#.

  2. Now verify the variables and Quartus is appropriately set up and recognized:

     ```sh
     quartus_syn --version
     
     Quartus Prime Synthesis
     Version 22.1.0 Build 174 03/30/2022 Patches 0.04,0.23,0.26,0.27 SC Pro Edition
     Copyright (C) 2022  Intel Corporation. All rights reserved.
     ```
  
  4. Everything is set up correctly. Please go to the following link for more information related to the [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide.
  
     **Tip:** If you need to de-attach without stopping the container, you can use Ctrl+P or Ctrl+Q. For custom combinations, for example, `docker attach --detach-keys="ctrl-a"  myOFS` and if you press CTRL+A you will exit the container without killing it.
  
* **De-attach Mode:**

  This mode runs your container in the background and allows you to run multiple commands without going inside of the docker container.
  
  1. The OFS Docker image already includes the evaluation script.
  
  2. Let's use option 2   - Check versions of Operating System and Quartus Premier Design Suite (QPDS); remember multiple options could not be available if the DFL drivers and the FPGA Platform is **not installed**, This example uses the Intel® FPGA SmartNIC N6001-PL . 
  
     ```sh
     $ sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs-n6001_eval.sh 2
     
     Go to selection: 2
     ###########################################################################################
     #################### Check versions of Operation System, Quartus ##########################
     ###########################################################################################
     
     Checking Linux release
     Linux version 6.1.22-dfl .....
     
     ....
         
     cycle complete exiting...
     ```
     
   3. The Intel Docker image includes the script ofs_extratool.sh to allow you to change the seed value.
     ```sh
     sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs_extratool.sh -s 5
     ```
      Now you can control and compile the design. You can use the interactive or de-attach mode.
  
  4. If you need to save the log file and output files use the following command 
  
     ```sh
     sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs_extratool.sh -e
     ```
  
     all the files are saved under the share volume, DataOFS , /var/lib/docker/volumes/DataOFS/_data

## 4.0  Deployment 

The OFS docker image allows you to connect with your FPGA Platform. The main difference from the development installation process is that you are able to test with real hardware, but you must have a specific requirement to have a fully compatible system. 

Information related to host setup please go to [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide.

### 4.1 Installation of Deployment server

Once you ensure the DFL drivers are installed, follow the below steps:

1. Follow the steps listed in sections  2.1 to 2.3
   * [2.1 Quartus installation](#21-quartus-installation)
   * [2.2 Docker Engine installation](#22-docker-engine-installation)
   * [2.3 Load Docker Image installation](#23-load-docker-image-installation)
2. The steps required for DFL driver installation are documented [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide.

Now you should have all the steps required, and you can run the docker image directly.

### 4.2 Create a container 

Now you are ready to start the container, and should be prepared to run it (Note: now we are adding a new flag to allow us to access the PCIe devices “—privileged”) :

1. First, copy your Quartus installation path and  paste it under -v:

   ```sh 
   docker run --rm --privileged -itd --name myOFS -v=<yourintallationfolder>:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   ```

   Example, my Quartus installation is located at "/home/intelFPGA_pro/23.1" as a result, my  command should be 

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/23.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   bdc1289fb0813bb325b55dd11df4eeec252143d6745a6e5772638fbc107d0949
   ```

   **Tip**: you can change *myOFS* with any other value. The value is the given name of the container.

   **Important:** The --privileged flag gives all capabilities to the container. When the operator executes `docker run --privileged`, Docker will enable access to all devices on the host as well as set some configuration in AppArmor or SELinux to allow the container nearly all the same access to the host as processes running outside containers on the host. Additional information about running with `--privileged` is available on the [Docker Blog](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/). 

> :warning: **Only use --privileged under development infrastructure, never in production!**

2. Execute the docker run command.

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/23.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   25b41eb4d232de9c750b52ddc6b92a3db612200e5993f55733b59068898623d7
   ```

3. Now, the docker container should be available.

   ```sh 
   # sudo docker ps
   CONTAINER ID   IMAGE                              COMMAND       CREATED     STATUS     PORTS     NAMES
   25b41eb4d232   ofs:latest                        "/bin/bash"   13 seconds ago   Up 12 seconds     myOFS
   ```

​		Your Container ID is 25b41eb4d232. 

### 4.3 Evaluate OFS container

The OFS container has two possible ways to interact with the container:

* **Interactive mode:** 

  This mode it takes you straight inside the container and uses the command terminal as a regular Linux console. 

  1. Enable the interactive mode:

     ```sh
     docker attach myOFS
     [root@25b41eb4d232 /]#
     ```

     The container id is shown when you are in interactive mode [root@**25b41eb4d232** /]#.

  2. Now verify the variables and Quartus is appropriately setup and recognized:

     ```sh
     quartus_syn --version
     
     Quartus Prime Synthesis
     Version 22.1.0 Build 174 03/30/2022 Patches 0.04,0.23,0.26,0.27 SC Pro Edition
     Copyright (C) 2022  Intel Corporation. All rights reserved.
     ```
  
  4. Everything is set up correctly. Please go to the following link for more information related to the [OFS Site](https://ofs.github.io) select your desired platform and select User Guide,  Technical Reference Manual, Developer Guide, or Getting Started Guide.
  
     **Tip:** If you need to de-attach without stopping the container you can use Ctrl+P or Ctrl+Q. For custom, combinations use for example `docker attach --detach-keys="ctrl-a"  myOFS` and if you press CTRL+A you will exit the container, without killing it.
  
* **De-attach Mode:**

  This mode runs your container in the background and allows you to run multiple commands without going inside of the docker container.
  
  1. The OFS Docker image already includes the eval script.
  
  2. Run the script and make a selection, you can directly execute with the following command:
  
     Let's use option 3   - Identify  Platform Hardware via PCIe; remember the DFL drivers need be installed. 
  
  
  ```sh
  $ sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs-n6001_eval.sh 3
  
  Go to selection: 3
  
  
  PCIe card detected as
  
  
  b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
  b1:00.1 Processing accelerators: Intel Corporation Device bcce
  b1:00.2 Processing accelerators: Intel Corporation Device bcce
  b1:00.4 Processing accelerators: Intel Corporation Device bcce
  
  Host Server is connected to SINGLE card configuration
  
  cycle complete exiting...
  ```
  
  3. The Intel Docker image includes the script ofs_extratool.sh to allow you to change the seed value.
    
        ```sh
        sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs_extratool.sh -s 5
        ```
  
  Now you can control and compile the design using the interactive or de-attach mode.
  
  
  

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
 
