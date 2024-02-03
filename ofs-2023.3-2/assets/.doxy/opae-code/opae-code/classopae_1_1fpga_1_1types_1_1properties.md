
# Class opae::fpga::types::properties



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**properties**](classopae_1_1fpga_1_1types_1_1properties.md)



_Wraps an OPAE fpga\_properties object._ [More...](#detailed-description)

* `#include <properties.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**properties**](classopae_1_1fpga_1_1types_1_1properties.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |


## Public Attributes

| Type | Name |
| ---: | :--- |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; [**fpga\_accelerator\_state**](types__enum_8h.md#enum-fpga_accelerator_state) &gt; | [**accelerator\_state**](#variable-accelerator_state)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint64\_t &gt; | [**bbs\_id**](#variable-bbs_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; [**fpga\_version**](structfpga__version.md) &gt; | [**bbs\_version**](#variable-bbs_version)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint8\_t &gt; | [**bus**](#variable-bus)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint64\_t &gt; | [**capabilities**](#variable-capabilities)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint8\_t &gt; | [**device**](#variable-device)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint16\_t &gt; | [**device\_id**](#variable-device_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint8\_t &gt; | [**function**](#variable-function)  <br> |
|  [**guid\_t**](structopae_1_1fpga_1_1types_1_1guid__t.md) | [**guid**](#variable-guid)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; [**fpga\_interface**](types__enum_8h.md#enum-fpga_interface) &gt; | [**interface**](#variable-interface)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint64\_t &gt; | [**local\_memory\_size**](#variable-local_memory_size)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; char \* &gt; | [**model**](#variable-model)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint32\_t &gt; | [**num\_errors**](#variable-num_errors)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint32\_t &gt; | [**num\_interrupts**](#variable-num_interrupts)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint32\_t &gt; | [**num\_mmio**](#variable-num_mmio)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint32\_t &gt; | [**num\_slots**](#variable-num_slots)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint64\_t &gt; | [**object\_id**](#variable-object_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; [**fpga\_token**](types_8h.md#typedef-fpga_token) &gt; | [**parent**](#variable-parent)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint16\_t &gt; | [**segment**](#variable-segment)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint8\_t &gt; | [**socket\_id**](#variable-socket_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint16\_t &gt; | [**subsystem\_device\_id**](#variable-subsystem_device_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint16\_t &gt; | [**subsystem\_vendor\_id**](#variable-subsystem_vendor_id)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; [**fpga\_objtype**](types__enum_8h.md#enum-fpga_objtype) &gt; | [**type**](#variable-type)  <br> |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; uint16\_t &gt; | [**vendor\_id**](#variable-vendor_id)  <br> |

## Public Static Attributes

| Type | Name |
| ---: | :--- |
|  const std::vector&lt; [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) &gt; | [**none**](#variable-none)  <br>_An empty vector of properties._  |

## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_properties**](types_8h.md#typedef-fpga_properties) | [**c\_type**](#function-c_type) () const<br>_Get the underlying fpga\_properties object._  |
|   | [**operator fpga\_properties**](#function-operator-fpga_properties) () const<br>_Get the underlying fpga\_properties object._  |
|  [**properties**](classopae_1_1fpga_1_1types_1_1properties.md) & | [**operator=**](#function-operator) (const [**properties**](classopae_1_1fpga_1_1types_1_1properties.md) & p) = delete<br> |
|   | [**properties**](#function-properties-12) (const [**properties**](classopae_1_1fpga_1_1types_1_1properties.md) & p) = delete<br> |
|   | [**~properties**](#function-properties) () <br> |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-16) () <br>_Create a new properties object._  |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-26) ([**fpga\_guid**](types_8h.md#typedef-fpga_guid) guid\_in) <br>_Create a new properties object from a guid._  |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-36) ([**fpga\_objtype**](types__enum_8h.md#enum-fpga_objtype) objtype) <br>_Create a new properties object from an fpga\_objtype._  |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-46) (std::shared\_ptr&lt; [**token**](classopae_1_1fpga_1_1types_1_1token.md) &gt; t) <br>_Retrieve the properties for a given token object._  |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-56) ([**fpga\_token**](types_8h.md#typedef-fpga_token) t) <br>_Retrieve the properties for a given fpga\_token._  |
|  [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) | [**get**](#function-get-66) (std::shared\_ptr&lt; [**handle**](classopae_1_1fpga_1_1types_1_1handle.md) &gt; h) <br>_Retrieve the properties for a given handle object._  |







# Detailed Description


properties are information describing an accelerator resource that is identified by its token. The properties are used during enumeration to narrow the search for an accelerator resource, and after enumeration to provide the configuration of that resource. 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<properties> opae::fpga::types::properties::ptr_t;
```



## Public Attributes Documentation


### variable accelerator\_state 

```C++
pvalue<fpga_accelerator_state> opae::fpga::types::properties::accelerator_state;
```




### variable bbs\_id 

```C++
pvalue<uint64_t> opae::fpga::types::properties::bbs_id;
```




### variable bbs\_version 

```C++
pvalue<fpga_version> opae::fpga::types::properties::bbs_version;
```




### variable bus 

```C++
pvalue<uint8_t> opae::fpga::types::properties::bus;
```




### variable capabilities 

```C++
pvalue<uint64_t> opae::fpga::types::properties::capabilities;
```




### variable device 

```C++
pvalue<uint8_t> opae::fpga::types::properties::device;
```




### variable device\_id 

```C++
pvalue<uint16_t> opae::fpga::types::properties::device_id;
```




### variable function 

```C++
pvalue<uint8_t> opae::fpga::types::properties::function;
```




### variable guid 

```C++
guid_t opae::fpga::types::properties::guid;
```




### variable interface 

```C++
pvalue<fpga_interface> opae::fpga::types::properties::interface;
```




### variable local\_memory\_size 

```C++
pvalue<uint64_t> opae::fpga::types::properties::local_memory_size;
```




### variable model 

```C++
pvalue<char *> opae::fpga::types::properties::model;
```




### variable num\_errors 

```C++
pvalue<uint32_t> opae::fpga::types::properties::num_errors;
```




### variable num\_interrupts 

```C++
pvalue<uint32_t> opae::fpga::types::properties::num_interrupts;
```




### variable num\_mmio 

```C++
pvalue<uint32_t> opae::fpga::types::properties::num_mmio;
```




### variable num\_slots 

```C++
pvalue<uint32_t> opae::fpga::types::properties::num_slots;
```




### variable object\_id 

```C++
pvalue<uint64_t> opae::fpga::types::properties::object_id;
```




### variable parent 

```C++
pvalue<fpga_token> opae::fpga::types::properties::parent;
```




### variable segment 

```C++
pvalue<uint16_t> opae::fpga::types::properties::segment;
```




### variable socket\_id 

```C++
pvalue<uint8_t> opae::fpga::types::properties::socket_id;
```




### variable subsystem\_device\_id 

```C++
pvalue<uint16_t> opae::fpga::types::properties::subsystem_device_id;
```




### variable subsystem\_vendor\_id 

```C++
pvalue<uint16_t> opae::fpga::types::properties::subsystem_vendor_id;
```




### variable type 

```C++
pvalue<fpga_objtype> opae::fpga::types::properties::type;
```




### variable vendor\_id 

```C++
pvalue<uint16_t> opae::fpga::types::properties::vendor_id;
```



## Public Static Attributes Documentation


### variable none 

_An empty vector of properties._ 
```C++
const std::vector<properties::ptr_t> opae::fpga::types::properties::none;
```



Useful for enumerating based on a "match all" criteria. 


        
## Public Functions Documentation


### function c\_type 

```C++
inline fpga_properties opae::fpga::types::properties::c_type () const
```




### function operator fpga\_properties 

```C++
inline opae::fpga::types::properties::operator fpga_properties () const
```




### function operator= 

```C++
properties & opae::fpga::types::properties::operator= (
    const properties & p
) = delete
```




### function properties [1/2]

```C++
opae::fpga::types::properties::properties (
    const properties & p
) = delete
```




### function ~properties 

```C++
opae::fpga::types::properties::~properties () 
```



## Public Static Functions Documentation


### function get [1/6]

_Create a new properties object._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get () 
```





**Returns:**

A properties smart pointer. 





        

### function get [2/6]

_Create a new properties object from a guid._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get (
    fpga_guid guid_in
) 
```





**Parameters:**


* `guid_in` A guid to set in the properties 



**Returns:**

A properties smart pointer with its guid initialized to guid\_in 





        

### function get [3/6]

_Create a new properties object from an fpga\_objtype._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get (
    fpga_objtype objtype
) 
```





**Parameters:**


* `objtype` An object type to set in the properties 



**Returns:**

A properties smart pointer with its object type set to objtype. 





        

### function get [4/6]

_Retrieve the properties for a given token object._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get (
    std::shared_ptr< token > t
) 
```





**Parameters:**


* `t` A token identifying the accelerator resource. 



**Returns:**

A properties smart pointer for the given token. 





        

### function get [5/6]

_Retrieve the properties for a given fpga\_token._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get (
    fpga_token t
) 
```





**Parameters:**


* `t` An fpga\_token identifying the accelerator resource. 



**Returns:**

A properties smart pointer for the given fpga\_token. 





        

### function get [6/6]

_Retrieve the properties for a given handle object._ 
```C++
static properties::ptr_t opae::fpga::types::properties::get (
    std::shared_ptr< handle > h
) 
```





**Parameters:**


* `h` A handle identifying the accelerator resource. 



**Returns:**

A properties smart pointer for the given handle. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/properties.h`