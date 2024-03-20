
# Struct mem\_link



[**ClassList**](annotated.md) **>** [**mem\_link**](structmem__link.md)



_Provides an API for allocating/freeing a logical address space._ [More...](#detailed-description)

* `#include <mem_alloc.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint64\_t | [**address**](#variable-address)  <br> |
|  struct [**mem\_link**](structmem__link.md) \* | [**next**](#variable-next)  <br> |
|  struct [**mem\_link**](structmem__link.md) \* | [**prev**](#variable-prev)  <br> |
|  uint64\_t | [**size**](#variable-size)  <br> |










# Detailed Description


There is no interaction with any OS memory allocation infrastructure, whether malloc, mmap, etc. The "address ranges" tracked by this allocator are arbitrary 64-bit integers. The allocator simply provides the bookeeping logic that ensures that a unique address with the appropriate size is returned for each allocation request, and that an allocation can be freed, ie released back to the available pool of logical address space for future allocations. The memory backing the allocator's internal data structures is managed by malloc()/free(). 


    
## Public Attributes Documentation


### variable address 

```C++
uint64_t mem_link::address;
```




### variable next 

```C++
struct mem_link* mem_link::next;
```




### variable prev 

```C++
struct mem_link* mem_link::prev;
```




### variable size 

```C++
uint64_t mem_link::size;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/mem_alloc.h`