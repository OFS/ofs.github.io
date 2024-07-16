
# Class opae::fpga::types::handle



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**handle**](classopae_1_1fpga_1_1types_1_1handle.md)



_An allocated accelerator resource._ [More...](#detailed-description)

* `#include <handle.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**handle**](classopae_1_1fpga_1_1types_1_1handle.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_handle**](types_8h.md#typedef-fpga_handle) | [**c\_type**](#function-c_type) () const<br>_Retrieve the underlying OPAE handle._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**close**](#function-close) () <br>_Close an accelerator resource (if opened)_  |
|  [**token::ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) | [**get\_token**](#function-get_token) () const<br>_Retrieve the token corresponding to this handle object._  |
|   | [**handle**](#function-handle-12) (const [**handle**](classopae_1_1fpga_1_1types_1_1handle.md) &) = delete<br> |
|  uint8\_t \* | [**mmio\_ptr**](#function-mmio_ptr) (uint64\_t offset, uint32\_t csr\_space=0) const<br>_Retrieve a pointer to the MMIO region._  |
|   | [**operator fpga\_handle**](#function-operator-fpga_handle) () const<br>_Retrieve the underlying OPAE handle._  |
|  [**handle**](classopae_1_1fpga_1_1types_1_1handle.md) & | [**operator=**](#function-operator) (const [**handle**](classopae_1_1fpga_1_1types_1_1handle.md) &) = delete<br> |
|  uint32\_t | [**read\_csr32**](#function-read_csr32) (uint64\_t offset, uint32\_t csr\_space=0) const<br>_Read 32 bits from a CSR belonging to a resource associated with a handle._  |
|  uint64\_t | [**read\_csr64**](#function-read_csr64) (uint64\_t offset, uint32\_t csr\_space=0) const<br>_Read 64 bits from a CSR belonging to a resource associated with a handle._  |
|  void | [**reconfigure**](#function-reconfigure) (uint32\_t slot, const uint8\_t \* bitstream, size\_t size, int flags) <br>_Load a bitstream into an FPGA slot._  |
| virtual void | [**reset**](#function-reset) () <br>_Reset the accelerator identified by this handle._  |
|  void | [**write\_csr32**](#function-write_csr32) (uint64\_t offset, uint32\_t value, uint32\_t csr\_space=0) <br>_Write 32 bit to a CSR belonging to a resource associated with a handle._  |
|  void | [**write\_csr512**](#function-write_csr512) (uint64\_t offset, const void \* value, uint32\_t csr\_space=0) <br>_Write 512 bits to a CSR belonging to a resource associated with a handle._  |
|  void | [**write\_csr64**](#function-write_csr64) (uint64\_t offset, uint64\_t value, uint32\_t csr\_space=0) <br>_Write 64 bits to a CSR belonging to a resource associated with a handle._  |
| virtual  | [**~handle**](#function-handle) () <br> |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) | [**open**](#function-open-12) ([**fpga\_token**](types_8h.md#typedef-fpga_token) token, int flags) <br>_Open an accelerator resource, given a raw fpga\_token._  |
|  [**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) | [**open**](#function-open-22) ([**token::ptr\_t**](classopae_1_1fpga_1_1types_1_1token.md#typedef-ptr_t) token, int flags) <br>_Open an accelerator resource, given a token object._  |







# Detailed Description


Represents an accelerator resource that has been allocated by OPAE. Depending on the type of resource, its register space may be read/written using a handle object. 


    
## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<handle> opae::fpga::types::handle::ptr_t;
```



## Public Functions Documentation


### function c\_type 

```C++
inline fpga_handle opae::fpga::types::handle::c_type () const
```




### function close 

_Close an accelerator resource (if opened)_ 
```C++
fpga_result opae::fpga::types::handle::close () 
```





**Returns:**

fpga\_result indication the result of closing the handle or FPGA\_EXCEPTION if handle is not opened




**Note:**

This is available for explicitly closing a handle. The destructor for handle will call close. 





        

### function get\_token 

```C++
token::ptr_t opae::fpga::types::handle::get_token () const
```




### function handle [1/2]

```C++
opae::fpga::types::handle::handle (
    const handle &
) = delete
```




### function mmio\_ptr 

_Retrieve a pointer to the MMIO region._ 
```C++
uint8_t * opae::fpga::types::handle::mmio_ptr (
    uint64_t offset,
    uint32_t csr_space=0
) const
```





**Parameters:**


* `offset` The byte offset to add to MMIO base. 
* `csr_space` The desired CSR space. Default is 0. 



**Returns:**

MMIO base + offset 





        

### function operator fpga\_handle 

```C++
inline opae::fpga::types::handle::operator fpga_handle () const
```




### function operator= 

```C++
handle & opae::fpga::types::handle::operator= (
    const handle &
) = delete
```




### function read\_csr32 

_Read 32 bits from a CSR belonging to a resource associated with a handle._ 
```C++
uint32_t opae::fpga::types::handle::read_csr32 (
    uint64_t offset,
    uint32_t csr_space=0
) const
```





**Parameters:**


* `offset` The register offset 
* `csr_space` The CSR space to read from. Default is 0.



**Returns:**

The 32-bit value read from the CSR 





        

### function read\_csr64 

_Read 64 bits from a CSR belonging to a resource associated with a handle._ 
```C++
uint64_t opae::fpga::types::handle::read_csr64 (
    uint64_t offset,
    uint32_t csr_space=0
) const
```





**Parameters:**


* `offset` The register offset 
* `csr_space` The CSR space to read from. Default is 0.



**Returns:**

The 64-bit value read from the CSR 





        

### function reconfigure 

_Load a bitstream into an FPGA slot._ 
```C++
void opae::fpga::types::handle::reconfigure (
    uint32_t slot,
    const uint8_t * bitstream,
    size_t size,
    int flags
) 
```





**Parameters:**


* `slot` The slot number to program 
* `bitstream` The bitstream binary data 
* `size` The size of the bitstream 
* `flags` Flags that control behavior of reconfiguration. Value of 0 indicates no flags. FPGA\_RECONF\_FORCE indicates that the bitstream is programmed into the slot without checking if the resource is currently in use.



**Exception:**


* [**invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) if the handle is not an FPGA device handle or if the other parameters are not valid. 
* `exception` if an internal error is encountered. 
* `busy` if the accelerator for the given slot is in use. 
* [**reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) if errors are reported by the driver (CRC or protocol errors). 




        

### function reset 

```C++
virtual void opae::fpga::types::handle::reset () 
```




### function write\_csr32 

_Write 32 bit to a CSR belonging to a resource associated with a handle._ 
```C++
void opae::fpga::types::handle::write_csr32 (
    uint64_t offset,
    uint32_t value,
    uint32_t csr_space=0
) 
```





**Parameters:**


* `offset` The register offset. 
* `value` The 32-bit value to write to the register. 
* `csr_space` The CSR space to read from. Default is 0. 




        

### function write\_csr512 

_Write 512 bits to a CSR belonging to a resource associated with a handle._ 
```C++
void opae::fpga::types::handle::write_csr512 (
    uint64_t offset,
    const void * value,
    uint32_t csr_space=0
) 
```





**Parameters:**


* `offset` The register offset. 
* `value` Pointer to the 512-bit value to write to the register. 
* `csr_space` The CSR space to read from. Default is 0. 




        

### function write\_csr64 

_Write 64 bits to a CSR belonging to a resource associated with a handle._ 
```C++
void opae::fpga::types::handle::write_csr64 (
    uint64_t offset,
    uint64_t value,
    uint32_t csr_space=0
) 
```





**Parameters:**


* `offset` The register offset. 
* `value` The 64-bit value to write to the register. 
* `csr_space` The CSR space to read from. Default is 0. 




        

### function ~handle 

```C++
virtual opae::fpga::types::handle::~handle () 
```



## Public Static Functions Documentation


### function open [1/2]

_Open an accelerator resource, given a raw fpga\_token._ 
```C++
static handle::ptr_t opae::fpga::types::handle::open (
    fpga_token token,
    int flags
) 
```





**Parameters:**


* `token` A token describing the accelerator resource to be allocated.
* `flags` The flags parameter to [**fpgaOpen()**](access_8h.md#function-fpgaopen).



**Returns:**

pointer to the mmio base + offset for the given csr space 





        

### function open [2/2]

_Open an accelerator resource, given a token object._ 
```C++
static handle::ptr_t opae::fpga::types::handle::open (
    token::ptr_t token,
    int flags
) 
```





**Parameters:**


* `token` A token object describing the accelerator resource to be allocated.
* `flags` The flags parameter to [**fpgaOpen()**](access_8h.md#function-fpgaopen).



**Returns:**

shared ptr to a handle object 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/handle.h`