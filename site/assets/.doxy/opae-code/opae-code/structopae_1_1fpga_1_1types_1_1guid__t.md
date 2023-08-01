
# Struct opae::fpga::types::guid\_t



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**guid\_t**](structopae_1_1fpga_1_1types_1_1guid__t.md)



_Representation of the guid member of a properties object._ 

* `#include <pvalue.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  const uint8\_t \* | [**c\_type**](#function-c_type) () const<br>_Return a raw pointer to the guid._  |
|   | [**guid\_t**](#function-guid_t) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* p) <br>_Construct the_ [_**guid\_t**_](structopae_1_1fpga_1_1types_1_1guid__t.md) _given its containing fpga\_properties._ |
|  void | [**invalidate**](#function-invalidate) () <br>_Invalidate the cached local copy of the guid._  |
|  bool | [**is\_set**](#function-is_set) () const<br>_Tracks whether the cached local copy of the guid is valid._  |
|   | [**operator uint8\_t \***](#function-operator-uint8_t-*) () <br>_Return a raw pointer to the guid._  |
|  [**guid\_t**](structopae_1_1fpga_1_1types_1_1guid__t.md) & | [**operator=**](#function-operator) ([**fpga\_guid**](types_8h.md#typedef-fpga_guid) g) <br>_Assign from fpga\_guid Sets the guid field of the associated properties object using the OPAE properties API._  |
|  bool | [**operator==**](#function-operator_1) (const [**fpga\_guid**](types_8h.md#typedef-fpga_guid) & g) <br>_Compare contents with an fpga\_guid._  |
|  void | [**parse**](#function-parse) (const char \* str) <br>_Convert a string representation of a guid to binary._  |
|  void | [**update**](#function-update) () <br>_Update the local cached copy of the guid._  |








## Public Functions Documentation


### function c\_type 

```C++
inline const uint8_t * opae::fpga::types::guid_t::c_type () const
```




### function guid\_t 

```C++
inline opae::fpga::types::guid_t::guid_t (
    fpga_properties * p
) 
```




### function invalidate 

```C++
inline void opae::fpga::types::guid_t::invalidate () 
```




### function is\_set 

```C++
inline bool opae::fpga::types::guid_t::is_set () const
```




### function operator uint8\_t \* 

_Return a raw pointer to the guid._ 
```C++
inline opae::fpga::types::guid_t::operator uint8_t * () 
```





**Return value:**


* `nullptr` if the guid could not be queried. 




        

### function operator= 

_Assign from fpga\_guid Sets the guid field of the associated properties object using the OPAE properties API._ 
```C++
inline guid_t & opae::fpga::types::guid_t::operator= (
    fpga_guid g
) 
```





**Parameters:**


* `g` The given fpga\_guid. 



**Returns:**

a reference to this [**guid\_t**](structopae_1_1fpga_1_1types_1_1guid__t.md). 





        

### function operator== 

_Compare contents with an fpga\_guid._ 
```C++
inline bool opae::fpga::types::guid_t::operator== (
    const fpga_guid & g
) 
```





**Return value:**


* `The` result of memcmp of the two objects. 




        

### function parse 

_Convert a string representation of a guid to binary._ 
```C++
inline void opae::fpga::types::guid_t::parse (
    const char * str
) 
```





**Parameters:**


* `str` The guid string. 




        

### function update 

```C++
inline void opae::fpga::types::guid_t::update () 
```


## Friends Documentation



### friend operator&lt;&lt; 

```C++
inline std::ostream & opae::fpga::types::guid_t::operator<< (
    std::ostream & ostr,
    const guid_t & g
) 
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/pvalue.h`