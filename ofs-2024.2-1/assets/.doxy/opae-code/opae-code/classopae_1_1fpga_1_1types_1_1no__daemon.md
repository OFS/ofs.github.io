
# Class opae::fpga::types::no\_daemon



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md)



[_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_[More...](#detailed-description)

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
|   | [**no\_daemon**](#function-no_daemon) ([**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>[_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _constructor_ |

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


[**no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) tracks the source line of origin for exceptions thrown when the error code FPGA\_NO\_DAEMON is returned from a call to an OPAE C API function 


    
## Public Functions Documentation


### function no\_daemon 

[_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _constructor_
```C++
inline opae::fpga::types::no_daemon::no_daemon (
    src_location loc
) noexcept
```





**Parameters:**


* `loc` Location where the exception was constructed. 




        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`