
# Struct \_opae\_hash\_map\_item



[**ClassList**](annotated.md) **>** [**\_opae\_hash\_map\_item**](struct__opae__hash__map__item.md)



_List link item._ [More...](#detailed-description)

* `#include <hash_map.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  void \* | [**key**](#variable-key)  <br> |
|  struct [**\_opae\_hash\_map\_item**](struct__opae__hash__map__item.md) \* | [**next**](#variable-next)  <br> |
|  void \* | [**value**](#variable-value)  <br> |










# Detailed Description


This structure provides the association between key and value. When the supplied hash function for keys A and B returns the same bucket index, both A and B can co-exist on the same list rooted at the bucket index. 


    
## Public Attributes Documentation


### variable key 

```C++
void* _opae_hash_map_item::key;
```




### variable next 

```C++
struct _opae_hash_map_item* _opae_hash_map_item::next;
```




### variable value 

```C++
void* _opae_hash_map_item::value;
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/hash_map.h`