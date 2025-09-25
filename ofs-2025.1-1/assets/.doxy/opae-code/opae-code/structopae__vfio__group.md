
# Struct opae\_vfio\_group



[**ClassList**](annotated.md) **>** [**opae\_vfio\_group**](structopae__vfio__group.md)



_VFIO group._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  char \* | [**group\_device**](#variable-group_device)  <br>_Full path to the group device._  |
|  int | [**group\_fd**](#variable-group_fd)  <br>_File descriptor for the group device._  |










# Detailed Description


Each device managed by vfio-pci belongs to a VFIO group rooted at /dev/vfio/N, where N is the group number. 


    
## Public Attributes Documentation


### variable group\_device 

```C++
char* opae_vfio_group::group_device;
```




### variable group\_fd 

```C++
int opae_vfio_group::group_fd;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`