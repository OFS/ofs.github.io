# Software Reference Manual: Open FPGA Stack

## **1.0 Introduction**

### **1.1 Audience**

The information presented in this document is intended to be used by software developers looking to increase their knowledge of the OPAE SDK user-space software stack and the kernel-space linux-dfl drivers. This information is intended as a starting point, with links to where users can deep dive on specific topics.

Former OPAE and DFL software documents were combined with the Software Reference Manual to reduce clutter and more cleanly document OFS software capabilities. The following documents are no longer available as standalone as of ofs-2023.3:

- Quick Start Guide
- OPAE Installation Guide
- OPAE C API Programming Guide
- OPAE Python Bindings
- OPAE Plugin Developers Guide
- Open Programmable Accelerator Engine (OPAE) Linux Device Driver Architecture

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


### **1.3 OPAE Software Development Kit (SDK)**

The OPAE C library is a lightweight user-space library that provides abstraction for FPGA resources in a compute environment. Built on top of the OPAE Intel® FPGA driver stack that supports Intel® FPGA platforms, the library abstracts away hardware specific and OS specific details and exposes the underlying FPGA resources as a set of features accessible from within software programs running on the host. The OPAE source code is available on the [OPAE SDK repository](https://github.com/OFS/opae-sdk).

By providing a unified C API, the library supports different FPGA
integration and deployment models, ranging from single-node systems with one or a few FPGA devices to large-scale FPGA deployments in a data center. At one end of the spectrum, the API supports a simple application using a PCIe link to reconfigure the FPGA with different accelerator functions. At the other end of the spectrum, resource
management and orchestration services in a data center can use this API to discover and select FPGA resources and then allocate them for use by acceleration workloads.

The OPAE provides consistent interfaces to crucial components of the platform. OPAE does not constrain frameworks and applications by making optimizations with limited applicability. When the OPAE does
provide convenience functions or optimizations, they are optional. For example, the OPAE provides an interface to allocate physically contiguous buffers in system memory that user-space software and an accelerator can share. This interface enables the most basic feature set of allocating and sharing a large page of memory in one API call. However, it does *not* provide a `malloc()`-like interface backed by a memory pool or slab allocator. Higher layers of the software stack can make such domain-specific optimizations.

Most of the information related to OPAE can be found on the official [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/ofs-2023.2/) and in the [OPAE SDK repository](https://github.com/OFS/opae-sdk). The following is a summary of the information present on this web page:

- Configuration options present in the OPAE SDK build and installation flow
- The steps required to build a sample OPAE application
- An explanation of the basic application flow
- A reference for the C, C++, and Python APIs
- An explanation of the OPAE Linux Device Driver Architecture
- Definitions for the various user-facing OPAE SDK tools

The remaining sections on OPAE in this document are unique and build on basic principles explained in opae.github.io.


#### Table 1: Additional Websites and Links

| Document | Link |
| -------------------- | ------------------------------------------------------ |
| OPAE SDK on github   | [OPAE SDK repository](https://github.com/OFS/opae-sdk) |
| OPAE Documents | [Open FPGA Stack (OFS) Collateral Site](https://ofs.github.io/) |
| pybind11             | https://pybind11.readthedocs.io/en/stable/             |
| CLI11                | https://github.com/CLIUtils/CLI11                      |
| spdlog               | https://github.com/gabime/spdlog                       |

#### Table 2: OFS Hardware Terminology

|Term|Description|
|-----|-----|
|**FPGA: [Field Programmable Gate Array](https://en.wikipedia.org/wiki/Field-programmable_gate_array)**| a discrete or integrated device connecting to a host CPU via PCIe or other type of interconnects.|
|**Accelerator Function Unit (AFU)**| The AFU is the supplied implementation of an accelerator, typically in HDL. AFUs implement a function such as compression, encryption, or mathematical operations.The Quartus Prime Pro software synthesizes the RTL logic into a bitstream. |
| **Accelerator Function (AF)**| The AF is the compiled binary for an AFU. An AF is a raw binary file (.rbf) bitstream. A tool (_fpgaconf_) reconfigures the FPGA using an AF bitstream.|
|**Reconfiguration**|The process of reprogramming the FPGA with a different AF.|

## **2.0 OPAE C API**

The following OPAE data structures and functions integrate AFUs into the OPAE environment. 
The OPAE C API models these data structures and functions. For more information on the object 
models refer to the [Object model](#object-models) section.

* Accelerator: An accelerator is an allocable accelerator function implemented in an FPGA. 
An accelerator tracks the  _ownership_ of an AFU (or part of it) for a process that uses it.
Multiple processes can share an accelerator.
* Device: The OPAE enumerates and models two device types: the FPGA and the AFU.
* Events: Events are asynchronous notifications. The FPGA driver
triggers particular events to indicate error conditions. Accelerator logic can also
define its own events. User applications can choose to be
notified when particular events occur and respond appropriately.
* Shared memory buffers: Software allocates shared memory buffers in user process memory
on the host. Shared memory buffers facilitate data transfers between the user process and the 
accelerator that it owns.

### **2.1 libopae-c**

Linking with this library is straightforward.
Code using the  OPAE library should include the header file `fpga.h`. Taking the GCC
compiler on Linux as an example, here is the simplest compile and link command:

`gcc myprog.c -I</path/to/fpga.h> -L</path/to/libopae-c.so> -lopae-c -luuid -ljson-c -lpthread`

.. note::

```
The OPAE library uses the third-party `libuuid` and `libjson-c` libraries that are not distributed with 
the OPAE library. Make sure to install these libraries.
```

### Sample Code
The library source includes two code samples. Use these samples
to learn how to call functions in the library. Build and run these samples
to determine if your installation and environment are set up properly. 

Refer to the [Running the Hello FPGA Example](https://www.altera.com/content/altera-www/global/en_us/index/documentation/dnv1485190478614.html#vks1498593668425) chapter in the _Intel&reg; Acceleration Stack
Quick Start Guide for for Intel Programmable Acceleration Card with Intel Arria&reg; 10 GX FPGA_ for more information about using the sample code.  

### High-Level Directory Structure
Building and installing the OPAE library results in the following directory structure on the Linux OS.
Windows and MacOS have similar directories and files.

|Directory & Files |Contents |
|------------------|---------|
|include/opae      |Directory containing all header files|
|include/opae/fpga.h |Top-level header for user code to include|
|include/opae/access.h |Header file for accelerator acquire/release, MMIO, memory management, event handling, and so on |
|include/opae/bitstream.h |Header file for bitstream manipulation functions |
|include/opae/common.h |Header file for error reporting functions |
|include/opae/enum.h |Header file for AFU enumeration functions |
|include/opae/manage.h |Header file for FPGA management functions |
|include/opae/types.h |Various type definitions |
|lib               |Directory containing shared library files |
|lib/libopae-c.so    |The shared dynamic library for linking with the user application |
|doc               |Directory containing API documentation |
|doc/html          |Directory for documentation of HTML format
|doc/latex         |Directory for documentation of LaTex format
|doc/man           |Directory for documentation of Unix man page format

### Object Models 
* `fpga_objtype`: An enum type that represents the type of an FPGA resource, either `FPGA_DEVICE` or `FPGA_ACCELERATOR`. 
An `FPGA_DEVICE` object corresponds to a physical FPGA device. Only `FPGA_DEVICE` objects can invoke management functions.
The `FPGA_ACCELERATOR` represents an instance of an AFU. 
* `fpga_token`: An opaque type that represents a resource known to, but not
necessarily owned by, the calling process. The calling process must own a
resource before it can invoke functions of the resource.
* `fpga_handle`: An opaque type that represents a resource owned by the
calling process. The API functions `fpgaOpen()` and `fpgaClose()` acquire and release ownership of a resource that an `fpga_handle` represents. (Refer to the [Functions](#functions) section for more information.)
* `fpga_properties`: An opaque type for a properties object. Your
applications use these properties to query and search for appropriate resources. The 
[FPGA Resource Properties](#fpga-resource-properties) section documents properties visible to your
applications.
* `fpga_event_handle`: An opaque handle the FPGA driver uses to notify your
application about an event. 
* `fpga_event_type`: An enum type that represents the types of events. The following are valid values: 
`FPGA_EVENT_INTERRUPT`, `FPGA_EVENT_ERROR`, and `FPGA_EVENT_POWER_THERMAL`. (The Intel Programmable Acceleration Card (PAC) with
Intel Arria 10 GX FPGA does not handle thermal and power events.)
* `fpga_result`: An enum type to represent the result of an API function. If the
function returns successfully the result is `FPGA_OK`. Otherwise, the result is
the appropriate error codes. Function `fpgaErrStr()` translates an error code
into human-readable strings.

### Functions 
The table below groups important API calls by their functionality. For more information about each of the functions, refer to the 
[OPAE C API reference manual](https://opae.github.io/0.13.0/docs/fpga_api/fpga_api.html).

|Functionality |API Call |FPGA |Accelerator|Description |
|:--------|:----------|:-----:|:-----:|:-----------------------|
|Enumeration | ```fpgaEnumerate()``` |Yes| Yes| Query FPGA resources that match certain properties |
|Enumeration: Properties | ```fpga[Get, Update, Clear, Clone, Destroy Properties]()``` |Yes| Yes| Manage ```fpga_properties``` life cycle |
|           | ```fpgaPropertiesGet[Prop]()``` | Yes| Yes|Get the specified property *Prop*, from the [FPGA Resource Properties](#fpga-resource-properties) table |
|           | ```fpgaPropertiesSet[Prop]()``` | Yes| Yes|Set the specified property *Prop*, from the [FPGA Resource Properties](#fpga-resource-properties) table |
|Access: Ownership  | ```fpga[Open, Close]()``` | Yes| Yes|Acquire/release ownership |
|Access: Reset      | ```fpgaReset()``` |Yes| Yes| Reset an accelerator |
|Access: Event handling | ```fpga[Register, Unregister]Event()``` |Yes| Yes| Register/unregister an event to be notified about |
|               | ```fpga[Create, Destroy]EventHandle()```|Yes| Yes| Manage ```fpga_event_handle``` life cycle |
|Access: MMIO       | ```fpgaMapMMIO()```, ```fpgaUnMapMMIO()``` |Yes| Yes| Map/unmap MMIO space |
|           | ```fpgaGetMMIOInfo()``` |Yes| Yes| Get information about the specified MMIO space |
|           | ```fpgaReadMMIO[32, 64]()``` | Yes| Yes|Read a 32-bit or 64-bit value from MMIO space |
|           | ```fpgaWriteMMIO[32, 64]()``` |Yes| Yes| Write a 32-bit or 64-bit value to MMIO space |
|Memory management: Shared memory | ```fpga[Prepare, Release]Buffer()``` |Yes| Yes| Manage memory buffer shared between the calling process and an accelerator |
|              | ```fpgaGetIOAddress()``` | Yes| Yes|Return the device I/O address of a shared memory buffer |
|              | ```fpgaBindSVA()``` | Yes| Yes|Bind IOMMU shared virtual addressing |
|Management: Reconfiguration | ```fpgaReconfigureSlot()``` | Yes | No | Replace an existing AFU with a new one |
|Error report | ```fpgaErrStr()``` | Yes| Yes|Map an error code to a human readable string |

.. note::

```
The UMsg APIs are not supported for the Intel(R) PAC cards. They will be deprecated in a future release.
```

### FPGA Resource Propertie
Applications query resource properties by specifying the property name for `Prop` in the 
`fpgaPropertiesGet[Prop]()` and `fpgaPropertiesSet[Prop]()` functions. The FPGA and Accelerator
columns state whether or not the Property is available for the FPGA or Accelerator objects.

|Property |FPGA |Accelerator |Description |
|:---------|:-----:|:----:|:-----|
|Parent |No |Yes |`fpga_token` of the parent object |
|ObjectType |Yes |Yes |The type of the resource: either `FPGA_DEVICE` or `FPGA_ACCELERATOR` |
|Bus |Yes |Yes |The bus number |
|Device |Yes |Yes |The PCI device number |
|Function |Yes |Yes |The PCI function number |
|SocketId |Yes |Yes |The socket ID |
|DeviceId |Yes |Yes |The device ID |
|NumSlots |Yes |No |Number of AFU slots available on an `FPGA_DEVICE` resource |
|BBSID |Yes |No |The FPGA Interface Manager (FIM) ID of an `FPGA_DEVICE` resource |
|BBSVersion |Yes |No |The FIM version of an `FPGA_DEVICE` resource |
|VendorId |Yes |No |The vendor ID of an `FPGA_DEVICE` resource |
|GUID |Yes |Yes |The GUID of an `FPGA_DEVICE` or `FPGA_ACCELERATOR` resource |
|NumMMIO |No |Yes |The number of MMIO space of an `FPGA_ACCELERATOR` resource |
|NumInterrupts |No |Yes |The number of interrupts of an `FPGA_ACCELERATOR` resource |
|AcceleratorState |No |Yes |The state of an `FPGA_ACCELERATOR` resource: either `FPGA_ACCELERATOR_ASSIGNED` or `FPGA_ACCELERATOR_UNASSIGNED`|

### OPAE C API Return Codes ##
The OPAE C library returns a code for every exported public API function.  `FPGA_OK` indicates successful completion
of the requested operation. Any return code other than `FPGA_OK` indicates an error or unexpected
behavior. When using the OPAE C API, always check the API return codes. 

|Error Code|Description|
|----------|-----------|
|`FPGA_OK`|Operation completed successfully|
|`FPGA_INVALID_PARAM`|Invalid parameter supplied|
|`FPGA_BUSY`|Resource is busy|
|`FPGA_EXCEPTION`|An exception occurred|
|`FPGA_NOT_FOUND`|A required resource was not found|
|`FPGA_NO_MEMORY`|Not enough memory to complete operation|
|`FPGA_NOT_SUPPORTED`|Requested operation is not supported|
|`FPGA_NO_DRIVER`|Driver is not loaded|
|`FPGA_NO_DAEMON`|FPGA Daemon (`fpgad`) is not running|
|`FPGA_NO_ACCESS`|Insufficient privileges or permissions|
|`FPGA_RECONF_ERROR`|Error while reconfiguring FPGA|

#### **2.1.1 Device Abstraction**

The OPAE C API relies on two base abstractions concerning how the FIM
and accelerator are presented to and manipulated by the user. The FIM is
concerned with management functionality. Access to the FIM and its
interfaces is typically restricted to privileged (root) users. The
accelerator contains the user-defined logic in its reconfigurable
region. Most OPAE end-user applications are concerned with querying and
opening the accelerator device, then interacting with the AFU via MMIO
and shared memory.

##### **2.1.1.1 Device types**

The C enum
[fpga\_objtype](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L100-L115)
defines two variants. The FPGA\_DEVICE variant corresponds to the FIM
portion of the device, and the FPGA\_ACCELERATOR refers to the
accelerator, also known as the AFU.

An FPGA\_DEVICE refers loosely to the sysfs tree rooted at the dfl-fme.X
directory, for example /sys/class/fpga\_region/region0/dfl-fme.0, and
its associated device file /dev/dfl-fme.0.

An FPGA\_ACCELERATOR refers loosely to the sysfs tree rooted at the
dfl-port.X directory, for example
/sys/class/fpga\_region/region0/dfl-port.0, and its associated device
file /dev/dfl-port.0.

The number X in dfl-fme.X and dfl-port.X refers to a numeric ID that is
assigned by the DFL device driver to uniquely identify an instance of
the FIM/Accelerator. Systems with multiple FPGA acceleration devices
will have multiple dfl-fme.X’s and matching dfl-port.X’s.



##### **2.1.1.2 Tokens and Handles**

An
[fpga\_token](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L94-L107)
is an opaque data structure that uniquely represents an FPGA\_DEVICE or
an FPGA\_ACCELERATOR. Tokens convey existence, but not ownership. Tokens
are retrieved via the OPAE enumeration process described below using the
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
call.

An
[fpga\_handle](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L109-L120)
is an opaque data structure that corresponds to an opened device
instance, whether FPGA\_DEVICE or FPGA\_ACCELERATOR. A Handle is
obtained from a token via the
[fpgaOpen()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L41-L73)
call. A handle conveys that the /dev/dfl-fme.X or /dev/dfl-port.X device
file has been opened and is ready for interaction via its IOCTL
interface.



#### **2.1.2 Enumeration**

Enumeration is the process by which an OPAE application becomes aware of
the existence of FPGA\_DEVICE’s and FPGA\_ACCELERATOR’s. Refer to the
signature of the
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
call:

```C
fpga_result fpgaEnumerate(const fpga_properties *filters,
uint32_t num_filters,
fpaa_token *tokens,
uint32_t max_tokens,
uint32_t *num_matches);
```
<p align = "center">Figure 1 fpgaEnumerate()</p> 

The typical enumeration flow involves an initial call to
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
to discover the number of available tokens.

```C
uint32_t num_matches = 0;
fpgaEnumerate(NULL, 0, NULL, 0, &num_matches);
```
<p align = "center">Figure 2 Discovering Number of Tokens</p> 

Once the number of available tokens is known, the application can
allocate the correct amount of space to hold the tokens:

```C
fpga_token *tokens;
uint32_t num_tokens = num_matches;
tokens = (fpga_token *)calloc(num_tokens, sizeof(fpga_token));
fpgaEnumerate(NULL, 0, tokens, num_tokens, &num_matches);
```
<p align = "center">Figure 3 Enumerating All Tokens</p>

Note that parameters filters and num\_filters were not used in the
preceding example, as they were NULL and 0. When no filtering criteria
are provided,
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
returns all tokens that can be enumerated.



##### **2.1.2.1 fpga\_properties and Filtering**

An
[fpga\_properties](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L71-L92)
is an opaque data structure used to retrieve all of the properties
concerning an FPGA\_DEVICE or FPGA\_ACCELERATOR. These properties can be
included in the filters parameter to
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
to select tokens by specific criteria.



##### **2.1.2.1.1 Common Properties**

Table 3 lists the set of
[properties](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/props.h#L82-L133)
that are common to FPGA\_DEVICE and FPGA\_ACCELERATOR:



<table>
<thead>
<tr class="header">
<th> Property</th>
<th> Description</th>
</tr>
</thread>
<tbody>
<tr class="even">
<td>fpga_guid guid;</td>
<td>FPGA_DEVICE: PR Interface ID<br />
FPGA_ACCELERATOR: AFU ID</td>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>fpga_token parent;</td>
<td>FPGA_DEVICE: always NULL<br />
FPGA_ACCELERATOR: the token of the corresponding FPGA_DEVICE, if any. Otherwise, NULL.</td>
</tr>
<tr class="even">
<td>fpga_objtype objtype;</td>
<td>FPGA_DEVICE or FPGA_ACCELERATOR</td>
</tr>
<tr class="odd">
<td>uint16_t segment;</td>
<td>The segment portion of the PCIe address: ssss:bb:dd.f</td>
</tr>
<tr class="even">
<td>uint8_t bus;</td>
<td><p>The bus portion of the PCIe address:</p>
<p>ssss:bb:dd.f</p></td>
</tr>
<tr class="odd">
<td>uint8_t device;</td>
<td><p>The device portion of the PCIe address:</p>
<p>ssss:bb:dd.f</p></td>
</tr>
<tr class="even">
<td>uint8_t function;</td>
<td>The function portion of the PCIe address: ssss:bb:dd.f</td>
</tr>
<tr class="odd">
<td>uint64_t object_id;</td>
<td>A unique 64-bit value that identifies this token on the system.</td>
</tr>
<tr class="even">
<td>uint16_t vendor_id;</td>
<td>The PCIe Vendor ID</td>
</tr>
<tr class="odd">
<td>uint16_t device_id;</td>
<td>The PCIe Device ID</td>
</tr>
<tr class="even">
<td>uint32_t num_errors;</td>
<td>The number of error sysfs nodes available for this token.</td>
</tr>
<tr class="odd">
<td><a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L117-L132">fpga_interface</a> interface;</td>
<td>An identifier for the underlying plugin-based access method.</td>
</tr>
</tbody>
</table>


<p align = "center">Table 3 Common Properties</p>



###### **2.1.2.1.2 FPGA\_DEVICE Properties**

Table 4 lists the set of properties that are specific to FPGA\_DEVICE
token types.



|Property | Description|
|---------------------------------------------------------------------------------------------------------- | ------------------------------ |
| uint64\_t bbs\_id;                                                                                         | FIM-specific Blue Bitstream ID |
| [fpga\_version](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L135-L146) bbs\_version; | BBS version                    |



<p align = "center">Table 4 FPGA_DEVICE Properties</p>



###### **2.1.2.1.3 FPGA\_ACCELERATOR Properties**

Table 5 lists the set of properties that are specific to
FPGA\_ACCELERATOR token types.



|Property | Description|
|----------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| [fpga\_accelerator\_state](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L92-L98) state; | Whether the Accelerator is currently open |
| uint32\_t num\_mmio;                                                                                              | The number of MMIO regions available      |
| uint32\_t num\_interrupts;                                                                                        | The number of interrupts available        |

<p align = "center">Table 5 FPGA_ACCELERATOR Properties</p>

Following is an example of using
[fpga\_properties](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L71-L92)
to enumerate a specific AFU:

```C
#define NLB0_AFU "D8424DC4-A4A3-C413-F89E-433683F9040B"
fpga_properties filter = NULL;
fpga_guid afu_id;
fpgaGetProperties(NULL, &filter); // NULL: a new empty properties
fpgaPropertiesSetObjectType(filter, FPGA_ACCELERATOR);
uuid_parse(NLB0_AFU, afu_id);
fpgaPropertiesSetGuid(filter, afu_id);
fpgaEnumerate(&filter, 1, tokens, num_tokens, &num_matches);
```
Relevant Links: 
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L122-L133">fpga_guid</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L77-L105">fpgaGetProperties</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L216-L227">fpgaPropertiesSetObjectType</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L591-L605">fpgaPropertiesSetGUID</a>

<p align = "center">Figure 4 Filtering During Enumeration</p>

Note that fpga\_properties and fpga\_token’s are allocated resources
that must be freed by their respective API calls, ie
[fpgaDestroyProperties()](https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L160-L176)
and
[fpgaDestroyToken()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L120-L133).



#### **2.1.3 Access**

Once a token is discovered and returned to the caller by
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103),
the token can be converted into a handle by
[fpgaOpen()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L41-L73).
Upon a successful call to
[fpgaOpen()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L41-L73),
the associated /dev/dfl-fme.X (FPGA\_DEVICE) or /dev/dfl-port.X
(FPGA\_ACCELERATOR) is opened and ready for use. Having acquired an
fpga\_handle, the application can then use the handle with any of the
OPAE APIs that require an fpga\_handle as an input parameter.

Like tokens and properties, handles are allocated resources. When a
handle is no longer needed, it should be closed and released by calling
[fpgaClose()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L75-L88).



#### **2.1.4 Events**

Event registration in OPAE is a two-step process. First, the type of
event must be identified. The following
[fpga\_event\_type](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L71-L82)
variants are defined:



|Event | Description|
| ---------------------- | ------------------------------------------- |
| FPGA\_EVENT\_INTERRUPT | AFU interrupt                               |
| FPGA\_EVENT\_ERROR     | Infrastructure error event (FME/Port Error) |

Table 6 FPGA Event Types

Once the desired event type is known, an
[fpga\_event\_handle](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L148-L160)
is created via
[fpgaCreateEventHandle()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L50-L63).
Once the event handle is available, the event notification is registered
using
[fpgaRegisterEvent()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L96-L128).
In the example below, note the use of the flags field for passing the
desired IRQ vector when the event type is FPGA\_EVENT\_INTERRUPT. With
the event registered, the application can then use
[fpgaGetOSObjectFromEventHandle()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L82-L94)
to obtain a file descriptor for use with the poll() system call. When
the interrupt occurs, the file descriptor will be set to the signaled
state by the DFL driver.

```C
fpga_event_handle event_handle = NULL;
int fd = -1;
fpgaCreateEventHandle(&event_handle);
fpgaRegisterEvent(fpga_handle, FPGA_EVENT_INTERRUPT,
event_handle, irq_vector);
fpgaGetOSObjectFromEventHandle(event_handle, &fd);
```


<p align = "center">Figure 5 Creating and Registering Events</p>

When an event notification is no longer needed, it should be released by
calling
[fpgaUnregisterEvent()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L130-L154).
Like device handles, event handles are allocated resources that must be
freed when no longer used. To free an event handle, use the
[fpgaDestroyEventHandle()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L65-L79)
call.




#### **2.1.5 MMIO and Shared Memory**

Communication with the AFU is achieved via reading and writing CSRs and
by reading and writing to AFU/host shared memory buffers. An AFU’s CSRs
are memory-mapped into the application process address space by way of
the
[fpgaMapMMIO()](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L141-L183)
call.

```C
uint32_t mmio_num = 0;
fpgaMapMMIO(fpga_handle, mmio_num, NULL);
fpgaWriteMMIO64(fpga_handle, mmio_num, MY_CSR, 0xa);
```

<p align = "center">Figure 6 Mapping and Accessing CSRs</p>

The second parameter, mmio\_num, is the zero-based index identifying the
desired MMIO region. The maximum number of MMIO regions for a particular
handle is found by accessing the num\_mmio property. Refer to the
[fpgaPropertiesGetNumMMIO()](https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L607-L618)
call.

Once the AFU CSRs are mapped into the process address space, the
application can use the fpgaReadMMIO**XX**() and fpgaWriteMMIO**XX**() family of
functions, eg
[fpgaReadMMIO64()](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L67-L83)
and
[fpgaWriteMMIO64()](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L49-L65).
When an MMIO region is no longer needed, it should be unmapped from the
process address space using the
[fpgaUnmapMMIO()](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L185-L201)
call.

Shared memory buffers are allocated by way of the
[fpgaPrepareBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L55-L99)
call.

```C
fpga_result fpgaPrepareBuffer(fpga_handle handle,
uint64_t len,
void **buf_addr,
uint64_t *wsid,
int flags);
```

<p align = "center">Figure 7 fpgaPrepareBuffer()</p>

Three buffer lengths are supported by this allocation method:



|Length | Description|
| ----------------- | ----------------------------------------- |
| 4096 (4KiB)       | No memory configuration needed.           |
| 2097152 (2MiB)    | Requires 2MiB huge pages to be allocated. |
| 1073741824 (1GiB) | Requires 1GiB huge pages to be allocated. |

<p align = "center">Table 7 fpgaPrepareBuffer() Lengths</p>

```bash
echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
echo 2 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
```

<p align = "center">Figure 8 Configuring Huge Pages</p>

The buf\_addr parameter to
[fpgaPrepareBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L55-L99)
is a pointer to a void \* that accepts the user virtual base address of
the newly-created buffer. The wsid parameter is a pointer to a uint64\_t
that receives a unique workspace ID for the buffer allocation. This
workspace ID is used in subsequent calls to
[fpgaReleaseBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L101-L115),
which should be called when the buffer is no longer needed and in calls
to
[fpgaGetIOAddress()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L117-L136)
which is used to query the IO base address of the buffer. The IO base
address can be programmed into the AFU by means of the AFU CSR space.
For example, here is a code snippet from the
[hello\_fpga](https://github.com/OFS/opae-sdk/blob/master/samples/hello_fpga/hello_fpga.c)
sample that demonstrates programming a shared buffer’s IO base address
into an AFU CSR in MMIO region 0:

```C
#define LOG2_CL 6
#define CACHELINE_ALIGNED_ADDR(p) ((p) >> LOG2_CL)
fpgaGetIOAddress(accelerator_handle, input_wsid, &iova);
fpgaWriteMMIO64(accelerator_handle, 0, nlb_base_addr + CSR_SRC_ADDR,
CACHELINE_ALIGNED_ADDR(iova));
```

<p align = "center">Figure 9 Programming Shared Memory</p>

If applications need to map a shared buffer that has been allocated by
some other means than
[fpgaPrepareBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L55-L99),
then the flags parameter can be set to
[FPGA\_BUF\_PREALLOCATED](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L140).
This causes
[fpgaPrepareBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L55-L99)
to skip the allocation portion of the call and to only memory map the
given buf\_addr into the application process address space.

Buffers can also be allocated and mapped as read-only by specifying
[FPGA\_BUF\_READ\_ONLY](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L142).



#### **2.1.6 Management**

The management feature in OPAE concerns re-programming the programmable
region of the Port. To program the Port bitstream, pass a handle to the
FPGA\_DEVICE associated with the desired Port. The slot parameter
identifies which Port to program in the case of multi-port
implementations. Most designs will only pass zero as the slot parameter.
The bitstream parameter is a buffer that contains the entire bitstream
contents, including the JSON bitstream header information. The
bitstream\_len field gives the length of bitstream in bytes.

[fpgaReconfigureSlot()](https://github.com/OFS/opae-sdk/blob/master/include/opae/manage.h#L109-L141)
first checks whether the FPGA\_ACCELERATOR corresponding to the
FPGA\_DEVICE in fme\_handle is open. If it is open, then the programming
request is aborted with an error code. The application may pass
[FPGA\_RECONF\_FORCE](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L162)
in the flags parameter in order to avoid this open check and forcefully
program the bitstream.

```C
fpga_result fpgaReconfigureSlot(fpga_handle fme_handle,
uint32_t slot,
const uint8_t *bitstream,
size_t bitstream_len,
int flags);
```

<p align = "center">Figure 10 fpgaReconfigureSlot()</p>



#### **2.1.7 Errors**

The OPAE errors API provides a means to query and clear both
FPGA\_DEVICE and FPGA\_ACCELERATOR errors. Each FPGA device exports a
collection of error registers via the DFL drivers’ sysfs tree, for both
the FME and the Port. Each register is typically an unsigned 64-bit mask
of the current errors, where each bit or some collection of bits
specifies an error type. An error is signaled if its bit or collection
of bits is non-zero. Note that the 32-bit error index may vary from one
process execution to the next. Applications should use
[fpgaGetErrorInfo](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L91-L106)()
and examine the error name returned in the struct
[fpga\_error\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L162-L172)
to identify the desired 64-bit error mask.

```C
struct fpga_error_info {
char name[FPGA_ERROR_NAME_MAX];
bool can_clear;
};
```

<p align = "center">Figure 11 struct fpga_error_info</p>

Each 64-bit mask of errors is assigned a unique 32-bit integer index and
a unique name. Given an fpga\_token and an error index,
[fpgaGetErrorInfo](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L91-L106)()
retrieves the struct
[fpga\_error\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L162-L172)
corresponding to the error.

```C
fpga_result fpgaGetErrorInfo(fpga_token token,
uint32_t error_num,
struct fpga_error_info *error_info);
```

<p align = "center">Figure 12 fpgaGetErrorInfo()</p>

[fpgaReadError](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L46-L60)()
provides access to the raw 64-bit error mask, given the unique error
index.
[fpgaClearError](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L62-L75)()
clears the errors for a particular index.
[fpgaClearAllErrors](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L77-L89)()
clears all the errors for the given fpga\_token.



#### **2.1.8 Metrics**

The OPAE metrics API refers to a group of functions and data structures
that allow querying the various device metrics from the Board Management
Controller component of the FPGA device. A metric is described by an
instance of struct
[fpga\_metric\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L208-L221).

```C
typedef struct fpga_metric_info {
uint64_t metric_num;
fpga_guid metric_guid;
char qualifier_name[FPGA_METRIC_STR_SIZE];
char group_name[FPGA_METRIC_STR_SIZE];
char metric_name[FPGA_METRIC_STR_SIZE];
char metric_units[FPGA_METRIC_STR_SIZE];
enum fpga_metric_datatype metric_datatype;
enum fpga_metric_type metric_type;
} fpga_metric_info;
```
Relevant Links: 
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L200-L210">fpga_metric_datatype</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L188-L198">fpga_metric_type</a>

<p align = "center">Figure 13 fpga_metric_info</p>

The group\_name field holds a string describing the broad categorization
of the metric. Some sample values for group\_name are “thermal\_mgmt”
and “power\_mgmt”. The metric\_name field contains the metric’s name.
The number and names of metrics may vary from one FPGA platform to the
next. The qualifier\_name field is a concatenation of group\_name and
metric\_name, with a colon character in between. The metric\_units field
contains the string name of the unit of measurement for the specific
metric. Some examples for metric\_units are “Volts”, “Amps”, and
“Celsius”.

The metric\_datatype field uniquely identifies the underlying C data
type for the metric’s value:



```C
enum fpga_metric_datatype {
FPGA_METRIC_DATATYPE_INT,
FPGA_METRIC_DATATYPE_FLOAT,
FPGA_METRIC_DATATYPE_DOUBLE,
FPGA_METRIC_DATATYPE_BOOL,
FPGA_METRIC_DATATYPE_UNKNOWN
};
```



<p align = "center">Figure 14 enum fpga_metric_datatype</p>

The metric\_type field classifies the metric into a broad category. This
information is redundant with the group\_name field.



```C
enum fpga_metric_type {
FPGA_METRIC_TYPE_POWER,
FPGA_METRIC_TYPE_THERMAL,
FPGA_METRIC_TYPE_PERFORMANCE_CTR,
FPGA_METRIC_TYPE_AFU,
FPGA_METRIC_TYPE_UNKNOWN
};
```



<p align = "center">Figure 15 enum fpga_metric_type</p>

In order to enumerate the information for each of the metrics available
from the FPGA device, determine the number of metrics using
[fpgaGetNumMetrics](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L45-L57)().



```C
uint64_t num_metrics = 0;
fpgaGetNumMetrics(handle, &num_metrics);
```



<p align = "center">Figure 16 Determining Number of Metrics</p>

This call retrieves the number of available metrics for the FPGA\_DEVICE
that is opened behind the handle parameter to the call. Refer to 2.1.3
Access for information about the fpgaOpen() call. When the number of
available metrics is known, allocate a buffer large enough to hold that
many
[fpga\_metric\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L208-L221)
data structures, and call
[fpgaGetMetricsInfo](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L59-L75)()
to populate the entries:



```C
fpga_metric_info *metric_info;
uint64_t metric_infos = num_metrics;
metric_info = calloc(num_metrics, sizeof(fpga_metric_info));
fpgaGetMetricsInfo(handle, metric_info, &metric_infos);
```



<p align = "center">Figure 17 Querying Metrics Info</p>

The
[fpga\_metric](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L223-L231)
structure is the representation of a metric’s value:



```C
typedef struct fpga_metric {
uint64_t metric_num;
metric_value value;
bool isvalid;
} fpga_metric;
```
Relevant Links:
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L196-L205">metric_value</a>




<p align = "center">Figure 18 struct fpga_metric</p>

The metric\_num field matches the metric\_num field of the
[fpga\_metric\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L208-L221)
structure. value contains the metric value, which is encoded in the C
data type identified by the metric\_datatype field of
[fpga\_metric\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L208-L221).
Finally, the isvalid field denotes whether the metric value is valid.

There are two methods of obtaining a metric’s value, given the
information in the
[fpga\_metric\_info](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L208-L221)
structure:



##### **2.1.8.1 Querying Metric Values by Index**

[fpgaGetMetricsByIndex](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L77-L94)()
retrieves a metric value using the metric\_num field of the metric info:



```C
uint64_t metric_num = metric_info[0]->metric_num;
fpga_metric metric0;
fpgaGetMetricsByIndex(handle, &metric_num, 1, &metric0);
```



<p align = "center">Figure 19 Retrieve Metric by Index</p>

This call allows retrieving one or more metric values, each identified
by their unique metric\_num. The second and fourth parameters allow
passing arrays so that multiple values can be fetched in a single call.



##### **2.1.8.2 Querying Metric Values by Name**

[fpgaGetMetricsByName](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L96-L112)()
retrieves a metric value using the metric\_name field of the metric
info:



```C
char *metric_name = metric_info[1]->metric_name;
fpga_metric metric1;
fpgaGetMetricsByName(handle, &metric_name, 1, &metric1);
```



This call also allows retrieving one or more metric values, each
identified by their unique metric\_name. The second and fourth
parameters allow passing arrays so that multiple values can be fetched
in a single call.

The
[fpgaGetMetricsThresholdInfo](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L115-L133)()
call is provided for legacy implementations only. It should be
considered deprecated for current and future FPGA designs.



#### **2.1.9 SysObject**

When the hardware access method in use is the DFL drivers (see 2.3.2
libxfpga Plugin), the sysfs tree rooted at the struct \_fpga\_token’s
sysfspath member is accessible via the OPAE SDK SysObject API. The
SysObject API provides an abstraction to search, traverse, read, and
write sysfs entities. These sysfs entities may take the form of
directories, which are referred to as containers, or files, which are
referred to as attributes. Figure 20 enum fpga\_sysobject\_type shows
the API’s means of distinguishing between the two types.



```C
enum fpga_sysobject_type {
FPGA_OBJECT_CONTAINER = (1u << 0),
FPGA_OBJECT_ATTRIBUTE = (1u << 1)
};
```



<p align = "center">Figure 20 enum fpga_sysobject_type</p>

The SysObject API introduces another opaque structure type,
[fpga\_object](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L174-L189).
An
[fpga\_object](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L174-L189)
can be queried from an fpga\_token or an fpga\_handle by way of the
[fpgaTokenGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L42-L67)()
and
[fpgaHandleGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L69-L94)()
API’s.


```C
fpga_result fpgaTokenGetObject(fpga_token token, const char *name,
fpga_object *object, int flags);
fpga_result fpgaHandleGetObject(fpga_handle handle, const char *name,
fpga_object *object, int flags);
```



<p align = "center">Figure 21 fpgaTokenGetObject() / fpgaHandleGetObject()</p>

The remainder of the SysObject API is broken into two categories of
calls, depending on the fpga\_object’s type. The type of an fpga\_object
is learned via
[fpgaObjectGetType](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L145-L155)().



```C
fpga_result fpgaObjectGetType(fpga_object obj,
enum fpga_sysobject_type *type);
```



<p align = "center">Figure 22 fpgaObjectGetType()</p>

When an fpga\_object is no longer needed, it should be freed via
[fpgaDestroyObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L157-L170)().



##### **2.1.9.1 FPGA\_OBJECT\_CONTAINER API’s**

For directory sysfs entities, passing a value of
[FPGA\_OBJECT\_RECURSE\_ONE](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L172)
or
[FPGA\_OBJECT\_RECURSE\_ALL](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L175)
in the flags parameter to
[fpgaTokenGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L42-L67)()
or
[fpgaHandleGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L69-L94)()
causes these two API’s to treat the target object as either a
single-layer or multi-layer directory structure, making its child
entities available for query via
[fpgaObjectGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L96-L124)()
and
[fpgaObjectGetObjectAt](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L126-L144)().



```C
fpga_result fpgaObjectGetObject(fpga_object parent, const char *name,
fpga_object *object, int flags);
fpga_result fpgaObjectGetObjectAt(fpga_object parent, size_t idx,
fpga_object *object);
```



<p align = "center">Figure 23 fpgaObjectGetObject() / fpgaObjectGetObjectAt()</p>

Any child object resulting from
[fpgaObjectGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L96-L124)()
or
[fpgaObjectGetObjectAt](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L126-L144)()
must be freed via
[fpgaDestroyObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L157-L170)()
when it is no longer needed.



##### **2.1.9.2 FPGA\_OBJECT\_ATTRIBUTE API’s**

Attribute sysfs entities may be queried for their size and read from or
written to. In order to determine the size of an attribute’s data, use
[fpgaObjectGetSize](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L172-L184)().



```C
fpga_result fpgaObjectGetSize(fpga_object obj,
uint32_t *value, int flags);
```



<p align = "center">Figure 24 fpgaObjectGetSize()</p>

Attributes containing arbitrary string data can be read with
[fpgaObjectRead](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L186-L202)().



```C
fpga_result fpgaObjectRead(fpga_object obj, uint8_t *buffer,
size_t offset, size_t len, int flags);
```



<p align = "center">Figure 25 fpgaObjectRead()</p>

If an attribute contains an unsigned integer value, its value can be
read with
[fpgaObjectRead64](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L204-L219)()
and written with
[fpgaObjectWrite64](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L221-L236)().



```C
fpga_result fpgaObjectRead64(fpga_object obj,
uint64_t *value, int flags);
fpga_result fpgaObjectWrite64(fpga_object obj,
uint64_t value, int flags);
```



<p align = "center">Figure 26 fpgaObjectRead64() / fpgaObjectWrite64()</p>



#### **2.1.10 Utilities**

The
[fpga\_result](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L38-L69)
enumeration defines a set of error codes used throughout OPAE. In order
to convert an
[fpga\_result](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L38-L69)
error code into a printable string, the application can use the
[fpgaErrStr()](https://github.com/OFS/opae-sdk/blob/master/include/opae/utils.h#L42-L51)
call.



### **2.2 DFL Driver IOCTL Interfaces**

The DFL drivers export an IOCTL interface which the libxfpga.so plugin
consumes in order to query and configure aspects of the FME and Port.
These interfaces are used only internally by the SDK; they are not
customer-facing. The description here is provided for completeness only.



#### **2.2.1 Port Reset**

The
[DFL\_FPGA\_PORT\_RESET](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L70-L80)
ioctl is used by the
[fpgaReset()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L90-L102)
call in order to perform a Port reset. The fpga\_handle passed to
[fpgaReset()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L90-L102)
must be a valid open handle to an FPGA\_ACCELERATOR. The ioctl requires
no input/output parameters.



#### **2.2.2 Port Information**

The
[DFL\_FPGA\_PORT\_GET\_INFO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L82-L99)
ioctl is used to query properties of the Port, notably the number of
associated MMIO regions. The ioctl requires a pointer to a struct
[dfl\_fpga\_port\_info](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L90-L97).



#### **2.2.3 MMIO Region Information**

The
[DFL\_FPGA\_PORT\_GET\_REGION\_INFO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L101-L128)
ioctl is used to query the details of an MMIO region. The ioctl requires
a pointer to a struct
[dfl\_fpga\_port\_region\_info](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L110-L126).
The index field of the struct is populated by the caller, and the
padding, size, and offset values are populated by the DFL driver.




#### **2.2.4 Shared Memory Mapping and Unmapping**

The
[DFL\_FPGA\_PORT\_DMA\_MAP](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L130-L149)
ioctl is used to map a memory buffer into the application’s process
address space. The ioctl requires a pointer to a struct
[dfl\_fpga\_port\_dma\_map](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L139-L147).

The
[DFL\_FPGA\_PORT\_DMA\_UNMAP](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L151-L165)
ioctl is used to unmap a memory buffer from the application’s process
address space. The ioctl requires a pointer to a struct
[dfl\_fpga\_port\_dma\_unmap](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L158-L163).

These ioctls provide the underpinnings of the
[fpgaPrepareBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L55-L99)
and
[fpgaReleaseBuffer()](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L101-L115)
calls.



#### **2.2.5 Number of Port Error IRQs**

The
[DFL\_FPGA\_PORT\_ERR\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L180-L189)
ioctl is used to query the number of Port error interrupt vectors
available. The ioctl requires a pointer to a uint32\_t that receives the
Port error interrupt count.



#### **2.2.6 Port Error Interrupt Configuration**

The
[DFL\_FPGA\_PORT\_ERR\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L191-L201)
ioctl is used to configure one or more file descriptors for the Port
Error interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.



#### **2.2.7 Number of AFU Interrupts**

The
[DFL\_FPGA\_PORT\_UINT\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L203-L212)
ioctl is used to query the number of AFU interrupt vectors available.
The ioctl requires a pointer to a uint32\_t that receives the AFU
interrupt count.



#### **2.2.8 User AFU Interrupt Configuration**

The
[DFL\_FPGA\_PORT\_UINT\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L214-L224)
ioctl is used to configure one or more file descriptors for the AFU
interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.



#### **2.2.9 Partial Reconfiguration**

The
[DFL\_FPGA\_FME\_PORT\_PR](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L228-L249)
ioctl is used to update the logic stored in the Port’s programmable
region. This ioctl must be issued on the device file descriptor
corresponding to the FPGA\_DEVICE (/dev/dfl-fme.X). The ioctl requires a
pointer to a struct
[dfl\_fpga\_fme\_port\_pr](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L240-L247)
with each of the fields populated.



#### **2.2.10 Number of FME Error IRQs**

The
[DFL\_FPGA\_FME\_ERR\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L269-L278)
ioctl is used to query the number of FME error interrupt vectors
available. The ioctl requires a pointer to a uint32\_t that receives the
FME error interrupt count.



#### **2.2.11 FME Error Interrupt Configuration**

The
[DFL\_FPGA\_FME\_ERR\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L280-L290)
ioctl is used to configure one or more file descriptors for the FME
Error interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.
as returned by the eventfd() C standard library API.


### **2.3 Plugin Manager**

The OPAE Plugin Manager refers to initialization code in libopae-c that
examines an FPGA device’s PCIe Vendor and Device ID and makes an
association between a particular FPGA device and its access method. OPAE
currently supports three device access methods:

<table>
<tbody>
<tr class="odd">
<td><blockquote>
<p><strong>Access Method</strong></p>
</blockquote></td>
<td><blockquote>
<p><strong>Plugin Module</strong></p>
</blockquote></td>
</tr>
<tr class="even">
<td>Device Feature List drivers</td>
<td>libxfpga.so</td>
</tr>
<tr class="odd">
<td>Virtual Function I/O</td>
<td>libopae-v.so</td>
</tr>
<tr class="even">
<td>AFU Simulation Environment</td>
<td>libase.so</td>
</tr>
</tbody>
</table>

<p align = "center">Table 9 Plugin Device Access Methods</p>

The Plugin Manager allows code that is written to a specific API
signature to access FPGA hardware via different mechanisms. In other
words, the end user codes to the OPAE API; and the OPAE API, based on
configuration data, routes the hardware access to the device via
different means.

As an example, consider an API configuration that accesses FPGA
device\_A via the Device Feature List drivers and that accesses FPGA
device\_B via VFIO. The application is coded against the OPAE API.

As part of its initialization process, the application enumerates and
discovers an fpga\_token corresponding to device\_A. That fpga\_token is
opened and its MMIO region 0 is mapped via a call to
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L577-L589)().

The API configuration for device\_A is such that the fpga\_handle
corresponding to device\_A routes its hardware access calls through
libxfpga.so. The call to
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L577-L589)()
is redirected to libxfpga.so’s implementation of the MMIO mapping
function,
[xfpga\_fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/mmio.c#L374-L401)().
As a result, the call to
[xfpga\_fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/mmio.c#L374-L401)()
uses its [AFU file
descriptor](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/mmio.c#L71)
to communicate with the DFL driver to map the MMIO region.

Subsequently, the application enumerates and discovers an fpga\_token
corresponding to device\_B. That fpga\_token is opened and its MMIO
region 0 is mapped via a call to
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L577-L589)().

The API configuration for device\_B is such that the fpga\_handle
corresponding to device\_B routes its hardware access calls through
libopae-v.so. The call to
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L577-L589)()
is redirected to libopae-v.so’s implementation of the MMIO mapping
function,
[vfio\_fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L996-L1014)().
As a result, the call to
[vfio\_fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L996-L1014)()
uses the [MMIO
mapping](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L843-L850)
performed by libopaevfio.so during initialization of the VFIO session.



#### **2.3.1 Plugin Model**

The OPAE SDK plugin model is facilitated by its use of opaque C
structures for
[fpga\_token](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L94-L107)
and
[fpga\_handle](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L109-L120).
These types are both declared as void \*; and this allows the parameters
to the OPAE SDK functions to take different forms, depending on the
layer of the SDK being used.

At the topmost layer, for example when calling
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L685-L821)(),
the output fpga\_token parameter array is actually an array of pointers
to
[opae\_wrapped\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/opae_int.h#L102-L109)
struct’s.


```C
typedef struct _opae_wrapped_token {
uint32_t magic;
fpga_token opae_token;
uint32_t ref_count;
struct _opae_wrapped_token *prev;
struct _opae_wrapped_token *next;
opae_api_adapter_table *adapter_table;
} opae_wrapped_token;
```



<p align = "center">Figure 27 opae_wrapped_token</p>

An
[opae\_wrapped\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/opae_int.h#L102-L109),
as the name suggests, is a thin wrapper around the lower-layer token
which is stored in struct member opae\_token. The
[adapter\_table](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/adapter.h#L38-L220)
struct member is a pointer to a plugin-specific adapter table. The
adapter table provides a mapping between the top-layer
[opae\_wrapped\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/opae_int.h#L102-L109)
and its underlying plugin-specific API entry points, which are called
using the opae\_token struct member (the lower-level token).



```C
typedef struct _opae_api_adapter_table {
struct _opae_api_adapter_table *next;
opae_plugin plugin;
...
fpga_result (*fpgaEnumerate)(const fpga_properties *filters,
uint32_t num_filters,
fpga_token *tokens,
uint32_t max_tokens,
uint32_t *num_matches);
...
int (*initialize)(void);
int (*finalize)(void);
} opae_api_adapter_table;
```



<p align = "center">Figure 28 opae_api_adapter_table</p>

When libopae-c loads, the plugin manager uses the plugin configuration
data to open and configure a session to each of the required plugin
libraries. During this configuration process, each plugin is passed an
empty adapter table struct. The purpose of the plugin configuration is
to populate this adapter table struct with each of the plugin-specific
API entry points.

When the top-level
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L685-L821)()
is called, each adapter table’s plugin-specific fpgaEnumerate() struct
member is called; and the output fpga\_token’s are collected. At this
point, these fpga\_token’s are the lower-level token structure types.
Before the top-level
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L685-L821)()
returns, these plugin-specific tokens are wrapped inside
opae\_wrapped\_token structures, along with a pointer to the respective
adapter table.

After enumeration is complete, the application goes on to call other
top-level OPAE SDK functions with the wrapped tokens. Each top-level
entry point which accepts an fpga\_token knows that it is actually being
passed an
[opae\_wrapped\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/opae_int.h#L102-L109).
With this knowledge, the entry point peeks inside the wrapped token and
calls through to the plugin-specific API entry point using the adapter
table, passing the lower-level opae\_token struct member.



#### **2.3.2 libxfpga Plugin**

2.3.1 Plugin Model introduced the concept of an
[opae\_wrapped\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/opae_int.h#L102-L109)
and a corresponding plugin-specific token structure. libxfpga.so is the
plugin library that implements the DFL driver hardware access method.
Its plugin-specific token data structure is struct
[\_fpga\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/types_int.h#L101-L108).



```C
struct _fpga_token {
fpga_token_header hdr;
uint32_t device_instance;
uint32_t subdev_instance;
char sysfspath[SYSFS_PATH_MAX];
char devpath[DEV_PATH_MAX];
struct error_list *errors;
};
```
Relevant Links:
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L255-L276">fpga_token_header</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/error_int.h#L38-L43">error_list</a>



<p align = "center">Figure 29 struct _fpga_token</p>

A struct \_fpga\_token corresponding to the Port will have sysfspath and
devpath members that contain strings like the following example paths:



```bash
sysfspath: “/sys/class/fpga_region/region0/dfl-port.0”
devpath: “/dev/dfl-port.0”
```



<p align = "center">Figure 30 libxfpga Port Token</p>

Likewise, a struct \_fpga\_token corresponding to the FME will have
sysfspath and devpath members that contain strings like the following
example paths:



```bash
sysfspath: “/sys/class/fpga_region/region0/dfl-fme.0”
devpath: “/dev/dfl-fme.0”
```



<p align = "center">Figure 31 libxfpga FME Token</p>

When a call to the top-level
[fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L272-L307)()
is made, the lower-level token is unwrapped and passed to
[xfpga\_fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/open.c#L41-L172)().
In return,
[xfpga\_fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/open.c#L41-L172)()
opens the character device file identified by the devpath member of the
struct \_fpga\_token. It then allocates and initializes an instance of
libxfpga.so’s plugin-specific handle data structure, struct
[\_fpga\_handle](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/types_int.h#L153-L177).



```C
struct _fpga_handle {
pthread_mutex_t lock;
uint64_t magic;
fpga_token token;
int fddev;
int fdfpgad;
uint32_t num_irqs;
uint32_t irq_set;
struct wsid_tracker *wsid_root;
struct wsid_tracker *mmio_root;
void *umsg_virt;
uint64_t umsg_size;
uint64_t *umsg_iova;
bool metric_enum_status;
fpga_metric_vector fpga_enum_metric_vector;
void *bmc_handle;
struct _fpga_bmc_metric *_bmc_metric_cache_value;
uint64_t num_bmc_metric;
uint32_t flags;
};
```
Relevant Links:
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/types_int.h#L205-L211">wsid_tracker</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/metrics/vector.h#L45-L49">fpga_metric_vector</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/types_int.h#L146-L151">_fpga_bmc_metric</a>



<p align = "center">Figure 32 struct _fpga_handle</p>



#### **2.3.3 libopae-v Plugin**

libopae-v.so is the plugin library that implements the VFIO hardware
access method. Its plugin-specific token data structure is
[vfio\_token](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L98-L115).



```C
#define USER_MMIO_MAX 8
typedef struct _vfio_token {
fpga_token_header hdr;
fpga_guid compat_id;
pci_device_t *device;
uint32_t region;
uint32_t offset;
uint32_t mmio_size;
uint32_t pr_control;
uint32_t user_mmio_count;
uint32_t user_mmio[USER_MMIO_MAX];
uint64_t bitstream_id;
uint64_t bitstream_mdata;
uint8_t num_ports;
struct _vfio_token *parent;
struct _vfio_token *next;
vfio_ops ops;
} vfio_token;
```
Relevant Links:
- <a href="https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L255-L276">fpga_token_header</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L83-L92">pci_device_t</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L94-L96">vfio_ops</a>



<p align = "center">Figure 33 vfio_token</p>

When a call to the top-level
[fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/api-shell.c#L272-L307)()
is made, the lower-level token is unwrapped and passed to
[vfio\_fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L603-L681)().
In return,
[vfio\_fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L603-L681)()
[opens the VFIO
device](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.c#L645)
matching the device address found in the input vfio\_token. It then
allocates and initializes an instance of libopae-v.so’s plugin-specific
handle data structure,
[vfio\_handle](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L124-L134).



```C
typedef struct _vfio_handle {
uint32_t magic;
struct _vfio_token *token;
vfio_pair_t *vfio_pair;
volatile uint8_t *mmio_base;
size_t mmio_size;
pthread_mutex_t lock;
#define OPAE_FLAG_HAS_AVX512 (1u << 0)
uint32_t flags;
} vfio_handle;
```
Relevant Links:
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L98-L115">vfio_token</a>
- <a href="https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/vfio/opae_vfio.h#L118-L122">vfio_pair_t</a>



<p align = "center">Figure 34 vfio_handle</p>



##### **2.3.3.1 Supporting Libraries**



###### **2.3.3.1.1 libopaevfio**

[libopaevfio.so](https://github.com/OFS/opae-sdk/blob/master/include/opae/vfio.h)
is OPAE’s implementation of the Linux kernel’s Virtual Function I/O
interface. This VFIO interface presents a generic means of configuring
and accessing PCIe endpoints from a user-space process via a supporting
Linux kernel device driver, vfio-pci.

libopaevfio.so provides APIs for opening/closing a VFIO device instance,
for mapping/unmapping MMIO spaces, for allocating/freeing DMA buffers,
and for configuring interrupts for the device.



###### **2.3.3.1.2 libopaemem**

Each DMA buffer allocation made by libopaevfio.so’s
[opae\_vfio\_buffer\_allocate](https://github.com/OFS/opae-sdk/blob/master/include/opae/vfio.h#L333-L336)()
and
[opae\_vfio\_buffer\_allocate\_ex](https://github.com/OFS/opae-sdk/blob/master/include/opae/vfio.h#L394-L398)()
APIs requires a backing I/O Virtual Address range. These address ranges
are discovered at VFIO device open time by way of the
[VFIO\_IOMMU\_GET\_INFO](https://github.com/OFS/opae-sdk/blob/master/libraries/libopaevfio/opaevfio.c#L543)
ioctl.

Each range specifies a large contiguous block of I/O Virtual Address
space. The typical DMA buffer allocation size is significantly less than
one of these IOVA blocks, so the division of each block into allocatable
segments must be managed so that multiple DMA buffer allocations can be
made from a single block. In other words, the IOVA blocks must be
memory-managed in order to make efficient use of them.

[libopaemem.so](https://github.com/OFS/opae-sdk/blob/master/include/opae/mem_alloc.h)
provides a generic means of managing a large memory space, consisting of
individual large memory blocks of contiguous address space. When a DMA
buffer allocation is requested, libopaevfio.so uses this generic memory
manager to carve out a small chunk of contiguous IOVA address space in
order for the DMA mapping to be made. The IOVA space corresponding to
the allocation is marked as allocated, and the rest of the large block
remains as allocatable space within the memory manager. Subsequent
de-allocation returns a chunk of IOVA space to the free state,
coalescing contiguous chunks as they are freed. The allocations and
de-allocations of the IOVA space can occur in any order with respect to
each other. libopaemem.so tracks both the allocated and free block
space, carving out small chunks from the large IOVA blocks on
allocations, and coalescing small chunks back into larger ones on frees.



##### **2.3.3.2 Configuring PCIe Virtual Functions**

Before an AFU can be accessed with VFIO, the FPGA Physical Function must
be configured to enable its Virtual Functions. Then, each VF must be
bound to the vfio-pci Linux kernel driver.

As of the Arrow Creek program, the FPGA hardware allows multiple AFU’s
to co-exist by placing each AFU in its own PCIe Virtual Function. Upon
system startup, no PCIe VF’s exist. The pci\_device command can be used
to enable the VF’s and their AFU’s. First, use the lspci command to
examine the current device topology:



```bash
# lspci | grep cel
b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
b1:00.1 Processing accelerators: Intel Corporation Device bcce
b1:00.2 Processing accelerators: Intel Corporation Device bcce
b1:00.3 Processing accelerators: Intel Corporation Device bcce
b1:00.4 Processing accelerators: Intel Corporation Device bcce
```


<p align = "center">Figure 35 lspci Device Topology</p>

In this example, VF’s are controlled by PF 0, as highlighted in [Figure
35 lspci Device Topology](#figure-35). In the figure, each PF is shown as having the
Arrow Creek PF PCIe device ID of bcce.

Now, use the pci\_device command to enable three VF’s for PF0:



```bash
# pci_device 0000:b1:00.0 vf 3
# lspci | grep cel
b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
b1:00.1 Processing accelerators: Intel Corporation Device bcce
b1:00.2 Processing accelerators: Intel Corporation Device bcce
b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device
b1:00.4 Processing accelerators: Intel Corporation Device bcce
b1:00.5 Processing accelerators: Intel Corporation Device bccf
b1:00.6 Processing accelerators: Intel Corporation Device bccf
b1:00.7 Processing accelerators: Intel Corporation Device bccf
```



<p align = "center">Figure 36 Enable Virtual Functions</p>

Figure 20 Enable Virtual Functions shows that three VF’s were created.
Each VF is shown as having the Arrow Creek VF PCIe device ID of bccf.

Now, each Virtual Function must be bound to the vfio-pci Linux kernel
driver so that it can be accessed via VFIO:



```bash
# opaevfio -i -u myuser -g mygroup 0000:b1:00.5
Binding (0x8086,0xbccf) at 0000:b1:00.5 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.5 is 318
```



<p align = "center">Figure 37 Bind VF's to vfio-pci</p>

Here, myuser and mygroup identify the unprivileged user/group that
requires access to the device. The opaevfio command will change the
ownership of the device per the values given.

Once the VF’s are bound to vfio-pci, the OPAE SDK will find and
enumerate them with libopae-v.so:



```bash
# fpgainfo port
//****** PORT ******//
Object Id : 0xEF00000
PCIe s:b:d.f : 0000:B1:00.0
Device Id : 0xBCCE
Socket Id : 0x00
//****** PORT ******//
Object Id : 0xE0B1000000000000
PCIe s:b:d.f : 0000:B1:00.7
Device Id : 0xBCCF
Socket Id : 0x01
Accelerator GUID : 4dadea34-2c78-48cb-a3dc-5b831f5cecbb
//****** PORT ******//
Object Id : 0xC0B1000000000000
PCIe s:b:d.f : 0000:B1:00.6
Device Id : 0xBCCF
Socket Id : 0x01
Accelerator GUID : 823c334c-98bf-11ea-bb37-0242ac130002
//****** PORT ******//
Object Id : 0xA0B1000000000000
PCIe s:b:d.f : 0000:B1:00.5
Device Id : 0xBCCF
Socket Id : 0x01
Accelerator GUID : 8568ab4e-6ba5-4616-bb65-2a578330a8eb
```



<p align = "center">Figure 38 List VF's with fpgainfo</p>

When the VF’s are no longer needed, they can be unbound from the
vfio-pci driver:



```bash
# opaevfio -r 0000:b1:00.5
Releasing (0x8086,0xbccf) at 0000:b1:00.5 from vfio-pci
# opaevfio -r 0000:b1:00.6
Releasing (0x8086,0xbccf) at 0000:b1:00.6 from vfio-pci
# opaevfio -r 0000:b1:00.7
Releasing (0x8086,0xbccf) at 0000:b1:00.7 from vfio-pci
```


<p align = "center">Figure 39 Unbind VF's from vfio-pci</p>

Finally, the VF’s can be disabled:



```bash
# pci_device 0000:b1:00.0 vf 0
# lspci | grep cel
b1:00.0 Processing accelerators: Intel Corporation Device bcce (rev 01)
b1:00.1 Processing accelerators: Intel Corporation Device bcce
b1:00.2 Processing accelerators: Intel Corporation Device bcce
b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device
b1:00.4 Processing accelerators: Intel Corporation Device bcce
```



<p align = "center">Figure 40 Disable Virtual Functions</p>

### **2.4 Application Flow**


A typical OPAE application that interacts with an AFU via MMIO and
shared memory will have a flow similar to the one described in this
section.



#### **2.4.1 Create Filter Criteria**

Refer to 2.1.2 Enumeration. When enumerating AFU’s, if no filtering
criteria is specified, then
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L101-L103)()
returns fpga\_token’s for each AFU that is present in the system. In
order to limit the enumeration search to a specific AFU, create an
fpga\_properties object and set its guid to that of the desired AFU:



```C
#define MY_AFU_GUID “57fa0b03-ab4f-4b02-b4eb-d3fe1ec18518”
fpga_properties filter = NULL;
fpga_guid guid;
fpgaGetProperties(NULL, &filter);
uuid_parse(MY_AFU_GUID, guid);
fpgaPropertiesSetGUID(filter, guid);
```



<p align = "center">Figure 41 Flow: Create Filter Criteria</p>



#### **2.4.2 Enumerate the AFU**

With the filtering criteria in place, enumerate to obtain an fpga\_token
for the AFU:



```C
fpga_token afu_token = NULL;
uint32_t num_matches = 0;
fpgaEnumerate(&filter, 1, &afu_token, 1, &num_matches);
```



<p align = "center">Figure 42 Flow: Enumerate the AFU</p>



#### **2.4.3 Open the AFU**

After finding an fpga\_token for the AFU using
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L101-L103)(),
the token must be opened with
[fpgaOpen](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L72-L73)()
to establish a session with the AFU. The process of opening an
fpga\_token creates an fpga\_handle:



```C
fpga_handle afu_handle = NULL;
fpgaOpen(afu_token, &afu_handle, 0);
```



<p align = "center">Figure 43 Flow: Open the AFU</p>



#### **2.4.4 Map MMIO Region**

In order to access the MMIO region of the AFU to program its CSR’s, the
region must first be mapped into the application’s process address
space. This is accomplished using
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L182-L183)():



```C
uint32_t region = 0;
fpgaMapMMIO(afu_handle, region, NULL);
```



<p align = "center">Figure 44 Flow: Map MMIO Region</p>



#### **2.4.5 Allocate DMA Buffers**

If the AFU is DMA-capable, shared memory buffers can be allocated and
mapped into the process address space and the IOMMU with
[fpgaPrepareBuffer](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L97-L99)().
Refer to Figure 8 Configuring Huge Pages for instructions on configuring
2MiB and 1GiB huge pages.



```C
#define BUF_SIZE (2 * 1024 * 1024)
volatile uint64_t *src_ptr = NULL;
uint64_t src_wsid = 0;
volatile uint64_t *dest_ptr = NULL;
uint64_t dest_wsid = 0;
fpgaPrepareBuffer(afu_handle, BUF_SIZE, (void **)&src_ptr,
&src_wsid, 0);
fpgaPrepareBuffer(afu_handle, BUF_SIZE, (void **)&dest_ptr,
&dest_wsid, 0);
memset(src_ptr, 0xaf, BUF_SIZE);
memset(dest_ptr, 0xbe, BUF_SIZE);
```



<p align = "center">Figure 45 Flow: Allocate DMA Buffers</p>



#### **2.4.6 Make AFU Aware of DMA Buffers**

The process by which locations of shared memory buffers and their sizes
are made known to the AFU is entirely AFU-specific. This example shows
the method used by the Native Loopback AFU. Each buffer I/O virtual
address is cacheline-aligned and programmed into a unique AFU CSR; then
the buffer size in lines is programmed into a length CSR:



```C
#define CSR_SRC_ADDR 0x000A // AFU-specific
#define CSR_DEST_ADDR 0x000B // AFU-specific
#define CSR_NUM_LINES 0x000C // AFU-specific
uint64_t src_iova = 0;
uint64_t dest_iova = 0;
fpgaGetIOAddress(afu_handle, src_wsid, &src_iova);
fpgaGetIOAddress(afu_handle, dest_wsid, &dest_iova);
fpgaWriteMMIO64(afu_handle, 0, CSR_SRC_ADDR, src_iova >> 6);
fpgaWriteMMIO64(afu_handle, 0, CSR_DEST_ADDR, dest_iova >> 6);
fpgaWriteMMIO32(afu_handle, 0, CSR_NUM_LINES, BUF_SIZE / 64);
```



<p align = "center">Figure 46 Flow: Make AFU Aware of DMA Buffers</p>



#### **2.4.7 Initiate an Acceleration Task**

With the shared buffer configuration complete, the AFU can be told to
initiate the acceleration task. This process is AFU-specific. The Native
Loopback AFU starts the acceleration task by writing a value to its
control CSR:



```C
#define CSR_CTRL 0x000D // AFU-specific
fpgaWriteMMIO32(afu_handle, 0, CSR_CTRL, 3);
```



<p align = "center">Figure 47 Initiate an Acceleration Task</p>



#### **2.4.8 Wait for Task Completion**

Once the acceleration task is initiated, the application may poll the
AFU for a completion status. This process is AFU-specific. The AFU may
provide a status CSR for the application to poll; or the AFU may
communicate status to the application by means of a result code written
to a shared buffer.



#### **2.4.9 Free DMA Buffers**

When the acceleration task completes and the AFU is quiesced such that
there are no outstanding memory transactions targeted for the shared
memory, the DMA buffers can be unmapped and freed using
[fpgaReleaseBuffer](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L115)():



```C
fpgaReleaseBuffer(afu_handle, src_wsid);
fpgaReleaseBuffer(afu_handle, dest_wsid);
```



<p align = "center">Figure 48 Flow: Free DMA Buffers</p>



#### **2.4.10 Unmap MMIO Region**

The MMIO regions should also be unmapped using
[fpgaUnmapMMIO](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L200-L201)():

```C
fpgaUnmapMMIO(afu_handle, region);
```
<br>

<p align = "center">Figure 49 Flow: Unmap MMIO Region</p>



#### **2.4.11 Close the AFU**

The AFU handle should be closed via
[fpgaClose](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L88)()
to release its resources:

<br>

```C
fpgaClose(afu_handle);
```

<br>



<br>

#### **2.4.12 Release the Tokens and Properties**

The fpga\_token’s returned by
[fpgaEnumerate](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L101-L103)()
should be destroyed using the
[fpgaDestroyToken](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L133)()
API. The fpga\_properties objects should be destroyed using the
[fpgaDestroyProperties](https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L176)()
API:



```C
fpgaDestroyToken(&afu_token);
fpgaDestroyProperties(&filter);

```


<p align = "center">Figure 51 Flow: Release the Tokens and Properties</p>



### **3.0 OPAE C++ API**

The OPAE C++ API refers to a C++ layer that sits on top of the OPAE C
API, providing object-oriented implementations of the main OPAE C API
abstractions: properties, tokens, handles, dma buffers, etc. Like the
OPAE C API, the [C++ API
headers](https://github.com/OFS/opae-sdk/tree/master/include/opae/cxx/core)
contain Doxygen markup for each of the provided classes.



#### **3.1 libopae-cxx-core**

The implementation files for the C++ API are compiled into
libopae-cxx-core.so. A convenience header,
[core.h](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core.h),
provides a quick means of including each of the C++ API headers. Each of
the types comprising the C++ API is located within the opae::fpga::types
C++ namespace.



##### **3.1.1 Properties**

Class
[properties](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/properties.h#L41-L137)
provides the C++ implementation of the fpga\_properties type and its
associated APIs.

```C++
properties::ptr_t filter = properties::get();
```

<p align = "center">Figure 52 C++ Create New Empty Properties</p>

Class properties provides [member
variables](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/properties.h#L114-L136)
for each fpga\_properties item that can be manipulated with
fpgaPropertiesGet…() and fpgaPropertiesSet…(). For example, to set the
AFU ID in a properties instance and to set that instance’s type to
FPGA\_ACCELERATOR:



```C++
#define MY_AFU_ID “8ad74241-d13b-48eb-b428-7986dcbcab14”
filter->guid.parse(MY_AFU_ID);
filter->type = FPGA_ACCELERATOR;
```



<p align = "center">Figure 53 C++ Properties Set GUID and Type</p>



##### **3.1.2 Tokens**

Class
[token](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/token.h#L39-L77)
provides the C++ implementation of the fpga\_token type and its
associated APIs. Class token also provides the
[enumerate](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/token.h#L48-L54)()
static member function:



```C++
std::vector<token::ptr_t> tokens = token::enumerate({filter});
if (tokens.size() < 1) {
// flag error and return
}
token::ptr_t tok = tokens[0];
```



<p align = "center">Figure 54 C++ Enumeration</p>



##### **3.1.3 Handles**

Class
[handle](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/handle.h#L38-L194)
provides the C++ implementation of the fpga\_handle type and its
associated APIs. The handle class provides member functions for opening
and closing a token, for reading and writing to MMIO space, and for
reconfiguring the FPGA’s Programmable Region.

```C++
handle::ptr_t accel = handle::open(tok, 0);
```

<p align = "center">Figure 55 C++ Opening a Handle</p>



##### **3.1.4 Shared Memory**

The
[shared\_buffer](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/shared_buffer.h#L42-L173)
class provides member functions for allocating and releasing DMA
buffers, for querying buffer attributes, and for reading and writing
buffers.



```C++
#define BUF_SIZE (2 * 1024 * 1024)
shared_buffer::ptr_t input = shared_buffer::allocate(accel, BUF_SIZE);
shared_buffer::ptr_t output = shared_buffer::allocate(accel, BUF_SIZE);
std::fill_n(input->c_type(), BUF_SIZE, 0xaf);
std::fill_n(output->c_type(), BUF_SIZE, 0xbe);
```



<p align = "center">Figure 56 C++ Allocate and Init Buffers</p>

Once DMA buffers have been allocated, their IO addresses are programmed
into AFU-specific CSRs to enable the DMA. Here, the IO address of each
buffer is aligned to the nearest cache line before programming it into
the AFU CSR space. The number of cache lines is then programmed into the
appropriate AFU CSR.



```C++
#define CSR_SRC_ADDR 0x000A // AFU-specific
#define CSR_DEST_ADDR 0x000B // AFU-specific
#define CSR_NUM_LINES 0x000C // AFU-specific
#define LOG2_CL 6
accel->write_csr64(CSR_SRC_ADDR, input->io_address() >> LOG2_CL);
accel->write_csr64(CSR_DEST_ADDR, output->io_address() >> LOG2_CL);
accel->write_csr32(CSR_NUM_LINES, BUF_SIZE / 64);
```



<p align = "center">Figure 57 C++ Make the AFU Aware of DMA Buffers</p>



##### **3.1.5 Events**

The
[event](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/events.h#L37-L108)
class provides member functions for event registration. In order to
register an event, provide the handle::ptr\_t for the desired device,
along with the event type and optional flags.



```C++
int vect = 2;
event::ptr_t evt = event::register_event(accel,
FPGA_EVENT_INTERRUPT,
vect);
int evt_fd = evt.os_object();
```



<p align = "center">Figure 58 C++ Event Registration</p>




##### **3.1.6 Errors**

Class
[error](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/errors.h#L37-L97)
provides a means of querying the device errors given a token::ptr\_t.
The token and integer ID provided to the
[error::get](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/errors.h#L50-L59)()
static member function uniquely identify one of the 64-bit error masks
associated with the token.

```C++
error::ptr_t err = error::get(tok, 0); 
```

<p align = "center">Figure 59 C++ Query Device Errors</p>



##### **3.1.7 SysObject**

Class
[sysobject](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L38-L196)
is the C++ implementation of the OPAE SysObject API. sysobject provides
a means of creating class instances via its two
[sysobject::get](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L52-L86)()
static member functions. A third non-static
[sysobject::get](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L88-L103)()
enables creating a sysobject instance given a parent sysobject instance.
The
[read64](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L124-L137)()
and
[write64](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L139-L152)()
member functions allow reading and writing the sysobject’s value as a
64-bit unsigned integer. The
[bytes](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/sysobject.h#L154-L177)()
member functions allow reading a sysobject’s value as a raw byte stream.



### **4.0 OPAE Python API**

The OPAE Python API is built on top of the OPAE C++ Core API and its object model. Because of this, developing OPAE applications in Python is very similar to developing OPAE applications in C++ which significantly reduces the learning curve required to adapt to the Python API. While the object model remains the same, some static factory functions in the OPAE C++ Core API have been moved to module level methods in the OPAE Python API with the exception of the properties class. The goal of the OPAE Python API is to enable fast prototyping, test automation, infrastructure managment, and an easy to use framework for FPGA resource interactions that don’t rely on software algorithms with a high runtime complexity.

The major benefits of using pybind11 for developing the OPAE Python API include, but are not limited to, the following features of pybind11:

- Uses C++ 11 standard library although it can use C++ 14 or C++17.
- Automatic conversions of shared_ptr types
- Built-in support for numpy and Eigen numerical libraries
- Interoperable with the Python C API

Currently, the only Python package that is part of OPAE is `opae.fpga`. Because `opae.fpga` is built on top of the `opae-cxx-core` API, it does require that the runtime libraries for both `opae-cxx-core` and `opae-c` be installed on the system (as well as any other libraries they depend on). Those libraries can be installed using the `opae-libs` package (from either RPM or DEB format - depending on your Linux distribution). Installation for the Python OPAE bindings are included in the Getting Started Guide for your platform. 

#### **4.1 opae**

The Python API is coded as a
[pybind11](https://pybind11.readthedocs.io/en/stable/) project, which
allows C++ code to directly interface with Python internals. Each C++
API concept is encoded into a Python equivalent. The functionality
exists as a Python extension module, compiled into \_opae.so.



##### **4.1.1 Enumeration**

Enumeration is somewhat simplified as compared to the OPAE C/C++ APIs.
The fpga.enumerate() function accepts keyword arguments for each of the
[property
names](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/properties.h#L115-L136)
that are defined in the C++ API. As an example, to enumerate for an
FPGA\_ACCELERATOR by its GUID:



```python
from opae import fpga
MY_ACCEL = “d573b29e-176f-4cb7-b810-efbf7be34cc9”
tokens = fpga.enumerate(type=fpga.ACCELERATOR, guid=MY_ACCEL)
assert tokens, “No accelerator matches {}”.format(MY_ACCEL)
```



<p align = "center">Figure 60 Python Enumeration</p>

The return value from the fpga.enumerate() function is a list of all the
token objects matching the search criteria.



##### **4.1.2 Properties**

Querying properties for a token or handle is also a bit different in the
Python API. In order to query properties for one of these objects, pass
the object to the fpga.properties() constructor. The return value is a
properties object with each of the [property
names](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/properties.h#L115-L136)
defined as instance attributes.



```python
prop = fpga.properties(tokens[0])
print(f'0x{prop.vendor_id:04x} 0x{prop.device_id:04x}')
```



<p align = "center">Figure 61 Python Get Token Properties</p>

Properties objects may also be created by invoking the fpga.properties()
constructor, passing the same keyword arguments as those to
fpga.enumerate(). Properties objects created in this way are also useful
for enumeration purposes:



```python
props = fpga.properties(type=fpga.ACCELERATOR)
tokens = fpga.enumerate([props])
```



<p align = "center">Figure 62 Python Properties Constructor</p>



##### **4.1.3 Tokens**

Tokens overload both the \_\_getitem\_\_ and \_\_getattr\_\_ methods to
enable the SysObject API. Both of the following are valid forms of
accessing the ‘errors/first\_error’ sysfs attribute, given a token
object:



```python
tok = tokens[0]
ferr = tok['errors/first_error']
print(f'first error: 0x{ferr.read64():0x}')
print('0x{:0x}'.format(tok.errors.first_error.read64()))
```



<p align = "center">Figure 63 Python Tokens and SysObject API</p>

Tokens also implement a find() method, which accepts a glob expression
in order to search sysfs. The following example finds the “id” sysfs
entry in the given token’s sysfs tree.



```python
my_id = tok.find(‘i?’)
print(f'{my_id.read64()}')
```



<p align = "center">Figure 64 Python Token Find</p>



##### **4.1.4 Handles**

Tokens are converted to handles by way of the fpga.open() function. The
flags (second) parameter to fpga.open() may be zero or
fpga.OPEN\_SHARED.



```python
with fpga.open(tok, fpga.OPEN_SHARED) as handle:
    use_the_handle(handle)
```



<p align = "center">Figure 65 Python Open Handle</p>

Like token objects, handle objects overload \_\_getitem\_\_ and
\_\_getattr\_\_ methods to enable the SysObject API. handle also
provides a find() method similar to token’s find().



```python
err = handle['errors/errors']
print(f'errors: 0x{err.read64():0x}')
print('first error: 0x{:0x}'.format(
handle.errors.first_error.read64()))
my_id = handle.find('i?')
print(f'{my_id.read64()}')
```



<p align = "center">Figure 66 Python Handles and SysObject API</p>

Partial reconfiguration is provided by class handle’s reconfigure()
method. The first parameter, slot, will be zero in most designs. The
second parameter is an opened file descriptor to the file containing the
GBS image. The third parameter, flags, defaults to zero.



```python
with open(‘my.gbs’, ‘rb’) as fd:
    handle.reconfigure(0, fd)
```


<p align = "center">Figure 67 Python Partial Reconfiguration</p>

Device reset is accomplished by means of handle’s reset() method, which
takes no parameters.

Finally for handles, CSR space reads are accomplished via read\_csr32()
and read\_csr64(). Both methods accept the register offset as the first
parameter and an optional csr\_space index, which defaults to zero, as
the second parameter. CSR space writes are accomplished via
write\_csr32() and write\_csr64(). Both methods accept the register
offset as the first parameter, the value to write as the second, and an
optional csr\_space index, which defaults to zero, as the third.



```python
print(’0x{:0x}’.format(handle.read_csr32(0x000a)))
print(‘0x{:0x}’.format(handle.read_csr64(0x000c)))
handle.write_csr32(0x000b, 0xdecafbad, 2)
handle.write_csr64(0x000e, 0xc0cac01adecafbad, 2)
```



<p align = "center">Figure 68 Python Read/Write CSR</p>



##### **4.1.5 Shared Memory**

The fpga.allocate\_shared\_buffer() function provides access to the OPAE
memory allocator. The allocation sizes and required huge page
configurations are the same as those noted in 2.1.5 MMIO and Shared
Memory.

The fpga.allocate\_shared\_buffer() function returns an object instance
of type shared\_buffer. The shared\_buffer class implements methods
size(), wsid(), and io\_address(), which return the buffer size in
bytes, the unique workspace ID, and the IO address respectively:



```python
buf = fpga.allocate_shared_buffer(handle, 4096)
print(f’size: {buf.size()}’)
print(f’wsid: 0x{buf.wsid():0x}’)
print(f’io_address: 0x{buf.io_address():0x}’)
```



<p align = "center">Figure 69 Python Allocate Shared Memory</p>

The shared\_buffer class implements a fill() method which takes an
integer parameter which is applied to each byte of the buffer (similar
to C standard library’s memset()). The compare() method compares the
contents of the first size bytes of one buffer to another. The value
returned from compare() is the same as the C standard library’s
memcmp(). The copy() method copies the first size bytes of the calling
buffer into the argument buffer.



```python
b0 = fpga.allocate_shared_buffer(handle, 4096)
b1 = fpga.allocate_shared_buffer(handle, 4096)
b0.fill(0xa5)
b1.fill(0xa5)
print(f'compare: {b0.compare(b1, 4096)}')
b1.fill(0xa0)
b0.copy(b1, 4096)
print(f'compare: {b0.compare(b1, 4096)}')
```



<p align = "center">Figure 70 Python Buffer Fill, Copy, Compare</p>

shared\_buffer’s read32() and read64() methods read a 32- or 64-bit
value from the given offset. The write32() and write64() methods write a
32- or 64-bit value to the given offset.



```python
print(f'value at 0: 0x{b0.read32(0):0x}')
print(f'value at 4: 0x{b0.read64(4):0x}')
b0.write32(0xabadbeef, 0)
b0.write64(0xdecafbadabadbeef, 4)
print(f'value at 0: 0x{b0.read32(0):0x}')
print(f'value at 4: 0x{b0.read64(4):0x}')
```



<p align = "center">Figure 71 Python Buffer Read and Write</p>

The shared\_buffer class provides three polling methods: poll(),
poll32(), and poll64(). Each method takes an offset as its first
parameter. The second parameter is a value and the third is a mask. The
value and mask parameters are 8 bits wide for poll(), 32 bits wide for
poll32(), and 64 bits wide for poll64(). The fourth and last parameter
is a timeout value which defaults to 1000 microseconds.

Each polling method reads the n-bit wide item at offset and applies
(logical AND) the mask to that value. The masked value created in the
previous step is then compared to the second parameter, value. If the
two values are equal, then the method returns true immediately.
Otherwise, the method continues to loop, attempting the same comparison
over and over **without sleeping**. Finally, if the elapsed time from
the beginning of the call to the current time is greater than or equal
to the timeout value, then the method times out and returns false.



```python
if b0.poll32(0, 0xbebebebe, 0xffffffff, 250):
    print(‘Got it!’)
```



<p align = "center">Figure 72 Python Buffer Poll</p>

The shared\_buffer split() method allows creating two or more buffer
objects from one larger buffer object. The return value is a list of
shared\_buffer instances whose sizes match the arguments given to
split().



```python
b1, b2 = b1.split(2048, 2048)
print(f'b1 io_address: 0x{b1.io_address():0x}')
print(f'b2 io_address: 0x{b2.io_address():0x}')
```



<p align = "center">Figure 73 Python Splitting Buffer</p>

Finally, the shared\_buffer class implements the Python buffer protocol
to support
[memoryview](https://docs.python.org/dev/library/stdtypes.html#memoryviewhttps://docs.python.org/dev/library/stdtypes.html)
objects. The Python buffer protocol allows access to an object’s
underlying memory without copying that memory. As a brief example:



```python
mv = memoryview(b1)
assert mv
assert mv[0] == 0xbe
b1[15] = int(65536)
assert struct.unpack('<L', bytearray(b1[15:19]))[0] == 65536
```



<p align = "center">Figure 74 Python memoryview</p>



##### **4.1.6 Events**

Given a handle and an event type, the fpga.register\_event() function
returns an object of type event. The event class implements one method,
os\_object(), which returns the underlying file descriptor that can be
used to poll for the event:



```python
import select
evt = fpga.register_event(handle, fpga.EVENT_ERROR)
os_object = evt.os_object()
received_event = False
epoll = select.epoll()
epoll.register(os_object, select.EPOLLIN)
for fileno, ev in epoll.poll(1):
    if fileno == os_object:
        received_event = True
        print(f'received: {received_event}')
```



<p align = "center">Figure 75 Python Events</p>

In addition to fpga.EVENT\_ERROR, fpga.EVENT\_INTERRUPT, and
fpga.EVENT\_POWER\_THERMAL are also supported.



##### **4.1.7 Errors**

Given a token, the fpga.errors() function returns a list of objects of
type error. Each error instance represents a 64-bit mask of error
values. The error bit masks are platform-dependent. Each error instance
has two attributes: name and can\_clear and one method: read\_value()
which returns the 64-bit error mask.



```python
for e in fpga.errors(tok):
    print(f’name: "{e.name}"’)
    print(f’can_clear: {e.can_clear}’)
    print(f’value: {e.read_value()}’)
```



<p align = "center">Figure 76 Python Get Errors</p>



##### **4.1.8 SysObject**

The Python API’s SysObject implementation is introduced in 4.1.3 Tokens
and 4.1.4 Handles. When the index operator (\_\_getitem\_\_) or
attribute reference (\_\_getattr\_\_) is used and the referenced string
or attribute name corresponds to a sysfs entry in the sysfs path of
either a token or a handle, then an object of type sysobject is
returned.

The size() method returns the length of the sysfs entry in bytes. Note
that a typical sysfs entry is terminated with a ‘\\n’ followed by the
‘\\0’ NULL terminator. The bytes() method returns the sysfs entry’s
value as a string.



```python
afu_id = tok['afu_id']
assert afu_id
print(f'size: {afu_id.size()} bytes: {afu_id.bytes().rstrip()}')
```



<p align = "center">Figure 77 Python sysobject as Bytes</p>

The sysobject read64() and write64() methods provide a means to read and
write a sysfs entry’s value as an unsigned 64-bit integer. The sysobject
class itself also implements the \_\_getitem\_\_ and \_\_getattr\_\_
methods so that a sysobject of type FPGA\_OBJECT\_CONTAINER can retrieve
sysobject instances for child sysfs entries.



```python
errs = tok['errors']
first = errs['first_error']
assert first
print(f'first 0x{first.read64():0x}')
```

### **4.1.8 Python Example Application**

The following example is an implementation of the sample, hello_fpga.c, which is designed to configure the NLB0 diagnostic accelerator for a simple loopback.

```python
import time
from opae import fpga

NLB0 = "d8424dc4-a4a3-c413-f89e-433683f9040b"
CTL = 0x138
CFG = 0x140
NUM_LINES = 0x130
SRC_ADDR = 0x0120
DST_ADDR = 0x0128
DSM_ADDR = 0x0110
DSM_STATUS = 0x40

def cl_align(addr):
    return addr >> 6

tokens = fpga.enumerate(type=fpga.ACCELERATOR, guid=NLB0)
assert tokens, "Could not enumerate accelerator: {}".format(NlB0)

with fpga.open(tokens[0], fpga.OPEN_SHARED) as handle:
    src = fpga.allocate_shared_buffer(handle, 4096)
    dst = fpga.allocate_shared_buffer(handle, 4096)
    dsm = fpga.allocate_shared_buffer(handle, 4096)
    handle.write_csr32(CTL, 0)
    handle.write_csr32(CTL, 1)
    handle.write_csr64(DSM_ADDR, dsm.io_address())
    handle.write_csr64(SRC_ADDR, cl_align(src.io_address())) # cacheline-aligned
    handle.write_csr64(DST_ADDR, cl_align(dst.io_address())) # cacheline-aligned
    handle.write_csr32(CFG, 0x42000)
    handle.write_csr32(NUM_LINES, 4096/64)
    handle.write_csr32(CTL, 3)
    while dsm[DSM_STATUS] & 0x1 == 0:
        time.sleep(0.001)
    handle.write_csr32(CTL, 7)
```

This example shows how one might reprogram (Partial Reconfiguration) an accelerator on a given bus, 0x5e, using a bitstream file, m0.gbs.

```python
from opae import fpga

BUS = 0x5e
GBS = 'm0.gbs'
tokens = fpga.enumerate(type=fpga.DEVICE, bus=BUS)
assert tokens, "Could not enumerate device on bus: {}".format(BUS)
with open(GBS, 'rb') as fd, fpga.open(tokens[0]) as device:
    device.reconfigure(0, fd)
```



<p align = "center">Figure 78 Python sysobject Container</p>

## **5.0 Management Interfaces - opae.admin**

While the OPAE SDK C, C++, and Python APIs focus on presenting the AFU and all its related functionality to the end user, there is also a need for a maintenance functionality to aid in configuring the platform and performing secure firmware updates for the FPGA device and its components.  opae.admin is a Python framework which provides abstractions for performing these types of maintenance tasks on FPGA devices.  opae.admin provides Python classes which model the FPGA and the sysfs interfaces provided by the DFL drivers.



### **5.1 sysfs** 
opae.admin’s sysfs module provides abstractions for interacting with sysfs nodes, which comprise the base entity abstraction of opae.admin.



####	**5.1.1 sysfs_node**
A sysfs_node is an object that tracks a unique path within a sysfs directory tree.  sysfs_node provides methods for finding and constructing other sysfs_node objects, based on the root path of the parent sysfs_node object.  sysfs_node also provides a mechanism to read and write sysfs file contents.  sysfs_node serves as the base class for many of the sysfs module’s other classes.



####	**5.1.2 pci_node**
A pci_node is a sysfs_node that is rooted at /sys/bus/pci/devices.  Each pci_node has a unique PCIe address corresponding to the PCIe device it represents.  Methods for finding the pci_node’s children, for determining the PCIe device tree rooted at the node, for manipulating the node’s PCIe address, for determining the vendor and device ID’s, and for removing, unbinding, and rescanning the device are provided.



####	**5.1.3 sysfs_driver**
A sysfs_driver is a sysfs_node that provides a method for unbinding a sysfs_device object.



####	**5.1.4 sysfs_device**
A sysfs_device is a sysfs_node that is located under /sys/class or /sys/bus.  sysfs_device provides the basis for opae.admin’s FPGA enumeration capability.



####	**5.1.5 pcie_device**
A pcie_device is a sysfs_device that is rooted at /sys/bus/pci/devices.



### **5.2 fpga**
opae.admin’s fpga module provides classes which abstract an FPGA and its components.



####	**5.2.1 region**
A region is a sysfs_node that has an associated Linux character device, rooted at /dev.  Methods for opening the region’s character device file and for interacting with the character device via its IOCTL interface are provided.



####	**5.2.2 fme**
An fme is a region that represents an FPGA device’s FME component.  An fme provides accessors for the PR interface ID, the various bus paths that may exist under an FME, and the BMC firmware revision information.



####	**5.2.3 port**
A port is a region that represents an FPGA device’s Port component.  A port provides an accessor for the Port AFU ID.



####	**5.2.4 fpga_base**
An fpga_base is a sysfs_device that provides accessors for the FPGA device’s FME, for the FPGA device’s Port, and for the secure update sysfs controls.  fpga_base provides routines for enabling and disabling AER and for performing device RSU.



####	**5.2.5 fpga**
An fpga (derived from fpga_base) is the basis for representing the FPGA device in opae.admin.  Utilities such as fpgasupdate rely on fpga’s enum classmethod to enumerate all of the FPGA devices in the system.  In order for a device to enumerate via this mechanism, it must be bound to the dfl-pci driver at the time of enumeration.



###	**5.3 opae.admin Utilities**
Several utilities are written on top of opae.admin’s class abstractions.  The following sections highlight some of the most commonly-used utilities.



####	**5.3.1 fpgasupdate**
fpgasupdate, or FPGA Secure Update, is used to apply firmware updates to the components of the FPGA.  As the name implies, these updates target a secure FPGA device, one that has the ability to implement a secure root of trust.
The command-line interface to fpgasupdate was designed to be as simple as possible for the end user.  The command simply takes a path to the firmware update file to be applied and the PCIe address of the targeted FPGA device.

```bash
# fpgasupdate update-file.bin 0000:b2:00.0
```

<p align = "center">Figure 79 fpgasupdate Interface</p>

fpgasupdate can apply a variety of firmware image updates.
| Image| Description|
| -----| -----|
|Programmable Region Image|	.gbs or Green BitStream|
|SR Root Key Hash|	Static Region RKH|
|PR Root Key Hash|	Programmable Region RKH|
|FPGA Firmware Image|	Static Region Device Firmware|
|PR Authentication Certificate|	Programmable Region Auth Cert|
|BMC Firmware Image|	Board Management Controller Firmware|
|SR Thermal Image|	Static Region Thermal Sensor Thresholds|
|PR Thermal Image|	Programmable Region Thermal Sensor Thresholds|
|CSK Cancelation|	Code Signing Key Cancelation Request|
|SDM Image|	Secure Device Manager Firmware|


<p align = "center">Table 10 fpgasupdate Image Types</p>




####	**5.3.2 pci_device**
pci_device is a utility that provides a convenient interface to some of the Linux Kernel’s standard PCIe device capabilities.



#####	**5.3.2.1 pci_device aer subcommand**
The aer dump subcommand displays the Correctable, Fatal, and NonFatal device errors.

```bash
# pci_device 0000:b2:00.0 aer dump
```

<p align = "center">Figure 80 pci_device aer dump</p>

The aer mask subcommand displays, masks, or unmasks errors using the syntax of the setpci command.

```bash
# pci_device 0000:b2:00.0 aer mask show
0x00010000 0x000031c1
# pci_device 0000:b2:00.0 aer mask all
# pci_device 0000:b2:00.0 aer mask off
# pci_device 0000:b2:00.0 aer mask 0x01010101 0x10101010
```

<p align = "center">Figure 81 pci_device aer mask</p>

The aer clear subcommand clears the current errors.

```bash
# pci_device 0000:b2:00.0 aer clear
aer clear errors: 00000000
```
<p align = "center">Figure 82 pci_device aer clear</p>



#####	**5.3.2.2 pci_device unbind subcommand**

The unbind subcommand unbinds the target device from the currently-bound device driver.

```bash
# pci_device 0000:b2:00.0 unbind
```
<p align = "center">Figure 83 pci_device unbind</p>

In order to re-bind the device to a driver, eg dfl-pci, use the following commands:

```bash
# cd /sys/bus/pci/drivers/dfl-pci
# echo 0000:b2:00.0 > bind
```

<p align = "center">Figure 84 Re-binding a Driver</p>



#####	**5.3.2.3 pci_device rescan subcommand**
The rescan subcommand triggers a PCIe bus rescan of all PCIe devices.

```bash
# pci_device 0000:b2:00.0 rescan
```

<p align = "center">Figure 85 pci_device rescan</p>




#####	**5.3.2.4 pci_device remove subcommand**
The remove subcommand removes the target device from Linux kernel management.

```bash
# pci_device 0000:b2:00.0 remove
```

<p align = "center">Figure 86 pci_device remove</p>

Note: a reboot may be required in order to re-establish the Linux kernel management for the device.



#####	**5.3.2.5 pci_device topology subcommand**

The topology subcommand shows a tab-delimited depiction of the target device as it exists in the PCIe device tree in the Linux kernel.

```bash
# pci_device 0000:b2:00.0 topology
[pci_address(0000:3a:00.0), pci_id(0x8086, 0x2030)] (pcieport)
    [pci_address(0000:3b:00.0), pci_id(0x10b5, 0x8747)] (pcieport)
        [pci_address(0000:3c:09.0), pci_id(0x10b5, 0x8747)] (pcieport)
            [pci_address(0000:b2:00.0), pci_id(0x8086, 0x0b30)] (dfl-pci)
        [pci_address(0000:3c:11.0), pci_id(0x10b5, 0x8747)] (pcieport)
            [pci_address(0000:43:00.0), pci_id(0x8086, 0x0b32)] (no driver)
        [pci_address(0000:3c:08.0), pci_id(0x10b5, 0x8747)] (pcieport)
            [pci_address(0000:3d:00.1), pci_id(0x8086, 0x0d58)] (i40e)
            [pci_address(0000:3d:00.0), pci_id(0x8086, 0x0d58)] (i40e)
        [pci_address(0000:3c:10.0), pci_id(0x10b5, 0x8747)] (pcieport)
            [pci_address(0000:41:00.0), pci_id(0x8086, 0x0d58)] (i40e)
            [pci_address(0000:41:00.1), pci_id(0x8086, 0x0d58)] (i40e)
```

<p align = "center">Figure 87 pci_device topology</p>

The green output indicates the target device.  The other endpoint devices are shown in blue.



#####	**5.3.2.6 pci_device vf subcommand**

The vf subcommand allows setting the value of the sriov_numvfs sysfs node of the target device.  This is useful in scenarios where device functionality is presented in the form of one or more PCIe Virtual Functions.

```bash
# pci_device 0000:b2:00.0 vf 3
# pci_device 0000:b2:00.0 vf 0

```
<p align = "center">Figure 88 pci_device vf</p>



####	**5.3.3 rsu**
rsu is a utility that performs Remote System Update.  rsu is used subsequent to programming a firmware update or other supported file type with fpgasupdate, in order to reset the targeted FPGA entity so that a newly-loaded firmware image becomes active.



#####	**5.3.3.1 rsu bmc subcommand**
The bmc subcommand causes a Board Management Controller reset.  This command is used to apply a previous fpgasupdate of a BMC firmware image.  The --page argument selects the desired boot image.  Valid values for --page are ‘user’ and ‘factory’.


```bash
# rsu bmc --page user 0000:b2:00.0
# rsu bmc --page factory 0000:b2:00.0
```
<p align = "center">Figure 89 rsu bmc</p>



#####	**5.3.3.2 rsu retimer subcommand**
The retimer subcommand causes a Parkvale reset (specific to Vista Creek).  This command is used to apply a previous fpgasupdate of a BMC firmware image (the Parkvale firmware is contained within the BMC firmware image).  The retimer subcommand causes only the Parkvale to reset.

```bash
# rsu retimer 0000:b2:00.0
```

<p align = "center">Figure 90 rsu retimer</p>




#####	**5.3.3.3 rsu fpga subcommand**
The fpga subcommand causes a reconfiguration of the FPGA Static Region.  This command is used to apply a previous fpgasupdate of the Static Region image.  The --page argument selects the desired boot image.  Valid values for --page are ‘user1’, ‘user2’, and ‘factory’.


```bash
# rsu fpga --page user1 0000:b2:00.0
# rsu fpga --page user2 0000:b2:00.0
# rsu fpga --page factory 0000:b2:00.0
```

<p align = "center">Figure 91 rsu fpga</p>



#####	**5.3.3.4 rsu sdm subcommand**
The sdm subcommand causes a reset of the Secure Device Manager.  This command is used to apply a previous fpgasupdate of the SDM image.

```bash
# rsu sdm 0000:b2:00.0
```

<p align = "center">Figure 92 rsu sdm</p>



#####	**5.3.3.5 rsu fpgadefault subcommand**
The fpgadefault subcommand can be used to display the default FPGA boot sequence; and it can be used to select the image to boot on the next reset of the FPGA.
When given without additional parameters, the fpgadefault subcommand displays the default FPGA boot sequence:


```bash
# rsu fpgadefault 0000:b2:00.0
```

<p align = "center">Figure 93 rsu Displaying FPGA Boot Sequence</p>

The parameters to the fpgadefault subcommand are --page and --fallback.  The --page parameter accepts ‘user1’, ‘user2’, or ‘factory’, specifying the desired page to boot the FPGA from on the next reset.  Note that this subcommand does not actually cause the reset to occur.  Please refer to rsu fpga subcommand for an example of resetting the FPGA using the rsu command.


```bash
# rsu fpgadefault --page user1 0000:b2:00.0
# rsu fpgadefault --page user2 0000:b2:00.0
# rsu fpgadefault --page factory 0000:b2:00.0
```

<p align = "center">Figure 94 rsu Select FPGA Boot Image</p>

The --fallback parameter accepts a comma-separated list of the keywords ‘user1’, ‘user2’, and ‘factory’.  These keywords, in conjunction with the --page value are used to determine a fallback boot sequence for the FPGA.
The fallback boot sequence is used to determine which FPGA image to load in the case of a boot failure.  For example, given the following command, the FPGA would attempt to boot in the order ‘factory’, ‘user1’, ‘user2’.  That is to say, if the ‘factory’ image failed to boot, then the ‘user1’ image would be tried.  Failing to boot ‘user1’, the ‘user2’ image would be tried.


```bash
# rsu fpgadefault --page factory --fallback user1,user2 0000:b2:00.0
```

<p align = "center">Figure 95 rsu Select FPGA Boot Image and Fallback</p>




## **6.0 Sample Applications**



### **6.1 afu-test Framework**

afu-test refers to a test-writing framework that exists as a set of C++
classes written on top of the OPAE C++ bindings. The first class,
[afu](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L151-L341),
serves as the base class for the test application abstraction. Class
[afu](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L151-L341)
provides integration with [CLI11](https://github.com/CLIUtils/CLI11), a
C++ ’11 command-line parsing framework, and with
[spdlog](https://github.com/gabime/spdlog), a C++ logging library. The
second class,
[command](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L113-L132)
represents a unique test sequence that is called by the afu object.
Instances of the
[command](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L113-L132)
class implement the test-specific workload.



```C++
class afu {
public:
afu(const char *name,
const char *afu_id = nullptr,
const char *log_level = nullptr);
int open_handle(const char *afu_id);
int main(int argc, char *argv[]);
virtual int run(CLI::App *app, command::ptr_t test);
template<class T>
CLI::App *register_command();
};
```



<p align = "center">Figure 96 C++ class afu</p>

The afu class constructor initializes the CLI11 command parser with some
general, application-wide parameters.

| Subcommand| Description |
| ----------------- | ------------------------------------ |
| \-g,--guid        | Accelerator AFU ID.                  |
| \-p,--pci-address | Address of the accelerator device.   |
| \-l,--log-level   | Requested spdlog output level.       |
| \-s,--shared      | Open the AFU in shared mode?         |
| \-t,--timeout     | Application timeout in milliseconds. |

<p align = "center">Figure 97 class afu Application Parameters</p>

The register\_command() member function adds a test
[command](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L113-L132)
instance to the afu object. Each test command that an afu object is
capable of executing is registered during the test’s startup code. For
instance, here is the
[hssi](https://github.com/OFS/opae-sdk/blob/master/samples/hssi/hssi.cpp#L51-L54)
application’s use of register\_command():



```C++
hssi_afu app;
int main(int argc, char *argv[])
{
app.register_command<hssi_10g_cmd>();
app.register_command<hssi_100g_cmd>();
app.register_command<hssi_pkt_filt_10g_cmd>();
app.register_command<hssi_pkt_filt_100g_cmd>();
…
app.main(argc, argv);
}

```


<p align = "center">Figure 98 hssi's app.register_command()</p>

Next, the afu instance’s main() member function is called. main()
initializes the spdlog instance, searches its database of registered
commands to find the command matching the test requested from the
command prompt, uses the open\_handle() member function to enumerate for
the requested AFU ID, and calls its run() member function, passing the
CLI::App and the test command variables. The run() member function
initializes a test timeout mechanism, then calls the command parameter’s
run() to invoke the test-specific logic.

With all the boiler-plate of application startup, configuration, and
running handled by the afu class, the test-specific
[command](https://github.com/OFS/opae-sdk/blob/master/libraries/afu-test/afu_test.h#L113-L132)
class is left to implement only a minimum number of member functions:



```C++
class command {
public:
virtual const char *name() const = 0;
virtual const char *description() const = 0;
virtual int run(afu *afu, CLI::App *app) = 0;
virtual void add_options(CLI::App *app) { }
virtual const char *afu_id() const { return nullptr; }
};
```



<p align = "center">Figure 99 class command</p>

The name() member function gives the unique command name. Some examples
of names from the hssi app are hssi\_10g, hssi\_100g, pkt\_filt\_10g,
and pkt\_filt\_100g. The description() member function gives a brief
description that is included in the command-specific help output.
add\_options() adds command-specific command-line options. afu\_id()
gives the AFU ID for the command, in string form. Finally, run()
implements the command-specific test functionality.




### **6.2 afu-test Based Samples**



#### **6.2.1 dummy\_afu**

The dummy\_afu application is a afu-test based application that
implements three commands: mmio, ddr, and lpbk.


| Target|Description |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| \# dummy\_afu [mmio](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/mmio.h#L131-L152) | Targets special scratchpad area implemented by the AFU. |
| \# dummy\_afu [ddr](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/ddr.h#L60-L103)    | Execute dummy\_afu-specific DDR test.                   |
| \# dummy\_afu [lpbk](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/lpbk.h#L50-L65)   | Execute a simple loopback test.                         |



#### **6.2.2 host\_exerciser**

[host\_exerciser](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/host_exerciser/host_exerciser.md)
markdown document.



#### **6.2.3 hssi**

[hssi](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/hssi/hssi.md)
markdown document.



##  **7.0 Other Utilities**



### **7.1 opae.io**

[opae.io](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/opae.io/opae.io.md)
markdown document.



### **7.2 bitstreaminfo**

The bitstreaminfo command prints diagnostic information about firmware
image files that have been passed through the PACSign utility. PACSign
prepends secure block 0 and secure block 1 data headers to the images
that it processes. These headers contain signature hashes and other
metadata that are consumed by the BMC firmware during a secure update.

To run bitstreaminfo, pass the path to the desired firmware image file:

```bash
# bitstreaminfo my_file.bin 
```

<p align = "center">Figure 100 Running bitstreaminfo</p>



### **7.3 fpgareg**

The fpgareg command prints the register spaces for the following fpga
device components:

| Command| Description|
| ---------------------------- | ----------------------------------------- |
| \# fpgareg 0000:b1:00.0 pcie | Walks and prints the DFL for the device.  |
| \# fpgareg 0000:b1:00.0 bmc  | Prints the BMC registers for the device.  |
| \# fpgareg 0000:b1:00.0 hssi | Prints the HSSI registers for the device. |
| \# fpgareg 0000:b1:00.0 acc  | Prints the AFU register spaces.           |

<p align = "center">Figure 101 fpgareg Commands</p>

Note that fpgareg is only available as of Arrow Creek ADP and forward.
It will not work with prior platforms, eg N3000.



### **7.4 opaevfio**

[opaevfio](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/opaevfio/opaevfio.md)
markdown document.




##  **8.0 OPAE Build Configurations**

Refer to the software installation guides on this website for detailed instructions and building and installing both the OPAE SDK and Linux DFL driver set for any given release. The following section has been included to provide more information on the build targets for the DFL drivers.


### **8.1 CMake Options**


<table>
<thead>
<tr class="header">
<th>Option</th>
<th>Description</th>
<th>Values</th>
<th>Default</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>-DCMAKE_BUILD_TYPE</td>
<td>Configure debugging info</td>
<td><p>Debug</p>
<p>Release</p>
<p>Coverage</p>
<p>RelWithDebInfo</p></td>
<td>RelWithDebInfo</td>
</tr>
<tr class="even">
<td>-DCMAKE_INSTALL_PREFIX</td>
<td>Root install path</td>
<td><varies></td>
<td>/usr/local</td>
</tr>
<tr class="odd">
<td>-DOPAE_BUILD_SPHINX_DOC</td>
<td>Enable/Disable docs</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="even">
<td>-DOPAE_BUILD_TESTS</td>
<td>Enable/Disable unit tests</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="odd">
<td>-DOPAE_ENABLE_MOCK</td>
<td>Enable/Disable mock driver for unit tests</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="even">
<td>-DOPAE_INSTALL_RPATH</td>
<td>Enable/Disable rpath for install</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="odd">
<td>-DOPAE_VERSION_LOCAL</td>
<td>Local version string</td>
<td><varies></td>
<td><none></td>
</tr>
<tr class="even">
<td>-DOPAE_PRESERVE_REPOS</td>
<td>Preserve local changes to external repos?</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="odd">
<td>-D OPAE_BUILD_LIBOPAE_CXX</td>
<td>Enable C++ bindings</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_WITH_PYBIND11</td>
<td>Enable pybind11</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-D OPAE_BUILD_PYTHON_DIST</td>
<td>Enable Python bindings</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="even">
<td>-DOPAE_BUILD_LIBOPAEVFIO</td>
<td>Build libopaevfio.so</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-D OPAE_BUILD_PLUGIN_VFIO</td>
<td>Build libopae-v.so</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_BUILD_LIBOPAEUIO</td>
<td>Build libopaeuio.so</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-DOPAE_BUILD_LIBOFS</td>
<td>Build OFS Copy Engine</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_BUILD_SAMPLES</td>
<td>Build Samples</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-DOPAE_BUILD_LEGACY</td>
<td>Build legacy repo</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
<tr class="even">
<td>-DOPAE_LEGACY_TAG</td>
<td>Specify legacy build tag</td>
<td><varies></td>
<td>master</td>
</tr>
<tr class="odd">
<td>-DOPAE_WITH_CLI11</td>
<td>Enable apps which use CLI11</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_WITH_SPDLOG</td>
<td>Enable apps which use spdlog</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-DOPAE_WITH_LIBEDIT</td>
<td>Enable apps which use libedit</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_WITH_HWLOC</td>
<td>Enable apps which use hwloc</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="odd">
<td>-DOPAE_WITH_TBB</td>
<td>Enable apps which use Thread Building Blocks</td>
<td>ON/OFF</td>
<td>ON</td>
</tr>
<tr class="even">
<td>-DOPAE_MINIMAL_BUILD</td>
<td>Enable/Disable minimal build. When set to ON, disable CLI11, spdlog, libedit, hwloc, tbb</td>
<td>ON/OFF</td>
<td>OFF</td>
</tr>
</tbody>
</table>


<p align = "center">Table 12 CMake Options</p>



### **8.2 Building OPAE for Debug:**

```bash
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
```



### **8.3 Creating OPAE Packages**

To ease the RPM creation process, the OPAE SDK provides a simple RPM
creation script. The parameter to the RPM create script for either Fedora or RHEL is `unrestricted` 
For rhel, the build flag -DOPAE\_MINIMAL\_BUILD is set to ON, omitting the binaries which
have dependencies on external components that RHEL does not include in
its base repositories.

In order to create RPMs for Fedora, run the create script on a system
loaded with all the Fedora build prerequisites. If prerequisites are
missing, the create script will complain until they are resolved.

In order to create RPMs for RHEL, run the create script on a system
loaded with all the RHEL build prerequisites. If prerequisites are
missing, the create script will complain until they are resolved.



```bash
$ cd opae-sdk
$ ./packaging/opae/rpm/create unrestriected
```

### **8.4 Updating the RPM Version Information**

The RPMs will be versioned according to the information found in the
file
[packaging/opae/version](https://github.com/OFS/opae-sdk/blob/master/packaging/opae/version#L27-L28).
If you edit this file to update the version information, then re-run the create script to create the RPMs.


## **9.0 Debugging OPAE**



### **9.1	Enabling Debug Logging**

The OPAE SDK has a built-in debug logging facility.  To enable it, set the cmake flag `-DCMAKE_BUILD_TYPE=Debug` and then use the following environment variables:
| Variable| Description|
| ----- | ----- |
|LIBOPAE_LOG=1|	Enable debug logging output.  When not set, only critical error messages are displayed.|
|LIBOPAE_LOGFILE=file.log|	Capture debug log output to file.log.  When not set, the logging appears on stdout and stderr.  The file must appear in a relative path or it can be rooted at /tmp.|

<p align = "center"> Table 13 Logging Environment Variables</p>



### **9.2 GDB**
To enable gdb-based debugging, the cmake configuration step must specify a value for -DCMAKE_BUILD_TYPE of either Debug or RelWithDebInfo so that debug symbols are included in the output binaries.
The OPAE SDK makes use of dynamically-loaded library modules.  When debugging with gdb, the best practice is to remove all OPAE SDK libraries from the system installation paths to ensure that library modules are only loaded from the local build tree:

```bash
$ cd opae-sdk/build
$ LD_LIBRARY_PATH=$PWD/lib gdb --args <some_opae_executable> <args>
```

<p align = "center">Figure 103 Debugging with GDB</p>

## **10.0 Adding New Device Support**

As of OPAE 2.2.0 the SDK has transitioned to a single configuration file model.  The libraries, plugins, and applications obtain their runtime configuration during startup by examining a single JSON configuration file.  In doing so, the original configuration file formats for libopae-c and fpgad have been deprecated in favor of the respective sections in the new configuration file. 

###	**10.1 Configuration File Search Order**
By default the OPAE SDK will install its configuration file to /etc/opae/opae.cfg. 


```C
/etc/opae/opae.cfg 
```


<p align = "center">Figure 104 Default Configuration File</p>


The SDK searches for the configuration file during startup by employing the following search algorithm: 

First, the environment variable LIBOPAE_CFGFILE is examined.  If it is set to a path that represents a valid path to a configuration file, then that configuration file path is used, and the search is complete. 

Next, the HOME environment variable is examined.  If its value is valid, then it is prepended to the following set of relative paths.  If HOME is not set, then the search continues with the value of the current user’s home path as determined by getpwuid().  The home path, if any, determined by getpwuid() is prepended to the following set of relative paths.  Searching completes successfully if any of these home-relative search paths is valid. 

```C
/.local/opae.cfg 

/.local/opae/opae.cfg 

/.config/opae/opae.cfg 
```

<p align = "center">Figure 105 HOME Relative Search Paths</p>

Finally, the configuration file search continues with the following system-wide paths.  If any of these paths is found to contain a configuration file, then searching completes successfully. 

```C
usr/local/etc/opae/opae.cfg 

/etc/opae/opae.cfg 
```

<p align = "center">Figure 106 System Search Paths</p>

If the search exhausts all of the possible configuration file locations without finding a configuration file, then an internal default configuration is used.  This internal default configuration matches that of the opae.cfg file shipped with the OPAE SDK. 

###	**10.2 Configuration File Format**
The OPAE SDK configuration file is stored in JSON formatted text.  The file has two main sections: “configs” and “configurations”.  The “configs” section is an array of strings.  Each value in the “configs” array is a key into the data stored in the “configurations” section.  If a key is present in “configs”, then that key is searched for and processed in “configurations”.  If the key is not found in “configs”, then that section of “configurations” will not be processed, irrespective of whether it exists in “configurations”. 

```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

    } 

  }, 

  “configs”: [ 

    “c6100” 

  ] 

} 
```

<p align = "center">Figure 107 Keyed Configurations</p>

Each keyed section in “configurations” has four top-level entries: “enabled”, “platform”, “devices”, “opae”. 

```C
{ 

  “configurations”: { 

    “c6100”: { 

      “enabled”: true, 

      “platform”: “Intel Acceleration Development Platform C6100”, 

      “devices”: [ 

        { “name”: “c6100_pf”, “id”: [ ... ] }, 

        { “name”: “c6100_vf”, “id”: [ ... ] } 

      ], 

      “opae”: { 

        ... 

      } 

    } 

  }, 

} 
```
<p align = "center">Figure 108 Configurations Format</p>

The “enabled” key holds a Boolean value.  If the value is false or if the “enabled” key is omitted, then that configuration is skipped when parsing the file.  The “platform” key holds a string that identifies the current configuration item as a product family.  The “devices” key contains the device descriptions. 

“devices” is an array of objects that contain a “name” and an “id” key.  The “name” is a shorthand descriptor for a device PF or VF.  The value of “name” appears elsewhere in the current “configurations” section in order to uniquely identify the device.  “id” is an array of four strings, corresponding to the PCIe Vendor ID, Device ID, Subsystem Vendor ID, and Subsystem Device ID of the device.  The entries corresponding to Vendor ID and Device ID must contain valid 16-bit hex integers.  The entries corresponding to Subsystem Vendor ID and Subsystem Device ID may be 16-bit hex integers or the special wildcard string “*”, which indicates a don’t care condition. 

The remaining sections in this chapter outline the format of the “opae” configurations key. 

“plugin”: libopae-c and libopae-v 

The “plugin” key in the “opae” section of a configuration is an array of OPAE SDK plugin configuration data.  Each item in the array matches one or more PF or VF devices to a plugin library module. 


```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “plugin”: [ 

          { 

            “enabled”: true, 

            “module”: “libxfpga.so”, 

            “devices”: [ “c6100_pf” ], 

            “configuration”: {} 

          }, 

          { 

            “enabled”: true, 

            “module”: “libopae-v.so”, 

            “devices”: [ “c6100_pf”, “c6100_vf” ], 

            “configuration”: {} 

          } 

        ], 

      } 

    } 

  }, 

} 
```

<p align = "center">Figure 109 "opae" / "plugin" key/</p>

If the “enabled” key is false or if it is omitted, then that “plugin” array entry is skipped, and parsing continues.  The “module” key is a string that identifies the desired plugin module library for the entry.  The “devices” array lists one or more PF/VF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.  The “configuration” key of the “plugin” section specifies a unique plugin-specific configuration.  Currently, libopae-c and libopae-v use no plugin-specific config, so these keys are left empty. 

“fpgainfo”: fpgainfo application 

The “fpgainfo” key in the “opae” section of a configuration is an array of fpgainfo plugin configuration data.  Each item in the array matches one or more PF or VF devices to an fpgainfo plugin library module. 


```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “fpgainfo”: [ 

          { 

            “enabled”: true, 

            “module”: “libboard_c6100.so”, 

            “devices”: [ 

              { “device”: “c6100_pf”, “feature_id”: “0x12” }, 

              { “device”: “c6100_vf”, “feature_id”: “0x12” } 

            ] 

          } 

        ], 

      } 

    } 

  }, 

} 
```

<p align = "center">Figure 110 "opae" / "fpgainfo" key</p>


If the “enabled” key is false or if it is omitted, then that “fpgainfo” array entry is skipped, and parsing continues.  The “module” key is a string that identifies the desired fpgainfo module library for the entry.  Each “devices” array entry gives a PF/VF identifier in its “device” key and a DFL feature ID in its “feature_id” key. 

“fpgad”: fpgad daemon process 

The “fpgad” key in the “opae” section of a configuration is an array of fpgad plugin configuration data.  Each item in the array matches one or more PF or VF devices to an fpgad plugin library module. 


```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “fpgad”: [ 

          { 

            “enabled”: true, 

            “module”: “libfpgad-vc.so”, 

            “devices”: [ “c6100_pf” ], 

            “configuration”: { 

              ... 

            } 

          } 

        ], 

      } 

    } 

  }, 

} 
```

<p align = "center">Figure 111 "opae" / "fpgad" key </p>


If the “enabled” key is false or if it is omitted, then that “fpgad” array entry is skipped, and parsing continues.  The “module” key is a string that identifies the desired fpgad plugin module library for the entry.  The “devices” array lists one or more PF/VF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.  The “configuration” key of the “fpgad” section specifies a unique plugin-specific configuration. 

“rsu”: rsu script 

The “rsu” key in the “opae” section of a configuration is an array of rsu script configuration data.  Each item in the array matches one or more PF devices to an rsu configuration. 


```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “rsu”: [ 

          { 

            “enabled”: true, 

            “devices”: [ “c6100_pf” ], 

            “fpga_default_sequences”: “common_rsu_sequences” 

          } 

        ], 

      } 

    } 

  }, 

  “common_rsu_sequences”: [ 

    ... 

  ] 

} 
```

<p align = "center">Figure 112 "opae" / "rsu" key  </p>

If the “enabled” key is false or if it is omitted, then that “rsu” array entry is skipped, and parsing continues.  When disabled, the device(s) mentioned in that array entry will not be available for the rsu command. The “devices” array lists one or more PF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.  The “fpga_default_sequences” key of the “rsu” section specifies a JSON key.  The configuration searches for that JSON key at the global level of the configuration file, and when found applies its value as the valid set of fpga boot sequences that can be used with the rsu fpgadefault subcommand. 

 ```C
“fpgareg”: fpgareg script 
 ```

The “fpgareg” key in the “opae” section of a configuration is an array of fpgareg script configuration data.  Each item in the array matches one or more PF/VF devices to an fpgareg configuration. 

 ```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “fpgareg”: [ 

          { 

            “enabled”: true, 

            “devices”: [ “c6100_pf”, “c6100_vf” ] 

          } 

        ], 

      } 

    } 

  }, 

} 
 ```

<p align = "center">Figure 113 "opae" / "fpgareg" key   </p>


If the “enabled” key is false or if it is omitted, then that “fpgareg” array entry is skipped, and parsing continues.  When disabled, the device(s) mentioned in that array entry will not be available for the fpgareg command. The “devices” array lists one or more PF/VF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.   

```C
“opae.io”: opae.io application 
```

The “opae.io” key in the “opae” section of a configuration is an array of opae.io configuration data.  Each item in the array matches one or more PF/VF devices to an opae.io platform string. 


```C
{ 

  “configurations”: { 

    “c6100”: { 

      ... 

      “opae”: { 

        “opae.io”: [ 

          { 

            “enabled”: true, 

            “devices”: [ “c6100_pf”, “c6100_vf” ] 

          } 

        ], 

      } 

    } 

  }, 

} 
```

<p align = "center">Figure 114 "opae" / "opae.io" key    </p>

If the “enabled” key is false or if it is omitted, then that “opae.io” array entry is skipped, and parsing continues.  When disabled, the device(s) mentioned in that array entry will continue to be available for the opae.io command.  The device(s) platform string will not be shown in the `opae.io ls` command.  The “devices” array lists one or more PF/VF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.   

Libxfpga – Updating the Metrics API 

Edit libraries/plugins/xfpga/sysfs.c.  Find the definition of the opae_id_to_hw_type() function.  Update the function to add the new vendor/device ID to hw_type mapping. 

This mapping is used by the SDK’s metrics API to determine the method of accessing the board sensor information and is very specific to the underlying BMC implementation.  It may be necessary to add a new hw_type value and to update the logic in libraries/plugins/xfpga/metrics. 

## **11.0 DFL Linux Kernel Drivers**

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks such as DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality.

The OFS driver software can be found in the [OFS repository - linux-dfl](https://github.com/OFS/linux-dfl), under the linux-dfl specific category. This repository has an associated [OFS repository - linux-dfl](https://github.com/OFS/linux-dfl/wiki) that includes the following information:

- An description of the three available branch archetypes
- Configuration tweaks required while building the kernel
- A functional description of the available DFL framework
- Descriptions for all currently available driver modules that support FPGA DFL board solutions
- Steps to create a new DFL driver
- Steps to port a DFL driver patch

### **11.1 Hardware Architecture**

The Linux Operating System treats the FPGA hardware as a PCIe\* device. A predefined data structure,
Device Feature List (DFL), allows for dynamic feature discovery in an Intel
FPGA solution.

![FPGA PCIe Device](FPGA_PCIe_Device.png "FPGA PCIe Device")

The Linux Device Driver implements PCIe Single Root I/O Virtualization (SR-IOV) for the creation of
Virtual Functions (VFs). The device driver can release individual accelerators
for assignment to virtual machines (VMs).

![Virtualized FPGA PCIe Device](FPGA_PCIe_Device_SRIOV.png "Virtualized FPGA PCIe Device")

### **11.2 FPGA Management Engine (FME)**

The FPGA Management Engine provides error reporting, reconfiguration, performance reporting, and other
infrastructure functions. Each FPGA has one FME which is always accessed through the Physical
Function (PF). The Intel Xeon&reg; Processor with Integrated FPGA also performs power and thermal management.
These functions are not available on the Intel Programmable Acceleration Card (PAC).

User-space applications can acquire exclusive access to the FME using `open()`,
and release it using `close()`. Device access may be managed by standard Linux
interfaces and tools.

> If an application terminates without freeing the FME or Port resources, Linux closes all file descriptors owned by the terminating process, freeing those resources.

### **11.3 Port**

A Port represents the interface between two components:
* The FPGA Interface Manager (FIM) which is part of the static FPGA fabric
* The Accelerator Function Unit (AFU) which is the partially reconfigurable region

The Port controls the communication from software to the AFU and makes features such as reset and debug available.

### **11.4 Accelerator Function Unit (AFU)**

An AFU attaches to a Port. The AFU provides a 256 KB memory mapped I/O (MMIO) region for accelerator-specific control registers.

* Use `open()` on the Port device to acquire access to an AFU associated with the Port device.
* Use `close()`on the Port device to release the AFU associated with the Port device.
* Use `mmap()` on the Port device to map accelerator MMIO regions.

### **11.5 Partial Reconfiguration (PR)**

Use PR to reconfigure an AFU from a bitstream file. Successful reconfiguration has the following requirement:

* You must generate the reconfiguration AFU for the exact FIM. The AFU and FIM are compatible if their interface IDs match.
You can verify this match by comparing the interface ID in the bitstream header against the interface ID that is
exported by the driver in sysfs.

In all other cases PR fails and may cause system instability.

> Platforms that support 512-bit Partial Reconfiguration require binutils >= version 2.25.

Close any software programs accessing the FPGA, including those running in a virtualized host before
initiating PR. For virtualized environments, the recommended sequence is as
follows:

1. Unload the driver from the guest
2. Release the VF from the guest

> Releasing the VF from the guest while an application on the guest is still accessing its resources may lead to VM instabilities. We recommend closing all applications accessing the VF in the guest before releasing the VF.

3. Disable SR-IOV
4. Perform PR
5. Enable SR-IOV
6. Assign the VF to the guest
7. Load the driver in the guest

### **11.6 FPGA Virtualization**

To enable accelerator access from applications running on a VM, create a VF for
the port using the following process:

1. Release the Port from the PF using the associated ioctl on the FME device.

2. Use the following command to enable SR-IOV and VFs. Each VF can own a single Port with an AFU. In the following command,
N is the number of Port released from the PF.

```console
    echo N > $PCI_DEVICE_PATH/sriov_numvfs
```

> The number, 'N', cannot be greater than the number of supported VFs. This can be read from $PCI_DEVICE_PATH/sriov_totalvfs.

3. Pass the VFs through to VMs using hypervisor interfaces.

4. Access the AFU on a VF from applications running on the VM using the same driver inside the VM.

> Creating VFs is only supported for port devices. Consequently, PR and other management functions are only available through the PF.    

<br>

> If assigning multiple devices to the same VM on a guest IOMMU, you may need to increase the [hard_limit option](https://libvirt.org/formatdomain.html#memory-tuning) in order to avoid hitting a limit of pinned memory. The hard limit should be more than (VM memory size x Number of PCIe devices).


### **11.7 Driver Organization**

#### **11.7.1 PCIe Module Device Driver**

![Driver Organization](Driver_Organization.png "Driver Organization")




FPGA devices appear as a PCIe devices. Once enumeration detects a PCIe PF or VF, the Linux OS loads the FPGA PCIe
device driver. The device driver performs the following functions:

1. Walks through the Device Feature List in PCIe device base address register (BAR) memory to discover features
and their sub-features and creates necessary platform devices.
2. Enables SR-IOV.
3. Introduces the feature device infrastructure, which abstracts operations for sub-features and provides common functions
to feature device drivers.

#### **11.7.2 PCIe Module Device Driver Functions**

The PCIe Module Device Driver performs the following functions:

1. PCIe discovery, device enumeration, and feature discovery.
2. Creates sysfs directories for the device, FME, and Port.
3. Creates the platform driver instances, causing the Linux kernel to load their respective drivers.

#### **11.7.3 FME Platform Module Device Driver**

The FME Platform Module Device Driver loads automatically after the PCIe driver creates the
FME Platform Module. It provides the following features for FPGA management:

1. Power and thermal management, error reporting, performance reporting, and other infrastructure functions. You can access
these functions via sysfs interfaces the FME driver provides.

2. Partial Reconfiguration. During PR sub-feature initialization, the FME driver registers the FPGA Manager framework
to support PR. When the FME receives the relevant ioctl request from user-space, it invokes the common interface
function from the FPGA Manager to reconfigure the AFU using PR.

3. Port management for virtualization (releasing/assigning port device).

After a port device is released, you can use the PCIe driver SR-IOV interfaces to create/destroy VFs.

For more information, refer to "FPGA Virtualization".

#### **11.7.4 FME Platform Module Device Driver Functions**

The FME Platform Module Device Driver performs the the following functions:

* Creates the FME character device node.
* Creates the FME sysfs files and implements the FME sysfs file accessors.
* Implements the FME private feature sub-drivers.
* FME private feature sub-drivers:
    * FME Header
    * Partial Reconfiguration
    * Global Error
    * Global Performance

#### **11.7.5 Port Platform Module Device Driver**

After the PCIe Module Device Driver creates the Port Platform Module device,
the FPGA Port and AFU driver are loaded.  This module provides an
interface for user-space applications to access the individual
accelerators, including basic reset control on the Port, AFU MMIO region
export, DMA buffer mapping service, and remote debug functions.

#### **11.7.6 Port Platform Module Device Driver Functions**

The Port Platform Module Device Driver performs the the following functions:

* Creates the Port character device node.
* Creates the Port sysfs files and implements the Port sysfs file accessors.
* Implements the following Port private feature sub-drivers.
    * Port Header
    * AFU
    * Port Error
    * Signal Tap

#### **11.7.7 OPAE FPGA Driver Interface**
The user-space interface consists of a sysfs hierarchy and ioctl requests. Most
kernel attributes can be accessed/modified via sysfs nodes in this hierarchy.
More complex I/O operations are controlled via ioctl requests. The OPAE API
implementation, libopae-c, has been designed to use this interface to
interact with the OPAE FPGA kernel drivers.

## **12.0 Plugin Development**

### **12.1 Overview**

Beginning with OPAE C library version 1.2.0, OPAE implements a plugin-centric
model. This guide serves as a reference to define the makeup of an OPAE C API
plugin and to describe a sequence of steps that one may follow when constructing
an OPAE C API plugin.

### **12.2 Plugin Required Functions** 

An OPAE C API plugin is a runtime-loadable shared object library, also known as
a module. On Linux systems, the *dl* family of APIs from libdl are used to
interact with shared objects. Refer to "man dlopen" and "man dlsym" for examples
of using the libdl API.

An OPAE C API plugin implements one required function. This function is required
to have C linkage, so that its name is not mangled.

```c
    int opae_plugin_configure(opae_api_adapter_table *table, const char *config);
```

During initialization, the OPAE plugin manager component loads each plugin,
searching for its `opae_plugin_configure` function. If none is found, then
the plugin manager rejects that plugin. When it is found, `opae_plugin_configure`
is called passing a pointer to a freshly-created `opae_api_adapter_table` and
a buffer consisting of configuration data for the plugin.

The job of the `opae_plugin_configure` function is to populate the given adapter
table with each of the plugin's API entry points and to consume and comprehend
the given configuration data in preparation for initialization.

### **12.3 OPAE API Adapter Table**

The adapter table is a data structure that contains function pointer entry points
for each of the OPAE APIs implemented by a plugin. In this way, it adapts the
plugin-specific behavior to the more general case of a flat C API. Note that
OPAE applications are only required to link with opae-c. In other words, the
name of the plugin library should not appear on the linker command line. In this
way, plugins are truly decoupled from the OPAE C API, and they are required to
adapt to the strict API specification by populating the adapter table only. No
other linkage is required nor recommended.

`adapter.h` contains the definition of the `opae_api_adapter_table`. An abbreviated
version is depicted below, along with supporting type `opae_plugin`:

```c
    typedef struct _opae_plugin {
        char *path;
        void *dl_handle;
    } opae_plugin;

    typedef struct _opae_api_adapter_table {

        struct _opae_api_adapater_table *next;
        opae_plugin plugin;

        fpga_result (*fpgaOpen)(fpga_token token, fpga_handle *handle,
                                int flags);

        fpga_result (*fpgaClose)(fpga_handle handle);

        ...

        fpga_result (*fpgaEnumerate)(const fpga_properties *filters,
                                     uint32_t num_filters, fpga_token *tokens,
                                     uint32_t max_tokens,
                                     uint32_t *num_matches);

        ...

        // configuration functions
        int (*initialize)(void);
        int (*finalize)(void);

        // first-level query
        bool (*supports_device)(const char *device_type);
        bool (*supports_host)(const char *hostname);

    } opae_api_adapter_table;
```

Some points worth noting are that the adapter tables are organized in memory by
adding them to a linked list data structure. This is the use of the `next`
structure member. (The list management is handled by the plugin manager.)
The `plugin` structure member contains the handle to the shared object instance,
as created by `dlopen`. This handle is used in the plugin's `opae_plugin_configure`
to load plugin entry points. A plugin need only implement the portion of the
OPAE C API that a target application needs. Any API entry points that are not
supported should be left as NULL pointers (the default) in the adapter table.
When an OPAE API that has no associated entry point in the adapter table is
called, the result for objects associated with that plugin will be
`FPGA_NOT_SUPPORTED`.

The following code illustrates a portion of the `opae_plugin_configure` for
a theoretical OPAE C API plugin libfoo.so:

```c
    /* foo_plugin.c */

    int opae_plugin_configure(opae_api_adapter_table *table, const char *config)
    {
        adapter->fpgaOpen = dlsym(adapter->plugin.dl_handle, "foo_fpgaOpen");
        adapter->fpgaClose =
                dlsym(adapter->plugin.dl_handle, "foo_fpgaClose");

        ...

        adapter->fpgaEnumerate =
                dlsym(adapter->plugin.dl_handle, "foo_fpgaEnumerate");

        ...

        return 0;
    }
```

Notice that the implementations of the API entry points for plugin libfoo.so
are prefixed with `foo_`. This is the recommended practice to avoid name
collisions and to enhance the debugability of the application. Upon successful
configuration, `opae_plugin_configure` returns 0 to indicate success. A
non-zero return value indicates failure and causes the plugin manager to
reject the plugin from futher consideration.

### **12.4 Plugin Optional Functions**

Once the plugin manager loads and configures each plugin, it uses the adapter
table to call back into the plugin so that it can be made ready for runtime.
This is the job of the `opae_plugin_initialize` entry point, whose signature
is defined as:

```c
    int opae_plugin_initialize(void);
```

The function takes no parameters, as the configuration data was already given
to the plugin by `opae_plugin_configure`. `opae_plugin_initialize` returns 0
if no errors were encountered during initialization. A non-zero return code
indicates that plugin initialization failed. A plugin makes its
`opae_plugin_initialize` available to the plugin manager by populating the
adapter table's `initialize` entry point as shown:

```c
    /* foo_plugin.c */

    int foo_plugin_initialize(void)
    {
        ...

        return 0; /* success */
    }

    int opae_plugin_configure(opae_api_adapter_table *table, const char *config)
    {
        ... 

        adapter->initialize =
                dlsym(adapter->plugin.dl_handle, "foo_plugin_initialize");

        ...

        return 0;
    }
```

If a plugin does not implement an `opae_plugin_initialize` entry point, then
the `initialize` member of the adapter table should be left uninitialized.
During plugin initialization, if a plugin has no `opae_plugin_initialize`
entry in its adapter table, the plugin initialization step will be skipped,
and the plugin will be considered to have initialized successfully.

Once plugin initialization is complete for all loaded plugins, the system
is considered to be running and fully functional.

During teardown, the plugin manager uses the adapter table to call into each
plugin's `opae_plugin_finalize` entry point, whose signature is defined as:

```c
    int opae_plugin_finalize(void);
```

`opae_plugin_finalize` returns 0 if no errors were encountered during teardown.
A non-zero return code indicates that plugin teardown failed. A plugin makes
its `opae_plugin_finalize` available to the plugin manager by populating the
adapter table's `finalize` entry point as shown:

```c
    /* foo_plugin.c */

    int foo_plugin_finalize(void)
    {
        ...

        return 0; /* success */
    }

    int opae_plugin_configure(opae_api_adapter_table *table, const char *config)
    {
        ... 

        adapter->finalize =
                dlsym(adapter->plugin.dl_handle, "foo_plugin_finalize");

        ...

        return 0;
    }
```

If a plugin does not implement an `opae_plugin_finalize` entry point, then
the `finalize` member of the adapter table should be left uninitialized.
During plugin cleanup, if a plugin has no `opae_plugin_finalize` entry
point in its adapter table, the plugin finalize step will be skipped, and
the plugin will be considered to have finalized successfully.

In addition to `initialize` and `finalize`, an OPAE C API plugin has two
further optional entry points that relate to device enumeration. During
enumeration, when a plugin is being considered for a type of device, the
plugin may provide input on that decision by exporting an
`opae_plugin_supports_device` entry point in the adapter table:

```c
    bool opae_plugin_supports_device(const char *device_type);
```

`opae_plugin_supports_device` returns true if the given device type is
supported and false if it is not. A false return value from
`opae_plugin_supports_device` causes device enumeration to skip the
plugin.

Populating the `opae_plugin_supports_device` is done as:

```c
    /* foo_plugin.c */

    bool foo_plugin_supports_device(const char *device_type)
    {
        if (/* device_type is supported */)
            return true;

        ...

        return false;
    }

    int opae_plugin_configure(opae_api_adapter_table *table, const char *config)
    {
        ... 

        adapter->supports_device =
                dlsym(adapter->plugin.dl_handle, "foo_plugin_supports_device");

        ...

        return 0;
    }
```

```eval_rst
.. note::
    The `opae_plugin_supports_device` mechanism serves as a placeholder only.
    It is not implemented in the current version of the OPAE C API.
```

Similarly to determining whether a plugin supports a type of device, a plugin
may also answer questions about network host support by populating an
`opae_plugin_supports_host` entry point in the adapter table:

```c
    bool opae_plugin_supports_host(const char *hostname);
```

`opae_plugin_supports_host` returns true if the given hostname is supported
and false if it is not. A false return value from `opae_plugin_supports_host`
causes device enumeration to skip the plugin.

Populating the `opae_plugin_supports_host` is done as:

```c
    /* foo_plugin.c */

    bool foo_plugin_supports_host(const char *hostname)
    {
        if (/* hostname is supported */)
            return true;

        ...

        return false;
    }

    int opae_plugin_configure(opae_api_adapter_table *table, const char *config)
    {
        ... 

        adapter->supports_host =
                dlsym(adapter->plugin.dl_handle, "foo_plugin_supports_host");

        ...

        return 0;
    }
```

```eval_rst
.. note::
    The `opae_plugin_supports_host` mechanism serves as a placeholder only.
    It is not implemented in the current version of the OPAE C API.
```

### **12.5 Plugin Construction**

The steps required to implement an OPAE C API plugin, libfoo.so, are:

* Create foo\_plugin.c: implements `opae_plugin_configure`,
`opae_plugin_initialize`, `opae_plugin_finalize`, `opae_plugin_supports_device`,
and `opae_plugin_supports_host` as described in the previous sections.
* Create foo\_plugin.h: implements function prototypes for each of the
plugin-specific OPAE C APIs.

```c
    /* foo_plugin.h */

    fpga_result foo_fpgaOpen(fpga_token token, fpga_handle *handle,
                             int flags);

    fpga_result foo_fpgaClose(fpga_handle handle);

    ...

    fpga_result foo_fpgaEnumerate(const fpga_properties *filters,
                                  uint32_t num_filters, fpga_token *tokens,
                                  uint32_t max_tokens,
                                  uint32_t *num_matches);
    ...
```

* Create foo\_types.h: implements plugin-specific types for opaque data
structures.

```c
    /* foo_types.h */

    struct _foo_token {
        ...
    };

    struct _foo_handle {
        ...
    };

    struct _foo_event_handle {
        ...
    };

    struct _foo_object {
        ...
    };
```

* Create foo\_enum.c: implements `foo_fpgaEnumerate`,
`foo_fpgaCloneToken`, and `foo_fpgaDestroyToken`.
* Create foo\_open.c: implements `foo_fpgaOpen`.
* Create foo\_close.c: implements `foo_fpgaClose`.
* Create foo\_props.c: implements `foo_fpgaGetProperties`,
`foo_fpgaGetPropertiesFromHandle`, `foo_fpgaUpdateProperties`
* Create foo\_mmio.c: implements `foo_fpgaMapMMIO`, `foo_fpgaUnmapMMIO`
`foo_fpgaWriteMMIO64`, `foo_fpgaReadMMIO64`, `foo_fpgaWriteMMIO32`,
`foo_fpgaReadMMIO32`.
* Create foo\_buff.c: implements `foo_fpgaPrepareBuffer`,
`foo_fpgaReleaseBuffer`, `foo_fpgaGetIOAddress`.
* Create foo\_error.c: implements `foo_fpgaReadError`, `foo_fpgaClearError`,
`foo_fpgaClearAllErrors`, `foo_fpgaGetErrorInfo`.
* Create foo\_event.c: implements `foo_fpgaCreateEventHandle`,
`foo_fpgaDestroyEventHandle`, `foo_fpgaGetOSObjectFromEventHandle`,
`foo_fpgaRegisterEvent`, `foo_fpgaUnregisterEvent`.
* Create foo\_reconf.c: implements `foo_fpgaReconfigureSlot`.
* Create foo\_obj.c: implements `foo_fpgaTokenGetObject`,
`foo_fpgaHandleGetObject`, `foo_fpgaObjectGetObject`,
`foo_fpgaDestroyObject`, `foo_fpgaObjectGetSize`, `foo_fpgaObjectRead`,
`foo_fpgaObjectRead64`, `foo_fpgaObjectWrite64`.
* Create foo\_clk.c: implements `foo_fpgaSetUserClock`,
`foo_fpgaGetUserClock`.

## **13.0 Building a Sample Application**

Building a sample application
The library source includes code samples. Use these samples to learn how to call functions in the library. Build and run these samples as quick sanity checks to determine if your installation and environment are set up properly.

In this guide, we will build `hello_fpga.c`. This is the "Hello World!" example of using the library. This code searches for a predefined and known AFU called "Native Loopback Adapter" on the FPGA. If found, it acquires ownership and then interacts with the AFU by sending it a 2MB message and waiting for the message to be echoed back. This code exercises all major components of the API except for AFU reconfiguration: AFU search, enumeration, access, MMIO, and memory management.

You can also find the source for `hello_fpga` in the **samples** directory of the OPAE SDK repository on GitHub.

```c
    int main(int argc, char *argv[])
    {
        fpga_properties    filter = NULL;
        fpga_token         afu_token;
        fpga_handle        afu_handle;
        fpga_guid          guid;
        uint32_t           num_matches;

        volatile uint64_t *dsm_ptr    = NULL;
        volatile uint64_t *status_ptr = NULL;
        volatile uint64_t *input_ptr  = NULL;
        volatile uint64_t *output_ptr = NULL;

        uint64_t        dsm_wsid;
        uint64_t        input_wsid;
        uint64_t        output_wsid;
        fpga_result     res = FPGA_OK;

        if (uuid_parse(NLB0_AFUID, guid) < 0) {
            fprintf(stderr, "Error parsing guid '%s'\n", NLB0_AFUID);
            goto out_exit;
        }

        /* Look for accelerator by its "afu_id" */
        res = fpgaGetProperties(NULL, &filter);
        ON_ERR_GOTO(res, out_exit, "creating properties object");

        res = fpgaPropertiesSetObjectType(filter, FPGA_ACCELERATOR);
        ON_ERR_GOTO(res, out_destroy_prop, "setting object type");

        res = fpgaPropertiesSetGuid(filter, guid);
        ON_ERR_GOTO(res, out_destroy_prop, "setting GUID");

        /* TODO: Add selection via BDF / device ID */

        res = fpgaEnumerate(&filter, 1, &afu_token, 1, &num_matches);
        ON_ERR_GOTO(res, out_destroy_prop, "enumerating accelerators");

        if (num_matches < 1) {
            fprintf(stderr, "accelerator not found.\n");
            res = fpgaDestroyProperties(&filter);
            return FPGA_INVALID_PARAM;
        }

        /* Open accelerator and map MMIO */
        res = fpgaOpen(afu_token, &afu_handle, 0);
        ON_ERR_GOTO(res, out_destroy_tok, "opening accelerator");

        res = fpgaMapMMIO(afu_handle, 0, NULL);
        ON_ERR_GOTO(res, out_close, "mapping MMIO space");

        /* Allocate buffers */
        res = fpgaPrepareBuffer(afu_handle, LPBK1_DSM_SIZE,
                    (void **)&dsm_ptr, &dsm_wsid, 0);
        ON_ERR_GOTO(res, out_close, "allocating DSM buffer");

        res = fpgaPrepareBuffer(afu_handle, LPBK1_BUFFER_ALLOCATION_SIZE,
                   (void **)&input_ptr, &input_wsid, 0);
        ON_ERR_GOTO(res, out_free_dsm, "allocating input buffer");

        res = fpgaPrepareBuffer(afu_handle, LPBK1_BUFFER_ALLOCATION_SIZE,
                   (void **)&output_ptr, &output_wsid, 0);
        ON_ERR_GOTO(res, out_free_input, "allocating output buffer");

        printf("Running Test\n");

        /* Initialize buffers */
        memset((void *)dsm_ptr,    0,    LPBK1_DSM_SIZE);
        memset((void *)input_ptr,  0xAF, LPBK1_BUFFER_SIZE);
        memset((void *)output_ptr, 0xBE, LPBK1_BUFFER_SIZE);

        cache_line *cl_ptr = (cache_line *)input_ptr;
        for (uint32_t i = 0; i < LPBK1_BUFFER_SIZE / CL(1); ++i) {
            cl_ptr[i].uint[15] = i+1; /* set the last uint in every cacheline */
        }

        /* Reset accelerator */
        res = fpgaReset(afu_handle);
        ON_ERR_GOTO(res, out_free_output, "resetting accelerator");

        /* Program DMA addresses */
        uint64_t iova;
        res = fpgaGetIOAddress(afu_handle, dsm_wsid, &iova);
        ON_ERR_GOTO(res, out_free_output, "getting DSM IOVA");

        res = fpgaWriteMMIO64(afu_handle, 0, CSR_AFU_DSM_BASEL, iova);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_AFU_DSM_BASEL");

        res = fpgaWriteMMIO32(afu_handle, 0, CSR_CTL, 0);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_CFG");
        res = fpgaWriteMMIO32(afu_handle, 0, CSR_CTL, 1);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_CFG");

        res = fpgaGetIOAddress(afu_handle, input_wsid, &iova);
        ON_ERR_GOTO(res, out_free_output, "getting input IOVA");
        res = fpgaWriteMMIO64(afu_handle, 0, CSR_SRC_ADDR, CACHELINE_ALIGNED_ADDR(iova));
        ON_ERR_GOTO(res, out_free_output, "writing CSR_SRC_ADDR");

        res = fpgaGetIOAddress(afu_handle, output_wsid, &iova);
        ON_ERR_GOTO(res, out_free_output, "getting output IOVA");
        res = fpgaWriteMMIO64(afu_handle, 0, CSR_DST_ADDR, CACHELINE_ALIGNED_ADDR(iova));
        ON_ERR_GOTO(res, out_free_output, "writing CSR_DST_ADDR");

        res = fpgaWriteMMIO32(afu_handle, 0, CSR_NUM_LINES, LPBK1_BUFFER_SIZE / CL(1));
        ON_ERR_GOTO(res, out_free_output, "writing CSR_NUM_LINES");
        res = fpgaWriteMMIO32(afu_handle, 0, CSR_CFG, 0x42000);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_CFG");

        status_ptr = dsm_ptr + DSM_STATUS_TEST_COMPLETE/8;

        /* Start the test */
        res = fpgaWriteMMIO32(afu_handle, 0, CSR_CTL, 3);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_CFG");

        /* Wait for test completion */
        while (0 == ((*status_ptr) & 0x1)) {
            usleep(100);
        }

        /* Stop the device */
        res = fpgaWriteMMIO32(afu_handle, 0, CSR_CTL, 7);
        ON_ERR_GOTO(res, out_free_output, "writing CSR_CFG");

        /* Check output buffer contents */
        for (uint32_t i = 0; i < LPBK1_BUFFER_SIZE; i++) {
            if (((uint8_t*)output_ptr)[i] != ((uint8_t*)input_ptr)[i]) {
                fprintf(stderr, "Output does NOT match input "
                    "at offset %i!\n", i);
                break;
            }
        }

        printf("Done Running Test\n");

        /* Release buffers */
    out_free_output:
        res = fpgaReleaseBuffer(afu_handle, output_wsid);
        ON_ERR_GOTO(res, out_free_input, "releasing output buffer");
    out_free_input:
        res = fpgaReleaseBuffer(afu_handle, input_wsid);
        ON_ERR_GOTO(res, out_free_dsm, "releasing input buffer");
    out_free_dsm:
        res = fpgaReleaseBuffer(afu_handle, dsm_wsid);
        ON_ERR_GOTO(res, out_unmap, "releasing DSM buffer");

        /* Unmap MMIO space */
    out_unmap:
        res = fpgaUnmapMMIO(afu_handle, 0);
        ON_ERR_GOTO(res, out_close, "unmapping MMIO space");

        /* Release accelerator */
    out_close:
        res = fpgaClose(afu_handle);
        ON_ERR_GOTO(res, out_destroy_tok, "closing accelerator");

        /* Destroy token */
    out_destroy_tok:
        res = fpgaDestroyToken(&afu_token);
        ON_ERR_GOTO(res, out_destroy_prop, "destroying token");

        /* Destroy properties object */
    out_destroy_prop:
        res = fpgaDestroyProperties(&filter);
        ON_ERR_GOTO(res, out_exit, "destroying properties object");

    out_exit:
        return res;

    }
```

Linking with the OPAE library is straightforward. Code using this library should include the header file fpga.h. Taking the GCC compiler on Linux as an example, the minimalist compile and link line should look like:

```bash
gcc -std=c99 hello_fpga.c -I/usr/local/include -L/usr/local/lib -lopae-c -luuid -ljson-c -lpthread -o hello_fpga
```

The API uses some features from the C99 language standard. The
`-std=c99` switch is required if the compiler does not support C99 by
default.

Third-party library dependency: The library internally uses
`libuuid` and `libjson-c`. But they are not distributed as part of the
library. Make sure you have these libraries properly installed. The `-c` flag may not be necessary depending on 
the platform being used. 


```bash
sudo ./hello_fpga -c
Running Test
Running on bus 0x08.
AFU NLB0 found @ 28000
Done Running Test
```
To run the hello_fpga application:

```bash
sudo ./hello_fpga
Running Test
Done
```

## **Appendix A - Integrating an N6001 Based Custom Platform with DFL and OPAE**

The process of adding a custom device to the DFL framework and OPAE SDK requires changes to files 
in several locations. In this section we will walk through the additions necessary to instruct the kernel's probe and match function
to associate your new device with OPAE, choose the correct OPAE plugin to associate with your board, and change basic descriptors to properly
display the name of your new custom platform when using OPAE's management interfaces. 

This section does not require useage of an entirely new platform - we will use the Intel N6001's FIM design as our base, and alter only those
settings in the PCIe IP necessary to change the following PCIe IDs for both the PF and VF:

- Vendor ID
- Device ID
- Subsystem Vendor ID
- Subsystem Device ID

This document will not cover the process by which a FIM can be modified to support these new IDs. Refer to section **5.7 How to 
change the PCIe device ID and Vendor ID** in  [F2000x](../../../f2000x/dev_guides/fim_dev/ug_dev_fim_ofs.md) FIM Developer guide or section **10.0 How to 
change the PCIe device ID and Vendor ID** in the [N6001](../../../n6001/dev_guides/fim_dev/ug_dev_fim_ofs_n6001.md) FIM Developer guide
for an overview of this process. The following sections assume you have a FIM that has been configured with new IDs. This FIM can be loaded
onto your N6001 board using either the SOF via a USB-BlasterII cable and the Quartus Programmer, or by using the OPAE command `fpgasupdate` consuming a compatible binary programming
file. The following values will be used as our new device IDs.

| ID Type               | PF0           | PF0-VF            |
| -----                 | -----         | -----             |
| Vendor ID             | 0xff00        | 0xff00            | 
| Device ID             | 0x1234        | 0x5555            |
| Subsystem Vendor ID   | 0xff00        | 0xff00            |
| Subsystem Device ID   | 0x0x5678      | 0x5678            |

The only value that differs between PF0 and PF0-VF in this example is the Device ID, and all other values do not currently exist in either the OPAE SDK
or linux-dfl drivers. You will need to download the OPAE SDK and linux-dfl sources from GitHub and modify their contents. We will be using a validated Agilex OFS release to pair
our OPAE SDK and linux-dfl versions together. Refer to the below table for a list of the exact version we will use for each software component and where you can 
learn how to build and install. Your versions may not match those in the document.

| Software      | Version       | Build Instructions                  |
| -----         | -----         | -----                               |
| OPAE SDK      | 2.3.0-1       | [**4.0 OPAE Software Development Kit**](https://github.com/intel-innersource/applications.fpga.ofs.documentation/blob/main/n6000/user_guides/ofs_getting_started/ug_qs_ofs_n6000.md#heading-4.0) |
| linux-dfl     | ofs-2022.3-2  | [**3.0 Intel OFS DFL Kernel Drivers**](https://github.com/intel-innersource/applications.fpga.ofs.documentation/blob/main/n6000/user_guides/ofs_getting_started/ug_qs_ofs_n6000.md#heading-3.0)  |

The following steps will enable your device to use the OPAE SDK. We will call our new device the "Intel FPGA Programmable Acceleration Card N6002".
This device is identical to the Intel FPGA Programmable Acceleration Card N6001, and will use the pre-existing plugins and feature ID associated with that device. We will also use the enum value `FPGA_HW_DCP_N6002` to describe our new board
in the code. These plugins can be customized as you become more familiar with the OPAE SDK software. 

1. Download the OPAE SDK from GitHub. File paths assume the user is in the directory `opae-sdk`.
2. Open the file `binaries/opae.io/opae/io/config.py`. Add a new configuration entry under `DEFAULT_OPAE_IO_CONFIG`. Save and exit.

**Example:**

```c
(0xff00, 0x1234, 0xff00, 0x5678) : {
        'platform': 'Intel FPGA Programmable Acceleration Card N6002'
    },
```

3. Open the file `libraries/libopae-c/cfg-file.c`. Add two new entries (one for PF0 and PF0-VF) under `STATIC libopae_config_data default_libopae_config_table[]`. Add  two new entries under `STATIC fpgainfo_config_data default_fpgainfo_config_table[]`. Save and exit.

**Example:**

```c
STATIC fpgainfo_config_data default_fpgainfo_config_table[] = {
...
{ 0xff00, 0x1234, 0xff00, 0x5678, 0x12, "libboard_n6000.so", NULL,
"Intel FPGA Programmable Acceleration Card N6002" },                  // N6002 PF0
{ 0xff00, 0x5555, 0xff00, 0x5678, 0x12, "libboard_n6000.so", NULL,
"Intel FPGA Programmable Acceleration Card N6002" },                  // N6002 PF0-VF
```

**Example:**

```c
STATIC libopae_config_data default_libopae_config_table[] = {
...
{ 0xff00, 0x1234, 0xff00,          0x5678,          "libxfpga.so",  "{}", 0 }    , // N6002 PF0
{ 0xff00, 0x5555, 0xff00,          0x5678,          "libxfpga.so",  "{}", 0 }    , // N6002 PF0-VF
```
4. Open the file `libraries/plugins/xfpga/metrics/metric_utils.c`. Add one entry to the switch case under `enum_fpga_metrics(fpga_handle handle)`. The enum value used should match the enum set in step 6. 
Add a new condition to the if statement beginning `if (((_fpga_enum_metric->hw_type == FPGA_HW_DCP_N3000)`. Save and exit.

**Example:**

```c
                 // DCP VC DC
                 case FPGA_HW_DCP_N3000:
                 case FPGA_HW_DCP_D5005:
                 case FPGA_HW_DCP_N6002:
                 case FPGA_HW_DCP_N5010: {
                 ...
```

**Example:**

```c
                            if (((_fpga_enum_metric->hw_type == FPGA_HW_DCP_N3000) ||
                                 (_fpga_enum_metric->hw_type == FPGA_HW_DCP_D5005) ||
                                 (_fpga_enum_metric->hw_type == FPGA_HW_DCP_N6002) ||
                                 (_fpga_enum_metric->hw_type == FPGA_HW_DCP_N5010)) &&
```
5. Open the file `libraries/plugins/xfpga/sysfs.c`. Add a new set of switch cases under `enum fpga_hw_type opae_id_to_hw_type(uint16_t vendor_id, uint16_t device_id)`. The enum value
used should match the enum value set in step 6. Save and exit.

**Example:**

```c
            if (vendor_id == 0xff00) {        
                 switch (device_id) {
                         case 0x1234:
                         case 0x5555:
                                 hw_type = FPGA_HW_DCP_N6002;
                         break;
                 default:
                         OPAE_ERR("unknown device id: 0x%04x", device_id);
```
6. Open the file `libraries/plugins/xfpga/types_int.h`. Add your new enum value under `enum fpga_hw_type`. Save and exit.

**Example:**

```c
enum fpga_hw_type {
         FPGA_HW_MCP,
         FPGA_HW_DCP_RC,
         FPGA_HW_DCP_D5005,
         FPGA_HW_DCP_N3000,
         FPGA_HW_DCP_N5010,
         FPGA_HW_DCP_N6002,
         FPGA_HW_UNKNOWN
};
```
7. Open the file `opae.cfg`. Create a new entry for device "n6002" by copying the entry for "n6001,"" substituting our new values. Add one new entry under "configs" for the name "n6002." Save and exit.

**Example:**

```c
    "n6002": {
      "enabled": true,
      "platform": "Intel Acceleration Development Platform N6002",
      "devices": [
        { "name": "n6002_pf", "id": [ "0xff00", "0x1234", "0xff00", "0x5678" ] },
        { "name": "n6002_vf", "id": [ "0xff00", "0x5555", "0xff00", "0x5678" ] }
      ],
      "opae": {
        "plugin": [
          {
            "enabled": true,
            "module": "libxfpga.so",
            "devices": [ "n6002_pf" ],
            "configuration": {}
          },
          {
            "enabled": true,
            "module": "libopae-v.so",
            "devices": [ "n6002_pf", "n6002_vf" ],
            "configuration": {}
          }
        ],
        "fpgainfo": [
          {
            "enabled": true,
            "module": "libboard_n6000.so",
            "devices": [
              { "device": "n6002_pf", "feature_id": "0x12" },
              { "device": "n6002_vf", "feature_id": "0x12" }
            ]
          }
        ],
        "fpgad": [
         {
            "enabled": true,
            "module": "libfpgad-vc.so",
            "devices": [ "n6002_pf" ],
            "configuration": {
              "cool-down": 30,
              "get-aer":     [ "setpci -s %s ECAP_AER+0x08.L",
                               "setpci -s %s ECAP_AER+0x14.L" ],
              "disable-aer": [ "setpci -s %s ECAP_AER+0x08.L=0xffffffff",
                               "setpci -s %s ECAP_AER+0x14.L=0xffffffff" ],
              "set-aer":     [ "setpci -s %s ECAP_AER+0x08.L=0x%08x",
                               "setpci -s %s ECAP_AER+0x14.L=0x%08x" ],
              "sensor-overrides": [],
              "monitor-seu": false
            }
          }
        ],
        "rsu": [
          {
            "enabled": true,
            "devices": [ "n6002_pf" ],
            "fpga_default_sequences": "common_rsu_sequences"
          }
        ],
        "fpgareg": [
          {
            "enabled": true,
            "devices": [ "n6002_pf", "n6002_vf" ]
          }
        ],
        "opae.io": [
          {
            "enabled": true,
            "devices": [ "n6002_pf", "n6002_vf" ]
          }
        ]
      }
    },
```

**Example:**

```c
"configs": [
     "mcp",
     "a10gx",
     "d5005",
     "n3000",
     "n5010",
     "n5013",
     "n5014",
     "n6000",
     "n6001",
     "n6002",
     ...
```
These conclude our integration of our new platform with the OPAE SDK. The next step is to download the source for linux-dfl (as shown above) 
and configure our new kernel's match and probe function to associate the DFL drivers
with our new custom platform. The following file path assumes the user is in the directory `linux-dfl`
1. Open the file `drivers/fpga/dfl-pci.c`. Define a list of necessary ID values at the top of the file. Use these values to add two new entries under `pci_device_id cci_pcie_id_tbl[]`,
one for PF0 and the other for PF0-VF. Save and exit.

**Example:**

```c
/* N6002 IDS */
#define PCIE_DEVICE_ID_PF_N6002                 0x1234
#define PCIE_VENDOR_ID_PF_N6002                 0xff00
#define PCIE_SUBDEVICE_ID_PF_N6002              0x5678
#define PCIE_DEVICE_ID_VF_N6002                 0x5555
```

**Example:**

```c
static struct pci_device_id cci_pcie_id_tbl[] = {
        ...
        {PCI_DEVICE_SUB(PCIE_VENDOR_ID_PF_N6002, PCIE_DEVICE_ID_PF_N6002,
                    PCIE_VENDOR_ID_PF_N6002, PCIE_SUBDEVICE_ID_PF_N6002),}, //N6002 PF0
        {PCI_DEVICE_SUB(PCIE_VENDOR_ID_PF_N6002, PCIE_DEVICE_ID_VF_N6002,
                    PCIE_VENDOR_ID_PF_N6002, PCIE_SUBDEVICE_ID_PF_N6002),}, //N6002 PF0-VF
                    ...
```

This concludes our integration our new platform with the linux-dfl driver set. Build and install the linux-dfl enabled kernel and the OPAE SDK userspace libraries as discussed in their relevant
sections in the user guide linked above. If the above conditions have been met, and your N6001 board has been configured with this new "N6002" FIM, you should see the following output when running the command "fpgainfo fme" (your Bitstream ID,
PR Interface ID, and Image Info entries may differ). Check that the board's display name at the top and values for Vendor/Device/SubVendor/Subdevice IDs are correct.

```c
Intel Acceleration Development Platform N6002
Board Management Controller NIOS FW version: 3.11.0
Board Management Controller Build version: 3.11.0
//****** FME ******//
Object Id                        : 0xED00001
PCIe s:b:d.f                     : 0000:B1:00.0
Vendor Id                        : 0xFF00
Device Id                        : 0x1234
SubVendor Id                     : 0xFF00
SubDevice Id                     : 0x5678
Socket Id                        : 0x00
Ports Num                        : 01
Bitstream Id                     : 0x5010202C8AD72D7
Bitstream Version                : 5.0.1
Pr Interface Id                  : 8df219e3-cf25-5e77-8689-f57102d54435
Boot Page                        : user1
Factory Image Info               : a2b5fd0e7afca4ee6d7048f926e75ac2
User1 Image Info                 : 9804075d2e8a71a192ec89602f2f5544
User2 Image Info                 : 9804075d2e8a71a192ec89602f2f5544
```

<br>

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
 
