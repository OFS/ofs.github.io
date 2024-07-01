
# Class opae::fpga::types::not\_found



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md)



[_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_[More...](#detailed-description)

* `#include <except.h>`



Inherits the following classes: [opae::fpga::types::except](classopae_1_1fpga_1_1types_1_1except.md)















## Public Static Attributes inherited from opae::fpga::types::except

See [opae::fpga::types::except](classopae_1_1fpga_1_1types_1_1except.md)

| Type | Name |
| ---: | :--- |
|  const std::size\_t | [**MAX\_EXCEPT**](#variable-max_except)   = = 256<br> |

## Public Functions

| Type | Name |
| ---: | :--- |
|   | [**not\_found**](#function-not_found) ([**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>[_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _constructor_ |

## Public Functions inherited from opae::fpga::types::except

See [opae::fpga::types::except](classopae_1_1fpga_1_1types_1_1except.md)

| Type | Name |
| ---: | :--- |
|   | [**except**](#function-except-13) ([**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor The fpga\_result value is FPGA\_EXCEPTION._  |
|   | [**except**](#function-except-23) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) res, [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor_  |
|   | [**except**](#function-except-33) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) res, const char \* msg, [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor_  |
|   | [**operator fpga\_result**](#function-operator-fpga_result) () noexcept const<br>_Convert this except to its fpga\_result._  |
| virtual const char \* | [**what**](#function-what) () noexcept override const<br>_Convert this except to an informative string._  |








## Protected Attributes inherited from opae::fpga::types::except

See [opae::fpga::types::except](classopae_1_1fpga_1_1types_1_1except.md)

| Type | Name |
| ---: | :--- |
|  char | [**buf\_**](#variable-buf_)  <br> |
|  [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) | [**loc\_**](#variable-loc_)  <br> |
|  const char \* | [**msg\_**](#variable-msg_)  <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**res\_**](#variable-res_)  <br> |







# Detailed Description


[**not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) tracks the source line of origin for exceptions thrown when the error code FPGA\_NOT\_FOUND is returned from a call to an OPAE C API function 


    
## Public Functions Documentation


### function not\_found 

[_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _constructor_
```C++
inline opae::fpga::types::not_found::not_found (
    src_location loc
) noexcept
```





**Parameters:**


* `loc` Location where the exception was constructed. 




        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`