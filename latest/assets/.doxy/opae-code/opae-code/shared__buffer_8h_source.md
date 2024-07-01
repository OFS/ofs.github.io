
# File shared\_buffer.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**shared\_buffer.h**](shared__buffer_8h.md)

[Go to the documentation of this file.](shared__buffer_8h.md) 

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
#include <opae/buffer.h>
#include <opae/cxx/core/except.h>
#include <opae/cxx/core/handle.h>

#include <chrono>
#include <cstdint>
#include <initializer_list>
#include <memory>
#include <thread>
#include <vector>

namespace opae {
namespace fpga {
namespace types {

class shared_buffer {
 public:
  typedef std::size_t size_t;
  typedef std::shared_ptr<shared_buffer> ptr_t;

  shared_buffer(const shared_buffer &) = delete;
  shared_buffer &operator=(const shared_buffer &) = delete;

  virtual ~shared_buffer();

  static shared_buffer::ptr_t allocate(handle::ptr_t handle, size_t len,
                                       bool read_only = false);

  static shared_buffer::ptr_t attach(handle::ptr_t handle, uint8_t *base,
                                     size_t len, bool read_only = false);

  void release();

  volatile uint8_t *c_type() const { return virt_; }

  handle::ptr_t owner() const { return handle_; }

  size_t size() const { return len_; }

  uint64_t wsid() const { return wsid_; }

  uint64_t io_address() const { return io_address_; }

  void fill(int c);

  int compare(ptr_t other, size_t len) const;

  template <typename T>
  T read(size_t offset) const {
    if ((offset < len_) && (virt_ != nullptr)) {
      return *reinterpret_cast<T *>(virt_ + offset);
    } else if (offset >= len_) {
      throw except(OPAECXX_HERE);
    } else {
      throw except(OPAECXX_HERE);
    }
    return T();
  }

  template <typename T>
  void write(const T &value, size_t offset) {
    if ((offset < len_) && (virt_ != nullptr)) {
      *reinterpret_cast<T *>(virt_ + offset) = value;
    } else if (offset >= len_) {
      throw except(OPAECXX_HERE);
    } else {
      throw except(OPAECXX_HERE);
    }
  }

 protected:
  shared_buffer(handle::ptr_t handle, size_t len, uint8_t *virt, uint64_t wsid,
                uint64_t io_address);

  handle::ptr_t handle_;
  size_t len_;
  uint8_t *virt_;
  uint64_t wsid_;
  uint64_t io_address_;
};

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```