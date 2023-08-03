
# Struct opae\_uio



[**ClassList**](annotated.md) **>** [**opae\_uio**](structopae__uio.md)



_OPAE UIO device abstraction._ [More...](#detailed-description)

* `#include <uio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  int | [**device\_fd**](#variable-device_fd)  <br> |
|  char | [**device\_path**](#variable-device_path)  <br> |
|  struct [**opae\_uio\_device\_region**](structopae__uio__device__region.md) \* | [**regions**](#variable-regions)  <br> |










# Detailed Description


This structure is used to interact with the OPAE UIO API. Each UIO device has a file descriptor that is used to mmap its regions into user address space. Each device also has one or more MMIO regions. 


    
## Public Attributes Documentation


### variable device\_fd 

```C++
int opae_uio::device_fd;
```




### variable device\_path 

```C++
char opae_uio::device_path[OPAE_UIO_PATH_MAX];
```




### variable regions 

```C++
struct opae_uio_device_region* opae_uio::regions;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/uio.h`