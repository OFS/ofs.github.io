
# Class opae::fpga::types::sysobject



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md)



_Wraps the OPAE fpga\_object primitive._ [More...](#detailed-description)

* `#include <sysobject.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  std::vector&lt; uint8\_t &gt; | [**bytes**](#function-bytes-12) (int flags=0) const<br>_Get all raw bytes from the object._  |
|  std::vector&lt; uint8\_t &gt; | [**bytes**](#function-bytes-22) (uint32\_t offset, uint32\_t size, int flags=0) const<br>_Get a subset of raw bytes from the object._  |
|  [**fpga\_object**](types_8h.md#typedef-fpga_object) | [**c\_type**](#function-c_type) () const<br>_Retrieve the underlying fpga\_object primitive._  |
|  [**sysobject::ptr\_t**](classopae_1_1fpga_1_1types_1_1sysobject.md#typedef-ptr_t) | [**get**](#function-get-14) (const std::string & name, int flags=0) <br>_Get a sysobject from an object._  |
|  [**sysobject::ptr\_t**](classopae_1_1fpga_1_1types_1_1sysobject.md#typedef-ptr_t) | [**get**](#function-get-24) (int index) <br>_Get a sysobject from a container object._  |
|   | [**operator fpga\_object**](#function-operator-fpga_object) () const<br>_Retrieve the underlying fpga\_object primitive._  |
|  [**sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md) & | [**operator=**](#function-operator) (const [**sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md) & o) = delete<br> |
|  uint64\_t | [**read64**](#function-read64) (int flags=0) const<br>_Read a 64-bit value from an FPGA object._  |
|  uint32\_t | [**size**](#function-size) () const<br>_Get the size (in bytes) of the object._  |
|   | [**sysobject**](#function-sysobject-13) () = delete<br> |
|   | [**sysobject**](#function-sysobject-23) (const [**sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md) & o) = delete<br> |
|  enum [**fpga\_sysobject\_type**](types__enum_8h.md#enum-fpga_sysobject_type) | [**type**](#function-type) () const<br>_Get the object type (attribute or container)_  |
|  void | [**write64**](#function-write64) (uint64\_t value, int flags=0) const<br>_Write 64-bit value to an FPGA object._  |
| virtual  | [**~sysobject**](#function-sysobject) () <br> |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**sysobject::ptr\_t**](classopae_1_1fpga_1_1types_1_1sysobject.md#typedef-ptr_t) | [**get**](#function-get-34) ([**token::ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) t, const std::string & name, int flags=0) <br>_Get a sysobject from a token._  |
|  [**sysobject::ptr\_t**](classopae_1_1fpga_1_1types_1_1sysobject.md#typedef-ptr_t) | [**get**](#function-get-44) ([**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) h, const std::string & name, int flags=0) <br>_Get a sysobject from a handle._  |







# Detailed Description


sysobject's are created from a call to fpgaTokenGetObject, fpgaHandleGetObject, or fpgaObjectGetObject 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<sysobject> opae::fpga::types::sysobject::ptr_t;
```



## Public Functions Documentation


### function bytes [1/2]

_Get all raw bytes from the object._ 
```C++
std::vector< uint8_t > opae::fpga::types::sysobject::bytes (
    int flags=0
) const
```





**Parameters:**


* `flags` Flags that control how object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the data.



**Returns:**

A vector of all bytes in the object. 





        

### function bytes [2/2]

_Get a subset of raw bytes from the object._ 
```C++
std::vector< uint8_t > opae::fpga::types::sysobject::bytes (
    uint32_t offset,
    uint32_t size,
    int flags=0
) const
```





**Parameters:**


* `offset` The bytes offset for the start of the returned vector. 
* `size` The number of bytes for the returned vector. 
* `flags` Flags that control how object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the data.



**Returns:**

A vector of size bytes in the object starting at offset. 





        

### function c\_type 

```C++
inline fpga_object opae::fpga::types::sysobject::c_type () const
```




### function get [1/4]

_Get a sysobject from an object._ 
```C++
sysobject::ptr_t opae::fpga::types::sysobject::get (
    const std::string & name,
    int flags=0
) 
```



This will be read-write if its parent was created from a handle..




**Parameters:**


* `name` An identifier representing an object belonging to this object. 
* `flags` Control behavior of object identification and creation. FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects. Flags are defaulted to 0 meaning no flags.



**Returns:**

A shared\_ptr to a sysobject instance. 





        

### function get [2/4]

_Get a sysobject from a container object._ 
```C++
sysobject::ptr_t opae::fpga::types::sysobject::get (
    int index
) 
```



This will be read-write if its parent was created from a handle..




**Parameters:**


* `index` An index number to get.



**Returns:**

A shared\_ptr to a sysobject instance. 





        

### function operator fpga\_object 

```C++
inline opae::fpga::types::sysobject::operator fpga_object () const
```




### function operator= 

```C++
sysobject & opae::fpga::types::sysobject::operator= (
    const sysobject & o
) = delete
```




### function read64 

_Read a 64-bit value from an FPGA object._ 
```C++
uint64_t opae::fpga::types::sysobject::read64 (
    int flags=0
) const
```



The value is assumed to be in string format and will be parsed. See flags below for changing that behavior.




**Parameters:**


* `flags` Flags that control how the object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the data. If FPGA\_OBJECT\_RAW is used, then the data will be read as raw bytes into the uint64\_t pointer variable. Flags are defaulted to 0 meaning no flags.



**Returns:**

A 64-bit value from the object. 





        

### function size 

_Get the size (in bytes) of the object._ 
```C++
uint32_t opae::fpga::types::sysobject::size () const
```





**Returns:**

The number of bytes that the object occupies in memory. 





        

### function sysobject [1/3]

```C++
opae::fpga::types::sysobject::sysobject () = delete
```




### function sysobject [2/3]

```C++
opae::fpga::types::sysobject::sysobject (
    const sysobject & o
) = delete
```




### function type 

```C++
enum fpga_sysobject_type opae::fpga::types::sysobject::type () const
```




### function write64 

_Write 64-bit value to an FPGA object._ 
```C++
void opae::fpga::types::sysobject::write64 (
    uint64_t value,
    int flags=0
) const
```



The value will be converted to string before writing. See flags below for changing that behavior.




**Parameters:**


* `value` The value to write to the object. 
* `flags` Flags that control how the object is written If FPGA\_OBJECT\_RAW is used, then the value will be written as raw bytes. Flags are defaulted to 0 meaning no flags.



**Note:**

This operation will force a sync operation to update its cached buffer 





        

### function ~sysobject 

```C++
virtual opae::fpga::types::sysobject::~sysobject () 
```



## Public Static Functions Documentation


### function get [3/4]

_Get a sysobject from a token._ 
```C++
static sysobject::ptr_t opae::fpga::types::sysobject::get (
    token::ptr_t t,
    const std::string & name,
    int flags=0
) 
```



This will be read-only.




**Parameters:**


* `t` Token object representing a resource. 
* `name` An identifier representing an object belonging to a resource represented by the token. 
* `flags` Control behavior of object identification and creation. FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects below the current object identified by name.



**Returns:**

A shared\_ptr to a sysobject instance. 





        

### function get [4/4]

_Get a sysobject from a handle._ 
```C++
static sysobject::ptr_t opae::fpga::types::sysobject::get (
    handle::ptr_t h,
    const std::string & name,
    int flags=0
) 
```



This will be read-write.




**Parameters:**


* `h` Handle object representing an open resource. 
* `name` An identifier representing an object belonging to a resource represented by the handle. 
* `flags` Control behavior of object identification and creation. FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects below the current object identified by name.



**Returns:**

A shared\_ptr to a sysobject instance. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/sysobject.h`