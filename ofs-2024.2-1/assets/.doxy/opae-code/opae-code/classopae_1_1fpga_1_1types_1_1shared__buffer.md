
# Class opae::fpga::types::shared\_buffer



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md)



_Host/AFU shared memory blocks._ [More...](#detailed-description)

* `#include <shared_buffer.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |
| typedef std::size\_t | [**size\_t**](#typedef-size_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  uint8\_t \* | [**c\_type**](#function-c_type) () const<br>_Retrieve the virtual address of the buffer base._  |
|  int | [**compare**](#function-compare) ([**ptr\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-ptr_t) other, [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) len) const<br>_Compare this_ [_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _(the first len bytes) to that held in other, using memcmp()._ |
|  void | [**fill**](#function-fill) (int c) <br>_Write c to each byte location in the buffer._  |
|  uint64\_t | [**io\_address**](#function-io_address) () const<br>_Retrieve the address of the buffer suitable for programming into the accelerator device._  |
|  [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) & | [**operator=**](#function-operator) (const [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) &) = delete<br> |
|  [**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) | [**owner**](#function-owner) () const<br>_Retrieve the handle smart pointer associated with this buffer._  |
|  T | [**read**](#function-read) ([**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) offset) const<br>_Read a T-sized block of memory at the given location._  |
|  void | [**release**](#function-release) () <br>_Disassociate the_ [_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _object from the resource used to create it._ |
|   | [**shared\_buffer**](#function-shared_buffer-12) (const [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) &) = delete<br> |
|  [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) | [**size**](#function-size) () const<br>_Retrieve the length of the buffer in bytes._  |
|  void | [**write**](#function-write) (const T & value, [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) offset) <br>_Write a T-sized block of memory to the given location._  |
|  uint64\_t | [**wsid**](#function-wsid) () const<br>_Retrieve the underlying buffer's workspace id._  |
| virtual  | [**~shared\_buffer**](#function-shared_buffer) () <br>[_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _destructor._ |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**shared\_buffer::ptr\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-ptr_t) | [**allocate**](#function-allocate) ([**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) handle, [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) len, bool read\_only=false) <br>[_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _factory method - allocate a_[_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _._ |
|  [**shared\_buffer::ptr\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-ptr_t) | [**attach**](#function-attach) ([**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) handle, uint8\_t \* base, [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) len, bool read\_only=false) <br>_Attach a pre-allocated buffer to a_ [_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _object._ |



## Protected Attributes

| Type | Name |
| ---: | :--- |
|  [**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) | [**handle\_**](#variable-handle_)  <br> |
|  uint64\_t | [**io\_address\_**](#variable-io_address_)  <br> |
|  [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) | [**len\_**](#variable-len_)  <br> |
|  uint8\_t \* | [**virt\_**](#variable-virt_)  <br> |
|  uint64\_t | [**wsid\_**](#variable-wsid_)  <br> |


## Protected Functions

| Type | Name |
| ---: | :--- |
|   | [**shared\_buffer**](#function-shared_buffer-22) ([**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) handle, [**size\_t**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#typedef-size_t) len, uint8\_t \* virt, uint64\_t wsid, uint64\_t io\_address) <br> |


# Detailed Description


[**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) abstracts a memory block that may be shared between the host cpu and an accelerator. The block may be allocated by the [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) class itself (see allocate), or it may be allocated elsewhere and then attached to a [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) object via attach. 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<shared_buffer> opae::fpga::types::shared_buffer::ptr_t;
```




### typedef size\_t 

```C++
typedef std::size_t opae::fpga::types::shared_buffer::size_t;
```



## Public Functions Documentation


### function c\_type 

_Retrieve the virtual address of the buffer base._ 
```C++
inline uint8_t * opae::fpga::types::shared_buffer::c_type () const
```





**Note:**

Instances of a shared buffer can only be created using either 'allocate' or 'attach' static factory function. Because these functions return a shared pointer (std::shared\_ptr) to the instance, references to an instance are counted automatically by design of the shared\_ptr class. Calling '[**c\_type()**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#function-c_type)' function is provided to get access to the raw data but isn't used in tracking its reference count. Assigning this to a variable should be done in limited scopes as this variable can be defined in an outer scope and may outlive the [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) object. Once the reference count in the shared\_ptr reaches zero, the [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) object will be released and deallocated, turning any variables assigned from a call to '[**c\_type()**](classopae_1_1fpga_1_1types_1_1shared__buffer.md#function-c_type)' into dangling pointers. 





        

### function compare 

```C++
int opae::fpga::types::shared_buffer::compare (
    ptr_t other,
    size_t len
) const
```




### function fill 

```C++
void opae::fpga::types::shared_buffer::fill (
    int c
) 
```




### function io\_address 

```C++
inline uint64_t opae::fpga::types::shared_buffer::io_address () const
```




### function operator= 

```C++
shared_buffer & opae::fpga::types::shared_buffer::operator= (
    const shared_buffer &
) = delete
```




### function owner 

```C++
inline handle::ptr_t opae::fpga::types::shared_buffer::owner () const
```




### function read 

_Read a T-sized block of memory at the given location._ 
```C++
template<typename T typename T>
inline T opae::fpga::types::shared_buffer::read (
    size_t offset
) const
```





**Parameters:**


* `offset` The byte offset from the start of the buffer. 



**Returns:**

A T from buffer base + offset. 





        

### function release 

_Disassociate the_ [_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _object from the resource used to create it._
```C++
void opae::fpga::types::shared_buffer::release () 
```



If the buffer was allocated using the allocate function then the buffer is freed. 


        

### function shared\_buffer [1/2]

```C++
opae::fpga::types::shared_buffer::shared_buffer (
    const shared_buffer &
) = delete
```




### function size 

```C++
inline size_t opae::fpga::types::shared_buffer::size () const
```




### function write 

_Write a T-sized block of memory to the given location._ 
```C++
template<typename T typename T>
inline void opae::fpga::types::shared_buffer::write (
    const T & value,
    size_t offset
) 
```





**Parameters:**


* `value` The value to write. 
* `offset` The byte offset from the start of the buffer. 




        

### function wsid 

```C++
inline uint64_t opae::fpga::types::shared_buffer::wsid () const
```




### function ~shared\_buffer 

```C++
virtual opae::fpga::types::shared_buffer::~shared_buffer () 
```



## Public Static Functions Documentation


### function allocate 

[_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _factory method - allocate a_[_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _._
```C++
static shared_buffer::ptr_t opae::fpga::types::shared_buffer::allocate (
    handle::ptr_t handle,
    size_t len,
    bool read_only=false
) 
```





**Parameters:**


* `handle` The handle used to allocate the buffer. 
* `len` The length in bytes of the requested buffer. 



**Returns:**

A valid [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) smart pointer on success, or an empty smart pointer on failure. 





        

### function attach 

_Attach a pre-allocated buffer to a_ [_**shared\_buffer**_](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _object._
```C++
static shared_buffer::ptr_t opae::fpga::types::shared_buffer::attach (
    handle::ptr_t handle,
    uint8_t * base,
    size_t len,
    bool read_only=false
) 
```





**Parameters:**


* `handle` The handle used to attach the buffer. 
* `base` The base of the pre-allocated memory. 
* `len` The size of the pre-allocated memory, which must be a multiple of the page size. 



**Returns:**

A valid [**shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) smart pointer on success, or an empty smart pointer on failure. 





        
## Protected Attributes Documentation


### variable handle\_ 

```C++
handle::ptr_t opae::fpga::types::shared_buffer::handle_;
```




### variable io\_address\_ 

```C++
uint64_t opae::fpga::types::shared_buffer::io_address_;
```




### variable len\_ 

```C++
size_t opae::fpga::types::shared_buffer::len_;
```




### variable virt\_ 

```C++
uint8_t* opae::fpga::types::shared_buffer::virt_;
```




### variable wsid\_ 

```C++
uint64_t opae::fpga::types::shared_buffer::wsid_;
```



## Protected Functions Documentation


### function shared\_buffer [2/2]

```C++
opae::fpga::types::shared_buffer::shared_buffer (
    handle::ptr_t handle,
    size_t len,
    uint8_t * virt,
    uint64_t wsid,
    uint64_t io_address
) 
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/shared_buffer.h`