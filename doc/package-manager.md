# Package Manager

TODO

## Packages

| Name | Description | Installed Libraries | Installed Programs |
|--|--|--|--|
| `core` | Core utilities such as directory navigation. | `core` | `cat`, `cd`, `cp`, `date`, `ls`, `mkdir`, `mv`, `path`, `rm`, `tee`, `sysinfo` |
| `system-core` | System core utilities such as `shutdown`. Not recommended to uninstall. | `core` | `shutdown`, `systemctl`, `chroot`, `kill`, `sudo`, `user`, `group` |
| `basic-term` | A basic terminal (no WM), with a builtin basic shell. | `exec` | `sh` |
| `pm` | The @ **P**ackage **M**anager. Name to be decided. | `pm` | `pm` |
| `partition-utils` | A CLI for changing, moving, creating, and reading partitions | `partitions` | `part` |
| `vlib` | The V standard library dynamically linkable shared object file. This is more core than `core`, and if you delete this, none of the other applications on this list will work. | `vlib` | `vlibctl` |
