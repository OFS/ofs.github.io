This walkthrough describes the steps to program the Agilex FPGA on the Agilex™ 7 FPGA F-Series Development Kit (2x F-Tile) with a `SOF` image via JTAG.

Pre-Requisites:

* This walkthrough requires an OFS Agilex PCIe Attach deployment environment. Refer to the [Getting Started Guide: OFS for Agilex™ 7 PCIe Attach FPGAs (F-Series Development Kit (2xF-Tile))))](https://ofs.github.io/ofs-2023.2/hw/ftile_devkit/user_guides/ug_qs_ofs_ftile/ug_qs_ofs_ftile/) for instructions on setting up a deployment environment.

* This walkthrough requires a `SOF` image which will be programmed to the Agilex FPGA. Refer to the [Walkthrough: Compile OFS FIM] Section for step-by-step instructions for generating a `SOF` image.

* This walkthrough requires a JTAG connection to the fseries-dk. Refer to the [Walkthrough: Set up JTAG] section for step-by-step instructions.

* This walkthrough requires a Full Quartus Installation or Standalone Quartus Prime Programmer & Tools running on the machine where the Agilex™ 7 FPGA F-Series Development Kit (2x F-Tile) is connected via JTAG.

Steps:

1. Start in your deployment environment.

2. If the card is already programmed with an OFS enabled design, determine the PCIe B:D.F of the card using OPAE command `fpgainfo fme`. In this example, the PCIe B:D.F is `B1:00.0`.

  ```bash
  sudo fpgainfo fme
  ```

  Example output:

  ```bash
  Intel Acceleration Development Platform N6001
  board_n6000.c:306:read_bmcfw_version() **ERROR** : Failed to get read object
  board_n6000.c:482:print_board_info() **ERROR** : Failed to read bmc version
  board_n6000.c:332:read_max10fw_version() **ERROR** : Failed to get read object
  board_n6000.c:488:print_board_info() **ERROR** : Failed to read max10 version
  Board Management Controller NIOS FW version:
  Board Management Controller Build version:
  //****** FME ******//
  Interface                        : DFL
  Object Id                        : 0xEF00001
  PCIe s:b:d.f                     : 0000:B1:00.0
  Vendor Id                        : 0x8086
  Device Id                        : 0xBCCE
  SubVendor Id                     : 0x8086
  SubDevice Id                     : 0x1771
  Socket Id                        : 0x00
  Ports Num                        : 01
  Bitstream Id                     : 0x5010202A8769764
  Bitstream Version                : 5.0.1
  Pr Interface Id                  : b541eb7c-3c7e-5678-a660-a54f71594b34
  Boot Page                        : N/A
  ```

  >**Note:** The errors related to the BMC are the result of the OFS BMC not being present on the fseries-dk design. These will be removed in a future release.

3. Remove the card from PCIe prior to programming. This will disable AER for the PCIe root port to prevent a surprise link-down event during programming.

  ```bash
  sudo pci_device b1:00.0 unplug
  ```

4. Switch to the machine with JTAG connection to the fseries-dk, if different than your deployment machine.

5. Open the Quartus programmer GUI

  ```bash
  quartus_pgmw
  ```

  ![quartus_pgmw](/ofs-2024.3-1/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw.png)

1. Click **Hardware Setup** to open the Hardware Setup dialog window.

  1. In the **Currently selected hardware** field select the fseries-dk.

  2. In the **Hardware frequency** field enter `16000000` Hz

      ![quartus_pgmw_hardware_setup](/ofs-2024.3-1/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_hardware_setup.png)

  3. Click **Close**

2. In the **Quartus Prime Programmer** window, click **Auto Detect**.

3. If prompted, select the AGFB027R24C2E2VR2 device. The JTAG chain should show the device.

  ![quartus_pgmw_device_chain](/ofs-2024.3-1/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_device_chain.png)

9. Right click the AGFB027R24C2E2VR2 row and selct **Change File**.

  ![quartus_pgmw_change_file](/ofs-2024.3-1/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_change_file.png)

1.  In the **Select New Programming File** window that opens, select  `ofs_top_hps.sof` and click **Open**.

2.  Check the **Program/Configure** box for the AGFB027R24C2E2VR2 row, then click **Start**. Wait for the **Progress** bar to show `100% (Success)`.

  ![quartus_pgmw_success](/ofs-2024.3-1/hw/ftile_devkit/dev_guides/fim_dev/images/quartus_pgmw_success.png)

12. Close the Quartus Programmer GUI.

13. Switch to the deployment environment, if different than the JTAG connected machine.

14. Replug the board PCIe

  ```bash
  sudo pci_device b1:00.0 plug
  ```

15. Run `fpgainfo fme` to verify communication with the board, and to check the PR Interface ID.

  ```bash
  Intel Acceleration Development Platform N6001
  board_n6000.c:306:read_bmcfw_version() **ERROR** : Failed to get read object
  board_n6000.c:482:print_board_info() **ERROR** : Failed to read bmc version
  board_n6000.c:332:read_max10fw_version() **ERROR** : Failed to get read object
  board_n6000.c:488:print_board_info() **ERROR** : Failed to read max10 version
  Board Management Controller NIOS FW version:
  Board Management Controller Build version:
  //****** FME ******//
  Interface                        : DFL
  Object Id                        : 0xEF00001
  PCIe s:b:d.f                     : 0000:B1:00.0
  Vendor Id                        : 0x8086
  Device Id                        : 0xBCCE
  SubVendor Id                     : 0x8086
  SubDevice Id                     : 0x1771
  Socket Id                        : 0x00
  Ports Num                        : 01
  Bitstream Id                     : 360571656009101231
  Bitstream Version                : 5.0.1
  Pr Interface Id                  : 5a2d5e39-7ef2-58f8-b0b9-a737303ab4ab
  Boot Page                        : N/A
  ```

  >**Note:** The errors related to the BMC are the result of the OFS BMC not being present on the fseries-dk design. These will be removed in a future release.