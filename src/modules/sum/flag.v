module sum

import cli

// ================
// LINUX-LIKE FLAGS
// ================

// init_flags initializes the flags of the Linux sum command
pub fn init_flags(mut cmd &cli.Command, algo Hash) {
	check_description := 'Reads $algo sums from the FILEs and checks them'
	check_flag := init_check_flag(check_description)
	bin_flag := init_bin_flag()
	text_flag := init_text_flag()
	for flag in [check_flag, bin_flag, text_flag] {
		cmd.add_flag(flag)
	}
}

// init_check_flag initializes the check flag
fn init_check_flag(description string) cli.Flag {
	return cli.Flag{
		flag: .bool
		required: false
		name: 'check'
		abbrev: 'c'
		description: description
	}
}

// init_check_flag initializes the binary flag
fn init_bin_flag() cli.Flag {
	return cli.Flag{
		flag: .bool
		required: false
		name: 'binary'
		abbrev: 'b'
		description: 'Reads in binary mode'
	}
}

// init_check_flag initializes the text flag
fn init_text_flag() cli.Flag {
	return cli.Flag{
		flag: .bool
		required: false
		name: 'text'
		abbrev: 't'
		description: 'Reads in text mode (default)'
	}
}

// get_bool_flag returns a flag of type bool
fn get_bool_flag(cmd cli.Command, flag_name string) bool {
	flag := cmd.flags.get_bool(flag_name) or {
		false
	}
	return flag
}

// get_string_flag returns a flag of type string
fn get_string_flag(cmd cli.Command, flag_name string) string {
	flag := cmd.flags.get_string(flag_name) or {
		''
	}
	return flag
}

// get_bin_flag returns the value of the binary flag
fn get_bin_flag(cmd cli.Command) bool {
	return get_bool_flag(cmd, 'binary')
}

// get_bin_flag returns the value of the text flag
fn get_text_flag(cmd cli.Command) bool {
	return get_bool_flag(cmd, 'text')
}

// get_bin_flag returns the value of the check flag
fn get_check_flag(cmd cli.Command) bool {
	return get_bool_flag(cmd, 'check')
}

// ==============
// BSD-LIKE FLAGS
// ==============

// init_bsd_flags initializes BSD sum flags
pub fn init_bsd_flags(mut cmd &cli.Command) {
	check_flag := init_check_bsd_flag()
	string_flag := init_string_bsd_flag()
	print_flag := init_print_bsd_flag()
	quiet_flag := init_quiet_bsd_flag()
	reverse_flag := init_reverse_bsd_flag()
	for flag in [check_flag, string_flag, print_flag, quiet_flag, reverse_flag] {
		cmd.add_flag(flag)
	}
}

// init_flags initializes the flags of the BSD sum command
fn init_check_bsd_flag() cli.Flag {
	return cli.Flag{
		flag: .string
		name: 'check'
		abbrev: 'c'
		description: 'Compare the digest of the file against this string'
	}
}

fn init_string_bsd_flag() cli.Flag {
	return cli.Flag{
		flag: .string
		name: 'string'
		abbrev: 's'
		description: 'Prints a checksum of the given string'
	}
}

fn init_print_bsd_flag() cli.Flag {
	return cli.Flag{
		flag: .bool
		name: 'print'
		abbrev: 'p'
		description: 'Echo stdin to stdout and append the checksum to stdout'
	}
}

fn init_quiet_bsd_flag() cli.Flag {
	return cli.Flag{
		flag: .bool
		name: 'quiet'
		abbrev: 'q'
		description: 'Quiet mode -- only the checksum is printed out. Overrides the -r option.'
	}
}

fn init_reverse_bsd_flag() cli.Flag {
	return cli.Flag{
		flag: .bool
		name: 'reverse'
		abbrev: 'r'
		description: 'Reverses the format of the output'
	}
}
