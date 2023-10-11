module sum

import cli
import os

import lib

const (
	success = 0
	error   = 1
)

// is_valid check if the given file exists and is a file (not a directory)
pub fn is_valid(cmd_name string, path string) bool {
	if path == "-" { // stdin
		return true
	}
	if !os.exists(path) {
		eprintln("${cmd_name}: ${path}: No such file or directory")
		return false
	}
	if os.is_dir(path) {
		eprintln("${cmd_name}: ${path}: Is a directory")
		return false
	}
	return true
}

// ==================================
// LINUX-LIKE COMMAND LINE PROCESSING
// ==================================

pub struct SumOptions {
	name string     // Command name
	files []string  // Command arguments (files)
	algo Hash
	bin_flag bool
	check_flag bool
}

// execute is the entry point of the Linux-like sum command (ex: md5sum, sha1sum...)
pub fn execute(cmd cli.Command, algo Hash) int {
	mut result := success
	options := SumOptions {
		name: cmd.name
		files: cmd.args
		algo: algo
		bin_flag: get_bin_flag(cmd)
		check_flag: get_check_flag(cmd)
	}
	if options.check_flag {
		result = options.process_files_check()
	} else {
		result = options.process_files()
	}
	return result
}

// execute is the entry point of the Linux-like sum command (ex: md5sum, sha1sum...)
// TODO: continue converting in this format (replace cli with flag)
pub fn exec(options SumOptions, algo Hash) int {
	mut result := success
	if options.check_flag {
		result = options.process_files_check()
	} else {
		result = options.process_files()
	}
	return result
}

fn (o SumOptions) process_files() int {
	mut result := success
	mut files := o.files.clone()
	if files.len == 0 {
		// Read from stdin
		files << '-'
	}
	for file in files {
		if !is_valid(o.name, file) {
			result = error
			continue
		}
		hex_digest := calc_hash_file(file, o.algo) or {
			result = error
			eprintln(err)
			continue
		}
		// hex_digest is an empty strying, typically the file does not exist
		if hex_digest.len == 0 {
			result = error
			continue
		}
		print_digest(file, hex_digest, o.bin_flag)
	}
	return result
}

// process_files processes each check file entered as argument at the command line
// A check file is a file containing a list of files to be checked against. A line in
// a check file is as follows:
// <hash> <file_name>
// For each file in the list, the program calculates the hash and compare it with 
// the first field in the line
fn (o SumOptions) process_files_check() int {
	mut files := o.files.clone()
	if files.len == 0 {
		// Read from stdin
		files << '-'
	}
	for check_file in files {
		if !is_valid(o.name, check_file) {
			continue
		}
		lines := os.read_lines(check_file) or {
			eprintln(err)
			continue
		}
		mut bad_fmt := 0
		mut bad_compute := 0
		for line in lines {
			if line.trim_space().len == 0 {
				bad_fmt++
				continue
			}
			words := lib.split_into_words(line, 2)
			if words.len != 2 {
				bad_fmt++
				continue
			}
			hash := words[0]
			mut file_name := words[1]
			if file_name.starts_with('*') {
				file_name = file_name[1..]
			}
			hex_digest := calc_hash_file(file_name, o.algo) or {
				eprintln(err)
				continue
			}
			if hash.len != hex_digest.len {
				bad_fmt++
				continue
			}
			if hash == hex_digest {
				println('${file_name}: OK')
			} else {
				println('${file_name}: FAILED')
				bad_compute++
			}
		}
		if bad_compute > 0 {
			if bad_compute == 1 {
				eprintln('WARNING: 1 computed checksum did NOT match')
			} else {
				eprintln('WARNING: $bad_compute computed checksums did NOT match')
			}
		}
		if bad_fmt > 0 {
			if bad_fmt == 1 {
				eprintln('WARNING: 1 line is not properly formatted')
			} else {
				eprintln('WARNING: $bad_fmt lines are not properly formatted')
			}
		}
	}
	return 0
}

// print_digest prints a line composed of 2 fields:
// - the hexadecimal digest of the hash
// - the file name
fn print_digest(file_path string, hex_digest string, binary bool) {
	mut mode := ' '
	if binary {
		mode = '*'
	}
	println('${hex_digest} ${mode}${file_path}')
}

// ================================
// BSD-LIKE COMMAND LINE PROCESSING
// ================================

