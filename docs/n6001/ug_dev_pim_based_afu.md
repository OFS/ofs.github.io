# **PIM Based AFU Developer Guide**
Last updated: **February 26, 2025** 

## **1. Introduction**

When creating an AFU, a designer needs to decide what type of interfaces the platform (FIM) should provide to the AFU.  The FIM can provide the native interfaces (i.e. PCIe TLP commands) or standard memory mapped interfaces (i.e. AXI-MM or AVMM) by using the PIM.  The PIM is an abstraction layer consisting of a collection of SystemVerilog interfaces and shims to enable partial AFU portability across hardware despite variations in hardware topology and native interfaces. The PIM adds a level of logic between the AFU and the FIM converting the native interfaces from the FIM to match the interfaces provided by the AFU.
![](/ofs-2024.3-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/images/PIM_top_intro.png)


This guide will walk you through creating a PIM-Based AFU, including:

- AFU Build environment
- Using the PIM to interface with an AFU
- AFU Design
- Software Development
- Packaging the AFU

For more information on the PIM, refer to [PIM Core Concepts](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_core_concepts.md).

For PIM based examples AFU's to provide templates in designing your own AFU, refer to [examples AFU](https://github.com/OFS/examples-afu.git).

For steps on compiling your AFU, please see the associated platform's AFU Developer Guide.

For steps on integrating your AFU into the FIM, please see the associated platform's FIM Developer Guide.


## **2. AFU Build Environment**
The Platform Interface Manager (PIM) acts as a gateway between the board-specific platform and the generic AFU. It manages resources, handles communication protocols, and translates platform-specific signals to a format the AFU can understand. The PIM wraps all FIM devices in a single container as an interface named `ofs_plat_if`, which is passed to the top-level AFU module `ofs_plat_afu`.

The below table shows the supported interfaces for each channel type by the PIM.  

| Channel        |  AXI-MM  | AXI-Lite | Avalon MM | Avalon MM Rd/Wr |  HSSI Channel  |
| -------------- |  ------  |  ------  | --------- | --------------- | -------------- |
| MMIO           |          |     X    |    X      |                 |                |
| Host Memory    |     X    |          |    X      |        X        |                |
| Local Memory   |     X    |          |    X      |                 |                |
| HSSI           |          |          |           |                 |         X      |

A Partial Reconfiguration (PR) build template is used for configuring a PR AFU build and is derived from a synthesized FIM. The template includes the PIM and the `afu_synth_setup` script, which generates a Quartus build environment for an AFU. The build environment is instantiated from a FIM release and then configured for the specified AFU. The AFU source files are specified in a text file parsed by the script when creating the Quartus project.

The PIM is instantiated in the build environment from an .ini file describing the platform, located at 
`<PR build template>/hw/lib/platform/platform_db/<ofs platform>.ini`

