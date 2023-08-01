
# File buffer.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**buffer.h**](buffer_8h.md)

[Go to the source code of this file.](buffer_8h_source.md)

_Functions for allocating and sharing system memory with an FPGA accelerator._ [More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetIOAddress**](#function-fpgagetioaddress) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t wsid, uint64\_t \* ioaddr) <br>_Retrieve base IO address for buffer._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPrepareBuffer**](#function-fpgapreparebuffer) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t len, void \*\* buf\_addr, uint64\_t \* wsid, int flags) <br>_Prepare a shared memory buffer._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReleaseBuffer**](#function-fpgareleasebuffer) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t wsid) <br>_Release a shared memory buffer._  |








# Detailed Description


To share memory between a software application and an FPGA accelerator, these functions set up system components (e.g. an IOMMU) to allow accelerator access to a provided memory region.


There are a number of restrictions on what memory can be shared, depending on platform capabilities. Usually, FPGA accelerators to not have access to virtual address mappings of the CPU, so they can only access physical addresses. To support this, the OPAE C library on Linux uses hugepages to allocate large, contiguous pages of physical memory that can be shared with an accelerator. It also supports sharing memory that has already been allocated by an application, as long as that memory satisfies the requirements of being physically contigous and page-aligned. 


    
## Public Functions Documentation


### function fpgaGetIOAddress 

_Retrieve base IO address for buffer._ 
```C++
fpga_result fpgaGetIOAddress (
    fpga_handle handle,
    uint64_t wsid,
    uint64_t * ioaddr
) 
```



This function is used to acquire the physical base address (on some platforms called IO Virtual Address or IOVA) for a shared buffer identified by wsid.




**Note:**

This function will disappear once the APIs for secure sharing of buffer addresses is implemented.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `wsid` Buffer handle / workspace ID referring to the buffer for which the IO address is requested 
* `ioaddr` Pointer to memory where the IO address will be returned 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if invalid parameters were provided, or if the parameter combination is not valid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. FPGA\_NOT\_FOUND if `wsid` does not refer to a previously shared buffer. 





        

### function fpgaPrepareBuffer 

_Prepare a shared memory buffer._ 
```C++
fpga_result fpgaPrepareBuffer (
    fpga_handle handle,
    uint64_t len,
    void ** buf_addr,
    uint64_t * wsid,
    int flags
) 
```



Prepares a memory buffer for shared access between an accelerator and the calling process. This may either include allocation of physical memory, or preparation of already allocated memory for sharing. The latter case is indicated by supplying the FPGA\_BUF\_PREALLOCATED flag.


This function will ask the driver to pin the indicated memory (make it non-swappable), and program the IOMMU to allow access from the accelerator. If the buffer was not pre-allocated (flag FPGA\_BUF\_PREALLOCATED), the function will also allocate physical memory of the requested size and map the memory into the caller's process' virtual address space. It returns in 'wsid' an fpga\_buffer object that can be used to program address registers in the accelerator for shared access to the memory.


When using FPGA\_BUF\_PREALLOCATED, the input len must be a non-zero multiple of the page size, else the function returns FPGA\_INVALID\_PARAM. When not using FPGA\_BUF\_PREALLOCATED, the input len is rounded up to the nearest multiple of page size.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `len` Length of the buffer to allocate/prepare in bytes 
* `buf_addr` Virtual address of buffer. Contents may be NULL (OS will choose mapping) or non-NULL (OS will take contents as a hint for the virtual address). 
* `wsid` Handle to the allocated/prepared buffer to be used with other functions 
* `flags` Flags. FPGA\_BUF\_PREALLOCATED indicates that memory pointed at in '\*buf\_addr' is already allocated an mapped into virtual memory. FPGA\_BUF\_READ\_ONLY pins pages with only read access from the FPGA. 



**Returns:**

FPGA\_OK on success. FPGA\_NO\_MEMORY if the requested memory could not be allocated. FPGA\_INVALID\_PARAM if invalid parameters were provided, or if the parameter combination is not valid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle.




**Note:**

As a special case, when FPGA\_BUF\_PREALLOCATED is present in flags, if len == 0 and buf\_addr == NULL, then the function returns FPGA\_OK if pre-allocated buffers are supported. In this case, a return value other than FPGA\_OK indicates that pre-allocated buffers are not supported. 





        

### function fpgaReleaseBuffer 

_Release a shared memory buffer._ 
```C++
fpga_result fpgaReleaseBuffer (
    fpga_handle handle,
    uint64_t wsid
) 
```



Releases a previously prepared shared buffer. If the buffer was allocated using fpgaPrepareBuffer (FPGA\_BUF\_PREALLOCATED was not specified), this call will deallocate/free that memory. Otherwise, it will only be returned to it's previous state (pinned/unpinned, cached/non-cached).




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `wsid` Handle to the allocated/prepared buffer 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if invalid parameters were provided, or if the parameter combination is not valid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/buffer.h`