The `vfio-pci` driver implementation will automatically issue an FLR (Function Level Reset) signal every time a new host application is executed. This signal is triggered whenever an application opens a `/dev/vfio*` file and is expected behavior for the `vfio` driver architecture.

You may also encounter issues while debugging an AFU when executing the OPAE SDK tool `opae.io` with `peek/poke` subcommands, which will automatically set register values if they are connected to a reset. The OPAE SDK function `fpgaReset()` will also not accept devices bound to the `vfio-pci` driver. Both of these behaviors can be worked around if they are not desired.

You can use the following steps to enable / disable FLR for a specific device bound to the `vfio-pci` driver. In this example we will use an OFS enabled PCIe device at BDF af:00.0, and will disable FLR on a VF at address af:00.5.

Disable FLR:

```bash
cd /sys/bus/pci/devices/0000:ae:00.0/0000:af:00.5
echo "" > reset_method
cat reset_method
```

Enable FLR:

```bash
cd /sys/bus/pci/devices/0000:ae:00.0/0000:af:00.5
echo "flr" > reset_method
cat reset_method
```

If you wish to manually reset your currently configured AFU without resetting the entire FIM, you can use the OPAE SDK function `fpgaEnumerate()`. This will issue a reset on the AFU's VFIO DEVICE_GROUP. To avoid issuing an FLR to the entire FIM, you need to call this function after disabling FLR as shown above.

If you wish to debug your AFU's register space without changing any of its register values using `opae.io`, you need to execute a `opae.io` compatible python script. An example application is shown below:

```bash
opae.io --version
opae.io 1.0.0

sudo opae.io init -d BDF $USER
opae.io script sample.py
Value@0x0     = 0x4000000010000000
Value@0x12060 = 100

```

`Sample.py` contents:

```python
import sys

def main():
    # Check opae.io initialization
    if the_region is None :
        print("\'opae.io\' initialization has not been performed, please bind the device in question to vfio-pci.")
        sys.exit(1)
    v = the_region.read64(0x0)
    print("Value@0x0     = 0x{:016X}".format(v))
    the_region.write32(0x12060,100)
    v = the_region.read32(0x12060)
    print("Value@0x12060 = {:d}".format(v))

####################################

if __name__ == "__main__":
    main()
```
