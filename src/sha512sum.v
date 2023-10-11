import cli
import os

import sum

fn main() {
	mut cmd := cli.Command{
		name: 'sha512sum'
		description: 'Prints or checks SHA512 (512-bit) checksums.'
		version: '0.1.0'
		execute: fn (cmd cli.Command) ! { exit(sum.execute(cmd, sum.Hash.sha512)) }
		parent: 0
	}
	sum.init_flags(mut cmd, sum.Hash.sha512)
	cmd.parse(os.args)
}
