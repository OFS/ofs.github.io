
# File mmio.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**mmio.h**](mmio_8h.md)

[Go to the source code of this file.](mmio_8h_source.md)

_Functions for mapping and accessing MMIO space._ [More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaMapMMIO**](#function-fpgamapmmio) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t \*\* mmio\_ptr) <br>_Map MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReadMMIO32**](#function-fpgareadmmio32) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t offset, uint32\_t \* value) <br>_Read 32 bit value from MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReadMMIO64**](#function-fpgareadmmio64) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t offset, uint64\_t \* value) <br>_Read 64 bit value from MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaUnmapMMIO**](#function-fpgaunmapmmio) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num) <br>_Unmap MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaWriteMMIO32**](#function-fpgawritemmio32) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t offset, uint32\_t value) <br>_Write 32 bit value to MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaWriteMMIO512**](#function-fpgawritemmio512) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t offset, const void \* value) <br>_Write 512 bit value to MMIO space._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaWriteMMIO64**](#function-fpgawritemmio64) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint32\_t mmio\_num, uint64\_t offset, uint64\_t value) <br>_Write 64 bit value to MMIO space._  |








# Detailed Description


Most FPGA accelerators provide access to control registers through memory-mappable address spaces, commonly referred to as "MMIO spaces". This file provides functions to map, unmap, read, and write MMIO spaces.


Note that an accelerator may have multiple MMIO spaces, denoted by the `mmio_num` argument of the APIs below. The meaning and properties of each MMIO space are up to the accelerator designer. 


    
## Public Functions Documentation


### function fpgaMapMMIO 

_Map MMIO space._ 
```C++
fpga_result fpgaMapMMIO (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t ** mmio_ptr
) 
```



This function will return a pointer to the specified MMIO space of the target object in process virtual memory, if supported by the target. Some MMIO spaces may be restricted to privileged processes, depending on the used handle and type.


After mapping the respective MMIO space, you can access it through direct pointer operations (observing supported access sizes and alignments of the target platform and accelerator).




**Note:**

Some targets (such as the ASE simulator) do not support memory-mapping of IO register spaces and will not return a pointer to an actually mapped space. Instead, they will return `FPGA_NOT_SUPPORTED`. Usually, these platforms still allow the application to issue MMIO operations using [**fpgaReadMMIO32()**](mmio_8h.md#function-fpgareadmmio32), [**fpgaWriteMMIO32()**](mmio_8h.md#function-fpgawritemmio32), fpgeReadMMIO64(), and [**fpgaWriteMMIO64()**](mmio_8h.md#function-fpgawritemmio64).


If the caller passes in NULL for mmio\_ptr, no mapping will be performed, and no virtual address will be returned, though the call will return `FPGA_OK`. This implies that all accesses will be performed through [**fpgaReadMMIO32()**](mmio_8h.md#function-fpgareadmmio32), [**fpgaWriteMMIO32()**](mmio_8h.md#function-fpgawritemmio32), fpgeReadMMIO64(), and [**fpgaWriteMMIO64()**](mmio_8h.md#function-fpgawritemmio64). This is the only supported case for ASE.


The number of available MMIO spaces can be retrieved through the num\_mmio property (fpgaPropertyGetNumMMIO()).




**Parameters:**


* `handle` Handle to previously opened resource 
* `mmio_num` Number of MMIO space to access 
* `mmio_ptr` Pointer to memory where a pointer to the MMIO space will be returned. May be NULL, in which case no pointer is returned. Returned address may be NULL if underlying platform does not support memory mapping for register access. 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. FPGA\_NO\_ACCESS if the process' permissions are not sufficient to map the requested MMIO space. FPGA\_NOT\_SUPPORTED if platform does not support memory mapped IO. 





        

### function fpgaReadMMIO32 

_Read 32 bit value from MMIO space._ 
```C++
fpga_result fpgaReadMMIO32 (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t offset,
    uint32_t * value
) 
```



This function will read from MMIO space of the target object at a specified offset.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `mmio_num` Number of MMIO space to access 
* `offset` Byte offset into MMIO space 
* `value` Pointer to memory where read value is returned (32 bit) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaReadMMIO64 

_Read 64 bit value from MMIO space._ 
```C++
fpga_result fpgaReadMMIO64 (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t offset,
    uint64_t * value
) 
```



This function will read from MMIO space of the target object at a specified offset.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `mmio_num` Number of MMIO space to access 
* `offset` Byte offset into MMIO space 
* `value` Pointer to memory where read value is returned (64 bit) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaUnmapMMIO 

_Unmap MMIO space._ 
```C++
fpga_result fpgaUnmapMMIO (
    fpga_handle handle,
    uint32_t mmio_num
) 
```



This function will unmap a previously mapped MMIO space of the target object, rendering any pointers to it invalid.




**Note:**

This call is only supported by hardware targets, not by ASE simulation.




**Parameters:**


* `handle` Handle to previously opened resource 
* `mmio_num` Number of MMIO space to access 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaWriteMMIO32 

_Write 32 bit value to MMIO space._ 
```C++
fpga_result fpgaWriteMMIO32 (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t offset,
    uint32_t value
) 
```



This function will write to MMIO space of the target object at a specified offset.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `mmio_num` Number of MMIO space to access 
* `offset` Byte offset into MMIO space 
* `value` Value to write (32 bit) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaWriteMMIO512 

_Write 512 bit value to MMIO space._ 
```C++
fpga_result fpgaWriteMMIO512 (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t offset,
    const void * value
) 
```



512 bit MMIO writes may not be supported on all platforms.


This function will write to MMIO space of the target object at a specified offset.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `mmio_num` Number of MMIO space to access 
* `offset` Byte offset into MMIO space 
* `value` Pointer to memory holding value to write (512 bits) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaWriteMMIO64 

_Write 64 bit value to MMIO space._ 
```C++
fpga_result fpgaWriteMMIO64 (
    fpga_handle handle,
    uint32_t mmio_num,
    uint64_t offset,
    uint64_t value
) 
```



This function will write to MMIO space of the target object at a specified offset.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `mmio_num` Number of MMIO space to access 
* `offset` Byte offset into MMIO space 
* `value` Value to write (64 bit) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/mmio.h`