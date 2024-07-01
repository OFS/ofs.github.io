
# File vfio.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**vfio.h**](vfio_8h.md)

[Go to the source code of this file.](vfio_8h_source.md)

_APIs to manage a PCIe device via vfio-pci._ [More...](#detailed-description)

* `#include <stdio.h>`
* `#include <stdint.h>`
* `#include <pthread.h>`
* `#include <linux/vfio.h>`
* `#include <opae/mem_alloc.h>`
* `#include <opae/hash_map.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**opae\_vfio**](structopae__vfio.md) <br>_OPAE VFIO device abstraction._  |
| struct | [**opae\_vfio\_buffer**](structopae__vfio__buffer.md) <br>_System DMA buffer._  |
| struct | [**opae\_vfio\_device**](structopae__vfio__device.md) <br>_VFIO device._  |
| struct | [**opae\_vfio\_device\_irq**](structopae__vfio__device__irq.md) <br>_Interrupt info._  |
| struct | [**opae\_vfio\_device\_region**](structopae__vfio__device__region.md) <br>_MMIO region info._  |
| struct | [**opae\_vfio\_group**](structopae__vfio__group.md) <br>_VFIO group._  |
| struct | [**opae\_vfio\_iova\_range**](structopae__vfio__iova__range.md) <br>_IO Virtual Address Range._  |
| struct | [**opae\_vfio\_sparse\_info**](structopae__vfio__sparse__info.md) <br>_MMIO sparse-mappable region info._  |

## Public Types

| Type | Name |
| ---: | :--- |
| enum  | [**opae\_vfio\_buffer\_flags**](#enum-opae_vfio_buffer_flags)  <br>_Flags for_ [_**opae\_vfio\_buffer\_allocate\_ex()**_](vfio_8h.md#function-opae_vfio_buffer_allocate_ex) _._ |




## Public Functions

| Type | Name |
| ---: | :--- |
|  int | [**opae\_vfio\_buffer\_allocate**](#function-opae_vfio_buffer_allocate) (struct [**opae\_vfio**](structopae__vfio.md) \* v, size\_t \* size, uint8\_t \*\* buf, uint64\_t \* iova) <br>_Allocate and map system buffer._  |
|  int | [**opae\_vfio\_buffer\_allocate\_ex**](#function-opae_vfio_buffer_allocate_ex) (struct [**opae\_vfio**](structopae__vfio.md) \* v, size\_t \* size, uint8\_t \*\* buf, uint64\_t \* iova, int flags) <br>_Allocate and map system buffer (extended w/ flags)_  |
|  int | [**opae\_vfio\_buffer\_free**](#function-opae_vfio_buffer_free) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint8\_t \* buf) <br>_Unmap and free a system buffer._  |
|  struct [**opae\_vfio\_buffer**](structopae__vfio__buffer.md) \* | [**opae\_vfio\_buffer\_info**](#function-opae_vfio_buffer_info) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint8\_t \* vaddr) <br>_Extract the internal data structure pointer for the given vaddr._  |
|  void | [**opae\_vfio\_close**](#function-opae_vfio_close) (struct [**opae\_vfio**](structopae__vfio.md) \* v) <br>_Release and close a VFIO device._  |
|  int | [**opae\_vfio\_irq\_disable**](#function-opae_vfio_irq_disable) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint32\_t index, uint32\_t subindex) <br>_Disable an IRQ._  |
|  int | [**opae\_vfio\_irq\_enable**](#function-opae_vfio_irq_enable) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint32\_t index, uint32\_t subindex, int event\_fd) <br>_Enable an IRQ._  |
|  int | [**opae\_vfio\_irq\_mask**](#function-opae_vfio_irq_mask) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint32\_t index, uint32\_t subindex) <br>_Mask an IRQ._  |
|  int | [**opae\_vfio\_irq\_unmask**](#function-opae_vfio_irq_unmask) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint32\_t index, uint32\_t subindex) <br>_Unmask an IRQ._  |
|  int | [**opae\_vfio\_open**](#function-opae_vfio_open) (struct [**opae\_vfio**](structopae__vfio.md) \* v, const char \* pciaddr) <br>_Open and populate a VFIO device._  |
|  int | [**opae\_vfio\_region\_get**](#function-opae_vfio_region_get) (struct [**opae\_vfio**](structopae__vfio.md) \* v, uint32\_t index, uint8\_t \*\* ptr, size\_t \* size) <br>_Query device MMIO region._  |
|  int | [**opae\_vfio\_secure\_open**](#function-opae_vfio_secure_open) (struct [**opae\_vfio**](structopae__vfio.md) \* v, const char \* pciaddr, const char \* token) <br>_Open and populate a VFIO device._  |








# Detailed Description


Presents a simple interface for interacting with a PCIe device that is bound to the vfio-pci driver. See [https://kernel.org/doc/Documentation/vfio.txt](https://kernel.org/doc/Documentation/vfio.txt) for a description of vfio-pci.


Provides APIs for opening/closing the device, querying info about the MMIO regions of the device, and allocating/mapping and freeing/unmapping DMA buffers. 


    
## Public Types Documentation


### enum opae\_vfio\_buffer\_flags 

```C++
enum opae_vfio_buffer_flags {
    OPAE_VFIO_BUF_PREALLOCATED = 1
};
```



## Public Functions Documentation


### function opae\_vfio\_buffer\_allocate 

_Allocate and map system buffer._ 
```C++
int opae_vfio_buffer_allocate (
    struct opae_vfio * v,
    size_t * size,
    uint8_t ** buf,
    uint64_t * iova
) 
```



Allocate, map, and retrieve info for a system buffer capable of DMA. Saves an entry in the v-&gt;cont\_buffers list. If the buffer is not explicitly freed by opae\_vfio\_buffer\_free, it will be freed during opae\_vfio\_close.


mmap is used for the allocation. If the size is greater than 2MB, then the allocation request is fulfilled by a 1GB huge page. Else, if the size is greater than 4096, then the request is fulfilled by a 2MB huge page. Else, the request is fulfilled by the non-huge page pool.




**Note:**

Allocations from the huge page pool require that huge pages be configured on the system. Huge pages may be configured on the kernel boot command prompt. Example default\_hugepagesz=1G hugepagesz=1G hugepages=2 hugepagesz=2M hugepages=8




**Note:**

Huge pages may also be configured at runtime. Example sudo sh -c 'echo 8 &gt; /sys/kernel/mm/hugepages/hugepages-2048kB/nr\_hugepages' sudo sh -c 'echo 2 &gt; /sys/kernel/mm/hugepages/hugepages-1048576kB/nr\_hugepages'




**Note:**

Be sure that the IOMMU is also enabled using the follow kernel boot command: intel\_iommu=on




**Parameters:**


* `v` The open OPAE VFIO device. 
* `size` A pointer to the requested size. The size may be rounded to the next page size prior to return from the function. 
* `buf` Optional pointer to receive the virtual address for the buffer. Pass NULL to ignore. 
* `iova` Optional pointer to receive the IOVA address for the buffer. Pass NULL to ignore. 



**Returns:**

Non-zero on error. Zero on success.


Example 
opae_vfio v;

size_t sz;
uint8_t *buf_2m_virt = NULL;
uint8_t *buf_1g_virt = NULL;
uint64_t buf_2m_iova = 0;
uint64_t buf_1g_iova = 0;

if (opae_vfio_open(&v, "0000:00:00.0")) {
  // handle error
} else {
  sz = 2 * 1024 * 1024;
  if (opae_vfio_buffer_allocate(&v,
                                &sz,
                                &buf_2m_virt,
                                &buf_2m_iova)) {
    // handle allocation error
  }

  sz = 1024 * 1024 * 1024;
  if (opae_vfio_buffer_allocate(&v,
                                &sz,
                                &buf_1g_virt,
                                &buf_1g_iova)) {
    // handle allocation error
  }
}
 


        

### function opae\_vfio\_buffer\_allocate\_ex 

_Allocate and map system buffer (extended w/ flags)_ 
```C++
int opae_vfio_buffer_allocate_ex (
    struct opae_vfio * v,
    size_t * size,
    uint8_t ** buf,
    uint64_t * iova,
    int flags
) 
```



Allocate, map, and retrieve info for a system buffer capable of DMA. Saves an entry in the v-&gt;cont\_buffers list. If the buffer is not explicitly freed by opae\_vfio\_buffer\_free, it will be freed during opae\_vfio\_close, unless OPAE\_VFIO\_BUF\_PREALLOCATED is used in which case the buffer is not freed by this library.


When not using OPAE\_VFIO\_BUF\_PREALLOCATED, mmap is used for the allocation. If the size is greater than 2MB, then the allocation request is fulfilled by a 1GB huge page. Else, if the size is greater than 4096, then the request is fulfilled by a 2MB huge page. Else, the request is fulfilled by the non-huge page pool.




**Parameters:**


* `v` The open OPAE VFIO device. 
* `size` A pointer to the requested size. The size may be rounded to the next page size prior to return from the function. 
* `buf` Optional pointer to receive the virtual address for the buffer/input buffer pointer when using OPAE\_VFIO\_BUF\_PREALLOCATED. Pass NULL to ignore. 
* `iova` Optional pointer to receive the IOVA address for the buffer. Pass NULL to ignore. 



**Returns:**

Non-zero on error. Zero on success.


Example 
opae_vfio v;

size_t sz = MY_BUF_SIZE;
uint8_t *prealloc_virt = NULL;
uint64_t iova = 0;

prealloc_virt = allocate_my_buffer(sz);

if (opae_vfio_open(&v, "0000:00:00.0")) {
  // handle error
} else {
  if (opae_vfio_buffer_allocate_ex(&v,
                                   &sz,
                                   &prealloc_virt,
                                   &iova,
                                   OPAE_VFIO_BUF_PREALLOCATED)) {
    // handle allocation error
  }
}
 


        

### function opae\_vfio\_buffer\_free 

_Unmap and free a system buffer._ 
```C++
int opae_vfio_buffer_free (
    struct opae_vfio * v,
    uint8_t * buf
) 
```



The buffer corresponding to buf must have been created by a previous call to opae\_vfio\_buffer\_allocate.




**Parameters:**


* `v` The open OPAE VFIO device. 
* `buf` The virtual address corresponding to the buffer to be freed. 



**Returns:**

Non-zero on error. Zero on success.


Example 
size_t sz;
uint8_t *buf_2m_virt = NULL;
uint64_t buf_2m_iova = 0;

sz = 2 * 1024 * 1024;
if (opae_vfio_buffer_allocate(&v,
                              &sz,
                              &buf_2m_virt,
                              &buf_2m_iova)) {
  // handle allocation error
} else {
  // use the buffer

  if (opae_vfio_buffer_free(&v, buf_2m_virt)) {
    // handle free error
  }
}
 


        

### function opae\_vfio\_buffer\_info 

_Extract the internal data structure pointer for the given vaddr._ 
```C++
struct opae_vfio_buffer * opae_vfio_buffer_info (
    struct opae_vfio * v,
    uint8_t * vaddr
) 
```



The virtual address vaddr must correspond to a buffer previously allocated by [**opae\_vfio\_buffer\_allocate()**](vfio_8h.md#function-opae_vfio_buffer_allocate) or [**opae\_vfio\_buffer\_allocate\_ex()**](vfio_8h.md#function-opae_vfio_buffer_allocate_ex).




**Parameters:**


* `v` The open OPAE VFIO device. 
* `vaddr` The user virtual address of the desired buffer info struct. 



**Returns:**

NULL on lookup error. 





        

### function opae\_vfio\_close 

_Release and close a VFIO device._ 
```C++
void opae_vfio_close (
    struct opae_vfio * v
) 
```



The given device pointer must have been previously initialized by opae\_vfio\_open. Releases all data structures, including any DMA buffer allocations that have not be explicitly freed by opae\_vfio\_buffer\_free.




**Parameters:**


* `v` Storage for the device info. May be stack-resident.

Example 
opae_vfio v;

if (opae_vfio_open(&v, "0000:00:00.0")) {
  // handle error
} else {
  // interact with the device
  ...
  // free the device
  opae_vfio_close(&v);
}



Example 
$ sudo opaevfio -r 0000:00:00.0
 


        

### function opae\_vfio\_irq\_disable 

_Disable an IRQ._ 
```C++
int opae_vfio_irq_disable (
    struct opae_vfio * v,
    uint32_t index,
    uint32_t subindex
) 
```





**Parameters:**


* `v` The open OPAE VFIO device. 
* `index` The IRQ category. For MSI-X, use VFIO\_PCI\_MSIX\_IRQ\_INDEX. 
* `subindex` The IRQ to disable. 



**Returns:**

Non-zero on error. Zero on success. 





        

### function opae\_vfio\_irq\_enable 

_Enable an IRQ._ 
```C++
int opae_vfio_irq_enable (
    struct opae_vfio * v,
    uint32_t index,
    uint32_t subindex,
    int event_fd
) 
```





**Parameters:**


* `v` The open OPAE VFIO device. 
* `index` The IRQ category. For MSI-X, use VFIO\_PCI\_MSIX\_IRQ\_INDEX. 
* `subindex` The IRQ to enable. 
* `event_fd` The file descriptor, created by eventfd(). Interrupts will result in this event\_fd being signaled. 



**Returns:**

Non-zero on error. Zero on success. 





        

### function opae\_vfio\_irq\_mask 

_Mask an IRQ._ 
```C++
int opae_vfio_irq_mask (
    struct opae_vfio * v,
    uint32_t index,
    uint32_t subindex
) 
```





**Parameters:**


* `v` The open OPAE VFIO device. 
* `index` The IRQ category. For MSI-X, use VFIO\_PCI\_MSIX\_IRQ\_INDEX. 
* `subindex` The IRQ to mask. 



**Returns:**

Non-zero on error. Zero on success. 





        

### function opae\_vfio\_irq\_unmask 

_Unmask an IRQ._ 
```C++
int opae_vfio_irq_unmask (
    struct opae_vfio * v,
    uint32_t index,
    uint32_t subindex
) 
```





**Parameters:**


* `v` The open OPAE VFIO device. 
* `index` The IRQ category. For MSI-X, use VFIO\_PCI\_MSIX\_IRQ\_INDEX. 
* `subindex` The IRQ to unmask. 



**Returns:**

Non-zero on error. Zero on success. 





        

### function opae\_vfio\_open 

_Open and populate a VFIO device._ 
```C++
int opae_vfio_open (
    struct opae_vfio * v,
    const char * pciaddr
) 
```



Opens the PCIe device corresponding to the address given in pciaddr. The device must be bound to the vfio-pci driver prior to opening it. The data structures corresponding to IOVA space, MMIO regions, and DMA buffers are initialized.




**Parameters:**


* `v` Storage for the device info. May be stack-resident. 
* `pciaddr` The PCIe address of the requested device. 



**Returns:**

Non-zero on error. Zero on success.


Example 
$ sudo opaevfio -i 0000:00:00.0 -u user -g group



Example 
opae_vfio v;

if (opae_vfio_open(&v, "0000:00:00.0")) {
  // handle error
}
 


        

### function opae\_vfio\_region\_get 

_Query device MMIO region._ 
```C++
int opae_vfio_region_get (
    struct opae_vfio * v,
    uint32_t index,
    uint8_t ** ptr,
    size_t * size
) 
```



Retrieves info describing the MMIO region with the given region index. The device structure v must have been previously opened by a call to opae\_vfio\_open.




**Parameters:**


* `v` The open OPAE VFIO device. 
* `index` The zero-based index of the desired MMIO region. 
* `ptr` Optional pointer to receive the virtual address for the region. Pass NULL to ignore. 
* `size` Optional pointer to receive the size of the MMIO region. Pass NULL to ignore. 



**Returns:**

Non-zero on error (including index out-of-range). Zero on success.


Example 
opae_vfio v;

uint8_t *fme_virt = NULL;
uint8_t *port_virt = NULL;
size_t fme_size = 0;
size_t port_size = 0;

if (opae_vfio_open(&v, "0000:00:00.0")) {
  // handle error
} else {
  opae_vfio_region_get(&v, 0, &fme_virt, &fme_size);
  opae_vfio_region_get(&v, 2, &port_virt, &port_size);
}
 


        

### function opae\_vfio\_secure\_open 

_Open and populate a VFIO device._ 
```C++
int opae_vfio_secure_open (
    struct opae_vfio * v,
    const char * pciaddr,
    const char * token
) 
```



Opens the PCIe device corresponding to the address given in pciaddr, using the VF token (GUID) given in token. The device must be bound to the vfio-pci driver prior to opening it. The data structures corresponding to IOVA space, MMIO regions, and DMA buffers are initialized.




**Parameters:**


* `v` Storage for the device info. May be stack-resident. 
* `pciaddr` The PCIe address of the requested device. 
* `token` The GUID representing the VF token. 



**Returns:**

Non-zero on error. Zero on success.


Example 
$ sudo opaevfio -i 0000:00:00.0 -u user -g group



Example 
opae_vfio v;

if (opae_vfio_secure_open(&v, "0000:00:00.0",
                          "00f5ad6b-2edd-422e-9d1e-34124c686fec")) {
  // handle error
}
 


        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`