
# Struct opae\_vfio\_device\_region



[**ClassList**](annotated.md) **>** [**opae\_vfio\_device\_region**](structopae__vfio__device__region.md)



_MMIO region info._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  struct [**opae\_vfio\_device\_region**](structopae__vfio__device__region.md) \* | [**next**](#variable-next)  <br>_Pointer to next in list._  |
|  uint32\_t | [**region\_index**](#variable-region_index)  <br>_Region index, from 0._  |
|  uint8\_t \* | [**region\_ptr**](#variable-region_ptr)  <br>_Virtual address of region._  |
|  size\_t | [**region\_size**](#variable-region_size)  <br>_Size of region._  |
|  struct [**opae\_vfio\_sparse\_info**](structopae__vfio__sparse__info.md) \* | [**region\_sparse**](#variable-region_sparse)  <br>_For sparse regions._  |










# Detailed Description


Describes a range of mappable MMIO. 


    
## Public Attributes Documentation


### variable next 

```C++
struct opae_vfio_device_region* opae_vfio_device_region::next;
```




### variable region\_index 

```C++
uint32_t opae_vfio_device_region::region_index;
```




### variable region\_ptr 

```C++
uint8_t* opae_vfio_device_region::region_ptr;
```




### variable region\_size 

```C++
size_t opae_vfio_device_region::region_size;
```




### variable region\_sparse 

```C++
struct opae_vfio_sparse_info* opae_vfio_device_region::region_sparse;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`