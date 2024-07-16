
# File types\_enum.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**types\_enum.h**](types__enum_8h.md)

[Go to the source code of this file.](types__enum_8h_source.md)

_Definitions of enumerated types for the OPAE C API._ [More...](#detailed-description)












## Public Types

| Type | Name |
| ---: | :--- |
| enum  | [**fpga\_accelerator\_state**](#enum-fpga_accelerator_state)  <br>_accelerator state_  |
| enum  | [**fpga\_buffer\_flags**](#enum-fpga_buffer_flags)  <br>_Buffer flags._  |
| enum  | [**fpga\_event\_type**](#enum-fpga_event_type)  <br>_FPGA events._  |
| enum  | [**fpga\_interface**](#enum-fpga_interface)  <br>_OPAE plugin interface._  |
| enum  | [**fpga\_metric\_datatype**](#enum-fpga_metric_datatype)  <br>_Metrics data type._  |
| enum  | [**fpga\_metric\_type**](#enum-fpga_metric_type)  <br>_fpga metrics types opae defines power,thermal, performance counter and afu metric types_  |
| enum  | [**fpga\_objtype**](#enum-fpga_objtype)  <br>_OPAE FPGA resources (objects)_  |
| enum  | [**fpga\_open\_flags**](#enum-fpga_open_flags)  <br>_Open flags._  |
| enum  | [**fpga\_reconf\_flags**](#enum-fpga_reconf_flags)  <br>_Reconfiguration flags._  |
| enum  | [**fpga\_result**](#enum-fpga_result)  <br>_OPAE C API function return codes._  |
| enum  | [**fpga\_sysobject\_flags**](#enum-fpga_sysobject_flags)  <br> |
| enum  | [**fpga\_sysobject\_type**](#enum-fpga_sysobject_type)  <br> |












# Detailed Description


This file defines return and error codes, event and object types, states, and flags as used or reported by OPAE C API functions. 


    
## Public Types Documentation


### enum fpga\_accelerator\_state 

```C++
enum fpga_accelerator_state {
    FPGA_ACCELERATOR_ASSIGNED = 0,
    FPGA_ACCELERATOR_UNASSIGNED
};
```




### enum fpga\_buffer\_flags 

_Buffer flags._ 
```C++
enum fpga_buffer_flags {
    FPGA_BUF_PREALLOCATED = (1u << 0),
    FPGA_BUF_QUIET = (1u << 1),
    FPGA_BUF_READ_ONLY = (1u << 2)
};
```



These flags can be passed to the [**fpgaPrepareBuffer()**](buffer_8h.md#function-fpgapreparebuffer) function. 


        

### enum fpga\_event\_type 

_FPGA events._ 
```C++
enum fpga_event_type {
    FPGA_EVENT_INTERRUPT = 0,
    FPGA_EVENT_ERROR,
    FPGA_EVENT_POWER_THERMAL
};
```



OPAE currently defines the following event types that applications can register for. Note that not all FPGA resources and target platforms may support all event types. 


        

### enum fpga\_interface 

_OPAE plugin interface._ 
```C++
enum fpga_interface {
    FPGA_IFC_DFL = 0,
    FPGA_IFC_VFIO,
    FPGA_IFC_SIM_DFL,
    FPGA_IFC_SIM_VFIO,
    FPGA_IFC_UIO
};
```



These are the supported plugin interfaces. 


        

### enum fpga\_metric\_datatype 

```C++
enum fpga_metric_datatype {
    FPGA_METRIC_DATATYPE_INT,
    FPGA_METRIC_DATATYPE_FLOAT,
    FPGA_METRIC_DATATYPE_DOUBLE,
    FPGA_METRIC_DATATYPE_BOOL,
    FPGA_METRIC_DATATYPE_UNKNOWN
};
```




### enum fpga\_metric\_type 

```C++
enum fpga_metric_type {
    FPGA_METRIC_TYPE_POWER,
    FPGA_METRIC_TYPE_THERMAL,
    FPGA_METRIC_TYPE_PERFORMANCE_CTR,
    FPGA_METRIC_TYPE_AFU,
    FPGA_METRIC_TYPE_UNKNOWN
};
```




### enum fpga\_objtype 

_OPAE FPGA resources (objects)_ 
```C++
enum fpga_objtype {
    FPGA_DEVICE = 0,
    FPGA_ACCELERATOR
};
```



These are the FPGA resources currently supported by the OPAE object model. 


        

### enum fpga\_open\_flags 

_Open flags._ 
```C++
enum fpga_open_flags {
    FPGA_OPEN_SHARED = (1u << 0)
};
```



These flags can be passed to the [**fpgaOpen()**](access_8h.md#function-fpgaopen) function. 


        

### enum fpga\_reconf\_flags 

_Reconfiguration flags._ 
```C++
enum fpga_reconf_flags {
    FPGA_RECONF_FORCE = (1u << 0),
    FPGA_RECONF_SKIP_USRCLK = (1u << 1)
};
```



These flags can be passed to the [**fpgaReconfigureSlot()**](manage_8h.md#function-fpgareconfigureslot) function. 


        

### enum fpga\_result 

_OPAE C API function return codes._ 
```C++
enum fpga_result {
    FPGA_OK = 0,
    FPGA_INVALID_PARAM,
    FPGA_BUSY,
    FPGA_EXCEPTION,
    FPGA_NOT_FOUND,
    FPGA_NO_MEMORY,
    FPGA_NOT_SUPPORTED,
    FPGA_NO_DRIVER,
    FPGA_NO_DAEMON,
    FPGA_NO_ACCESS,
    FPGA_RECONF_ERROR
};
```



Every public API function exported by the OPAE C library will return one of these codes. Usually, FPGA\_OK denotes successful completion of the requested operation, while any return code _other_ than FPGA\_OK indicates an error or other deviation from the expected behavior. Users of the OPAE C API should always check the return codes of the APIs they call, and not use output parameters of functions that did not execute successfully.


The [**fpgaErrStr()**](utils_8h.md#function-fpgaerrstr) function converts error codes into printable messages.


OPAE also has a logging mechanism that allows a developer to get more information about why a particular call failed with a specific message. If enabled, any function that returns an error code different from FPGA\_OK will also print out a message with further details. This mechanism can be enabled by setting the environment variable `LIBOPAE_LOG` to 1 before running the respective application. 


        

### enum fpga\_sysobject\_flags 

```C++
enum fpga_sysobject_flags {
    FPGA_OBJECT_SYNC = (1u << 0),
    FPGA_OBJECT_GLOB = (1u << 1),
    FPGA_OBJECT_RAW =
		(1u << 2),
    FPGA_OBJECT_RECURSE_ONE =
		(1u
		 << 3),
    FPGA_OBJECT_RECURSE_ALL =
		(1u
		 << 4)
};
```




### enum fpga\_sysobject\_type 

```C++
enum fpga_sysobject_type {
    FPGA_OBJECT_CONTAINER =
		(1u << 0),
    FPGA_OBJECT_ATTRIBUTE =
		(1u << 1)
};
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/types_enum.h`