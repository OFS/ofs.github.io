**Intel ${{ env.QUARTUS_PRO_VER_L }}** is verified to work with the latest OFS release ${{ env.OFS_FIM_RELEASE }}.  However, you have the option to port and verify the release on newer versions of Intel Quartus Prime Pro software.

Use ${{ env.HOST_OS_L }} for compatibility with your development flow and also testing your FIM design in your platform. 

Prior to installing Quartus:

1. Ensure you have sufficient free disk space for Quartus Prime Pro installation and your development work.

  * The disk space may be significantly more based on the device families included in the install. Prior to installation, the disk space should be enough to hold both zipped tar files and uncompressed installation files. After successful installation, delete the downloaded zipped files and uncompressed zip files to release the disk space.

2. Ensure you have sufficient RAM available for OFS compilations with Quartus

  * It is recommended you have at least 128 GB of RAM to compile OFS designs.

3. Perform the following steps to satisfy the required dependencies.

  ```bash
  $ sudo dnf install -y gcc gcc-c++ make cmake libuuid-devel rpm-build autoconf automake bison boost boost-devel libxml2 libxml2-devel make ncurses grub2 bc csh flex glibc-locale-source libnsl ncurses-compat-libs 
  ```

  Apply the following configurations.

  ```bash
  $ sudo localedef -f UTF-8 -i en_US en_US.UTF-8 
  $ sudo ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5 
  $ sudo ln -s /usr/bin/python3 /usr/bin/python
  ```

4. Create the default installation path: <home directory>/intelFPGA_pro/<version number>, where <home directory> is the default path of the Linux workstation, or as set by the system administrator and <version> is your Quartus version number.

  The installation path must satisfy the following requirements:

  * Contain only alphanumeric characters
  * No special characters or symbols, such as !$%@^&*<>,
  * Only English characters
  * No spaces

5. Download your required Quartus Prime Pro Linux version [here](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime/resource.html).

6. After running the Quartus Prime Pro installer, set the PATH environment variable to make utilities `quartus`, `jtagconfig`, and `quartus_pgm` discoverable. Edit your bashrc file `~/.bashrc` to add the following line:

  ```bash
  export PATH=<Quartus install directory>/quartus/bin:$PATH
  export PATH=<Quartus install directory>/qsys/bin:$PATH
  ```

  For example, if the Quartus install directory is /home/intelFPGA_pro/${{ env.QUARTUS_PRO_VER_S }} then the new line is:

  ```bash
  export PATH=/home/intelFPGA_pro/${{ env.QUARTUS_PRO_VER_S }}/quartus/bin:$PATH
  export PATH=/home/intelFPGA_pro/${{ env.QUARTUS_PRO_VER_S }}/qsys/bin:$PATH
  ```

7. Verify, Quartus is discoverable by opening a new shell:

  ```
  $ which quartus
  /home/intelFPGA_pro/${{ env.QUARTUS_PRO_VER_S }}/quartus/bin/quartus
  ```

