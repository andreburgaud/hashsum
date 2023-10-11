import cli
import os

import sum

fn main() {
	mut cmd := cli.Command{
		name: 'sha384sum'
		description: 'Prints or checks SHA384 (384-bit) checksums.'
		version: '0.1.0'
		execute: fn (cmd cli.Command) ! { exit(sum.execute(cmd, sum.Hash.sha384)) }
		parent: 0
	}
	sum.init_flags(mut cmd, sum.Hash.sha384)
	cmd.parse(os.args)
}
