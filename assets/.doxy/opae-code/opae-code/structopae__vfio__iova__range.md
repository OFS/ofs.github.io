
# Struct opae\_vfio\_iova\_range



[**ClassList**](annotated.md) **>** [**opae\_vfio\_iova\_range**](structopae__vfio__iova__range.md)



_IO Virtual Address Range._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint64\_t | [**end**](#variable-end)  <br>_End of this range of offsets._  |
|  struct [**opae\_vfio\_iova\_range**](structopae__vfio__iova__range.md) \* | [**next**](#variable-next)  <br>_Pointer to next in list._  |
|  uint64\_t | [**start**](#variable-start)  <br>_Start of this range of offsets._  |










# Detailed Description


A range of allocatable IOVA offsets. Used for mapping DMA buffers. 


    
## Public Attributes Documentation


### variable end 

```C++
uint64_t opae_vfio_iova_range::end;
```




### variable next 

```C++
struct opae_vfio_iova_range* opae_vfio_iova_range::next;
```




### variable start 

```C++
uint64_t opae_vfio_iova_range::start;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`