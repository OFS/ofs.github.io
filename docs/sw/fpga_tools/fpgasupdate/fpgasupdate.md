# fpgasupdate #

## SYNOPSIS ##

`fpgasupdate [--log-level=<level>] file [bdf]`

## DESCRIPTION ##

The ```fpgasupdate``` command implements a secure firmware update for the following programmable accelerator cards (PACs):
* Intel&reg; PAC with Intel Arria&reg; 10 GX FPGA
* Intel&reg; FPGA PAC D5005
* Intel&reg; PAC N3000
* Intel&reg; FPGA SmartNIC N6001-PL with Intel&reg Agilex&reg FPGA
* Intel&reg; FPGA IPU F2000X-PL

`--log-level <level>`

    Specifies the `log-level` which is the level of information output to your command tool.
    The following seven levels  are available: `state`, `ioctl`, `debug`, `info`, `warning`,
    `error`, `critical`. Setting `--log-level=state` provides the most verbose output.
    Setting `--log-level=ioctl` provides the second most information, and so on. The default
    level is `info`. 

`file`

    Specifies the secure update firmware file to be programmed. This file may be to program a
    static region (SR), programmable region (PR), root entry hash, key cancellation, or other
    device-specific firmware.

`bdf`

    The PCIe&reg; address of the PAC to program. `bdf` is of the form `[ssss:]bb:dd:f`,
    corresponding to PCIe segment, bus, device, function. The segment is optional. If
    you do not specify a segment, the segment defaults to `0000`. If the system has only
    one PAC you can omit the `bdf` and let `fpgasupdate`  determine the address
    automatically.

## TROUBLESHOOTING ##

To gather more debug output, decrease the `--log-level` parameter. 

## EXAMPLES ##

`fpgasupdate firmware.bin`<br>
`fpgasupdate firmware.bin 05:00.0`<br>
`fpgasupdate firmware.bin 0001:04:02.0 --log-level=ioctl`
