[source](https://itectec.com/unixlinux/command-to-determine-ports-of-a-device-like-dev-ttyusb0)

# Command to determine ports of a device (like /dev/ttyUSB0)

I have a question regarding the ports in Linux. If I connect my device via USB and want to check its port I can't do it using the command lsusb, which only specifies bus number and device number on this bus:

```
[ziga@Ziga-PC ~]$ lsusb
Bus 003 Device 007: ID 0403:6001 Future Technology Devices International, Ltd FT232 USB-Serial (UART) IC
```

Is there a command that tells me the port the device is connected to directly? Only way to do this until now was to disconect and reconnect and using the command:

```
[ziga@Ziga-PC ~]$ dmesg | grep tty
[    0.000000] console [tty0] enabled
[    0.929510] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.378109] systemd[1]: Starting system-getty.slice.
[    4.378543] systemd[1]: Created slice system-getty.slice.
[    8.786474] usb 3-4.4: FTDI USB Serial Device converter now attached to ttyUSB0
```

In the last line it can be seen that my device is connected to /dev/ttyUSB0.

## Best Answer

I'm not quite certain what you're asking. You mention 'port' several times, but then in your example, you say the answer is **/dev/ttyUSB0**, which is a device dev path, not a port. So this answer is about finding the dev path for each device.

Below is a quick and dirty script which walks through devices in **/sys** looking for USB devices with a **ID_SERIAL** attribute. Typically only real USB devices will have this attribute, and so we can filter with it. If we don't, you'll see a lot of things in the list that aren't physical devices.

```
#!/bin/bash

for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        echo "/dev/$devname - $ID_SERIAL"
    )
done
```

On my system, this results in the following:
```
/dev/ttyACM0 - LG_Electronics_Inc._LGE_Android_Phone_VS930_4G-991c470
/dev/sdb - Lexar_USB_Flash_Drive_AA26MYU15PJ5QFCL-0:0
/dev/sdb1 - Lexar_USB_Flash_Drive_AA26MYU15PJ5QFCL-0:0
/dev/input/event5 - Logitech_USB_Receiver
/dev/input/mouse1 - Logitech_USB_Receiver
/dev/input/event2 - Razer_Razer_Diamondback_3G
/dev/input/mouse0 - Razer_Razer_Diamondback_3G
/dev/input/event3 - Logitech_HID_compliant_keyboard
/dev/input/event4 - Logitech_HID_compliant_keyboard
```

### Explanation:
```
find /sys/bus/usb/devices/usb*/ -name dev
```
Devices which show up in /dev have a dev file in their /sys directory. So we search for directories matching this criteria.
 
```
syspath="${sysdevpath%/dev}"
```
We want the directory path, so we strip off /dev.
 
```
devname="$(udevadm info -q name -p $syspath)"
```
This gives us the path in /dev that corresponds to this /sys device.
 
```
[[ "$devname" == "bus/"* ]] && exit
```
This filters out things which aren't actual devices. Otherwise you'll get things like USB controllers & hubs. The exit exits the subshell, which flows to the next iteration of the loop.
 
```
eval "$(udevadm info -q property --export -p $syspath)"
```
The udevadm info -q property --export command lists all the device properties in a format that can be parsed by the shell into variables. So we simply call eval on this. This is also the reason why we wrap the code in the parenthesis, so that we use a subshell, and the variables get wiped on each loop.
 
```
[[ -z "$ID_SERIAL" ]] && exit
```
More filtering of things that aren't actual devices.
 
```
echo "/dev/$devname - $ID_SERIAL"
```
I hope you know what this line does :-)
