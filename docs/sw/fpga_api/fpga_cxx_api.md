# OPAE C++ Core API Reference

The reference documentation for the OPAE C++ Core API is grouped into the following sections:

- [Overview](#id1)
- [Goals](#id2)
  - [Simplicity](#id3)
  - [Extensibility and Interoperability](#id4)
  - [Modern C++ Coding Practices](#id5)
  - [Error Handling](#id6)
  - [Coding Style](#id7)
- [Fundamental Types](#id8)
  - [Properties](#id9)
  - [pvalue.h](#id10)
  - [properties.h](#id11)
  - [Resource Classes](#id12)
  - [token.h](#id13)
  - [handle.h](#id14)
  - [shared_buffer.h](#id15)
  - [errors.h](#id16)
  - [events.h](#id17)
  - [sysobject.h](#id18)
  - [Exceptions](#id19)
  - [except.h](#id20)
  - [Misc](#id21)
  - [version.h](#id22)



## <a name="id1">Overview</a>

The OPAE C++ API enables C++ developers with the means to use FPGA resources by integrating the OPAE software stack into C++ applications.



## <a name="id2">Goals</a>



### <a name="id3">Simplicity</a>

Keep the API as small and lightweight as possible. Although features such as system validation and orchestration are beyond the scope of this API, using this API for their development should be relatively easy.



### <a name="id4">Extensibility and Interoperability</a>

While keeping to the goal of simplicity, the OPAE C++ API is designed to allow for better reuse by either extending the API or by integrating with other languages.



### <a name="id5">Modern C++ Coding Practices</a>

The OPAE C++ API uses the C++ 11 standard library and makes use of its features whenever practical. The OPAE C++ API is also designed to require the minimum number of third-party libraries/dependencies.



### <a name="id6">Error Handling</a>

The OPAE C++ API is designed to throw exceptions when appropriate. The structure of OPAE C++ exceptions is similar to the error codes in the OPAE C API. This gives users of the API more freedom on error handling while providing better debug information in cases of failure.



### <a name="id7">Coding Style</a>

For formatting of the OPAE C++ API complies with most of the recommendations of the Google C++ style. For example, the OPAE C++ API uses:

- opening braces on the same line as their scope definition
- spaces instead of tabs for indentation
- indentation of two spaces



## <a name="id8">Fundamental Types</a>

Basic types for the OPAE C++ API are found in the opae::fpga::types namespace. They serve as an adapter layer between the OPAE C API and the OPAE C++ layer. Aside from providing a C++ binding to the C fundamental types, these types also:

- manage the lifetime and scope of the corresponding C struct.

> - For example a C++ destructor will take care of calling the appropriate C function to release the data structure being wrapped.

- provide a friendly syntax for using the OPAE C type.

Most classes in this namespace have a c_type() method that returns the C data structure being wrapped, making it easy to use the OPAE C++ type with the OPAE C API. Alternatively, most classes in this namespace have implicit conversion operators that enable interoperability with the OPAE C API.



### <a name="id9">Properties</a>

C++ class properties wraps fpga_properties and uses pvalue and guid_t to get and set properties stored in an instance of an fpga_properties. pvalue and guid_t are designed to call an accessor method in the OPAE C API to either read property values or write them. Most accessor methods in the OPAE C API share a similar signature, so pvalue generalizes them into common operations that translate into calling the corresponding C API function. guid_t follows similar patterns when reading or assigning values.



### <a name="id10" href="../../../opae-code/pvalue_8h/index.html">pvalue.h</a>

[pvalue.h](../../../opae-code/pvalue_8h/index.html)


### <a name="id11" href="../../../opae-code/cxx_2core_2properties_8h/index.html">properties.h</a>

[properties.h](../../../opae-code/cxx_2core_2properties_8h/index.html)



### <a name="id12">Resource Classes</a>

The token, handle, and shared_buffer classes are used to enumerate and access FPGA resources. properties are used to narrow the search space for token's. Before enumerating the accelerator resources in the system, applications can produce one or more properties objects whose values are set to the desired characteristics for the resource. For example, an application may search for an accelerator resource based on its guid.

Once one or more token's have been enumerated, the application must choose which token's to request. The token is then converted to a handle by requesting that a handle object be allocated and opened for it.

Once a handle has been successfully opened, the application can read and write the associated configuration and status space. Additionally, the application may use the handle to allocate shared_buffer's or to register event's. The shared_buffer and event objects retain a reference to their owning handle so that the handle does not lose scope before freeing the shared_buffer and event objects.



### <a name="id13" href="../../../opae-code/token_8h/index.html">token.h</a>

[token.h](../../../opae-code/token_8h/index.html)



### <a name="id14" href="../../../opae-code/handle_8h/index.html">handle.h</a>

[handle.h](../../../opae-code/handle_8h/index.html)



### <a name="id15" href="../../../opae-code/shared__buffer_8h/index.html">shared_buffer.h</a>

[shared_buffer.h](../../../opae-code/shared__buffer_8h/index.html)



### <a name="id16" href="../../../opae-code/errors_8h/index.html">errors.h</a>

[errors.h](../../../opae-code/errors_8h/index.html)



### <a name="id17" href="../../../opae-code/events_8h/index.html">events.h</a>

[events.h](../../../opae-code/events_8h/index.html)



### <a name="id18" href="../../../opae-code/cxx_2core_2sysobject_8h/index.html">sysobject.h</a>

[sysobject.h](../../../opae-code/cxx_2core_2sysobject_8h/index.html)



### <a name="id19">Exceptions</a>

When the OPAE C++ API encounters an error from the OPAE C API, it captures the current source code location and the error code into an object of type except, then throws the except. Applications should implement the appropriate catch blocks required to respond to runtime exceptions.



### <a name="id20" href="../../../opae-code/except_8h/index.html">except.h</a>

[except.h](../../../opae-code/except_8h/index.html)



### <a name="id21">Misc</a>

The version class wraps the OPAE C version API.



### <a name="id22" href="../../../opae-code/cxx_2core_2version_8h/index.html">version.h</a>

[version.h](../../../opae-code/cxx_2core_2version_8h/index.html)

