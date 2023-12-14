
# File except.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**except.h**](except_8h.md)

[Go to the documentation of this file.](except_8h.md) 

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
#include <opae/types_enum.h>

#include <cstdint>
#include <exception>

namespace opae {
namespace fpga {
namespace types {

class src_location {
 public:
  src_location(const char *file, const char *fn, int line) noexcept;

  src_location(const src_location &other) noexcept;

  src_location &operator=(const src_location &other) noexcept;

  const char *file() const noexcept;

  const char *fn() const noexcept { return fn_; }

  int line() const noexcept { return line_; }

 private:
  const char *file_;
  const char *fn_;
  int line_;
};

#define OPAECXX_HERE \
  opae::fpga::types::src_location(__FILE__, __func__, __LINE__)

class except : public std::exception {
 public:
  static const std::size_t MAX_EXCEPT = 256;

  except(src_location loc) noexcept;

  except(fpga_result res, src_location loc) noexcept;

  except(fpga_result res, const char *msg, src_location loc) noexcept;

  virtual const char *what() const noexcept override;

  operator fpga_result() const noexcept { return res_; }

 protected:
  fpga_result res_;
  const char *msg_;
  src_location loc_;
  mutable char buf_[MAX_EXCEPT];
};

class invalid_param : public except {
 public:
  invalid_param(src_location loc) noexcept
      : except(FPGA_INVALID_PARAM, "failed with return code FPGA_INVALID_PARAM",
               loc) {}
};

class busy : public except {
 public:
  busy(src_location loc) noexcept
      : except(FPGA_BUSY, "failed with return code FPGA_BUSY", loc) {}
};

class exception : public except {
 public:
  exception(src_location loc) noexcept
      : except(FPGA_EXCEPTION, "failed with return code FPGA_EXCEPTION", loc) {}
};

class not_found : public except {
 public:
  not_found(src_location loc) noexcept
      : except(FPGA_NOT_FOUND, "failed with return code FPGA_NOT_FOUND", loc) {}
};

class no_memory : public except {
 public:
  no_memory(src_location loc) noexcept
      : except(FPGA_NO_MEMORY, "failed with return code FPGA_NO_MEMORY", loc) {}
};

class not_supported : public except {
 public:
  not_supported(src_location loc) noexcept
      : except(FPGA_NOT_SUPPORTED, "failed with return code FPGA_NOT_SUPPORTED",
               loc) {}
};

class no_driver : public except {
 public:
  no_driver(src_location loc) noexcept
      : except(FPGA_NO_DRIVER, "failed with return code FPGA_NO_DRIVER", loc) {}
};

class no_daemon : public except {
 public:
  no_daemon(src_location loc) noexcept
      : except(FPGA_NO_DAEMON, "failed with return code FPGA_NO_DAEMON", loc) {}
};

class no_access : public except {
 public:
  no_access(src_location loc) noexcept
      : except(FPGA_NO_ACCESS, "failed with return code FPGA_NO_ACCESS", loc) {}
};

class reconf_error : public except {
 public:
  reconf_error(src_location loc) noexcept
      : except(FPGA_RECONF_ERROR, "failed with return code FPGA_RECONF_ERROR",
               loc) {}
};

namespace detail {

typedef bool (*exception_fn)(fpga_result,
                             const opae::fpga::types::src_location &loc);

template <typename T>
constexpr bool is_ok(fpga_result result,
                     const opae::fpga::types::src_location &loc) {
  return result == FPGA_OK ? true : throw T(loc);
}

static exception_fn opae_exceptions[12] = {
    is_ok<opae::fpga::types::invalid_param>,
    is_ok<opae::fpga::types::busy>,
    is_ok<opae::fpga::types::exception>,
    is_ok<opae::fpga::types::not_found>,
    is_ok<opae::fpga::types::no_memory>,
    is_ok<opae::fpga::types::not_supported>,
    is_ok<opae::fpga::types::no_driver>,
    is_ok<opae::fpga::types::no_daemon>,
    is_ok<opae::fpga::types::no_access>,
    is_ok<opae::fpga::types::reconf_error>};

static inline void assert_fpga_ok(fpga_result result,
                                  const opae::fpga::types::src_location &loc) {
  if (result > FPGA_OK && result <= FPGA_RECONF_ERROR)
    // our exception table above starts at invalid_param with index 0
    // but FPGA_INVALID_PARAM is actually enum 1 - let's account for that
    opae_exceptions[result - 1](result, loc);
}

}  // end of namespace detail

#define ASSERT_FPGA_OK(r)                    \
  opae::fpga::types::detail::assert_fpga_ok( \
      r, opae::fpga::types::src_location(__FILE__, __func__, __LINE__));

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```