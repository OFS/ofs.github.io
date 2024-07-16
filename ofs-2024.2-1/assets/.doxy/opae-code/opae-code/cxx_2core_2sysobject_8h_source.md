
# File sysobject.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**sysobject.h**](cxx_2core_2sysobject_8h.md)

[Go to the documentation of this file.](cxx_2core_2sysobject_8h.md) 

```C++

// Copyright(c) 2018, Intel Corporation
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
#include <opae/cxx/core/handle.h>
#include <opae/cxx/core/token.h>
#include <opae/types.h>

#include <memory>
#include <vector>

namespace opae {
namespace fpga {
namespace types {

class sysobject {
 public:
  typedef std::shared_ptr<sysobject> ptr_t;

  sysobject() = delete;

  sysobject(const sysobject &o) = delete;

  sysobject &operator=(const sysobject &o) = delete;

  static sysobject::ptr_t get(token::ptr_t t, const std::string &name,
                              int flags = 0);

  static sysobject::ptr_t get(handle::ptr_t h, const std::string &name,
                              int flags = 0);

  sysobject::ptr_t get(const std::string &name, int flags = 0);

  sysobject::ptr_t get(int index);

  virtual ~sysobject();

  uint32_t size() const;

  uint64_t read64(int flags = 0) const;

  void write64(uint64_t value, int flags = 0) const;

  std::vector<uint8_t> bytes(int flags = 0) const;

  std::vector<uint8_t> bytes(uint32_t offset, uint32_t size,
                             int flags = 0) const;

  enum fpga_sysobject_type type() const;

  fpga_object c_type() const { return sysobject_; }

  operator fpga_object() const { return sysobject_; }

 private:
  sysobject(fpga_object sysobj, token::ptr_t token, handle::ptr_t hnd);
  fpga_object sysobject_;
  token::ptr_t token_;
  handle::ptr_t handle_;
};

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```