# fpgaconf #

## SYNOPSIS ##

`fpgaconf [-hvVn] [-S <segment>] [-B <bus>] [-D <device>] [-F <function>] [PCI_ADDR] <gbs>`

## DESCRIPTION ##

```fpgaconf``` configures the FPGA with the accelerator function (AF). It also checks the AF for compatibility with 
the targeted FPGA and the FPGA Interface Manager (FIM). ```fpgaconf``` takes the following arguments: 

`-h, --help`

	Prints usage information.

`-v, --version`

	Prints version information and exits.

`-V, --verbose`

	Prints more verbose messages while enumerating and configuring. Can be
	requested more than once.

`-n, --dry-run`

	Performs enumeration. Skips any operations with side-effects such as the
	actual AF configuration. 

`-S, --segment`

	PCIe segment number of the target FPGA.

`-B, --bus`

	PCIe bus number of the target FPGA.

`-D, --device`

	PCIe device number of the target FPGA. 

`-F, --function`

	PCIe function number of the target FPGA.

`--force`

	Reconfigure the AFU even if it is in use.

```fpgaconf``` enumerates available FPGA devices in the system and selects
compatible FPGAs for configuration. If more than one FPGA is
compatible with the AF, ```fpgaconf``` exits and asks you to be
more specific in selecting the target FPGAs by specifying a
a PCIe BDF.

## EXAMPLES ##

`fpgaconf my_af.gbs`

	Program "my_af.gbs" to a compatible FPGA.

`fpgaconf -V -B 0x3b my_af.gbs`

	Program "my_af.gbs" to the FPGA in bus 0x3b, if compatible,
	while printing out slightly more verbose information.

`fpgaconf 0000:3b:00.0 my_af.gbs`

	Program "my_af.gbs" to the FPGA at address 0000:3b:00.0.
