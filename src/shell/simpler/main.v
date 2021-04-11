module main

import os

const (
	builtins = map{
		'cd': fn (args []string) int {
			if args.len > 1 {
				eprintln('cd only requires one argument')
				return 1
			}
			if args.len == 0 {
				os.chdir(os.getenv('HOME'))
			}
			os.chdir(args[0])
			return 0
		}
	}
)

fn main() {
	// cache all executables in PATH
	mut cached := map[string]string{} // ls:/usr/bin/ls
	paths := os.getenv('PATH').split(':')
	for path in paths {
		ls := os.ls(path) or {
			eprintln('invalid \$PATH: directory $path does not exist')
			exit(1)
		}
		for cmd in ls {
			cmdpath := os.join_path(path, cmd)
			if os.is_executable(cmdpath) && cmd !in cached {
				cached[cmd] = cmdpath
			}
		}
	}
	defer {
		os.execute('stty sane')
	}
	mut history := []string{}
	for {
		os.execute('stty raw icrnl onlret')
		mut cmd_with_args := ''
		print('$ ')
		mut in_escape_begin := false
		mut in_escape := false
		mut history_idx := history.len
		for {
			run := rune(utf8_getchar())
			// println(int(run))
			if in_escape {
				match run {
					`A` { // up arrow
						if history_idx != 0 {
							history_idx--
							print('\x1b[0K$ ')
							print(history[history_idx])
							cmd_with_args = history[history_idx]
						}
					}
					`B` { // down arrow
						if history_idx == history.len {
							continue
						}
						history_idx++
						print('\x1b[0K$ ')
						if history_idx == history.len {
							print('\x1b[0K$ ')
							cmd_with_args = ''
						} else {
							print(history[history_idx])
							cmd_with_args = history[history_idx]
						}
					}
					else {
						eprintln('unknown escape: `${int(run)}`')
						exit(1)
					}
				}
				in_escape = false
				continue
			}
			match run {
				0x03 { // ^C
					cmd_with_args = ''
					print('\n$ ')
				}
				0x04 { // ^D
					return
				}
				0x0a { // \n
					break
				}
				0x1b { // ^[
					in_escape_begin = true
					print('\x1b[3D\x1b[0J')
					continue
				}
				0x5b { // [
					if in_escape_begin {
						in_escape_begin = false
						in_escape = true
						print('\x1b[1D\x1b[0J')
					}
					continue
				}
				0x7f { // ^? or backspace
					if cmd_with_args != '' {
						cmd_with_args = cmd_with_args[..cmd_with_args.len - 1]
						print('\x1b[3D\x1b[0J')
						continue
					}
				}
				else {}
			}
			cmd_with_args += run.str()
		}
		if cmd_with_args == '' {
			continue
		}

		history << cmd_with_args

		split := cmd_with_args.trim_space().split(' ')
		cmd := split[0]
		mut args := split[1..]

		mut cmdpath := cmd
		if cmd in builtins {
			builtins[cmd](args)
			continue
		}
		if !cmd.contains('/') {
			cmdpath = cached[cmd] or {
				eprintln('command not found: $cmd')
				continue
			}
		}
		os.execute('stty raw icrnl onlret isig')
		mut proc := os.new_process(cmdpath)
		proc.set_args(args)
		proc.wait()
	}
}
