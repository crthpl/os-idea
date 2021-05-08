# Devices
Devices in @ are controlled through the `device` program or the `write` system call.
All devices are in the `/devices` folder and they can have seperate channels. (This is to eliminate stuff like all the `loop#` or `tty#` devices) The driver can dynamically change the amount of channels. Channel indexes are 0-based. The read/write permissions can be used to see what the device supports. Each channel has a way to initialize, configure, and end transmissions.

List of Devices:
| Name | Permission / Channels | Description |
|--|--|--|
| console | rw, 2 channels | Channel 0 write is equivalent to `stdout`, channel 0 read is equivalent to `stdin`, channel 1 write is equivalent to `stderr`, channel 1 read does not have a unix equivalent but can be used to read the stderr through a pipe, and give debug input to a program. Channel 1 is not meant for errors only, it should be refered to as "secondary output", but errors should be printed on secondary output, not primary output |

Devices are specified as `name.r/w.channel_number`.