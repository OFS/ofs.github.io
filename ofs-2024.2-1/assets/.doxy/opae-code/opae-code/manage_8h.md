
# File manage.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**manage.h**](manage_8h.md)

[Go to the source code of this file.](manage_8h_source.md)

_Functions for managing FPGA configurations._ [More...](#detailed-description)

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaAssignPortToInterface**](#function-fpgaassignporttointerface) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) fpga, uint32\_t interface\_num, uint32\_t slot\_num, int flags) <br>_Assign Port to a host interface._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaAssignToInterface**](#function-fpgaassigntointerface) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) fpga, [**fpga\_token**](types_8h.md#typedef-fpga_token) accelerator, uint32\_t host\_interface, int flags) <br>_Assign an accelerator to a host interface._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReconfigureSlot**](#function-fpgareconfigureslot) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) fpga, uint32\_t slot, const uint8\_t \* bitstream, size\_t bitstream\_len, int flags) <br>_Reconfigure a slot._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaReleaseFromInterface**](#function-fpgareleasefrominterface) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) fpga, [**fpga\_token**](types_8h.md#typedef-fpga_token) accelerator) <br>_Unassign a previously assigned accelerator._  |








# Detailed Description


FPGA accelerators can be reprogrammed at run time by providing new partial bitstreams ("green bitstreams"). This file defines API functions for programming green bitstreams as well as for assigning accelerators to host interfaces for more complex deployment setups, such as virtualized systems. 


    
## Public Functions Documentation


### function fpgaAssignPortToInterface 

_Assign Port to a host interface._ 
```C++
fpga_result fpgaAssignPortToInterface (
    fpga_handle fpga,
    uint32_t interface_num,
    uint32_t slot_num,
    int flags
) 
```



This function assign Port to a host interface for subsequent use. Only Port that have been assigned to a host interface can be opened by [**fpgaOpen()**](access_8h.md#function-fpgaopen).




**Parameters:**


* `fpga` Handle to an FPGA object previously opened that both the host interface and the slot belong to 
* `interface_num` Host interface number 
* `slot_num` Slot number 
* `flags` Flags (to be defined) 



**Returns:**

FPGA\_OK on success FPGA\_INVALID\_PARAM if input parameter combination is not valid. FPGA\_EXCEPTION if an exception occcurred accessing the `fpga` handle. FPGA\_NOT\_SUPPORTED if driver does not support assignment. 





        

### function fpgaAssignToInterface 

_Assign an accelerator to a host interface._ 
```C++
fpga_result fpgaAssignToInterface (
    fpga_handle fpga,
    fpga_token accelerator,
    uint32_t host_interface,
    int flags
) 
```



This function assigns an accelerator to a host interface for subsequent use. Only accelerators that have been assigned to a host interface can be opened by [**fpgaOpen()**](access_8h.md#function-fpgaopen).




**Note:**

This function is currently not supported.




**Parameters:**


* `fpga` Handle to an FPGA object previously opened that both the host interface and the accelerator belong to 
* `accelerator` accelerator to assign 
* `host_interface` Host interface to assign accelerator to 
* `flags` Flags (to be defined) 



**Returns:**

FPGA\_OK on success 





        

### function fpgaReconfigureSlot 

_Reconfigure a slot._ 
```C++
fpga_result fpgaReconfigureSlot (
    fpga_handle fpga,
    uint32_t slot,
    const uint8_t * bitstream,
    size_t bitstream_len,
    int flags
) 
```



Sends a green bitstream file to an FPGA to reconfigure a specific slot. This call, if successful, will overwrite the currently programmed AFU in that slot with the AFU in the provided bitstream.


As part of the reconfiguration flow, all accelerators associated with this slot will be unassigned and reset.




**Parameters:**


* `fpga` Handle to an FPGA object previously opened 
* `slot` Token identifying the slot to reconfigure 
* `bitstream` Pointer to memory holding the bitstream 
* `bitstream_len` Length of the bitstream in bytes 
* `flags` Flags that control behavior of reconfiguration. Value of 0 indicates no flags. FPGA\_RECONF\_FORCE indicates that the bitstream is programmed into the slot without checking if the resource is currently in use. 



**Returns:**

FPGA\_OK on success. FPGA\_INVALID\_PARAM if the provided parameters are not valid. FPGA\_EXCEPTION if an internal error occurred accessing the handle or while sending the bitstream data to the driver. FPGA\_BUSY if the accelerator for the given slot is in use. FPGA\_RECONF\_ERROR on errors reported by the driver (such as CRC or protocol errors).




**Note:**

By default, fpgaReconfigureSlot will not allow reconfiguring a slot with an accelerator in use. Add the flag FPGA\_RECONF\_FORCE to force reconfiguration without checking for accelerators in use. 





        

### function fpgaReleaseFromInterface 

_Unassign a previously assigned accelerator._ 
```C++
fpga_result fpgaReleaseFromInterface (
    fpga_handle fpga,
    fpga_token accelerator
) 
```



This function removes the assignment of an accelerator to an host interface (e.g. to be later assigned to a different host interface). As a consequence, the accelerator referred to by token 'accelerator' will be reset during the course of this function.




**Note:**

This function is currently not supported.




**Parameters:**


* `fpga` Handle to an FPGA object previously opened that both the host interface and the accelerator belong to 
* `accelerator` accelerator to unassign/release 



**Returns:**

FPGA\_OK on success 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/manage.h`