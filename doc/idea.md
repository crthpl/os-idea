This is an idea for an operating system, not an specification of an implementation. The operating system is called `@` for reference.
If you have a suggestion or have found an issue, open a PR or an issue.

# Filesystem Hierarchy
The [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) is, in my opinion, an abomination. What does `/bin` do? Almost the same thing as `/usr/bin`, which just sounds like "A users' (Trash?) bin". But it's a folder for binaries, and even the name of a which `/dev` sounds like a development folder, but no, it's a folder that contains devices. The only reason no one has changed it is because it is 
In this hierarchy, the names make sense, in that you can read them and grasp what they mean.

Notes: 
1. "Equivalent" means the Linux [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) counterpart. 
3. Applications can also run in Linux Emulation Mode (LEM), in which case `/usr/bin` will symlink to `/apps/core`, `/etc` to `/config` etc.
4. The root user is called the `admin` user in this OS,  because that is what it actually does (The only root part is that it owns the root directory).

See the filesystem hierarchy (with some examples) at [github.com/crthpl/os-idea/fs-hierarchy](https://github.com/crthpl/os-idea/tree/master/fs-hierarchy)

| Directory | Description |
|--|--|
| `/apps` | Equivalent to `/bin`, `usr/bin` and `/sbin`. Installed apps are placed in `/apps` (unless they are games). This folder may get more subfolders in the future, and applications can add their own (For example MS Office might have a `/apps/office` folder). Any `.app` files here (and in subdirectories) are hardcoded into your `$PATH`, you cannot change nor read your `$PATH` (Unless in LEM), you must assume that this is your `$PATH`.   |
| `/apps/core` | Equivalent to `/bin`: contains core utilities such as `cd` and `cat`.  |
| `/apps/system` | Equivalent to `/sbin`: contains essential system adminstration and boot commands such as `fsck` and `halt`. |
| `/apps/games` | Equivalent to `/usr/games`. For games. |
| `/config` | Equivalent to `/etc`. Contains root configuration files. Each app may have a subdirectory here to read configuration (`.cfg`) files. They may not access other apps config files).  |
| `/home` | All home folders are here, including the admin user. Special users (Such as the admin user, or all those other wierd ones in `/etc/passswd` in Linux) can have special stuff about them specified in `/home/attr.cfg`. See the home directory structure |
| `/resources` | Contains resource files, such as images. Each app may have a subdirectory here to write resource files. |
| `/var` | Contains files that will be changed and read much more often then other files. Files in this folder should be more likely to be cached by the kernel, and writes should be withheld until a shutdown, the application closes, or a certain amount of memory has been used. The folder hierarchies of this folder is similar to the Linux eqivalent (`/var`). |
| `/var/log` | Contains log files from applications. Each application may have their own subdirectory, with files of the format `logname_YEAR-MONTH-DAY_HOUR-MONTH-SECOND.log` where `logname` should be the name of the application for simpler application, or something different for larger applications with different logs being written at the same time (For applications that have multiple services, for example). Each subdirectory may also have a `crash` directory, for crash logs. The crash logs have the same naming format, but with the `.crash_log` extension instead. |
| `/var/cache` | Contains cache files for large computations an application does not wish to repeat. Each application may have their own subdirectory. These files may be deleted without notice. |
| `/temp` | Contains temporary files.  Each application may have their own subdirectory. Create a lock on the folder if you do not wish it to be deleted. This can be used for building applications, storing files for applications that only accept input from files, or other things. After you have removed the lock on your folder, it may be deleted without notice. |
| `/mount` | Contains temporarily mounted filesystems. |
| `/mount/media` | Contains mount points for inserted media, such as USB sticks or CD-ROMs. |
| `/share` | Contains folders used to share files between users. The folder names are of the format `john=nina=john2` and can have 2 or more users. |
| `/library` | Contains `.so` files that can be used by multiple programs. Please do not prefix your library names with `lib`. |
| `/data` | Data such as game save files or installed packages for package managers. |

