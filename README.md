# Katon

## Quick start

```bash
$ express foo && cd foo
$ npm install
$ katon link
$ open http://foo.dev/
```

## Install

```bash
$ npm install -g katon
$ katon install-pow      # In case Pow is not installed
$ npm install -g nodemon # For auto restart feature
$ katon load
```

## Usage

```bash
$ katon -h
# Usage information

$ katon load
# Load Katon daemon

$ katon unload
# Unload Katon daemon

$ katon link
# Link the current dir to ~/.katon/<current_directory>
# and create a Pow proxy ~/.pow/<current_directory>

$ katon unlink
# Unlink current dir

$ katon unlink foo
# Unlink foo app

$ katon list
# List apps linked in ~/.katon

$ katon install-pow
# Install or update Pow

$ katon uninstall-pow
# Uninstall pow
```

## Uninstall

```bash
$ katon uninstall-pow
$ npm remove katon && rm -rf ~/.katon
```

## Logs

```bash
$ tail -f <app_directory>/katon.logs
```

## Feedback

Contribute, feel free to give feedback.

## Test

To run tests:

```
npm test
```
