
# Struct opae\_vfio



[**ClassList**](annotated.md) **>** [**opae\_vfio**](structopae__vfio.md)



_OPAE VFIO device abstraction._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  [**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) | [**cont\_buffers**](#variable-cont_buffers)  <br>_Map of allocated DMA buffers._  |
|  char \* | [**cont\_device**](#variable-cont_device)  <br>_"/dev/vfio/vfio"_  |
|  int | [**cont\_fd**](#variable-cont_fd)  <br>_Container file descriptor._  |
|  char \* | [**cont\_pciaddr**](#variable-cont_pciaddr)  <br>_PCIe address, eg 0000:00:00.0._  |
|  struct [**opae\_vfio\_iova\_range**](structopae__vfio__iova__range.md) \* | [**cont\_ranges**](#variable-cont_ranges)  <br>_List of IOVA ranges._  |
|  struct [**opae\_vfio\_device**](structopae__vfio__device.md) | [**device**](#variable-device)  <br>_The VFIO device._  |
|  struct [**opae\_vfio\_group**](structopae__vfio__group.md) | [**group**](#variable-group)  <br>_The VFIO device group._  |
|  struct [**mem\_alloc**](structmem__alloc.md) | [**iova\_alloc**](#variable-iova_alloc)  <br>_Allocator for IOVA space._  |
|  pthread\_mutex\_t | [**lock**](#variable-lock)  <br>_For thread safety._  |










# Detailed Description


This structure is used to interact with the OPAE VFIO API. It tracks data related to the VFIO container, group, and device. A mutex is provided for thread safety. 


    
## Public Attributes Documentation


### variable cont\_buffers 

```C++
opae_hash_map opae_vfio::cont_buffers;
```




### variable cont\_device 

```C++
char* opae_vfio::cont_device;
```




### variable cont\_fd 

```C++
int opae_vfio::cont_fd;
```




### variable cont\_pciaddr 

```C++
char* opae_vfio::cont_pciaddr;
```




### variable cont\_ranges 

```C++
struct opae_vfio_iova_range* opae_vfio::cont_ranges;
```




### variable device 

```C++
struct opae_vfio_device opae_vfio::device;
```




### variable group 

```C++
struct opae_vfio_group opae_vfio::group;
```




### variable iova\_alloc 

```C++
struct mem_alloc opae_vfio::iova_alloc;
```




### variable lock 

```C++
pthread_mutex_t opae_vfio::lock;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`