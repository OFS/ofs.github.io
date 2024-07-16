
# File pvalue.h

[**File List**](files.md) **>** [**core**](dir_23b1b9d7ef54caa3fa7bb54d9bc2d47a.md) **>** [**pvalue.h**](pvalue_8h.md)

[Go to the documentation of this file.](pvalue_8h.md) 

```C++

// Copyright(c) 2018-2020, Intel Corporation
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
#include <opae/cxx/core/except.h>
#include <opae/properties.h>
#include <opae/utils.h>
#include <uuid/uuid.h>

#include <algorithm>
#include <array>
#include <cstring>
#include <iostream>
#include <type_traits>

namespace opae {
namespace fpga {
namespace types {

struct guid_t {
  guid_t(fpga_properties *p) : props_(p), is_set_(false) {}

  void update() {
    fpga_result res = fpgaPropertiesGetGUID(
        *props_, reinterpret_cast<fpga_guid *>(data_.data()));
    ASSERT_FPGA_OK(res);
    is_set_ = true;
  }

  operator uint8_t *() {
    update();
    return data_.data();
  }

  const uint8_t *c_type() const { return data_.data(); }

  guid_t &operator=(fpga_guid g) {
    is_set_ = false;
    ASSERT_FPGA_OK(fpgaPropertiesSetGUID(*props_, g));
    is_set_ = true;
    uint8_t *begin = &g[0];
    uint8_t *end = begin + sizeof(fpga_guid);
    std::copy(begin, end, data_.begin());
    return *this;
  }

  bool operator==(const fpga_guid &g) {
    return is_set() && (0 == std::memcmp(data_.data(), g, sizeof(fpga_guid)));
  }

  void parse(const char *str) {
    is_set_ = false;
    if (0 != uuid_parse(str, data_.data())) {
      throw except(OPAECXX_HERE);
    }
    ASSERT_FPGA_OK(fpgaPropertiesSetGUID(*props_, data_.data()));
    is_set_ = true;
  }

  friend std::ostream &operator<<(std::ostream &ostr, const guid_t &g) {
    fpga_properties props = *g.props_;
    fpga_guid guid_value;
    fpga_result res;
    if ((res = fpgaPropertiesGetGUID(props, &guid_value)) == FPGA_OK) {
      char guid_str[84];
      uuid_unparse(guid_value, guid_str);
      ostr << guid_str;
    } else if (FPGA_NOT_FOUND == res) {
      std::cerr << "[guid_t::<<] GUID property not set\n";
    } else {
      ASSERT_FPGA_OK(res);
    }
    return ostr;
  }

  bool is_set() const { return is_set_; }

  void invalidate() { is_set_ = false; }

 private:
  fpga_properties *props_;
  bool is_set_;
  std::array<uint8_t, 16> data_;
};

template <typename T>
struct pvalue {
  typedef typename std::conditional<
      std::is_same<T, char *>::value, fpga_result (*)(fpga_properties, T),
      fpga_result (*)(fpga_properties, T *)>::type getter_t;

  typedef fpga_result (*setter_t)(fpga_properties, T);

  typedef typename std::conditional<std::is_same<T, char *>::value,
                                    typename std::string, T>::type copy_t;

  pvalue() : props_(0), is_set_(false), get_(nullptr), set_(nullptr), copy_() {}

  pvalue(fpga_properties *p, getter_t g, setter_t s)
      : props_(p), is_set_(false), get_(g), set_(s), copy_() {}

  pvalue<T> &operator=(const T &v) {
    is_set_ = false;
    ASSERT_FPGA_OK(set_(*props_, v));
    is_set_ = true;
    copy_ = v;
    return *this;
  }

  bool operator==(const T &other) { return is_set() && (copy_ == other); }

  void update() {
    ASSERT_FPGA_OK(get_(*props_, &copy_));
    is_set_ = true;
  }

  operator copy_t() {
    update();
    return copy_;
  }

  // TODO: Remove this once all properties are tested
  fpga_result get_value(T &value) const { return get_(*props_, &value); }

  friend std::ostream &operator<<(std::ostream &ostr, const pvalue<T> &p) {
    T value;
    fpga_properties props = *p.props_;
    fpga_result res;
    if ((res = p.get_(props, &value)) == FPGA_OK) {
      ostr << +(value);
    } else if (FPGA_NOT_FOUND == res) {
      std::cerr << "property getter returned (" << res << ") "
                << fpgaErrStr(res);
    } else {
      ASSERT_FPGA_OK(res);
    }
    return ostr;
  }

  bool is_set() const { return is_set_; }

  void invalidate() { is_set_ = false; }

 private:
  fpga_properties *props_;
  bool is_set_;
  getter_t get_;
  setter_t set_;
  copy_t copy_;
};

template <>
inline void pvalue<char *>::update() {
  char buf[256];
  ASSERT_FPGA_OK(get_(*props_, buf));
  copy_.assign(buf);
  is_set_ = true;
}

}  // end of namespace types
}  // end of namespace fpga
}  // end of namespace opae

```