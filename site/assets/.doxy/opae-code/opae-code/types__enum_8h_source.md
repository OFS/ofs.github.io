
# File types\_enum.h

[**File List**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**types\_enum.h**](types__enum_8h.md)

[Go to the documentation of this file.](types__enum_8h.md) 

```C++

// Copyright(c) 2017-2022, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef __FPGA_TYPES_ENUM_H__
#define __FPGA_TYPES_ENUM_H__

typedef enum {
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
} fpga_result;

typedef enum {
    FPGA_EVENT_INTERRUPT = 0,   
    FPGA_EVENT_ERROR,           
    FPGA_EVENT_POWER_THERMAL    
} fpga_event_type;

/* TODO: consider adding lifecycle events in the future
 * to help with orchestration.  Need a complete specification
 * before including them in the API.  Proposed events:
 *  FPGA_EVENT_APPEAR
 *  FPGA_EVENT_DISAPPEAR
 *  FPGA_EVENT_CHANGE
 */

typedef enum {
    FPGA_ACCELERATOR_ASSIGNED = 0,
    FPGA_ACCELERATOR_UNASSIGNED
} fpga_accelerator_state;

typedef enum {
    FPGA_DEVICE = 0,
    FPGA_ACCELERATOR
} fpga_objtype;

typedef enum {
    FPGA_IFC_DFL = 0,
    FPGA_IFC_VFIO,
    FPGA_IFC_SIM_DFL,
    FPGA_IFC_SIM_VFIO,
    FPGA_IFC_UIO,
} fpga_interface;

enum fpga_buffer_flags {
    FPGA_BUF_PREALLOCATED = (1u << 0), 
    FPGA_BUF_QUIET = (1u << 1),        
    FPGA_BUF_READ_ONLY = (1u << 2)     
};

enum fpga_open_flags {
    FPGA_OPEN_SHARED = (1u << 0)
};

enum fpga_reconf_flags {
    FPGA_RECONF_FORCE = (1u << 0),
    FPGA_RECONF_SKIP_USRCLK = (1u << 1)
};

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

enum fpga_sysobject_type {
    FPGA_OBJECT_CONTAINER =
        (1u << 0), 
    FPGA_OBJECT_ATTRIBUTE =
        (1u << 1) 
};

enum fpga_metric_type {
    FPGA_METRIC_TYPE_POWER,             // Metric power
    FPGA_METRIC_TYPE_THERMAL,           // Metric Thermal
    FPGA_METRIC_TYPE_PERFORMANCE_CTR,   // Metric Performance counter
    FPGA_METRIC_TYPE_AFU,               // Metric AFU
    FPGA_METRIC_TYPE_UNKNOWN            // Unknown
};

enum fpga_metric_datatype {
    FPGA_METRIC_DATATYPE_INT,       // Metric datatype integer
    FPGA_METRIC_DATATYPE_FLOAT,     // Metric datatype float
    FPGA_METRIC_DATATYPE_DOUBLE,    // Metric datatype double
    FPGA_METRIC_DATATYPE_BOOL,      // Metric datatype bool
    FPGA_METRIC_DATATYPE_UNKNOWN    // Metric datatype unknown
};

#endif // __FPGA_TYPES_ENUM_H__

```