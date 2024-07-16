
# File version.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**version.h**](version_8h.md)

[Go to the source code of this file.](version_8h_source.md)



* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetOPAECBuildString**](#function-fpgagetopaecbuildstring) (char \* build\_str, size\_t len) <br>_Get build information about the OPAE library as a string._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetOPAECVersion**](#function-fpgagetopaecversion) ([**fpga\_version**](structfpga__version.md) \* version) <br>_Get version information about the OPAE library._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetOPAECVersionString**](#function-fpgagetopaecversionstring) (char \* version\_str, size\_t len) <br>_Get version information about the OPAE library as a string._  |







## Macros

| Type | Name |
| ---: | :--- |
| define  | [**FPGA\_BUILD\_STR\_MAX**](version_8h.md#define-fpga_build_str_max)  41<br> |
| define  | [**FPGA\_VERSION\_STR\_MAX**](version_8h.md#define-fpga_version_str_max)  10<br> |

## Public Functions Documentation


### function fpgaGetOPAECBuildString 

_Get build information about the OPAE library as a string._ 
```C++
fpga_result fpgaGetOPAECBuildString (
    char * build_str,
    size_t len
) 
```



Retrieve the build identifier of the OPAE library.




**Parameters:**


* `build_str` String to copy build information into 
* `len` Length of `build_str` 



**Returns:**

FPGA\_INVALID\_PARAM if `build_str` is NULL, FPGA\_EXCEPTION if the version string cannot be copied into `build_str`, FPGA\_OK otherwise. 





        

### function fpgaGetOPAECVersion 

_Get version information about the OPAE library._ 
```C++
fpga_result fpgaGetOPAECVersion (
    fpga_version * version
) 
```



Retrieve major version, minor version, and revision information about the OPAE library.




**Parameters:**


* `version` FPGA version 



**Returns:**

FPGA\_INVALID\_PARAM if any of the output parameters is NULL, FPGA\_OK otherwise. 





        

### function fpgaGetOPAECVersionString 

_Get version information about the OPAE library as a string._ 
```C++
fpga_result fpgaGetOPAECVersionString (
    char * version_str,
    size_t len
) 
```



Retrieve major version, minor version, and revision information about the OPAE library, encoded in a human-readable string (e.g. "1.0.0").




**Parameters:**


* `version_str` String to copy version information into 
* `len` Length of `version_str` 



**Returns:**

FPGA\_INVALID\_PARAM if `version_str` is NULL, FPGA\_EXCEPTION if the version string cannot be copied into `version_str`, FPGA\_OK otherwise. 





        
## Macro Definition Documentation



### define FPGA\_BUILD\_STR\_MAX 

```C++
#define FPGA_BUILD_STR_MAX 41
```




### define FPGA\_VERSION\_STR\_MAX 

```C++
#define FPGA_VERSION_STR_MAX 10
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/version.h`