
# Namespace opae::fpga::types::detail



[**Namespace List**](namespaces.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**detail**](namespaceopae_1_1fpga_1_1types_1_1detail.md)
















## Public Types

| Type | Name |
| ---: | :--- |
| typedef bool(\* | [**exception\_fn**](#typedef-exception_fn)  <br>_typedef function pointer that returns bool if result is FPGA\_OK_  |



## Public Static Attributes

| Type | Name |
| ---: | :--- |
|  [**exception\_fn**](namespaceopae_1_1fpga_1_1types_1_1detail.md#typedef-exception_fn) | [**opae\_exceptions**](#variable-opae_exceptions)   = = {
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md)&gt;,
    [**is\_ok**](namespaceopae_1_1fpga_1_1types_1_1detail.md#function-is_ok)&lt;[**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md)&gt;}<br> |

## Public Functions

| Type | Name |
| ---: | :--- |
|  constexpr bool | [**is\_ok**](#function-is_ok) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) result, const [**opae::fpga::types::src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) & loc) <br>_is\_ok is a template function that throws an excpetion of its template argument type if the result code is not FPGA\_OK._  |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  void | [**assert\_fpga\_ok**](#function-assert_fpga_ok) ([**fpga\_result**](types__enum_8h.md#enum-fpga_result) result, const [**opae::fpga::types::src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) & loc) <br> |







## Public Types Documentation


### typedef exception\_fn 

```C++
typedef bool(* opae::fpga::types::detail::exception_fn) (fpga_result, const opae::fpga::types::src_location &loc);
```



## Public Static Attributes Documentation


### variable opae\_exceptions 

```C++
exception_fn opae::fpga::types::detail::opae_exceptions[12];
```



## Public Functions Documentation


### function is\_ok 

_is\_ok is a template function that throws an excpetion of its template argument type if the result code is not FPGA\_OK._ 
```C++
template<typename T typename T>
constexpr bool opae::fpga::types::detail::is_ok (
    fpga_result result,
    const opae::fpga::types::src_location & loc
) 
```



Otherwise it returns true. 


        
## Public Static Functions Documentation


### function assert\_fpga\_ok 

```C++
static inline void opae::fpga::types::detail::assert_fpga_ok (
    fpga_result result,
    const opae::fpga::types::src_location & loc
) 
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`