Example N6001 FIM .ini file, `<pr_build_template>/hw/lib/platform/platform_db/ofs_agilex.ini`
```sh
;; Platform Interface Manager configuration
;;
;; Agilex™ adp board
;; OFS FIM
;;
;; Local memory with AXI-MM interface
;;

[define]
PLATFORM_FPGA_FAMILY_AGILEX=1
PLATFORM_FPGA_FAMILY_AGILEX7=1
;; Indicates that ASE emulation of the afu_main interface is offered
ASE_AFU_MAIN_IF_OFFERED=1
native_class=none
;; Early versions of afu_main checked INCLUDE_HSSI_AND_NOT_CVL. When
;; this macro is set, the presence of HSSI ports in afu_main() is
;; controlled by INCLUDE_HSSI.
AFU_MAIN_API_USES_INCLUDE_HSSI=1

[clocks]
pclk_freq=int'(ofs_fim_cfg_pkg::MAIN_CLK_MHZ)
;; Newer parameter, more accurate when pclk is not an integer MHz
pclk_freq_mhz_real=ofs_fim_cfg_pkg::MAIN_CLK_MHZ
native_class=none

[host_chan]
num_ports=top_cfg_pkg::PG_AFU_NUM_PORTS
native_class=native_axis_pcie_tlp
gasket=pcie_ss
mmio_addr_width=ofs_fim_cfg_pkg::MMIO_ADDR_WIDTH_PG
num_intr_vecs=ofs_fim_cfg_pkg::NUM_AFU_INTERRUPTS

;; Minimum number of outstanding flits that must be in flight to
;; saturate bandwidth. Maximum bandwidth is typically a function
;; of the number flits in flight, indepent of burst sizes.
max_bw_active_flits_rd=1024
max_bw_active_flits_wr=128

;; Recommended number of times an AFU should register host channel
;; signals before use in order to make successful timing closure likely.
suggested_timing_reg_stages=0

[local_mem]
native_class=native_axi
gasket=fim_emif_axi_mm
num_banks=ofs_fim_mem_if_pkg::NUM_MEM_CHANNELS
;; Address width (line-based, ignoring the byte offset within a line)
addr_width=ofs_fim_mem_if_pkg::AXI_MEM_ADDR_WIDTH-$clog2(ofs_fim_mem_if_pkg::AXI_MEM_WDATA_WIDTH/8)
data_width=ofs_fim_mem_if_pkg::AXI_MEM_WDATA_WIDTH
ecc_width=0
;; For consistency, the PIM always encodes burst width as if the bus were
;; Avalon. Add 1 bit: Avalon burst length is 1-based, AXI is 0-based.
burst_cnt_width=8+1
user_width=ofs_fim_mem_if_pkg::AXI_MEM_USER_WIDTH
rid_width=ofs_fim_mem_if_pkg::AXI_MEM_ID_WIDTH
wid_width=ofs_fim_mem_if_pkg::AXI_MEM_ID_WIDTH
suggested_timing_reg_stages=2

[hssi]
native_class=native_axis_with_fc
num_channels=ofs_fim_eth_plat_if_pkg::MAX_NUM_ETH_CHANNELS

;; Sideband interface specific to this platform. It is used for passing
;; state through plat_ifc.other.ports[] that the PIM does not manage.
[other]
;; Use the PIM's "generic" extension class. The PIM provides the top-level
;; generic wrapper around ports and the implementation of the type is set below.
template_class=generic_templates
native_class=ports
;; All PIM wrappers are vectors. Depending on the data being passed through
;; the interface, FIMs may either use more ports or put vectors inside the
;; port's type.
num_ports=1
;; Data type of the sideband interface
type=ofs_plat_fim_other_if
;; Import the "other" SystemVerilog definitions into the PIM (relative path)
import=import/extend_pim
```

The OFS scripts choose the proper subset of PIM sources to map from standard PIM AFU interfaces to physical hardware. Given an input .ini configuration file, `gen_ofs_plat_if` constructs an `ofs_plat_if` interface that is tailored to the target platform. Templates make it possible for the source tree to support multiple devices of similar types, such as both DDR and HBM, on a single board.

Each major section in a platform .ini file corresponds to one or more devices of the same type. Same-sized banks of local memory share a single .ini section, with the number of banks as a parameter in the section. The same is true of HSSI ports and, on some multi-PCIe systems, of host channels. All devices in a section must share the same properties. If there are two types of local memory on a board with different address or data widths, they must have their own local memory sections. Separate sections of the same type must be named with monotonically increasing numeric suffixes, e.g. local_memory.0 and local_memory.1. The trailing .0 is optional. host_channel.0 and host_channel are equivalent.

The `gen_ofs_plat_if` script, which composes a platform-specific PIM given an .ini file, uses the ofs_plat_if/src/rtl/ tree as a template. The script copies sources into the target `ofs_plat_if` interface within a release, generates some top-level wrapper files and emits rules that import the generated tree for simulation or synthesis.

For more information, refer to [PIM Board Vendors](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_board_vendors.md)

### **2.1. PIM Resources**