struct SumBsdOptions {
	name string     // Command name
	files []string  // Command arguments (files)
	algo Hash
	quiet_flag bool
	reverse_flag bool
	bin_flag bool
	check_hash string
	string_to_hash string
}

// TODO: handle the print
// execute is the entry point of the BSD-like sum command (ex: md5, sha1...)
pub fn execute_bsd(cmd cli.Command, algo Hash) int {
	mut result := success
	options := SumBsdOptions {
		name: cmd.name
		files: cmd.args
		algo: algo
		quiet_flag: get_bool_flag(cmd, 'quiet')
		reverse_flag: get_bool_flag(cmd, 'reverse')
		check_hash: get_string_flag(cmd, 'check')
		string_to_hash: get_string_flag(cmd, 'string')	
	}
	if options.check_hash.len > 0 {
		result = options.process_bsd_files_check()
		return result
	}
	if options.string_to_hash.len > 0 {
		result = options.execute_bsd_string()
		return result
	}
	result = options.process_bsd_files()
	return result
}

// process_bsd_files processes input: if not arguments, takes stdin as input, otherwise
// process each file sequentially. It does not handle '-' as stdin like the GNU style sum
// utils.
fn (o SumBsdOptions) process_bsd_files() int {
	mut result := success
	mut files := o.files.clone()
	if files.len == 0 {
		hex_digest := calc_hash_stdin(o.algo)
		println(hex_digest)
	} else {
		for file_name in files {
			if !is_valid(o.name, file_name) {
				result = error
				continue
			}
			hex_digest := calc_hash_file(file_name, o.algo) or {
				eprintln(err)
				result = error
				continue
			}
			// hex_digest is an empty strying, typically the file does not exist
			if hex_digest.len == 0 {
				result = error
				continue
			}
			println(get_bsd_output(o.algo, file_name, hex_digest, o.quiet_flag, o.reverse_flag,
				true))
		}
	}
	return result
}

// get_bsd_output
fn get_bsd_output(algo Hash, file_name string, hash string, quiet bool, reverse bool, success bool) string {
	mut output := ''
	algo_upper := '$algo'.to_upper()
	if quiet { // Just the hash
		return hash
	}
	if reverse {
		output = '$hash $file_name'
	} else {
		output = '$algo_upper ($file_name) = $hash'
	}
	if !success {
		return output + ' [Failed]'
	}
	return output
}

// execute_bsd_check validates that the hash passed as a check option argument
// is equal to the calculated hash of all the other files passed as arguments.
// Example:
// $ sha1 -c <some_hash> file1 file1 file2
// SHA1(file1) = <some_hash>
// SHA1(file1) = <some_hash>
// SHA1(file2) = <some_hash> [ Failed ]
// $ echo $?
// 2
// ========================================================
// $ sha1 -c <some_hash> file1 file1 file3
// SHA1(file1) = <some_hash>
// SHA1(file1) = <some_hash>
// sha1: file3: No such file or directory
// $ echo $?
// 1
// ========================================================
// The last error will be returned (error = 1)
fn (o SumBsdOptions) process_bsd_files_check() int {
	mut result := success
	if o.files.len < 1 {
		eprintln('At least 1 file is required')
		return error
	}

	for file_name in o.files {
		if !is_valid(o.name, file_name) {
			continue
		}
		hex_digest := calc_hash_file(file_name, o.algo) or {
			eprintln(err)
			result = error
			continue
		}
		ok := (hex_digest == o.check_hash)
		if ok {
			result = success
		} else {
			result = error
		}
		println(get_bsd_output(o.algo, hex_digest, file_name, o.quiet_flag, o.reverse_flag,
			ok))
	}
	return result
}

// execute_bsd_string generates the hash for a given string. All other arguments, if any,
// are expected to be files and process sequentially
fn (o SumBsdOptions) execute_bsd_string() int {
	mut result := success
	mut hex_digest := calc_hash_string(o.string_to_hash, o.algo)
	println(get_bsd_output(o.algo, '"$o.string_to_hash"', hex_digest, o.quiet_flag, o.reverse_flag,
		true))
	for file_name in o.files {
		hex_digest = calc_hash_file(file_name, o.algo) or {
			eprintln(err)
			result = error
			continue
		}
		if hex_digest.len == 0 {
			continue
		}
		println(get_bsd_output(o.algo, file_name, hex_digest, o.quiet_flag, o.reverse_flag,
			true))
	}
	return result
}
