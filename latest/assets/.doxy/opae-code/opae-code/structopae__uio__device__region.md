
# Struct opae\_uio\_device\_region



[**ClassList**](annotated.md) **>** [**opae\_uio\_device\_region**](structopae__uio__device__region.md)



_MMIO region info._ [More...](#detailed-description)

* `#include <uio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  struct [**opae\_uio\_device\_region**](structopae__uio__device__region.md) \* | [**next**](#variable-next)  <br> |
|  uint32\_t | [**region\_index**](#variable-region_index)  <br> |
|  size\_t | [**region\_page\_offset**](#variable-region_page_offset)  <br> |
|  uint8\_t \* | [**region\_ptr**](#variable-region_ptr)  <br> |
|  size\_t | [**region\_size**](#variable-region_size)  <br> |










# Detailed Description


Describes a range of mappable MMIO. 


    
## Public Attributes Documentation


### variable next 

```C++
struct opae_uio_device_region* opae_uio_device_region::next;
```




### variable region\_index 

```C++
uint32_t opae_uio_device_region::region_index;
```




### variable region\_page\_offset 

```C++
size_t opae_uio_device_region::region_page_offset;
```




### variable region\_ptr 

```C++
uint8_t* opae_uio_device_region::region_ptr;
```




### variable region\_size 

```C++
size_t opae_uio_device_region::region_size;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/uio.h`