
# File access.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**access.h**](access_8h.md)

[Go to the source code of this file.](access_8h_source.md)

_Functions to acquire, release, and reset OPAE FPGA resources._ 

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaClose**](#function-fpgaclose) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle) <br>_Close a previously opened FPGA object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaOpen**](#function-fpgaopen) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, [**fpga\_handle**](types_8h.md#typedef-fpga_handle) \* handle, int flags) <br>_Open an FPGA object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReset**](#function-fpgareset) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle) <br>_Reset an FPGA object._  |








## Public Functions Documentation


### function fpgaClose 

_Close a previously opened FPGA object._ 
```C++
fpga_result fpgaClose (
    fpga_handle handle
) 
```



Relinquishes ownership of a previously [**fpgaOpen()**](access_8h.md#function-fpgaopen)ed resource. This enables others to acquire ownership if the resource was opened exclusively. Also deallocates / unmaps MMIO and UMsg memory areas.




**Parameters:**


* `handle` Handle to previously opened FPGA object 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if handle does not refer to an acquired resource, or if handle is NULL. FPGA\_EXCEPTION if an internal error occurred while accessing the handle. 





        

### function fpgaOpen 

_Open an FPGA object._ 
```C++
fpga_result fpgaOpen (
    fpga_token token,
    fpga_handle * handle,
    int flags
) 
```



Acquires ownership of the FPGA resource referred to by 'token'.


Most often this will be used to open an accelerator object to directly interact with an accelerator function, or to open an FPGA object to perform management functions.




**Parameters:**


* `token` Pointer to token identifying resource to acquire ownership of 
* `handle` Pointer to preallocated memory to place a handle in. This handle will be used in subsequent API calls. 
* `flags` One of the following flags:
  * FPGA\_OPEN\_SHARED allows the resource to be opened multiple times (not supported in ASE) Shared resources (including buffers) are released when all associated handles have been closed (either explicitly with [**fpgaClose()**](access_8h.md#function-fpgaclose) or by process termination). 





**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the resource for 'token' could not be found. FPGA\_INVALID\_PARAM if 'token' does not refer to a resource that can be opened, or if either argument is NULL or invalid. FPGA\_EXCEPTION if an internal exception occurred while creating the handle. FPGA\_NO\_DRIVER if the driver is not loaded. FPGA\_BUSY if trying to open a resource that has already been opened in exclusive mode. FPGA\_NO\_ACCESS if the current process' privileges are not sufficient to open the resource. 





        

### function fpgaReset 

_Reset an FPGA object._ 
```C++
fpga_result fpgaReset (
    fpga_handle handle
) 
```



Performs an accelerator reset.




**Parameters:**


* `handle` Handle to previously opened FPGA object 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if handle does not refer to an acquired resource or to a resource that cannot be reset. FPGA\_EXCEPTION if an internal error occurred while trying to access the handle or resetting the resource. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/access.h`