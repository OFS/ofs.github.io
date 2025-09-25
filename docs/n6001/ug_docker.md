# Docker User Guide: Open FPGA Stack: Intel® Open FPGA Stack

Last updated: **September 25, 2025** 

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

The following table highlights the hardware that comprises the Best-Known Configuration (BKC) for the OFS release. For a detailed explanation and safety information regarding the setup go to [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select Getting stated guide. This site walks you through the BIOS configuration changes needed to enable the OFS Platform's.

## 3.0 Development Installation

Docker engines have cross-compatibility with multiple systems, but the host server does not require any specific distribution. However, the Quartus<sup>&reg;</sup> Prime Pro Edition Version 25.1 requires a specific version. For this guide, [Red Hat Linux ] is used for general instructions. 

The OFS Docker image includes all the libraries and tools required by the OFS and OPAE SDK (Python, Perl, CMake, and so on).

### 3.1 Intel Quartus Prime Software Installation

<a name="3.1"></a>

Building AFUs with OFS for Agilex™ FPGA requires the build machine to have at least 64 GB of RAM.

Go to [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select Getting stated guide for a list of detailed steps for the Quartus<sup>&reg;</sup> Prime Pro Edition Version 25.1 installation.  

### 3.2 Docker Engine installation
## RHEL 9.4

The Docker installation steps for RHEL 9.4 are the following:

1. Remove old versions; older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them, along with associated dependencies. Also, uninstall `Podman` and the related dependencies if installed already.

   ```sh
    sudo dnf remove docker \
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
   sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
   ```
   
3. Install the *latest version* of Docker Engine, containerd, and Docker Compose, or go to the next step to install a specific version.

   ```sh
   sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
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

   Note: Never remove --no-cache this could cause issues with your environmental variables inside of the container

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
           "CreatedAt": "xxxxxxxxxx",
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
   docker run --rm -itd --name myOFS -v=/home/intelFPGA_pro/25.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
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
     Version Quartus Prime Pro Version 25.1
     ```
     
  4. Everything is set up correctly. Please go to the following link for more information related to the [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select Getting stated guide.
  
     **Tip:** If you need to de-attach without stopping the container, you can use Ctrl+P or Ctrl+Q. For custom combinations, for example, `docker attach --detach-keys="ctrl-a"  myOFS` and if you press CTRL+A you will exit the container without killing it.
  
* **De-attach Mode:**

  This mode runs your container in the background and allows you to run multiple commands without going inside of the docker container.
  
  1. The OFS Docker image already includes the evaluation script.
  
  2. Let's use option 2   - Check versions of Operating System and Quartus Premier Design Suite (QPDS); remember multiple options could not be available if the DFL drivers and the FPGA Platform is **not installed**, This example uses the Intel® FPGA SmartNIC N6001-PL . 
  
     ```sh
     $ sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs-agx7-pcie-attach_eval.sh 2
     
     Go to selection: 2
     ###########################################################################################
     #################### Check versions of Operation System, Quartus ##########################
     ###########################################################################################
     
     Checking Linux release
     Linux version 5.14.0-dfl .....
     
     ....
         
     cycle complete exiting...
     ```
     
   3. The Intel Docker image includes the script ofs_extratool.sh to allow you to change the seed value.
   
     ```sh
     sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs_extratool.sh -s 5
     ```

      Now you can control and compile the design. You can use the interactive or de-attach mode.
  
  3. If you need to save the log file and output files use the following command 
  
     ```sh
     sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs_extratool.sh -e
     ```
  
     all the files are saved under the share volume, DataOFS , /var/lib/docker/volumes/DataOFS/_data

## 4.0  Deployment 

The OFS docker image allows you to connect with your FPGA Platform. The main difference from the development installation process is that you are able to test with real hardware, but you must have a specific requirement to have a fully compatible system. 

Information related to host setup please go to [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select Getting stated guide.

### 4.1 Installation of Deployment server

Once you ensure the DFL drivers are installed, follow the below steps:

1. Follow the steps listed in sections  2.1 to 2.3
   * [2.1 Quartus installation](#21-quartus-installation)
   * [2.2 Docker Engine installation](#22-docker-engine-installation)
   * [2.3 Load Docker Image installation](#23-load-docker-image-installation)
2. The steps required for DFL driver installation are documented [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select Getting stated guide.

Now you should have all the steps required, and you can run the docker image directly.

### 4.2 Create a container 

Now you are ready to start the container, and should be prepared to run it (Note: now we are adding a new flag to allow us to access the PCIe devices “—privileged”) :

1. First, copy your Quartus installation path and  paste it under -v:

   ```sh 
   docker run --rm --privileged -itd --name myOFS -v=<yourintallationfolder>:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   ```

   Example, my Quartus installation is located at "/home/intelFPGA_pro/25.1" as a result, my  command should be 

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/25.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   bdc1289fb0813bb325b55dd11df4eeec252143d6745a6e5772638fbc107d0949
   ```

   **Tip**: you can change *myOFS* with any other value. The value is the given name of the container.

   **Important:** The --privileged flag gives all capabilities to the container. When the operator executes `docker run --privileged`, Docker will enable access to all devices on the host as well as set some configuration in AppArmor or SELinux to allow the container nearly all the same access to the host as processes running outside containers on the host. Additional information about running with `--privileged` is available on the [Docker Blog](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/). 

> :warning: **Only use --privileged under development infrastructure, never in production!**

2. Execute the docker run command.

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/25.1:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
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
     Version 25.1
     ```
     
  4. Everything is set up correctly. Please go to the following link for more information related to the [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform and select User Guide,  Technical Reference Manual, Developer Guide, or Getting Started Guide.
  
     **Tip:** If you need to de-attach without stopping the container you can use Ctrl+P or Ctrl+Q. For custom, combinations use for example `docker attach --detach-keys="ctrl-a"  myOFS` and if you press CTRL+A you will exit the container, without killing it.
  
* **De-attach Mode:**

  This mode runs your container in the background and allows you to run multiple commands without going inside of the docker container.
  
  1. The OFS Docker image already includes the eval script.
  
  2. Run the script and make a selection, you can directly execute with the following command:
  
      Let's use option 3   - Identify  Platform Hardware via PCIe; remember the DFL drivers need be installed. 
  
      
      ```sh
      $ sudo docker exec -it myOFS /home/OFS_BUILD_ROOT/ofs-agx7-pcie-attach_eval.sh 3
      
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

Altera® Corporation technologies may require enabled hardware, software or service activation. No product or component can be absolutely secure. Performance varies by use, configuration and other factors. Your costs and results may vary. You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Altera or Intel products described herein. You agree to grant Altera Corporation a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein. No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Altera or Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document. The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request. Altera disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade. You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. © Altera Corporation. Altera, the Altera logo, and other Altera marks are trademarks of Altera Corporation. Other names and brands may be claimed as the property of others.

OpenCL* and the OpenCL* logo are trademarks of Apple Inc. used by permission of the Khronos Group™.  


[Open FPGA Stack (OFS) Collateral Site]: https://ofs.github.io/ofs-2025.1-1
[OFS Welcome Page]: https://ofs.github.io/ofs-2025.1-1
[OFS Collateral for Stratix® 10 FPGA PCIe Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_s10_pcie_attach
[OFS Collateral for Agilex™ 7 FPGA PCIe Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_pcie_attach
[OFS Collateral for Agilex™ SoC Attach Reference FIM]: https://ofs.github.io/ofs-2025.1-1/hw/doc_modules/contents_agx7_soc_attach


[Automated Evaluation User Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/
[Automated Evaluation User Guide: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_eval_script_ofs_agx7_pcie_attach/ug_eval_script_ofs_agx7_pcie_attach/
[Automated Evaluation User Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_eval_ofs/ug_eval_script_ofs_f2000x/


[Board Installation Guide: OFS for Acceleration Development Platforms]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/adp_board_installation/adp_board_installation_guidelines
[Board Installation Guide: OFS for Agilex™ 7 PCIe Attach Development Kits]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/devkit_board_installation/devkit_board_installation_guidelines
[Board Installation Guide: OFS For Agilex™ 7 SoC Attach IPU F2000X-PL]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/f2000x_board_installation/f2000x_board_installation
[Board Installation Guide: OFS for Agilex™ 5 PCIe Attach Development Kits]: https://ofs.github.io/ofs-2025.1-1/hw/common/board_installation/devkit_board_installation/devkit_board_installation_guidelines


[Software Installation Guide: OFS for PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach
[Software Installation Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/soc_attach/sw_install_soc_attach


[Getting Started Guide: OFS for Stratix 10® FPGA PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (I-Series Development Kit (2xR-Tile, 1xF-Tile))]: https://ofs.github.io/ofs-2025.1-1/hw/iseries_devkit/user_guides/ug_qs_ofs_iseries/ug_qs_ofs_iseries/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (F-Series Development Kit (2xF-Tile))]: https://ofs.github.io/ofs-2025.1-1/hw/ftile_devkit/user_guides/ug_qs_ofs_ftile/ug_qs_ofs_ftile/
[Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (Intel® FPGA SmartNIC N6001-PL/N6000-PL)]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/
[Getting Started Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/


[Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/
[Shell Technical Reference Manual: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/
[Shell Technical Reference Manual: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs/


[Shell Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/fim_dev/ug_dev_fim_ofs_d5005/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (2xR-tile, F-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (2xF-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/
[Shell Developer Guide: OFS for Agilex™ 7 PCIe Attach (P-tile, E-tile) FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/
[Shell Developer Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/
[Shell Developer Guide: OFS for Agilex™ 5 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001/


[Workload Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/dev_guides/afu_dev/ug_dev_afu_d5005/
[Workload Developer Guide: OFS for Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_ofs_agx7_pcie_attach/ug_dev_afu_ofs_agx7_pcie_attach/
[Workload Developer Guide: OFS for Agilex™ 7 SoC Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/
[Workload Developer Guide: OFS for Agilex™ 5 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/agx5/user_guides/afu_dev/ug_dev_afu_ofs_agx5/


[oneAPI Accelerator Support Package (ASP): Getting Started User Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/oneapi_asp/ug_oneapi_asp/
[oneAPI Accelerator Support Package(ASP) Reference Manual: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/reference_manual/oneapi_asp/oneapi_asp_ref_mnl/


[UVM Simulation User Guide: OFS for Stratix® 10 PCIe Attach]: https://ofs.github.io/ofs-2025.1-1/hw/d5005/user_guides/ug_sim_ofs_d5005/ug_sim_ofs_d5005/
[UVM Simulation User Guide: OFS for Agilex™ 7 PCIe Attach]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_sim_ofs_agx7_pcie_attach/ug_sim_ofs_agx7_pcie_attach/
[UVM Simulation User Guide: OFS for Agilex™ 7 SoC Attach]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_sim_ofs/ug_sim_ofs/


[FPGA Developer Journey Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_fpga_developer/ug_fpga_developer/ 
[PIM Based AFU Developer Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/ug_dev_pim_based_afu/
[AFU Simulation Environment User Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_sim_env/ug_dev_afu_sim_env/
[AFU Host Software Developer Guide]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/afu_dev/ug_dev_afu_host_software/ug_dev_afu_host_software/
[Docker User Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_docker/ug_docker/
[KVM User Guide: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_kvm/ug_kvm/
[Hard Processor System Software Developer Guide: OFS for Agilex™ FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/dev_guides/hps_dev/hps_developer_ug/
[Software Reference Manual: Open FPGA Stack]: https://ofs.github.io/ofs-2025.1-1/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/
[Troubleshooting Guide for OFS Agilex™ 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2025.1-1/hw/common/user_guides/ug_troubleshoot/ug_agx7_troubleshoot/


[OFS repository - linux-dfl]: https://github.com/OFS/linux-dfl
[OFS repository - linux-dfl - wiki page]: https://github.com/OFS/linux-dfl/wiki
[OPAE SDK repository]: https://github.com/OFS/opae-sdk
[OFS Site]: https://ofs.github.io
[examples-afu]: https://github.com/OFS/examples-afu.git


[Intel® oneAPI Base Toolkit (Base Kit)]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html
[Intel® oneAPI Toolkits Installation Guide for Linux* OS]: https://www.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top.html
[Intel® oneAPI Programming Guide]: https://www.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top.html
[FPGA Optimization Guide for Intel® oneAPI Toolkits]: https://www.intel.com/content/www/us/en/develop/documentation/oneapi-fpga-optimization-guide/top.html
[oneAPI-samples]: https://github.com/oneapi-src/oneAPI-samples.git
[Intel® oneAPI DPC++/C++ Compiler Handbook for Intel® FPGAs]: https://www.intel.com/content/www/us/en/docs/oneapi-fpga-add-on/developer-guide/current.html


[OPAE SDK]: https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/quick_start/readme/
[OFS DFL kernel driver]: https://ofs.github.io/ofs-2025.1-1/sw/fpga_api/quick_start/readme/#build-the-opae-linux-device-drivers-from-the-source


[Connecting an AFU to a Platform using PIM]: https://github.com/OPAE/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[PIM Tutorial]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/01_pim_ifc
[Non-PIM AFU Development]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/03_afu_main
[Multi-PCIe Link AFUs]: https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/04_multi_link
[VChan Muxed AFUs]:  https://github.com/OFS/examples-afu/tree/main/tutorial/afu_types/05_pim_vchan
[PIM AFU Interface]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md
[PIM Board Vendors]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_board_vendors.md
[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md
[PIM IFC Host Channel]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md
[PIM IFC Local Memory]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md
[base_ifcs]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/base_ifcs
[ifcs_classes]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/ifc_classes
[utils]: https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/utils
[Device Feature List Overview]: https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#device-feature-list-dfl-overview



[Token authentication requirements for Git operations]: https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations
[4.0 OPAE Software Development Kit]: https://ofs.github.io/ofs-2025.1-1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/#40-opae-software-development-kit
[6.2 Installing the OPAE SDK On the Host]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/#62-installing-the-opae-sdk-on-the-host

[Signal Tap Logic Analyzer: Introduction & Getting Started]: https://www.intel.com/content/www/us/en/programmable/support/training/course/odsw1164.html
[Quartus Pro Prime Download]: https://www.intel.com/content/www/us/en/software-kit/839515/intel-quartus-prime-pro-edition-design-software-version-24-3-for-linux.html

[Red Hat Linux]: https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.4/x86_64/product-software
[OFS GitHub Docker]: https://github.com/OFS/ofs.github.io/tree/main/docs/hw/common/user_guides/ug_docker

[Security User Guide: Open FPGA Stack]: https://github.com/otcshare/ofs-bmc/blob/main/docs/user_guides/security/ug-pac-security.md

[Device Feature List Feature IDs]: https://github.com/OFS/dfl-feature-id/blob/main/dfl-feature-ids.rst

[OFS 2024.1 F2000X-PL Release Notes]: https://github.com/OFS/ofs-f2000x-pl/releases/tag/ofs-2025.1-1

[AXI Streaming IP for PCI Express User Guide]: https://www.intel.com/content/www/us/en/docs/programmable/790711/24-3-1/introduction.html

[PIM Core Concepts]: https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md
 