## Home directory structure
Each home directory has a `config/` folder to store configuration that overrides the root config folder (`/config`), a `documents` folder to store documents, a `downloads` folder to store files downloaded from the [Internet](http://info.cern.ch/hypertext/WWW/TheProject.html), a `dev` folder to store projects being developed (this folder only exists if the user has the `dev` attribute. This shortening is used because it is so common, people are referring to developers as "devs".
| Directory | Description |
|--|--|
| `apps/` | Programs installed only for the current user. The structure is the same as the root `/apps`. |
| `config/` | Configuration that overrides the root config folder (`/config`) |
| `dev/` | Development folder. This folder only exists if the user has the `dev` attribute.
| `Documents/` | Documents. Videos are also stored here. |
| `Downloads/` | Downloads from the [Internet](http://info.cern.ch/hypertext/WWW/TheProject.html). Default for broswers and wget/curl (if no directory specified). |
| `var/` | Contains files that will be changed and read much more often then other files. Files in this folder should be more likely to be cached by the kernel, and writes should be withheld until a shutdown, the application closes, or a certain amount of memory has been used. The folder hierarchies of this folder is similar to the Linux eqivalent (`/var`). There is a duplicate of the root `/var` here, since othere users might be able to tell private information from cache data or logs. The structure in here is identical to the root `/var` (no need to repeat). |
| `library/` | Libraries installed only for the current user. |
| `mount/` | Contains temporarily mounted filesystems. |
| `data/` | Data such as game save files or installed packages for package managers. |

# Exit Codes
Exit codes should contain a lot more meaning an not always be `1` for crash and `0` for not crashed.
Exit codes can be between `−32768` and `32767`. Exit codes greater than 0 mean success, exit codes less than 0 mean failure, and an exit code of 0 mean that the program incorrectly exited (in LEM exit codes of 0 are turned into 1). Generally, the greater the absolute of the exit code the worse it was (`32767` means that there were a *lot* of warnings, while `−32768` means everything that could go wrong and even things that can't go wrong went wrong).
Exit codeshave the following meaning:
| Code | Meaning |
|--|--|
| 0 | The program exited incorrectly  |
| 1 | Everything went well |
| 2 | Everything went well 2 (can be used for debug purposes) |
| -3 | Program was run with `-h` or `--help` |
| >=4 | ($code - 3$) warnings |
| -1 | Unspecified failure (Default) |
| -2 | Incorrect amount of arguments |
| -3 | Unknown switch |
| -5 | Unknown argument (unspecified argument error) |
| -4 | Unknown sub-command |
| -100 | Program was killed with `^C` |
| -900 | Program was killed with `^C` in the middle of doing something important, and it may be possible to recover (e.g. files were being written) |
| -1000 | Program was killed
| -5000 | Illegal Instruction |
| -10000 | Program was killed with `^C` in the middle of doing something important, and it is probably impossible to recover (e.g. a 100 GB file was being written and was stopped in the middle and the program doesn't know where it was) |
| -30000 | Everything that could go wrong went wrong |
| -32767 | The program that crashed is `systemd` (or whatever equivalent this OS uses) |
| -32768 | Everything that could go wrong went wrong and even things that can't go wrong went wrong |
Some of these may be changed in the future. Any exit code used not listed should be accompanied by an error message to `oerr`
y | Description |
|--|--|
| `/apps` | Equivalent to `/bin`, `usr/bin` and `/sbin`. Installed apps are placed in `/apps` (unless they are games). This folder may get more subfolders in the future, and applications can add their own (For example MS Office might have a `/apps/office` folder). Any `.app` files here (and in subdirectories) are hardcoded into your `$PATH`, you cannot change nor read your `$PATH` (Unless in LEM), you must assume that this is your `$PATH`.   |
| `/apps/core` | Equivalent to `/bin`: contains core utilities such as `cd` and `cat`.  |
| `/apps/system` | Equivalent to `/sbin`: contains essential system adminstration and boot commands such as `fsck` and `halt`. |
| `/apps/games` | Equivalent to `/usr/games`. A blank system will have this empty (Though for example the Raspberry Pi might have [Minecraft Pi Edition](https://www.minecraft.net/en-us/edition/pi/) here by default). |
| `/config` | Equivalent to `/etc`. Contains root configuration files. Each app may have a subdirectory here to read configuration (`.cfg`) files. They may not access other apps config files).  |
| `/home` | All home folders are here, including the admin user. Special users (Such as the admin user, or all those other wierd ones in `/etc/passswd` in Linux) can have special stuff about them specified in `/home/attr.cfg`. Each home directory has a `config/` folder to store configuration that overrides the root config folder (`/config`), a `documents` folder to store documents, a `downloads` folder to store files downloaded from the [Internet](http://info.cern.ch/hypertext/WWW/TheProject.html), a `dev` folder to store projects being developed (this folder only exists if the user has the `developer` attribute). |
| `/resources` | Contains resource files, such as images. Each app may have a subdirectory here to write resource files. |
| `/var` | Contains files that will be changed and read much more often then other files. Files in this folder should be more likely to be cached by the kernel, and writes should be withheld until a shutdown, the application closes, or a certain amount of memory has been used. The folder hierarchies of this folder is similar to the Linux eqivalent (`/var`). |
| `/var/log` | Contains log files from applications. Each application may have their own subdirectory, with files of the format `logname_YEAR-MONTH-DAY_HOUR-MONTH-SECOND.log` where `logname` should be the name of the application for simpler application, or something different for larger applications with different logs being written at the same time (For applications that have multiple services, for example). Each subdirectory may also have a `crash` directory, for crash logs. The crash logs have the same naming format, but with the `.crash_log` extension instead. |
| `/var/cache` | Contains cache files for large computations an application does not wish to repeat. Each application may have their own subdirectory. These files may be deleted without notice. |
| `/temp` | Contains temporary files.  Each application may have their own subdirectory. Create a lock on the folder if you do not wish it to be deleted. This can be used for building applications, storing files for applications that only accept input from files, or other things. After you have removed the lock on your folder, it may be deleted without notice. |
| `/mount` | Contains temporarily mounted filesystems. |
| `/mount/media` | Contains mount points for inserted media, such as USB sticks or CD-ROMs |
| `/share` | Contains folders used to share files between users. The folder names are of the format `john=nina=joe` and can have 2 or more users. |
| `/library` | Contains `.so` files that can be used by multiple programs. |
| `/documentation` | Contains man and info pages and other documentation related files. |
| `/devices` | Contains device files |

# Exit Codes
Exit codes should contain a lot more meaning an not always be `1` for crash and `0` for not crashed.
Exit codes can be between `−32768` and `32767`. Exit codes greater than 0 mean success, exit codes less than 0 mean failure, and an exit code of 0 mean that the program incorrectly exited (in LEM exit codes of 0 are turned into 1). Generally, the greater the absolute of the exit code the worse it was (`32767` means that there were a *lot* of warnings, while `−32768` means everything that could go wrong and even things that can't go wrong went wrong).
Exit codes have the following meaning:
| Code | Meaning |
|--|--|
| 0 | The program exited incorrectly  |
| 1 | Everything went well |
| 2 | Everything went well 2 (can be used for debug purposes) |
| -3 | Program was run with `-h` or `--help` |
| >=4 | ($code - 3$) warnings |
| -1 | Unspecified failure (Default) |
| -2 | Incorrect amount of arguments |
| -3 | Unknown switch |
| -5 | Unknown argument (unspecified argument error) |
| -4 | Unknown sub-command |
| -100 | Program was killed with `^C` |
| -900 | Program was killed with `^C` in the middle of doing something important, and it may be possible to recover (e.g. files were being written) |
| -1000 | Program was killed
| -5000 | Illegal Instruction |
| -10000 | Program was killed with `^C` in the middle of doing something important, and it is probably impossible to recover (e.g. a 100 GB file was being written and was stopped in the middle and the program doesn't know where it was) |
| -30000 | Everything that could go wrong went wrong |
| -32767 | The program that crashed is `systemd` (or whatever equivalent @ will use) |
| -32768 | Everything that could go wrong went wrong and even things that can't go wrong went wrong |
Some of these may be changed in the future. Any exit code used not listed here should be accompanied by an error message to `outerr`

# Devices
Devices in @ are controlled through the `device` program or the `write` system call.
All devices are in the `/devices` folder and they can have seperate channels. (This is to eliminate stuff like all the `loop#` or `tty#` devices) The driver can dynamically change the amount of channels. Channel indexes are 0-based. The read/write permissions can be used to see what the device supports. 



Devices:
| Name | Permission / Channels | Description |
|--|--|--|
| console | rw, 2 channels | Channel 0 write is equivalent to `stdout`, channel 0 read is equivalent to `stdin`, channel 1 write is equivalent to `stderr`, channel 1 read does not have a unix equivalent but can be used to read the stderr through a pipe, and give debug input to a program. Channel 1 is not meant for errors only, it should be refered to as "secondary output", but errors should be printed on secondary output, not primary output |



# TTY equivalent
The TTY system in Linux is entirely built on stuff from several decades ago, and if someone from thenabouts with expertise in unix time-traveled to today, they could still operate a shell just as well. The way TTY works today is an ugly mess of signals, way too many options, parity checks, which are no longer needed, but still there for backwards compatibility. See [The TTY demystified by Linus Akesson](https://www.linusakesson.net/programming/tty/) for an in-depth explanation of how the current system works. This replacement is meant to be easy to understand and good.

This new TTY replacement will is called `console`.

Echoing, line control, etc., for `console` is controlled by the terminal emulator , not the kernel. The program can send escape codes (`\e` or `\x1b`) to change the settings (echoing, what key to use to kill programs, etc.), request information about the terminal (e.g. width/height, current settings, supported features of terminal emulator), change the position of the cursor, change the appearence of text, or clear text. They do not require a `[` after the `\e`, like ANSI escapes. There is a setting to turn off escape codes, until a timer has run out or a program has exited.
Escape Codes are of the format (with regex:
`\e` + type + args + `]`, where type is `[A-Z]*` and args is`([\-0-9A-Za-z]*;)*`. The full format is: `\e[A-Z]*(;[0-9a-z]*)*\]`. As soon as an invalidity is detected, terminal just writes the raw text to the terminal (with the `\e`). For bool arguments (b), it is written as `y` or `n`. For numbers (n), it is numbers. For strings, it is letters or numbers (s). The type can be always determined from the command type (The text after the `\e`).
Escape Codes (all prefixed with `\e` of cours) that are writtin by the program for the terminal:
<table>
  <tr>
    <th>Type</th>
    <th>Arg Types <br>(a(n) refers to <br>nth argument)</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>A</td>
    <td>n, n, n</td>
    <td>Set text color to RGB provided.</td>
  </tr>
  <tr>
    <td>B</td>
    <td>n, b</td>
    <td>Various stateful text appearence settings: 
	<table>
	<tr><th>a(1)</th><th>Setting</th></tr>
	<tr><td>0</td><td>Turn off/on all of the below</td></tr>
	<tr><td>1</td><td>Bold</td></tr>
	<tr><td>2</td><td>Italic</td></tr>
	<tr><td>3</td><td>Underline</td></tr>
	<tr><td>4</td><td>Overline</td></tr>
	<tr><td>5</td><td>Blink  (twice per second)</td></tr>
	<tr><td>6</td><td>Superscript</td></tr>
	<tr><td>7</td><td>Subscript</td></tr>
	<tr><td>8</td><td>Rainbow (Equivalent to  <code>| lolcat</code>)</td></tr>
	<tr><td>9</td><td>Framed (All text within is framed with a rectangle (or a polygon with more sides, if it is multiline, but still only right angles), will at screeshot of examlpes sometime) </td></tr>
	</table>
    </td>
  </tr>
  <tr>
    <td>C</td>
    <td>n</td>
    <td>Text blinks n times per minute. -1 resets to no blink</td>
  </tr>
  <tr>
    <td>D</td>
    <td>n, n, n</td>
    <td>Set background color to RGB Provided</td>
  </tr>
  <tr>
    <td>E</td>
    <td></td>
    <td>Swap background and foreground colors</td>
  </tr>
  <tr>
    <td>F</td>
    <td>n,n,n,b</td>
    <td>Set underline colour to RGB specified (overline if a(4))</td>
  </tr>
</table>
Note: A redo of the above is planned soon (Moving around commands, adding alpha)

# First Boot
After the user has downloaded the iso, burnt on to a USB, and booted into it, they will be greeted by a basic shell (no fancy stuff like piping). The installed packages are:
 - `core` Core utilities such as directory navigation
 - `system-core` System core utilities such as `shutdown`
 - `basic-term` A basic terminal (no WM), with a builtin basic shell.
 - `pm` The @ **P**ackage **M**anager.
 - `partition-utils` Partioning utilities
 - `vlib` The V standard library dynamic linkable shared objects file. This is more core than `core`, and if you delete this, none of the other applications on this list will work.
 - `@-install` Installs the system onto a partition, and then uninstalls itself.
 
When in the operating system, one has to setup the following:
 1. Set your keyboard layout by editing the `/config/keyboard.cfg` file.
 2. Partition your hard disk with the `part` program.
 3. Run `@-install <install-partition>`. Pass `--create-bootloader`, if you do not have a bootloader or want to use the @ bootloader.
 4. Run `shutdown --reboot`.
 5. When booting, go into your BIOS settings and set the default launch disk to the disk you chose in step 3.
 6. Reboot
 7. Change your bootloader settings to make the partition you chose in step 3. the default. If you passed `--create-bootloader` in step 3., this is not required.
 8. Reboot

From there, you can install other packages (or uninstall the builtin packages - `pm` can uninstall all of the above packages, including `pm`), such as a better shell, an editor, and some other file manipulation utilities (such as symbolic links makers and extended attributes editors). 

There will also be a different iso with everything setup, with a WM, DE, Drivers, a graphical installation, and other essentials.

# Package Manager

TODO

## Packages

| Name | Description | Installed Libraries | Installed Programs |
|--|--|--|--|
| `core` | Core utilities such as directory navigation | `core` | `cat`, `cd`, `cp`, `date`, `ls`, `mkdir`, `mv`, `path`, `rm`, `tee`, `sysinfo` |
| `system-core` | System core utilities such as `shutdown`. Not recommended to uninstall. | `core` | `shutdown`, `systemctl`, `chroot`, `kill`, `sudo`, `user`, `group` |
| `basic-term` | A basic terminal (no WM), with a builtin basic shell. | `exec` | `sh` |
| `pm` | The @ **P**ackage **M**anager. Name to be decided. | `pm` | `pm` |
| `partition-utils` | A CLI for changing, moving, creating, and reading partitions | `partitions` | `part` |
| `vlib` | The V standard library dynamic linkable shared objects file. This is more core than `core`, and if you delete this, none of the other applications on this list will work. | `vlib` | `vlibctl` |
