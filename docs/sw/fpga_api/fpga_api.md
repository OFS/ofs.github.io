# OPAE C API Reference

The reference documentation for the OPAE C API is grouped into the following sections:

- [Types](#id1)
  - [types.h](#id2)
  - [types_enum.h](#id3)
- [Enumeration API](#id4)
  - [enum.h](#id5)
  - [properties.h](#id6)
- [Access API](#id7)
  - [access.h](#id8)
- [Event API](#id9)
  - [event.h](#id10)
- [MMIO and Shared Memory APIs](#id11)
  - [mmio.h](#id12)
  - [buffer.h](#id13)
  - [umsg.h](#id14)
- [Management API](#id15)
  - [manage.h](#id16)
- [Metrics API](#id17)
  - [metrics.h](#id18)
- [SysObject](#id19)
  - [sysobject.h](#id20)
- [Utilities](#id21)
  - [utils.h](#id22)
- [Samples](#id23)
  - [hello_fpga.c](#id24)
  - [hello_events.c](#id25)



## <a name="id1">Types</a>

The OPAE C API defines a number of types; most prominent are the types fpga_token, fpga_handle, and fpga_properties. All regular types are defined in [types.h](#id2), while the values of enumeration types are defined in [types_enum.h](#id3).



### <a name="id2" href="../../../opae-code/types_8h/index.html">types.h</a>

[types.h](../../../opae-code/types_8h/index.html)

### <a name="id3" href="../../../opae-code/types__enum_8h/index.html">types_enum.h</a>

[types_enum.h](../../../opae-code/types__enum_8h/index.html)



## <a name="id4">Enumeration API</a>

The OPAE enumeration API allows selective discovery of FPGA resources. When enumerating resources, a list of filter criteria can be passed to the respective function to select a subset of all resources in the system. The fpgaEnumerate() function itself then returns a list of fpga_tokens denoting resources, which can be used in subsequent API calls.

Filter criteria are specified using one or more fpga_properties object. These objects need to be created using fpgaGetProperties() (defined in <opae/properties/h>) before being passed to fpgaEnumerate(). Individual attributes of an fpga_properties object are set using specific accessors, which are also defined in <opae/properties.h>.



### <a name="id5" href="../../../opae-code/enum_8h/index.html">enum.h</a>

[enum.h](../../../opae-code/enum_8h/index.html)



### <a name="id6" href="../../../opae-code/properties_8h/index.html">properties.h</a>

[properties.h](../../../opae-code/properties_8h/index.html)



## <a name="id7">Access API</a>

The access API provides functions for opening and closing FPGA resources. Opening a resource yields an fpga_handle, which denotes ownership and can be used in subsequent API calls to interact with a specific resource. Ownership can be exclusive or shared.



### <a name="id8" href="../../../opae-code/access_8h/index.html">access.h</a>

[access.h](../../../opae-code/access_8h/index.html)



## <a name="id9">Event API</a>

The event API provides functions and types for handling asynchronous events such as errors or accelerator interrupts.

To natively support asynchronous event, the driver for the FPGA platform needs to support events natively (in which case the OPAE C library will register the event directly with the driver). For some platforms that do not support interrupt-driven event delivery, you need to run the FPGA Daemon (fpgad) to enable asynchronous OPAE events. fpgad will act as a proxy for the application and deliver asynchronous notifications for registered events.



### <a name="id10" href="../../../opae-code/event_8h/index.html">event.h</a>

[event.h](../../../opae-code/event_8h/index.html)



## <a name="id11">MMIO and Shared Memory APIs</a>

These APIs feature functions for mapping and accessing control registers through memory-mapped IO (mmio.h), allocating and sharing system memory buffers with an accelerator (buffer.h), and using low-latency notifications (umsg.h).



### <a name="id12" href="../../../opae-code/mmio_8h/index.html">mmio.h</a>

[mmio.h](../../../opae-code/mmio_8h/index.html)



### <a name="id13" href="../../../opae-code/buffer_8h/index.html">buffer.h</a>

[buffer.h](../../../opae-code/buffer_8h/index.html)



### <a name="id14" href="../../../opae-code/umsg_8h/index.html">umsg.h</a>

[umsg.h](../../../opae-code/umsg_8h/index.html)



## <a name="id15">Management API</a>

The management APIs define functions for reconfiguring an FPGA (writing new partial bitstreams) as well as assigning accelerators to host interfaces.



### <a name="id16" href="../../../opae-code/manage_8h/index.html">manage.h</a>

[manage.h](../../../opae-code/manage_8h/index.html)



## <a name="id17">Metrics API</a>

The metrics APIs define functions for discovery/enumeration of metrics information and reading metrics values.



### <a name="id18" href="../../../opae-code/metrics_8h/index.html">metrics.h</a>

[metrics.h](../../../opae-code/metrics_8h/index.html)



## <a name="id19" >SysObject</a>

The SysObject API can be used to get system objects by name. Names used with the SysObject API are driver-specific and may not be compatible across plugins and/or drivers. For example, SysObject names used with the xfpga plugin will apply to the OPAE Linux Kernel driver and refer to sysfs nodes under the sysfs tree for the resource used with the SysObject API.



### <a name="id20" href="../../../opae-code/sysobject_8h/index.html">sysobject.h</a>

[sysobject.h](../../../opae-code/sysobject_8h/index.html)



## <a name="id21">Utilities</a>

Functions for mapping fpga_result values to meaningful error strings are provided by the utilities API.



### <a name="id22" href="../../../opae-code/utils_8h/index.html">utils.h</a>

[utils.h](../../../opae-code/utils_8h/index.html)



## <a name="id23">Samples</a>

Code samples demonstrate how to use OPAE C API.



### <a name="id24" href="../../../opae-code/hello__fpga_8c/index.html">hello_fpga.c</a>

[hello_fpga.c](../../../opae-code/hello__fpga_8c/index.html)



### <a name="id25" href="../../../opae-code/hello__events_8c/index.html">hello_events.c</a>

[hello_events.c](../../../opae-code/hello__events_8c/index.html)
