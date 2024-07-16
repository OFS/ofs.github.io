
# File hello\_fpga.c



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**samples**](dir_9a6968a8846ef48cff617fcd6355d7b4.md) **>** [**hello\_fpga**](dir_a3c160366dc832de1042e5d4d49ef034.md) **>** [**hello\_fpga.c**](hello__fpga_8c.md)

[Go to the source code of this file.](hello__fpga_8c_source.md)

_A code sample illustrates the basic usage of the OPAE C API._ [More...](#detailed-description)

* `#include <stdio.h>`
* `#include <stdlib.h>`
* `#include <string.h>`
* `#include <stdint.h>`
* `#include <getopt.h>`
* `#include <unistd.h>`
* `#include <uuid/uuid.h>`
* `#include <opae/fpga.h>`
* `#include <argsfilter.h>`
* `#include "mock/opae_std.h"`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**cache\_line**](structcache__line.md) <br> |
| struct | [**config**](structconfig.md) <br> |



## Public Attributes

| Type | Name |
| ---: | :--- |
|  struct [**config**](structconfig.md) | [**config**](#variable-config)   = = {
	.open\_flags = 0,
	.run\_n3000 = 0
}<br> |


## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**find\_fpga**](#function-find_fpga) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) device\_filter, [**fpga\_guid**](types_8h.md#typedef-fpga_guid) afu\_guid, [**fpga\_token**](types_8h.md#typedef-fpga_token) \* accelerator\_token, uint32\_t \* num\_matches\_accelerators) <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**find\_nlb\_n3000**](#function-find_nlb_n3000) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) accelerator\_handle, uint64\_t \* afu\_baddr) <br> |
|  void | [**help**](#function-help) (void) <br> |
|  int | [**main**](#function-main) (int argc, char \* argv) <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**parse\_args**](#function-parse_args) (int argc, char \* argv) <br> |
|  void | [**print\_err**](#function-print_err) (const char \* s, [**fpga\_result**](types__enum_8h.md#enum-fpga_result) res) <br> |
|  bool | [**probe\_for\_ase**](#function-probe_for_ase) (void) <br> |
|  int | [**usleep**](#function-usleep) (unsigned) <br> |







## Macros

| Type | Name |
| ---: | :--- |
| define  | [**CACHELINE\_ALIGNED\_ADDR**](hello__fpga_8c.md#define-cacheline_aligned_addr) (p) ((p) &gt;&gt; [**LOG2\_CL**](hello__fpga_8c.md#define-log2_cl))<br> |
| define  | [**CL**](hello__fpga_8c.md#define-cl) (x) ((x) \* 64)<br> |
| define  | [**CSR\_AFU\_DSM\_BASEL**](hello__fpga_8c.md#define-csr_afu_dsm_basel)  0x0110<br> |
| define  | [**CSR\_CFG**](hello__fpga_8c.md#define-csr_cfg)  0x0140<br> |
| define  | [**CSR\_CTL**](hello__fpga_8c.md#define-csr_ctl)  0x0138<br> |
| define  | [**CSR\_DST\_ADDR**](hello__fpga_8c.md#define-csr_dst_addr)  0x0128<br> |
| define  | [**CSR\_NUM\_LINES**](hello__fpga_8c.md#define-csr_num_lines)  0x0130<br> |
| define  | [**CSR\_SRC\_ADDR**](hello__fpga_8c.md#define-csr_src_addr)  0x0120<br> |
| define  | [**CSR\_STATUS1**](hello__fpga_8c.md#define-csr_status1)  0x0168<br> |
| define  | [**DSM\_STATUS\_TEST\_COMPLETE**](hello__fpga_8c.md#define-dsm_status_test_complete)  0x40<br> |
| define  | [**FPGA\_NLB0\_UUID\_H**](hello__fpga_8c.md#define-fpga_nlb0_uuid_h)  0xd8424dc4a4a3c413<br> |
| define  | [**FPGA\_NLB0\_UUID\_L**](hello__fpga_8c.md#define-fpga_nlb0_uuid_l)  0xf89e433683f9040b<br> |
| define  | [**GETOPT\_STRING**](hello__fpga_8c.md#define-getopt_string)  "hscv"<br> |
| define  | [**LOG2\_CL**](hello__fpga_8c.md#define-log2_cl)  6<br> |
| define  | [**LPBK1\_BUFFER\_ALLOCATION\_SIZE**](hello__fpga_8c.md#define-lpbk1_buffer_allocation_size)  [**MB**](hello__fpga_8c.md#define-mb)(2)<br> |
| define  | [**LPBK1\_BUFFER\_SIZE**](hello__fpga_8c.md#define-lpbk1_buffer_size)  [**MB**](hello__fpga_8c.md#define-mb)(1)<br> |
| define  | [**LPBK1\_DSM\_SIZE**](hello__fpga_8c.md#define-lpbk1_dsm_size)  [**MB**](hello__fpga_8c.md#define-mb)(2)<br> |
| define  | [**MB**](hello__fpga_8c.md#define-mb) (x) ((x) \* 1024 \* 1024)<br> |
| define  | [**N3000\_AFUID**](hello__fpga_8c.md#define-n3000_afuid)  "9AEFFE5F-8457-0612-C000-C9660D824272"<br> |
| define  | [**NLB0\_AFUID**](hello__fpga_8c.md#define-nlb0_afuid)  "D8424DC4-A4A3-C413-F89E-433683F9040B"<br> |
| define  | [**ON\_ERR\_GOTO**](hello__fpga_8c.md#define-on_err_goto) (res, label, desc) <br> |
| define  | [**TEST\_TIMEOUT**](hello__fpga_8c.md#define-test_timeout)  30000<br> |

# Detailed Description


The sample is a host application that demonstrates the basic steps of interacting with FPGA using the OPAE library. These steps include:



* FPGA enumeration
* Resource acquiring and releasing
* Managing shared memory buffer
* MMIO read and write




The sample also demonstrates OPAE's object model, such as tokens, handles, and properties.


The sample requires a native loopback mode (NLB) test image to be loaded on the FPGA. Refer to [Quick Start Guide](https://opae.github.io/docs/fpga_api/quick_start/readme.html) for full instructions on building, configuring, and running this code sample. 


    
## Public Attributes Documentation


### variable config 

```C++
struct config config;
```



## Public Functions Documentation


### function find\_fpga 

```C++
fpga_result find_fpga (
    fpga_properties device_filter,
    fpga_guid afu_guid,
    fpga_token * accelerator_token,
    uint32_t * num_matches_accelerators
) 
```




### function find\_nlb\_n3000 

```C++
fpga_result find_nlb_n3000 (
    fpga_handle accelerator_handle,
    uint64_t * afu_baddr
) 
```




### function help 

```C++
void help (
    void
) 
```




### function main 

```C++
int main (
    int argc,
    char * argv
) 
```




### function parse\_args 

```C++
fpga_result parse_args (
    int argc,
    char * argv
) 
```




### function print\_err 

```C++
void print_err (
    const char * s,
    fpga_result res
) 
```




### function probe\_for\_ase 

```C++
bool probe_for_ase (
    void
) 
```




### function usleep 

```C++
int usleep (
    unsigned
) 
```



## Macro Definition Documentation



### define CACHELINE\_ALIGNED\_ADDR 

```C++
#define CACHELINE_ALIGNED_ADDR (
    p
) ((p) >> LOG2_CL )
```




### define CL 

```C++
#define CL (
    x
) ((x) * 64)
```




### define CSR\_AFU\_DSM\_BASEL 

```C++
#define CSR_AFU_DSM_BASEL 0x0110
```




### define CSR\_CFG 

```C++
#define CSR_CFG 0x0140
```




### define CSR\_CTL 

```C++
#define CSR_CTL 0x0138
```




### define CSR\_DST\_ADDR 

```C++
#define CSR_DST_ADDR 0x0128
```




### define CSR\_NUM\_LINES 

```C++
#define CSR_NUM_LINES 0x0130
```




### define CSR\_SRC\_ADDR 

```C++
#define CSR_SRC_ADDR 0x0120
```




### define CSR\_STATUS1 

```C++
#define CSR_STATUS1 0x0168
```




### define DSM\_STATUS\_TEST\_COMPLETE 

```C++
#define DSM_STATUS_TEST_COMPLETE 0x40
```




### define FPGA\_NLB0\_UUID\_H 

```C++
#define FPGA_NLB0_UUID_H 0xd8424dc4a4a3c413
```




### define FPGA\_NLB0\_UUID\_L 

```C++
#define FPGA_NLB0_UUID_L 0xf89e433683f9040b
```




### define GETOPT\_STRING 

```C++
#define GETOPT_STRING "hscv"
```




### define LOG2\_CL 

```C++
#define LOG2_CL 6
```




### define LPBK1\_BUFFER\_ALLOCATION\_SIZE 

```C++
#define LPBK1_BUFFER_ALLOCATION_SIZE MB (2)
```




### define LPBK1\_BUFFER\_SIZE 

```C++
#define LPBK1_BUFFER_SIZE MB (1)
```




### define LPBK1\_DSM\_SIZE 

```C++
#define LPBK1_DSM_SIZE MB (2)
```




### define MB 

```C++
#define MB (
    x
) ((x) * 1024 * 1024)
```




### define N3000\_AFUID 

```C++
#define N3000_AFUID "9AEFFE5F-8457-0612-C000-C9660D824272"
```




### define NLB0\_AFUID 

```C++
#define NLB0_AFUID "D8424DC4-A4A3-C413-F89E-433683F9040B"
```




### define ON\_ERR\_GOTO 

```C++
#define ON_ERR_GOTO (
    res,
    label,
    desc
) do {                                       \
		if ((res) != FPGA_OK ) {            \ print_err ((desc), (res));  \
			goto label;                \
		}                                  \
	} while (0)
```




### define TEST\_TIMEOUT 

```C++
#define TEST_TIMEOUT 30000
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/samples/hello_fpga/hello_fpga.c`