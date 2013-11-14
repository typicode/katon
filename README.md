# Katon

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
$ katon load
```

## Usage

```bash
$ katon load
# Load Katon daemon

$ katon unload
# Unload Katon daemon

$ katon link
# Link the current dir to ~/.katon/<current_directory>
# and create a Pow proxy ~/.pow/<current_directory>

$ katon unlink
# Remove link and file created by katon link

$ katon list
# List apps linked in ~/.katon

$ katon install
# Install or update Pow
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
