# Hashsum

Collection of command line [checksum tools](https://en.wikipedia.org/wiki/Checksum) based on similar tools available on Linux and BSD systems. These tools calculate and verify hashes. They are usually intended to verify the integrity of files. The binary files are available for Linux, MacOS and Windows.

Most of these tools are available in some forms in any popular operating systems. I wanted to experiment with the [V Programming Language](https://vlang.io/) to build binaries of these tools for each of these systems.

## MacOS, Linux and BSD Systems

Similar tools are already included by default on Mac, Linux and BSD system. They may have different flavors and options depending on your system.

For example, if you are using Linux, you already have `sha1sum`, but you don't have `sha1`. Both tools overlap and have different options detailed in section **Usage** in this document. 

## Windows

On Windows, you can invoke [Powershell](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/powershell) functions to calculate and verify hashes, but similar tools are not available by default unless you use the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) or  distributions including the Unix tools like:

* [Cygwin](https://www.cygwin.com/)
* [CoreUtils for Windows](http://gnuwin32.sourceforge.net/packages/coreutils.htm)
* [MSYS2](https://www.msys2.org/)

With PowerShell on Windows, you can calculate the MD5 hash of a file as follows:

```
> CertUtil -hashfile README.md MD5
MD5 hash of README.md:
c99041cc08d477b84c8e790bb1285050
CertUtil: -hashfile command completed successfully.
```

## When Would You Need Such Tools?

For example, if you download a Python distribution from https://www.python.org/downloads/release/python-391/, in section **Files**, you will see a list of files with a corresponding [MD5 Sum](https://en.wikipedia.org/wiki/Md5sum). After downloading the corresponding file, you are encouraged to calculate the MD5 hash and compare it with the value in the table. If this is the same value, you have a higher level of confidence that the file has not been tampered with. `md5` or `md5sum` included in this project would allow you to calculate and verify this hash. 

## List of Tools

* Linux Family:
  * md5sum
  * sha1sum
  * sha224sum
  * sha256sum
  * sha384sum
  * sha512sum

* BSD Family:
  * md5
  * sha1
  * sha224
  * sha256
  * sha384
  * sha512

These tools only implement the main options of the original Linux or BSD tools.

## Usage

TBD

## Installation

The most simple is to download the binaries as described in the section **Binaries** below. Skip to section **From Source**, if you feel adventurous, and want to build the tools on your system. 

### Binary

You can download a distribution for your system from [Hashsum GitHub releases](https://github.com/andreburgaud/hashsum/releases).

### From Source

Building the **hashsum** tools requires the [V](https://vlang.io) compiler installed on your system.

First you need to check out the **hashsum** repository:

```
$ git clone git@github.com:andreburgaud/hashsum.git
```

After compilation, you will need to copy the executable in a directory available in your [`PATH`](https://en.wikipedia.org/wiki/PATH_(variable)) to execute the tools from any folder.

#### Build on Windows

```
C:/> cd hashsum
C:/> make build
C:/> dir /b build
md5.exe
md5sum.exe
sha1.exe
sha1sum.exe
sha224.exe
sha224sum.exe
sha256.exe
sha256sum.exe
sha384.exe
sha384sum.exe
sha512.exe
sha512sum.exe
```

#### Build on Linux or Mac

```
$ cd hashsum
$ make build
$ ls -1 build
md5
md5sum
sha1
sha1sum
sha224
sha224sum
sha256
sha256sum
sha384
sha384sum
sha512
sha512sum
```

## Development

TBD

### Testing

Hashsum exposes 2 types of testing:

1. Unit-tests (V unit-tests)
1. CLI tests (Python tests)

For the CLI tests, follow the instructions in the next section.

#### CLI Testing Environment

This testing executes CLI functional tests using [pytest](https://docs.pytest.org/en/stable/) and [pytest-console-scripts](https://pypi.org/project/pytest-console-scripts/) to drive the execution of the command line tools and to validate the output or results.

* Requirements: 
  * Python 3.8 or 3.9
  * PyTest

Create a Python virtual environment on windows:

```
C:/> python -m venv .venv --prompt hashsum
C:/> .venv\Scripts\activate
(hashsum) C:/> python -m pip install --upgrade pip
(hashsum) C:/> python -m pip install --upgrade setuptools
(hashsum) C:/> python -m pip install -r tests/requirements.txt
```

On Linux or Mac:

```
$ python3 -m venv .venv --prompt hashsum
$ . .venv/bin/activate
(hashsum) $ python -m pip install --upgrade pip
(hashsum) $ python -m pip install --upgrade setuptools
(hashsum) $ python -m pip install -r tests/requirements.txt
```

#### CLI Testing Execution

When the environment is ready, you can execute the CLI tests with the following command on Windows:

```
C:/> .venv\Scripts\activate
(hashsum) C:/> pytest -v .
```

On Linux or Max, the Makefile has a task available:

```
$ make pytest
```

## Similar Tools - Other Projects

TBD
