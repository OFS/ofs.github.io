
# File utils.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**utils.h**](utils_8h.md)

[Go to the source code of this file.](utils_8h_source.md)

_Utility functions and macros for the FPGA API._ 

* `#include <opae/types.h>`
* `#include <stdio.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  const char \* | [**fpgaErrStr**](#function-fpgaerrstr) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) e) <br>_Return human-readable error message._  |








## Public Functions Documentation


### function fpgaErrStr 

_Return human-readable error message._ 
```C++
const char * fpgaErrStr (
    fpga_result e
) 
```



Returns a pointer to a human-readable error message corresponding to the provided fpga\_error error code.




**Parameters:**


* `e` Error code (as returned by another FPGA API function 



**Returns:**

Pointer to a descriptive error message string 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/utils.h`