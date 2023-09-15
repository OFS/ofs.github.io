Perform the following steps to compile a FIM for where the exercisers are removed and replaced with an he_null module while keeping the PF/VF multiplexor connections.

Pre-requisites:

* This walkthrough requires a development environment. Refer to the [Walkthrough: Set Up Development Environment] Section for instructions on setting up a development environment.

Steps:

1. Clone the FIM repository (or use an existing cloned repository). Refer to the [Walkthrough: Clone FIM Repository] section for step-by-step instructions.

2. Set development environment variables. Refer to the [Walkthrough: Set Development Environment Variables] section for step-by-step instructions.

3. Compile the FIM with the HE_NULL compile options

  ```bash
  cd $OFS_ROOTDIR

  ./ofs-common/scripts/common/syn/build_top.sh -p --ofss tools/ofss_config/${{ env.MODEL }}.ofss ${{ env.MODEL }}:null_he_lb,null_he_hssi,null_he_mem,null_he_mem_tg work_${{ env.MODEL }}
  ```