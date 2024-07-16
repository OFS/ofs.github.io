An OFSS file with IP type `iopll` is used to configure the IOPLL in the FIM.

The IOPLL OFSS file has a special section type (`[p_clk]`) which is used to define the IOPLL clock frequency.

Currently supported configuration options for an OFSS file with IP type `iopll` are described in the *IOPLL OFSS File Options* table.

*Table: IOPLL OFSS File Options*

| Section | Parameter | Options | Description | n6001 Default Value | n6000 Default Value | fseries-dk Default Value | iseries-dk Default Value |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `[ip]` | `type` | `iopll` | Specifies that this OFSS file configures the IOPLL | `iopll` | `iopll` | `iopll` | `iopll` |
| `[settings]` | `output_name` | `sys_pll` | Specifies the output name of the IOPLL. | `sys_pll` | `sys_pll` | `sys_pll` | `sys_pll` |
| | `instance_name` | `iopll_0` | Specifies the instance name of the IOPLL. | `iopll_0` | `iopll_0` | `iopll_0` | `iopll_0` |
| `[p_clk]` | `freq` | Integer: 250 - 500 | Specifies the IOPLL clock frequency in MHz. | `500` | `350` | `500` | `500` |

The *Provided IOPLL OFSS Files* table describes the IOPLL OFSS files that are provided to you.

*Table: Provided IOPLL OFSS Files*

| OFSS File Name | Location | Type | Description | Supported Board |
| --- | --- | --- | --- | --- |
| `iopll_500MHz.ofss` | `$OFS_ROOTDIR/tools/ofss_config/iopll` | iopll | Sets the IOPLL frequency to `500 MHz` | N6001 \| fseries-dk \| iseries-dk |
| `iopll_470MHz.ofss` | `$OFS_ROOTDIR/tools/ofss_config/iopll` | iopll | Sets the IOPLL frequency to `470 MHz` | N6001 \| fseries-dk \| iseries-dk |
| `iopll_350MHz.ofss` | `$OFS_ROOTDIR/tools/ofss_config/iopll` | iopll | Sets the IOPLL frequency to `350 MHz` | N6001 \| N6000 \| fseries-dk \| iseries-dk |
