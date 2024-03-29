
# File uio.h

[**File List**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**uio.h**](uio_8h.md)

[Go to the documentation of this file.](uio_8h.md) 

```C++

// Copyright(c) 2020, Intel Corporation
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

#ifndef __OPAE_UIO_H__
#define __OPAE_UIO_H__

#include <stdio.h>
#include <stdint.h>

#define OPAE_UIO_PATH_MAX 256

struct opae_uio_device_region {
    uint32_t region_index;
    uint8_t *region_ptr;
    size_t region_page_offset;
    size_t region_size;
    struct opae_uio_device_region *next;
};

struct opae_uio {
    char device_path[OPAE_UIO_PATH_MAX];
    int device_fd;
    struct opae_uio_device_region *regions;
};


#ifdef __cplusplus
extern "C" {
#endif

int opae_uio_open(struct opae_uio *u,
          const char *dfl_device);

int opae_uio_region_get(struct opae_uio *u,
            uint32_t index,
            uint8_t **ptr,
            size_t *size);

void opae_uio_close(struct opae_uio *u);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus

#endif // __OPAE_UIO_H__

```