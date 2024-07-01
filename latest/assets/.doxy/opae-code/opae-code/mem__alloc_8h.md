
# File mem\_alloc.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**mem\_alloc.h**](mem__alloc_8h.md)

[Go to the source code of this file.](mem__alloc_8h_source.md)



* `#include <stdint.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**mem\_alloc**](structmem__alloc.md) <br> |
| struct | [**mem\_link**](structmem__link.md) <br>_Provides an API for allocating/freeing a logical address space._  |





## Public Functions

| Type | Name |
| ---: | :--- |
|  int | [**mem\_alloc\_add\_free**](#function-mem_alloc_add_free) (struct [**mem\_alloc**](structmem__alloc.md) \* m, uint64\_t address, uint64\_t size) <br>_Add a memory region to an allocator._  |
|  void | [**mem\_alloc\_destroy**](#function-mem_alloc_destroy) (struct [**mem\_alloc**](structmem__alloc.md) \* m) <br>_Destroy a memory allocator object._  |
|  int | [**mem\_alloc\_get**](#function-mem_alloc_get) (struct [**mem\_alloc**](structmem__alloc.md) \* m, uint64\_t \* address, uint64\_t size) <br>_Allocate memory._  |
|  void | [**mem\_alloc\_init**](#function-mem_alloc_init) (struct [**mem\_alloc**](structmem__alloc.md) \* m) <br>_Initialize a memory allocator object._  |
|  int | [**mem\_alloc\_put**](#function-mem_alloc_put) (struct [**mem\_alloc**](structmem__alloc.md) \* m, uint64\_t address) <br>_Free memory._  |








## Public Functions Documentation


### function mem\_alloc\_add\_free 

_Add a memory region to an allocator._ 
```C++
int mem_alloc_add_free (
    struct mem_alloc * m,
    uint64_t address,
    uint64_t size
) 
```



The memory region is added to the allocatable space and is immediately ready for allocation.




**Parameters:**


* `m` The memory allocator object. 
* `address` The beginning address of the memory region. 
* `size` The size of the memory region. 



**Returns:**

Non-zero on error. Zero on success.


Example 
struct mem_alloc m;

mem_alloc_init(&m);

if (mem_alloc_add_free(&m, 0x4000, 4096)) {
  // handle error
}
 


        

### function mem\_alloc\_destroy 

_Destroy a memory allocator object._ 
```C++
void mem_alloc_destroy (
    struct mem_alloc * m
) 
```



Frees all of the allocator's internal resources.




**Parameters:**


* `m` The address of the memory allocator to destroy. 




        

### function mem\_alloc\_get 

_Allocate memory._ 
```C++
int mem_alloc_get (
    struct mem_alloc * m,
    uint64_t * address,
    uint64_t size
) 
```



Retrieve an available memory address for a free block that is at least size bytes.




**Parameters:**


* `m` The memory allocator object. 
* `address` The retrieved address for the allocation. 
* `size` The request size in bytes. 



**Returns:**

Non-zero on error. Zero on success.


Example 
struct mem_alloc m;
uint64_t addr = 0;

mem_alloc_init(&m);

if (mem_alloc_add_free(&m, 0x4000, 4096)) {
  // handle error
}

...

if (mem_alloc_get(&m, &addr, 4096)) {
  // handle allocation error
}
 


        

### function mem\_alloc\_init 

_Initialize a memory allocator object._ 
```C++
void mem_alloc_init (
    struct mem_alloc * m
) 
```



After the call, the allocator is initialized but "empty". To add allocatable memory regions, further initialize the allocator with [**mem\_alloc\_add\_free()**](mem__alloc_8h.md#function-mem_alloc_add_free).




**Parameters:**


* `m` The address of the memory allocator to initialize. 




        

### function mem\_alloc\_put 

_Free memory._ 
```C++
int mem_alloc_put (
    struct mem_alloc * m,
    uint64_t address
) 
```



Release a previously-allocated memory block.




**Parameters:**


* `m` The memory allocator object. 
* `address` The address to free. 



**Returns:**

Non-zero on error. Zero on success.


Example 
struct mem_alloc m;
uint64_t addr = 0;

mem_alloc_init(&m);

if (mem_alloc_add_free(&m, 0x4000, 4096)) {
  // handle error
}

...

if (mem_alloc_get(&m, &addr, 4096)) {
  // handle allocation error
}

...

if (mem_alloc_put(&m, addr)) {
  // handle free error
}
 


        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/mem_alloc.h`