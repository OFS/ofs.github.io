
# Class opae::fpga::types::token



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**token**](classopae_1_1fpga_1_1types_1_1token.md)



_Wraps the OPAE fpga\_token primitive._ [More...](#detailed-description)

* `#include <token.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**token**](classopae_1_1fpga_1_1types_1_1token.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_token**](types_8h.md#typedef-fpga_token) | [**c\_type**](#function-c_type) () const<br>_Retrieve the underlying fpga\_token primitive._  |
|  [**ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) | [**get\_parent**](#function-get_parent) () const<br>_Retrieve the parent token, or an empty pointer if there is none._  |
|   | [**operator fpga\_token**](#function-operator-fpga_token) () const<br>_Retrieve the underlying fpga\_token primitive._  |
|   | [**~token**](#function-token) () <br> |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  std::vector&lt; [**token::ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) &gt; | [**enumerate**](#function-enumerate) (const std::vector&lt; [**properties::ptr\_t**](classopae_1_1fpga_1_1types_1_1properties.md#typedef-ptr_t) &gt; & props) <br>_Obtain a vector of token smart pointers for given search criteria._  |







# Detailed Description


token's are created from an enumeration operation that uses properties describing an accelerator resource as search criteria. 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<token> opae::fpga::types::token::ptr_t;
```



## Public Functions Documentation


### function c\_type 

```C++
inline fpga_token opae::fpga::types::token::c_type () const
```




### function get\_parent 

```C++
ptr_t opae::fpga::types::token::get_parent () const
```




### function operator fpga\_token 

```C++
inline opae::fpga::types::token::operator fpga_token () const
```




### function ~token 

```C++
opae::fpga::types::token::~token () 
```



## Public Static Functions Documentation


### function enumerate 

_Obtain a vector of token smart pointers for given search criteria._ 
```C++
static std::vector< token::ptr_t > opae::fpga::types::token::enumerate (
    const std::vector< properties::ptr_t > & props
) 
```





**Parameters:**


* `props` The search criteria. 



**Returns:**

A set of known tokens that match the search. 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/token.h`