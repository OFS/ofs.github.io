
# File sysobject.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**sysobject.h**](sysobject_8h.md)

[Go to the source code of this file.](sysobject_8h_source.md)

_Functions to read/write from system objects._ [More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaDestroyObject**](#function-fpgadestroyobject) ([**fpga\_object**](types_8h.md#typedef-fpga_object) \* obj) <br>_Free memory used for the fpga\_object data structure._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaHandleGetObject**](#function-fpgahandlegetobject) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, const char \* name, [**fpga\_object**](types_8h.md#typedef-fpga_object) \* object, int flags) <br>_Create an_ `fpga_object` _data structure from a handle._ |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectGetObject**](#function-fpgaobjectgetobject) ([**fpga\_object**](types_8h.md#typedef-fpga_object) parent, const char \* name, [**fpga\_object**](types_8h.md#typedef-fpga_object) \* object, int flags) <br>_Create an_ `fpga_object` _data structure from a parent object._ |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectGetObjectAt**](#function-fpgaobjectgetobjectat) ([**fpga\_object**](types_8h.md#typedef-fpga_object) parent, size\_t idx, [**fpga\_object**](types_8h.md#typedef-fpga_object) \* object) <br>_Create an_ `fpga_object` _data structure from a parent object using a given index._ |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectGetSize**](#function-fpgaobjectgetsize) ([**fpga\_object**](types_8h.md#typedef-fpga_object) obj, uint32\_t \* value, int flags) <br>_Retrieve the size of the object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectGetType**](#function-fpgaobjectgettype) ([**fpga\_object**](types_8h.md#typedef-fpga_object) obj, enum [**fpga\_sysobject\_type**](types__enum_8h.md#enum-fpga_sysobject_type) \* type) <br>_Get the sysobject type (container or attribute)_  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectRead**](#function-fpgaobjectread) ([**fpga\_object**](types_8h.md#typedef-fpga_object) obj, uint8\_t \* buffer, size\_t offset, size\_t len, int flags) <br>_Read bytes from an FPGA object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectRead64**](#function-fpgaobjectread64) ([**fpga\_object**](types_8h.md#typedef-fpga_object) obj, uint64\_t \* value, int flags) <br>_Read a 64-bit value from an FPGA object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaObjectWrite64**](#function-fpgaobjectwrite64) ([**fpga\_object**](types_8h.md#typedef-fpga_object) obj, uint64\_t value, int flags) <br>_Write 64-bit value to an FPGA object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaTokenGetObject**](#function-fpgatokengetobject) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, const char \* name, [**fpga\_object**](types_8h.md#typedef-fpga_object) \* object, int flags) <br>_Create an_ `fpga_object` _data structures._ |








# Detailed Description


On Linux systems with the OPAE kernel driver, this is used to access sysfs nodes created by the driver. 


    
## Public Functions Documentation


### function fpgaDestroyObject 

_Free memory used for the fpga\_object data structure._ 
```C++
fpga_result fpgaDestroyObject (
    fpga_object * obj
) 
```





**Note:**

[**fpgaDestroyObject()**](sysobject_8h.md#function-fpgadestroyobject) requires the address of an fpga\_object as created by [**fpgaTokenGetObject()**](sysobject_8h.md#function-fpgatokengetobject), [**fpgaHandleGetObject()**](sysobject_8h.md#function-fpgahandlegetobject), or [**fpgaObjectGetObject()**](sysobject_8h.md#function-fpgaobjectgetobject). Passing any other value results in undefind behavior.




**Parameters:**


* `obj` Pointer to the fpga\_object instance to destroy



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if the object is NULL, FPGA\_EXCEPTION if an internal error is encountered. 





        

### function fpgaHandleGetObject 

_Create an_ `fpga_object` _data structure from a handle._
```C++
fpga_result fpgaHandleGetObject (
    fpga_handle handle,
    const char * name,
    fpga_object * object,
    int flags
) 
```



An `fpga_object` is a handle to an FPGA resource which can be an attribute, register, or container. This object has read/write access..




**Parameters:**


* `handle` Handle identifying a resource (accelerator or device) 
* `name` A key identifying an object belonging to a resource. 
* `object` Pointer to memory to store the object in 
* `flags` Control behavior of object identification and creation FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects below the current object identified by name.



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_NOT\_FOUND if an object cannot be found with the given key. FPGA\_NOT\_SUPPORTED if this function is not supported by the current implementation of this API.




**Note:**

Names that begin with '.' or '/' or contain '..' are not allowed and result in FPGA\_INVALID\_PARAM being returned 





        

### function fpgaObjectGetObject 

_Create an_ `fpga_object` _data structure from a parent object._
```C++
fpga_result fpgaObjectGetObject (
    fpga_object parent,
    const char * name,
    fpga_object * object,
    int flags
) 
```



An `fpga_object` is a handle to an FPGA resource which can be an attribute, register, or container. If the parent object was created with a handle, then the new object will inherit the handle allowing it to have read-write access to the object data.




**Parameters:**


* `parent` A parent container `fpga_object`. 
* `name` A key identifying a sub-object of the parent container. 
* `object` Pointer to memory to store the object in. 
* `flags` Control behavior of object identification and creation. FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects below the current object identified by name.



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid - this includes a parent object that is not a container object. FPGA\_NOT\_FOUND if an object cannot be found with the given key. FPGA\_NOT\_SUPPORTED if this function is not supported by the current implementation of this API.




**Note:**

Names that begin with '.' or '/' or contain '..' are not allowed and result in FPGA\_INVALID\_PARAM being returned 





        

### function fpgaObjectGetObjectAt 

_Create an_ `fpga_object` _data structure from a parent object using a given index._
```C++
fpga_result fpgaObjectGetObjectAt (
    fpga_object parent,
    size_t idx,
    fpga_object * object
) 
```



An `fpga_object` is a handle to an FPGA resource which can be an attribute, register, or container. If the parent object was created with a handle, then the new object will inherit the handle allowing it to have read-write access to the object data.




**Parameters:**


* `parent` A parent container 'fpga\_object' 
* `idx` A positive index less than the size reported by the parent. 
* `object` Pointer to memory to store the object in.



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid - this includes a parent object that is not a container object. FPGA\_NOT\_FOUND if an object cannot be found with the given key. FPGA\_NOT\_SUPPORTED if this function is not supported by the current implementation of this API. 





        

### function fpgaObjectGetSize 

_Retrieve the size of the object._ 
```C++
fpga_result fpgaObjectGetSize (
    fpga_object obj,
    uint32_t * value,
    int flags
) 
```





**Parameters:**


* `obj` An fpga\_object instance. 
* `value` Pointer to variable to store size in. 
* `flags` Flags that control how the object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the size.



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of supplied parameters is invalid. FPGA\_EXCEPTION if error occurred. 





        

### function fpgaObjectGetType 

_Get the sysobject type (container or attribute)_ 
```C++
fpga_result fpgaObjectGetType (
    fpga_object obj,
    enum fpga_sysobject_type * type
) 
```





**Parameters:**


* `obj` An fpga\_object instance 
* `type` The type of object (FPGA\_OBJECT\_CONTAINER or FPGA\_OBJECT\_ATTRIBUTE)



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if any of the supplied parameters are null or invalid 





        

### function fpgaObjectRead 

_Read bytes from an FPGA object._ 
```C++
fpga_result fpgaObjectRead (
    fpga_object obj,
    uint8_t * buffer,
    size_t offset,
    size_t len,
    int flags
) 
```





**Parameters:**


* `obj` An fpga\_object instance. 
* `buffer` Pointer to a buffer to read bytes into. 
* `offset` Byte offset relative to objects internal buffer where to begin reading bytes from. 
* `len` The length, in bytes, to read from the object. 
* `flags` Flags that control how object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the data.



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid 





        

### function fpgaObjectRead64 

_Read a 64-bit value from an FPGA object._ 
```C++
fpga_result fpgaObjectRead64 (
    fpga_object obj,
    uint64_t * value,
    int flags
) 
```



The value is assumed to be in string format and will be parsed. See flags below for changing that behavior.




**Parameters:**


* `obj` An fpga\_object instance 
* `value` Pointer to a 64-bit variable to store the value in 
* `flags` Flags that control how the object is read If FPGA\_OBJECT\_SYNC is used then object will update its buffered copy before retrieving the data. If FPGA\_OBJECT\_RAW is used, then the data will be read as raw bytes into the uint64\_t pointer variable.



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid 





        

### function fpgaObjectWrite64 

_Write 64-bit value to an FPGA object._ 
```C++
fpga_result fpgaObjectWrite64 (
    fpga_object obj,
    uint64_t value,
    int flags
) 
```



The value will be converted to string before writing. See flags below for changing that behavior.




**Parameters:**


* `obj` An fpga\_object instance. 
* `value` The value to write to the object 
* `flags` Flags that control how the object is written If FPGA\_OBJECT\_RAW is used, then the value will be written as raw bytes.



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid




**Note:**

The object must have been created using a handle to a resource. 





        

### function fpgaTokenGetObject 

_Create an_ `fpga_object` _data structures._
```C++
fpga_result fpgaTokenGetObject (
    fpga_token token,
    const char * name,
    fpga_object * object,
    int flags
) 
```



An `fpga_object` is a handle to an FPGA resource which can be an attribute, register or a container. This object is read-only.




**Parameters:**


* `token` Token identifying a resource (accelerator or device) 
* `name` A key identifying an object belonging to a resource. 
* `object` Pointer to memory to store the object in 
* `flags` Control behavior of object identification and creation. FPGA\_OBJECT\_GLOB is used to indicate that the name should be treated as a globbing expression. FPGA\_OBJECT\_RECURSE\_ONE indicates that subobjects be created for objects one level down from the object identified by name. FPGA\_OBJECT\_RECURSE\_ALL indicates that subobjects be created for all objects below the current object identified by name.



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if any of the supplied parameters is invalid. FPGA\_NOT\_FOUND if an object cannot be found with the given key. FPGA\_NOT\_SUPPORTED if this function is not supported by the current implementation of this API.




**Note:**

Names that begin with '.' or '/' or contain '..' are not allowed and result in FPGA\_INVALID\_PARAM being returned 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/sysobject.h`