
# File error.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**error.h**](error_8h.md)

[Go to the source code of this file.](error_8h_source.md)

_Functions for reading and clearing errors in resources._ [More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaClearAllErrors**](#function-fpgaclearallerrors) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token) <br>_Clear all error registers of a particular resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaClearError**](#function-fpgaclearerror) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, uint32\_t error\_num) <br>_Clear error register._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetErrorInfo**](#function-fpgageterrorinfo) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, uint32\_t error\_num, struct [**fpga\_error\_info**](structfpga__error__info.md) \* error\_info) <br>_Get information about a particular error register._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReadError**](#function-fpgareaderror) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, uint32\_t error\_num, uint64\_t \* value) <br>_Read error value._  |








# Detailed Description


Many FPGA resources have the ability to track the occurrence of errors. This file provides functions to retrieve information about errors within resources. 


    
## Public Functions Documentation


### function fpgaClearAllErrors 

_Clear all error registers of a particular resource._ 
```C++
fpga_result fpgaClearAllErrors (
    fpga_token token
) 
```



This function will clear all error registers of the resource referenced by `token`, observing the necessary order of clearing errors, if any.




**Parameters:**


* `token` Token to accelerator resource to query 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the token, and FPGA\_BUSY if error could not be cleared. 





        

### function fpgaClearError 

_Clear error register._ 
```C++
fpga_result fpgaClearError (
    fpga_token token,
    uint32_t error_num
) 
```



This function will clear the error register `error_num` of the resource referenced by `token`.




**Parameters:**


* `token` Token to accelerator resource to query 
* `error_num` Number of error register to clear 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the token, and FPGA\_BUSY if error could not be cleared. 





        

### function fpgaGetErrorInfo 

_Get information about a particular error register._ 
```C++
fpga_result fpgaGetErrorInfo (
    fpga_token token,
    uint32_t error_num,
    struct fpga_error_info * error_info
) 
```



This function will populate a `fpga_error_info` struct with information about error number `error_num` of the resource referenced by `token`.




**Parameters:**


* `token` Token to accelerator resource to query 
* `error_num` Error register to retrieve information about 
* `error_info` Pointer to memory to store information into 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the token. 





        

### function fpgaReadError 

_Read error value._ 
```C++
fpga_result fpgaReadError (
    fpga_token token,
    uint32_t error_num,
    uint64_t * value
) 
```



This function will read the value of error register `error_num` of the resource referenced by `token` into the memory location pointed to by `value`.




**Parameters:**


* `token` Token to accelerator resource to query 
* `error_num` Number of error register to read 
* `value` Pointer to memory to store error value into (64 bit) 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the token. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/error.h`