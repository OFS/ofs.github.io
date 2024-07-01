
# File except.h



[**FileList**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**except.h**](except_8h.md)

[Go to the source code of this file.](except_8h_source.md)



* `#include <opae/types_enum.h>`
* `#include <cstdint>`
* `#include <exception>`









## Namespaces

| Type | Name |
| ---: | :--- |
| namespace | [**opae**](namespaceopae.md) <br> |
| namespace | [**fpga**](namespaceopae_1_1fpga.md) <br> |
| namespace | [**types**](namespaceopae_1_1fpga_1_1types.md) <br> |
| namespace | [**detail**](namespaceopae_1_1fpga_1_1types_1_1detail.md) <br> |

## Classes

| Type | Name |
| ---: | :--- |
| class | [**busy**](classopae_1_1fpga_1_1types_1_1busy.md) <br>_busy exception_  |
| class | [**except**](classopae_1_1fpga_1_1types_1_1except.md) <br>_Generic OPAE exception._  |
| class | [**exception**](classopae_1_1fpga_1_1types_1_1exception.md) <br>_exception exception_  |
| class | [**invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) <br>[_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_ |
| class | [**no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) <br>[_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_ |
| class | [**no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) <br>[_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_ |
| class | [**no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) <br>[_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_ |
| class | [**no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) <br>[_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_ |
| class | [**not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) <br>[_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_ |
| class | [**not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) <br>[_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_ |
| class | [**reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) <br>[_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_ |
| class | [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) <br>_Identify a particular line in a source file._  |












## Macros

| Type | Name |
| ---: | :--- |
| define  | [**ASSERT\_FPGA\_OK**](except_8h.md#define-assert_fpga_ok) (r) <br>_Macro to check of result is FPGA\_OK If not, throw exception that corresponds to the result code._  |
| define  | [**OPAECXX\_HERE**](except_8h.md#define-opaecxx_here)    [**opae::fpga::types::src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md)(\_\_FILE\_\_, \_\_func\_\_, \_\_LINE\_\_)<br>_Construct a src\_location object for the current source line._  |

## Macro Definition Documentation



### define ASSERT\_FPGA\_OK 

```C++
#define ASSERT_FPGA_OK (
    r
) opae::fpga::types::detail::assert_fpga_ok( \
      r, opae::fpga::types::src_location (__FILE__, __func__, __LINE__));
```




### define OPAECXX\_HERE 

```C++
#define OPAECXX_HERE opae::fpga::types::src_location (__FILE__, __func__, __LINE__)
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`