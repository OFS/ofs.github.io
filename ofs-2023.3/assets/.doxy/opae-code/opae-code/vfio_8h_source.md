
# File vfio.h

[**File List**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**vfio.h**](vfio_8h.md)

[Go to the documentation of this file.](vfio_8h.md) 

```C++

// Copyright(c) 2020-2023, Intel Corporation
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

#ifndef __OPAE_VFIO_H__
#define __OPAE_VFIO_H__

#include <stdio.h>
#include <stdint.h>
#include <pthread.h>

#include <linux/vfio.h>
#include <opae/mem_alloc.h>
#include <opae/hash_map.h>

struct opae_vfio_iova_range {
    uint64_t start;             
    uint64_t end;               
    struct opae_vfio_iova_range *next;  
};

struct opae_vfio_group {
    char *group_device; 
    int group_fd;       
};

struct opae_vfio_sparse_info {
    uint32_t index;             
    uint32_t offset;            
    uint32_t size;              
    uint8_t *ptr;               
    struct opae_vfio_sparse_info *next; 
};

struct opae_vfio_device_region {
    uint32_t region_index;              
    uint8_t *region_ptr;                
    size_t region_size;             
    struct opae_vfio_sparse_info *region_sparse;    
    struct opae_vfio_device_region *next;       
};

struct opae_vfio_device_irq {
    uint32_t flags;             
    uint32_t index;             
    uint32_t count;             
    int32_t *event_fds;         
    int32_t *masks;             
    struct opae_vfio_device_irq *next;  
};

struct opae_vfio_device {
    int device_fd;                  
    uint64_t device_config_offset;          
    uint32_t device_num_regions;            
    struct opae_vfio_device_region *regions;    
    uint32_t device_num_irqs;           
    struct opae_vfio_device_irq *irqs;      
};

struct opae_vfio_buffer {
    uint8_t *buffer_ptr;        
    size_t buffer_size;     
    uint64_t buffer_iova;       
    int flags;          
};

struct opae_vfio {
    pthread_mutex_t lock;               
    char *cont_device;              
    char *cont_pciaddr;             
    int cont_fd;                    
    struct opae_vfio_iova_range *cont_ranges;   
    struct mem_alloc iova_alloc;            
    struct opae_vfio_group group;           
    struct opae_vfio_device device;         
    opae_hash_map cont_buffers;     
};

#ifdef __cplusplus
extern "C" {
#endif

int opae_vfio_open(struct opae_vfio *v,
           const char *pciaddr);

int opae_vfio_secure_open(struct opae_vfio *v,
              const char *pciaddr,
              const char *token);

int opae_vfio_region_get(struct opae_vfio *v,
             uint32_t index,
             uint8_t **ptr,
             size_t *size);

int opae_vfio_buffer_allocate(struct opae_vfio *v,
                  size_t *size,
                  uint8_t **buf,
                  uint64_t *iova);

enum opae_vfio_buffer_flags {
    OPAE_VFIO_BUF_PREALLOCATED = 1, 
};

int opae_vfio_buffer_allocate_ex(struct opae_vfio *v,
                 size_t *size,
                 uint8_t **buf,
                 uint64_t *iova,
                 int flags);

struct opae_vfio_buffer *opae_vfio_buffer_info(struct opae_vfio *v,
                           uint8_t *vaddr);

int opae_vfio_buffer_free(struct opae_vfio *v,
              uint8_t *buf);

int opae_vfio_irq_enable(struct opae_vfio *v,
             uint32_t index,
             uint32_t subindex,
             int event_fd);

int opae_vfio_irq_unmask(struct opae_vfio *v,
             uint32_t index,
             uint32_t subindex);

int opae_vfio_irq_mask(struct opae_vfio *v,
               uint32_t index,
               uint32_t subindex);

int opae_vfio_irq_disable(struct opae_vfio *v,
              uint32_t index,
              uint32_t subindex);

void opae_vfio_close(struct opae_vfio *v);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus

#endif // __OPAE_VFIO_H__

```