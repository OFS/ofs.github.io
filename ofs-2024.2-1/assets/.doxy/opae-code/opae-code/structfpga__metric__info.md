
# Struct fpga\_metric\_info



[**ClassList**](annotated.md) **>** [**fpga\_metric\_info**](structfpga__metric__info.md)



_Metric info struct._ 

* `#include <types.h>`













## Public Attributes

| Type | Name |
| ---: | :--- |
|  char | [**group\_name**](#variable-group_name)  <br> |
|  enum [**fpga\_metric\_datatype**](types__enum_8h.md#enum-fpga_metric_datatype) | [**metric\_datatype**](#variable-metric_datatype)  <br> |
|  [**fpga\_guid**](types_8h.md#typedef-fpga_guid) | [**metric\_guid**](#variable-metric_guid)  <br> |
|  char | [**metric\_name**](#variable-metric_name)  <br> |
|  uint64\_t | [**metric\_num**](#variable-metric_num)  <br> |
|  enum [**fpga\_metric\_type**](types__enum_8h.md#enum-fpga_metric_type) | [**metric\_type**](#variable-metric_type)  <br> |
|  char | [**metric\_units**](#variable-metric_units)  <br> |
|  char | [**qualifier\_name**](#variable-qualifier_name)  <br> |










## Public Attributes Documentation


### variable group\_name 

```C++
char fpga_metric_info::group_name[FPGA_METRIC_STR_SIZE];
```




### variable metric\_datatype 

```C++
enum fpga_metric_datatype fpga_metric_info::metric_datatype;
```




### variable metric\_guid 

```C++
fpga_guid fpga_metric_info::metric_guid;
```




### variable metric\_name 

```C++
char fpga_metric_info::metric_name[FPGA_METRIC_STR_SIZE];
```




### variable metric\_num 

```C++
uint64_t fpga_metric_info::metric_num;
```




### variable metric\_type 

```C++
enum fpga_metric_type fpga_metric_info::metric_type;
```




### variable metric\_units 

```C++
char fpga_metric_info::metric_units[FPGA_METRIC_STR_SIZE];
```




### variable qualifier\_name 

```C++
char fpga_metric_info::qualifier_name[FPGA_METRIC_STR_SIZE];
```




------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/types.h`