Virtual machine User Guide: Open FPGA Stack + KVM 
===

Last updated: **September 25, 2025** 

## Document scope 

The document describes setting up and configuring a virtual machine to use PCIe devices. Here are the steps that the document may include:

1. Install the necessary tools, such as virt-manager, on the host machine. This may involve downloading and installing the software from the internet.
2. Enable the virtualization feature on the host machine. This may involve going into the BIOS settings and enabling hardware-assisted virtualization or using a command-line tool to enable it in the operating system.
3. Use virt-manager to create a new virtual machine and configure its settings. This may involve choosing a name and operating system for the virtual machine and setting the amount of memory and storage it will use.
4. Install the OPAE (Open Programmable Acceleration Engine) tool on the virtual machine. This may involve downloading and installing the OPAE software.
5. Install the DFL (Data Field Level) drivers on the virtual machine. These drivers allow the virtual machine to access and use the PCIe devices on the host machine. This may involve downloading and installing the drivers from the internet.
6. Once all of the steps have been completed, you should be able to use the virtual machine to access and use the PCIe devices on the host machine. You may need to configure the virtual machine's settings to enable it to use the PCIe devices, such as by assigning a specific device to the virtual machine.

## 1. Modes of Operation

Our current operational framework stipulates two distinct modes of operation for PF/VF configurations. When using a 2 PF enabled FIM design, both the workload and management ports can be interchangeably passed through to a VM or run on bare-metal.

1. **Management Mode**: This mode necessitates the passthrough of only the FME device (use fpgainfo fme to discover your port number, normally .0). The reason for this is that the Open FPGA Stack (OFS) depends on this address for management. Under this mode, the use of the exerciser and virtual functions is not feasible.

2. **Virtual Function Mode**: This mode comes into effect when a user needs to utilize the Virtual Functions (VF). The user will convert (example) Physical Function 0 (PF0) to three Virtual Functions (VF). This means the PF will cease to function for management purposes. Once the VFs are set up, they essentially take over the role of the PF in communicating with the Virtual Machines (VMs).

    However, this mode is subject to a limitation. If the user needs to execute 'fpgainfo fme' or 'fpgaupdate', they will need to transition from Virtual Function Mode to Management Mode. Conversely, if the user intends to utilize the Virtual Functions, they would need to switch from Management Mode to Virtual Function Mode. It is imperative to bear this limitation in mind when operating within these modes.

## 2. Enable Virtualization

To check if virtualization is enabled on a Red Hat system using `lscpu` and `grep`, you can use the following command:

```sh
lscpu -e | grep Virtualization
```

This command will run `lscpu` with the `-e` or `--extended` option, which displays information about the CPU and its available virtualization capabilities. Then, it pipes the output to `grep` with the search pattern "Virtualization". If the system has support for virtualization, the output will show the "Virtualization" field and its value, for example:

```sh
Virtualization: VT-x
```

In this example, the output shows that the system supports Intel VT-x virtualization technology. If the "Virtualization" field is empty, the system does not have support for virtualization. Keep in mind that even if the system has support for virtualization, it may not be enabled in the BIOS or the operating system itself.