The PIM provides a collection of RTL interfaces and modules.  These are copied over from ofs-platform-afu-bbb to `<afu build dir>/build/platform/ofs_plat_if/rtl/`.  The modules brought over are based on the FIM's native interfaces:

- ofs_plat_if.vh: PIM's top level wrapper interface for passing all top-level interfaces into an AFU and is copied over to `<afu build dir>/build/platform/ofs_plat_if/rtl/ofs_plat_if.vh`. The 'ofs_plat_if' file typically contains the definition of the interface signals and parameters that connect the AFU to the PIM. This includes details about the data and control signals that the AFU and PIM use to communicate, such as clocks, host channels or local memory.

- PIM interfaces are defined in [base_ifcs](https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/base_ifcs) and copied over to `<afu build dir>/build/platform/ofs_plat_if/rtl/base_ifcs`.  This base interface classes tree is a collection of generic interface definitions (e.g. Avalon and AXI) and helper modules (e.g. clock crossing and pipeline stage insertion).

- PIM modules are defined in [ifcs_classes](https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/ifc_classes) and copied over to `<afu build dir>/build/platform/ofs_plat_if/rtl/ifc_classes`. The PIM-provided modules (aka shims) transform FIM interfaces to PIM interfaces.  On the AFU side of its shims, all PIM modules share common base AXI and Avalon interfaces.  The PIM modules are classified by the channels they support:
  - host_chan
  - local_memory
  - hssi
  - Other

- PIM utilities are defined in [utils](https://github.com/OFS/ofs-platform-afu-bbb/tree/master/plat_if_develop/ofs_plat_if/src/rtl/utils) and copied over to `<afu build dir>/build/platform/ofs_plat_if/rtl/utils`.  Utilities include primitive shims, such as FIFOs, memories, and reorder buffers.

## **3. Using PIM to interface with an AFU**

To interface the PIM with an AFU:

- Create top level module ofs_plat_afu.sv.
- For each Subsystem used by your AFU, create individual channel interfaces using your selected bus protocols and connect the channel PIM Shims based on selected bus protocols.
   - PCIe - Host Channel 
   - Local Memory
   - HSSI
- Tie off all unused channels/ports.
- Connect the channel interfaces to the AFU module.


### **3.1. Top Level Module - ofs_plaf_afu**

For a PIM based AFU, start with the required top level module, ofs_plat_afu, which has a single interface, ofs_plat_if, containing all the FIM connections.   It should include 'ofs_plat_if.vh' to ensure that the PIM resources are available.

```sh
`include "ofs_plat_if.vh"

//
// Top level PIM-based module.
//

module ofs_plat_afu
   (
    // All platform wires, wrapped in one interface.
    ofs_plat_if plat_ifc
    );
```
The SystemVerilog interface `ofs_plat_if` wraps all connections to the FIM's devices. The contents of `ofs_plat_if` may vary from device to device. Portability is maintained by conforming to standard naming conventions. `ofs_plat_if` is, itself, a collection of interface wrappers to groups of devices.  Each PCIe virtual or physical function is treated by the PIM as a separate channel.

For more information, refer to [PIM AFU Interface](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_AFU_interface.md)

### **3.2. Host Channel**

The host channel serves as the communication pathway between the host and the FPGA. It facilitates the exchange of commands, data, and control signals, allowing the host to interact with the FPGA and manage accelerated functions. 

For more information, refer to [PIM IFC Host Channel](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_host_channel.md)

#### **3.2.1. Create the host channel interfaces to the AFU**

The Host Memory interface is designed to facilitate the communication between the host and the FPGA as it allows the FPGA to access data stored in the host's main memory or to receive data from the host for processing.  

The Host Memory supported interface: 

- AVMM 
- AVMM-RDWR 
- AXI-MM

AXI-MM example:
```sh
ofs_plat_axi_mem_if
  #(
    `HOST_CHAN_AXI_MEM_PARAMS,
    .LOG_CLASS(ofs_plat_log_pkg::HOST_CHAN)
    )
host_mem();
```

The Memory-Mapped I/O (MMIO) allows the host to access and control specific registers or memory locations within the FPGA's address space. This interface is commonly used for configuring and interacting with hardware components through memory-mapped addresses.

The MMIO supported interface: 

- AVMM 
- AXI-Lite

AXI-Lite example:
```sh
ofs_plat_axi_mem_lite_if
  #(
    `HOST_CHAN_AXI_MMIO_PARAMS(64),
    .LOG_CLASS(ofs_plat_log_pkg::HOST_CHAN)
    )
    mmio64_to_afu();
