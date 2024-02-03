
# File umsg.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**umsg.h**](umsg_8h.md)

[Go to the source code of this file.](umsg_8h_source.md)

_FPGA UMsg API._ 

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetNumUmsg**](#function-fpgagetnumumsg) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t \* value) <br>_Get number of Umsgs._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetUmsgPtr**](#function-fpgagetumsgptr) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t \*\* umsg\_ptr) <br>_Access UMsg memory directly._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaSetUmsgAttributes**](#function-fpgasetumsgattributes) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t value) <br>_Sets Umsg hint._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaTriggerUmsg**](#function-fpgatriggerumsg) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t value) <br>_Trigger Umsg._  |








## Public Functions Documentation


### function fpgaGetNumUmsg 

_Get number of Umsgs._ 
```C++
fpga_result fpgaGetNumUmsg (
    fpga_handle handle,
    uint64_t * value
) 
```



Retuns number of umsg supported by AFU.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `value` Returns number of UMsgs 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if input parameter combination is not valid. FPGA\_EXCEPTION if input parameter fpga handle is not valid. 





        

### function fpgaGetUmsgPtr 

_Access UMsg memory directly._ 
```C++
fpga_result fpgaGetUmsgPtr (
    fpga_handle handle,
    uint64_t ** umsg_ptr
) 
```



This function will return a pointer to the memory allocated for low latency accelerator notifications (UMsgs).




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `umsg_ptr` Pointer to memory where a pointer to the virtual address space will be returned 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if input parameter combination is not valid. FPGA\_EXCEPTION if input parameter fpga handle is not valid. FPGA\_NO\_MEMORY if memory allocation fails or system doesn't configure huge pages. 





        

### function fpgaSetUmsgAttributes 

_Sets Umsg hint._ 
```C++
fpga_result fpgaSetUmsgAttributes (
    fpga_handle handle,
    uint64_t value
) 
```



Writes usmg hint bit.




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `value` Value to use for UMsg hint, Umsg hit is N wide bitvector where N = number of Umsgs. 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if input parameter combination is not valid. FPGA\_EXCEPTION if input parameter fpga handle is not valid. 





        

### function fpgaTriggerUmsg 

_Trigger Umsg._ 
```C++
fpga_result fpgaTriggerUmsg (
    fpga_handle handle,
    uint64_t value
) 
```



Writes a 64-bit value to trigger low-latency accelerator notification mechanism (UMsgs).




**Parameters:**


* `handle` Handle to previously opened accelerator resource 
* `value` Value to use for UMsg 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if input parameter combination is not valid. FPGA\_EXCEPTION if input parameter fpga handle is not valid. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/umsg.h`