
# File token.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**token.h**](token_8h.md)

[Go to the documentation of this file.](token_8h.md) 

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
#include <opae/access.h>
#include <opae/cxx/core/properties.h>
#include <opae/enum.h>
#include <opae/types.h>

#include <memory>
#include <vector>

namespace opae {
namespace fpga {
namespace types {

class token {
 public:
  typedef std::shared_ptr<token> ptr_t;

  static std::vector<token::ptr_t> enumerate(
      const std::vector<properties::ptr_t>& props);

  ~token();

  fpga_token c_type() const { return token_; }

  operator fpga_token() const { return token_; }

  ptr_t get_parent() const;

 private:
  token(fpga_token tok);

  fpga_token token_;

  friend class handle;
};

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```