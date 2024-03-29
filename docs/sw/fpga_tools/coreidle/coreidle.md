# coreidle #

## SYNOPSIS  ##

`coreidle [-v] [-B <bus>] [-D <device>] [-F <function>] [-S <socket>] [-G <GBS path>] `


## DESCRIPTION ##

```coreidle``` parses the Accelerator Function Unit (AFU) metadata and extracts power information. ```coreidle``` calculates
the FPGA power and calculates the number of online and idle cores. It moves threads from idle cores to online cores. 
```coreidle``` is only available the Integrated FPGA Platform. You cannot run ```coreidle``` on the PCIe Accelerator Card (PAC).


## EXAMPLES  ##

`./coreidle  -B 0x5e -G /home/lab/gbs/mode0.gbs`

  Idle cores to run online cores at maximum capacity.

## OPTIONS ##

`-v,--version` Prints version information and exit.

`-B,--bus` FPGA bus number.

`-D,--device` FPGA device number.

`-F,--functio` FPGA function number.

`-S,--socket` FPGA socket number.

`-G,--gbs` Green bitstream file path.
