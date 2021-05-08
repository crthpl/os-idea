# System Calls

## Calling convention
### x86
`rcx` is not saved. The syscall type is stored in `eax`, and the arguments are stored in `rdx` `rsi`, `rdi`, `r8`, `r9`, `r10`, in that order. The return value is stored in `eax` and the error in `rdx` (0 means no error)

## Table
| Type | Mnemonic | Return Value (error is always there) | Arg 1 | Arg 2 | Arg 3 | Arg 4 | Arg 5 |
|--|--|--|--|--|--|--|--|
| 0 | read | bytes read | fd u64 | buf \*u8 | count u64 |||
| 1 | write | bytes written | fd u64 | buf \*u8 | count u64 |||
| 2 | open | file descriptor |  path \*u8 | pathlen u64 | flags u64 |||
| 3 | close | nothing |  fd u64 |||||
| 4 | stat | pointer to stat struct | path \*u8 | pathlen u64 ||||
| 5 | fstat | pointer to stat struct | fd u64 |||||
| 6 | seek | offset from start of file | fd u64 | offset i64 | whence u64 |||
| tbc | exit | nothing | code u64 |||||