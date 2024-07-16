This walkthrough guides you through the process of setting up your development environment in preparation for FIM development. This flow only needs to be done once on your development machine.

1. Ensure that ${{ env.QUARTUS_PRO_VER_L }} for Linux with Intel Agilex FPGA device support is installed on your development machine. Refer to the [Walkthrough: Install Quartus Prime Pro Software] section for step-by-step installation instructions.

  1. Verify version number

      ```bash
      quartus_sh --version
      ```

      Example Output:

      ```bash
      Quartus Prime Shell
      Version ${{ env.QUARTUS_PRO_VER_S }} SC Pro Edition
      Copyright (C) 2024  Intel Corporation. All rights reserved.
      ```

2. Ensure that all support tools are installed on your development machine, and that they meet the version requirements.

  1. Python ${{ env.PYTHON_VER }} or later

    1. Verify version number

      ```bash
      python --version
      ```

      Example Output:

      ```bash
      Python ${{ env.PYTHON_VER }}
      ```

  2. GCC ${{ env.GCC_VER }} or later
    1. Verify version number

      ```bash
      gcc --version
      ```

      Example output:

      ```bash
      gcc (GCC) ${{ env.GCC_VER }}
      ```

  3. cmake ${{ env.CMAKE_VER }} or later
    1. Verify version number

      ```bash
      cmake --version
      ```

      Example output:

      ```bash
      cmake version ${{ env.CMAKE_VER }}
      ```

  4. git ${{ env.GIT_VER }} or later.

    1. Verify version number

      ```bash
      git --version
      ```

      Example output:

      ```bash
      git version ${{ env.GIT_VER }}
      ```

3. Clone the ${{ env.OFS_FIM_REPO }} repository. Refer to the [Walkthrough: Clone FIM Repository] section for step-by-step instructions.

4. Install UART IP license patch `.02`.

  1. Navigate to the `license` directory

    ```bash
    cd $IOFS_BUILD_ROOT/license
    ```

  2. Install Patch 0.02

    ```bash
    sudo ./quartus-0.0-0.02iofs-linux.run
    ```

5. Install Quartus Patches ${{ env.QUARTUS_PATCHES }}. All required patches are provided in the **Assets** of the OFS FIM Release: ${{ env.OFS_FIM_RELEASE_PAGE_URL }}

6. Verify that patches have been installed correctly. They should be listed in the output of the following command.

  ```bash
  quartus_sh --version
  ```

5. Set required environment variables. Refer to the [Walkthrough: Set Environment Variables] section for step-by-step instructions.

This concludes the walkthrough for setting up your development environment. At this point you are ready to begin FIM development.