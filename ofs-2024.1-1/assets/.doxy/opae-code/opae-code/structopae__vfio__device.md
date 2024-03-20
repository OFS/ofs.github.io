
# Struct opae\_vfio\_device



[**ClassList**](annotated.md) **>** [**opae\_vfio\_device**](structopae__vfio__device.md)



_VFIO device._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint64\_t | [**device\_config\_offset**](#variable-device_config_offset)  <br>_Offset of PCIe config space._  |
|  int | [**device\_fd**](#variable-device_fd)  <br>_Device file descriptor._  |
|  uint32\_t | [**device\_num\_irqs**](#variable-device_num_irqs)  <br>_IRQ index count._  |
|  uint32\_t | [**device\_num\_regions**](#variable-device_num_regions)  <br>_Total MMIO region count._  |
|  struct [**opae\_vfio\_device\_irq**](structopae__vfio__device__irq.md) \* | [**irqs**](#variable-irqs)  <br>_IRQ list pointer._  |
|  struct [**opae\_vfio\_device\_region**](structopae__vfio__device__region.md) \* | [**regions**](#variable-regions)  <br>_Region list pointer._  |










# Detailed Description


Each VFIO device has a file descriptor that is used to query information about the device MMIO regions and config space. 


    
## Public Attributes Documentation


### variable device\_config\_offset 

```C++
uint64_t opae_vfio_device::device_config_offset;
```




### variable device\_fd 

```C++
int opae_vfio_device::device_fd;
```




### variable device\_num\_irqs 

```C++
uint32_t opae_vfio_device::device_num_irqs;
```




### variable device\_num\_regions 

```C++
uint32_t opae_vfio_device::device_num_regions;
```




### variable irqs 

```C++
struct opae_vfio_device_irq* opae_vfio_device::irqs;
```




### variable regions 

```C++
struct opae_vfio_device_region* opae_vfio_device::regions;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`