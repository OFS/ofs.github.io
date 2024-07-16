# **AFU Host Software Developer Guide**

Last updated: **July 16, 2024** 

The host application is used to control the AFU and manage data transfer between the host and the AFU.   The host channel provides two interfaces between the host and AFU, MMIO and Host Memory.   MMIO is used to read/write the CSR interface of the AFU, and the Host Memory interface is used to share data between the AFU and Host user space. 
![](/ofs-2024.2-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/images/SW_Model.png)


## **1. Host Application Flow**
The OPAE SDK provides a library with routines to setup and manage the AFU.  The basic host application flow is as follows:

![](/ofs-2024.2-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/images/SW_Flow.png)

When creating the host application, the following OPAE Header Files are required:
- opae/fpga.h  - For the OPAE C API library 
- afu_json_info.h - For AFU information including UUID 

```sh
// Headers needed for example code
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
// For uuid_parse() to convert UUID string into binary
#include <uuid/uuid.h>

// OPAE C API
#include <opae/fpga.h>

// State from the AFU's JSON file, extracted using OPAE's afu_json_mgr script
#include "afu_json_info.h"
```

### **1.1. Find and connect to AFU**

Here is an example function which searches for the AFU based on its UUID.  If there is a match, it will connect to the AFU.   It will also check to see if the AFU is being run in hardware or simulation (ASE).

```sh
// Set as global, to allow MMIO routines to access in ASE mode
static fpga_handle s_accel_handle;

//
// Search for an accelerator matching the requested UUID and connect to it.
// Check to see if running in ASE-Simulation mode
//
static fpga_handle connect_to_accel(const char *accel_uuid, bool *is_ase_sim)
{
    fpga_properties filter = NULL;
    fpga_guid guid;
    fpga_token accel_token;
    uint32_t num_matches;
    fpga_handle accel_handle;
    fpga_result r;

    // Don't print verbose messages in ASE by default
    setenv("ASE_LOG", "0", 0);
    *is_ase_sim = NULL;

    // Set up a filter that will search for an accelerator
    fpgaGetProperties(NULL, &filter);
    fpgaPropertiesSetObjectType(filter, FPGA_ACCELERATOR);

    // Convert UUID string into binary
    uuid_parse(accel_uuid, guid);
    // Add the desired UUID to the filter
    fpgaPropertiesSetGUID(filter, guid);

    // Do the search across the available FPGA contexts
    num_matches = 1;
    fpgaEnumerate(&filter, 1, &accel_token, 1, &num_matches);

    // Not needed anymore
    fpgaDestroyProperties(&filter);

    if (num_matches < 1)
    {
        fprintf(stderr, "Accelerator %s not found!\n", accel_uuid);
        return 0;
    }

    // Acquire ownership of accelerator
    r = fpgaOpen(accel_token, &accel_handle, 0);
    assert(FPGA_OK == r);

    // While the token is available, check whether it is for HW or for ASE simulation.
    fpga_properties accel_props;
    uint16_t vendor_id, dev_id;
    fpgaGetProperties(accel_token, &accel_props);
    fpgaPropertiesGetVendorID(accel_props, &vendor_id);
    fpgaPropertiesGetDeviceID(accel_props, &dev_id);
    *is_ase_sim = (vendor_id == 0x8086) && (dev_id == 0xa5e);

    // Done with token
    fpgaDestroyToken(&accel_token);

    return accel_handle;
}
```

In main(), the function is called updating the accel_handle and ASE status.   AFU_ACCEL_UUID is provided by afu_json_info.h created for the Accelerator Descriptor File:
```sh
    bool is_ase_sim;
    
    // Find and connect to the accelerator(s)
    s_accel_handle = connect_to_accel(AFU_ACCEL_UUID, &is_ase_sim);
    if (NULL == s_accel_handle) return 0;
```

### **1.2. Map MMIO (optional)**
Mapping the MMIO provides higher performance on the MMIO access versus the standard OPAE MMIO functions.  fpgaMapMMIO() is used to return a pointer to the specified MMIO space of the target AFU in process virtual memory.  When running in ASE mode, MMIO mapping isn't supported and the MMIO pointer is set to NULL.   

```sh
static volatile uint64_t *s_mmio_buf;

fpga_result r;
    if (is_ase_sim)
    {
        printf("Running in ASE Mode");
		s_mmio_buf = NULL;
    }
    else
    {
        uint64_t *tmp_ptr;
        r = fpgaMapMMIO(s_accel_handle, 0, &tmp_ptr);
        assert(FPGA_OK == r);
        s_mmio_buf = tmp_ptr;
    }

```

The below example functions provide MMIO Reads/Writes.   When running in hardware the functions will use s_mmio_buf for accessing.  When running in ASE mode, indicated by s_mmio_buf being set to NULL, fpgaReadMMIO64() fpgaWriteMMIO64() will be used.
```sh
//
// Read a 64 bit CSR. When a pointer to CSR buffer is available, read directly.
// Direct reads can be significantly faster.
// If s_mmio_buf is NULL, in ASE mode and need to use OPAE MMIO functions.
//
static inline uint64_t readMMIO64(uint32_t idx)
{
    if (s_mmio_buf)
    {
        return s_mmio_buf[idx];
    }
    else
    {
        fpga_result r;
        uint64_t v;
        r = fpgaReadMMIO64(s_accel_handle, 0, 8 * idx, &v);
        assert(FPGA_OK == r);
        return v;
    }
}

//
// Write a 64 bit CSR. When a pointer to CSR buffer is available, write directly.
//
static inline void writeMMIO64(uint32_t idx, uint64_t v)
{
    if (s_mmio_buf)
    {
        s_mmio_buf[idx] = v;
    }
    else
    {
        fpgaWriteMMIO64(s_accel_handle, 0, 8 * idx, v);
    }
}
```

