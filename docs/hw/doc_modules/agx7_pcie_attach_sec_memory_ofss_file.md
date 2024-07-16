An OFSS file with IP type `memory` is used to configure the Memory-SS in the FIM.

The Memory OFSS file specifies a `preset` value, which selects a presets file (`.qprs`) to configure the Memory-SS.

Currently supported configuration options for an OFSS file with IP type `memory` are described in the *Memory OFSS File Options* table.

*Table: Memory OFSS File Options*

| Section | Parameter | Options | Description | n6001 Default Value | n6000 Default Value | fseries-dk Default Value | iseries-dk Default Value |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `[ip]` | `type` | `memory` | Specifies that this OFSS file configures the Memory-SS | `memory` | N/A | `memory` | `memory` |
| `[settings]` | `output_name` | `mem_ss_fm` | Specifies the output name of the Memory-SS. | `mem_ss_fm` | N/A | `mem_ss_fm` | `mem_ss_fm` |
| | `preset` | *String*<sup>**[1]**</sup> | Specifies the name of the `.qprs` presets file that will be used to build the Memory-SS. | `n6001` | N/A | `fseries-dk` | `iseries-dk` |

<sup>**[1]**</sup> You may generate your own `.qprs` presets file with a unique name using Quartus. 

Memory-SS presets files are stored in the `$OFS_ROOTDIR/ipss/mem/qip/presets` directory.

The *Provided Memory OFSS Files* table describes the Memory OFSS files that are provided to you.

*Table: Provided Memory OFSS Files*

| OFSS File Name | Location | Type | Description | Supported Board |
| --- | --- | --- | --- | --- |
| `memory.ofss` | `$OFS_ROOTDIR/tools/ofss_config/memory` | memory | Defines the memory IP preset file to be used during the build as: | N6001 \| N6000 <sup>**[1]**</sup> |
| `memory_ftile.ofss` | `$OFS_ROOTDIR/tools/ofss_config/memory` | memory | Defines the memory IP preset file to be used during the build as `fseries-dk` | fseries-dk |
| `memory_rtile.ofss` | `$OFS_ROOTDIR/tools/ofss_config/memory` | memory | Defines the memory IP preset file to be used during the build as `iseries-dk` | iseries-dk |
| `memory_rtile_no_dimm.ofss` | `$OFS_ROOTDIR/tools/ofss_config/memory` | memory | Defines the memory IP preset file to be used during the build as `iseries-dk` | iseries-dk |

<sup>**[1]**</sup> The `memory.ofss` file can be used for the N6000, however, the default N6000 FIM does not implement the Memory Sub-system. Refer to Section 4.7.2 for step-by-step instructions on how to enable the Memory sub-system
