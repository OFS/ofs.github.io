[Introduction]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1-introduction
[About This Document]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#11-about-this-document
[Knowledge Prerequisites]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#111-knowledge-prerequisites
[FIM Development Theory]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#12-fim-development-theory
[Default FIM Features]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#121-default-fim-features
[Top Level FPGA]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1211-top-level-fpga
[Interfaces]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1212-interfaces
[Subsystems]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1213-subsystems
[Host Exercisers]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1214-host-exercisers
[Module Access via APF/BPF]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1215-module-access-via-apf-bpf
[Customization Options]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#122-customization-options
[Development Environment]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#13-development-environment
[Development Tools]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#131-development-tools
[Install Quartus Prime Pro Software]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1311-walkthrough-install-quartus-prime-pro-software
[FIM Source Files]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#132-fim-source-files
[Clone FIM Repository]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1321-walkthrough-clone-fim-repository
[Environment Variables]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#133-environment-variables
[Set Development Environment Variables]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#1331-walkthrough-set-development-environment-variables
[Set Up Development Environment]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#134-walkthrough-set-up-development-environment
[FIM Compilation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2-fim-compilation
[Compilation Theory]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#21-compilation-theory
[FIM Build Script]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#211-fim-build-script
[Build Work Directory]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2111-build-work-directory
[Null Host Exercisers]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2112-null-host-exercisers
[OFSS File Usage]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#212-ofss-file-usage
[Platform OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2121-platform-ofss-file
[OFS IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2122-ofs-ip-ofss-file
[PCIe IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2123-pcie-ip-ofss-file
[IOPLL IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2124-iopll-ip-ofss-file
[Memory IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2125-memory-ip-ofss-file
[HSSI IP OFSS File]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2126-hssi-ip-ofss-file
[OFS Build Script Outputs]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#213-ofs-build-script-outputs
[Compilation Flows]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#22-compilation-flows
[Flat FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#221-flat-fim
[In-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#222-in-tree-pr-fim
[Out-of-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#223-out-of-tree-pr-fim
[Compile OFS FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#225-walkthrough-compile-ofs-fim
[Creating a Relocatable PR Directory Tree]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#226-creating-a-relocatable-pr-directory-tree
[Manually Generate OFS Out-Of-Tree PR FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2261-walkthrough-manually-generate-ofs-out-of-tree-pr-fim
[Compilation Seed]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#227-compilation-seed
[Change the Compilation Seed]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#2271-walkthrough-change-the-compilation-seed
[Compiling the OFS FIM Using Quartus GUI]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#228-compiling-the-ofs-fim-using-quartus-gui
[Unit Level Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#3-unit-level-simulation
[Simulation File Generation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#31-simulation-file-generation
[Individual Unit Tests]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#32-individual-unit-tests
[Run Individual Unit Level Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#321-walkthrough-run-individual-unit-level-simulation
[Regression Unit Tests]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#33-regression-unit-tests
[Run Regression Unit Level Simulation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#331-walkthrough-run-regression-unit-level-simulation
[FIM Customization]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4-fim-customization
[Adding a new module to the FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#41-adding-a-new-module-to-the-fim
[Hello FIM Theory of Operation]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#411-hello-fim-theory-of-operation
[Hello FIM Board Peripheral Fabric (BPF)]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4111-hello-fim-board-peripheral-fabric-(bpf)
[Hello FIM CSR]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4112-hello-fim-csr
[Files to Edit to Support Hello FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4113-files-to-edit-to-support-hello-fim
[Add a new module to the OFS FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#412-walkthrough-add-a-new-module-to-the-ofs-fim
[Modify and run unit tests for a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#413-walkthrough-modify-and-run-unit-tests-for-a-fim-that-has-a-new-module
[Modify and run UVM tests for a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#414-walkthrough-modify-and-run-uvm-tests-for-a-fim-that-has-a-new-module
[Hardware test a FIM that has a new module]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#415-walkthrough-hardware-test-a-fim-that-has-a-new-module
[Debug the FIM with Signal Tap]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#416-walkthrough-debug-the-fim-with-signal-tap
[Preparing FIM for AFU Development]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#42-preparing-fim-for-afu-development
[Compile the FIM in preparation for designing your AFU]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#421-walkthrough-compile-the-fim-in-preparation-for-designing-your-afu
[Partial Reconfiguration Region]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#43-partial-reconfiguration-region
[Resize the Partial Reconfiguration Region]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#431-walkthrough-resize-the-partial-reconfiguration-region
[PCIe Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#44-pcie-configuration
[PF/VF MUX Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#441-pf-vf-mux-configuration
[PCIe-SS Configuration Registers]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#442-pcie-ss-configuration-registers
[PCIe Configuration Using OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#443-pcie-configuration-using-ofss
[Modify the PCIe Sub-System and PF/VF MUX Configuration Using OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4431-walkthrough-modify-the-pcie-sub-system-and-pf-vf-mux-configuration-using-ofss
[PCIe Sub-System configuration Using IP Presets]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#444-pcie-sub-system-configuration-using-ip-presets
[Modify PCIe Sub-System and PF/VF MUX Configuration Using IP Presets]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#4441-walkthrough-modify-pcie-sub-system-and-pf-vf-mux-configuration-using-ip-presets
[Create a Minimal FIM]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#451-walkthrough-create-a-minimal-fim
[Migrate to a Different Agilex Device Number]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#46-migrate-to-a-different-agilex-device-number
[Migrate to a Different Agilex Device Number]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#461-walkthrough-migrate-to-a-different-agilex-device-number
[Modify the Memory Sub-System]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#47-modify-the-memory-sub-system
[Modify the Memory Sub-System Using IP Presets With OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#471-walkthrough-modify-the-memory-sub-system-using-ip-presets-with-ofss
[Modify the Ethernet Sub-System]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#48-modify-the-ethernet-sub-system
[Modify the Ethernet Sub-System Channels With Pre-Made HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#481-walkthrough-modify-the-ethernet-sub-system-channels-with-pre-made-hssi-ofss
[Add Channels to the Ethernet Sub-System Channels With Custom HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#482-walkthrough-add-channels-to-the-ethernet-sub-system-channels-with-custom-hssi-ofss
[Modify the Ethernet Sub-System With Pre-Made HSSI OFSS Plus Additional Modifications]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#483-walkthrough-modify-the-ethernet-sub-system-with-pre-made-hssi-ofss-plus-additional-modifications
[Modify the Ethernet Sub-System Without HSSI OFSS]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#484-walkthrough-modify-the-ethernet-sub-system-without-hssi-ofss
[FPGA Configuration]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#5-fpga-configuration
[Set up JTAG]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#51-walkthrough-set-up-jtag
[Program the FPGA via JTAG]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#52-walkthrough-program-the-fpga-via-jtag
[Remote System Update]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#53-remote-system-update
[Program the FPGA via RSU]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#531-walkthrough-program-the-fpga-via-rsu
[Single Event Upset Reporting]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/#6-single-event-upset-reporting
[Appendix]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/appendix
[Appendix A: FIM FPGA Resource Usage]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/appendix-a-fim-fpga-resource-usage
[Appendix B: Glossary]: https://ofs.github.io/ofs-2025.1-1/hw/f2000x/dev_guides/fim_dev/ug_dev_fim_ofs/appendix-b-glossary