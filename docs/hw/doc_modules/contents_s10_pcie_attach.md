# Documentation Overview for Stratix 10 PCIe Attach Reference Designs

Use this page as a guide to understand how to navigate the documentation depending on your role:

| Document | Description | Board Developer | Shell Developer | Workload Developer | Software Developer |
|:------:|:------------|:----------:|:-------------:|:-----------------:|:---------------:|
|[Board Installation Guide: OFS for Acceleration Development Platforms](https://ofs.github.io/ofs-2024.3-1/hw/common/board_installation/adp_board_installation/adp_board_installation_guidelines) | Describes how to install the Intel FPGA PAC D5005 Platform in a server with required cabling and configure BIOS | X | X | | |
|[Software Installation Guide: OFS for PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.3-1/hw/common/sw_installation/pcie_attach/sw_install_pcie_attach)| Provides steps for installing Linux kernel packages and OPAE software development kit package| X | | X | X |
|[Getting Started Guide: OFS for Stratix 10® FPGA PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.3-1/hw/d5005/user_guides/ug_qs_ofs_d5005/ug_qs_ofs_d5005/)| Provides steps for loading a pre-packaged shell binary unto the Intel FPGA PAC D5005 platform and using the OPAE user space tools  |  | X | X |  |
| [Automated Evaluation User Guide: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.3-1/hw/d5005/user_guides/ug_eval_ofs_d5005/ug_eval_script_ofs_d5005/) | Describes how to use provided automated script to step through setup, build flows, simulation and OneAPI tasks.  Script can be leveraged for your own custom builds. |  | X | X |  |
| [Shell Technical Reference Manual: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.3-1/hw/d5005/reference_manuals/ofs_fim/mnl_fim_ofs_d5005/)| Provides explanation of the SoC attach shell reference design targeting the Intel FPGA PAC D5005 Platform and steps for building and modifying the design |  | X | | |
| [UVM Simulation User Guide: OFS for Stratix® 10 PCIe Attach](https://ofs.github.io/ofs-2024.3-1/hw/d5005/user_guides/ug_sim_ofs_d5005/ug_sim_ofs_d5005/)| Describes how to use the provided UVM environment files and test suite to simulate the default reference designs |  | X |  |  |
| [Workload Developer Guide: OFS for Stratix® 10 PCIe Attach FPGAs](https://ofs.github.io/ofs-2024.3-1/hw/d5005/dev_guides/afu_dev/ug_dev_afu_d5005/)| Describes how to build, test and debug an example workload for a PCIe attach shell. | | | X | |
| [PIM Based AFU Developer Guide](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/ug_dev_pim_based_afu/) | Describes how to create a an AFU/workload using the Platform Interface Manager (PIM) shims |  |  | X |  |
| [AFU Simulation Environment User Guide](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/afu_dev/ug_dev_afu_sim_env/ug_dev_afu_sim_env/) | Provides steps for using the AFU Simulation Environment for hardware/software co-simulation of your workload|  |  | X |  |
| [oneAPI Accelerator Support Package (ASP): Getting Started User Guide](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/oneapi_asp/ug_oneapi_asp/)| Provides steps to use and test with the default OneAPI Accelerator Support Package |  |  | X |  |
| [oneAPI Accelerator Support Package(ASP) Reference Manual: Open FPGA Stack](https://ofs.github.io/ofs-2024.3-1/hw/common/reference_manual/oneapi_asp/oneapi_asp_ref_mnl/)| Provides details about the hardware and software components required for enabling OneAPI in OFS designs. |  |  | X |  |
[Software Reference Manual: Open FPGA Stack](https://ofs.github.io/ofs-2024.3-1/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/)| Provides details of OPAE SDK user-space software stack and the kernel-space linux-dfl drivers |   |   |  | X  |
| [KVM User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/ug_kvm/ug_kvm/) | Describes how to setup and configure a virtual machine in an OFS-enabled design |  |  | X | X |
|[Docker User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2024.3-1/hw/common/user_guides/ug_docker/ug_docker/)| Provides steps for implementing a docker container to evaluate and develop with OFS |  |  X  |  X  | X |
| **Document** | **Description** |**Board Developer** | **Shell Developer** |**Workload Developer** | **Software Developer** |

