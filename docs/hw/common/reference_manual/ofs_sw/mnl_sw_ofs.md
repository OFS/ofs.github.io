# Software Reference Manual:  Open FPGA Stack



<a name="heading-1.0"></a>

## **1.0 Introduction**

<a name="heading-1.1"></a>

### **1.1 Audience**

The information presented in this document is intended to be used by software developers looking to increase their knowledge of the OPAE SDK user-space software stack and the kernel-space linux-dfl drivers. This information is intended as a starting point, with links to where users can deep dive on specific topics. 

<a name="heading-1.2"></a>

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
 

<a name="heading-1.3"></a>


## **2.0 OPAE Software Development Kit (SDK)**

The OPAE C library is a lightweight user-space library that provides abstraction for FPGA resources in a compute environment. Built on top of the OPAE Intel® FPGA driver stack that supports Intel® FPGA platforms, the library abstracts away hardware specific and OS specific details and exposes the underlying FPGA resources as a set of features accessible from within software programs running on the host. The OPAE source code is available on the [OPAE SDK repository](https://github.com/OFS/opae-sdk), under the opae-sdk tag.

These features include the acceleration logic configured on the device, as well as functions to manage and reconfigure the device. The library enables user applications to transparently and seamlessly leverage FPGA-based acceleration.

Most of the information related to OPAE can be found on the official [OFS Site](https://ofs.github.io) page. The following is a summary of the information present on this web page:

- Configuration options present in the OPAE SDK build and installation flow
- The steps required to build a sample OPAE application
- An explanation of the basic application flow
- A reference for the C, C++, and Python APIs
- An explanation of the OPAE Linux Device Driver Architecture
- Definitions for the various user-facing OPAE SDK tools

The remaining sections on OPAE in this document are unique and build on basic principles explained in opae.github.io.

<a name="table-2"></a>

#### Table : Additional Websites and Links

| Document | Link |
| -------------------- | ------------------------------------------------------ |
| OPAE SDK on github   | [OPAE SDK repository](https://github.com/OFS/opae-sdk) |
| OPAE Documents | [OFS Site](https://ofs.github.io) |
| pybind11             | https://pybind11.readthedocs.io/en/stable/             |
| CLI11                | https://github.com/CLIUtils/CLI11                      |
| spdlog               | https://github.com/gabime/spdlog                       |

<a name="heading-2.0"></a>

### **2.0 OPAE C API**

<a name="heading-2.1"></a>

### **2.1 libopae-c**


<a name="heading-2.1.1"></a>

#### **2.1.1 Device Abstraction**

The OPAE C API relies on two base abstractions concerning how the FIM
and accelerator are presented to and manipulated by the user. The FIM is
concerned with management functionality. Access to the FIM and its
interfaces is typically restricted to privileged (root) users. The
accelerator contains the user-defined logic in its reconfigurable
region. Most OPAE end-user applications are concerned with querying and
opening the accelerator device, then interacting with the AFU via MMIO
and shared memory.

<a name="heading-2.1.1.1"></a>

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

<a name="heading-2.1.1.2"></a>

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

<a name="heading-2.1.2"></a>

### **2.1.2 Enumeration**

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
<p align = "center">Figure 1 fpgaEnumerate()</p> <a name="figure1"></a>

The typical enumeration flow involves an initial call to
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
to discover the number of available tokens.

```C
uint32_t num_matches = 0;
fpgaEnumerate(NULL, 0, NULL, 0, &num_matches);
```
<p align = "center">Figure 2 Discovering Number of Tokens</p> <a name="figure-2"></a>

Once the number of available tokens is known, the application can
allocate the correct amount of space to hold the tokens:

```C
fpga_token *tokens;
uint32_t num_tokens = num_matches;
tokens = (fpga_token *)calloc(num_tokens, sizeof(fpga_token));
fpgaEnumerate(NULL, 0, tokens, num_tokens, &num_matches);
```
<p align = "center">Figure 3 Enumerating All Tokens</p><a name="figure-3"></a>

Note that parameters filters and num\_filters were not used in the
preceding example, as they were NULL and 0. When no filtering criteria
are provided,
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
returns all tokens that can be enumerated.

<a name="heading-2.1.2.1"></a>

#### **2.1.2.1 fpga\_properties and Filtering**

An
[fpga\_properties](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L71-L92)
is an opaque data structure used to retrieve all of the properties
concerning an FPGA\_DEVICE or FPGA\_ACCELERATOR. These properties can be
included in the filters parameter to
[fpgaEnumerate()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L46-L103)
to select tokens by specific criteria.

<a name="heading-2.1.2.1.1"></a>

##### **2.1.2.1.1 Common Properties**

Table 3 lists the set of
[properties](https://github.com/OFS/opae-sdk/blob/master/libraries/libopae-c/props.h#L82-L133)
that are common to FPGA\_DEVICE and FPGA\_ACCELERATOR:

<a name="table-3"></a>

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

<a name="heading-2.1.2.1.2"></a>

###### **2.1.2.1.2 FPGA\_DEVICE Properties**

Table 4 lists the set of properties that are specific to FPGA\_DEVICE
token types.

<a name="table-4"></a>

|Property | Description|
|---------------------------------------------------------------------------------------------------------- | ------------------------------ |
| uint64\_t bbs\_id;                                                                                         | FIM-specific Blue Bitstream ID |
| [fpga\_version](https://github.com/OFS/opae-sdk/blob/master/include/opae/types.h#L135-L146) bbs\_version; | BBS version                    |

<a name="table-4"></a>

<p align = "center">Table 4 FPGA_DEVICE Properties</p>

<a name="heading-2.1.2.1.3"></a>

###### **2.1.2.1.3 FPGA\_ACCELERATOR Properties**

Table 5 lists the set of properties that are specific to
FPGA\_ACCELERATOR token types.

<a name="table-5"></a>

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

<p align = "center">Figure 4 Filtering During Enumeration</p><a name="figure 4"></a>

Note that fpga\_properties and fpga\_token’s are allocated resources
that must be freed by their respective API calls, ie
[fpgaDestroyProperties()](https://github.com/OFS/opae-sdk/blob/master/include/opae/properties.h#L160-L176)
and
[fpgaDestroyToken()](https://github.com/OFS/opae-sdk/blob/master/include/opae/enum.h#L120-L133).

<a name="heading-2.1.3"></a>

### **2.1.3 Access**

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

<a name="heading-2.1.4"></a>

### **2.1.4 Events**

Event registration in OPAE is a two-step process. First, the type of
event must be identified. The following
[fpga\_event\_type](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L71-L82)
variants are defined:

<a name="table-6"></a>

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


<p align = "center">Figure 5 Creating and Registering Events</p><a name="figure-5"></a>

When an event notification is no longer needed, it should be released by
calling
[fpgaUnregisterEvent()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L130-L154).
Like device handles, event handles are allocated resources that must be
freed when no longer used. To free an event handle, use the
[fpgaDestroyEventHandle()](https://github.com/OFS/opae-sdk/blob/master/include/opae/event.h#L65-L79)
call.


<a name="heading-2.1.5"></a>

### **2.1.5 MMIO and Shared Memory**

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

<p align = "center">Figure 6 Mapping and Accessing CSRs</p><a name="figure6"></a>

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

<p align = "center">Figure 7 fpgaPrepareBuffer()</p><a name="figure-7"></a>

Three buffer lengths are supported by this allocation method:

<a name="table-7"></a>

|Length | Description|
| ----------------- | ----------------------------------------- |
| 4096 (4KiB)       | No memory configuration needed.           |
| 2097152 (2MiB)    | Requires 2MiB huge pages to be allocated. |
| 1073741824 (1GiB) | Requires 1GiB huge pages to be allocated. |

<p align = "center">Table 7 fpgaPrepareBuffer() Lengths</p><a name="table-7"></a>

```bash
echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
echo 2 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
```

<p align = "center">Figure 8 Configuring Huge Pages</p><a name="figure-8"></a>

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

<p align = "center">Figure 9 Programming Shared Memory</p><a name="figure-9"></a>

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

<a name="heading-2.1.6"></a>

### **2.1.6 Management**

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

<p align = "center">Figure 10 fpgaReconfigureSlot()</p><a name="figure-10"></a>

<a name="heading-2.1.7"></a>

### **2.1.7 Errors**

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

<p align = "center">Figure 11 struct fpga_error_info</p><a name="figure-11"></a>

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

<p align = "center">Figure 12 fpgaGetErrorInfo()</p><a name="figure-12"></a>

[fpgaReadError](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L46-L60)()
provides access to the raw 64-bit error mask, given the unique error
index.
[fpgaClearError](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L62-L75)()
clears the errors for a particular index.
[fpgaClearAllErrors](https://github.com/OFS/opae-sdk/blob/master/include/opae/error.h#L77-L89)()
clears all the errors for the given fpga\_token.

<a name="heading-2.1.8"></a>

### **2.1.8 Metrics**

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

<p align = "center">Figure 13 fpga_metric_info</p><a name="figure-13"></a>

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



<p align = "center">Figure 14 enum fpga_metric_datatype</p><a name="figure-14"></a>

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



<p align = "center">Figure 15 enum fpga_metric_type</p><a name="figure-15"></a>

In order to enumerate the information for each of the metrics available
from the FPGA device, determine the number of metrics using
[fpgaGetNumMetrics](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L45-L57)().



```C
uint64_t num_metrics = 0;
fpgaGetNumMetrics(handle, &num_metrics);
```



<p align = "center">Figure 16 Determining Number of Metrics</p><a name="figure-16"></a>

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



<p align = "center">Figure 17 Querying Metrics Info</p><a name="figure-17"></a>

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




<p align = "center">Figure 18 struct fpga_metric</p><a name="figure-18"></a>

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

<a name="heading-2.1.8.1"></a>

#### **2.1.8.1 Querying Metric Values by Index**

[fpgaGetMetricsByIndex](https://github.com/OFS/opae-sdk/blob/master/include/opae/metrics.h#L77-L94)()
retrieves a metric value using the metric\_num field of the metric info:



```C
uint64_t metric_num = metric_info[0]->metric_num;
fpga_metric metric0;
fpgaGetMetricsByIndex(handle, &metric_num, 1, &metric0);
```



<p align = "center">Figure 19 Retrieve Metric by Index</p><a name="figure-19"></a>

This call allows retrieving one or more metric values, each identified
by their unique metric\_num. The second and fourth parameters allow
passing arrays so that multiple values can be fetched in a single call.

<a name="heading-2.1.8.2"></a>

#### **2.1.8.2 Querying Metric Values by Name**

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

<a name="heading-2.1.9"></a>

### **2.1.9 SysObject**

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



<p align = "center">Figure 20 enum fpga_sysobject_type</p><a name="figure-20"></a>

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



<p align = "center">Figure 21 fpgaTokenGetObject() / fpgaHandleGetObject()</p><a name="figure-21"></a>

The remainder of the SysObject API is broken into two categories of
calls, depending on the fpga\_object’s type. The type of an fpga\_object
is learned via
[fpgaObjectGetType](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L145-L155)().



```C
fpga_result fpgaObjectGetType(fpga_object obj,
enum fpga_sysobject_type *type);
```



<p align = "center">Figure 22 fpgaObjectGetType()</p><a name="figure-22"></a>

When an fpga\_object is no longer needed, it should be freed via
[fpgaDestroyObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L157-L170)().

<a name="heading-2.1.9.1"></a>

#### **2.1.9.1 FPGA\_OBJECT\_CONTAINER API’s**

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



<p align = "center">Figure 23 fpgaObjectGetObject() / fpgaObjectGetObjectAt()</p><a name="figure-23"></a>

Any child object resulting from
[fpgaObjectGetObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L96-L124)()
or
[fpgaObjectGetObjectAt](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L126-L144)()
must be freed via
[fpgaDestroyObject](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L157-L170)()
when it is no longer needed.

<a name="heading-2.1.9.2"></a>

#### **2.1.9.2 FPGA\_OBJECT\_ATTRIBUTE API’s**

Attribute sysfs entities may be queried for their size and read from or
written to. In order to determine the size of an attribute’s data, use
[fpgaObjectGetSize](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L172-L184)().



```C
fpga_result fpgaObjectGetSize(fpga_object obj,
uint32_t *value, int flags);
```



<p align = "center">Figure 24 fpgaObjectGetSize()</p><a name="figure-24"></a>

Attributes containing arbitrary string data can be read with
[fpgaObjectRead](https://github.com/OFS/opae-sdk/blob/master/include/opae/sysobject.h#L186-L202)().



```C
fpga_result fpgaObjectRead(fpga_object obj, uint8_t *buffer,
size_t offset, size_t len, int flags);
```



<p align = "center">Figure 25 fpgaObjectRead()</p><a name="figure-25"></a>

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



<p align = "center">Figure 26 fpgaObjectRead64() / fpgaObjectWrite64()</p><a name="figure-26"></a>

<a name="heading-2.1.10"></a>

### **2.1.10 Utilities**

The
[fpga\_result](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L38-L69)
enumeration defines a set of error codes used throughout OPAE. In order
to convert an
[fpga\_result](https://github.com/OFS/opae-sdk/blob/master/include/opae/types_enum.h#L38-L69)
error code into a printable string, the application can use the
[fpgaErrStr()](https://github.com/OFS/opae-sdk/blob/master/include/opae/utils.h#L42-L51)
call.


<a name = "heading-2.2"></a>

### **2.2 DFL Driver IOCTL Interfaces**

The DFL drivers export an IOCTL interface which the libxfpga.so plugin
consumes in order to query and configure aspects of the FME and Port.
These interfaces are used only internally by the SDK; they are not
customer-facing. The description here is provided for completeness only.

<a name="heading-2.2.1"></a>

#### **2.2.1 Port Reset**

The
[DFL\_FPGA\_PORT\_RESET](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L70-L80)
ioctl is used by the
[fpgaReset()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L90-L102)
call in order to perform a Port reset. The fpga\_handle passed to
[fpgaReset()](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L90-L102)
must be a valid open handle to an FPGA\_ACCELERATOR. The ioctl requires
no input/output parameters.

<a name="heading-2.2.2"></a>

#### **2.2.2 Port Information**

The
[DFL\_FPGA\_PORT\_GET\_INFO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L82-L99)
ioctl is used to query properties of the Port, notably the number of
associated MMIO regions. The ioctl requires a pointer to a struct
[dfl\_fpga\_port\_info](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L90-L97).

<a name="heading-2.2.3"></a>

#### **2.2.3 MMIO Region Information**

The
[DFL\_FPGA\_PORT\_GET\_REGION\_INFO](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L101-L128)
ioctl is used to query the details of an MMIO region. The ioctl requires
a pointer to a struct
[dfl\_fpga\_port\_region\_info](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L110-L126).
The index field of the struct is populated by the caller, and the
padding, size, and offset values are populated by the DFL driver.


<a name="heading-2.2.4"></a>

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

<a name="heading-2.2.5"></a>

#### **2.2.5 Number of Port Error IRQs**

The
[DFL\_FPGA\_PORT\_ERR\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L180-L189)
ioctl is used to query the number of Port error interrupt vectors
available. The ioctl requires a pointer to a uint32\_t that receives the
Port error interrupt count.

<a name="heading-2.2.6"></a>

#### **2.2.6 Port Error Interrupt Configuration**

The
[DFL\_FPGA\_PORT\_ERR\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L191-L201)
ioctl is used to configure one or more file descriptors for the Port
Error interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.

<a name="heading-2.2.7"></a>

#### **2.2.7 Number of AFU Interrupts**

The
[DFL\_FPGA\_PORT\_UINT\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L203-L212)
ioctl is used to query the number of AFU interrupt vectors available.
The ioctl requires a pointer to a uint32\_t that receives the AFU
interrupt count.

<a name="heading-2.2.8"></a>

#### **2.2.8 User AFU Interrupt Configuration**

The
[DFL\_FPGA\_PORT\_UINT\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L214-L224)
ioctl is used to configure one or more file descriptors for the AFU
interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.

<a name="heading-2.2.9"></a>

#### **2.2.9 Partial Reconfiguration**

The
[DFL\_FPGA\_FME\_PORT\_PR](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L228-L249)
ioctl is used to update the logic stored in the Port’s programmable
region. This ioctl must be issued on the device file descriptor
corresponding to the FPGA\_DEVICE (/dev/dfl-fme.X). The ioctl requires a
pointer to a struct
[dfl\_fpga\_fme\_port\_pr](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L240-L247)
with each of the fields populated.

<a name="heading-2.2.10"></a>

#### **2.2.10 Number of FME Error IRQs**

The
[DFL\_FPGA\_FME\_ERR\_GET\_IRQ\_NUM](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L269-L278)
ioctl is used to query the number of FME error interrupt vectors
available. The ioctl requires a pointer to a uint32\_t that receives the
FME error interrupt count.

<a name="heading-2.2.11"></a>

##### **2.2.11 FME Error Interrupt Configuration**

The
[DFL\_FPGA\_FME\_ERR\_SET\_IRQ](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L280-L290)
ioctl is used to configure one or more file descriptors for the FME
Error interrupt. The ioctl requires a pointer to a struct
[dfl\_fpga\_irq\_set](https://github.com/OFS/opae-sdk/blob/master/libraries/plugins/xfpga/fpga-dfl.h#L167-L178).
The values stored in the evtfds field of this struct should be populated
with the event file descriptors for the interrupt, as returned by the
eventfd() C standard library API.
as returned by the eventfd() C standard library API.

<a name = "heading-2.3"></a>

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

<p align = "center">Table 9 Plugin Device Access Methods</p><a name="table-9"></a>

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

<a name="heading-2.3.1"></a>

### **2.3.1 Plugin Model**

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



<p align = "center">Figure 27 opae_wrapped_token</p><a name="figure-27"></a>

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



<p align = "center">Figure 28 opae_api_adapter_table</p><a name="figure-28"></a>

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

<a name="heading-2.3.2"></a>

### **2.3.2 libxfpga Plugin**

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



<p align = "center">Figure 29 struct _fpga_token</p><a name="figure-29"></a>

A struct \_fpga\_token corresponding to the Port will have sysfspath and
devpath members that contain strings like the following example paths:



```bash
sysfspath: “/sys/class/fpga_region/region0/dfl-port.0”
devpath: “/dev/dfl-port.0”
```



<p align = "center">Figure 30 libxfpga Port Token</p><a name="figure-30"></a>

Likewise, a struct \_fpga\_token corresponding to the FME will have
sysfspath and devpath members that contain strings like the following
example paths:



```bash
sysfspath: “/sys/class/fpga_region/region0/dfl-fme.0”
devpath: “/dev/dfl-fme.0”
```



<p align = "center">Figure 31 libxfpga FME Token</p><a name="figure-31"></a>

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



<p align = "center">Figure 32 struct _fpga_handle</p><a name="figure-32"></a>

<a name="heading-2.3.3"></a>

### **2.3.3 libopae-v Plugin**

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



<p align = "center">Figure 33 vfio_token</p><a name="figure-33"></a>

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



<p align = "center">Figure 34 vfio_handle</p><a name="figure-34"></a>

<a name="heading-2.3.3.1"></a>

#### **2.3.3.1 Supporting Libraries**

<a name="heading-2.3.3.1.1"></a>

##### **2.3.3.1.1 libopaevfio**

[libopaevfio.so](https://github.com/OFS/opae-sdk/blob/master/include/opae/vfio.h)
is OPAE’s implementation of the Linux kernel’s Virtual Function I/O
interface. This VFIO interface presents a generic means of configuring
and accessing PCIe endpoints from a user-space process via a supporting
Linux kernel device driver, vfio-pci.

libopaevfio.so provides APIs for opening/closing a VFIO device instance,
for mapping/unmapping MMIO spaces, for allocating/freeing DMA buffers,
and for configuring interrupts for the device.

<a name="heading-2.3.3.1.2"></a>

##### **2.3.3.1.2 libopaemem**

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

<a name="heading-2.3.3.2"></a>

#### **2.3.3.2 Configuring PCIe Virtual Functions**

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
b1:00.3 Processing accelerators: Red Hat, Inc. Virtio network device
b1:00.4 Processing accelerators: Intel Corporation Device bcce
```


<p align = "center">Figure 35 lspci Device Topology</p><a name="figure-35"></a>

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



<p align = "center">Figure 36 Enable Virtual Functions</p><a name="figure-36"></a>

Figure 20 Enable Virtual Functions shows that three VF’s were created.
Each VF is shown as having the Arrow Creek VF PCIe device ID of bccf.

Now, each Virtual Function must be bound to the vfio-pci Linux kernel
driver so that it can be accessed via VFIO:



```bash
# opaevfio -i -u myuser -g mygroup 0000:b1:00.5
Binding (0x8086,0xbccf) at 0000:b1:00.5 to vfio-pci
iommu group for (0x8086,0xbccf) at 0000:b1:00.5 is 318
```



<p align = "center">Figure 37 Bind VF's to vfio-pci</p><a name="figure-37"></a>

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



<p align = "center">Figure 38 List VF's with fpgainfo</p><a name="figure-38"></a>

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


<p align = "center">Figure 39 Unbind VF's from vfio-pci</p><a name="figure-39"></a>

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



<p align = "center">Figure 40 Disable Virtual Functions</p><a name="figure-40"></a>

<a name = "heading-2.4"></a>

### **2.4 Application Flow**


A typical OPAE application that interacts with an AFU via MMIO and
shared memory will have a flow similar to the one described in this
section.

<a name="heading-2.4.1"></a>

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



<p align = "center">Figure 41 Flow: Create Filter Criteria</p><a name="figure-41"></a>

<a name="heading-2.4.2"></a>

#### **2.4.2 Enumerate the AFU**

With the filtering criteria in place, enumerate to obtain an fpga\_token
for the AFU:



```C
fpga_token afu_token = NULL;
uint32_t num_matches = 0;
fpgaEnumerate(&filter, 1, &afu_token, 1, &num_matches);
```



<p align = "center">Figure 42 Flow: Enumerate the AFU</p><a name="figure-42"></a>

<a name="heading-2.4.3"></a>

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



<p align = "center">Figure 43 Flow: Open the AFU</p><a name="figure-43"></a>

<a name="heading-2.4.4"></a>

#### **2.4.4 Map MMIO Region**

In order to access the MMIO region of the AFU to program its CSR’s, the
region must first be mapped into the application’s process address
space. This is accomplished using
[fpgaMapMMIO](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L182-L183)():



```C
uint32_t region = 0;
fpgaMapMMIO(afu_handle, region, NULL);
```



<p align = "center">Figure 44 Flow: Map MMIO Region</p><a name="figure-44"></a>

<a name="heading-2.4.5"></a>

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



<p align = "center">Figure 45 Flow: Allocate DMA Buffers</p><a name="figure-45"></a>

<a name="heading-2.4.6"></a>

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



<p align = "center">Figure 46 Flow: Make AFU Aware of DMA Buffers</p><a name="figure-46"></a>

<a name="heading-2.4.7"></a>

#### **2.4.7 Initiate an Acceleration Task**

With the shared buffer configuration complete, the AFU can be told to
initiate the acceleration task. This process is AFU-specific. The Native
Loopback AFU starts the acceleration task by writing a value to its
control CSR:



```C
#define CSR_CTRL 0x000D // AFU-specific
fpgaWriteMMIO32(afu_handle, 0, CSR_CTRL, 3);
```



<p align = "center">Figure 47 Initiate an Acceleration Task</p><a name="figure-47"></a>

<a name="heading-2.4.8"></a>

#### 2.4.8 Wait for Task Completion

Once the acceleration task is initiated, the application may poll the
AFU for a completion status. This process is AFU-specific. The AFU may
provide a status CSR for the application to poll; or the AFU may
communicate status to the application by means of a result code written
to a shared buffer.

<a name="heading-2.4.9"></a>

#### 2.4.9 Free DMA Buffers

When the acceleration task completes and the AFU is quiesced such that
there are no outstanding memory transactions targeted for the shared
memory, the DMA buffers can be unmapped and freed using
[fpgaReleaseBuffer](https://github.com/OFS/opae-sdk/blob/master/include/opae/buffer.h#L115)():



```C
fpgaReleaseBuffer(afu_handle, src_wsid);
fpgaReleaseBuffer(afu_handle, dest_wsid);
```



<p align = "center">Figure 48 Flow: Free DMA Buffers</p><a name="figure-48"></a>

<a name="heading-2.4.10"></a>

#### 2.4.10 Unmap MMIO Region

The MMIO regions should also be unmapped using
[fpgaUnmapMMIO](https://github.com/OFS/opae-sdk/blob/master/include/opae/mmio.h#L200-L201)():

```C
fpgaUnmapMMIO(afu_handle, region);
```
<br>

<p align = "center">Figure 49 Flow: Unmap MMIO Region</p><a name="figure-49"></a>

<a name="heading-2.4.11"></a>

#### **2.4.11 Close the AFU**

The AFU handle should be closed via
[fpgaClose](https://github.com/OFS/opae-sdk/blob/master/include/opae/access.h#L88)()
to release its resources:

<br>

```C
fpgaClose(afu_handle);
```

<br>

<a name="heading-2.4.12"></a>

<br>

#### 2.4.12 Release the Tokens and Properties

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


<p align = "center">Figure 51 Flow: Release the Tokens and Properties</p><a name="figure-51"></a>

<a name="heading-3.0"></a>

### **3.0 OPAE C++ API**

The OPAE C++ API refers to a C++ layer that sits on top of the OPAE C
API, providing object-oriented implementations of the main OPAE C API
abstractions: properties, tokens, handles, dma buffers, etc. Like the
OPAE C API, the [C++ API
headers](https://github.com/OFS/opae-sdk/tree/master/include/opae/cxx/core)
contain Doxygen markup for each of the provided classes.

<a name="heading-3.1"></a>

#### **3.1 libopae-cxx-core**

The implementation files for the C++ API are compiled into
libopae-cxx-core.so. A convenience header,
[core.h](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core.h),
provides a quick means of including each of the C++ API headers. Each of
the types comprising the C++ API is located within the opae::fpga::types
C++ namespace.

<a name="heading-3.1.1"></a>

##### **3.1.1 Properties**

Class
[properties](https://github.com/OFS/opae-sdk/blob/master/include/opae/cxx/core/properties.h#L41-L137)
provides the C++ implementation of the fpga\_properties type and its
associated APIs.

```C++
properties::ptr_t filter = properties::get();
```

<p align = "center">Figure 52 C++ Create New Empty Properties</p><a name="figure-52"></a>

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



<p align = "center">Figure 53 C++ Properties Set GUID and Type</p><a name="figure-53"></a>

<a name="heading-3.1.2"></a>

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



<p align = "center">Figure 54 C++ Enumeration</p><a name="figure-54"></a>

<a name="heading-3.1.3"></a>

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

<p align = "center">Figure 55 C++ Opening a Handle</p><a name="figure-55"></a>

<a name="heading-3.1.4"></a>

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



<p align = "center">Figure 56 C++ Allocate and Init Buffers</p><a name="figure-56"></a>

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



<p align = "center">Figure 57 C++ Make the AFU Aware of DMA Buffers</p><a name="figure-57"></a>

<a name="heading-3.1.5"></a>

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



<p align = "center">Figure 58 C++ Event Registration</p><a name="figure-58"></a>


<a name="heading-3.1.6"></a>

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

<p align = "center">Figure 59 C++ Query Device Errors</p><a name="figure-59"></a>

<a name="heading-3.1.7"></a>

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

<a name="heading-4.0"></a>

### **4.0 OPAE Python API**

The OPAE Python API refers to a Python layer that sits on top of the
OPAE C++ API, providing Python implementations of the OPAE C++ API
abstractions: properties, tokens, handles, dma buffers, etc.

<a name="heading-4.1"></a>

#### **4.1 \_opae**

The Python API is coded as a
[pybind11](https://pybind11.readthedocs.io/en/stable/) project, which
allows C++ code to directly interface with Python internals. Each C++
API concept is encoded into a Python equivalent. The functionality
exists as a Python extension module, compiled into \_opae.so.

<a name="heading-4.1.1"></a>

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



<p align = "center">Figure 60 Python Enumeration</p><a name="figure-60"></a>

The return value from the fpga.enumerate() function is a list of all the
token objects matching the search criteria.

<a name="heading-4.1.2"></a>

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



<p align = "center">Figure 61 Python Get Token Properties</p><a name="figure-61"></a>

Properties objects may also be created by invoking the fpga.properties()
constructor, passing the same keyword arguments as those to
fpga.enumerate(). Properties objects created in this way are also useful
for enumeration purposes:



```python
props = fpga.properties(type=fpga.ACCELERATOR)
tokens = fpga.enumerate([props])
```



<p align = "center">Figure 62 Python Properties Constructor</p><a name="figure-62"></a>

<a name="heading-4.1.3"></a>

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



<p align = "center">Figure 63 Python Tokens and SysObject API</p><a name="figure-63"></a>

Tokens also implement a find() method, which accepts a glob expression
in order to search sysfs. The following example finds the “id” sysfs
entry in the given token’s sysfs tree.



```python
my_id = tok.find(‘i?’)
print(f'{my_id.read64()}')
```



<p align = "center">Figure 64 Python Token Find</p><a name="figure-64"></a>

<a name="heading-4.1.4"></a>

##### **4.1.4 Handles**

Tokens are converted to handles by way of the fpga.open() function. The
flags (second) parameter to fpga.open() may be zero or
fpga.OPEN\_SHARED.



```python
with fpga.open(tok, fpga.OPEN_SHARED) as handle:
    use_the_handle(handle)
```



<p align = "center">Figure 65 Python Open Handle</p><a name="figure-65"></a>

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



<p align = "center">Figure 66 Python Handles and SysObject API</p><a name="figure-66"></a>

Partial reconfiguration is provided by class handle’s reconfigure()
method. The first parameter, slot, will be zero in most designs. The
second parameter is an opened file descriptor to the file containing the
GBS image. The third parameter, flags, defaults to zero.



```python
with open(‘my.gbs’, ‘rb’) as fd:
    handle.reconfigure(0, fd)
```


<p align = "center">Figure 67 Python Partial Reconfiguration</p><a name="figure-67"></a>

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



<p align = "center">Figure 68 Python Read/Write CSR</p><a name="figure-68"></a>

<a name="heading-4.1.5"></a>

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



<p align = "center">Figure 69 Python Allocate Shared Memory</p><a name="figure-69"></a>

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



<p align = "center">Figure 70 Python Buffer Fill, Copy, Compare</p><a name="figure-70"></a>

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



<p align = "center">Figure 71 Python Buffer Read and Write</p><a name="figure-71"></a>

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



<p align = "center">Figure 72 Python Buffer Poll</p><a name="figure-72"></a>

The shared\_buffer split() method allows creating two or more buffer
objects from one larger buffer object. The return value is a list of
shared\_buffer instances whose sizes match the arguments given to
split().



```python
b1, b2 = b1.split(2048, 2048)
print(f'b1 io_address: 0x{b1.io_address():0x}')
print(f'b2 io_address: 0x{b2.io_address():0x}')
```



<p align = "center">Figure 73 Python Splitting Buffer</p><a name="figure-73"></a>

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



<p align = "center">Figure 74 Python memoryview</p><a name="figure-74"></a>

<a name="heading-4.1.6"></a>

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



<p align = "center">Figure 75 Python Events</p><a name="figure-75"></a>

In addition to fpga.EVENT\_ERROR, fpga.EVENT\_INTERRUPT, and
fpga.EVENT\_POWER\_THERMAL are also supported.

<a name="heading-4.1.7"></a>

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



<p align = "center">Figure 76 Python Get Errors</p><a name="figure-76"></a>

<a name="heading-4.1.8"></a>

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



<p align = "center">Figure 77 Python sysobject as Bytes</p><a name="figure-77"></a>

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



<p align = "center">Figure 78 Python sysobject Container</p><a name="figure-78"></a>


<a name = "heading-5.0"></a>

### **5.0 Management Interfaces - opae.admin**

While the OPAE SDK C, C++, and Python APIs focus on presenting the AFU and all its related functionality to the end user, there is also a need for a maintenance functionality to aid in configuring the platform and performing secure firmware updates for the FPGA device and its components.  opae.admin is a Python framework which provides abstractions for performing these types of maintenance tasks on FPGA devices.  opae.admin provides Python classes which model the FPGA and the sysfs interfaces provided by the DFL drivers.

<a name="heading-5.1"></a>

#### **5.1 sysfs** 
opae.admin’s sysfs module provides abstractions for interacting with sysfs nodes, which comprise the base entity abstraction of opae.admin.

<a name="heading-5.1.1"></a>

#####	**5.1.1 sysfs_node**
A sysfs_node is an object that tracks a unique path within a sysfs directory tree.  sysfs_node provides methods for finding and constructing other sysfs_node objects, based on the root path of the parent sysfs_node object.  sysfs_node also provides a mechanism to read and write sysfs file contents.  sysfs_node serves as the base class for many of the sysfs module’s other classes.

<a name="heading-5.1.2"></a>

#####	**5.1.2 pci_node**
A pci_node is a sysfs_node that is rooted at /sys/bus/pci/devices.  Each pci_node has a unique PCIe address corresponding to the PCIe device it represents.  Methods for finding the pci_node’s children, for determining the PCIe device tree rooted at the node, for manipulating the node’s PCIe address, for determining the vendor and device ID’s, and for removing, unbinding, and rescanning the device are provided.

<a name="heading-5.1.3"></a>

#####	**5.1.3 sysfs_driver**
A sysfs_driver is a sysfs_node that provides a method for unbinding a sysfs_device object.

<a name="heading-5.1.4"></a>

#####	**5.1.4 sysfs_device**
A sysfs_device is a sysfs_node that is located under /sys/class or /sys/bus.  sysfs_device provides the basis for opae.admin’s FPGA enumeration capability.

<a name="heading-5.1.5"></a>

#####	**5.1.5 pcie_device**
A pcie_device is a sysfs_device that is rooted at /sys/bus/pci/devices.

<a name="heading-5.2"></a>

#### **5.2 fpga**
opae.admin’s fpga module provides classes which abstract an FPGA and its components.

<a name="heading-5.2.1"></a>

#####	**5.2.1 region**
A region is a sysfs_node that has an associated Linux character device, rooted at /dev.  Methods for opening the region’s character device file and for interacting with the character device via its IOCTL interface are provided.

<a name="heading-5.2.2"></a>

#####	**5.2.2 fme**
An fme is a region that represents an FPGA device’s FME component.  An fme provides accessors for the PR interface ID, the various bus paths that may exist under an FME, and the BMC firmware revision information.

<a name="heading-5.2.3"></a>

#####	**5.2.3 port**
A port is a region that represents an FPGA device’s Port component.  A port provides an accessor for the Port AFU ID.

<a name="heading-5.2.4"></a>

#####	**5.2.4 fpga_base**
An fpga_base is a sysfs_device that provides accessors for the FPGA device’s FME, for the FPGA device’s Port, and for the secure update sysfs controls.  fpga_base provides routines for enabling and disabling AER and for performing device RSU.

<a name="heading-5.2.5"></a>

#####	**5.2.5 fpga**
An fpga (derived from fpga_base) is the basis for representing the FPGA device in opae.admin.  Utilities such as fpgasupdate rely on fpga’s enum classmethod to enumerate all of the FPGA devices in the system.  In order for a device to enumerate via this mechanism, it must be bound to the dfl-pci driver at the time of enumeration.

<a name="heading-5.3"></a>

####	**5.3 opae.admin Utilities**
Several utilities are written on top of opae.admin’s class abstractions.  The following sections highlight some of the most commonly-used utilities.

<a name="heading-5.3.1"></a>

#####	**5.3.1 fpgasupdate**
fpgasupdate, or FPGA Secure Update, is used to apply firmware updates to the components of the FPGA.  As the name implies, these updates target a secure FPGA device, one that has the ability to implement a secure root of trust.
The command-line interface to fpgasupdate was designed to be as simple as possible for the end user.  The command simply takes a path to the firmware update file to be applied and the PCIe address of the targeted FPGA device.

```bash
# fpgasupdate update-file.bin 0000:b2:00.0
```

<p align = "center">Figure 79 fpgasupdate Interface</p><a name="figure-79"></a>

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


<p align = "center">Table 10 fpgasupdate Image Types</p><a name="table-10"></a>


<a name="heading-5.3.2"></a>

#####	**5.3.2 pci_device**
pci_device is a utility that provides a convenient interface to some of the Linux Kernel’s standard PCIe device capabilities.

<a name="heading-5.3.2.1"></a>

######	**5.3.2.1 pci_device aer subcommand**
The aer dump subcommand displays the Correctable, Fatal, and NonFatal device errors.

```bash
# pci_device 0000:b2:00.0 aer dump
```

<p align = "center">Figure 80 pci_device aer dump</p><a name="figure-80"></a>

The aer mask subcommand displays, masks, or unmasks errors using the syntax of the setpci command.

```bash
# pci_device 0000:b2:00.0 aer mask show
0x00010000 0x000031c1
# pci_device 0000:b2:00.0 aer mask all
# pci_device 0000:b2:00.0 aer mask off
# pci_device 0000:b2:00.0 aer mask 0x01010101 0x10101010
```

<p align = "center">Figure 81 pci_device aer mask</p><a name="figure-81"></a>

The aer clear subcommand clears the current errors.

```bash
# pci_device 0000:b2:00.0 aer clear
aer clear errors: 00000000
```
<p align = "center">Figure 82 pci_device aer clear</p><a name="figure-82"></a>

<a name="heading-5.3.2.2"></a>

######	**5.3.2.2 pci_device unbind subcommand**

The unbind subcommand unbinds the target device from the currently-bound device driver.

```bash
# pci_device 0000:b2:00.0 unbind
```
<p align = "center">Figure 83 pci_device unbind</p><a name="figure-83"></a>

In order to re-bind the device to a driver, eg dfl-pci, use the following commands:

```bash
# cd /sys/bus/pci/drivers/dfl-pci
# echo 0000:b2:00.0 > bind
```

<p align = "center">Figure 84 Re-binding a Driver</p><a name="figure-84"></a>

<a name="heading-5.3.2.3"></a>

######	**5.3.2.3 pci_device rescan subcommand**
The rescan subcommand triggers a PCIe bus rescan of all PCIe devices.

```bash
# pci_device 0000:b2:00.0 rescan
```

<p align = "center">Figure 85 pci_device rescan</p><a name="figure-85"></a>


<a name="heading-5.3.2.4"></a>

######	**5.3.2.4 pci_device remove subcommand**
The remove subcommand removes the target device from Linux kernel management.

```bash
# pci_device 0000:b2:00.0 remove
```

<p align = "center">Figure 86 pci_device remove</p><a name="figure-86"></a>

Note: a reboot may be required in order to re-establish the Linux kernel management for the device.

<a name="heading-5.3.2.5"></a>

######	**5.3.2.5 pci_device topology subcommand**

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

<p align = "center">Figure 87 pci_device topology</p><a name="figure-87"></a>

The green output indicates the target device.  The other endpoint devices are shown in blue.

<a name="heading-5.3.2.6"></a>

######	**5.3.2.6 pci_device vf subcommand**

The vf subcommand allows setting the value of the sriov_numvfs sysfs node of the target device.  This is useful in scenarios where device functionality is presented in the form of one or more PCIe Virtual Functions.

```bash
# pci_device 0000:b2:00.0 vf 3
# pci_device 0000:b2:00.0 vf 0

```
<p align = "center">Figure 88 pci_device vf</p><a name="figure-88"></a>

<a name="heading-5.3.3"></a>

#####	**5.3.3 rsu**
rsu is a utility that performs Remote System Update.  rsu is used subsequent to programming a firmware update or other supported file type with fpgasupdate, in order to reset the targeted FPGA entity so that a newly-loaded firmware image becomes active.

<a name="heading-5.3.3.1"></a>

######	**5.3.3.1 rsu bmc subcommand**
The bmc subcommand causes a Board Management Controller reset.  This command is used to apply a previous fpgasupdate of a BMC firmware image.  The --page argument selects the desired boot image.  Valid values for --page are ‘user’ and ‘factory’.


```bash
# rsu bmc --page user 0000:b2:00.0
# rsu bmc --page factory 0000:b2:00.0
```
<p align = "center">Figure 89 rsu bmc</p><a name="figure-89"></a>

<a name="heading-5.3.3.2"></a>

######	**5.3.3.2 rsu retimer subcommand**
The retimer subcommand causes a Parkvale reset (specific to Vista Creek).  This command is used to apply a previous fpgasupdate of a BMC firmware image (the Parkvale firmware is contained within the BMC firmware image).  The retimer subcommand causes only the Parkvale to reset.

```bash
# rsu retimer 0000:b2:00.0
```

<p align = "center">Figure 90 rsu retimer</p><a name="figure-90"></a>


<a name="heading-5.3.3.3"></a>

######	**5.3.3.3 rsu fpga subcommand**
The fpga subcommand causes a reconfiguration of the FPGA Static Region.  This command is used to apply a previous fpgasupdate of the Static Region image.  The --page argument selects the desired boot image.  Valid values for --page are ‘user1’, ‘user2’, and ‘factory’.


```bash
# rsu fpga --page user1 0000:b2:00.0
# rsu fpga --page user2 0000:b2:00.0
# rsu fpga --page factory 0000:b2:00.0
```

<p align = "center">Figure 91 rsu fpga</p><a name="figure-91"></a>

<a name="heading-5.3.3.4"></a>

######	**5.3.3.4 rsu sdm subcommand**
The sdm subcommand causes a reset of the Secure Device Manager.  This command is used to apply a previous fpgasupdate of the SDM image.

```bash
# rsu sdm 0000:b2:00.0
```

<p align = "center">Figure 92 rsu sdm</p><a name="figure-92"></a>

<a name="heading-5.3.3.5"></a>

######	**5.3.3.5 rsu fpgadefault subcommand**
The fpgadefault subcommand can be used to display the default FPGA boot sequence; and it can be used to select the image to boot on the next reset of the FPGA.
When given without additional parameters, the fpgadefault subcommand displays the default FPGA boot sequence:


```bash
# rsu fpgadefault 0000:b2:00.0
```

<p align = "center">Figure 93 rsu Displaying FPGA Boot Sequence</p><a name="figure-93"></a>

The parameters to the fpgadefault subcommand are --page and --fallback.  The --page parameter accepts ‘user1’, ‘user2’, or ‘factory’, specifying the desired page to boot the FPGA from on the next reset.  Note that this subcommand does not actually cause the reset to occur.  Please refer to rsu fpga subcommand for an example of resetting the FPGA using the rsu command.


```bash
# rsu fpgadefault --page user1 0000:b2:00.0
# rsu fpgadefault --page user2 0000:b2:00.0
# rsu fpgadefault --page factory 0000:b2:00.0
```

<p align = "center">Figure 94 rsu Select FPGA Boot Image</p><a name="figure-94"></a>

The --fallback parameter accepts a comma-separated list of the keywords ‘user1’, ‘user2’, and ‘factory’.  These keywords, in conjunction with the --page value are used to determine a fallback boot sequence for the FPGA.
The fallback boot sequence is used to determine which FPGA image to load in the case of a boot failure.  For example, given the following command, the FPGA would attempt to boot in the order ‘factory’, ‘user1’, ‘user2’.  That is to say, if the ‘factory’ image failed to boot, then the ‘user1’ image would be tried.  Failing to boot ‘user1’, the ‘user2’ image would be tried.


```bash
# rsu fpgadefault --page factory --fallback user1,user2 0000:b2:00.0
```

<p align = "center">Figure 95 rsu Select FPGA Boot Image and Fallback</p><a name="figure-95"></a>


<a name="heading-6.0"></a>

### **6.0 Sample Applications**

<a name="heading-6.1"></a>

#### **6.1 afu-test Framework**

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



<p align = "center">Figure 96 C++ class afu</p><a name="figure-96"></a>

The afu class constructor initializes the CLI11 command parser with some
general, application-wide parameters.

| Subcommand| Description |
| ----------------- | ------------------------------------ |
| \-g,--guid        | Accelerator AFU ID.                  |
| \-p,--pci-address | Address of the accelerator device.   |
| \-l,--log-level   | Requested spdlog output level.       |
| \-s,--shared      | Open the AFU in shared mode?         |
| \-t,--timeout     | Application timeout in milliseconds. |

<p align = "center">Figure 97 class afu Application Parameters</p><a name="figure-97"></a>

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


<p align = "center">Figure 98 hssi's app.register_command()</p><a name="figure-98"></a>

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



<p align = "center">Figure 99 class command</p><a name="figure-99"></a>

The name() member function gives the unique command name. Some examples
of names from the hssi app are hssi\_10g, hssi\_100g, pkt\_filt\_10g,
and pkt\_filt\_100g. The description() member function gives a brief
description that is included in the command-specific help output.
add\_options() adds command-specific command-line options. afu\_id()
gives the AFU ID for the command, in string form. Finally, run()
implements the command-specific test functionality.


<a name="heading-6.2"></a>

#### **6.2 afu-test Based Samples**

<a name="heading-6.2.1"></a>

##### **6.2.1 dummy\_afu**

The dummy\_afu application is a afu-test based application that
implements three commands: mmio, ddr, and lpbk.


| Target|Description |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| \# dummy\_afu [mmio](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/mmio.h#L131-L152) | Targets special scratchpad area implemented by the AFU. |
| \# dummy\_afu [ddr](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/ddr.h#L60-L103)    | Execute dummy\_afu-specific DDR test.                   |
| \# dummy\_afu [lpbk](https://github.com/OFS/opae-sdk/blob/master/samples/dummy_afu/lpbk.h#L50-L65)   | Execute a simple loopback test.                         |

<a name="heading-6.2.2"></a>

##### **6.2.2 host\_exerciser**

[host\_exerciser](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/host_exerciser/host_exerciser.md)
markdown document.

<a name="heading-6.2.3"></a>

##### **6.2.3 hssi**

[hssi](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/hssi/hssi.md)
markdown document.

<a name="heading-7.0"></a>

###  **7.0 Other Utilities**

<a name="heading-7.1"></a>

#### **7.1 opae.io**

[opae.io](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/opae.io/opae.io.md)
markdown document.

<a name="heading-7.2"></a>

#### **7.2 bitstreaminfo**

The bitstreaminfo command prints diagnostic information about firmware
image files that have been passed through the PACSign utility. PACSign
prepends secure block 0 and secure block 1 data headers to the images
that it processes. These headers contain signature hashes and other
metadata that are consumed by the BMC firmware during a secure update.

To run bitstreaminfo, pass the path to the desired firmware image file:

```bash
# bitstreaminfo my_file.bin 
```

<p align = "center">Figure 100 Running bitstreaminfo</p><a name="figure-100"></a>

<a name="heading-7.3"></a>

#### **7.3 fpgareg**

The fpgareg command prints the register spaces for the following fpga
device components:

| Command| Description|
| ---------------------------- | ----------------------------------------- |
| \# fpgareg 0000:b1:00.0 pcie | Walks and prints the DFL for the device.  |
| \# fpgareg 0000:b1:00.0 bmc  | Prints the BMC registers for the device.  |
| \# fpgareg 0000:b1:00.0 hssi | Prints the HSSI registers for the device. |
| \# fpgareg 0000:b1:00.0 acc  | Prints the AFU register spaces.           |

<p align = "center">Figure 101 fpgareg Commands</p><a name="figure-101"></a>

Note that fpgareg is only available as of Arrow Creek ADP and forward.
It will not work with prior platforms, eg N3000.

<a name="heading-7.4"></a>

#### **7.4 opaevfio**

[opaevfio](https://github.com/OFS/opae-sdk/blob/master/doc/src/fpga_tools/opaevfio/opaevfio.md)
markdown document.


<a name="heading-8.0"></a>

###  **8.0 Building OPAE**

The OPAE SDK uses the cmake build and configuration system, version >=
3.10. The basic steps required to build the SDK from source are:


Install prerequisite packages.

```bash
$ git clone <https://github.com/OFS/opae-sdk.git>
$ cd opae-sdk
$ mkdir build
$ cd build
$ cmake .. <cmake options>
$ make

```

<a name="heading-8.1"></a>

#### **8.1 Installing Prerequisite Packages**

The OPAE SDK is intended to build and run on modern Linux distributions.
The SDK contains a set of system configuration scripts to aid the system
configuration process.

| Script| Target Operating System|
| ------------------------------------------------------------------------- | ---------------- |
| [centos.sh](https://github.com/OFS/opae-sdk/blob/master/setup/centos.sh) | CentOS 8.x       |
| [fedora.sh](https://github.com/OFS/opae-sdk/blob/master/setup/fedora.sh) | Fedora 33/34     |
| [ubuntu.sh](https://github.com/OFS/opae-sdk/blob/master/setup/ubuntu.sh) | Ubuntu 20.04 LTS |

<p align = "center">Table 11 System Configuration Scripts</p><a name="table-11"></a>

<a name="heading-8.2"></a>

#### **8.2 Cloning the SDK repository**

```bash
$ git clone https://github.com/OFS/opae-sdk.git
```

<a name="heading-8.3"></a>

##### **8.3 CMake Options**

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

<p align = "center">Table 12 CMake Options</p><a name="table-12"></a>

<a name="heading-8.4"></a>

#### **8.4 Building OPAE for Debug**

```bash
$ cmake .. -DCMAKE_BUILD_TYPE=Debug
```

<a name="heading-8.5"></a>

#### **8.5 Creating RPMs**

To ease the RPM creation process, the OPAE SDK provides a simple RPM
creation script. The parameters to the RPM create script are fedora or
rhel, depending on which distribution is targeted. For rhel, the build
flag -DOPAE\_MINIMAL\_BUILD is set to ON, omitting the binaries which
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
$ ./packaging/opae/rpm/create fedora
-OR-
$ ./packaging/opae/rpm/create rhel
```



<p align = "center"> Figure 102 RPM Creation</p><a name="figure-102"></a>

After running the create script, the RPM files will be located in the
packaging/opae/rpm directory.

<a name="heading-8.5.1"></a>

##### **8.5.1 Updating the RPM Version Information**

The RPMs will be versioned according to the information found in the
file
[packaging/opae/version](https://github.com/OFS/opae-sdk/blob/master/packaging/opae/version#L27-L28).
Edit this file to update the version information, then re-run the create
script to create the RPMs.


<a name = "heading-9.0"></a>

### **9.0 Debugging OPAE**

<a name="heading-9.1"></a>

#### **9.1	Enabling Debug Logging**

The OPAE SDK has a built-in debug logging facility.  To enable it, set the cmake flag `-DCMAKE_BUILD_TYPE=Debug` and then use the following environment variables:
| Variable| Description|
| ----- | ----- |
|LIBOPAE_LOG=1|	Enable debug logging output.  When not set, only critical error messages are displayed.|
|LIBOPAE_LOGFILE=file.log|	Capture debug log output to file.log.  When not set, the logging appears on stdout and stderr.  The file must appear in a relative path or it can be rooted at /tmp.|

<p align = "center"> Table 13 Logging Environment Variables</p><a name="table-13"></a>

<a name="heading-9.2"></a>

#### **9.2 GDB**
To enable gdb-based debugging, the cmake configuration step must specify a value for -DCMAKE_BUILD_TYPE of either Debug or RelWithDebInfo so that debug symbols are included in the output binaries.
The OPAE SDK makes use of dynamically-loaded library modules.  When debugging with gdb, the best practice is to remove all OPAE SDK libraries from the system installation paths to ensure that library modules are only loaded from the local build tree:

```bash
$ cd opae-sdk/build
$ LD_LIBRARY_PATH=$PWD/lib gdb --args <some_opae_executable> <args>
```

<p align = "center">Figure 103 Debugging with GDB</p><a name="figure-103"></a>

<a name = "heading-10.0"></a>

### **10.0 Adding New Device Support**

As of OPAE 2.2.0 the SDK has transitioned to a single configuration file model.  The libraries, plugins, and applications obtain their runtime configuration during startup by examining a single JSON configuration file.  In doing so, the original configuration file formats for libopae-c and fpgad have been deprecated in favor of the respective sections in the new configuration file. 

####	**10.1 Configuration File Search Order**
By default the OPAE SDK will install its configuration file to /etc/opae/opae.cfg. 


```C
/etc/opae/opae.cfg 
```


<p align = "center">Figure 104 Default Configuration File</p><a name="figure-104"></a>


The SDK searches for the configuration file during startup by employing the following search algorithm: 

First, the environment variable LIBOPAE_CFGFILE is examined.  If it is set to a path that represents a valid path to a configuration file, then that configuration file path is used, and the search is complete. 

Next, the HOME environment variable is examined.  If its value is valid, then it is prepended to the following set of relative paths.  If HOME is not set, then the search continues with the value of the current user’s home path as determined by getpwuid().  The home path, if any, determined by getpwuid() is prepended to the following set of relative paths.  Searching completes successfully if any of these home-relative search paths is valid. 

```C
/.local/opae.cfg 

/.local/opae/opae.cfg 

/.config/opae/opae.cfg 
```

<p align = "center">Figure 105 HOME Relative Search Paths</p><a name="figure-105"></a>

Finally, the configuration file search continues with the following system-wide paths.  If any of these paths is found to contain a configuration file, then searching completes successfully. 

```C
usr/local/etc/opae/opae.cfg 

/etc/opae/opae.cfg 
```

<p align = "center">Figure 106 System Search Paths</p><a name="figure-106"></a>

If the search exhausts all of the possible configuration file locations without finding a configuration file, then an internal default configuration is used.  This internal default configuration matches that of the opae.cfg file shipped with the OPAE SDK. 

####	**10.2 Configuration File Format **
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

<p align = "center">Figure 107 Keyed Configurations</p><a name="figure-107"></a>

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
<p align = "center">Figure 108 Configurations Format</p><a name="figure-108"></a>

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

<p align = "center">Figure 109 "opae" / "plugin" key/</p><a name="figure-109"></a>

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

<p align = "center">Figure 110 "opae" / "fpgainfo" key</p><a name="figure-110"></a>


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

<p align = "center">Figure 111 "opae" / "fpgad" key </p><a name="figure-111"></a>


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

<p align = "center">Figure 112 "opae" / "rsu" key  </p><a name="figure-112"></a>

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

<p align = "center">Figure 113 "opae" / "fpgareg" key   </p><a name="figure-113"></a>


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

<p align = "center">Figure 114 "opae" / "opae.io" key    </p><a name="figure-114"></a>

If the “enabled” key is false or if it is omitted, then that “opae.io” array entry is skipped, and parsing continues.  When disabled, the device(s) mentioned in that array entry will continue to be available for the opae.io command.  The device(s) platform string will not be shown in the `opae.io ls` command.  The “devices” array lists one or more PF/VF identifiers.  Each array value must be a string, and it must match a device that is described in the “configurations” “devices” section.   

Libxfpga – Updating the Metrics API 

Edit libraries/plugins/xfpga/sysfs.c.  Find the definition of the opae_id_to_hw_type() function.  Update the function to add the new vendor/device ID to hw_type mapping. 

This mapping is used by the SDK’s metrics API to determine the method of accessing the board sensor information and is very specific to the underlying BMC implementation.  It may be necessary to add a new hw_type value and to update the logic in libraries/plugins/xfpga/metrics. 

<a name = "heading-11.0"></a>

## **11.0 DFL Linux Kernel Drivers**

OFS DFL driver software provides the bottom-most API to FPGA platforms. Libraries such as OPAE and frameworks such as DPDK are consumers of the APIs provided by OFS. Applications may be built on top of these frameworks and libraries. The OFS software does not cover any out-of-band management interfaces. OFS driver software is designed to be extendable, flexible, and provide for bare-metal and virtualized functionality.

The OFS driver software can be found in the[OFS repository - linux-dfl](https://github.com/OFS/linux-dfl), under the linux-dfl specific category. This repository has an associated [OFS repository - linux-dfl - wiki page](https://github.com/OFS/linux-dfl/wiki) that includes the following information:
- An description of the three available branch archetypes
- Configuration tweaks required while building the kernel
- A functional description of the available DFL framework
- Descriptions for all currently available driver modules that support FPGA DFL board solutions
- Steps to create a new DFL driver
- Steps to port a DFL driver patch


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
 
