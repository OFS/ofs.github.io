
# File types.h

[**File List**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**types.h**](types_8h.md)

[Go to the documentation of this file.](types_8h.md) 

```C++

// Copyright(c) 2018-2022, Intel Corporation
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

#ifndef __FPGA_TYPES_H__
#define __FPGA_TYPES_H__

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <opae/types_enum.h>

typedef void *fpga_properties;

typedef void *fpga_token;

typedef void *fpga_handle;

typedef uint8_t fpga_guid[16];

typedef struct {
    uint8_t major;        
    uint8_t minor;        
    uint16_t patch;       
} fpga_version;

typedef void *fpga_event_handle;

#define FPGA_ERROR_NAME_MAX 64
struct fpga_error_info {
    char name[FPGA_ERROR_NAME_MAX];   
    bool can_clear;                   
};

typedef void *fpga_object;

#define FPGA_METRIC_STR_SIZE   256
typedef union {
    uint64_t   ivalue;  // Metric integer value
    double     dvalue;  // Metric double value
    float      fvalue;  // Metric float value
    bool       bvalue;  // Metric bool value
} metric_value;


typedef struct fpga_metric_info {
    uint64_t metric_num;                         // Metric index num
    fpga_guid metric_guid;                       // Metric guid
    char qualifier_name[FPGA_METRIC_STR_SIZE];   // Metric full name
    char group_name[FPGA_METRIC_STR_SIZE];       // Metric group name
    char metric_name[FPGA_METRIC_STR_SIZE];      // Metric name
    char metric_units[FPGA_METRIC_STR_SIZE];     // Metric units
    enum fpga_metric_datatype metric_datatype;   // Metric data type
    enum fpga_metric_type metric_type;           // Metric group type
} fpga_metric_info;

typedef struct fpga_metric {
    uint64_t metric_num;    // Metric index num
    metric_value value;     // Metric value
    bool isvalid;           // Metric value is valid
} fpga_metric;


typedef struct threshold {
    char threshold_name[FPGA_METRIC_STR_SIZE]; // Threshold name
    uint32_t is_valid;                         // Threshold is valid
    double value;                              // Threshold value
} threshold;

typedef struct metric_threshold {
    char metric_name[FPGA_METRIC_STR_SIZE];        // Metric Threshold name
    threshold upper_nr_threshold;                  // Upper Non-Recoverable Threshold
    threshold upper_c_threshold;                   // Upper Critical Threshold
    threshold upper_nc_threshold;                  // Upper Non-Critical Threshold
    threshold lower_nr_threshold;                  // Lower Non-Recoverable Threshold
    threshold lower_c_threshold;                   // Lower Critical Threshold
    threshold lower_nc_threshold;                  // Lower Non-Critical Threshold
    threshold hysteresis;                          // Hysteresis
} metric_threshold;

typedef struct _fpga_token_header {
    uint64_t magic;
    uint16_t vendor_id;
    uint16_t device_id;
    uint16_t segment;
    uint8_t bus;
    uint8_t device;
    uint8_t function;
    fpga_interface interface;
    fpga_objtype objtype;
    uint64_t object_id;
    fpga_guid guid;
    uint16_t subsystem_vendor_id;
    uint16_t subsystem_device_id;
} fpga_token_header;

#define fpga_is_parent_child(__parent_hdr, __child_hdr) \
(((__parent_hdr)->objtype == FPGA_DEVICE) && \
 ((__child_hdr)->objtype == FPGA_ACCELERATOR) && \
 ((__parent_hdr)->segment == (__child_hdr)->segment) && \
 ((__parent_hdr)->bus == (__child_hdr)->bus) && \
 ((__parent_hdr)->device == (__child_hdr)->device))

#endif // __FPGA_TYPES_H__

```