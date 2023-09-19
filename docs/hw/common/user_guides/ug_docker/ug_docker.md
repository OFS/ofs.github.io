# Docker User Guide: Intel® Open FPGA Stack

Last updated: **September 19, 2023** 

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

Docker engines have cross-compatibility with multiple systems, but the host server does not require any specific distribution. However, the ${{ env.COMMON_QUARTUS_VER }} requires a specific version. For this guide, [Red Hat Linux ](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.2/x86_64/product-software) is used for general instructions. 

The OFS Docker image includes all the libraries and tools required by the OFS and OPAE SDK (Python, Perl, CMake, and so on).

### 3.1 Intel Quartus Prime Software Installation

<a name="3.1"></a>

Building AFUs with OFS for Intel Agilex FPGA requires the build machine to have at least 64 GB of RAM.

Go to [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide for a list of detailed steps for the ${{ env.COMMON_QUARTUS_VER }} installation.  

### 3.2 Docker Engine installation
## RHEL 8.6

The Docker installation steps for RHEL 8.6 are the following:

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
   docker run --rm -itd --name myOFS -v=/home/intelFPGA_pro/23.2:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
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
     Version Quartus Prime Pro Version 23.2
     ```
     
  4. Everything is set up correctly. Please go to the following link for more information related to the [OFS Site](https://ofs.github.io) select your desired platform and select Getting stated guide.
  
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
     Linux version 6.1.41-dfl .....
     
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

   Example, my Quartus installation is located at "/home/intelFPGA_pro/23.2" as a result, my  command should be 

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/23.2:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
   bdc1289fb0813bb325b55dd11df4eeec252143d6745a6e5772638fbc107d0949
   ```

   **Tip**: you can change *myOFS* with any other value. The value is the given name of the container.

   **Important:** The --privileged flag gives all capabilities to the container. When the operator executes `docker run --privileged`, Docker will enable access to all devices on the host as well as set some configuration in AppArmor or SELinux to allow the container nearly all the same access to the host as processes running outside containers on the host. Additional information about running with `--privileged` is available on the [Docker Blog](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/). 

> :warning: **Only use --privileged under development infrastructure, never in production!**

2. Execute the docker run command.

   ```sh
   docker run --rm --privileged -itd --name myOFS -v=/home/intelFPGA_pro/23.2:/home/intelFPGA_pro/:ro -v=DataOFS:/dataofs ofs:latest /bin/bash
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
     Version 23.2
     ```
     
  4. Everything is set up correctly. Please go to the following link for more information related to the [OFS Site](https://ofs.github.io) select your desired platform and select User Guide,  Technical Reference Manual, Developer Guide, or Getting Started Guide.
  
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
 
