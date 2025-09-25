An OFSS file with IP type `ofs` contains board specific information for the target board. It defines certain attributes of the design, including the platform name, device family, fim type, part number, and device ID. It can also contain settings for system information like PCIe generation and subsystem device IDs. Note that PCIe settings defined in the PCIe OFSS file will take precedence over any PCIe settings defined in the Base OFSS file.

Currently supported configuration options for an OFSS file with IP type `ofs` are described in the *OFS IP OFSS File Options* table.

*Table: OFS IP OFSS File Options*

| Section | Parameter | n6001 Default Value | n6000 Default Value | fseries-dk Default Value | iseries-dk Default Value |
| --- | --- | --- | --- | --- | --- |
| `[ip]` | `type` | `ofs` | `ofs` | `ofs` | `ofs` |
| `[settings]` | `platform` | `n6001` | `n6000` | `n6001` | `n6001` |
| | `family` | `agilex` | `agilex` | `agilex` | `agilex` |
| | `fim` | `base_x16` | `base_x16` | `base_x16` | `base_x16` |
| | `part` | `AGFB014R24A2E2V` | `AGFB014R24A2E2V` | `AGFB027R24C2E2VR2` | `AGIB027R29A1E1VB` |
| | `device_id` | `6001` | `6000` | `6001` | `6001` |
| `[pcie.settings]` | `pcie_gen` | `4` | `4` | `4` | `5` |
| `[pcie]` | `subsys_dev_id` | `1771` | `1770` | `1` | `1` |
| | `exvf_subsysid` | `1771` | `1770` | `1` | `1` |

The *Provided Base OFSS Files* table describes the Base OFSS files that are provided to you.

*Table: Provided Base OFSS Files*

| OFSS File Name | Location | Type | Supported Board |
| --- | --- | --- | --- |
| `n6001_base.ofss` | `$OFS_ROOTDIR/tools/ofss_config/base` | ofs | N6001 |
| `n6000_base.ofss` | `$OFS_ROOTDIR/tools/ofss_config/base` | ofs | N6000 |
| `fseries-dk_base.ofss` | `$OFS_ROOTDIR/tools/ofss_config/base` | ofs | fseries-dk |
| `iseries-dk_base.ofss` | `$OFS_ROOTDIR/tools/ofss_config/base` | ofs | iseries-dk |
