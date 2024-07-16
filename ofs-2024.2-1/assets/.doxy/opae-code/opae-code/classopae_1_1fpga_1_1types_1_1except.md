
# Class opae::fpga::types::except



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**except**](classopae_1_1fpga_1_1types_1_1except.md)



_Generic OPAE exception._ [More...](#detailed-description)

* `#include <except.h>`



Inherits the following classes: std::exception


Inherited by the following classes: [opae::fpga::types::busy](classopae_1_1fpga_1_1types_1_1busy.md),  [opae::fpga::types::exception](classopae_1_1fpga_1_1types_1_1exception.md),  [opae::fpga::types::invalid\_param](classopae_1_1fpga_1_1types_1_1invalid__param.md),  [opae::fpga::types::no\_access](classopae_1_1fpga_1_1types_1_1no__access.md),  [opae::fpga::types::no\_daemon](classopae_1_1fpga_1_1types_1_1no__daemon.md),  [opae::fpga::types::no\_driver](classopae_1_1fpga_1_1types_1_1no__driver.md),  [opae::fpga::types::no\_memory](classopae_1_1fpga_1_1types_1_1no__memory.md),  [opae::fpga::types::not\_found](classopae_1_1fpga_1_1types_1_1not__found.md),  [opae::fpga::types::not\_supported](classopae_1_1fpga_1_1types_1_1not__supported.md),  [opae::fpga::types::reconf\_error](classopae_1_1fpga_1_1types_1_1reconf__error.md)









## Public Static Attributes

| Type | Name |
| ---: | :--- |
|  const std::size\_t | [**MAX\_EXCEPT**](#variable-max_except)   = = 256<br> |

## Public Functions

| Type | Name |
| ---: | :--- |
|   | [**except**](#function-except-13) ([**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor The fpga\_result value is FPGA\_EXCEPTION._  |
|   | [**except**](#function-except-23) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) res, [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor_  |
|   | [**except**](#function-except-33) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) res, const char \* msg, [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) loc) noexcept<br>_except constructor_  |
|   | [**operator fpga\_result**](#function-operator-fpga_result) () noexcept const<br>_Convert this except to its fpga\_result._  |
| virtual const char \* | [**what**](#function-what) () noexcept override const<br>_Convert this except to an informative string._  |




## Protected Attributes

| Type | Name |
| ---: | :--- |
|  char | [**buf\_**](#variable-buf_)  <br> |
|  [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) | [**loc\_**](#variable-loc_)  <br> |
|  const char \* | [**msg\_**](#variable-msg_)  <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**res\_**](#variable-res_)  <br> |




# Detailed Description


An except tracks the source line of origin and an optional fpga\_result. If no fpga\_result is given, then FPGA\_EXCEPTION is used. 


    
## Public Static Attributes Documentation


### variable MAX\_EXCEPT 

```C++
const std::size_t opae::fpga::types::except::MAX_EXCEPT;
```



## Public Functions Documentation


### function except [1/3]

_except constructor The fpga\_result value is FPGA\_EXCEPTION._ 
```C++
opae::fpga::types::except::except (
    src_location loc
) noexcept
```





**Parameters:**


* `loc` Location where the exception was constructed. 




        

### function except [2/3]

_except constructor_ 
```C++
opae::fpga::types::except::except (
    fpga_result res,
    src_location loc
) noexcept
```





**Parameters:**


* `res` The fpga\_result value associated with this exception. 
* `loc` Location where the exception was constructed. 




        

### function except [3/3]

_except constructor_ 
```C++
opae::fpga::types::except::except (
    fpga_result res,
    const char * msg,
    src_location loc
) noexcept
```





**Parameters:**


* `res` The fpga\_result value associated with this exception. 
* `msg` The error message as a string 
* `loc` Location where the exception was constructed. 




        

### function operator fpga\_result 

```C++
inline opae::fpga::types::except::operator fpga_result () noexcept const
```




### function what 

```C++
virtual const char * opae::fpga::types::except::what () noexcept override const
```



## Protected Attributes Documentation


### variable buf\_ 

```C++
char opae::fpga::types::except::buf_[MAX_EXCEPT];
```




### variable loc\_ 

```C++
src_location opae::fpga::types::except::loc_;
```




### variable msg\_ 

```C++
const char* opae::fpga::types::except::msg_;
```




### variable res\_ 

```C++
fpga_result opae::fpga::types::except::res_;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`