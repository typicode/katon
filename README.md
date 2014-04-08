# Katon

__Katon is all about saving you time during development.__

There's something repetitive that we do: open a terminal, start development server, ... and then start coding.

Using Katon, you can totally forget about manually starting development servers each time. Instead, link them once to Katon and it will automatically start them for you and serve them locally on .dev domains.

Katon runs on Mac OS and works with __all__ your usual tools (Express, Grunt, Gulp, ...).

[![NPM version](https://badge.fury.io/js/katon.png)](http://badge.fury.io/js/katon)

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

Close your terminal and go to `http://app.dev`.

Open a text editor and try to make some changes to the code (Katon uses [nodemon](https://github.com/remy/nodemon) to monitor changes).

Reboot and go to `http://app.dev/`.

# Install

Katon requires [Pow](http://pow.cx/) to be installed. If it's not, run this:

```
curl get.pow.cx | sh
```

You can then proceed installing Katon.

```
npm install -g katon
katon start
```

This will install Katon CLI and start Katon daemon. You just have to do this once.

# CLI usage

```
Usage: katon <command> [options]

Commands:

  link               Link current dir
  link <cmd>         Link current dir and use cmd to start server
  unlink             Unlink current dir
  unlink <app_name>  Unlink app
  list               List linked apps
  open               Open current app in browser
  start              Start Katon daemon
  stop               Stop Katon daemon
  status             Katon status information
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
katon link 'harp --port $PORT'
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

1. `.katon` file content, which is created when you pass a custom cmd to link
2. `package.json` > `main`
3. `package.json` > `scripts` > `start`

If it doesn't find `.katon`, `main` or `start` in `package.json`, Katon will serve files from app directory using a static server.

If `main` file property is set, Katon will always use `nodemon` to run the file.

If `start` script uses `node`, Katon will replace it with `nodemon` at runtime.  However, if `start` script uses something else than `node`, Katon will just start it as `npm start` would.

# How ports are set

Internally, Katon manages ports (starting at 4001) for linked apps. 

Whenever it starts an app, it sets the corresponding port in a PORT environment variable. In your code, you'll usually write something like this to get PORT or use a default port:

```javascript
var port = 3000 || process.env.PORT;
```

But, if needed, you can also use `$PORT` in commands. It will be replaced at runtime by Katon.

```
katon link 'harp --port $PORT'
```

# Multiple versions of Node

If you've installed [nvm](https://github.com/creationix/nvm), Katon will use your app `.nvmrc` or `~/.nvm/alias/default` to determine which version to use.

# Troubleshoot

`No server found`

Check that Pow daemon is running with `katon status`.

`Proxy error`

Check that Katon daemon is running with `katon status`.

`An error has occurred: {"code":"ECONNREFUSED","errno":"ECONNREFUSED","syscall":"connect"}`

Your app may not be listening to requests check `katon.log`.

`Not found`

If you get a 404, it's because your app directory is served using Katon embedded static server and it can't find an `index.html`.

You may also want to check `katon.log` for more informations or run `katon` with `--verbose` option.

# Contribute

Katon is a recent project, you may find bugs, have issues, suggestions or questions. Do not hesitate to fill an [issue](https://github.com/typicode/katon/issues) or contact me [@typicode](https://github.com/typicode).

If you want to add a new feature, it's recommended to create an issue to discuss it before starting to code it.

# Uninstall

Just run this script and everything will be cleaned.

```
katon stop && rm -rf ~/.katon && npm rm -g katon
```

# Credits

* [Pow](http://pow.cx/) for inspiration and proxying requests.
* [nodemon](https://github.com/remy/nodemon) for restarting Node apps on code change.
* [Powder](https://github.com/rodreegez/powder) for CLI inspiration.

# License

Katon is released under the MIT License.