```

#### **3.2.2. Connect the host channel to the PIM Shim**

Using the PIM Shim, host channel FIM interface is bridged over to the AFU's host memory interface and MMIO interface, making it usable for the AFU.

AXI example:
```sh
ofs_plat_host_chan_as_axi_mem_with_mmio primary_axi
       (
        .to_fiu(plat_ifc.host_chan.ports[0]),
        .host_mem_to_afu(host_mem),
        .mmio_to_afu(mmio64_to_afu),
 
        // These ports would be used if the PIM is told to cross to
        // a different clock. In this example, native pClk is used.
        .afu_clk(),
        .afu_reset_n()
        );
```

#### **3.2.3. Avalon Example**

The following examples show the steps for a Avalon MM interface:
```sh
    #Host memory	
    ofs_plat_avalon_mem_rdwr_if
      #(
        `HOST_CHAN_AVALON_MEM_RDWR_PARAMS,
        .LOG_CLASS(ofs_plat_log_pkg::HOST_CHAN)
        )
      host_mem();

    #MMIO
    ofs_plat_avalon_mem_if
      #(
        `HOST_CHAN_AVALON_MMIO_PARAMS(64),
        .LOG_CLASS(ofs_plat_log_pkg::HOST_CHAN)
        )
        mmio64_to_afu();
    
    #PIM Shim
    ofs_plat_host_chan_as_avalon_mem_rdwr_with_mmio primary_avalon
       (
        .to_fiu(plat_ifc.host_chan.ports[0]),
        .host_mem_to_afu(host_mem),
        .mmio_to_afu(mmio64_to_afu),

        .afu_clk(),
        .afu_reset_n()
        );

```

### **3.3. Local Memory**

Local memory is off-chip memory connected to an FPGA but not visible to the host as system memory.  Local memory is organized in groups and banks. Within a group, all banks have the same address and data widths.  

For more information, refer to [PIM IFC Local Memory](https://github.com/OFS/ofs-platform-afu-bbb/blob/master/plat_if_develop/ofs_plat_if/docs/PIM_ifc_local_mem.md)

#### **3.3.1. Create the local memory interfaces to the AFU**
  
The Local Memory supported interfaces: 

- AVMM 
- AXI-MM

AXI-MM example:
```sh
    ofs_plat_axi_mem_if
      #(
        `LOCAL_MEM_AXI_MEM_PARAMS_DEFAULT,
        .LOG_CLASS(ofs_plat_log_pkg::LOCAL_MEM),
        .BURST_CNT_WIDTH($clog2(MAX_BURST_SIZE/ofs_plat_host_chan_pkg::DATA_WIDTH_BYTES))
        )
      local_mem_to_afu[local_mem_cfg_pkg::LOCAL_MEM_NUM_BANKS]();
```


#### **3.3.2. Connect local memory to the PIM Shim**

Using the PIM Shim, the local memory FIM interface is bridged over to the AFU's local memory interface, making it usable for the AFU.

AXI example:
```sh
    genvar b;
    generate
        for (b = 0; b < local_mem_cfg_pkg::LOCAL_MEM_NUM_BANKS; b = b + 1)
        begin : mb
            ofs_plat_local_mem_as_axi_mem
              #(
                .ADD_CLOCK_CROSSING(1)
                )
              shim
               (
                .to_fiu(plat_ifc.local_mem.banks[b]),
                .to_afu(local_mem_to_afu[b]),

                .afu_clk(host_mem.clk),
                .afu_reset_n(host_mem.reset_n)
                );
        end
    endgenerate
```

