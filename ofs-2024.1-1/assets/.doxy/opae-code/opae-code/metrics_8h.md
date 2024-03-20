
# File metrics.h



[**FileList**](files.md) **>** [**docs**](dir_49e56c817e5e54854c35e136979f97ca.md) **>** [**sw**](dir_55721a669a8e0900d975c02921addb49.md) **>** [**include**](dir_97b4588afba69bf89bbe554642ac6431.md) **>** [**opae**](dir_ade97cd9199f278c0723672dd8647ba4.md) **>** [**metrics.h**](metrics_8h.md)

[Go to the source code of this file.](metrics_8h_source.md)

_Functions for Discover/ Enumerates metrics and retrieves values._ 

* `#include <opae/types.h>`















## Public Functions

| Type | Name |
| ---: | :--- |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetMetricsByIndex**](#function-fpgagetmetricsbyindex) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t \* metric\_num, uint64\_t num\_metric\_indexes, [**fpga\_metric**](structfpga__metric.md) \* metrics) <br>_Retrieve metrics values by index._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetMetricsByName**](#function-fpgagetmetricsbyname) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, char \*\* metrics\_names, uint64\_t num\_metric\_names, [**fpga\_metric**](structfpga__metric.md) \* metrics) <br>_Retrieve metric values by names._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetMetricsInfo**](#function-fpgagetmetricsinfo) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, [**fpga\_metric\_info**](structfpga__metric__info.md) \* metric\_info, uint64\_t \* num\_metrics) <br>_Retrieve metrics information._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetMetricsThresholdInfo**](#function-fpgagetmetricsthresholdinfo) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, struct [**metric\_threshold**](structmetric__threshold.md) \* metric\_thresholds, uint32\_t \* num\_thresholds) <br>_Retrieve metrics / sendor threshold information and values._  |
|  [**fpga\_result**](types__enum_8h.md#enum-fpga_result) | [**fpgaGetNumMetrics**](#function-fpgagetnummetrics) ([**fpga\_handle**](types_8h.md#typedef-fpga_handle) handle, uint64\_t \* num\_metrics) <br>_Enumerates number of metrics._  |








## Public Functions Documentation


### function fpgaGetMetricsByIndex 

_Retrieve metrics values by index._ 
```C++
fpga_result fpgaGetMetricsByIndex (
    fpga_handle handle,
    uint64_t * metric_num,
    uint64_t num_metric_indexes,
    fpga_metric * metrics
) 
```





**Parameters:**


* `handle` Handle to previously opened fpga resource 
* `metric_num` Pointer to array of metric index user allocates metric array 
* `num_metric_indexes` Size of metric array 
* `metrics` pointer to array of metric struct



**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the Metrics are not found. FPGA\_NO\_MEMORY if there was not enough memory to enumerates metrics. 





        

### function fpgaGetMetricsByName 

_Retrieve metric values by names._ 
```C++
fpga_result fpgaGetMetricsByName (
    fpga_handle handle,
    char ** metrics_names,
    uint64_t num_metric_names,
    fpga_metric * metrics
) 
```





**Parameters:**


* `handle` Handle to previously opened fpga resource 
* `metrics_names` Pointer to array of metrics name user allocates metrics name array 
* `num_metric_names` Size of metric name array 
* `metrics` Pointer to array of metric struct



**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the Metrics are not found 





        

### function fpgaGetMetricsInfo 

_Retrieve metrics information._ 
```C++
fpga_result fpgaGetMetricsInfo (
    fpga_handle handle,
    fpga_metric_info * metric_info,
    uint64_t * num_metrics
) 
```





**Parameters:**


* `handle` Handle to previously opened fpga resource 
* `metric_info` Pointer to array of metric info struct user allocates metrics info array
* `num_metrics` Size of metric info array



**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the Metrics are not found. FPGA\_NO\_MEMORY if there was not enough memory to enumerates metrics. 





        

### function fpgaGetMetricsThresholdInfo 

_Retrieve metrics / sendor threshold information and values._ 
```C++
fpga_result fpgaGetMetricsThresholdInfo (
    fpga_handle handle,
    struct metric_threshold * metric_thresholds,
    uint32_t * num_thresholds
) 
```





**Parameters:**


* `handle` Handle to previously opened fpga resource 
* `metrics_threshold` pointer to array of metric thresholds user allocates threshold array memory Number of thresholds returns enumerated thresholds if user pass NULL metrics\_thresholds 
* `num_thresholds` number of thresholds



**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the Metrics are not found. FPGA\_NO\_MEMORY if there was not enough memory to enumerates metrics. 





        

### function fpgaGetNumMetrics 

_Enumerates number of metrics._ 
```C++
fpga_result fpgaGetNumMetrics (
    fpga_handle handle,
    uint64_t * num_metrics
) 
```





**Parameters:**


* `handle` Handle to previously opened fpga resource 
* `num_metrics` Number of metrics are discovered in fpga resource



**Returns:**

FPGA\_OK on success. FPGA\_NOT\_FOUND if the Metrics are not discovered 





        

------------------------------
The documentation for this class was generated from the following file `docs/sw/include/opae/metrics.h`