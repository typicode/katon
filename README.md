# katon [![](https://badge.fury.io/js/katon.svg)](http://badge.fury.io/js/katon) [![](https://travis-ci.org/typicode/katon.svg?branch=master)](https://travis-ci.org/typicode/katon)

> Autostarts your development servers so that you can be more productive

With katon, there's no need anymore to open a Terminal and manually start developement servers each time you want to develop.

Instead, add your development servers once to katon and they'll be autostarted and always accessible on local .ka domains.

<p align="center">
  <img src="http://i.imgur.com/ovO1g86.png"><br>
  <a href="http://i.imgur.com/7oPMSbm.png">Click here to view a screenshot of katon + Express + Rails</a>
</p>

__katon supports any server: Node, Ruby, Python, Go, Java, PHP, ...__ that can be started with a command-line and runs on Mac OS (Yosemite included).

## Install

Make sure [Node](http://nodejs.org/download/) is installed first, then:

```bash
$ npm install -g katon
```

To manually install katon, you can run `sudo katon install && katon start`.

## Add servers

```bash
$ katon add 'nodemon'
$ katon add 'npm start'
$ katon add 'grunt server'
$ katon add 'rails server --port $PORT'
$ katon add 'python -m SimpleHTTPServer $PORT'
```

To add a server with a different name than its directory.

```bash
$ katon add 'grunt server' my-custom-name
Application is now available at http://my-custom-name.ka
```

__Note__: it's important to use `'` and not `"` to avoid `$PORT` to be evaluated.

Port is dynamically set by katon using `PORT` environment variable but can be passed as a parameter using `$PORT`.

In case your server doesn't accept a port parameter, you can retrieve the `PORT` environment variable in your code. For example, for a Node server you would write something like:

```javascript
var port = process.env.PORT || 3000;
```

The same technique can be applied with other languages too.

## Subdomains

When adding a server, you can access it by its URL `http://app.ka`. But you can also use subdomains (e.g. `http://foo.app.ka`, `http://bar.app.ka`, ...).

If you want to map a server to a subdomain, let's say `api.app.ka`, simply use `katon add <cmd> api.app`.

## xip.io

katon is also fully compatible with [xip.io](http://xip.io/) service.

## Logs

Server logs are stored in `~/.katon/logs/<app_name>.log`, to view them you can use:

```bash
$ katon tail [app_name]
$ katon tail all # View all logs
```

## Version managers

katon works with any version manager, simply set the desired version before adding your server and katon will remember it.

```bash
$ nvm use 0.11 && katon add 'npm start'
$ rbenv local 2.0.0-p481 && katon add 'rails server --port $PORT'
```

Depending on your version manager, you may need to add environment variables.

```bash
$ rvm use ruby-2.0.0-p576 && katon add 'bundle exec unicorn' --env GEM_PATH
# Will use GEM_PATH previously set by rvm
```

For Node users, to keep access to katon CLI accross Node versions, add an alias to your .profile and reopen the Terminal.

```bash
echo "alias katon=`which katon`" >> ~/.profile
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