### **1.3. Allocate Shared Memory Buffers**
The below example function creates the shared buffers and provides the physical address for AFU access.
```sh
//
// Allocate a buffer in I/O memory, shared with the FPGA.
//
static volatile void* alloc_buffer(fpga_handle accel_handle,
                                   ssize_t size,
                                   uint64_t *wsid,
                                   uint64_t *io_addr)
{
    fpga_result r;
    volatile void* buf;

    r = fpgaPrepareBuffer(accel_handle, size, (void*)&buf, wsid, 0);
    if (FPGA_OK != r) return NULL;

    // Get the physical address of the buffer in the accelerator
    r = fpgaGetIOAddress(accel_handle, *wsid, io_addr);
    assert(FPGA_OK == r);

    return buf;
}
```

In main(), define the buffers and use the above function to allocate the shared buffers.   OPAE supports multiple buffers, and the number of buffers is design dependent.  Buffers over 4KB require hugepage support on the host.   The buffer address needs to be passed to the AFU over MMIO, for the AFU to correctly access the buffer.
```sh
    #define BUF_SIZE_IN_BYTES 16384

    volatile unsigned char *src_buf;
    uint64_t src_wsid;
    uint64_t src_pa;
    
    volatile unsigned char *dst_buf;
    uint64_t dst_wsid;
    uint64_t dst_pa;


    src_buf = alloc_buffer(s_accel_handle, BUF_SIZE_IN_BYTES, &src_wsid, &src_pa);
    assert(NULL != src_buf);

    dst_buf = alloc_buffer(s_accel_handle, BUF_SIZE_IN_BYTES, &dst_wsid, &dst_pa);
    assert(NULL != dst_buf);

```

### **1.4. Perform Acceleration**
The host application interaction is AFU dependent.  Generally, the MMIO interface will be used to setup and control the AFU.   While the shared buffers are used to pass data between the host and AFU.   Below is an example of setting up the AFU, writing the buffer and retrieving the results from the AFU.
```sh
// Loading source buffer with walking ones
for(i=0; i < BUF_SIZE_IN_BYTES; i++)
{
   src_buf[i] = 1 << (i & 0x7); // walking ones
}
// Send AFU buffer addresses and size 
// register addresses are based on the AFU CSR interface
writeMMIO64(8, src_pa);
writeMMIO64(9, dst_pa);
writeMMIO64(10, buf_size);

// Start Acceleration
writeMMIO64(11, 1);

// Wait for AFU to complete acceleration
while(!readMMIO64(12))
   ;

// Read destination buffer and print output
printf("output: ");
for(i=0; i < BUF_SIZE_IN_BYTES; i++)
{
   printf("%d ", dst_buf[i]);
}
```

### **1.5. Cleanup**
When the acceleration is complete, the host application should release the shared buffers and release ownership of the AFU.
```sh
    // Release shared buffers
    fpgaReleaseBuffer(s_accel_handle, src_wsid);
    fpgaReleaseBuffer(s_accel_handle, dst_wsid);   

    // Release ownership of accelerator
    fpgaClose(s_accel_handle);
```

## **2. Building the Host Application**
A Makefile is used to build the host application.   Below is an example Makefile from the [examples AFU] repo with the following updated:

- Path to common_include.mk (from examples-afu)
- TEST name
- Source files: SRCS
- Path to .json file (relative to Makefile directory)

Makefile:
```sh
# Path to examples-afu/tutorial/afu_types/01_pim_ifc/common/sw/common_include.mk
include ../../common/sw/common_include.mk

# Primary test name
TEST = example_afu

# Build directory
OBJDIR = obj
CFLAGS += -I./$(OBJDIR)
CPPFLAGS += -I./$(OBJDIR)

# Files and folders
SRCS = $(TEST).c
OBJS = $(addprefix $(OBJDIR)/,$(patsubst %.c,%.o,$(SRCS)))

all: $(TEST)

# AFU info from JSON file, including AFU UUID
AFU_JSON_INFO = $(OBJDIR)/afu_json_info.h
$(AFU_JSON_INFO): ../hw/rtl/$(TEST).json | objdir
	afu_json_mgr json-info --afu-json=$^ --c-hdr=$@
$(OBJS): $(AFU_JSON_INFO)

$(TEST): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(FPGA_LIBS) -lrt -pthread

$(OBJDIR)/%.o: %.c | objdir
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(TEST) $(OBJDIR)

objdir:
	@mkdir -p $(OBJDIR)

.PHONY: all clean
```

## **3. Running the Host Application**
To run the host application, you will need to:

- Load AFU onto the FIM
- Create VF's
- Bind VF's using the OPAE Drivers
- Run application

See the associated AFU Developer Guide for details.

<!-- include ./docs/hw/doc_modules/links.md -->

## Notices & Disclaimers

Intel<sup>&reg;</sup> technologies may require enabled hardware, software or service activation.
No product or component can be absolutely secure. 
Performance varies by use, configuration and other factors.
Your costs and results may vary. 
You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Intel products described herein. You agree to grant Intel a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein.
No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document.
The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications.  Current characterized errata are available on request.
Intel disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade.
You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. 
<sup>&copy;</sup> Intel Corporation.  Intel, the Intel logo, and other Intel marks are trademarks of Intel Corporation or its subsidiaries.  Other names and brands may be claimed as the property of others. 

OpenCL and the OpenCL logo are trademarks of Apple Inc. used by permission of the Khronos Group™. 