#### **3.3.3. Avalon Example**

The following examples show the steps for a Avalon MM interface:
```sh
    ofs_plat_avalon_mem_if
      #(
        `LOCAL_MEM_AVALON_MEM_PARAMS_DEFAULT,
        .LOG_CLASS(ofs_plat_log_pkg::LOCAL_MEM)
        )
      local_mem_to_afu[local_mem_cfg_pkg::LOCAL_MEM_NUM_BANKS]();
 
    genvar b;
    generate
        for (b = 0; b < local_mem_cfg_pkg::LOCAL_MEM_NUM_BANKS; b = b + 1)
        begin : mb
            ofs_plat_local_mem_as_avalon_mem
              #(
                .ADD_CLOCK_CROSSING(1)
                )
              shim
               (
                .to_fiu(plat_ifc.local_mem.banks[b]),
                .to_afu(local_mem_to_afu[b]),
 
                .afu_clk(mmio64_to_afu.clk),
                .afu_reset_n(mmio64_to_afu.reset_n)
                );
        end
    endgenerate
```

### **3.4. High Speed Serial Interface (HSSI)**

The High-Speed Serial Interface enables high-speed serial communication between the FPGA and external devices. It's commonly used for tasks such as high-speed data streaming, interfacing with storage devices, or connecting to network components.

#### **3.4.1. Create the HSSI interfaces to the AFU**
  
The High-Speed Serial Interface enables high-speed serial communication between the FPGA and external devices. It's commonly used for tasks such as high-speed data streaming, interfacing with storage devices, or connecting to network components.

A vector of HSSI channels holds RX and TX AXI-S data interfaces. In addition to the data streams, each channel has a flow control interface on which pause requests are passed. Within a single channel, the RX, TX and pause interfaces share a clock. The clock is not guaranteed to be common across channels. The PIM provides only an AXI-S data option.

Note: Clock Crossing not supported, parameter and ports are there for standardization

```sh
     // HSSI Channels
     ofs_plat_hssi_channel_if
     #(
        // Log AXI transactions in simulation
        .LOG_CLASS(ofs_plat_log_pkg::HSSI)
      )
      hssi_to_afu[ofs_fim_eth_if_pkg::NUM_ETH_CHANNELS](); 

    genvar c;
    generate
        for (c = 0; c < ofs_fim_eth_if_pkg::NUM_ETH_CHANNELS; c = c + 1)
        begin : ch
                
            ofs_plat_hssi_as_axi_st  hssi_shim
               (
                .to_fiu(plat_ifc.hssi.channels[c]),
                .rx_st(hssi_to_afu[c].data_rx), // HSSI->AFU
                .tx_st(hssi_to_afu[c].data_tx), // AFU->HSSI
                .fc(hssi_to_afu[c].fc),         // Flow Control
                // These are present in all PIM interfaces, though not available with hssi.
                .afu_clk(),
                .afu_reset_n()
                );
        end
    endgenerate
```

### **3.5. Tie Off Unused ports**

In digital design, unused input ports can lead to unpredictable behavior. To prevent this, unused ports are "tied off" to a known state. Tie-offs are passed to the PIM as bit masks in parameters. The mask makes it possible to indicate, for example, that a single local memory bank is being driven.  

```sh
ofs_plat_if_tie_off_unused
  #(
    // Only using channel 0
    .HOST_CHAN_IN_USE_MASK(1)
    // Use two memory banks
    .LOCAL_MEM_IN_USE_MASK(3)
    // Use 4 HSSI channel
    .HSSI_IN_USE_MASK(15)
    )
    tie_off(plat_ifc);
