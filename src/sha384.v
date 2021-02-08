import cli
import os

import sum

fn main() {
	mut cmd := cli.Command{
		name: 'sha384'
		description: 'Calculate a message-digest fingerprint (checksum) for a file'
		version: '0.1.0'
		execute: fn (cmd cli.Command) ? { exit(sum.execute_bsd(cmd, sum.Hash.sha384)) }
		parent: 0
	}
	sum.init_bsd_flags(mut cmd)
	cmd.parse(os.args)
}
