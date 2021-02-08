module lib

import os

const (
	std_input_handle = -10
)

// get_raw_bytes returns bytes from stdin when detecting the end of the stream
// Ctrl+z on Windows or Ctrl+d on *Nix.
pub fn get_raw_bytes() []byte {
	mut bytes := []byte{}
	max := 4096
	$if windows {
		unsafe {
			h_input := C.GetStdHandle(std_input_handle)
			mut bytes_read := 0
			mut buf := [`0`].repeat(max)
			for {
				res := C.ReadFile(h_input, buf.data, max, &bytes_read, 0)
				if !res || bytes_read == 0 {
					break
				}
				bytes << buf[0..bytes_read]
			}
			C.CloseHandle(h_input)
			return bytes
		}
	} $else {
		stdin := os.open_stdin()
		mut pos := 0
		for {
			bytes << stdin.read_bytes_at(max, pos)
			if bytes.len < max {
				break
			}
			pos += max
		}
		return bytes
	}
}
