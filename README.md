# wpas
wpas is a companion to [wp-cli](https://github.com/wp-cli/wp-cli). It allows you to run the wp command under another user in case you are root and that is the only (convenient) user on your host.

## Usage
Usage:
```shell
wpas <username> <...parameters>
```
Using `wpas` is easy. The command is `wpas` and it needs at least 2 arguments. The first is the user and the rest is what gets passed to `wp`. So everything after the `wpas <username>` part is the same as it would be with the `wp` command.

This script only works if you are root. If not, use `wp` directly.

## Installation
Grab the script.
```shell
curl -O https://github.com/realrellek/wpas/raw/main/wpas.sh
```

Make it executeable.
```shell
chmod +x ./wpas.sh
```

Move it to a convenient location (i.e. to where `wp` is too)
```shell
mv ./wpas.sh /usr/local/bin/wpas
```

Here's the copy-paste friendly version:
```shell
curl -O https://github.com/realrellek/wpas/raw/main/wpas.sh
chmod +x ./wpas.sh
mv ./wpas.sh /usr/local/bin/wpas
```

## Why is this?
So maybe you administrate a server and your only "real" user is root. There may or may not be other users, e.g. for `php-fpm` or at least `www-data`. But those may not have a login shell in which case things can get a little interesting.

`wp` does not (really) want you to run it as root, and for good reason. It could mess up file permissions if you update a plugin or regenerate thumbnails. So don't do it.

What you would want to do instead is to run `wp` as the user the webserver would run under too. But this can be a pain to remember the commands. With `wpas`, you don't have to remember.

## System requirements
Obviously, you need `wp` to work as intended.

Otherwise you should be fine with a *nix machine running your stuff. `wpas` favors `sudo` but can fall back to `runuser` (which is Linux-only) and even `su`.