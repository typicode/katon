# katon [![](https://badge.fury.io/js/katon.svg)](http://badge.fury.io/js/katon) [![](https://travis-ci.org/typicode/katon.svg?branch=master)](https://travis-ci.org/typicode/katon)

> Access your dev servers by their names

katon is a development tool that makes dev servers __accessible__ on __beautiful__ local .ka domains. It also __autostarts/stops__ them for you.

![](http://i.imgur.com/AyFpCHj.png)

katon supports any server: __Node, Ruby, Python, Go, Java, PHP, ...__ that can be started with a command-line and runs on __OS X__.

## Install

Make sure [Node](http://nodejs.org/download/) is installed first, then:

```bash
$ npm install -g katon
```

To manually install katon, you can run `sudo katon install && katon start`.

_Known issue: if Apache is running, it needs to be stopped to avoid conflict with katon._

## Add servers

```bash
$ katon add 'nodemon'
$ katon add 'npm start'
$ katon add 'grunt server'
$ katon add 'rails server --port $PORT'
$ katon add 'python -m SimpleHTTPServer $PORT'
$ katon add 'php -S 127.0.0.1:$PORT'
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

## How it works
- When you add a server using the `katon add` command, its configuration is saved locally to `~/.katon/hosts/<app>` and an equivalent `~/.katon/logs/<app>` directory is also created.
- The server is not started until you make your first request to your `<app>.ka` domain.
- If no request is made to your `<app>.ka` server within an hour, then katon automatically stops it. Therefore, Katon automatically manages resources by starting only needed servers and stopping them when they're not used.

## Subdomains

When adding a server, you can access it by its URL `http://app.ka`. But you can also use subdomains (e.g. `http://foo.app.ka`, `http://bar.app.ka`, ...).

If you want to map a server to a subdomain, let's say `api.app.ka`, simply use `katon add <cmd> api.app`.

## Access from other devices

Using [xip.io](http://xip.io/) you can access your servers from other devices (iPad, iPhone, ...) on your LAN.

```
# Let's say your local address is 192.168.1.12
http://<app_name>.192.168.1.12.xip.io/
```

_You can find your local address using `ifconfig` or going to index.ka_

## Remote access behind NAT/firewall

Using [ngrok.com](http://ngrok.com/) you can share access to your servers with others, when running behind a firewall or NAT.

First, follow the instructions to install ngrok, then [register on the site](https://dashboard.ngrok.com/user/signup) to enable custom subdomains.

Then run ngrok with your application name as the subdomain:

```
ngrok http -subdomain app_name 80
```

This exposes port 80 to the internet on *app_name.ngrok.io*. **Use at your own risk: all of your web hosts are accessible on this port while ngrok is running.**

## Access using HTTPS

You can also use HTTPS to access your servers `https://<app_name>.ka`.

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
