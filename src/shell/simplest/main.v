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

	for {
		cmd_with_args := os.input_opt('$ ') or { exit(0) }
		if cmd_with_args == '' {
			continue
		}

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

		mut proc := os.new_process(cmdpath)
		proc.set_args(args)
		proc.wait()
	}
}
