module sum

import crypto.md5
import crypto.sha1
import crypto.sha256
import crypto.sha512

import os
import lib

pub enum Hash {
	md5
	sha1
	sha224
	sha256
	sha384
	sha512
}

fn hexsum(algo Hash, data []byte) string {
	mut hash := []u8{}
	match algo {
		.md5 { hash = md5.sum(data) }
		.sha1 { hash = sha1.sum(data) }
		.sha224 { hash = sha256.sum224(data) }
		.sha256 { hash = sha256.sum(data) }
		.sha384 { hash = sha512.sum384(data) }
		.sha512 { hash = sha512.sum512(data) }
	}
	return hash.hex()
}

fn calc_hash_file(file_path string, algo Hash) ?string {
	mut data := []byte{}
	if file_path == '-' {
		data = lib.get_raw_bytes() // read from stdin
	} else {
		data = os.read_bytes(file_path) or {
			eprintln(err)
			return ''
		}
	}
	return hexsum(algo, data)
}

fn calc_hash_stdin(algo Hash) string {
	mut data := []byte{}
	data = lib.get_raw_bytes() // read from stdin
	return hexsum(algo, data)
}

fn calc_hash_string(text string, algo Hash) string {
	return hexsum(algo, text.bytes())
}
