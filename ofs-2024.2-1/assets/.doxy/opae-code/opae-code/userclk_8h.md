
# File userclk.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**userclk.h**](userclk_8h.md)

[Go to the source code of this file.](userclk_8h_source.md)

_Functions for setting and get afu user clock._ 

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetUserClock**](#function-fpgagetuserclock) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t \* high\_clk, uint64\_t \* low\_clk, int flags) <br>_Get afu user clock high and low._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaSetUserClock**](#function-fpgasetuserclock) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t high\_clk, uint64\_t low\_clk, int flags) <br>_set afu user clock high and low_  |








## Public Functions Documentation


### function fpgaGetUserClock 

_Get afu user clock high and low._ 
```C++
fpga_result fpgaGetUserClock (
    fpga_handle handle,
    uint64_t * high_clk,
    uint64_t * low_clk,
    int flags
) 
```





**Parameters:**


* `handle` Handle to previously opened accelerator resource. 
* `high_clk` AFU High user clock frequency in MHz. 
* `low_clk` AFU Low user clock frequency in MHz. 
* `flags` Flags Reserved.

.\*

**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if invalid parameters were provided, or if the parameter combination is not valid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

### function fpgaSetUserClock 

_set afu user clock high and low_ 
```C++
fpga_result fpgaSetUserClock (
    fpga_handle handle,
    uint64_t high_clk,
    uint64_t low_clk,
    int flags
) 
```





**Parameters:**


* `handle` Handle to previously opened accelerator resource. 
* `high_clk` AFU High user clock frequency in MHz. 
* `low_clk` AFU Low user clock frequency in MHz. 
* `flags` Flags Reserved.

.\*

**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if invalid parameters were provided, or if the parameter combination is not valid. FPGA\_EXCEPTION if an internal exception occurred while trying to access the handle. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/userclk.h`