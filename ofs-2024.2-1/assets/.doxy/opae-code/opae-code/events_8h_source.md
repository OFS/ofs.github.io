
# File events.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**events.h**](events_8h.md)

[Go to the documentation of this file.](events_8h.md) 

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
#include <opae/types_enum.h>

#include <memory>

namespace opae {
namespace fpga {
namespace types {

class event {
 public:
  typedef std::shared_ptr<event> ptr_t;

  virtual ~event();

  struct type_t {
    type_t(fpga_event_type c_type) : type_(c_type) {}

    operator fpga_event_type() { return type_; }

    static constexpr fpga_event_type interrupt = FPGA_EVENT_INTERRUPT;
    static constexpr fpga_event_type error = FPGA_EVENT_ERROR;
    static constexpr fpga_event_type power_thermal = FPGA_EVENT_POWER_THERMAL;

   private:
    fpga_event_type type_;
  };

  fpga_event_handle get() { return event_handle_; }

  operator fpga_event_handle();

  static event::ptr_t register_event(handle::ptr_t h, event::type_t t,
                                     int flags = 0);

  int os_object() const;

 private:
  event(handle::ptr_t h, event::type_t t, fpga_event_handle event_h);
  handle::ptr_t handle_;
  event::type_t type_;
  fpga_event_handle event_handle_;
  int os_object_;
};

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```