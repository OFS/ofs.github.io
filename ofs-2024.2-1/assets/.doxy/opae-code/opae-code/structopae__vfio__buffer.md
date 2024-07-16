
# Struct opae\_vfio\_buffer



[**ClassList**](annotated.md) **>** [**opae\_vfio\_buffer**](structopae__vfio__buffer.md)



_System DMA buffer._ [More...](#detailed-description)

* `#include <vfio.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  uint64\_t | [**buffer\_iova**](#variable-buffer_iova)  <br>_Buffer IOVA address._  |
|  uint8\_t \* | [**buffer\_ptr**](#variable-buffer_ptr)  <br>_Buffer virtual address._  |
|  size\_t | [**buffer\_size**](#variable-buffer_size)  <br>_Buffer size._  |
|  int | [**flags**](#variable-flags)  <br>_See opae\_vfio\_buffer\_flags._  |










# Detailed Description


Describes a system memory address space that is capable of DMA. 


    
## Public Attributes Documentation


### variable buffer\_iova 

```C++
uint64_t opae_vfio_buffer::buffer_iova;
```




### variable buffer\_ptr 

```C++
uint8_t* opae_vfio_buffer::buffer_ptr;
```




### variable buffer\_size 

```C++
size_t opae_vfio_buffer::buffer_size;
```




### variable flags 

```C++
int opae_vfio_buffer::flags;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/vfio.h`