# Exit Codes
Exit codes should contain a lot more meaning an not always be `1` for crash and `0` for not crashed.
Exit codes can be between `−32768` and `32767`. Exit codes greater than 0 mean success, exit codes less than 0 mean failure, and an exit code of 0 mean that the program incorrectly exited (in LEM exit codes of 0 are turned into 1). Generally, the greater the absolute of the exit code the worse it was (`32767` means that there were a *lot* of warnings, while `−32768` means everything that could go wrong and even things that can't go wrong went wrong).
Exit codes have the following meaning:
| Code | Meaning |
|--|--|
| 0 | Everything went well |
| 1 | Everything went well 2 (can be used for debug purposes) |
| 2 | Program was run with `-h` or `--help` (or no args, and help was shown) |
| >=3 | ($code - 3$) warnings |
| -1 | Unspecified failure (Default failure) |
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
Some of these may be changed in the future. Any exit code used not listed here should be accompanied by an error message to `console.w.1`