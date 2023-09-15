Perform the following steps to set up a JTAG connection to the Intel® FPGA SmartNIC N6001-PL.

Pre-requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [OFS Agilex PCIe Attach Getting Started Guide] for instructions on setting up a deployment environment.

* This walkthrough requires a workstation with Quartus Prime Pro Version 23.2 tools installed, specifically the `jtagconfig` tool.

* This walkthrough requires an [Intel FPGA Download Cable II].

Steps:

1. Set the board switches to dynamically select either the Intel® Agilex® 7 FPGA or MAX® 10 device on the JTAG chain.

   1. Set SW1.1=ON as shown in the next image. The switches are located at the back of the Intel® FPGA SmartNIC N6001-PL.

   ![](images/n6000_sw2_position_0_for_agilex_jtag.png)

2. The Intel® FPGA SmartNIC N6001-PL has a 10 pin JTAG header on the top side of the board. Connect an Intel® FPGA Download II Cable to the JTAG header of the Intel® FPGA SmartNIC N6001-PL as shown in picture below. This picture shows the Intel® FPGA SmartNIC N6001-PL card installed in the middle bay, top slot of a SuperMicro® SYS-220HE-FTNR server where the lower slot does not have card installed allowing the Intel® Download II cables to pass through removed the slot access. 

  ![](images/n6000_jtag_connection.png)

  >**Note:** If using the Intel FGPA download Cable on Linux, add the udev rule as described in [Intel FPGA Download Cable Driver for Linux].

3. Set the JTAG chain to select the Intel® Agilex® 7 FPGA as the target by writing to the JTAG enable register in the BMC (Register `0x378`). This is done via PMCI registers `0x2040C` and `0x20400`.

  >**Note:** The commands below are targeted to a board with PCIe B:D.F of 98:00.0. Use the correct PCIe B:D.F of your card.

  ```bash
  sudo opae.io init -d 0000:98:00.0 $USER
  sudo opae.io -d 0000:98:00.0 -r 0 poke 0x2040c 0x100000000
  sudo opae.io -d 0000:98:00.0 -r 0 poke 0x20400 0x37800000002
  sudo opae.io release -d 0000:98:00.0
  ```

  >**Note:** To later re-direct the JTAG back to the MAX 10 device, execute the following commands.

  ```bash
  sudo opae.io init -d 0000:b1:00.0 $USER
  sudo opae.io -d 0000:b1:00.0 -r 0 poke 0x2040c 0x000000000
  sudo opae.io -d 0000:b1:00.0 -r 0 poke 0x20400 0x37800000002
  sudo opae.io release -d 0000:b1:00.0
  ```

  Optionally, rather than dynamically commanding Intel® Agilex® 7 FPGA/MAX10 selection with the PMCI register settings, you can fix the selection with the following switch settings shown in the table below:

  | SW1.1 | SW2  | JTAG Target                                                  |
  | ----- | ---- | ------------------------------------------------------------ |
  | OFF   | OFF  | Intel® Agilex® 7 FPGA                                             |
  | OFF   | ON   | MAX® 10 FPGA                                                 |
  | ON    | X    | Intel® Agilex® 7 FPGA if BMC register `0x378=0x1` |
  | ON    | X    | MAX® 10 FPGA if BMC register `0x378=0x0` |

4. Use the `jtagconfig` tool to check that the JTAG chain contains the AGFB014R24A2E2V device.

  ```bash
  <QUARTUS_INSTALL_DIR>/23.2/quartus/bin/jtagconfig
  ```

  Example expected output:

  ```bash
  TBD
  ```