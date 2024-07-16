
# File init.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**init.h**](init_8h.md)

[Go to the source code of this file.](init_8h_source.md)

_Initialization routine._ 

* `#include <opae/types_enum.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaFinalize**](#function-fpgafinalize) (void) <br>_Finalize the OPAE library._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaInitialize**](#function-fpgainitialize) (const char \* config\_file) <br>_Initialize the OPAE library._  |








## Public Functions Documentation


### function fpgaFinalize 

_Finalize the OPAE library._ 
```C++
fpga_result fpgaFinalize (
    void
) 
```





**Returns:**

Whether OPAE finalized successfully. 





        

### function fpgaInitialize 

_Initialize the OPAE library._ 
```C++
fpga_result fpgaInitialize (
    const char * config_file
) 
```



Initialize OPAE using the given configuration file path, or perform default initialization if config\_file is NULL.




**Parameters:**


* `config_file` Path to OPAE configuration file. 



**Returns:**

Whether OPAE initialized successfully. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/init.h`