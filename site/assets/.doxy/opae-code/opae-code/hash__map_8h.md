
# File hash\_map.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**hash\_map.h**](hash__map_8h.md)

[Go to the source code of this file.](hash__map_8h_source.md)

_A general-purpose hybrid array/list hash map implementation._ [More...](#detailed-description)

* `#include <stdint.h>`
* `#include <stdbool.h>`
* `#include <opae/types_enum.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**\_opae\_hash\_map**](struct__opae__hash__map.md) <br>_Hash map object._  |
| struct | [**\_opae\_hash\_map\_item**](struct__opae__hash__map__item.md) <br>_List link item._  |

## Public Types

| Type | Name |
| ---: | :--- |
| enum  | [**\_opae\_hash\_map\_flags**](#enum-_opae_hash_map_flags)  <br>_Flags used to initialize a hash map._  |
| typedef struct [**\_opae\_hash\_map**](struct__opae__hash__map.md) | [**opae\_hash\_map**](#typedef-opae_hash_map)  <br>_Hash map object._  |
| typedef enum [**\_opae\_hash\_map\_flags**](hash__map_8h.md#enum-_opae_hash_map_flags) | [**opae\_hash\_map\_flags**](#typedef-opae_hash_map_flags)  <br>_Flags used to initialize a hash map._  |
| typedef struct [**\_opae\_hash\_map\_item**](struct__opae__hash__map__item.md) | [**opae\_hash\_map\_item**](#typedef-opae_hash_map_item)  <br>_List link item._  |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**opae\_hash\_map\_add**](#function-opae_hash_map_add) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm, void \* key, void \* value) <br>_Map a key to a value._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**opae\_hash\_map\_destroy**](#function-opae_hash_map_destroy) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm) <br>_Tear down a hash map._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**opae\_hash\_map\_find**](#function-opae_hash_map_find) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm, void \* key, void \*\* value) <br>_Retrieve the value for a given key._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**opae\_hash\_map\_init**](#function-opae_hash_map_init) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm, uint32\_t num\_buckets, uint32\_t hash\_seed, int flags, uint32\_t(\*)(uint32\_t num\_buckets, uint32\_t hash\_seed, void \*key) key\_hash, int(\*)(void \*keya, void \*keyb) key\_compare, void(\*)(void \*key, void \*context) key\_cleanup, void(\*)(void \*value, void \*context) value\_cleanup) <br>_Initialize a hash map._  |
|  bool | [**opae\_hash\_map\_is\_empty**](#function-opae_hash_map_is_empty) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm) <br>_Determine whether a hash map is empty._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**opae\_hash\_map\_remove**](#function-opae_hash_map_remove) ([**opae\_hash\_map**](hash__map_8h.md#typedef-opae_hash_map) \* hm, void \* key) <br>_Remove a key/value association._  |
|  int | [**opae\_u64\_key\_compare**](#function-opae_u64_key_compare) (void \* keya, void \* keyb) <br>_Convenience key comparison function for 64-bit values._  |
|  uint32\_t | [**opae\_u64\_key\_hash**](#function-opae_u64_key_hash) (uint32\_t num\_buckets, uint32\_t hash\_seed, void \* key) <br>_Convenience hash function for arbitrary pointers/64-bit values._  |








# Detailed Description


Presents a generic interface for mapping key objects to value objects. Both keys and values may be arbitrary data structures. The user supplies the means by which the hash of values is generated and by which the keys are compared to each other. 


    
## Public Types Documentation


### enum \_opae\_hash\_map\_flags 

_Flags used to initialize a hash map._ 
```C++
enum _opae_hash_map_flags {
    OPAE_HASH_MAP_UNIQUE_KEYSPACE = (1u << 0)
};
```



OPAE\_HASH\_MAP\_UNIQUE\_KEYSPACE says that the user provides a guarantee that the key space is truly unique. In other words, when the provided hash function for keys A and B returns the same bucket index, the key comparison function when comparing A and B will never return a result saying that the keys are equal in value. This is helpful in situations where the key space is guaranteed to produce unique values, for example a memory allocator. When the key space is guaranteed to be unique, [**opae\_hash\_map\_add()**](hash__map_8h.md#function-opae_hash_map_add) can implement a small performance improvement. 


        

### typedef opae\_hash\_map 

_Hash map object._ 
```C++
typedef struct _opae_hash_map opae_hash_map;
```



This structure defines the internals of the hash map. Each of the parameters supplied to [**opae\_hash\_map\_init()**](hash__map_8h.md#function-opae_hash_map_init) is stored in the structure. All parameters are required, except key\_cleanup and value\_cleanup, which may optionally be NULL. 


        

### typedef opae\_hash\_map\_flags 

_Flags used to initialize a hash map._ 
```C++
typedef enum _opae_hash_map_flags opae_hash_map_flags;
```



OPAE\_HASH\_MAP\_UNIQUE\_KEYSPACE says that the user provides a guarantee that the key space is truly unique. In other words, when the provided hash function for keys A and B returns the same bucket index, the key comparison function when comparing A and B will never return a result saying that the keys are equal in value. This is helpful in situations where the key space is guaranteed to produce unique values, for example a memory allocator. When the key space is guaranteed to be unique, [**opae\_hash\_map\_add()**](hash__map_8h.md#function-opae_hash_map_add) can implement a small performance improvement. 


        

### typedef opae\_hash\_map\_item 

_List link item._ 
```C++
typedef struct _opae_hash_map_item opae_hash_map_item;
```



This structure provides the association between key and value. When the supplied hash function for keys A and B returns the same bucket index, both A and B can co-exist on the same list rooted at the bucket index. 


        
## Public Functions Documentation


### function opae\_hash\_map\_add 

_Map a key to a value._ 
```C++
fpga_result opae_hash_map_add (
    opae_hash_map * hm,
    void * key,
    void * value
) 
```



Inserts a mapping from key to value in the given hash map object. Subsequent calls to [**opae\_hash\_map\_find()**](hash__map_8h.md#function-opae_hash_map_find) that are given the key will retrieve the value.




**Parameters:**


* `hm` A pointer to the storage for the hash map object. 
* `key` The hash map key. 
* `value` The hash map value. 



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if hm is NULL, FPGA\_NO\_MEMORY if malloc() fails when allocating the list item, or FPGA\_INVALID\_PARAM if the key hash produced by key\_hash is out of bounds. 





        

### function opae\_hash\_map\_destroy 

_Tear down a hash map._ 
```C++
fpga_result opae_hash_map_destroy (
    opae_hash_map * hm
) 
```



Given a hash map that was previously initialized by [**opae\_hash\_map\_init()**](hash__map_8h.md#function-opae_hash_map_init), destroy the hash map, releasing all keys, values, and the bucket array.




**Parameters:**


* `hm` A pointer to the storage for the hash map object. 



**Returns:**

FPGA\_OK on success or FPGA\_INVALID\_PARAM is hm is NULL. 





        

### function opae\_hash\_map\_find 

_Retrieve the value for a given key._ 
```C++
fpga_result opae_hash_map_find (
    opae_hash_map * hm,
    void * key,
    void ** value
) 
```



Given a key that was previously passed to [**opae\_hash\_map\_add()**](hash__map_8h.md#function-opae_hash_map_add), retrieve its associated value.




**Parameters:**


* `hm` A pointer to the storage for the hash map object. 
* `key` The hash map key. 
* `value` A pointer to receive the hash map value. 



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if hm is NULL or if the key hash produced by key\_hash is out of bounds, or FPGA\_NOT\_FOUND if the given key was not found in the hash map. 





        

### function opae\_hash\_map\_init 

_Initialize a hash map._ 
```C++
fpga_result opae_hash_map_init (
    opae_hash_map * hm,
    uint32_t num_buckets,
    uint32_t hash_seed,
    int flags,
    uint32_t(*)(uint32_t num_buckets, uint32_t hash_seed, void *key) key_hash,
    int(*)(void *keya, void *keyb) key_compare,
    void(*)(void *key, void *context) key_cleanup,
    void(*)(void *value, void *context) value_cleanup
) 
```



Populates the hash map data structure and allocates the buckets array.




**Parameters:**


* `hm` A pointer to the storage for the hash map object. 
* `num_buckets` The desired size of the buckets array. Each array entry may be empty (NULL), or may contain a list of opae\_hash\_map\_item structures for which the given key\_hash function returned the same key hash value. 
* `hash_seed` A seed value used during key hash computation. This value will be the hash\_seed parameter to the key hash function. 
* `flags` Initialization flags. See opae\_hash\_map\_flags. 
* `key_hash` A pointer to a function that produces the hash value, given the number of buckets, the hash seed, and the key. Valid values are between 0 and num\_buckets - 1, inclusively. 
* `key_compare` A pointer to a function that compares two keys. The return value is similar to that of strcmp(), where a negative value means that keya &lt; keyb, 0 means that keya == keyb, and a positive values means that keya &gt; keyb. 
* `key_cleanup` A pointer to a function that is called when a key is being removed from the map. This function is optional and may be NULL. When supplied, the function is responsible for freeing any resources allocated when the key was created. 
* `value_cleanup` A pointer to a function that is called when a value is being removed from the map. This function is optional and may be NULL. When supplied, the function is responsible for freeing any resources allocated when the value was created. 



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM if any of the required parameters are NULL, or FPGA\_NO\_MEMORY if the bucket array could not be allocated. 





        

### function opae\_hash\_map\_is\_empty 

_Determine whether a hash map is empty._ 
```C++
bool opae_hash_map_is_empty (
    opae_hash_map * hm
) 
```





**Parameters:**


* `hm` A pointer to the storage for the hash map object. 



**Returns:**

true if there are no key/value mappings present, false otherwise. 





        

### function opae\_hash\_map\_remove 

_Remove a key/value association._ 
```C++
fpga_result opae_hash_map_remove (
    opae_hash_map * hm,
    void * key
) 
```



Given a key that was previously passed to [**opae\_hash\_map\_add()**](hash__map_8h.md#function-opae_hash_map_add), remove the key and its associated value, calling the cleanup functions as needed.




**Parameters:**


* `hm` A pointer to the storage for the hash map object. 
* `key` The hash map key. 



**Returns:**

FPGA\_OK on success, FPGA\_INVALID\_PARAM when hm is NULL or when the key hash produced by key\_hash is out of bounds, or FPGA\_NOT\_FOUND if the key is not found in the hash map. 





        

### function opae\_u64\_key\_compare 

_Convenience key comparison function for 64-bit values._ 
```C++
int opae_u64_key_compare (
    void * keya,
    void * keyb
) 
```



Simply converts the key pointers to uint64\_t's and performs unsigned integer comparison. 


        

### function opae\_u64\_key\_hash 

_Convenience hash function for arbitrary pointers/64-bit values._ 
```C++
uint32_t opae_u64_key_hash (
    uint32_t num_buckets,
    uint32_t hash_seed,
    void * key
) 
```



Simply converts the key to a uint64\_t and then performs the modulus operation with the configured num\_buckets. hash\_seed is unused. 


        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/hash_map.h`