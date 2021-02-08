import lib

fn test_split_into_words() {
	line := 'cd36b370758a259b34845084a6cc38473cb95e27 example.txt'
	res := lib.split_into_words(line, 2)
	hash := res[0]
	assert hash == 'cd36b370758a259b34845084a6cc38473cb95e27'
	file := res[1]
	assert file == 'example.txt'
	assert res.len == 2
}

fn test_split_into_words_spaces() {
	line := 'cd36b370758a259b34845084a6cc38473cb95e27       example.txt'
	res := lib.split_into_words(line, 2)
	hash := res[0]
	assert hash == 'cd36b370758a259b34845084a6cc38473cb95e27'
	file := res[1]
	assert file == 'example.txt'
	assert res.len == 2
}

fn test_split_into_words_multi() {
	line := 'cd36b370758a259b34845084a6cc38473cb95e27       example.txt example2.txt example3.txt'
	res := lib.split_into_words(line, 2)
	hash := res[0]
	assert hash == 'cd36b370758a259b34845084a6cc38473cb95e27'
	file := res[1]
	assert file == 'example.txt example2.txt example3.txt'
	assert res.len == 2
}

fn test_split_into_words_tab() {
	line := 'cd36b370758a259b34845084a6cc38473cb95e27	example.txt'
	res := lib.split_into_words(line, 2)
	hash := res[0]
	assert hash == 'cd36b370758a259b34845084a6cc38473cb95e27'
	file := res[1]
	assert file == 'example.txt'
	assert res.len == 2
}

fn test_split_into_words_fewer_fields() {
	line := 'cd36b370758a259b34845084a6cc38473cb95e27'
	res := lib.split_into_words(line, 2)
	hash := res[0]
	assert hash == 'cd36b370758a259b34845084a6cc38473cb95e27'
	assert res.len == 1
}