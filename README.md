# Katon

There's something repetitive that we do everyday: open a terminal, start development server, ... and then start coding. 

Using Katon, you can totally forget about manually starting your development servers each time. It will automatically start them for you and serve them locally on .dev domains (a bit like Pow does with Ruby apps).

Katon runs on Mac OS and works with __all__ your usual Node tools and frameworks (Express, Grunt, Gulp, ...).

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

Reboot and go to `http://app.dev`.

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

  link             Link current directory
  link <cmd>       Use custom cmd to start server
  unlink           Unlink current directory
  unlink <app>     Unlink app
  list             List linked apps
  start            Start Katon daemon
  stop             Stop Katon daemon
  restart          Restart Katon daemon
  status           Katon status information

Options:

  -V --verbose     Makes output more verbose
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

# Troubleshoot
 
When opening your app in the browser, you may get errors:
 
`No server found`
 
Check that Pow daemon is running with `katon status`.
 
`Proxy error`
 
Check that Katon daemon is running with `katon status`.
 
`An error has occurred: {"code":"ECONNREFUSED","errno":"ECONNREFUSED","syscall":"connect"}`
 
Your app may not be listening to requests check `katon.log`.
 
`Not found`
 
If you get a 404, it's because your app directory is served using Katon embedded static server and it can't find an `index.html`.

__About nvm__

If you're using nvm and having problems, see discussion in [issue #3](https://github.com/typicode/katon/issues/3). Upcoming versions of Katon should make working with nvm easier.

# Issues and feedback

Katon is a recent project, even though it was successfully tested on my MacBook Air, you may find bugs, have issues or questions. Do not hesitate to fill an [issue](https://github.com/typicode/katon/issues) or contact me [@typicode](https://github.com/typicode). It really helps.

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
