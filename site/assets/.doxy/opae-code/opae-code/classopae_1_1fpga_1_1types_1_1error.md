
# Class opae::fpga::types::error



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**error**](classopae_1_1fpga_1_1types_1_1error.md)



_An error object represents an error register for a resource._ [More...](#detailed-description)

* `#include <errors.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**error**](classopae_1_1fpga_1_1types_1_1error.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_error\_info**](structfpga__error__info.md) | [**c\_type**](#function-c_type) () const<br>_Get the C data structure._  |
|  bool | [**can\_clear**](#function-can_clear) () <br>_Indicates whether an error register can be cleared._  |
|   | [**error**](#function-error-12) (const [**error**](classopae_1_1fpga_1_1types_1_1error.md) & e) = delete<br> |
|  std::string | [**name**](#function-name) () <br>_Get the error register name._  |
|  [**error**](classopae_1_1fpga_1_1types_1_1error.md) & | [**operator=**](#function-operator) (const [**error**](classopae_1_1fpga_1_1types_1_1error.md) & e) = delete<br> |
|  uint64\_t | [**read\_value**](#function-read_value) () <br>_Read the raw value contained in the associated error register._  |
|   | [**~error**](#function-error) () <br> |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**error::ptr\_t**](classopae_1_1fpga_1_1types_1_1error.md#typedef-ptr_t) | [**get**](#function-get) ([**token::ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) tok, uint32\_t num) <br>_Factory function for creating an error object._  |







# Detailed Description


This is used to read out the raw value in the register. No parsing is done by this class. 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<error> opae::fpga::types::error::ptr_t;
```



## Public Functions Documentation


### function c\_type 

_Get the C data structure._ 
```C++
inline fpga_error_info opae::fpga::types::error::c_type () const
```





**Returns:**

The [**fpga\_error\_info**](structfpga__error__info.md) that contains the name and the can\_clear boolean. 





        

### function can\_clear 

_Indicates whether an error register can be cleared._ 
```C++
inline bool opae::fpga::types::error::can_clear () 
```





**Returns:**

A boolean value indicating if the error register can be cleared. 





        

### function error [1/2]

```C++
opae::fpga::types::error::error (
    const error & e
) = delete
```




### function name 

_Get the error register name._ 
```C++
inline std::string opae::fpga::types::error::name () 
```





**Returns:**

A std::string object set to the error name. 





        

### function operator= 

```C++
error & opae::fpga::types::error::operator= (
    const error & e
) = delete
```




### function read\_value 

_Read the raw value contained in the associated error register._ 
```C++
uint64_t opae::fpga::types::error::read_value () 
```





**Returns:**

A 64-bit value (unparsed) read from the error register 





        

### function ~error 

```C++
inline opae::fpga::types::error::~error () 
```



## Public Static Functions Documentation


### function get 

_Factory function for creating an error object._ 
```C++
static error::ptr_t opae::fpga::types::error::get (
    token::ptr_t tok,
    uint32_t num
) 
```





**Parameters:**


* `tok` The token object representing a resource. 
* `num` The index of the error register. This must be lower than the num\_errors property of the resource.



**Returns:**

A shared\_ptr containing the error object 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/errors.h`