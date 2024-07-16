
# Class opae::fpga::types::src\_location



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md)



_Identify a particular line in a source file._ 

* `#include <except.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  const char \* | [**file**](#function-file) () noexcept const<br>_Retrieve the file name component of the location._  |
|  const char \* | [**fn**](#function-fn) () noexcept const<br>_Retrieve the function name component of the location._  |
|  int | [**line**](#function-line) () noexcept const<br>_Retrieve the line number component of the location._  |
|  [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) & | [**operator=**](#function-operator) (const [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) & other) noexcept<br> |
|   | [**src\_location**](#function-src_location-12) (const char \* file, const char \* fn, int line) noexcept<br>[_**src\_location**_](classopae_1_1fpga_1_1types_1_1src__location.md) _constructor_ |
|   | [**src\_location**](#function-src_location-22) (const [**src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) & other) noexcept<br> |








## Public Functions Documentation


### function file 

```C++
const char * opae::fpga::types::src_location::file () noexcept const
```




### function fn 

```C++
inline const char * opae::fpga::types::src_location::fn () noexcept const
```




### function line 

```C++
inline int opae::fpga::types::src_location::line () noexcept const
```




### function operator= 

```C++
src_location & opae::fpga::types::src_location::operator= (
    const src_location & other
) noexcept
```




### function src\_location [1/2]

[_**src\_location**_](classopae_1_1fpga_1_1types_1_1src__location.md) _constructor_
```C++
opae::fpga::types::src_location::src_location (
    const char * file,
    const char * fn,
    int line
) noexcept
```





**Parameters:**


* `file` The source file name, typically **FILE**. 
* `fn` The current function, typically **func**. 
* `line` The current line number, typically **LINE**. 




        

### function src\_location [2/2]

```C++
opae::fpga::types::src_location::src_location (
    const src_location & other
) noexcept
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/except.h`