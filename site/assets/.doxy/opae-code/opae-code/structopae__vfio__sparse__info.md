
# Struct opae\_vfio\_sparse\_info



[**ClassList**](annotated.md) **>** [**opae\_vfio\_sparse\_info**](structopae__vfio__sparse__info.md)



_MMIO sparse-mappable region info._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint32\_t | [**index**](#variable-index)  <br>_Region index, from 0._  |
|  struct [**opae\_vfio\_sparse\_info**](structopae__vfio__sparse__info.md) \* | [**next**](#variable-next)  <br>_Pointer to next in list._  |
|  uint32\_t | [**offset**](#variable-offset)  <br>_Offset of sparse region._  |
|  uint8\_t \* | [**ptr**](#variable-ptr)  <br>_Virtual address of sparse region._  |
|  uint32\_t | [**size**](#variable-size)  <br>_Size of sparse region._  |










# Detailed Description


Describes a range of sparse-mappable MMIO, for MMIO ranges that have non-contiguous addresses. 


    
## Public Attributes Documentation


### variable index 

```C++
uint32_t opae_vfio_sparse_info::index;
```




### variable next 

```C++
struct opae_vfio_sparse_info* opae_vfio_sparse_info::next;
```




### variable offset 

```C++
uint32_t opae_vfio_sparse_info::offset;
```




### variable ptr 

```C++
uint8_t* opae_vfio_sparse_info::ptr;
```




### variable size 

```C++
uint32_t opae_vfio_sparse_info::size;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`