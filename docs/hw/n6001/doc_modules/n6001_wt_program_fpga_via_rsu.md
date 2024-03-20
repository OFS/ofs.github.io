This walkthrough describes the steps to program the Agilex FPGA on the Intel® FPGA SmartNIC N6001-PL with a `BIN` image via JTAG.

Pre-Requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [Getting Started Guide: OFS for Agilex® 7 PCIe Attach FPGAs (Intel® FPGA SmartNIC N6001-PL/N6000-PL)] for instructions on setting up a deployment environment.

* This walkthrough requires a `BIN` image which will be programmed to the Agilex FPGA. Refer to the [Walkthrough: Compile OFS FIM] Section for step-by-step instructions for generating a `BIN` image. The image used for programming must be formatted with PACsign before programming. This is done automatically by the build script.

* This walkthrough requires a JTAG connection to the n6001. Refer to the [Walkthrough: Set up JTAG] section for step-by-step instructions.

* This walkthrough requires a Full Quartus Installation or Standalone Quartus Prime Programmer & Tools running on the machine where the Intel® FPGA SmartNIC N6001-PL is connected via JTAG.

Steps:

1. Start in your deployment environment.

2. Determine the PCIe B:D.F of the card using OPAE command `fpgainfo fme`. In this example, the PCIe B:D.F is `B1:00.0`.

  ```bash
  fpgainfo fme
  ```

  Example output:

  ```bash
  Intel Acceleration Development Platform N6001
  Board Management Controller NIOS FW version: 3.15.0
  Board Management Controller Build version: 3.15.0
  PBA: B#FB2CG1@AGF14-A0P2
  MMID: 217000
  SN: Q171211700050
  //****** FME ******//
  Interface                        : DFL
  Object Id                        : 0xEF00000
  PCIe s:b:d.f                     : 0000:98:00.0
  Vendor Id                        : 0x8086
  Device Id                        : 0xBCCE
  SubVendor Id                     : 0x8086
  SubDevice Id                     : 0x1771
  Socket Id                        : 0x00
  Ports Num                        : 01
  Bitstream Id                     : 00x50102023508A422 (TBD)
  Bitstream Version                : 5.0.1
  Pr Interface Id                  : 1d6beb4e-86d7-5442-a763-043701fb75b7 (TBD)
  Boot Page                        : user1
  Factory Image Info               : 9035190d637c383453173deb5de25fdd
  User1 Image Info                 : 893e691edfccfd0aecb1c332ad69551b
  User2 Image Info                 : 8cd2ae8073e194525bcd682f50935fc7
  ```

3. Use the OPAE `fpgasupdate` command to program a PACsign signed image to flash. The flash slot which will be programmed is determined by the PACsign header.

  ```bash
  sudo fpgasupdate <IMAGE> <PCIe B:D.F>
  ```

  * Example: update User Image 1 in flash

    ```bash
    sudo fpgasupdate ofs_top_page1_unsigned_user1.bin 98:00.0
    ```

  * Example: update User Image 2 in flash

    ```bash
    sudo fpgasupdate ofs_top_page2_unsigned_user2.bin 98:00.0
    ```

  * Example: update Factory Image in flash

    ```bash
    sudo fpgasupdate ofs_top_page0_unsigned_factory.bin 98:00.0
    ```

4. Use the OPAE `rsu` command to reconfigure the FPGA with the new image. You may select which image to configure from (User 1, User 2, Factory).

  ```bash
  sudo rsu fpga --page <PAGE> <PCIe B:D.F>
  ```

  * Example: configure FPGA with User 1 Image

    ```bash
    sudo rsu fpga --page user1 98:00.0
    ```

  * Example: configure FPGA with User 2 Image

    ```bash
    sudo rsu fpga --page user2 98:00.0
    ```

  * Example: configure FPGA with Factory Image

    ```bash
    sudo rsu fpga --page factory 98:00.0
    ```