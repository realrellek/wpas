# wpas

wpas is a thin wrapper around [wp-cli](https://github.com/wp-cli/wp-cli).

It allows you to run the `wp` command as the **site owner user** while staying
logged in as **root**.

It exists to solve one specific problem:

> Running wp-cli as root creates root-owned files and breaks permissions.

---

## Why does this exist?

On many servers, the only “real” login user is `root`.
Other users (php-fpm pools, `www-data`, hosting panel users, etc.)
either don’t have login shells or are inconvenient to switch to.

Running `wp` as root is discouraged — and for good reason.
Even with `--allow-root`, wp-cli may create files owned by root
(caches, generated assets, uploads, plugin updates),
which later causes subtle and annoying permission issues.

What you *actually* want is:
- log in as root (for system administration),
- but run wp-cli as the **user that owns the WordPress files**.

`wpas` does exactly that — nothing more, nothing less.

---

## What wpas is (and is not)

- wpas does **not** replace wp-cli
- wpas does **not** add features
- wpas does **not** change wp-cli semantics
- wpas does **not** try to be clever

It only changes **who runs `wp`**, not **what `wp` does**.

If you know wp-cli, you already know wpas.

---

## Usage

```shell
wpas <username> <...wp parameters>
````

The first argument is the user to run `wp` as.
Everything after that is passed to `wp` unchanged.

Example:

```shell
# wp-cli tutorial command
wp plugin update --all

# same command using wpas
wpas wum plugin update --all
```

This script only works if you are root.
If you are not root, just use `wp` directly.

---

## Why not just use --allow-root?

Because it only silences the warning — it does not fix the problem.

Running wp-cli as root still creates root-owned files.
Cleaning up permissions afterwards is error-prone and easy to forget.

`wpas` avoids this entirely by running wp-cli as the correct user in the first place.

---

## Installation

Download the script:

```shell
curl -O https://raw.githubusercontent.com/realrellek/wpas/main/wpas.sh
```

Make it executable:

```shell
chmod +x ./wpas.sh
```

Move it somewhere in your `$PATH` (for example, next to `wp`):

```shell
mv ./wpas.sh /usr/local/bin/wpas
```

Copy-paste friendly version:

```shell
curl -O https://raw.githubusercontent.com/realrellek/wpas/main/wpas.sh
chmod +x ./wpas.sh
mv ./wpas.sh /usr/local/bin/wpas
```

---

## Requirements

* wp-cli must be installed and working
* you must be root (wpas switches users internally)
* a Unix-like system with `sudo`, `runuser`, or `su`

`wpas` prefers `sudo`, but can fall back to `runuser` (Linux-only) or `su`.
