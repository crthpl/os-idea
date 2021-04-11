module main

import os
import errors

fn main() {
	errors.args_len(os.args, 1)
	os.chdir(os.args[1])
}
