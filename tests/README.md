# Functional Tests

* Execute functional tests using pytest and pytest-console-scripts
* The python script drives execution of the command line tool and validate the output or results

## Initial Environment

* Requirement: Python 3.9.1

Create a Python virtual environment on windows:

```
C:/> cd tests
C:/> python -m venv .venv --prompt wincoretools
C:/> .venv\Scripts\activate
(wincoretools) C:/> python -m pip install --upgrade pip
(wincoretools) C:/> python -m pip install --upgrade setuptools
(wincoretools) C:/> python -m install -r requirements.txt
```

On Linux:

```
$ cd tests
$ python -m venv .venv --prompt wincoretools
$ . .venv/bin/activate
(wincoretools) $ python -m pip install --upgrade pip
(wincoretools) $ python -m pip install --upgrade setuptools
(wincoretools) $ python -m install -r requirements.txt
```

## Execute Tests

From the root of the project, on Windows:

```
C:/> cd tests
C:/> . .venv\Scripts\activate
(wincoretools) C:/> pytest -v .
```

From the root of the project, on Linux:

```
$ cd tests
$ . .venv/bin/activate
(wincoretools) $ pytest -v .
```
