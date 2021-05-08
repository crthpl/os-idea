# First Boot
After the user has downloaded the iso, burnt on to a USB, and booted into it, they will be greeted by a basic shell (no fancy stuff like piping). The installed packages are:
 - `core` Core utilities such as directory navigation.
 - `system-core` System core utilities such as `shutdown`. Not recommended to uninstall.
 - `basic-term` A basic terminal (no WM), with a builtin basic shell.
 - `pm` The @ **P**ackage **M**anager. Name to be decided.
 - `partition-utils` A CLI for changing, moving, creating, and reading partitions
 - `vlib` The V standard library dynamically linkable shared object file. This is more core than `core`, and if you delete this, none of the other applications on this list will work.
 - `@-install` Installs the system onto a partition, configures the bootloader, and then uninstalls itself.
 
When in the operating system, one has to setup the following:
 1. Set your keyboard layout by editing the `/config/keyboard.cfg` file.
 2. Partition your hard disk with the `part` program.
 3. Run `@-install <install-partition>`. Pass `--create-bootloader`, if you do not have a bootloader or want to use the @ bootloader.
 4. Run `shutdown --reboot`.
 5. When booting, go into your BIOS settings and set the default launch disk to the disk you chose in step 3.
 6. Reboot
 7. Change your bootloader settings to make the partition you chose in step 3. the default. If you passed `--create-bootloader` in step 3., this is not required.
 8. Reboot

From there, you can install other packages (or uninstall the builtin packages - `pm` can uninstall all of the above packages, including `pm`), such as a better shell, an editor, and some other file manipulation utilities (such as symbolic links makers and extended attributes editors). See [Package Manager](package-manager.md) for more info.

There will also be a different iso with everything setup, with a WM, DE, Drivers, a graphical installation, and other essentials.