import cli
import os

import sum

fn main() {
	mut cmd := cli.Command{
		name: 'md5sum'
		description: 'Prints or checks MD5 (128-bit) checksums.'
		version: '0.1.0'
		execute: fn (cmd cli.Command) ? { exit(sum.execute(cmd, sum.Hash.md5)) }
		parent: 0
	}
	sum.init_flags(mut cmd, sum.Hash.md5)
	cmd.parse(os.args)
}
