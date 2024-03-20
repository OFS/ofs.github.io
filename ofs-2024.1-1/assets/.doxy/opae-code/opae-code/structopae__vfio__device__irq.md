
# Struct opae\_vfio\_device\_irq



[**ClassList**](annotated.md) **>** [**opae\_vfio\_device\_irq**](structopae__vfio__device__irq.md)



_Interrupt info._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint32\_t | [**count**](#variable-count)  <br>_Number of IRQs at this index._  |
|  int32\_t \* | [**event\_fds**](#variable-event_fds)  <br>_Event file descriptors._  |
|  uint32\_t | [**flags**](#variable-flags)  <br>_Flags._  |
|  uint32\_t | [**index**](#variable-index)  <br>_The IRQ index._  |
|  int32\_t \* | [**masks**](#variable-masks)  <br>_IRQ masks._  |
|  struct [**opae\_vfio\_device\_irq**](structopae__vfio__device__irq.md) \* | [**next**](#variable-next)  <br>_Pointer to next in list._  |










# Detailed Description


Describes an interrupt capability. 


    
## Public Attributes Documentation


### variable count 

```C++
uint32_t opae_vfio_device_irq::count;
```




### variable event\_fds 

```C++
int32_t* opae_vfio_device_irq::event_fds;
```




### variable flags 

_Flags._ 
```C++
uint32_t opae_vfio_device_irq::flags;
```



See struct vfio\_irq\_info. 


        

### variable index 

```C++
uint32_t opae_vfio_device_irq::index;
```




### variable masks 

```C++
int32_t* opae_vfio_device_irq::masks;
```




### variable next 

```C++
struct opae_vfio_device_irq* opae_vfio_device_irq::next;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`