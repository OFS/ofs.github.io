# Driver Development Quick Start Guidelines for Linux DFL

## **1.0 Introduction**

### **1.1 Audience**

The intended audience for this document is for developers looking to get starting in creating their own custom drivers with Linux DFL/DFH integration. It is assumed you have some prior knowledge of FPGA-based terminology and Linux Kernel Module development. It will be extremely helpful to have knowledge of the FPGA OPAE framework including plugins, SR-IOV, and MMIO. This information is intended as a starting point, with links where users can dive deeper.

### **1.2 Terminology**

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


### **1.3 Linux DFL**

The Device Feature List is a kernel-based framework that provides support for FPGA devices that are designed to support the Device Feature List. The DFL, which is implemented in RTL, consists of a self-describing data structure in the PCI BAR space that allows the DFL driver to automatically load the drivers required for a given FPGA configuration.

A detailed explanation of the DFL framework and its parts and their functions has been upstreamed in the Linux Kernel documentation at [dfl.html](https://docs.kernel.org/fpga/dfl.html). Here you can find an overview of the DFL linked list structure, a breakdown of DFHv0 and DFHv1 header layouts, and introduction to the FPGA Management Engine (FME), FIU-Ports, Partial Reconfiguration, virtualization using SR-IOV, device enumeration, performance counters, interrupt support, and more. This is considered **required reading** before moving forward as terms and concepts will be used through the rest of the document.

There are different flavors of the DFL framework currently on offer on GitHub - an explanation of their purpose and branch structure can be found on the [linux-dfl GitHub wiki pages](https://github.com/OFS/linux-dfl/wiki).

If you wish to build existing DFL offerings from source, these steps are provided in the [Software Installation Guide: Open FPGA Stack for PCIe Attach](https://ofs.github.io/latest/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach/#30-ofs-dfl-kernel-drivers).

The examples shown in this document are referencing values from the DFL implementation of a Virtual UART [8250_dfl.c](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c), which demonstrates a minimal level implementation of a UART driver which plugs into the DFL framework. You may also find it helpful to review [spi-altera-dfl.c](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/spi/spi-altera-dfl.c), which similarly glues existing kernel SPI logic together with the DFL framework.

## **2.0 Information Handoff with Workload Developer**

When writing DFL enabled kernel-space drivers there are several key pieces of information you will need to gather from the RTL developer as a part of their design process. For a specific feature that is exposed to kernel-space that you are writing a driver for, you need the following:

### **Table 1 - HW to SW ID Mappings**

|Variable|Description|
|-----|-----|
|FME_FEATURE_ID|The current value set can be seen in [Device Feature List (DFL) Feature IDs](https://github.com/OFS/dfl-feature-id/blob/main/dfl-feature-ids.rst). Create a pull request to merge your feature IDs with the current ID table. The RTL developer may pick any unused value for testing purposes while building their design as described in the [Shell Technical Reference Manual](https://ofs.github.io/latest/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs/?h=feature+id#611-device-feature-header-dfh-structure).|
|PCIe VID/DID/sVID/sDID|The PCIe Vendor ID, Device ID, Subsystem Vendor ID, and Subsystem Device ID. A list of all values used by Altera is found in [PCI IDs Containing Device Feature Lists](https://github.com/OFS/dfl-feature-id/blob/main/dfl-pci-ids.rst). Information for modifying these values in your design are found in the [Shell Developer Guide](https://ofs.github.io/latest/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/?h=#441-pfvf-mux-configuration).|
|[param_id](https://github.com/OFS/linux-dfl/blob/master/drivers/fpga/dfl.c#L989)|ID of the DFL paramater for the feature for features exposed to software in the RTL design, as set in [FeatureID](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs/?h=id#611-device-feature-header-dfh-structure). Ensure the ID is not already reserved.|

In addition to the above, your driver logic will depend on bitmasks, register offsets, register configurations, data widths, and other general values which will be defined at the top of your driver file in the form of C preprocessor macros. These are entirely dependent on the workload being developed and will need to be communicated from the workload to the driver developer.

## **3.0 Module Definitions**

The following Macros are required when writing your own kernel driver code.

* [**MODULE_DEVICE_TABLE(type, name)**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L153) - Describes all supported devices for this specific driver. Used to build out a [table](https://docs.kernel.org/pcmcia/devicetable.html) for all PCI and USB devices used by the kernel. <br><br> [**type**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L149) = [**FME_ID**](https://github.com/OFS/linux-dfl/blob/master/include/linux/dfl.h#L18). **FME_ID** represents the DFL IU type which corresponds with the FPGA Management Engine. <br><br> [**name**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L149) = **FME_FEATURE_ID**. FME_FEATURE_ID comes from the reserved list of all [FME Feature IDs](https://github.com/OFS/dfl-feature-id/blob/main/dfl-feature-ids.rst). In this case, we use **0x24** for the Virtual UART. Guidance on submitting a pull request for new Feature ID(s) is found in that repository's README.

* [**module_dfl_driver(__dfl_driver)**](https://github.com/OFS/linux-dfl/blob/master/include/linux/dfl.h#L90C9-L90C26) - Helper Macro for drivers that don't do anything special in module init/exit Macros (This replaces the module_init() and module_exit()). In this case, we pass a [**dfl_uart_driver**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L155) struct which is an instantiation of a [**dfl_driver**](https://github.com/OFS/linux-dfl/blob/master/include/linux/dfl.h#L57) where:<br><br>**.drv** = [**struct * device_driver**](https://github.com/OFS/linux-dfl/blob/master/include/linux/device/driver.h#L52), **device_driver\* drv** uses the value "dfl-uart" as its **name**, which will display to the user when loaded. <br><br> **.id_table** = **dfl_uart_ids**, which is an instantiation of [**dfl_device_id**](https://github.com/OFS/linux-dfl/blob/master/include/linux/dfl.h#L67) and is a 2D array of IDs from [**FME Feature IDs**](https://github.com/OFS/dfl-feature-id/blob/main/dfl-feature-ids.rst) this driver should match to (in this case just 0x24) in the form of { {FME_ID, FME_FEATURE_ID}, ..., {} }. The value **.guid** is a DFHv1 specific matching criteria that does not require knowledge of the feature ID ahead of time. You need at least one of .guid/FME_FEATURE_ID in the dfl_device_id table. <br><br> **.probe** = [**dfl_uart_probe**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L109) which is the UART's probe function as locally defined. This function has a more in-depth description in section [4.1 Driver Probing](#41-driver-probing). <br><br> **.remove** = [**dfl_uart_remove**](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L140) which is the UART's removal function as locally defined. This function has a more in-depth description in section [4.2 Driver Removal](#42-driver-removal).

* **GUID_INIT()** - describes the PCIe device IDs used to match this driver against the device(s) it should bind to. This is a [built-in](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/include/linux/uuid.h#L23) kernel Macro.

* **MODULE_DESCRIPTION("DFL Intel UART driver")** - describes what a module does and has no value dependency.

* **MODULE_AUTHOR("Intel Corporation")** - describes the author of the module and has no value dependency.

* [**MODULE_LICENSE("GPL")**](https://docs.kernel.org/process/license-rules.html#id1) - determines whether or not the module is free software or proprietary for the kernel module loader and for user space tools and must pull from a list of valid strings.

## **4.0 Commonly Used DFL Structures and Functions**

Creation of driver software involves interfacing with the same DFL-specific data structures and functions. The following is not a fully inclusive list:

### dfl_device*

```c
/**
 * struct dfl_device - represent an dfl device on dfl bus
 *
 * @dev: generic device interface.
 * @id: id of the dfl device.
 * @type: type of DFL FIU of the device. See enum dfl_id_type.
 * @feature_id: feature identifier local to its DFL FIU type.
 * @revision: revision of this dfl device feature.
 * @mmio_res: mmio resource of this dfl device.
 * @irqs: list of Linux IRQ numbers of this dfl device.
 * @num_irqs: number of IRQs supported by this dfl device.
 * @cdev: pointer to DFL FPGA container device this dfl device belongs to.
 * @id_entry: matched id entry in dfl driver's id table.
 * @dfh_version: version of DFH for the device
 * @param_size: size of the block parameters in bytes
 * @params: pointer to block of parameters copied memory
 */
struct dfl_device {
	struct device dev;
	int id;
	u16 type;
	u16 feature_id;
	u8 revision;
	struct resource mmio_res;
	int *irqs;
	unsigned int num_irqs;
	struct dfl_fpga_cdev *cdev;
	const struct dfl_device_id *id_entry;
	u8 dfh_version;
	unsigned int param_size;
	void *params;
};
```

Represents a DFL device on the DFL bus. This value is automatically passed to drivers that register their devices in the Macro [module_dfl_driver(__dfl_driver)](https://github.com/OFS/linux-dfl/blob/master/include/linux/dfl.h#L90C9-L90C26). The [**struct device dev**](https://github.com/OFS/linux-dfl/blob/master/include/linux/device.h#L719) local parameter is a pointer to the standard Linux container for devices. Other values are auto-populated in DFH by the RTL Developer as a part of workload development and exposed to you by the DFL framework.

### dfl_driver*

```c
/**
 * struct dfl_driver - represent an dfl device driver
 *
 * @drv: driver model structure.
 * @id_table: pointer to table of device IDs the driver is interested in.
 *	      { } member terminated.
 * @probe: mandatory callback for device binding.
 * @remove: callback for device unbinding.
 */
struct dfl_driver {
	struct device_driver drv;
	const struct dfl_device_id *id_table;

	int (*probe)(struct dfl_device *dfl_dev);
	void (*remove)(struct dfl_device *dfl_dev);
};
```

Represents a DFL device driver as required by the kernel. The **struct device_driver drv** local parameter is a pointer to the standard Linux [device_driver](https://github.com/OFS/linux-dfl/blob/master/include/linux/device/driver.h#L96). Importantly it is up to the user to populate the dfl_device_id table, and provide a pointer to both the probe and remove functions for their DFL driver. **dfl_device_id** is an [upstreamed](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/mod_devicetable.h?h=v6.11) data structure which identifies DFL devices to the kernel.

### dfl_device_id*

```c
/**
 * struct dfl_device_id -  dfl device identifier
 * @type: DFL FIU type of the device. See enum dfl_id_type.
 * @feature_id: feature identifier local to its DFL FIU type.
 * @driver_data: driver specific data.
 */
struct dfl_device_id {
	__u16 type;
	__u16 feature_id;
	kernel_ulong_t driver_data;
};
```

Similarly, **dfl_device_id** is an [upstreamed](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/mod_devicetable.h?h=v6.11) data structure used to identify devices as part of the DFL bus to the kernel.

### dfl_find_param()

```c
/**
 * dfh_find_param() - find parameter block for the given parameter id
 * @dfl_dev: dfl device
 * @param_id: id of dfl parameter
 * @psize: destination to store size of parameter data in bytes
 *
 * Return: pointer to start of parameter data, PTR_ERR otherwise.
 */
void *dfh_find_param(struct dfl_device *dfl_dev, int param_id, size_t *psize)
```

This function will find and return the value of a parameter as identified by the **dfl_dev** and **param_id**. This functions similarly to the PCIe find capability in that it scans PCIe bar space for the correct DFL information offsets to read off feature capabilities. Ultimately this function relies on the Linux Kernel Macro **FIELD_GET(mask, reg)** to extract a value from a hardware register give a bitmask and register value. This function iterates through all DFH offsets and returns NULL if it is unable to locate the **param_id** requested.

## **5.0 Probe and Remove Functions Using DFH**

Every DFL driver requires a probe and removal function to be defined for matching devices. The examples shown here are referencing values from the DFL implementation of a Virtual UART [8250_dfl.c](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c), which demonstrates a minimal level implementation of a UART driver which plugs into the DFL framework.

### **5.1 Driver Probing**

[dfl_uart_probe()](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L109C1-L109C54) = The DFL enabled vUART probe function. A [probe function](https://docs.kernel.org/PCI/pci.html) is passed a **struct * pcie_dev** for any devices matching its ID table in most cases. Because we have registered our device as a **dfl_uart_driver** using module_dfl_driver_() Macro, we are instead passed a **dfl_device \* dev**. In this example we use the pre-existing [Serial 8250](https://github.com/OFS/linux-dfl/blob/master/include/linux/serial_8250.h#L15) driver implementation in the kernel while also plugging the device into the DFL framework.

```c
static int dfl_uart_probe(struct dfl_device *dfl_dev)
```

To probe our device we need to accomplish the following:

1. Allocate the memory in the kernel for our device driver using [static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)](https://github.com/OFS/linux-dfl/blob/master/include/linux/device.h#L326)
2. Initialize our serial port using [serial8250_register_8250_port()](https://github.com/OFS/linux-dfl/blob/master/include/linux/serial_8250.h#L177) which will ready our port and return the line number.
3. Set a pointer to this driver's current state using [dev_set_drvdata(struct device *dev, void *data)](https://github.com/OFS/linux-dfl/blob/master/include/linux/device.h#L938)
4. Return 0 if the driver probe has completed without error.

Initializing the serial port is the only vUART specific function in this flow and can be replaced with the initialization functionality of the driver you are implementing.

Because the probe function is passed a (dfl_dev *) struct we have access to DFL specific functions for accessing device parameters via the Device Feature Header (DFH) structure. The DFL function [(void *dfh_find_param(struct dfl_device *dfl_dev, int param_id, size_t *psize)](https://github.com/OFS/linux-dfl/blob/master/drivers/fpga/dfl.c#L994) can be used to read parameters as defined in the DFH given a **param_id**. This information allows us to read configuration information for our driver directly from DFH registers and pass it along to our initialization function.

### **5.2 Driver Removal**

[dfl_uart_remove()](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev-6.6-lts/drivers/tty/serial/8250/8250_dfl.c#L140) is the DFL enabled vUART driver remove function. The logic in this function is related to the closure of any non-DFL structures from the kernel used by our driver. In this case we only need to worry about freeing the UART serial line that was previously claimed by our driver. If you have no logic tied to the removal of our driver this function is not necessary; the kernel will free memory automatically because of the work we put in to integrating our software with the driver framework.

```c
static void dfl_uart_remove(struct dfl_device *dfl_dev)
{
	struct dfl_uart *dfluart = dev_get_drvdata(&dfl_dev->dev);

	serial8250_unregister_port(dfluart->line);
}
```

## **6.0 Driver Skeleton Example**

This example provided below instantiates a DFL compatible driver without any feature-specific logic. This code will build an out-of-tree module and insert into a kernel, although without modification it doesn't accomplish anything. It will also not register itself with any known devices. Comments are provided in-line on where you can add in extra logic for your feature's use case, alongside some `printk` statements which will display in `dmesg` after the driver has been build and inserted with `insmod <file>.ko`. 

You will need to install the Linux DFL driver framework before attempting to build as shown in [Software Installation Guide: Open FPGA Stack for PCIe Attach](https://ofs.github.io/latest/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach/#30-ofs-dfl-kernel-drivers) alongside linux-headers-<kernel version>, linux-devel-<kernel version>, and any other minimal [requirements](https://www.kernel.org/doc/html/v4.13/process/changes.html). If you do not have any DFL compatible devices installed on your build machine, you will need to load the DFL kernel module code with `sudo modprobe dfl` before building.

1. Create a file skeleton.c and copy the following:

```c
#include <linux/bitfield.h>
#include <linux/device.h>
#include <linux/dfl.h>
#include <linux/errno.h>
#include <linux/ioport.h>
#include <linux/module.h>
#include <linux/mod_devicetable.h>
#include <linux/types.h>

/*
Insert all build dependent #includes.
*/

/*
Insert all feature-specific Macros that will be referenced as a part of your kernel probe, removal, and logic implementation. These values can be pulled from the RTL developer's build of your design and vary depending on requirements.
*/

static int dfh_get_u64_param_val(struct dfl_device *dfl_dev, int param_id, u64 *pval)
{
	size_t psize;
	u64 *p;

	p = dfh_find_param(dfl_dev, param_id, &psize);
	if (IS_ERR(p))
		return PTR_ERR(p);

	if (psize != sizeof(*pval))
		return -EINVAL;

	*pval = *p;

	return 0;
}

/*
Using dfh_get_u64_param_val above, create a function that reads all relevant information from DFH for your design.
*/

/*
You will need to insert driver probe logic for your specific feature in this function. We use a stand-in struct 'driver_data' with bogus data.
*/

struct driver_data {
    int field1;
    int field2;
    unsigned char field3;
    u64 size;
    u32 capabilities;
};

static int dfl_skeleton_probe(struct dfl_device *dfl_dev)
{
	struct device *dev = &dfl_dev->dev;
    struct driver_data *data;

    data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
    if (!data) 
    {
        return -ENOMEM;
    }

	int ret;

	dev_set_drvdata(dev, data);

    printk(KERN_INFO "DFL Skeleton Driver probe function has completed!\n");

	return 0;
}

static void dfl_skeleton_remove(struct dfl_device *dfl_dev)
{
	printk(KERN_INFO "DFL Skeleton Driver probe remove has completed!\n");
}

#define FME_FEATURE_ID_SKELETON 0x27


//#define FME_GUIDS \
//    GUID_INIT() 
// This section commented out to prevent build errors. Fill this in with your device's PCIe addressing information.


// Add FME_GUIDS as the third item after FME_FEATURE_ID_SKELETON if you have used the Kernel Macro
static const struct dfl_device_id dfl_driver_ids[] = {
	{ FME_ID, FME_FEATURE_ID_SKELETON },
	{ }
};
MODULE_DEVICE_TABLE(dfl, dfl_driver_ids);

static struct dfl_driver dfl_skeleton_driver = {
	.drv = {
		.name = "dfl-skeleton",
	},
	.id_table = dfl_driver_ids,
	.probe = dfl_skeleton_probe,
	.remove = dfl_skeleton_remove,
};
module_dfl_driver(dfl_skeleton_driver);

MODULE_DESCRIPTION("DFL Skeleton driver");
MODULE_AUTHOR("Your Name");
MODULE_LICENSE("GPL");
```

2. Create the below Makefile in the same directory as your driver code and build with `make`:

```makefile
obj-m += skeleton.o

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```
