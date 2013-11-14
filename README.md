# katon

## Quick start

```bash
$ express foo && cd foo
$ npm install

$ katon link
# Open http://foo.dev/
```

## Install

```bash
$ npm install -g katon
$ katon install-pow # in case Pow is not installed
$ katon start
```


## Usage

```bash
$ katon start
# Starts Katon daemon

$ katon stop
# Stops Katon daemon

$ katon link
# Links the current dir to ~/.katon/<current_directory>
# and create a Pow proxy ~/.pow/<current_directory>

$ katon unlink
# Removes link and file created by katon link

$ katon list
# Lists apps linked in ~/.katon

$ katon install
# Installs or updates Pow
```

## Test

To run tests:

```
npm test
```
