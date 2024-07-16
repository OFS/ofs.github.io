
# Class opae::fpga::types::version



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**version**](classopae_1_1fpga_1_1types_1_1version.md)





* `#include <version.h>`
















## Public Static Functions

| Type | Name |
| ---: | :--- |
|  std::string | [**as\_string**](#function-as_string) () <br>_Get the package version information as a string._  |
|  [**fpga\_version**](structfpga__version.md) | [**as\_struct**](#function-as_struct) () <br>_Get the package version information as a struct._  |
|  std::string | [**build**](#function-build) () <br>_Get the package build information as a string._  |







## Public Static Functions Documentation


### function as\_string 

_Get the package version information as a string._ 
```C++
static std::string opae::fpga::types::version::as_string () 
```





**Returns:**

The package version as an `std::string` object 





        

### function as\_struct 

_Get the package version information as a struct._ 
```C++
static fpga_version opae::fpga::types::version::as_struct () 
```





**Returns:**

The package version as an `fpga_version` struct 





        

### function build 

_Get the package build information as a string._ 
```C++
static std::string opae::fpga::types::version::build () 
```





**Returns:**

The package build as an `std::string` object 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/version.h`