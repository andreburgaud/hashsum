import pytest

EXE_DIR='build'
DATA_DIR='tests/data'

def idfn(val):
    return str(val)

data_sum = [
    ('md5sum',
     'db89bb5ceab87f9c0fcc2ab36c189c2c'),
    ('sha1sum',
     'cd36b370758a259b34845084a6cc38473cb95e27'),
    ('sha224sum',
     'b2d9d497bcc3e5be0ca67f08c86087a51322ae48b220ed9241cad7a5'),
    ('sha256sum',
     '2d8c2f6d978ca21712b5f6de36c9d31fa8e96a4fa5d8ff8b0188dfb9e7c171bb'),
    ('sha384sum',
     'd3b5710e17da84216f1bf08079bbbbf45303baefc6ecd677910a1c33c86cb164281f0f2dcab55bbadc5e8606bdbc16b6'),
    ('sha512sum',
     '8ba760cac29cb2b2ce66858ead169174057aa1298ccd581514e6db6dee3285280ee6e3a54c9319071dc8165ff061d77783100d449c937ff1fb4cd1bb516a69b9')
]

# Validates the result of: sha1sum some_file
@pytest.mark.parametrize('exe,digest', data_sum, ids=idfn)
def test_sum(script_runner, exe, digest):
    ret = script_runner.run(f'{EXE_DIR}/{exe}', f'{DATA_DIR}/lorem_ipsum.txt')
    assert ret.success
    first_line = ret.stdout.split('\n')[0]
    assert first_line == f'{digest}  {DATA_DIR}/lorem_ipsum.txt'

# Validates the result of: sha1sum < some_file
@pytest.mark.parametrize('exe,digest', data_sum, ids=idfn)
def test_sum_stdin(script_runner, exe, digest):
    ret = script_runner.run(f'{EXE_DIR}/{exe}', stdin=open(f'{DATA_DIR}/lorem_ipsum.txt', 'r', encoding='utf-8'))
    #assert ret.success
    first_line = ret.stdout.split('\n')[0]
    assert first_line == f'{digest}  -'

# Validates the result of: sha1sum --binary some_file
@pytest.mark.parametrize('exe,digest', data_sum, ids=idfn)
def test_sum_bin(script_runner, exe, digest):
    ret = script_runner.run(f'{EXE_DIR}/{exe}', '--binary', f'{DATA_DIR}/lorem_ipsum.txt')
    assert ret.success
    first_line = ret.stdout.split('\n')[0]
    assert first_line == f'{digest} *{DATA_DIR}/lorem_ipsum.txt'

data_sum_check = [
    ('md5sum', 'md5'),
    ('sha1sum', 'sha1'),
    ('sha224sum', 'sha224'),
    ('sha256sum', 'sha256'),
    ('sha384sum', 'sha384'),
    ('sha512sum', 'sha512')
]

# Validates the result of: sha1sum --check some_file.sha1
@pytest.mark.parametrize('exe,extension', data_sum_check, ids=idfn)
def test_sum_check(script_runner, exe, extension):
    ret = script_runner.run(f'{EXE_DIR}/{exe}', '--check', f'{DATA_DIR}/lorem_ipsum.txt.{extension}')
    assert ret.success
    expected = f'{DATA_DIR}/lorem_ipsum.txt: OK'
    first_line = ret.stdout.split('\n')[0]
    assert first_line == expected
