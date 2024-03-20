[release notes]: https://github.com/OFS/ofs-agx7-pcie-attach/releases/tag/ofs-2024.1-1

[Shell Technical Reference Manual: OFS for Agilex® 7 PCIe Attach FPGAs]: https://ofs.github.io/ofs-2024.1-1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/
[Ethernet Subsystem Intel FPGA IP User Guide]: https://www.intel.com/content/www/us/en/docs/programmable/773413/23-4-24-0-0/introduction.html
[Memory Subsystem Intel FPGA IP User Guide for Intel Agilex OFS]: https://www.intel.com/content/www/us/en/docs/programmable/789391/23-4-1-0-1/f-series-and-i-series-fpga-memory-subsystem-61448.html
[PCIe Subsystem Intel FPGA IP User Guide for Intel Agilex OFS]: https://ofs.github.io/ofs-2024.1-1/hw/common/user_guides/ug_qs_pcie_ss.pdf

[Analyzing and Optimizing the Design Floorplan]: https://www.intel.com/content/www/us/en/docs/programmable/683641/21-4/analyzing-and-optimizing-the-design-03170.html "Analyzing and Optimizing the Design Floorplan"

[Partial Reconfiguration Design Flow - Step 3 - Floorplan the Design]: https://www.intel.com/content/www/us/en/docs/programmable/683834/21-4/step-3-floorplan-the-design.html


[Introduction]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1-introduction
[About This Document]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#11-about-this-document
[Knowledge Pre-Requisites]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#111-knowledge-pre-requisites
[FIM Development Theory]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#12-fim-development-theory
[Default FIM Features]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#121-default-fim-features
[Top Level]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1211-top-level
[Interfaces]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1212-interfaces
[Subsystems]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1213-subsystems
[Host Exercisers]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1214-host-exercisers
[Module Access via APF/BPF]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1215-module-access-via-apf-bpf
[Customization Options]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#122-customization-options
[Development Environment]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#13-development-environment
[Development Tools]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#131-development-tools
[Install Quartus Prime Pro Software]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1311-walkthrough-install-quartus-prime-pro-software
[Install Git Large File Storage Extension]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1312-walkthrough-install-git-large-file-storage-extension
[FIM Source Files]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#132-fim-source-files
[Clone FIM Repository]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1321-walkthrough-clone-fim-repository
[Environment Variables]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#133-environment-variables
[Set Development Environment Variables]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#1331-walkthrough-set-development-environment-variables
[Set Up Development Environment]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#134-walkthrough-set-up-development-environment
[FIM Compilation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2-fim-compilation
[Compilation Theory]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#21-compilation-theory
[FIM Build Script]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#211-fim-build-script
[OFSS File Usage]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#212-ofss-file-usage
[Platform OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2121-platform-ofss-file
[OFS IP OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2122-ofs-ip-ofss-file
[PCIe IP OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2123-pcie-ip-ofss-file
[IOPLL IP OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2124-iopll-ip-ofss-file
[Memory IP OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2125-memory-ip-ofss-file
[HSSI IP OFSS File]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2126-hssi-ip-ofss-file
[OFS Build Script Outputs]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#213-ofs-build-script-outputs
[Compilation Flows]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#22-compilation-flows
[Flat FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#221-flat-fim
[In-Tree PR FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#222-in-tree-pr-fim
[Out-of-Tree PR FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#223-out-of-tree-pr-fim
[HE_NULL FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#224-he_null-fim
[Compile OFS FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#225-walkthrough-compile-ofs-fim
[Manually Generate OFS Out-Of-Tree PR FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#226-walkthrough-manually-generate-ofs-out-of-tree-pr-fim
[Compilation Seed]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#227-compilation-seed
[Change the Compilation Seed]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#2271-walkthrough-change-the-compilation-seed
[FIM Simulation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#3-fim-simulation
[Simulation File Generation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#31-simulation-file-generation
[Individual Unit Tests]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#32-individual-unit-tests
[Running Individual Unit Level Simulation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#321-walkthrough-running-individual-unit-level-simulation
[Regression Unit Tests]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#33-regression-unit-tests
[Running Regression Unit Level Simulation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#331-walkthrough-running-regression-unit-level-simulation
[FIM Customization]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#4-fim-customization
[Adding a new module to the FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#41-adding-a-new-module-to-the-fim
[Hello FIM Theory of Operation]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#411-hello-fim-theory-of-operation
[Hello FIM Board Peripheral Fabric (BPF)]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#4111-hello-fim-board-peripheral-fabric-bpf
[Hello FIM CSR]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#4112-hello-fim-csr
[Add a new module to the OFS FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#412-walkthrough-add-a-new-module-to-the-ofs-fim
[Modify and run unit tests for a FIM that has a new module]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#413-walkthrough-modify-and-run-unit-tests-for-a-fim-that-has-a-new-module
[Hardware test a FIM that has a new module]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#414-walkthrough-hardware-test-a-fim-that-has-a-new-module
[Debug the FIM with Signal Tap]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#415-walkthrough-debug-the-fim-with-signal-tap
[Preparing FIM for AFU Development]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#42-preparing-fim-for-afu-development
[Compile the FIM in preparation for designing your AFU]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#421-walkthrough-compile-the-fim-in-preparation-for-designing-your-afu
[Partial Reconfiguration Region]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#43-partial-reconfiguration-region
[Resize the Partial Reconfiguration Region]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#431-walkthrough-resize-the-partial-reconfiguration-region
[PCIe Configuration]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#44-pcie-configuration
[PCIe-SS Configuration Registers]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#441-pcie-ss-configuration-registers
[PF/VF MUX Configuration]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#442-pfvf-mux-configuration
[PCIe Configuration Using OFSS]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#443-pcie-configuration-using-ofss
[Modify the PCIe Sub-System and PF/VF MUX Configuration Using OFSS]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#4431-walkthrough-modify-the-pcie-sub-system-and-pfvf-mux-configuration-using-ofss
[PCIe Configuration Using IP Presets]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#444-pcie-configuration-using-ip-presets
[Modify PCIe Configuration Using IP Presets]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#4441-walkthrough-modify-pcie-configuration-using-ip-presets
[Minimal FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#45-minimal-fim
[Create a Minimal FIM]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#451-create-a-minimal-fim
[Migrating to a Different Agilex Device Number]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#46-migrating-to-a-different-agilex-device-number
[Migrate to a Different Agilex Device Number]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#461-walkthrough-migrate-to-a-different-agilex-device-number
[Modify the Ethernet Sub-System]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#47-modify-the-ethernet-sub-system
[Modify the Ethernet Sub-System to 1x400GbE]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#471-walkthrough-modify-the-ethernet-sub-system-to-1x400gbe
[FPGA Configuration]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#5-fpga-configuration
[Set up JTAG]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#51-walkthrough-set-up-jtag
[Program the FPGA via JTAG]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#52-walkthrough-program-the-fpga-via-jtag
[Appendix]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#appendix
[Appendix A: Resource Utilization Tables]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#appendix-a-resource-utilization-tables
[Appendix B: Glossary]: https://ofs.github.io/ofs-2024.1-1/hw/iseries_devkit/dev_guides/fim_dev/ug_ofs_iseries_dk_fim_dev/#appendix-b-glossary
