
# File types.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**types.h**](types_8h.md)

[Go to the source code of this file.](types_8h_source.md)

_Type definitions for FPGA API._ [More...](#detailed-description)

* `#include <stdint.h>`
* `#include <stddef.h>`
* `#include <stdbool.h>`
* `#include <opae/types_enum.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**\_fpga\_token\_header**](struct__fpga__token__header.md) <br>_Internal token type header._  |
| struct | [**fpga\_error\_info**](structfpga__error__info.md) <br> |
| struct | [**fpga\_metric**](structfpga__metric.md) <br>_Metric struct._  |
| struct | [**fpga\_metric\_info**](structfpga__metric__info.md) <br>_Metric info struct._  |
| struct | [**fpga\_version**](structfpga__version.md) <br>_Semantic version._  |
| struct | [**metric\_threshold**](structmetric__threshold.md) <br> |
| struct | [**threshold**](structthreshold.md) <br>_Threshold struct._  |

## Public Types

| Type | Name |
| ---: | :--- |
| typedef void \* | [**fpga\_event\_handle**](#typedef-fpga_event_handle)  <br>_Handle to an event object._  |
| typedef uint8\_t | [**fpga\_guid**](#typedef-fpga_guid)  <br>_Globally unique identifier (GUID)_  |
| typedef void \* | [**fpga\_handle**](#typedef-fpga_handle)  <br>_Handle to an FPGA resource._  |
| typedef struct [**fpga\_metric**](structfpga__metric.md) | [**fpga\_metric**](#typedef-fpga_metric)  <br>_Metric struct._  |
| typedef struct [**fpga\_metric\_info**](structfpga__metric__info.md) | [**fpga\_metric\_info**](#typedef-fpga_metric_info)  <br>_Metric info struct._  |
| typedef void \* | [**fpga\_object**](#typedef-fpga_object)  <br>_Object pertaining to an FPGA resource as identified by a unique name._  |
| typedef void \* | [**fpga\_properties**](#typedef-fpga_properties)  <br>_Object for expressing FPGA resource properties._  |
| typedef void \* | [**fpga\_token**](#typedef-fpga_token)  <br>_Token for referencing FPGA resources._  |
| typedef struct [**\_fpga\_token\_header**](struct__fpga__token__header.md) | [**fpga\_token\_header**](#typedef-fpga_token_header)  <br>_Internal token type header._  |
| typedef struct [**metric\_threshold**](structmetric__threshold.md) | [**metric\_threshold**](#typedef-metric_threshold)  <br> |
| union  | [**metric\_value**](#union-metric_value)  <br>_Metric value union._  |
| typedef struct [**threshold**](structthreshold.md) | [**threshold**](#typedef-threshold)  <br>_Threshold struct._  |











## Macros

| Type | Name |
| ---: | :--- |
| define  | [**FPGA\_ERROR\_NAME\_MAX**](types_8h.md#define-fpga_error_name_max)  64<br>_Information about an error register._  |
| define  | [**FPGA\_METRIC\_STR\_SIZE**](types_8h.md#define-fpga_metric_str_size)  256<br>_FPGA Metric string size._  |
| define  | [**fpga\_is\_parent\_child**](types_8h.md#define-fpga_is_parent_child) (\_\_parent\_hdr, \_\_child\_hdr) <br>_Determine token parent/child relationship._  |

# Detailed Description


OPAE uses the three opaque types fpga\_properties, fpga\_token, and fpga\_handle to create a hierarchy of objects that can be used to enumerate, reference, acquire, and query FPGA resources. This object model is designed to be extensible to account for different FPGA architectures and platforms.


### Initialization



OPAEs management of the opaque types `fpga_properties`, `fpga_token`, and `fpga_handle` relies on the proper initialization of variables of these types. In other words, before doing anything with a variable of one of these opaque types, you need to first initialize them.


The respective functions that initialize opaque types are:



* [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties) and [**fpgaCloneProperties()**](properties_8h.md#function-fpgacloneproperties) for `fpga_properties`
* [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate) and [**fpgaCloneToken()**](enum_8h.md#function-fpgaclonetoken) for `fpga_token`
* [**fpgaOpen()**](access_8h.md#function-fpgaopen) for `fpga_handle`




This should intuitively make sense - [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties) creates `fpga_properties` objects, [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate) creates `fpga_token` objects, [**fpgaOpen()**](access_8h.md#function-fpgaopen) creates `fpga_handle` objects, and [**fpgaCloneProperties()**](properties_8h.md#function-fpgacloneproperties) and [**fpgaCloneToken()**](enum_8h.md#function-fpgaclonetoken) clone (create) `fpga_properties` and `fpga_token` objects, respectively.


Since these opaque types are interpreted as pointers (they are typedef'd to a `void *`), passing an uninitialized opaque type into any function except the respective initailzation function will result in undefined behaviour, because OPAE will try to follow an invalid pointer. Undefined behaviour in this case may include an unexpected error code, or an application crash. 



    
## Public Types Documentation


### typedef fpga\_event\_handle 

_Handle to an event object._ 
```C++
typedef void* fpga_event_handle;
```



OPAE provides an interface to asynchronous events that can be generated by different FPGA resources. The event API provides functions to register for these events; associated with every event a process has registered for is an `fpga_event_handle`, which encapsulates the OS-specific data structure for event objects.


After use, `fpga_event_handle` objects should be destroyed using [**fpgaDestroyEventHandle()**](event_8h.md#function-fpgadestroyeventhandle) to free backing memory used by the `fpga_event_handle` object. 


        

### typedef fpga\_guid 

_Globally unique identifier (GUID)_ 
```C++
typedef uint8_t fpga_guid[16];
```



GUIDs are used widely within OPAE for helping identify FPGA resources. For example, every FPGA resource has a `guid` property, which can be (and in the case of FPGA\_ACCELERATOR resource primarily is) used for enumerating a resource of a specific type.


`fpga_guid` is compatible with libuuid's uuid\_t, so users can use libuuid functions like uuid\_parse() to create and work with GUIDs. 


        

### typedef fpga\_handle 

_Handle to an FPGA resource._ 
```C++
typedef void* fpga_handle;
```



A valid `fpga_handle` object, as populated by [**fpgaOpen()**](access_8h.md#function-fpgaopen), denotes ownership of an FPGA resource. Note that ownership can be exclusive or shared, depending on the flags used in [**fpgaOpen()**](access_8h.md#function-fpgaopen). Ownership can be released by calling [**fpgaClose()**](access_8h.md#function-fpgaclose), which will render the underlying handle invalid.


Many OPAE C API functions require a valid token (which is synonymous with ownership of the resource). 


        

### typedef fpga\_metric 

```C++
typedef struct fpga_metric fpga_metric;
```




### typedef fpga\_metric\_info 

```C++
typedef struct fpga_metric_info fpga_metric_info;
```




### typedef fpga\_object 

_Object pertaining to an FPGA resource as identified by a unique name._ 
```C++
typedef void* fpga_object;
```



An `fpga_object` represents either a device attribute or a container of attributes. Similar to filesystems, a '/' may be used to seperate objects in an object hierarchy. Once on object is acquired, it may be used to read or write data in a resource attribute or to query sub-objects if the object is a container object. The data in an object is buffered and will be kept around until the object is destroyed. Additionally, the data in an attribute can by synchronized from the owning resource using the FPGA\_OBJECT\_SYNC flag during read operations. The name identifying the object is unique with respect to the resource that owns it. A parent resource may be identified by an `fpga_token` object, by an `fpga_handle` object, or another `fpga_object` object. If a handle object is used when opening the object, then the object is opened with read-write access. Otherwise, the object is read-only. 


        

### typedef fpga\_properties 

_Object for expressing FPGA resource properties._ 
```C++
typedef void* fpga_properties;
```



`fpga_properties` objects encapsulate all enumerable information about an FPGA resources. They can be used for two purposes: selective enumeration (discovery) and querying information about existing resources.


For selective enumeration, usually an empty `fpga_properties` object is created (using [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties)) and then populated with the desired criteria for enumeration. An array of `fpga_properties` can then be passed to [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate), which will return a list of `fpga_token` objects matching these criteria.


For querying properties of existing FPGA resources, [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties) can also take an `fpga_token` and will return an `fpga_properties` object populated with information about the resource referenced by that token.


After use, `fpga_properties` objects should be destroyed using fpga\_destroyProperties() to free backing memory used by the `fpga_properties` object. 


        

### typedef fpga\_token 

_Token for referencing FPGA resources._ 
```C++
typedef void* fpga_token;
```



An `fpga_token` serves as a reference to a specific FPGA resource present in the system. Holding an `fpga_token` does not constitute ownership of the FPGA resource - it merely allows the user to query further information about a resource, or to use [**fpgaOpen()**](access_8h.md#function-fpgaopen) to acquire ownership.


`fpga_token`s are usually returned by [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate) or [**fpgaPropertiesGetParent()**](properties_8h.md#function-fpgapropertiesgetparent), and used by [**fpgaOpen()**](access_8h.md#function-fpgaopen) to acquire ownership and yield a handle to the resource. Some API calls also take `fpga_token`s as arguments if they don't require ownership of the resource in question. 


        

### typedef fpga\_token\_header 

_Internal token type header._ 
```C++
typedef struct _fpga_token_header fpga_token_header;
```



Each plugin (dfl: libxfpga.so, vfio: libopae-v.so) implements its own proprietary token type. This header _must_ appear at offset zero within that structure.


eg, see lib/plugins/xfpga/types\_int.h:struct \_fpga\_token and lib/plugins/vfio/opae\_vfio.h:struct \_vfio\_token. 


        

### typedef metric\_threshold 

```C++
typedef struct metric_threshold metric_threshold;
```




### union metric\_value 

```C++

```




### typedef threshold 

```C++
typedef struct threshold threshold;
```



## Macro Definition Documentation



### define FPGA\_ERROR\_NAME\_MAX 

_Information about an error register._ 
```C++
#define FPGA_ERROR_NAME_MAX 64
```



This data structure captures information about an error register exposed by an accelerator resource. The error API provides functions to retrieve these information structures from a particular resource. 


        

### define FPGA\_METRIC\_STR\_SIZE 

```C++
#define FPGA_METRIC_STR_SIZE 256
```




### define fpga\_is\_parent\_child 

_Determine token parent/child relationship._ 
```C++
#define fpga_is_parent_child (
    __parent_hdr,
    __child_hdr
) (((__parent_hdr)->objtype == FPGA_DEVICE ) && \
 ((__child_hdr)->objtype == FPGA_ACCELERATOR ) && \
 ((__parent_hdr)->segment == (__child_hdr)->segment) && \
 ((__parent_hdr)->bus == (__child_hdr)->bus) && \
 ((__parent_hdr)->device == (__child_hdr)->device))
```



Given pointers to two fpga\_token\_header structs, determine whether the first is the parent of the second. A parent will have objtype == FPGA\_DEVICE. A child will have objtype == FPGA\_ACCELERATOR. The PCIe address of the two headers will match in all but the function fields. 


        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/types.h`