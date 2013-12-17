# Katon

## Quick start

```bash
$ express my-app && cd my-app
$ npm install
$ katon link
$ open http://my-app.dev/
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

$ katon link /path/to/my-app

$ katon link --exec 'node server.js'

$ katon unlink
# Unlink current dir

$ katon unlink my-app
# Unlink my-app

$ katon list
# List apps linked in ~/.katon

$ katon install-pow
# Install or update Pow

$ katon uninstall-pow
# Uninstall pow

$ katon status
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

## Using grunt

TODO update Gruntfile

```bash
$ katon link --exec 'grunt server'
```

## Serving static files

```bash
$ npm install -g node-static
$ katon link --exec 'static'
```

## Feedback

Contribute, feel free to give feedback.

## Test

To run tests:

```
npm test
```
