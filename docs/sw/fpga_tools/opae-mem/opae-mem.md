# opae-mem #

## SYNOPSIS ##

`opae-mem ls [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID] [-t,--token-type {device,accel}] [-i,--interface {dfl,vfio,dfl_ase,vfio_ase,uio}]`<br>
`opae-mem peek [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID] [-c,--count COUNT] [-o,--output OUTPUT] [-F,--format {simple,hex,json}] offset`<br>
`opae-mem poke [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID] [-j,--json JSON_FILE] [offset] [value]`<br>
`opae-mem mb-read [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID] [-b,--mailbox-base BASE] [-c,--count COUNT] [-t,--timeout TIMEOUT] [-s,--sleep SLEEP] [-o,--output OUTPUT] [-F,--format {simple,hex,json}] address`<br>
`opae-mem mb-write [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID] [-b,--mailbox-base BASE] [-t,--timeout TIMEOUT] [-s,--sleep SLEEP] [-j,--json JSON_FILE] [address] [value]`<br>
`opae-mem lock [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID]`<br>
`opae-mem unlock [-d,--device <PCIE_ADDR>|<PCIE_ID>] [-f,--feature-id ID]`

## DESCRIPTION ##

```opae-mem``` is a utility that provides access to FPGA accelerator MMIO.
It is written on top of the OPAE Python bindings; so it works with any
FPGA accelerator, whether the accelerator is connected via DFL, VFIO, UIO, or ASE.

Accelerators are enumerated using the ```opae-mem ls``` command:

`$ sudo chmod 666 /dev/uio*`<br>
`$ opae-mem ls`<br>
`[0000:d8:00.0] (8086:bcce 8086:0000)`<br>
`  UIO 0x14 00000000-0000-0000-0000-000000000000`<br>
`  UIO 0x20 00000000-0000-0001-0000-000000000000`<br>
`[0000:3b:00.0] (8086:bcce 8086:0000)`<br>
`  UIO 0x15 00042415-0004-2415-0000-001100010000`<br>
`  UIO 0x20 00000000-0000-0001-0000-000000000000`<br>
`  UIO 0x14 00000000-0000-0000-0000-000000000000`

This output shows two FPGA cards with a total of five FPGA MMIO regions.

The first card at address 0000:d8:00.0 has two MMIO regions accessible via UIO:

`  Feature ID 0x14: s10 IOPLL`<br>
`  Feature ID 0x20: PCIe Subsystem`

The second card at address 0000:3b:00.0 has three MMIO regions accessible via UIO:

`  Feature ID 0x15: HSSI Subsystem`<br>
`  Feature ID 0x20: PCIe Subsystem`<br>
`  Feature ID 0x14: s10 IOPLL`

The ```peek``` command provides a way to view a range of MMIO addresses:

`$ opae-mem peek -d 0000:3b:00.0 -f 0x20 --count 4 0x0`<br>
`  00000000:  3000000010000020   0000000000000000  | ......0........|`<br>
`  00000010:  0000000000000001   0000000000000000  |................|`

Here, --count 4 causes the command to display four 64-bit qwords,
from addresses 0x0 through 0x18.

The default format is hex display, which is modeled after the
output of hexdump -C. The format can be controlled using the -F
option. Valid values for -F are simple, hex, and json.

`$ opae-mem peek -d 0000:3b:00.0 -f 0x20 --count 4 -F simple 0x0`<br>
`  00000000: 3000000010000020`<br>
`  00000008: 0000000000000000`<br>
`  00000010: 0000000000000001`<br>
`  00000018: 0000000000000000`

`$ opae-mem peek -d 0000:3b:00.0 -f 0x20 --count 4 -F json 0x0`<br>
`  {`<br>
`    "0x00000000": "0x3000000010000020",`<br>
`    "0x00000008": "0x0000000000000000",`<br>
`    "0x00000010": "0x0000000000000001",`<br>
`    "0x00000018": "0x0000000000000000"`<br>
`  }`

The output of ```opae-mem peek``` can be sent to a file using the -o
option. This is useful for capture/playback. Playback is available
with the ```opae-mem poke``` command.

`$ opae-mem peek -d 0000:3b:00.0 -f 0x20 --count 4 -F json -o file.json 0x0`<br>
`$ cat file.json`<br>
`  {`<br>
`    "0x00000000": "0x3000000010000020",`<br>
`    "0x00000008": "0x0000000000000000",`<br>
`    "0x00000010": "0x0000000000000001",`<br>
`    "0x00000018": "0x0000000000000000"`<br>
`  }`

The ```poke``` command provides a way to write MMIO addresses:

`$ opae-mem poke -d 0000:3b:00.0 -f 0x20 0x0 0xc0cac01a`

