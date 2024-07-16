
# Struct \_fpga\_token\_header



[**ClassList**](annotated.md) **>** [**\_fpga\_token\_header**](struct__fpga__token__header.md)



_Internal token type header._ [More...](#detailed-description)

* `#include <types.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint8\_t | [**bus**](#variable-bus)  <br> |
|  uint8\_t | [**device**](#variable-device)  <br> |
|  uint16\_t | [**device\_id**](#variable-device_id)  <br> |
|  uint8\_t | [**function**](#variable-function)  <br> |
|  [**fpga\_guid**](types_8h.md#typedef-fpga_guid) | [**guid**](#variable-guid)  <br> |
|  [**fpga\_interface**](types__enum_8h.md#enum-fpga_interface) | [**interface**](#variable-interface)  <br> |
|  uint64\_t | [**magic**](#variable-magic)  <br> |
|  uint64\_t | [**object\_id**](#variable-object_id)  <br> |
|  [**fpga\_objtype**](types__enum_8h.md#enum-fpga_objtype) | [**objtype**](#variable-objtype)  <br> |
|  uint16\_t | [**segment**](#variable-segment)  <br> |
|  uint16\_t | [**subsystem\_device\_id**](#variable-subsystem_device_id)  <br> |
|  uint16\_t | [**subsystem\_vendor\_id**](#variable-subsystem_vendor_id)  <br> |
|  uint16\_t | [**vendor\_id**](#variable-vendor_id)  <br> |










# Detailed Description


Each plugin (dfl: libxfpga.so, vfio: libopae-v.so) implements its own proprietary token type. This header _must_ appear at offset zero within that structure.


eg, see lib/plugins/xfpga/types\_int.h:struct \_fpga\_token and lib/plugins/vfio/opae\_vfio.h:struct \_vfio\_token. 


    
## Public Attributes Documentation


### variable bus 

```C++
uint8_t _fpga_token_header::bus;
```




### variable device 

```C++
uint8_t _fpga_token_header::device;
```




### variable device\_id 

```C++
uint16_t _fpga_token_header::device_id;
```




### variable function 

```C++
uint8_t _fpga_token_header::function;
```




### variable guid 

```C++
fpga_guid _fpga_token_header::guid;
```




### variable interface 

```C++
fpga_interface _fpga_token_header::interface;
```




### variable magic 

```C++
uint64_t _fpga_token_header::magic;
```




### variable object\_id 

```C++
uint64_t _fpga_token_header::object_id;
```




### variable objtype 

```C++
fpga_objtype _fpga_token_header::objtype;
```




### variable segment 

```C++
uint16_t _fpga_token_header::segment;
```




### variable subsystem\_device\_id 

```C++
uint16_t _fpga_token_header::subsystem_device_id;
```




### variable subsystem\_vendor\_id 

```C++
uint16_t _fpga_token_header::subsystem_vendor_id;
```




### variable vendor\_id 

```C++
uint16_t _fpga_token_header::vendor_id;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/types.h`