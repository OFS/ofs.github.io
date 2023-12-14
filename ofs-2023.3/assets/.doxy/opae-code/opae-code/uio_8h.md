
# File uio.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**uio.h**](uio_8h.md)

[Go to the source code of this file.](uio_8h_source.md)

_APIs to manage a PCIe device via UIO._ [More...](#detailed-description)

* `#include <stdio.h>`
* `#include <stdint.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**opae\_uio**](structopae__uio.md) <br>_OPAE UIO device abstraction._  |
| struct | [**opae\_uio\_device\_region**](structopae__uio__device__region.md) <br>_MMIO region info._  |





## Public Functions

| Type | Name |
| ---: | :--- |
|  void | [**opae\_uio\_close**](#function-opae_uio_close) (struct [**opae\_uio**](structopae__uio.md) \* u) <br>_Release and close a UIO device._  |
|  int | [**opae\_uio\_open**](#function-opae_uio_open) (struct [**opae\_uio**](structopae__uio.md) \* u, const char \* dfl\_device) <br>_Open and populate a UIO device._  |
|  int | [**opae\_uio\_region\_get**](#function-opae_uio_region_get) (struct [**opae\_uio**](structopae__uio.md) \* u, uint32\_t index, uint8\_t \*\* ptr, size\_t \* size) <br>_Query device MMIO region._  |







## Macros

| Type | Name |
| ---: | :--- |
| define  | [**OPAE\_UIO\_PATH\_MAX**](uio_8h.md#define-opae_uio_path_max)  256<br> |

# Detailed Description


Presents a simple interface for interacting with a DFL device that is bound to its UIO driver. See [https://kernel.org/doc/html/v4.14/driver-api/uio-howto.html](https://kernel.org/doc/html/v4.14/driver-api/uio-howto.html) for a description of UIO.


Provides APIs for opening/closing the device and for querying info about the MMIO regions of the device. 


    
## Public Functions Documentation


### function opae\_uio\_close 

_Release and close a UIO device._ 
```C++
void opae_uio_close (
    struct opae_uio * u
) 
```



The given device pointer must have been previously initialized by opae\_uio\_open. Releases all data structures.




**Parameters:**


* `u` Storage for the device info. May be stack-resident.

Example 
struct opae_uio u;

if (opae_uio_open(&u, "dfl_dev.10")) {
  // handle error
} else {
  // interact with the device
  ...
  // free the device
  opae_uio_close(&u);
}



Example 
$ sudo opaeuio -r dfl_dev.10
 


        

### function opae\_uio\_open 

_Open and populate a UIO device._ 
```C++
int opae_uio_open (
    struct opae_uio * u,
    const char * dfl_device
) 
```



Opens the Device Feature List device corresponding to the device name given in dfl\_device, eg "dfl\_dev.10". The device must be bound to the dfl-uio-pdev driver prior to opening it. The data structures corresponding to the MMIO regions are initialized.




**Parameters:**


* `u` Storage for the device. May be stack-resident. 
* `dfl_device` The name of the desired DFL device. 



**Returns:**

Non-zero on error. Zero on success.


Example 
$ sudo opaeuio -i -u lab -g lab dfl_dev.10



Example 
struct opae_uio u;

if (opae_uio_open(&u, "dfl_dev.10")) {
  // handle error
}
 


        

### function opae\_uio\_region\_get 

_Query device MMIO region._ 
```C++
int opae_uio_region_get (
    struct opae_uio * u,
    uint32_t index,
    uint8_t ** ptr,
    size_t * size
) 
```



Retrieves info describing the MMIO region with the given region index. The device structure u must have been previously opened by a call to opae\_uio\_open.




**Parameters:**


* `u` The open OPAE UIO device. 
* `index` The zero-based index of the desired MMIO region. 
* `ptr` Optional pointer to receive the virtual address for the region. Pass NULL to ignore. 
* `size` Optional pointer to receive the size of the MMIO region. Pass NULL to ignore. 



**Returns:**

Non-zero on error (including index out-of-range). Zero on success.


Example 
struct opae_uio u;

uint8_t *virt = NULL;
size_t size = 0;

if (opae_uio_open(&u, "dfl_dev.10")) {
  // handle error
} else {
  opae_uio_region_get(&u, 0, &virt, &size);
}
 


        
## Macro Definition Documentation



### define OPAE\_UIO\_PATH\_MAX 

```C++
#define OPAE_UIO_PATH_MAX 256
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/uio.h`