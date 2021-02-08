module sum

fn test_md5_string() {
	expected := 'f71dbe52628a3f83a77ab494817525c6'
	res := calc_hash_string('toto', Hash.md5)
	assert expected == res
}

fn test_sha1_string() {
	expected := '0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c'
	res := calc_hash_string('toto', Hash.sha1)
	assert expected == res
}

fn test_sha224_string() {
	expected := '21c043eecd7e85423a72dae3c062a2b5bfa0e6b35ce3fe788c9b57a6'
	res := calc_hash_string('toto', Hash.sha224)
	assert expected == res
}

fn test_sha256_string() {
	expected := '31f7a65e315586ac198bd798b6629ce4903d0899476d5741a9f32e2e521b6a66'
	res := calc_hash_string('toto', Hash.sha256)
	assert expected == res
}

fn test_sha384_string() {
	expected := 'eeb7aaa5565aa8ef732ec9a2999cd72258b2df354fbaf735b9cdf36169cd0e8484c667e42c31bc0d932995723b88a3dc'
	res := calc_hash_string('toto', Hash.sha384)
	assert expected == res
}

fn test_sha512_string() {
	expected := '10e06b990d44de0091a2113fd95c92fc905166af147aa7632639c41aa7f26b1620c47443813c605b924c05591c161ecc35944fc69c4433a49d10fc6b04a33611'
	res := calc_hash_string('toto', Hash.sha512)
	assert expected == res
}
