
# Filesystem Hierarchy
The [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) is, in my opinion, an abomination. What does `/bin` do? Almost the same thing as `/usr/bin`, which just sounds like "A users' (Trash?) bin". But it's a folder for binaries, and even the name of a which `/dev` sounds like a development folder, but no, it's a folder that contains devices. The only reason no one has changed it is because of backwards compatibility.

In this hierarchy, the names make sense, in that you can read them and grasp what they mean.

Notes: 
1. "Equivalent" means the Linux [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) counterpart. 
3. Applications can also run in Linux Emulation Mode (LEM), in which case `/usr/bin` will resolve to `/apps`, `/etc` to `/config` etc.
4. The root user is called the `admin` user in this OS,  because that is what it actually does (The only root part or the `root` user is that it owns the root directory).

| Directory | Description |
|--|--|
| `/apps` | Equivalent to `/bin`, `usr/bin` and `/sbin`. Installed apps are placed in `/apps` (unless they are games). This folder may get more subfolders in the future, and applications can add their own (For example MS Office might have a `/apps/office` folder). Any `.app` folders here (and in subdirectories) are hardcoded into your `$PATH`, you cannot change nor read your `$PATH` (Unless in LEM), you must assume that this is your `$PATH`. See the App Directory Structure |
| `/apps/core` | Equivalent to `/bin`: contains core utilities such as `cd` and `cat`.  |
| `/apps/system` | Equivalent to `/sbin`: contains essential system adminstration and boot commands such as `fsck` and `halt`. |
| `/apps/games` | Equivalent to `/usr/games`. For games. |
| `/home` | All home folders are here, including the admin user. Special users (Such as the admin user, or all those other wierd ones in `/etc/passswd` in Linux) can have special stuff about them specified in `/home/attr.cfg`. See the home directory structure |
| `/var` | Contains files that will be changed and read much more often then other files. Files in this folder should be more likely to be cached by the kernel, and writes should be withheld until a shutdown, the application closes, or a certain amount of memory has been used. The folder hierarchies of this folder is similar to the Linux eqivalent (`/var`). |
| `/var/log` | Contains log files from applications. Each application may have their own subdirectory, with files of the format `logname_YEAR-MONTH-DAY_HOUR-MONTH-SECOND.log` where `logname` should be the name of the application for simpler application, or something different for larger applications with different logs being written at the same time (For applications that have multiple services, for example). Each subdirectory may also have a `crash` directory, for crash logs. The crash logs have the same naming format, but with the `.crash_log` extension instead. |
| `/var/cache` | Contains cache files for large computations an application does not wish to repeat. Each application may have their own subdirectory. These files may be deleted without notice. |
| `/temp` | Contains temporary files.  Each application may have their own subdirectory. Create a lock on the folder if you do not wish it to be deleted. This can be used for building applications, storing files for applications that only accept input from files, or other things. After you have removed the lock on your folder, it may be deleted without notice. |
| `/mount` | Contains temporarily mounted filesystems. |
| `/mount/media` | Contains mount points for inserted media, such as USB sticks or CD-ROMs. |
| `/share` | Contains folders used to share files between users. The folder names are of the format `john=nina=john2` and can have 2 or more users. |
| `/library` | Contains `.so` files that can be used by multiple programs. Please do not prefix your library names with `lib`. |
| `/devices` | Contains device files |

## App Directory Structure
Files may only access files in this folder (unless they are verified system programs, or run with `sudo`), and folders that are opened with the program are piped into `console.r.0`. This folder can be moved to a different device, even if it has a different architecture (e.g., `x86_64` vs `arm64`), and it will run just fine with the same saved data, and everything. Apps can share data through the `appshare` device, and apps can deny requests for shares.
| File/Directory | Description |
|--|--|
| `manifest.cfg` | Contains metadata about the program, such as how to (un)install the program, what files the program can open, the icon path, and the executables to execute for what architectures (Complete app portability!). |
| `config/` | Equivalent to `/etc`. Contains configuration (`.cfg`) files . There will be a CLI and a GUI program that parses these files and makes an easy-to-use interface for it. |
| `data/` | Data such as game save files. |
| `documentation/` | Contains man and info pages and other documentation related files. |
| `resources/` | Contains resource files, such as images. User Texture Packs should be placed in a `config/` subdirectory. |
| `exec/` | Contains the executable programs and internal libraries. Libraries that can be used by other programs (such as Electron) should be placed in the root `/lib`. The file that will be run at startup is specified in `manifest.cfg`. |


## Home directory structure
Each home directory has a `config/` folder to store configuration that overrides the root config folder (`/config`), a `Documents` folder to store documents, a `Downloads` folder to store files downloaded from the [Internet](http://info.cern.ch/hypertext/WWW/TheProject.html), a `dev` folder to store projects being developed (this folder only exists if the user has the `dev` attribute. This shortening is used because it is so common, people are referring to developers as "devs".
| Directory | Description |
|--|--|
| `apps/` | Programs installed only for the current user. The structure is the same as the root `/apps`. |
| `dev/` | Development folder. This folder only exists if the user has the `dev` attribute.
| `Documents/` | Documents. Videos are also stored here. |
| `Downloads/` | Downloads from the [Internet](http://info.cern.ch/hypertext/WWW/TheProject.html). Default for broswers and wget/curl (if no directory specified). |
| `var/` | Contains files that will be changed and read much more often then other files. Files in this folder should be more likely to be cached by the kernel, and writes should be withheld until a shutdown, the application closes, or a certain amount of memory has been used. The folder hierarchies of this folder is similar to the Linux eqivalent (`/var`). There is a duplicate of the root `/var` here, since othere users might be able to tell private information from cache data or logs. The structure in here is identical to the root `/var` (no need to repeat). |
| `library/` | Libraries installed only for the current user. |
| `mount/` | Contains temporarily mounted filesystems. |
