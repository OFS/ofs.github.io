# fpgaport #

## SYNOPSIS ##
```console
fpgaport [-h] [-N NUMVFS] [-X] [--debug] {assign,release} device [port]
```

## DESCRIPTION ##
The ```fpgaport``` enables and disables virtualization. It assigns
and releases control of the port to the virtual function (VF). By default, the driver
assigns the port to the physical function (PF) in the non-virtualization use case.


## POSITIONAL ARGUMENTS ##

`{assign, release}`

    Action to perform.

`device`

    The FPGA device being targeted with this action.

`port`

    The number of the port.

## OPTIONAL ARGUMENTS ##

`-N NUMVFS, --numvfs NUMVFS`

    Create NUMVFS virtual functions. The typical value is 1.

`-X, --destroy-vfs`

    Destroy all virtual functions prior to assigning.

`--debug`

    Display additional log information.

`-h, --help`

    Print usage information.

## EXAMPLE ##

`fpgaport release /dev/dfl-fme.0 0`

    Release port 0 from physical function control.

`fpgaport assign /dev/dfl-fme.0 0`

    Assign port 0 to physical function control.
