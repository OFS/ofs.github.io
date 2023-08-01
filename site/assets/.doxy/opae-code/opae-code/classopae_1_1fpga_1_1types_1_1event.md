
# Class opae::fpga::types::event



[**ClassList**](annotated.md) **>** [**opae**](namespaceopae.md) **>** [**fpga**](namespaceopae_1_1fpga.md) **>** [**types**](namespaceopae_1_1fpga_1_1types.md) **>** [**event**](classopae_1_1fpga_1_1types_1_1event.md)



_Wraps fpga event routines in OPAE C._ 

* `#include <events.h>`










## Classes

| Type | Name |
| ---: | :--- |
| struct | [**type\_t**](structopae_1_1fpga_1_1types_1_1event_1_1type__t.md) <br>_C++ struct that is interchangeable with fpga\_event\_type enum._  |

## Public Types

| Type | Name |
| ---: | :--- |
| typedef std::shared\_ptr&lt; [**event**](classopae_1_1fpga_1_1types_1_1event.md) &gt; | [**ptr\_t**](#typedef-ptr_t)  <br> |




## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_event\_handle**](types_8h.md#typedef-fpga_event_handle) | [**get**](#function-get) () <br>_Get the fpga\_event\_handle contained in this object._  |
|   | [**operator fpga\_event\_handle**](#function-operator-fpga_event_handle) () <br>_Coversion operator for converting to fpga\_event\_handle objects._  |
|  int | [**os\_object**](#function-os_object) () const<br>_Get OS Object from the event object._  |
| virtual  | [**~event**](#function-event) () <br>_Destroy event and associated resources._  |

## Public Static Functions

| Type | Name |
| ---: | :--- |
|  [**event::ptr\_t**](classopae_1_1fpga_1_1types_1_1event.md#typedef-ptr_t) | [**register\_event**](#function-register_event) ([**handle::ptr\_t**](classopae_1_1fpga_1_1types_1_1handle.md#typedef-ptr_t) h, [**event::type\_t**](structopae_1_1fpga_1_1types_1_1event_1_1type__t.md) t, int flags=0) <br>_Factory function to create event objects._  |







## Public Types Documentation


### typedef ptr\_t 

```C++
typedef std::shared_ptr<event> opae::fpga::types::event::ptr_t;
```



## Public Functions Documentation


### function get 

_Get the fpga\_event\_handle contained in this object._ 
```C++
inline fpga_event_handle opae::fpga::types::event::get () 
```





**Returns:**

The fpga\_event\_handle contained in this object 





        

### function operator fpga\_event\_handle 

_Coversion operator for converting to fpga\_event\_handle objects._ 
```C++
opae::fpga::types::event::operator fpga_event_handle () 
```





**Returns:**

The fpga\_event\_handle contained in this object 





        

### function os\_object 

_Get OS Object from the event object._ 
```C++
int opae::fpga::types::event::os_object () const
```



Get an OS specific object from the event which can be used to subscribe for events. On Linux, the object corresponds to a file descriptor that can be used with select/poll/epoll calls.




**Returns:**

An integer object representing the OS object 





        

### function ~event 

```C++
virtual opae::fpga::types::event::~event () 
```



## Public Static Functions Documentation


### function register\_event 

_Factory function to create event objects._ 
```C++
static event::ptr_t opae::fpga::types::event::register_event (
    handle::ptr_t h,
    event::type_t t,
    int flags=0
) 
```





**Parameters:**


* `h` A shared ptr of a resource handle 
* `t` The resource type 
* `flags` Event registration flags passed on to fpgaRegisterEvent



**Returns:**

A shared ptr to an event object 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/cxx/core/events.h`