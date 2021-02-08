import cli
import os

import sum

fn main() {
	mut app := cli.Command{
		name: 'sha1sum'
		description: 'Prints or checks SHA1 (160-bit) checksums.'
		version: '0.1.0'
		execute: fn (cmd cli.Command) ? { exit(sum.execute(cmd, sum.Hash.sha1)) }
		parent: 0
	}
	sum.init_flags(mut app, sum.Hash.sha1)
	app.parse(os.args)
}
