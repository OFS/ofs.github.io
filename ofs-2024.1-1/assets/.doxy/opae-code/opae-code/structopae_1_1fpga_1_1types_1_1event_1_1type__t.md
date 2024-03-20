
# Struct opae::fpga::types::event::type\_t



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**event**](classopae_1_1fpga_1_1types_1_1event.md) **>** [**type\_t**](structopae_1_1fpga_1_1types_1_1event_1_1type__t.md)



_C++ struct that is interchangeable with fpga\_event\_type enum._ 

* `#include <events.h>`














## Public Static Attributes

| Type | Name |
| ---: | :--- |
|  constexpr [**fpga\_event\_type**](types__enum_8h.md#enum-fpga_event_type) | [**error**](#variable-error)   = = FPGA\_EVENT\_ERROR<br> |
|  constexpr [**fpga\_event\_type**](types__enum_8h.md#enum-fpga_event_type) | [**interrupt**](#variable-interrupt)   = = FPGA\_EVENT\_INTERRUPT<br> |
|  constexpr [**fpga\_event\_type**](types__enum_8h.md#enum-fpga_event_type) | [**power\_thermal**](#variable-power_thermal)   = = FPGA\_EVENT\_POWER\_THERMAL<br> |

## Public Functions

| Type | Name |
| ---: | :--- |
|   | [**operator fpga\_event\_type**](#function-operator-fpga_event_type) () <br> |
|   | [**type\_t**](#function-type_t) ([**fpga\_event\_type**](types__enum_8h.md#enum-fpga_event_type) c\_type) <br> |








## Public Static Attributes Documentation


### variable error 

```C++
constexpr fpga_event_type opae::fpga::types::event::type_t::error;
```




### variable interrupt 

```C++
constexpr fpga_event_type opae::fpga::types::event::type_t::interrupt;
```




### variable power\_thermal 

```C++
constexpr fpga_event_type opae::fpga::types::event::type_t::power_thermal;
```



## Public Functions Documentation


### function operator fpga\_event\_type 

```C++
inline opae::fpga::types::event::type_t::operator fpga_event_type () 
```




### function type\_t 

```C++
inline opae::fpga::types::event::type_t::type_t (
    fpga_event_type c_type
) 
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/events.h`