Check the following for the bios configuration, [**Enabling Intel VT-d Technology**](https://ofs.github.io/ofs-2025.1-1/n6001/adp_board_installation_guidelines/#30-server-settings)

## 3. Verify Environment Setup

1. Open a terminal window and log in as a user with sudo privileges.
2. Check if the virtualization kernel modules are loaded by running the following command:

```
lsmod | grep kvm
```

3. If the command outputs a list of modules, the virtualization kernel modules are loaded, and virtualization is enabled on your system.

4. The virtualization kernel modules are not loaded if the command does not output anything. You can try loading them manually by running the following command:

```
sudo modprobe kvm
```

5. If the kernel modules are not loaded, and you cannot load them manually, it may be because virtualization is not supported or enabled in your system's BIOS or UEFI settings. You must reboot your system and enter the BIOS or UEFI settings menu to enable virtualization. The exact steps for doing this may vary depending on your system's hardware and BIOS/UEFI version, so consult your motherboard or system documentation for specific instructions.

## 4. Install Virtual Machine Manager

Virtual Machine Manager (also known as libvirt) can be installed by following the below steps:

1. Open a terminal window and log in as a user with sudo privileges.
2. Update your system package index by running the following command:
   * Redhat

   ```sh
   sudo dnf update
   ```
   * Ubuntu
   ```SH
   sudo apt update
   ```

3. Install the libvirt package and any required dependencies by running the following command:

   * Redhat 

   ```sh
   sudo dnf install @virtualization
   ```

   * Ubuntu

   ```SH
   sudo apt install qemu-kvm libvirt-bin bridge-utils virt-manager
   ```

4. Start the libvirtd service and enable it to start automatically at boot time by running the following commands:

```sh
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

5. Optional: Install the virt-manager package, which provides a GUI application for managing virtual machines, by running the following command:

```sh
sudo dnf install virt-manager
```

6. Optional: If you want to be able to run virtual machines as a non-root user, add your user to the libvirt group by running the following command, replacing "USERNAME" with your username:

```sh
sudo usermod -a -G libvirt USERNAME
```

7. You can now launch virt-manager by running the command `virt-manager` as the non-root user.

Note: By default, virt-manager will only allow non-root users to create and manage virtual machines with limited resources, such as a limited amount of memory and CPU cores. To allow non-root users to create and manage virtual machines with more resources, you need to edit the `/etc/libvirt/qemu.conf` configuration file and set the `user` and `group` values for the `dynamic_ownership` option to `1`. For example:

```
# Set user and group ownership of dynamic /dev/kvm device nodes
dynamic_ownership = 1
user = "root"
group = "root"
```

You will also need to restart the libvirtd service for the changes to take effect. You can do this by running the command. 

```sh
sudo systemctl restart libvirtd
```

8. Reboot your server to apply the changes 

```sh
reboot
```

After completing these steps, you should be able to use the virt-manager GUI application to manage virtual machines on your system. 

## 5. Create a VM Using Virt-Manager

Before creating the virtual machine, ensure the DFL drivers are installed in your host machine. For your chosen OFS platform, refer to the **Getting Stared User Guide** and associated **Software Installation Guidelines** for a complete overview of the software installation process. The following are the current available getting started guides for OFS enabled platforms:

* [Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (Intel® FPGA SmartNIC N6001-PL/N6000-PL)](https://ofs.github.io/latest/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/)
* [Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (F-Series Development Kit (2xF-Tile))](https://ofs.github.io/latest/hw/ftile_devkit/user_guides/ug_qs_ofs_ftile/ug_qs_ofs_ftile/)
* [Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (I-Series Development Kit (2xR-Tile, 1xF-Tile))](https://ofs.github.io/latest/hw/iseries_devkit/user_guides/ug_qs_ofs_iseries/ug_qs_ofs_iseries/)
* [Getting Started Guide: OFS for Agilex™ 7 SoC Attach FPGAs](https://ofs.github.io/latest/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/)
* [Getting Started Guide: OFS for Stratix 10® FPGA PCIe Attach FPGAs](https://ofs.github.io/latest/hw/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005/)

To create a Red Hat 8.10 or Ubuntu 22.04  virtual machine (VM) using `virt-manager` and share PCI devices with the VM, you will need to perform the following steps:

1. Start the `virt-manager` GUI by running the following command:

```sh
sudo virt-manager&
```

<img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img2.png" alt="img2" style="zoom:50%;" />

2. Create a new connection from the menu File-> "Add Connection," Use the default options and click "Connect."

   ![img3](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img3.png)

   ![img4](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img4.png)

3. In the `virt-manager` window, click the "New virtual machine" button.

   ![img3](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img3.png)

4. In the "New VM" wizard, select "Local install media (ISO image or CDROM)" as the installation source, and then click "Forward."

   <img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img6.png" alt="img6" style="zoom:67%;" />

   * Get the Red Hat image from the following link.

     https://developers.redhat.com/content-gateway/file/rhel/Red_Hat_Enterprise_Linux_8.10/rhel-8.10-x86_64-dvd.iso

   * Get the Ubuntu image from the following link.

     https://releases.ubuntu.com/22.04/ubuntu-22.04.1-desktop-amd64.iso


5. In the next step, Click Browse -> Browse local, select the Red Hat 8.10 ISO image as the installation source and click "Forward".

   ![img7](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img7.png)

   ![img8](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img8.png)

   Note: if the system is not detected, disable "Automatic detected from the installation media/source" and type ubuntu and select 19.10 (this should be fine for the 22.04); this step is necessary to copy the default values for the specific OS

   ![img10](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img10.png)

6. In the next step, specify a name and location for the VM, and select the desired memory and CPU configuration. in our case, 16 cores and 64 GB of RAM; Click "Forward" to continue.

   ![img12](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img12.png)

7. Select "enable storage for this virtual machine," Select "Create a new disk for the virtual machine," and enter a size for the virtual disk (at least 200~300GB in case you need to compile the design) or create a custom storage.

   ![img13](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img13.png)

   1. If you need to create custom storage, select "Select or Create custom storage" and click "Manage."

      ![img14](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img14.png)

   2. Click on the "+" icon (Bottom left) to create the storage pool.

      ![image-20221213155215073](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213155215073.png)

   3. In the "Create a new storage pool" dialog, enter a name for the storage pool and select the type of storage pool you want to create; select the Target Path and Click "Finish."

      ![img16](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img16.png)

   4. Select the pool and later click on the "+" icon (The Icon is on the right side of the Volume label) to create the New Storage Volume.

      ![image-20221213155420459](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213155420459.png)

   5. In the "Create Storage Volume" dialog, Define the name and format (keep with the default qcow2) and select the Max Capacity (at least 200~300GB  in case you need to compile the design); click "Finish" to create the disk.

      ![img21](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img21.png)

   6. Once the disk is created, it will appear in your virtual machine's list of storage devices. You can now use this disk just like any other disk. Select from the list and Click "Choose Volume."

      ![img18](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img18.png)

8. In the next step, select the "Customize configuration before install" option and click "Finish."

   ![img24](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img24.png)

### 5.1 Passing Devices to the VM

In the "Overview" tab, select "Add Hardware," choose "PCI Host Device" from the drop-down menu and choose the PCI device you want to share with the VM. Click "Apply" to apply the changes, and then click "Finish" to create the VM.

Depending on the FIM currently loaded onto your FPGA device, you have access to a few modes of operation. [Management Mode](#511-management-mode) and [Deployment mode](#512-deployment-mode) can be used on any FIM that supports a PF/VF split architecture. When using the 2 PF FIM, see [2 PF Mode](#513-2-pf-mode).

#### 5.1.1 Management Mode

This will only allow you to load the binaries to the FPGA, you only need to add the PF listed at the `fpgainfo fme` command.

```bash
fpgainfo fme

fpgainfo fme
Intel Acceleration Development Platform N6001
Board Management Controller NIOS FW version: xxxx 
Board Management Controller Build version: xxxx 
//****** FME ******//
Object Id                        : 0xEE00000
PCIe s:b:d.f                     : 0000:b1:00.0
```

​               

<img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img25.png" alt="img25" style="zoom:67%;" />

<img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213155919267.png" alt="image-20221213155919267" style="zoom:80%;" />

![image-20221213160028673](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213160028673.png)

<img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213160128900.png" alt="image-20221213160128900" style="zoom:80%;" />

#### 5.1.2 Deployment Mode

The main idea of this mode is enable the Virtual function used by the Agilex PCIe Attach OFS under the Physical Function 0, This option will allow us to use the Host Exercises.

*Note: assigning multiple devices to the same VM on a guest IOMMU, you may need to increase the hard_limit option in order to avoid hitting a limit of pinned memory. The hard limit should be more than (VM memory size x Number of PCIe devices)*

1. Create 3 VFs in the PR region.

    ```bash
    sudo pci_device b1:00.0 vf 3 
    ```

2. Verify all 3 VFs were created.

  ```sh
  lspci -s b1:00 
  b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01) 
  b1:00.1 Processing accelerators: Intel Corporation Device bcce 
  b1:00.2 Processing accelerators: Intel Corporation Device bcce 
  b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device 
  b1:00.4 Processing accelerators: Intel Corporation Device bcce 
  b1:00.5 Processing accelerators: Intel Corporation Device bccf 
  b1:00.6 Processing accelerators: Intel Corporation Device bccf 
  b1:00.7 Processing accelerators: Intel Corporation Device bccf 
  ```

3. Bind all of the PF/VF endpoints to the `vfio-pci` driver.

   ```sh
   sudo opae.io init -d 0000:b1:00.1 user:user
   Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
   Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
   iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 187
   Assigning /dev/vfio/187 to DCPsupport
   Changing permissions for /dev/vfio/187 to rw-rw----
   
   sudo opae.io init -d 0000:b1:00.2 user:user
   Unbinding (0x8086,0xbcce) at 0000:b1:00.2 from dfl-pci
   Binding (0x8086,0xbcce) at 0000:b1:00.2 to vfio-pci
   iommu group for (0x8086,0xbcce) at 0000:b1:00.2 is 188
   Assigning /dev/vfio/188 to DCPsupport
   Changing permissions for /dev/vfio/188 to rw-rw----
   
   ...
   
   sudo opae.io init -d 0000:b1:00.7 user:user
   Binding (0x8086,0xbccf) at 0000:b1:00.7 to vfio-pci
   iommu group for (0x8086,0xbccf) at 0000:b1:00.7 is 319
   Assigning /dev/vfio/319 to DCPsupport
   Changing permissions for /dev/vfio/319 to rw-rw----
   ```

4. Check that the accelerators are present using `fpgainfo`. *Note your port configuration may differ from the below.*

   ```bash
   sudo fpgainfo port 
   //****** PORT ******//
   Object Id                        : 0xEC00000
   PCIe s:b:d.f                     : 0000:B1:00.0
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCE
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x00
   //****** PORT ******//
   Object Id                        : 0xE0B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.7
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCF
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 4dadea34-2c78-48cb-a3dc-5b831f5cecbb
   //****** PORT ******//
   Object Id                        : 0xC0B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.6
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCF
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 823c334c-98bf-11ea-bb37-0242ac130002
   //****** PORT ******//
   Object Id                        : 0xA0B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.5
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCF
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 8568ab4e-6ba5-4616-bb65-2a578330a8eb
   //****** PORT ******//
   Object Id                        : 0x80B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.4
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCE
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 44bfc10d-b42a-44e5-bd42-57dc93ea7f91
   //****** PORT ******//
   Object Id                        : 0x40B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.2
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCE
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 56e203e9-864f-49a7-b94b-12284c31e02b
   //****** PORT ******//
   Object Id                        : 0x20B1000000000000
   PCIe s:b:d.f                     : 0000:B1:00.1
   Vendor Id                        : 0x8086
   Device Id                        : 0xBCCE
   SubVendor Id                     : 0x8086
   SubDevice Id                     : 0x1771
   Socket Id                        : 0x01
   Accelerator GUID                 : 3e7b60a0-df2d-4850-aa31-f54a3e403501
   ```

The following table contains a mapping between each VF, Accelerator GUID, and component.
        
##### Table 16: Accelerator PF/VF and GUID Mappings

| Component                                     | VF           | Accelerator GUID                     |
| :-------------------------------------------- | :----------- | :----------------------------------- |
| Intel N6001-PL FPGA SmartNIC Platform base PF | XXXX:XX:XX.0 | N/A                                  |
| VirtIO Stub                                   | XXXX:XX:XX.1 | 3e7b60a0-df2d-4850-aa31-f54a3e403501 |
| HE-MEM Stub                                   | XXXX:XX:XX.2 | 56e203e9-864f-49a7-b94b-12284c31e02b |
| Copy Engine                                   | XXXX:XX:XX.4 | 44bfc10d-b42a-44e5-bd42-57dc93ea7f91 |
| HE-MEM                                        | XXXX:XX:XX.5 | 8568ab4e-6ba5-4616-bb65-2a578330a8eb |
| HE-HSSI                                       | XXXX:XX:XX.6 | 823c334c-98bf-11ea-bb37-0242ac130002 |
| MEM-TG                                        | XXXX:XX:XX.7 | 4dadea34-2c78-48cb-a3dc-5b831f5cecbb |

5. Ensure you add the desired VF in your PCIE devices list.

   ![](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img25.png)

   ![](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213155919267.png)

#### 5.1.3 2 PF Mode

For FIMs that support the dual PF architecture, you have the option to pass through any number of PFs into the VM. The VM's software will recognize any management / workload ports and probe them appropriately. This assumes you have the OPAE SDK and Linux DFL drivers installed on both the VM and host.
      
1. Bind all endpoints you wish to pass through to the VM to the `vfio-pci` driver on the host.

   ```bash
   sudo opae.io init -d 0000:b1:00.0 user:user
   Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
   Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
   iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 187
   Assigning /dev/vfio/187 to user
   Changing permissions for /dev/vfio/187 to rw-rw----
   sudo opae.io init -d 0000:b1:00.1 user:user
   Unbinding (0x8086,0xbcce) at 0000:b1:00.1 from dfl-pci
   Binding (0x8086,0xbcce) at 0000:b1:00.1 to vfio-pci
   iommu group for (0x8086,0xbcce) at 0000:b1:00.1 is 187
   Assigning /dev/vfio/187 to user
   Changing permissions for /dev/vfio/187 to rw-rw----
   ```

2. Pass through any required hardware endpoints, select "Add Hardware" -> "PCI Host Device".

   <img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img25.png" alt="img25.png" style="zoom:67%;" />

   <img src="/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213155919267.png" alt="image-20221213155919267" style="zoom:80%;" />

3. Run the following command on the host and VM to allocate hugepages for workload testing:

   ```bash
   echo 4194304 | sudo tee /sys/module/vfio_iommu_type1/parameters/dma_entry_limit
   ```

### 5.2 Virt-Manager Configuration Changes

1. Edit the XML file for your machine and include the following

   1. < ioapic driver='qemu'/> inside of features:

      ```xml
      <features>
      	<acpi/>
      	<apic/>
      	<ioapic driver='qemu'/>
      </features>
      ```

   2. Inside of devices

      ```xml
      <devices>
          ........
          ......
          <iommu model='intel'>
          	<driver intremap='on' caching_mode='on'/>
          </iommu>
      </devices>
      ```

   3. Ensure the hard limit is setup correctly otherwise you can only pass one device:

      ```xml
      <memtune>
      	<hard_limit unit='G'>64</hard_limit>
      </memtune>
      ```

      Note: assigning multiple devices to the same VM on a guest IOMMU, you may need to increase the hard_limit option in order to avoid hitting a limit of pinned memory. The hard limit should be more than (VM memory size x Number of PCIe devices)

   4. Save the changes "Apply"

2. On the host machine append `intel_iommu=on` to the end of the `GRUB_CMDLINE_LINUX` line in the grub configuration file.

   ```sh
   nano /etc/default/grub
   ......
   GRUB_CMDLINE_LINUX="....... ... intel_iommu=on"
   ...
   #Refresh the grub.cfg file for these changes to take effect
   
   grub2-mkconfig -o /boot/grub2/grub.cfg
   shutdown -r now
   ```

3. Ensure your devices are enumerated properly.

   1. Example in you host system should look like this:

      1. Management Mode:

        B1:00.0

      2. Deployment Mode:

         B1:00.5

   2. Under the virtual machine (The PCIe Address is an example you could get a different
     number):

      1. Management Mode:

        177:00.0

      2. Deployment Mode:

         177:00.0

4. Click on "Begin Installation." and follow the wizard installation of the OS.

   ![image-20221213160221768](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/image-20221213160221768.png)

5. Once the VM is created, you can start it by selecting it in the `virt-manager` window and clicking the "Run" button. This will boot the VM and start the Red Hat 8.10/Ubuntu installation process. Follow the on-screen instructions to complete the installation.

   ![img26](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img26.png)

   ![img27](/ofs-2025.1-1/hw/common/user_guides/ug_kvm/images/img27.png)

6. Under your virtual machine, configure your VM proxy:

   * Redhat [How to apply a system-wide proxy?](https://access.redhat.com/solutions/1351253)
   * Ubuntu [Define proxy settings](https://help.ubuntu.com/stable/ubuntu-help/net-proxy.html.en)
   * [Configure Git to use a proxy](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)

7. To include OPAE in your virtual machine, follow the instructions from the following link  [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform from the OFS Software tab and select Software Installation Guide. To install the DFL drivers, please follow the instructions from the following link  [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2025.1-1) select your desired platform from the OFS Software tab and select Software Installation Guide.

8. Use the OPAE SDK tool opae.io (under your virtual machine) to check default driver binding using your card under test PCIe B:D.F (Management mode).

   ```sh
   sudo fpgainfo fme
   
   Intel Acceleration Development Platform N6001
   Board Management Controller NIOS FW version: xxx 
   Board Management Controller Build version: xxx
   //****** FME ******//
   Object Id                        : 0xEC00000
   PCIe s:b:d.f                     : 0000:177:00.0
   
   
   ```

9. Use the Virtual function (Not supported at management mode)

   1.  Ensure the [DFL kernel drivers is install in your VM system](https://ofs.github.io/ofs-2025.1-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach/#30-ofs-dfl-kernel-drivers)

   2.  Bind VFs to VFIO driver

      ```bash
      $ sudo opae.io init -d 177:00.0
      [sudo] password for rhel8_10:
      Binding (0x8086,0xbccf) at 0000:177:00.0 to vfio-pci
      iommu group for (0x8086,0xbccf) at 0000:177:00.0 is 24

      ```

   3. Verify the binding is correct.

      ```sh
      $ opae.io ls
      [0000:177:00.0] (0x8086:0xbccf 0x8086:0x1771) Intel Acceleration Development Platform N6001 (Driver: vfio-pci)

      ```

   4. Test the  HE mem

      ```bash
       host_exerciser mem
               starting test run, count of 1
      API version: 2
      Bus width: 64 bytes
      Local memory bus width: 64 bytes
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
         Number of clocks: 8276
         Total number of Reads sent: 1024
         Total number of Writes sent: 1024
         Bandwidth: 3.722 GB/s
         Test mem(1): PASS

      ```

After the installation, you can use `virt-manager` to manage and configure the VM to move from Management mode to Deployment or vice versa, including setting up networking, attaching additional storage, and installing additional software. The shared PCI device will be available to the VM, allowing it to use it as if it were connected directly to the physical system.

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
