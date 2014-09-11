# katon [![](https://badge.fury.io/js/katon.svg)](http://badge.fury.io/js/katon) [![](https://travis-ci.org/typicode/katon.svg?branch=master)](https://travis-ci.org/typicode/katon)

> Autostarts your development servers so that you can be more productive

With katon, there's no need anymore to open a Terminal and manually start developement servers each time you want to develop.

Instead, add your development servers once to katon and they'll be autostarted and always accessible on local .ka domains.

![](http://i.imgur.com/7oPMSbm.png)

__katon supports any server (Node, Ruby, Python, Go, Java, ...)__ that can be started with a command-line and runs on Mac OS (even Yosemite).

## Install

```bash
$ npm install -g katon
$ sudo katon install && katon start
```

_Note: If you were already using katon, run `katon migrate` after installing katon 0.5 to keep your servers._

## Add servers

```bash
$ katon add 'nodemon'
$ katon add 'npm start'
$ katon add 'grunt server'
$ katon add 'rails server --port $PORT'
$ katon add 'python -m SimpleHTTPServer $PORT'
```

Port is dynamically set by katon using `PORT` environment variable.

Here's how to retrieve it in Node servers if you can't pass it as a parameter:

```javascript
var port = process.env.PORT || 3000;
```

## Version managers

katon works with any version manager, simply set the desired version before adding your server and katon will remember it.

```bash
$ nvm use 0.11 && katon add 'npm start'
$ rbenv local 2.0.0-p481 && katon add 'rails server --port $PORT'
```

For Node users, to keep access to katon CLI accross Node versions, add an alias to your .profile and reopen the Terminal.

```
echo "alias katon=`which katon`" >> ~/.profile
```

## Logs

Server logs are stored in `<server_dir>/katon.log`, to view them run:

```bash
$ tail -f katon.log
```

## Troubleshoot

Run `katon status` or check `~/.katon/daemon.log`.

If you're stuck, feel free to create an issue.

## Uninstall

```bash
$ npm rm -g katon
```

This will run the uninstall script wich does basically `katon stop && sudo katon uninstall`. To remove katon completely, run also `rm -rf ~/.katon`.

# Credits

* [Pow](http://pow.cx/) for daemon inspiration.
* [Powder](https://github.com/rodreegez/powder) for CLI inspiration.

# License

katon is released under the MIT License.