```

### **3.6. AFU Instantiation**

Instantiate the AFU in ofs_plat_afu.sv and connect to the channel interfaces.  

```sh
    // =========================================================================
    //
    //   Instantiate the AFU.
    //
    // =========================================================================

    example_afu
       #(
        .NUM_LOCAL_MEM_BANKS(local_mem_cfg_pkg::LOCAL_MEM_NUM_BANKS),
	    .NUM_ETHERNET_CHANNELS(ofs_fim_eth_if_pkg::NUM_ETH_CHANNELS)
       )
       afu_inst
       (
        .mmio64_to_afu,
        .host_mem,
        .local_mem_to_afu,
        .hssi_to_afu
        );
```

## **4. AFU**

The AFU requires that each channel uses the interfaces supported by the PIM.   The below table shows the supported interfaces for each channel type.  The MMIO channel is the only channel required by the FIM, while all other channels are optional and can be tied off.  

| Channel        |  AXI-MM  | AXI-Lite | Avalon MM | Avalon MM Rd/Wr |  HSSI Channel  |
| -------------- |  ------  |  ------  | --------- | --------------- | -------------- |
| MMIO           |          |     X    |    X      |                 |                |
| Host Memory    |     X    |          |    X      |        X        |                |
| Local Memory   |     X    |          |    X      |                 |                |
| HSSI           |          |          |           |                 |         X      |

### **4.1. AFU top level module**

The AFU module should match the interfaces provided by the PIM. Including ofs_plat_if.vh in your module will bring in the base interface classes and channel interfaces:

```sh
`include "ofs_plat_if.vh"

module example_afu
  #(
    parameter NUM_LOCAL_MEM_BANKS = 2,
    parameter NUM_ETHERNET_CHANNELS = 2
    )
   (
    // CSR interface (MMIO on the host)
    ofs_plat_axi_mem_lite_if.to_source mmio64_to_afu,

    // Host memory (DMA)
    ofs_plat_axi_mem_if.to_sink host_mem_to_afu,

    // Local memory interface 
    ofs_plat_axi_mem_if.to_sink local_mem_to_afu[NUM_LOCAL_MEM_BANKS],
 
	// High Speed Serial Interface
   ofs_plat_hssi_channel_if hssi_to_afu [NUM_ETHERNET_CHANNELS]
    
    );
```

### **4.2. AFU Interfaces**

The AXI-MM and AXI-Lite interfaces are defined in the `<afu_build_dir>/build/platform/ofs_plat_if/rtl/base_ifcs/axi` directory.   

For AXI-MM and AXI-Lite, the handshaking signals (Ready and Valid) are separated from each of the interfaces (aw, w, b, ar, r). For example, the aw interface is defined as:
```sh
t_axi_mem_aw aw;
logic awvalid;
logic awready;
```

The Avalon MM interfaces are defined in the `<afu_build_dir>/build/platform/ofs_plat_if/rtl/base_ifcs/avalon` directory.  There are two Avalon MM interfaces, a traditional interface (ofs_plat_avalon_mem_if) with shared read and write operations and a split-bus interface (ofs_plat_avalon_mem_rdwr_if) which separates the read and write channels.

The HSSI Channel interface is defined in the `<afu_build_dir>/build/platform/ofs_plat_if/rtl/ifc_classes/hssi` directory.   The HSSI channel is comprised of three interfaces, RX AXIS, TX AXIS and flow control.  These interfaces are defined in `<afu_build dir>/build/ofs-common/src/fpga_family/<device family>/hssi_ss/inc/ofs_eth_fim_if.sv`.

Clock and Resets definition and header files are in the `<afu_build_dir>/build/platform/ofs_plat_if/rtl/base_ifcs/clocks` directory.  By default, each channel has its own associated clock and reset which is derived from it connected subsystem.  Using the ADD_CROSS_CLOCKING option with the PIM shims, allows the channels to all be on the same clock domain. 
```sh
    // Each interface names its associated clock and reset.
    logic afu_clk;
    assign afu_clk = mmio64_to_afu.clk;
    logic afu_reset_n;
    assign afu_reset_n = mmio64_to_afu.reset_n;
```

