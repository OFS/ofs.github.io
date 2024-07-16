
# Struct \_opae\_hash\_map



[**ClassList**](annotated.md) **>** [**\_opae\_hash\_map**](struct__opae__hash__map.md)



_Hash map object._ [More...](#detailed-description)

* `#include <hash_map.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  [**opae\_hash\_map\_item**](hash__map_8h.md#typedef-opae_hash_map_item) \*\* | [**buckets**](#variable-buckets)  <br> |
|  void \* | [**cleanup\_context**](#variable-cleanup_context)  <br>_Optional second parameter to key\_cleanup and value\_cleanup._  |
|  int | [**flags**](#variable-flags)  <br> |
|  uint32\_t | [**hash\_seed**](#variable-hash_seed)  <br> |
|  void(\* | [**key\_cleanup**](#variable-key_cleanup)  <br>_(optional)_  |
|  int(\* | [**key\_compare**](#variable-key_compare)  <br>_(required)_  |
|  uint32\_t(\* | [**key\_hash**](#variable-key_hash)  <br> |
|  uint32\_t | [**num\_buckets**](#variable-num_buckets)  <br> |
|  void(\* | [**value\_cleanup**](#variable-value_cleanup)  <br>_(optional)_  |










# Detailed Description


This structure defines the internals of the hash map. Each of the parameters supplied to [**opae\_hash\_map\_init()**](hash__map_8h.md#function-opae_hash_map_init) is stored in the structure. All parameters are required, except key\_cleanup and value\_cleanup, which may optionally be NULL. 


    
## Public Attributes Documentation


### variable buckets 

```C++
opae_hash_map_item** _opae_hash_map::buckets;
```




### variable cleanup\_context 

```C++
void* _opae_hash_map::cleanup_context;
```




### variable flags 

```C++
int _opae_hash_map::flags;
```




### variable hash\_seed 

```C++
uint32_t _opae_hash_map::hash_seed;
```




### variable key\_cleanup 

```C++
void(* _opae_hash_map::key_cleanup) (void *key, void *context);
```




### variable key\_compare 

```C++
int(* _opae_hash_map::key_compare) (void *keya, void *keyb);
```




### variable key\_hash 

```C++
uint32_t(* _opae_hash_map::key_hash) (uint32_t num_buckets, uint32_t hash_seed, void *key);
```




### variable num\_buckets 

```C++
uint32_t _opae_hash_map::num_buckets;
```




### variable value\_cleanup 

```C++
void(* _opae_hash_map::value_cleanup) (void *value, void *context);
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/hash_map.h`