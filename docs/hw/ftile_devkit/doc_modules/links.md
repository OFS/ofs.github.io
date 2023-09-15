[OFS Welcome Page]: https://ofs.github.io/ofs-2023.2/
[OFS Agilex PCIe Attach Getting Started Guide]: https://ofs.github.io/ofs-2023.1/hw/n6001/user_guides/ug_qs_ofs_n6001/ug_qs_ofs_n6001/
[OFS Agilex PCIe Attach FIM Technical Reference Manual]: https://ofs.github.io/ofs-2023.1/hw/n6001/reference_manuals/ofs_fim/mnl_fim_ofs_n6001/
[Ethernet Subsystem Intel FPGA IP User Guide]: https://www.intel.com/content/www/us/en/secure/content-details/686148/memory-subsystem-intel-fpga-ip-user-guide-for-intel-agilex-ofs.html?wapkw=686148&DocID=686148
[Memory Subsystem Intel FPGA IP User Guide for Intel Agilex OFS]: https://www.intel.com/content/www/us/en/secure/content-details/686148/memory-subsystem-intel-fpga-ip-user-guide-for-intel-agilex-ofs.html?wapkw=686148&DocID=686148
[PCIe Subsystem Intel FPGA IP User Guide for Intel Agilex OFS]: hw/common/user_guides/ug_qs_pcie_ss.pdf

[Analyzing and Optimizing the Design Floorplan]: https://www.intel.com/content/www/us/en/docs/programmable/683641/21-4/analyzing-and-optimizing-the-design-03170.html "Analyzing and Optimizing the Design Floorplan"

[Partial Reconfiguration Design Flow - Step 3 - Floorplan the Design]: https://www.intel.com/content/www/us/en/docs/programmable/683834/21-4/step-3-floorplan-the-design.html

[Introduction]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1-introduction
[About This Document]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#11-about-this-document
[Knowledge Pre-Requisites]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#111-knowledge-pre-requisites
[FIM Development Theory]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#12-fim-development-theory
[Default FIM Features]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#121-default-fim-features
[Top Level]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1211-top-level
[Interfaces]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1212-interfaces
[Subsystems]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1213-subsystems
[Host Exercisers]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1214-host-exercisers
[Module Access via APF/BPF]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1215-module-access-via-apf/bpf
[Customization Options]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#122-customization-options
[Development Environment]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#13-development-environment
[Development Tools]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#131-development-tools
[Walkthrough: Install Quartus Prime Pro Software]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1311-walkthrough-install-quartus-prime-pro-software
[Walkthrough: Install Git Large File Storage Extension]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1312-walkthrough-install-git-large-file-storage-extension
[FIM Source Files]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#132-fim-source-files
[Walkthrough: Clone FIM Repository]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1321-walkthrough-clone-fim-repository
[Environment Variables]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#133-environment-variables
[Walkthrough: Set Development Environment Variables]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#1331-walkthrough-set-development-environment-variables
[Walkthrough: Set Up Development Environment]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#134-walkthrough-set-up-development-environment
[FIM Compilation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2-fim-compilation
[Compilation Theory]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#21-compilation-theory
[FIM Build Script]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#211-fim-build-script
[OFSS File Usage]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#212-ofss-file-usage
[Platform OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2121-platform-ofss-file
[OFS IP OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2122-ofs-ip-ofss-file
[PCIe IP OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2123-pcie-ip-ofss-file
[IOPLL IP OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2124-iopll-ip-ofss-file
[Memory IP OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2125-memory-ip-ofss-file
[HSSI IP OFSS File]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#2126-hssi-ip-ofss-file
[OFS Build Script Outputs]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#213-ofs-build-script-outputs
[Compilation Flows]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#22-compilation-flows
[Flat FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#221-flat-fim
[In-Tree PR FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#222-in-tree-pr-fim
[Out-of-Tree PR FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#223-out-of-tree-pr-fim
[HE_NULL FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#223-he_null-fim
[Walkthrough: Compile OFS FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#225-walkthrough-compile-ofs-fim
[Walkthrough: Manually Generate OFS Out-Of-Tree PR FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#226-walkthrough-manually-generate-ofs-out-of-tree-pr-fim
[FIM Simulation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#3-fim-simulation
[Simulation File Generation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#31-simulation-file-generation
[Individual Unit Tests]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#32-individual-unit-tests
[Walkthrough: Running Individual Unit Level Simulation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#321-walkthrough-running-individual-unit-level-simulation
[Regression Unit Tests]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#33-regression-unit-tests
[Walkthrough: Running Regression Unit Level Simulation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#331-walkthrough-running-regression-unit-level-simulation
[FIM Customization]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#4-fim-customization
[Adding a new module to the FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#41-adding-a-new-module-to-the-fim
[Hello FIM Theory of Operation]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#411-hello-fim-theory-of-operation
[Hello FIM Board Peripheral Fabric (BPF)]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#4111-hello-fim-board-peripheral-fabric-(bpf)
[Hello FIM CSR]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#4112-hello-fim-csr
[Walkthrough: Add a new module to the OFS FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#412-walkthrough-add-a-new-module-to-the-ofs-fim
[Walkthrough: Modify and run unit tests for a FIM that has a new module]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#413-walkthrough-modify-and-run-unit-tests-for-a-fim-that-has-a-new-module
[Walkthrough: Hardware test a FIM that has a new module]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#415-walkthrough-hardware-test-a-fim-that-has-a-new-module
[Walkthrough: Debug the FIM with Signal Tap]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#416-walkthrough-debug-the-fim-with-signal-tap
[Preparing FIM for AFU Development]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#42-preparing-fim-for-afu-development
[Walkthrough: Compile the FIM in preparation for designing your AFU]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#421-walkthrough-compile-the-fim-in-preparation-for-designing-your-afu
[Partial Reconfiguration Region]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#43-partial-reconfiguration-region
[Walkthrough: Resize the Partial Reconfiguration Region]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#431-walkthrough-resize-the-partial-reconfiguration-region
[PF/VF MUX Configuration]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#44-pf/vf-mux-configuration
[Walkthrough: Modify the PF/VF MUX Configuration]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#441-walkthrough-modify-the-pf/vf-mux-configuration
[Minimal FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#45-minimal-fim
[Walkthrough: Create a Minimal FIM]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#451-walkthrough-create-a-minimal-fim
[PCIe-SS Configuration Registers]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#46-pcie-ss-configuration-registers
[Walkthrough: Modify the PCIe IDs using OFSS Configuration Starting Point]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#461-walkthrough-modify-the-pcie-ids-using-ofss-configuration-starting-point
[Migrating to a Different Agilex Device Number]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#47-migrating-to-a-different-agilex-device-number
[Modify the Memory Sub-System]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#48-modify-the-memory-sub-system
[Modify the Ethernet Sub-System]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#49-modify-the-ethernet-sub-system
[FPGA Configuration]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#5-fpga-configuration
[Walkthrough: Set up JTAG]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#51-walkthrough-set-up-jtag
[Walkthrough: Program the FPGA via JTAG]: hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#5-walkthrough-program-the-fpga-via-jtag

[Appendix A]: /hw/ftile_devkit/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#appendix-a-resource-utilizatio-tables
[Appendix B]: /hw/n6001/dev_guides/fim_dev/ug_ofs_ftile_dk_fim_dev/#appendix-b-glossary