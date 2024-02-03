
# File handle.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**handle.h**](handle_8h.md)

[Go to the documentation of this file.](handle_8h.md) 

```C++

// Copyright(c) 2018-2021, Intel Corporation
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
#pragma once
#include <opae/cxx/core/token.h>
#include <opae/enum.h>
#include <opae/types.h>

#include <memory>
#include <vector>

namespace opae {
namespace fpga {
namespace types {

class handle {
 public:
  typedef std::shared_ptr<handle> ptr_t;

  handle(const handle &) = delete;
  handle &operator=(const handle &) = delete;

  virtual ~handle();

  fpga_handle c_type() const { return handle_; }

  operator fpga_handle() const { return handle_; }

  void reconfigure(uint32_t slot, const uint8_t *bitstream, size_t size,
                   int flags);

  uint32_t read_csr32(uint64_t offset, uint32_t csr_space = 0) const;

  void write_csr32(uint64_t offset, uint32_t value, uint32_t csr_space = 0);

  uint64_t read_csr64(uint64_t offset, uint32_t csr_space = 0) const;

  void write_csr64(uint64_t offset, uint64_t value, uint32_t csr_space = 0);

  void write_csr512(uint64_t offset, const void *value, uint32_t csr_space = 0);

  uint8_t *mmio_ptr(uint64_t offset, uint32_t csr_space = 0) const;

  static handle::ptr_t open(fpga_token token, int flags);

  static handle::ptr_t open(token::ptr_t token, int flags);

  virtual void reset();

  fpga_result close();

  token::ptr_t get_token() const;

 private:
  handle(fpga_handle h);

  fpga_handle handle_;
  fpga_token token_;
};

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```