### **4.3. CSR Interface**
The MMIO is the only required channel for the AFU.   Besides providing a control and status interface for the AFU, the MMIO is required to have base registers as described in the [Device Feature List Overview](https://github.com/OFS/linux-dfl/blob/fpga-ofs-dev/Documentation/fpga/dfl.rst#device-feature-list-dfl-overview), which is used by the OPAE SW.    

When using the host channel, the Host creates shared buffers created between the Host CPU and FPGA.  The base address of these buffers should be passed to the AFU using the MMIO interface.  

### **4.4. Addressing**
The interface addressing depends on the interface's bus protocol, the below table shows the addressing based of interface.

| Interface     |  Addressing |
| ------------- |  ---------- | 
| AXI           |     Byte    |
| Avalon        |     Word    |

### **4.5. Replicating Interface Parameters**
When creating interfaces in the AFU, using \`OFS_PLAT_AXI_MEM_IF_REPLICATE_PARAMS or \`OFS_PLAT_AVALON_MEM_IF_REPLICATE_PARAMS allows the interface to have the same parameters as the channel interface. 

```sh
// The read ports will be connected to the read engine and the write ports unused.
// This will split the read channels from the write channels but keep
// a single interface type.
ofs_plat_axi_mem_if
  #(
  // Copy the configuration from host_mem
     `OFS_PLAT_AXI_MEM_IF_REPLICATE_PARAMS(host_mem)
    )
    host_mem_rd();
```

### **4.6. SystemVerilog Packages**

The AFU project provides System Verilog packages, which provide configuration details for the different channels.

The Host Channel and Local Memory System Verilog packages are included by default in the Quartus Project:

- Host Channel Package: ofs_plat_host_chan_pkg
    `<afu_build_dir>/build/platform/ofs_plat_if/rtl/ifc_classes/host_chan/afu_ifcs/include/ofs_plat_host_chan_pkg.sv`
- Local Memory Package: local_mem_cfg_pkg  
    `<afu_build_dir>/build/platform/ofs_plat_if/rtl/ifc_classes/local_mem/local_mem_cfg_pkg.sv`

The HSSI Channel System Verilog package is not included by default, therefore it needs to be imported:

- HSSI Channel Package: ofs_fim_eth_if_pkg  
    `<afu_build_dir>/build/ofs-common/src/fpga_family/agilex/hssi_ss/inc/ofs_fim_eth_if_pkg.sv`
```sh
import ofs_fim_eth_if_pkg::*;
```
 
## **5. Host Software Development**

The host application is used to control the AFU and manage data transfer between the host and the AFU. Refer to the [AFU Host Software Developer Guide](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/afu_dev/ug_dev_afu_host_software/ug_dev_afu_host_software/) for creating a host application.

## **6. Packaging the AFU**
Besides the RTL and software files, an AFU requires an Accelerator Description File and source list file.  These files are used during the build process.

### **6.1. Accelerator Description File**
The Accelerator Description File is a JSON file that describes the metadata associated with an AFU. The Open Programmable Accelerator Engine (OPAE) uses this metadata during reconfiguration. 

example_afu.json:
```sh
{
   "version": 1,
   "afu-image": {
      "power": 0,
      "clock-frequency-high": "auto",
      "clock-frequency-low": "auto",
      "afu-top-interface":
         {
            "class": "ofs_plat_afu"
	  },
      "accelerator-clusters":
         [
            {
               "name": "example_afu",
               "total-contexts": 1,
               "accelerator-type-uuid": "01234567-89ab-cdef-fedc-ba9876543210"
            }
         ]
   }
}
```

- power - Accelerator Function power consumption, in watts. Set to 0 for Intel ADP platforms.
- clock-frequency-high - Clock frequency for uclk_usr in MHz.  (optional)
- clock-frequency-low -  Clock frequency for uclk_usr_div2  in MHz. (optional)
- afu-top-interface:
  - class : Set to "ofs_plat_afu" for PIM based AFU, "afu_main" for native/hybrid AFU's.
- accelerator-clusters:
  - name : name of AFU
  - total-contexts : Set to '1'
 - accelerator-type-uuid : 128-bit Universally Unique Identifier (UUID) used to identify the AFU. 

The ASE and synthesis setup scripts call afu_json_mgr to create afu_json_info.vh:
```sh
//
// Generated by afu_json_mgr from …/hw/rtl/example_afu.json
//

`ifndef __AFU_JSON_INFO__
`define __AFU_JSON_INFO__

`define AFU_ACCEL_NAME "example_afu"
`define AFU_ACCEL_NAME0 "example_afu"
`define AFU_ACCEL_UUID 128'h01234567_89ab_cdef_fedc_ba9876543210
`define AFU_ACCEL_UUID0 128'h01234567_89ab_cdef_fedc_ba9876543210
`define AFU_IMAGE_POWER 0
`define AFU_TOP_IFC "ofs_plat_afu"

`endif // __AFU_JSON_INFO__
```

The Makefile calls the afu_json_mgr to create afu_json_info.h:
```sh
//
// Generated by afu_json_mgr from ../hw/rtl/example_afu.json
//
#ifndef __AFU_JSON_INFO__
#define __AFU_JSON_INFO__
#define AFU_ACCEL_NAME " example_afu "
#define AFU_ACCEL_NAME0 " example_afu "
#define AFU_ACCEL_UUID "01234567-89AB-CDEF-FEDC-BA9876543210"
#define AFU_ACCEL_UUID0 "01234567-89AB-CDEF-FEDC-BA9876543210"
#define AFU_IMAGE_POWER 0
#define AFU_TOP_IFC "ofs_plat_afu"
#endif // __AFU_JSON_INFO__
```

### **6.2. Source List File**
The source list file is used by the ASE and synthesis setup scripts to build the AFU project.  It should include the accelerator description file and RTL source files.   The file paths are relative to the source list file location.

example sources.txt:
```sh
# Paths are relative to sources.txt file

# Accelerator Descriptor File
example_afu.json

# Top level module
ofs_plat_afu.sv

# RTL
example_afu.sv
example_afu_csr.sv
accelerator.sv
dma_engine.sv

# Pointer to software - Information only
# ../../sw/example_afu.c
```

### **6.3. Directory Structure**
Below is an example directory structure:

```sh
example_afu
|-- hw
|   |-_ rtl
|       |-- example_afu.json 
|       |-- sources.txt
|       |-- ofs_plat_afu.sv
|       |-- example_afu.sv 
|       |-- example_afu_csr.sv 
|       |-- accelerator.sv 
|       |-- dma_engine.sv
|--  sw
    |-- example_afu.c
    |-- Makefile
```





## Notices & Disclaimers

Altera® Corporation technologies may require enabled hardware, software or service activation. No product or component can be absolutely secure. Performance varies by use, configuration and other factors. Your costs and results may vary. You may not use or facilitate the use of this document in connection with any infringement or other legal analysis concerning Altera or Intel products described herein. You agree to grant Altera Corporation a non-exclusive, royalty-free license to any patent claim thereafter drafted which includes subject matter disclosed herein. No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document, with the sole exception that you may publish an unmodified copy. You may create software implementations based on this document and in compliance with the foregoing that are intended to execute on the Altera or Intel product(s) referenced in this document. No rights are granted to create modifications or derivatives of this document. The products described may contain design defects or errors known as errata which may cause the product to deviate from published specifications. Current characterized errata are available on request. Altera disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade. You are responsible for safety of the overall system, including compliance with applicable safety-related requirements or standards. © Altera Corporation. Altera, the Altera logo, and other Altera marks are trademarks of Altera Corporation. Other names and brands may be claimed as the property of others.

OpenCL* and the OpenCL* logo are trademarks of Apple Inc. used by permission of the Khronos Group™.
