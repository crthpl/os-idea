module errors

import os

pub fn args_len(args []string, _expect_len int) {
	expect_len := _expect_len + 1
	if args.len != expect_len {
		base := os.base(args[0]) // os.args contains the entire command given in the shell.
		eprintln('$base expects $expect_len arguments, but got $args.len arguments')
		exit(-2)
	}
}
