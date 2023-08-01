
# File log.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**log.h**](log_8h.md)

[Go to the source code of this file.](log_8h_source.md)



* `#include <stdint.h>`
* `#include <stdlib.h>`
* `#include <string.h>`
* `#include <errno.h>`
* `#include <opae/types.h>`











## Public Types

| Type | Name |
| ---: | :--- |
| enum  | [**opae\_loglevel**](#enum-opae_loglevel)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  void | [**opae\_print**](#function-opae_print) (int loglevel, const char \* fmt, ...) <br> |







## Macros

| Type | Name |
| ---: | :--- |
| define  | [**OPAE\_DBG**](log_8h.md#define-opae_dbg) (format, ...) {	}<br> |
| define  | [**OPAE\_DEFAULT\_LOGLEVEL**](log_8h.md#define-opae_default_loglevel)  OPAE\_LOG\_ERROR<br> |
| define  | [**OPAE\_ERR**](log_8h.md#define-opae_err) (format, ...) <br> |
| define  | [**OPAE\_MSG**](log_8h.md#define-opae_msg) (format, ...) <br> |
| define  | [**\_\_SHORT\_FILE\_\_**](log_8h.md#define-__short_file__)  <br> |

## Public Types Documentation


### enum opae\_loglevel 

```C++
enum opae_loglevel {
    OPAE_LOG_ERROR = 0,
    OPAE_LOG_MESSAGE,
    OPAE_LOG_DEBUG
};
```



## Public Functions Documentation


### function opae\_print 

```C++
void opae_print (
    int loglevel,
    const char * fmt,
    ...
) 
```



## Macro Definition Documentation



### define OPAE\_DBG 

```C++
#define OPAE_DBG (
    format,
    ...
) {	}
```




### define OPAE\_DEFAULT\_LOGLEVEL 

```C++
#define OPAE_DEFAULT_LOGLEVEL OPAE_LOG_ERROR
```




### define OPAE\_ERR 

```C++
#define OPAE_ERR (
    format,
    ...
) opae_print ( OPAE_LOG_ERROR ,                                \
	"%s:%u:%s() **ERROR** : " format "\n",                    \
	__SHORT_FILE__, __LINE__, __func__, ##__VA_ARGS__)
```




### define OPAE\_MSG 

```C++
#define OPAE_MSG (
    format,
    ...
) opae_print ( OPAE_LOG_MESSAGE , "%s:%u:%s() : " format "\n", \
	__SHORT_FILE__, __LINE__, __func__, ##__VA_ARGS__)
```




### define \_\_SHORT\_FILE\_\_ 

```C++
#define __SHORT_FILE__ ({                                                     \
	const char *file = __FILE__;                           \
	const char *p = file;                                  \
	while (*p)                                             \
		++p;                                           \
	while ((p > file) && ('/' != *p) && ('\\' != *p))      \
		--p;                                           \
	if (p > file)                                          \
		++p;                                           \
	p;                                                     \
	})
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/log.h`