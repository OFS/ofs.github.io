The Agilex® 7 FPGA F-Series Development Kit (2x F-Tile) has an on-board FPGA Download Cable II module which is used to program the FPGA via JTAG.

Perform the following steps to establish a JTAG connection with the fseries-dk.

Pre-requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [Getting Started Guide: OFS for Agilex® 7 PCIe Attach FPGAs (F-Series Development Kit (2xF-Tile))] for instructions on setting up a deployment environment.

* This walkthrough requires a workstation with Quartus Prime Pro Version 24.1 tools installed, specifically the `jtagconfig` tool.

Steps:

1. Refer to the following figure for Steps 2 and 3.

  ![agilex_ftile_dev_kit](images/agilex_ftile_dev_kit.png)

2. Locate Single DIP Switch **SW2** and 4-position DIP switch **SW3** on the fseries-dk. These switches control the JTAG setup for the board. Ensure that both **SW2** and **SW3.3** are set to `ON`.

3. Locate the **J10** Micro-USB port on the fseries-dk. Connect a Micro-USB to USB-A cable between the **J10** port and the workstation that has Quartus Prime Pro tools installed.

4. Use the `jtagconfig` tool to check that the JTAG chain contains the AGFB027R24C2E2VR2 device.

    ```bash
    <QUARTUS_INSTALL_DIR>/24.1/quartus/bin/jtagconfig
    ```

    Example expected output:

    ```bash
    1) Agilex F-Series FPGA Dev Kit [1-6]
    0343B0DD   AGFB027R24C(.|R2|R0)/..
    020D10DD   VTAP10
    ```

This concludes the walkthrough for establishing a JTAG connection on the fseries-dk.