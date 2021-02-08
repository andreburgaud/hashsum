module lib

// Split a string into words. Words are separated by spaces (spaces, tabs...).
// Example 1:
// given s = "cd36b370758a259b34845084a6cc38473cb95e27       example.txt example2.txt example3.txt"
// split_into_words(s, 2) returns:
// ['cd36b370758a259b34845084a6cc38473cb95e27', 'example.txt example2.txt example3.txt']
// Example 2:
// given s = "cd36b370758a259b34845084a6cc38473cb95e27 example.txt"
// split_into_words(s, 2) returns:
// ['cd36b370758a259b34845084a6cc38473cb95e27', 'example.txt']
pub fn split_into_words(s string, nth int) []string {
	mut res := []string{}
	str := s.trim_space()
	if str.len == 0 {
		return res
	}
	mut start := 0
	for i := 0; i < str.len; i++ {
		if str[i].is_space() {
			if !str[i - 1].is_space() {
				res << str[start..i]
				if res.len == nth {
					break
				}
			}
			start = i + 1
		}
	}
	if res.len == nth {
		// The last element was added because there were other words after the nth word
		res[res.len-1] = str[start..str.len].trim_space()
	} else {
		// No other space found, need to add the remaining part of the string
		res << str[start..str.len]
	}
	return res
}