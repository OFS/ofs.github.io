# HSSI ethernet statistics #

## SYNOPSIS ##
```console
hssistats [-h] [--pcie-address PCIE_ADDRESS, -P PCIE_ADDRESS]
```

## DESCRIPTION ##
The ```hssistats```  tool provides the MAC statistics.


### OPTIONAL ARGUMENTS ##

`-h, --help`

  Prints usage information

`--pcie-address PCIE_ADDRESS, -P PCIE_ADDRESS`

  The PCIe address of the desired fpga in ssss:bb:dd.f format. sbdf of device to program (e.g. 04:00.0 or 0000:04:00.0). Optional when one device in system.

## EXAMPLES ##

`hssistats --pcie-address  0000:04:00.0`

  prints the MAC statistics 
