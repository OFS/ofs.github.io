
# Struct fpga\_version



[**ClassList**](annotated.md) **>** [**fpga\_version**](structfpga__version.md)



_Semantic version._ [More...](#detailed-description)

* `#include <types.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint8\_t | [**major**](#variable-major)  <br>_Major version._  |
|  uint8\_t | [**minor**](#variable-minor)  <br>_Minor version._  |
|  uint16\_t | [**patch**](#variable-patch)  <br>_Revision or patchlevel._  |










# Detailed Description


Data structure for expressing version identifiers following the semantic versioning scheme. Used in various properties for tracking component versions. 


    
## Public Attributes Documentation


### variable major 

```C++
uint8_t fpga_version::major;
```




### variable minor 

```C++
uint8_t fpga_version::minor;
```




### variable patch 

```C++
uint16_t fpga_version::patch;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/types.h`