In the above ```poke``` command, 0x0 is the MMIO offset to write
and 0xc0cac01a is the value.

The output of the ```opae-mem peek``` command with -F json can
be played back as a series of writes to an MMIO region
using the ```opae-mem poke``` --json option:

`$ opae-mem poke -d 0000:3b:00.0 -f 0x20 --json file.json`

The ```opae-mem mb-read``` command is used to issue read requests
to an FPGA mailbox interface:

`$ opae-mem mb-read -d 0000:3b:00.0 -f 0x20 -c 4 0x0`<br>
`mb-read [0000:3b:00.0] 0x20 This command needs -b mailbox_base. For feature_id 0x20, try -b 0x0028`

`$ opae-mem mb-read -d 0000:3b:00.0 -f 0x20 -c 4 -b 0x28 0x0`<br>
`  00000000:  01000000 00000001 01104000 00000000  |.........@......|`

Each mailbox address represents a 32-bit data value.

Like ```peek```, the default display format for ```mb-read``` is hex.
To change the display format, use the -F option, which accepts
simple, hex, or json.

`$ opae-mem mb-read -d 0000:3b:00.0 -f 0x20 -c 4 -b 0x28 -F simple 0x0`<br>
`  00000000: 01000000`<br>
`  00000004: 00000001`<br>
`  00000008: 01104000`<br>
`  0000000c: 00000000`

`$ opae-mem mb-read -d 0000:3b:00.0 -f 0x20 -c 4 -b 0x28 -F json 0x0`<br>
`  {`<br>
`    "0x00000028": {`<br>
`    "0x00000000": "0x01000000",`<br>
`    "0x00000004": "0x00000001",`<br>
`    "0x00000008": "0x01104000",`<br>
`    "0x0000000c": "0x00000000"`<br>
`    }`<br>
`  }`

The ```mb-write``` command provides a way to issue write commands
to an FPGA mailbox interface.

`$ opae-mem mb-write -d 0000:3b:00.0 -f 0x20 -b 0x28 0x0 0xc0cac01a`

In the above command, 0x0 is the mailbox address and 0xc0cac01a
is the 32-bit data value to be written.

The output of the ```opae-mem mb-read``` command with -F json can
be played back as a series of writes to a mailbox interface
using the ```opae-mem mb-write``` --json option:

`$ opae-mem mb-read -d 0000:3b:00.0 -f 0x20 -c 4 -b 0x28 -F json -o mb.json 0x0`<br>
`$ opae-mem mb-write -d 0000:3b:00.0 -f 0x20 -b 0x28 --json mb.json`

Each of the above commands has explicitly specified the
-d PCIE_ADDR and -f FEATURE_ID parameters, making for some
long command lines. To shorten the length, ```opae-mem``` can
be "locked" to a (device, feature_id) pair:

`$ opae-mem lock -d 0000:3b:00.0 -f 0x20`<br>
`lock [0000:3b:00.0] 0x20 OK`

Once "locked" to a device, issuing the command again displays the lock status:

`$ opae-mem lock`<br>
`[locked 0000:3b:00.0 0x20] lock currently held by 0000:3b:00.0 0x20.`

From now until the time the session is unlocked,
```opae-mem``` commands may omit the explicit -d and -f
parameters:

`$ opae-mem peek 0x0`<br>
`  00000000:  3000000010000020                     | ......0        |`

"Locking" is simply a convenient way to shorten the ```opae-mem```
command line. Each of the other commands operates in the same
way, as if -d and -f were specified explicitly.

Note: a "lock" can be overridden by specifying -d and/or -f:

`$ opae-mem -V peek -d 0000:d8:00.0 -f 0x14 -c 4 0x0`<br>
`[locked 0000:3b:00.0 0x20 [override 0000:d8:00.0 0x14]] peek [0000:d8:00.0] 0x14 offset=0x0 region=0 format=hex`<br>
`  00000000:  3000000010000014   0000000000000000  |.......0........|`<br>
`  00000010:  0000000000000000   1000000000000000  |................|`

The preceding command used a lock override by specifying a
different device address to -d and a different feature_id
to -f. The -V (verbose) option was given to show the
lock override status.

The unlock command is used to release a lock:

`$ opae-mem unlock`<br>
`[locked 0000:3b:00.0 0x20] unlock Please tell me the device / feature id to unlock. (-d 0000:3b:00.0 -f 0x20)`

`$ opae-mem unlock -d 0000:3b:00.0 -f 0x20`<br>
`[locked 0000:3b:00.0 0x20] unlock [0000:3b:00.0] 0x20 OK`

`$ opae-mem lock`<br>
`lock Give me the device address and feature id.`
