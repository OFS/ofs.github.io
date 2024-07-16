
# Struct opae::fpga::types::pvalue

**template &lt;typename T typename T&gt;**



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)



_Wraps OPAE properties defined in the OPAE C API by associating an_ `fpga_properties` _reference with the getters and setters defined for a property._[More...](#detailed-description)

* `#include <pvalue.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::conditional&lt; std::is\_same&lt; T, char \* &gt;::value, typename std::string, T &gt;::type | [**copy\_t**](#typedef-copy_t)  <br>_Define the type of our copy variable For_ `char*` _types use std::string as the copy._ |
| typedef std::conditional&lt; std::is\_same&lt; T, char \* &gt;::value, [**fpga\_result**](types__enum_8h.md#enum-fpga_result)(\*)([**fpga\_properties**](types_8h.md#typedef-fpga_properties), T), [**fpga\_result**](types__enum_8h.md#enum-fpga_result)(\*)([**fpga\_properties**](types_8h.md#typedef-fpga_properties), T \*)&gt;::type | [**getter\_t**](#typedef-getter_t)  <br>_Define getter function as getter\_t For_ `char*` _types, do not use T\* as the second argument but instead use T._ |
| typedef [**fpga\_result**](types__enum_8h.md#enum-fpga_result)(\* | [**setter\_t**](#typedef-setter_t)  <br>_Define the setter function as setter\_t._  |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**get\_value**](#function-get_value) (T & value) const<br> |
|  void | [**invalidate**](#function-invalidate) () <br>_Invalidate the cached local copy of the pvalue._  |
|  bool | [**is\_set**](#function-is_set) () const<br>_Tracks whether the cached local copy of the pvalue is valid._  |
|   | [**operator copy\_t**](#function-operator-copy_t) () <br>_Implicit converter operator - calls the wrapped getter._  |
|  [**pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md)&lt; T &gt; & | [**operator=**](#function-operator) (const T & v) <br>_Overload of_ `=` _operator that calls the wrapped setter._ |
|  bool | [**operator==**](#function-operator_1) (const T & other) <br>_Compare a property for equality with a value._  |
|   | [**pvalue**](#function-pvalue-12) () <br> |
|   | [**pvalue**](#function-pvalue-22) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) \* p, [**getter\_t**](structopae_1_1fpga_1_1types_1_1pvalue.md#typedef-getter_t) g, [**setter\_t**](structopae_1_1fpga_1_1types_1_1pvalue.md#typedef-setter_t) s) <br>_pvalue contructor that takes in a reference to fpga\_properties and corresponding accessor methods for a property_  |
|  void | [**update**](#function-update-12) () <br> |
|  void | [**update**](#function-update-22) () <br>_Template specialization of_ `char*` _type property updater._ |








# Detailed Description




**Template parameters:**


* `T` The type of the property value being wrapped 




    
## Public Types Documentation


### typedef copy\_t 

```C++
typedef std::conditional<std::is_same<T, char *>::value, typename std::string, T>::type opae::fpga::types::pvalue< T >::copy_t;
```




### typedef getter\_t 

```C++
typedef std::conditional< std::is_same<T, char *>::value, fpga_result (*)(fpga_properties, T), fpga_result (*)(fpga_properties, T *)>::type opae::fpga::types::pvalue< T >::getter_t;
```




### typedef setter\_t 

```C++
typedef fpga_result(* opae::fpga::types::pvalue< T >::setter_t) (fpga_properties, T);
```



## Public Functions Documentation


### function get\_value 

```C++
inline fpga_result opae::fpga::types::pvalue::get_value (
    T & value
) const
```




### function invalidate 

```C++
inline void opae::fpga::types::pvalue::invalidate () 
```




### function is\_set 

```C++
inline bool opae::fpga::types::pvalue::is_set () const
```




### function operator copy\_t 

_Implicit converter operator - calls the wrapped getter._ 
```C++
inline opae::fpga::types::pvalue::operator copy_t () 
```





**Returns:**

The property value after calling the getter or a default value of the value type 





        

### function operator= 

_Overload of_ `=` _operator that calls the wrapped setter._
```C++
inline pvalue < T > & opae::fpga::types::pvalue::operator= (
    const T & v
) 
```





**Parameters:**


* `v` The value to set



**Returns:**

A reference to itself 





        

### function operator== 

_Compare a property for equality with a value._ 
```C++
inline bool opae::fpga::types::pvalue::operator== (
    const T & other
) 
```





**Parameters:**


* `other` The value being compared to



**Returns:**

Whether or not the property is equal to the value 





        

### function pvalue [1/2]

```C++
inline opae::fpga::types::pvalue::pvalue () 
```




### function pvalue [2/2]

_pvalue contructor that takes in a reference to fpga\_properties and corresponding accessor methods for a property_ 
```C++
inline opae::fpga::types::pvalue::pvalue (
    fpga_properties * p,
    getter_t g,
    setter_t s
) 
```





**Parameters:**


* `p` A reference to an fpga\_properties 
* `g` The getter function 
* `s` The setter function 




        

### function update [1/2]

```C++
inline void opae::fpga::types::pvalue::update () 
```




### function update [2/2]

_Template specialization of_ `char*` _type property updater._
```C++
inline void opae::fpga::types::pvalue::update () 
```





**Returns:**

The result of the property getter function. 





        ## Friends Documentation



### friend operator&lt;&lt; 

_Stream overalod operator._ 
```C++
inline std::ostream & opae::fpga::types::pvalue::operator<< (
    std::ostream & ostr,
    const pvalue < T > & p
) 
```





**Parameters:**


* `ostr` The output stream 
* `p` A reference to a pvalue&lt;T&gt; object



**Returns:**

The stream operator after streaming the property value 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/pvalue.h`