
# File hello\_events.c



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**samples**](dir_9a6968a8846ef48cff617fcd6355d7b4.md) **>** [**hello\_events**](dir_d66a8e4b979fa79493bebe26e2602d2b.md) **>** [**hello\_events.c**](hello__events_8c.md)

[Go to the source code of this file.](hello__events_8c_source.md)

_A code sample of using OPAE event API._ [More...](#detailed-description)

* `#include <stdio.h>`
* `#include <stdlib.h>`
* `#include <string.h>`
* `#include <unistd.h>`
* `#include <getopt.h>`
* `#include <poll.h>`
* `#include <errno.h>`
* `#include <sys/stat.h>`
* `#include <pthread.h>`
* `#include <opae/fpga.h>`
* `#include <argsfilter.h>`
* `#include "mock/opae_std.h"`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**ras\_inject\_error**](structras__inject__error.md) <br> |





## Public Functions

| Type | Name |
| ---: | :--- |
|  void \* | [**error\_thread**](#function-error_thread) (void \* arg) <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**find\_fpga**](#function-find_fpga) ([**fpga\_properties**](types_8h.md#typedef-fpga_properties) device\_filter, [**fpga\_token**](types_8h.md#typedef-fpga_token) \* fpga, uint32\_t \* num\_matches) <br> |
|  void | [**help**](#function-help) (void) <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**inject\_ras\_fatal\_error**](#function-inject_ras_fatal_error) ([**fpga\_token**](types_8h.md#typedef-fpga_token) fme\_token, uint8\_t err) <br> |
|  int | [**main**](#function-main) (int argc, char \* argv) <br> |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**parse\_args**](#function-parse_args) (int argc, char \* argv) <br> |
|  void | [**print\_err**](#function-print_err) (const char \* s, [**fpga\_result**](types__enum_8h.md#enum-fpga_result) res) <br> |
|  int | [**usleep**](#function-usleep) (unsigned) <br> |







## Macros

| Type | Name |
| ---: | :--- |
| define  | [**FME\_SYSFS\_INJECT\_ERROR**](hello__events_8c.md#define-fme_sysfs_inject_error)  "errors/inject\_errors"<br> |
| define  | [**GETOPT\_STRING**](hello__events_8c.md#define-getopt_string)  "hv"<br> |
| define  | [**ON\_ERR\_GOTO**](hello__events_8c.md#define-on_err_goto) (res, label, desc) <br> |

# Detailed Description


This sample starts two processes. One process injects an artificial fatal error to sysfs; while the other tries to asynchronously capture and handle the event. This sample code exercises all major functions of the event API, including creating and destroying event handles, register and unregister events, polling on event file descriptor, and getting the OS object associated with an event. For a full discussion of OPAE event API, refer to [**event.h**](event_8h.md). 


    
## Public Functions Documentation


### function error\_thread 

```C++
void * error_thread (
    void * arg
) 
```




### function find\_fpga 

```C++
fpga_result find_fpga (
    fpga_properties device_filter,
    fpga_token * fpga,
    uint32_t * num_matches
) 
```




### function help 

```C++
void help (
    void
) 
```




### function inject\_ras\_fatal\_error 

```C++
fpga_result inject_ras_fatal_error (
    fpga_token fme_token,
    uint8_t err
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




### function usleep 

```C++
int usleep (
    unsigned
) 
```



## Macro Definition Documentation



### define FME\_SYSFS\_INJECT\_ERROR 

```C++
#define FME_SYSFS_INJECT_ERROR "errors/inject_errors"
```




### define GETOPT\_STRING 

```C++
#define GETOPT_STRING "hv"
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




------------------------------
The documentation for this class was generated from the following file `docs/sw/samples/hello_events/hello_events.c`