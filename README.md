# katon

__Katon is all about saving you time during development.__

There's something repetitive that we do: open a terminal, start development server, ... and then start coding.

Using katon, you can totally forget about manually starting development servers each time. Instead, link them once to katon and it will automatically start them for you and serve them locally on .ka domains.

katon runs on Mac OS and works with __all__ your usual tools (Express, Grunt, Gulp, ...).

[![NPM version](https://badge.fury.io/js/katon.svg)](http://badge.fury.io/js/katon)
[![Build Status](https://travis-ci.org/typicode/katon.svg?branch=master)](https://travis-ci.org/typicode/katon)

# Example

For instance, create an Express app.

```
mkdir app
cd app
express && npm install
```

Link it.

```
katon link
```

Close your terminal and go to `http://app.ka`.

Open a text editor and try to make some changes to the code (katon uses [nodemon](https://github.com/remy/nodemon) to monitor changes).

Reboot and go to `http://app.ka/`.

# Install

```
npm install -g katon
```

This will install katon CLI and start Katon daemon.

# CLI usage

```
Usage: katon <command> [options]

Commands:

  link               Link current dir
  link <cmd>         Link current dir and use cmd to start server

  unlink             Unlink current dir
  unlink <app_name>  Unlink app

  open               Open current dir in browser
  open <app_name>    Open app in browser

  list               List linked apps

  start              Start daemon
  stop               Stop daemon
  status             Status information
```

If you use `npm start` to start your app or if `package.json` has a `main` file property, just run this from you app directory.

```
katon link
```

If you use another command.

```
katon link 'grunt server watch'
```

If you need to supply a port to listen on, use `$PORT`.

```
katon link 'harp server --port $PORT'
```

It works also with non node servers.

```
katon link 'python -m SimpleHTTPServer $PORT'
```

If you want to serve static files, just make sure that if a `package.json` is present, it has no `main` or `start` property.

```
katon link
```

# View app logs

Katon stores app output in `katon.log`, to view logs run this from your app directory.

```
tail -f katon.log
```

# How apps are started

Katon will try to start app using (in this order):

1. `.katon` file content, which is created when you pass a custom cmd to `katon link`
2. `package.json` > `main`
3. `package.json` > `scripts` > `start`

If it doesn't find `.katon`, `main` or `start` in `package.json`, Katon will serve files from app directory using a static server.

If `main` file property is set, Katon will always use `nodemon` to run the file.

If `start` script uses `node`, Katon will replace it with `nodemon` at runtime.  However, if `start` script uses something else than `node`, Katon will just start it as `npm start` would.

# How ports are set

Internally, Katon manages ports (starting at 4001) for linked apps.

Whenever it starts an app, it sets the corresponding port in a PORT environment variable. In your code, you'll usually write something like this to get PORT or use a default port:

```javascript
var port = process.env.PORT || 3000;
```

But, if needed, you can also use `$PORT` in commands. It will be replaced at runtime by Katon.

```
katon link 'harp server --port $PORT'
```

# Multiple versions of Node

If you've installed [nvm](https://github.com/creationix/nvm), Katon will use your app `.nvmrc` or `~/.nvm/alias/default` to determine which version to use.

# Troubleshoot

__No server found__

Check that katon daemon is running using `katon status`.

__Not found__

If you get a 404, it's because your app directory is served using Katon embedded static server and it can't find an `index.html`.

__execvp()__

This usually means that you're trying to run a command that is not in katon PATH. To fix this, link your bin in `/usr/local/bin`.

__.dev not working__

katon apps now are served on .ka domains. If you're using Pow alongside katon, make sure that Pow DNS port is 20559.

Feel free also to create an issue if you're stuck.

# Contribute

Katon is a recent project, you may find bugs, have issues, suggestions or questions. Do not hesitate to fill an [issue](https://github.com/typicode/katon/issues) or contact me [@typicode](https://github.com/typicode).

If you want to add a new feature, it's recommended to create an issue to discuss it before starting to code it.

# Credits

* [Pow](http://pow.cx/) for inspiration.
* [nodemon](https://github.com/remy/nodemon) for restarting Node apps on code change.
* [Powder](https://github.com/rodreegez/powder) for CLI inspiration.

# License

Katon is released under the MIT License.
