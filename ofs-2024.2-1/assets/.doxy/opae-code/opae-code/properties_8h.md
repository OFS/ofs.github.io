
# File properties.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**properties.h**](properties_8h.md)

[Go to the source code of this file.](properties_8h_source.md)

_Functions for examining and manipulating_ `fpga_properties` _objects._[More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaClearProperties**](#function-fpgaclearproperties) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop) <br>_Clear a fpga\_properties object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaCloneProperties**](#function-fpgacloneproperties) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) src, [**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* dst) <br>_Clone a fpga\_properties object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaDestroyProperties**](#function-fpgadestroyproperties) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* prop) <br>_Destroy a fpga\_properties object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetProperties**](#function-fpgagetproperties) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, [**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* prop) <br>_Create a fpga\_properties object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetPropertiesFromHandle**](#function-fpgagetpropertiesfromhandle) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, [**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* prop) <br>_Create a fpga\_properties object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetAcceleratorState**](#function-fpgapropertiesgetacceleratorstate) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_accelerator\_state**](types__enum_8h.md#enum-fpga_accelerator_state) \* state) <br>_Get the state of a accelerator resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetBBSID**](#function-fpgapropertiesgetbbsid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t \* bbs\_id) <br>_Get the BBS ID of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetBBSVersion**](#function-fpgapropertiesgetbbsversion) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_version**](structfpga__version.md) \* bbs\_version) <br>_Get the BBS Version of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetBus**](#function-fpgapropertiesgetbus) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t \* bus) <br>_Get the PCI bus number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetCapabilities**](#function-fpgapropertiesgetcapabilities) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t \* capabilities) <br>_Get the capabilities FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetDevice**](#function-fpgapropertiesgetdevice) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t \* device) <br>_Get the PCI device number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetDeviceID**](#function-fpgapropertiesgetdeviceid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t \* device\_id) <br>_Get the device id of the resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetFunction**](#function-fpgapropertiesgetfunction) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t \* function) <br>_Get the PCI function number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetGUID**](#function-fpgapropertiesgetguid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_guid**](types_8h.md#typedef-fpga_guid) \* guid) <br>_Get the GUID of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetInterface**](#function-fpgapropertiesgetinterface) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_interface**](types__enum_8h.md#enum-fpga_interface) \* interface) <br>_Get the OPAE plugin interface implemented by a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetLocalMemorySize**](#function-fpgapropertiesgetlocalmemorysize) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t \* lms) <br>_Get the local memory size of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetModel**](#function-fpgapropertiesgetmodel) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, char \* model) <br>_Get the model of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetNumErrors**](#function-fpgapropertiesgetnumerrors) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t \* num\_errors) <br>_Get the number of errors that can be reported by a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetNumInterrupts**](#function-fpgapropertiesgetnuminterrupts) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t \* num\_interrupts) <br>_Get the number of interrupts._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetNumMMIO**](#function-fpgapropertiesgetnummmio) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t \* mmio\_spaces) <br>_Get the number of mmio spaces._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetNumSlots**](#function-fpgapropertiesgetnumslots) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t \* num\_slots) <br>_Get the number of slots of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetObjectID**](#function-fpgapropertiesgetobjectid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t \* object\_id) <br>_Get the object ID of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetObjectType**](#function-fpgapropertiesgetobjecttype) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_objtype**](types__enum_8h.md#enum-fpga_objtype) \* objtype) <br>_Get the object type of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetParent**](#function-fpgapropertiesgetparent) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_token**](types_8h.md#typedef-fpga_token) \* parent) <br>_Get the token of the parent object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetSegment**](#function-fpgapropertiesgetsegment) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t \* segment) <br>_Get the PCI segment number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetSocketID**](#function-fpgapropertiesgetsocketid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t \* socket\_id) <br>_Get the socket id of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetSubsystemDeviceID**](#function-fpgapropertiesgetsubsystemdeviceid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t \* subsystem\_device\_id) <br>_Get the subsystem device id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetSubsystemVendorID**](#function-fpgapropertiesgetsubsystemvendorid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t \* subsystem\_vendor\_id) <br>_Get the subsystem vendor id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesGetVendorID**](#function-fpgapropertiesgetvendorid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t \* vendor\_id) <br>_Get the vendor id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetAcceleratorState**](#function-fpgapropertiessetacceleratorstate) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_accelerator\_state**](types__enum_8h.md#enum-fpga_accelerator_state) state) <br>_Set the state of an accelerator resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetBBSID**](#function-fpgapropertiessetbbsid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t bbs\_id) <br>_Set the BBS ID of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetBBSVersion**](#function-fpgapropertiessetbbsversion) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_version**](structfpga__version.md) version) <br>_Set the BBS Version of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetBus**](#function-fpgapropertiessetbus) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t bus) <br>_Set the PCI bus number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetCapabilities**](#function-fpgapropertiessetcapabilities) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t capabilities) <br>_Set the capabilities of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetDevice**](#function-fpgapropertiessetdevice) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t device) <br>_Set the PCI device number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetDeviceID**](#function-fpgapropertiessetdeviceid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t device\_id) <br>_Set the device id of the resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetFunction**](#function-fpgapropertiessetfunction) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t function) <br>_Set the PCI function number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetGUID**](#function-fpgapropertiessetguid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_guid**](types_8h.md#typedef-fpga_guid) guid) <br>_Set the GUID of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetInterface**](#function-fpgapropertiessetinterface) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_interface**](types__enum_8h.md#enum-fpga_interface) interface) <br>_Set the OPAE plugin interface implemented by a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetLocalMemorySize**](#function-fpgapropertiessetlocalmemorysize) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t lms) <br>_Set the local memory size of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetModel**](#function-fpgapropertiessetmodel) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, char \* model) <br>_Set the model of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetNumErrors**](#function-fpgapropertiessetnumerrors) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t num\_errors) <br>_Set the number of error registers._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetNumInterrupts**](#function-fpgapropertiessetnuminterrupts) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t num\_interrupts) <br>_Set the number of interrupts._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetNumMMIO**](#function-fpgapropertiessetnummmio) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t mmio\_spaces) <br>_Set the number of mmio spaces._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetNumSlots**](#function-fpgapropertiessetnumslots) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint32\_t num\_slots) <br>_Set the number of slots of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetObjectID**](#function-fpgapropertiessetobjectid) (const [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint64\_t object\_id) <br>_Set the object ID of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetObjectType**](#function-fpgapropertiessetobjecttype) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_objtype**](types__enum_8h.md#enum-fpga_objtype) objtype) <br>_Set the object type of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetParent**](#function-fpgapropertiessetparent) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, [**fpga\_token**](types_8h.md#typedef-fpga_token) parent) <br>_Set the token of the parent object._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetSegment**](#function-fpgapropertiessetsegment) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t segment) <br>_Set the PCI segment number of a resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetSocketID**](#function-fpgapropertiessetsocketid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint8\_t socket\_id) <br>_Set the socket id of the resource._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetSubsystemDeviceID**](#function-fpgapropertiessetsubsystemdeviceid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t subsystem\_device\_id) <br>_Set the subsystem device id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetSubsystemVendorID**](#function-fpgapropertiessetsubsystemvendorid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t subsystem\_vendor\_id) <br>_Set the subsystem vendor id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaPropertiesSetVendorID**](#function-fpgapropertiessetvendorid) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop, uint16\_t vendor\_id) <br>_Set the vendor id of an FPGA resource property._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaUpdateProperties**](#function-fpgaupdateproperties) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, [**fpga\_properties**](types_8h.md#typedef-fpga_properties) prop) <br>_Update a fpga\_properties object._  |








# Detailed Description


In OPAE, `fpga_properties` objects are used both for obtaining information about resources and for selectively enumerating resources based on their properties. This file provides accessor functions (get/set) to allow reading and writing individual items of an `fpga_properties` object. Generally, not all object types supported by OPAE carry all properties. If you call a property accessor method on a `fpga_properties` object that does not support this particular property, it will return FPGA\_INVALID\_PARAM.


## Accessor Return Values



In addition to the return values specified in the documentation below, all accessor functions return FPGA\_OK on success, FPGA\_INVALID\_PARAM if you pass NULL or invalid parameters (i.e. non-initialized properties objects), FPGA\_EXCEPTION if an internal exception occurred trying to access the properties object, FPGA\_NOT\_FOUND if the requested property is not part of the supplied properties object. 



    
## Public Functions Documentation


### function fpgaClearProperties 

_Clear a fpga\_properties object._ 
```C++
fpga_result fpgaClearProperties (
    fpga_properties prop
) 
```



Sets all fields of the properties object pointed at by 'prop' to 'don't care', which implies that the fpga\_properties object would match all FPGA resources if used for an [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate) query. The matching criteria can be further refined by using fpgaSet\* functions on the properties object.


Instead of creating a new fpga\_properties object every time, this function can be used to re-use fpga\_properties objects from previous queries.




**Parameters:**


* `prop` fpga\_properties object to clear 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if `prop` is not a valid object. FPGA\_EXCEPTION if an \* internal exception occured when trying to access `prop`. 





        

### function fpgaCloneProperties 

_Clone a fpga\_properties object._ 
```C++
fpga_result fpgaCloneProperties (
    fpga_properties src,
    fpga_properties * dst
) 
```



Creates a copy of an fpga\_properties object.




**Note:**

This call creates a new properties object and allocates memory for it. Both the 'src' and the newly created 'dst' objects will eventually need to be destroyed using [**fpgaDestroyProperties()**](properties_8h.md#function-fpgadestroyproperties).




**Parameters:**


* `src` fpga\_properties object to copy 
* `dst` New fpga\_properties object cloned from 'src' 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if `src` is not a valid object, or if `dst` is NULL. FPGA\_NO\_MEMORY if there was not enough memory to allocate an `fpga_properties` object for `dst`. FPGA\_EXCEPTION if an internal exception occurred either accessing `src` or updating `dst`. 





        

### function fpgaDestroyProperties 

_Destroy a fpga\_properties object._ 
```C++
fpga_result fpgaDestroyProperties (
    fpga_properties * prop
) 
```



Destroys an existing fpga\_properties object that the caller has previously created using [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties) or [**fpgaCloneProperties()**](properties_8h.md#function-fpgacloneproperties).




**Note:**

[**fpgaDestroyProperties()**](properties_8h.md#function-fpgadestroyproperties) requires the address of an fpga\_properties object, similar to [**fpgaGetPropertiesFromHandle()**](properties_8h.md#function-fpgagetpropertiesfromhandle), [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties), and [**fpgaCloneProperties()**](properties_8h.md#function-fpgacloneproperties). Passing any other value results in undefined behavior.




**Parameters:**


* `prop` Pointer to the fpga\_properties object to destroy 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM is `prop` is not a valid object. FPGA\_EXCEPTION if an internal exception occurrred while trying to access `prop`. 





        

### function fpgaGetProperties 

_Create a fpga\_properties object._ 
```C++
fpga_result fpgaGetProperties (
    fpga_token token,
    fpga_properties * prop
) 
```



Initializes the memory pointed at by `prop` to represent a properties object, and populates it with the properties of the resource referred to by `token`. Individual properties can then be queried using fpgaPropertiesGet\*() accessor functions.


If `token` is NULL, an "empty" properties object is created to be used as a filter for [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate). All individual fields are set to `don`t care`, which implies that the fpga\_properties object would match all FPGA resources if used for an [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate) query. The matching criteria can be further refined by using fpgaSet\* functions on the properties object, or the object can be populated with the actual properties of a resource by using [**fpgaUpdateProperties()**](properties_8h.md#function-fpgaupdateproperties).




**Note:**

[**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties) will allocate memory for the created properties object returned in `prop`. It is the responsibility of the caller to free this memory after use by calling [**fpgaDestroyProperties()**](properties_8h.md#function-fpgadestroyproperties).




**Parameters:**


* `token` Token to get properties for. Can be NULL, which will create an empty properties object to be used as a filter for [**fpgaEnumerate()**](enum_8h.md#function-fpgaenumerate). 
* `prop` Pointer to a variable of type fpga\_properties 



**Returns:**

FPGA\_OK on success. FPGA\_NO\_MEMORY if no memory could be allocated to create the `fpga_properties` object. FPGA\_EXCEPTION if an exception happend while initializing the `fpga_properties` object. 





        

### function fpgaGetPropertiesFromHandle 

_Create a fpga\_properties object._ 
```C++
fpga_result fpgaGetPropertiesFromHandle (
    fpga_handle handle,
    fpga_properties * prop
) 
```



Initializes the memory pointed at by `prop` to represent a properties object, and populates it with the properties of the resource referred to by `handle`. Individual properties can then be queried using fpgaPropertiesGet\*() accessor functions.




**Note:**

[**fpgaGetPropertiesFromHandle()**](properties_8h.md#function-fpgagetpropertiesfromhandle) will allocate memory for the created properties object returned in `prop`. It is the responsibility of the caller to free this memory after use by calling [**fpgaDestroyProperties()**](properties_8h.md#function-fpgadestroyproperties).




**Parameters:**


* `handle` Open handle to get properties for. 
* `prop` Pointer to a variable of type fpga\_properties 



**Returns:**

FPGA\_OK on success. FPGA\_NO\_MEMORY if no memory could be allocated to create the `fpga_properties` object. FPGA\_EXCEPTION if an exception happend while initializing the `fpga_properties` object. 





        

### function fpgaPropertiesGetAcceleratorState 

_Get the state of a accelerator resource property._ 
```C++
fpga_result fpgaPropertiesGetAcceleratorState (
    const fpga_properties prop,
    fpga_accelerator_state * state
) 
```



Returns the accelerator state of a accelerator.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_ACCELERATOR 
* `state` Pointer to a accelerator state variable of the accelerator 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetBBSID 

_Get the BBS ID of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetBBSID (
    const fpga_properties prop,
    uint64_t * bbs_id
) 
```



Returns the blue bitstream id of an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `bbs_id` Pointer to a bbs id variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetBBSVersion 

_Get the BBS Version of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetBBSVersion (
    const fpga_properties prop,
    fpga_version * bbs_version
) 
```



Returns the blue bitstream version of an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `bbs_version` Pointer to a bbs version variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetBus 

_Get the PCI bus number of a resource._ 
```C++
fpga_result fpgaPropertiesGetBus (
    const fpga_properties prop,
    uint8_t * bus
) 
```



Returns the bus number the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `bus` Pointer to a PCI bus variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetCapabilities 

_Get the capabilities FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetCapabilities (
    const fpga_properties prop,
    uint64_t * capabilities
) 
```



Returns the capabilities of an FPGA. Capabilities is a bitfield value




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `capabilities` Pointer to a capabilities variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesGetDevice 

_Get the PCI device number of a resource._ 
```C++
fpga_result fpgaPropertiesGetDevice (
    const fpga_properties prop,
    uint8_t * device
) 
```



Returns the device number the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `device` Pointer to a PCI device variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetDeviceID 

_Get the device id of the resource._ 
```C++
fpga_result fpgaPropertiesGetDeviceID (
    const fpga_properties prop,
    uint16_t * device_id
) 
```





**Parameters:**


* `prop` Properties object to query 
* `device_id` Pointer to a device id variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetFunction 

_Get the PCI function number of a resource._ 
```C++
fpga_result fpgaPropertiesGetFunction (
    const fpga_properties prop,
    uint8_t * function
) 
```



Returns the function number the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `function` Pointer to PCI function variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetGUID 

_Get the GUID of a resource._ 
```C++
fpga_result fpgaPropertiesGetGUID (
    const fpga_properties prop,
    fpga_guid * guid
) 
```



Returns the GUID of an FPGA or accelerator object.


For an accelerator, the GUID uniquely identifies a specific accelerator context type, i.e. different accelerators will have different GUIDs. For an FPGA, the GUID is used to identify a certain instance of an FPGA, e.g. to determine whether a given bitstream would be compatible.




**Parameters:**


* `prop` Properties object to query 
* `guid` Pointer to a GUID of the slot variable 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetInterface 

_Get the OPAE plugin interface implemented by a resource._ 
```C++
fpga_result fpgaPropertiesGetInterface (
    const fpga_properties prop,
    fpga_interface * interface
) 
```



Returns the plugin interface enumerator.




**Parameters:**


* `prop` Properties object to query 
* `interface` Pointer to an fpga\_interface location to store the interface in 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetLocalMemorySize 

_Get the local memory size of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetLocalMemorySize (
    const fpga_properties prop,
    uint64_t * lms
) 
```



Returns the local memory size of an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `lms` Pointer to a memory size variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesGetModel 

_Get the model of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetModel (
    const fpga_properties prop,
    char * model
) 
```



Returns the model of an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `model` Model of the FPGA resource (string of minimum FPGA\_MODEL\_LENGTH length 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesGetNumErrors 

_Get the number of errors that can be reported by a resource._ 
```C++
fpga_result fpgaPropertiesGetNumErrors (
    const fpga_properties prop,
    uint32_t * num_errors
) 
```



Returns the number of error registers understood by a resource.




**Parameters:**


* `prop` Properties object to query 
* `num_errors` Pointer to a 32 bit memory location to store the number of supported errors in 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetNumInterrupts 

_Get the number of interrupts._ 
```C++
fpga_result fpgaPropertiesGetNumInterrupts (
    const fpga_properties prop,
    uint32_t * num_interrupts
) 
```



Returns the number of interrupts of an accelerator properties structure.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_ACCELERATOR 
* `num_interrupts` Pointer to a variable for number of interrupts 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetNumMMIO 

_Get the number of mmio spaces._ 
```C++
fpga_result fpgaPropertiesGetNumMMIO (
    const fpga_properties prop,
    uint32_t * mmio_spaces
) 
```



Returns the number of mmio spaces of an AFU properties structure.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_ACCELERATOR 
* `mmio_spaces` Pointer to a variable for number of mmio spaces 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetNumSlots 

_Get the number of slots of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetNumSlots (
    const fpga_properties prop,
    uint32_t * num_slots
) 
```



Returns the number of slots present in an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `num_slots` Pointer to number of slots variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetObjectID 

_Get the object ID of a resource._ 
```C++
fpga_result fpgaPropertiesGetObjectID (
    const fpga_properties prop,
    uint64_t * object_id
) 
```



Returns the object ID of a resource. The object ID is a 64 bit identifier that is unique within a single node or system. It represents a similar concept as the token, but can be used across processes (e.g. passed on the command line).




**Parameters:**


* `prop` Properties object to query 
* `object_id` Pointer to a 64bit memory location to store the object ID in 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetObjectType 

_Get the object type of a resource._ 
```C++
fpga_result fpgaPropertiesGetObjectType (
    const fpga_properties prop,
    fpga_objtype * objtype
) 
```



Returns the object type of the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `objtype` Pointer to an object type variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetParent 

_Get the token of the parent object._ 
```C++
fpga_result fpgaPropertiesGetParent (
    const fpga_properties prop,
    fpga_token * parent
) 
```



Returns the token of the parent of the queried resource in '\*parent'.




**Parameters:**


* `prop` Properties object to query 
* `parent` Pointer to a token variable of the resource 'prop' is associated with 



**Returns:**

FPGA\_NOT\_FOUND if resource does not have a parent (e.g. an FPGA\_DEVICE resource does not have parents). Also see "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetSegment 

_Get the PCI segment number of a resource._ 
```C++
fpga_result fpgaPropertiesGetSegment (
    const fpga_properties prop,
    uint16_t * segment
) 
```



Returns the segment number of the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `segment` Pointer to a PCI segment variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetSocketID 

_Get the socket id of a resource._ 
```C++
fpga_result fpgaPropertiesGetSocketID (
    const fpga_properties prop,
    uint8_t * socket_id
) 
```



Returns the socket id of the queried resource.




**Parameters:**


* `prop` Properties object to query 
* `socket_id` Pointer to a socket id variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetSubsystemDeviceID 

_Get the subsystem device id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetSubsystemDeviceID (
    const fpga_properties prop,
    uint16_t * subsystem_device_id
) 
```



Returns the subsystem device id of an FPGA.




**Parameters:**


* `prop` Properties object to query 
* `subsystem_device_id` Pointer to a device id variable of the FPGA 



**Returns:**

FPGA\_OK on success. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetSubsystemVendorID 

_Get the subsystem vendor id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetSubsystemVendorID (
    const fpga_properties prop,
    uint16_t * subsystem_vendor_id
) 
```



Returns the subsystem vendor id of an FPGA.




**Parameters:**


* `prop` Properties object to query 
* `subsystem_vendor_id` Pointer to a vendor id variable of the FPGA 



**Returns:**

FPGA\_OK on success. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesGetVendorID 

_Get the vendor id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesGetVendorID (
    const fpga_properties prop,
    uint16_t * vendor_id
) 
```



Returns the vendor id of an FPGA.




**Parameters:**


* `prop` Properties object to query - must be of type FPGA\_DEVICE 
* `vendor_id` Pointer to a vendor id variable of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesSetAcceleratorState 

_Set the state of an accelerator resource property._ 
```C++
fpga_result fpgaPropertiesSetAcceleratorState (
    fpga_properties prop,
    fpga_accelerator_state state
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_ACCELERATOR 
* `state` accelerator state of the accelerator resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetBBSID 

_Set the BBS ID of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetBBSID (
    fpga_properties prop,
    uint64_t bbs_id
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `bbs_id` Blue bitstream id of the FPGA resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetBBSVersion 

_Set the BBS Version of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetBBSVersion (
    fpga_properties prop,
    fpga_version version
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `version` Blue bitstream version of the FPGA resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetBus 

_Set the PCI bus number of a resource._ 
```C++
fpga_result fpgaPropertiesSetBus (
    fpga_properties prop,
    uint8_t bus
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `bus` PCI bus number of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetCapabilities 

_Set the capabilities of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetCapabilities (
    fpga_properties prop,
    uint64_t capabilities
) 
```



Capabilities is a bitfield value




**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `capabilities` Capabilities of the FPGA resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesSetDevice 

_Set the PCI device number of a resource._ 
```C++
fpga_result fpgaPropertiesSetDevice (
    fpga_properties prop,
    uint8_t device
) 
```



Enforces the limitation on the number of devices as specified in the PCI spec.




**Parameters:**


* `prop` Properties object to modify 
* `device` PCI device number of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetDeviceID 

_Set the device id of the resource._ 
```C++
fpga_result fpgaPropertiesSetDeviceID (
    fpga_properties prop,
    uint16_t device_id
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `device_id` Device id of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetFunction 

_Set the PCI function number of a resource._ 
```C++
fpga_result fpgaPropertiesSetFunction (
    fpga_properties prop,
    uint8_t function
) 
```



Enforces the limitation on the number of functions as specified in the PCI spec.




**Parameters:**


* `prop` Properties object to modify 
* `function` PCI function number of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetGUID 

_Set the GUID of a resource._ 
```C++
fpga_result fpgaPropertiesSetGUID (
    fpga_properties prop,
    fpga_guid guid
) 
```



Sets the GUID of an FPGA or accelerator object.


For an accelerator, the GUID uniquely identifies a specific accelerator context type, i.e. different accelerators will have different GUIDs. For an FPGA, the GUID is used to identify a certain instance of an FPGA, e.g. to determine whether a given bitstream would be compatible.




**Parameters:**


* `prop` Properties object to modify 
* `guid` Pointer to a GUID of the slot variable 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetInterface 

_Set the OPAE plugin interface implemented by a resource._ 
```C++
fpga_result fpgaPropertiesSetInterface (
    const fpga_properties prop,
    fpga_interface interface
) 
```



Set the plugin interface enumerator.




**Parameters:**


* `prop` Properties object to query 
* `interface` The interface enumerator to set 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetLocalMemorySize 

_Set the local memory size of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetLocalMemorySize (
    fpga_properties prop,
    uint64_t lms
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `lms` Local memory size of the FPGA resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesSetModel 

_Set the model of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetModel (
    fpga_properties prop,
    char * model
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `model` Model of the FPGA resource (string of maximum FPGA\_MODEL\_LENGTH length 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaPropertiesSetNumErrors 

_Set the number of error registers._ 
```C++
fpga_result fpgaPropertiesSetNumErrors (
    const fpga_properties prop,
    uint32_t num_errors
) 
```



Set the number of error registers understood by a resource to enumerate.




**Parameters:**


* `prop` Properties object to query 
* `num_errors` Number of errors 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetNumInterrupts 

_Set the number of interrupts._ 
```C++
fpga_result fpgaPropertiesSetNumInterrupts (
    fpga_properties prop,
    uint32_t num_interrupts
) 
```



Sets the number of interrupts of an accelerator properties structure.




**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_ACCELERATOR 
* `num_interrupts` Number of interrupts of the accelerator 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetNumMMIO 

_Set the number of mmio spaces._ 
```C++
fpga_result fpgaPropertiesSetNumMMIO (
    fpga_properties prop,
    uint32_t mmio_spaces
) 
```



Sets the number of mmio spaces of an AFU properties structure.




**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_ACCELERATOR 
* `mmio_spaces` Number of MMIO spaces of the accelerator 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_ACCELERATOR. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetNumSlots 

_Set the number of slots of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetNumSlots (
    fpga_properties prop,
    uint32_t num_slots
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `num_slots` Number of slots of the FPGA 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetObjectID 

_Set the object ID of a resource._ 
```C++
fpga_result fpgaPropertiesSetObjectID (
    const fpga_properties prop,
    uint64_t object_id
) 
```



Sets the object ID of a resource. The object ID is a 64 bit identifier that is unique within a single node or system. It represents a similar concept as the token, but can be used across processes (e.g. passed on the command line).




**Parameters:**


* `prop` Properties object to query 
* `object_id` A 64bit value to use as the object ID 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetObjectType 

_Set the object type of a resource._ 
```C++
fpga_result fpgaPropertiesSetObjectType (
    fpga_properties prop,
    fpga_objtype objtype
) 
```



Sets the object type of the resource. \* Currently supported object types are FPGA\_DEVICE and FPGA\_ACCELERATOR.




**Parameters:**


* `prop` Properties object to modify 
* `objtype` Object type of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetParent 

_Set the token of the parent object._ 
```C++
fpga_result fpgaPropertiesSetParent (
    fpga_properties prop,
    fpga_token parent
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `parent` Pointer to a token variable of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetSegment 

_Set the PCI segment number of a resource._ 
```C++
fpga_result fpgaPropertiesSetSegment (
    fpga_properties prop,
    uint16_t segment
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `segment` PCI segment number of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetSocketID 

_Set the socket id of the resource._ 
```C++
fpga_result fpgaPropertiesSetSocketID (
    fpga_properties prop,
    uint8_t socket_id
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `socket_id` Socket id of the resource 'prop' is associated with 



**Returns:**

See "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetSubsystemDeviceID 

_Set the subsystem device id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetSubsystemDeviceID (
    fpga_properties prop,
    uint16_t subsystem_device_id
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `subsystem_device_id` Subsystem Device id of the FPGA resource 



**Returns:**

FPGA\_OK on success. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetSubsystemVendorID 

_Set the subsystem vendor id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetSubsystemVendorID (
    fpga_properties prop,
    uint16_t subsystem_vendor_id
) 
```





**Parameters:**


* `prop` Properties object to modify 
* `subsystem_vendor_id` Subsystem Vendor id of the FPGA resource 



**Returns:**

FPGA\_OK on success. See also "Accessor Return Values" in [properties.h](#properties-h). 





        

### function fpgaPropertiesSetVendorID 

_Set the vendor id of an FPGA resource property._ 
```C++
fpga_result fpgaPropertiesSetVendorID (
    fpga_properties prop,
    uint16_t vendor_id
) 
```





**Parameters:**


* `prop` Properties object to modify - must be of type FPGA\_DEVICE 
* `vendor_id` Vendor id of the FPGA resource 



**Returns:**

FPGA\_INVALID\_PARAM if object type is not FPGA\_DEVICE. See also "Accessor Return Values" in [properties.h](#properties-h).




**Note:**

This API is not currently supported. 





        

### function fpgaUpdateProperties 

_Update a fpga\_properties object._ 
```C++
fpga_result fpgaUpdateProperties (
    fpga_token token,
    fpga_properties prop
) 
```



Populates the properties object 'prop' with properties of the resource referred to by 'token'. Unlike [**fpgaGetProperties()**](properties_8h.md#function-fpgagetproperties), this call will not create a new properties object or allocate memory for it, but use a previously created properties object.




**Parameters:**


* `token` Token to retrieve properties for 
* `prop` fpga\_properties object to update 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if `token` or `prop` are not valid objects. FPGA\_NOT\_FOUND if the resource referred to by `token` was not found. FPGA\_NO\_DRIVER if not driver is loaded. FPGA\_EXCEPTION if an internal exception occured when trying to update `prop`. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/properties.h`