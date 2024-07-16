# Documentation Overview for Agilex 7 SoC Attach Reference Designs

Use this page as a guide to understand how to navigate the documentation depending on your role:

| Document | Description | Board Developer | Shell Developer | Workload Developer | Software Developer |
|:------:|:------------|:----------:|:-------------:|:-----------------:|:---------------:|
|[Board Installation Guide: OFS For Agilex® 7 SoC Attach IPU F2000X-PL](https://ofs.github.io/ofs-2024.2-1/hw/common/board_installation/f2000x_board_installation/f2000x_board_installation) | Describes how to install the Intel FPGA IPU F2000X-PL Platform in a server with required cabling and configure BIOS | X | X | | |
|[Software Installation Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/common/sw_installation/soc_attach/sw_install_soc_attach)| Provides steps for installing Linux kernel packages and OPAE software development kit package| X | | X | X |
| [Getting Started Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/user_guides/ug_qs_ofs_f2000x/ug_qs_ofs_f2000x/)| Provides steps for loading a pre-packaged SoC attach shell binary unto the Intel FPGA IPU F2000x-PL and using the OPAE user space tools  |  | X | X |  |
|[Automated Evaluation User Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/user_guides/ug_eval_ofs/ug_eval_script_ofs_f2000x/) | Describes how to use provided automated script to step through setup, build flows, simulation and OneAPI tasks.  Script can be leveraged for your own custom builds. |  | X | X |  |
| [Shell Technical Reference Manual: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/reference_manuals/ofs_fim/mnl_fim_ofs/)| Describes features and functions of the provided Agilex 7 SoC Attach Reference design  |  | X |  |  |
| [Shell Developer Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/) | Provides explanation of the shell reference design targeting the Intel FPGA IPU F2000X-PL Platform and steps for building and modifying the design |  | X | | |
| [UVM Simulation User Guide: OFS for Agilex® 7 SoC Attach](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/user_guides/ug_sim_ofs/ug_sim_ofs/) | Describes how to use the provided UVM environment files and test suite to simulate the default reference designs |  | X |  |  |
| [Workload Developer Guide: OFS for Agilex® 7 SoC Attach FPGAs](https://ofs.github.io/ofs-2024.2-1/hw/f2000x/dev_guides/afu_dev/ug_dev_afu_ofs_f2000x/)| Describes how to build, test and debug an example workload for a SoC attach shell. | | | X | |
| [PIM Based AFU Developer Guide](https://ofs.github.io/ofs-2024.2-1/hw/common/user_guides/afu_dev/ug_dev_pim_based_afu/ug_dev_pim_based_afu/) | Describes how to create a an AFU/workload using the Platform Interface Manager (PIM) shims |  |  | X |  |
| [AFU Simulation Environment User Guide](https://ofs.github.io/ofs-2024.2-1/hw/common/user_guides/afu_dev/ug_dev_afu_sim_env/ug_dev_afu_sim_env/) | Provides steps for using the AFU Simulation Environment for hardware/software co-simulation of your workload|  |  | X |  |
[Software Reference Manual: Open FPGA Stack](https://ofs.github.io/ofs-2024.2-1/hw/common/reference_manual/ofs_sw/mnl_sw_ofs/)| Provides details of OPAE SDK user-space software stack and the kernel-space linux-dfl drivers |   |   |  | X  |
| [KVM User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2024.2-1/hw/common/user_guides/ug_kvm/ug_kvm/) | Describes how to setup and configure a virtual machine in an OFS-enabled design |  |  | X | X |
|[Docker User Guide: Open FPGA Stack](https://ofs.github.io/ofs-2024.2-1/hw/common/user_guides/ug_docker/ug_docker/)| Provides steps for implementing a docker container to evaluate and develop with OFS |  |  X  |  X  | X |
| **Document** | **Description** |**Board Developer** | **Shell Developer** |**Workload Developer** | **Software Developer** |

<!-- include ./docs/hw/doc_modules/links.md -->


