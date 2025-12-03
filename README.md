# Do you want to build a snowflake?

This repository is aimed at getting you started on your Nix journey

Some useful links:

* https://nixos.org - Main Nix homepage and where you find installation instructions
* https://search.nixos.org - Search for packages in nixpkgs
* https://nix.dev - Official Nix documentation and guides
* https://zero-to-nix.com - Comprehensive Nix documentation including Flakes
* https://nix-community.github.io/home-manager/options.xhtml - Documentation of home-manager including what options you can set
* https://nixos.org/guides/nix-pills - A deeper dive in Nix if you want to learn more

## Getting started

Download and install Nix on your Linux distribution, if Nix is not packaged use the install script on the official [website](https://nixos.org).
Follow the official instructions and you should be able to run:

```bash
nix --version
```

### Make sure you are a trusted user

To be able to control nix settings through your user/home-manager make sure your are added as a trusted user in the global nix config.

Add the line `trusted-users = root YOURUSER` to the file `/etc/nix/nix.conf`.
To make the change take effect run `sudo systemctl restart nix-daemon` to make the daemon use the new settings.

NOTE that this only applies for **multi user installations** (the recommended way of installing nix)

## Bootstrap your environment

This repo exposes a starter Flake template to be customized for your needs.
Flakes are as of now marked as an **experimental feature** but fear not, they are already widely adopted and will not go anywhere anytime soong

To actually use flakes you have to tell nix to allow flake usage.
Simplest way to do this is to enter the bootstrap dev shell present in this repo.
This allows you to enter an environment where everything is setup to work the way we have defined. (more on that later 😉 ...)

Enter the bootstrap environment as so:

```bash
nix-shell # nix-shell --arg sandbox false for demo container
```

In this shell we are allowing flakes and have some new programs available, check if you have home-manager on your path:

```bash
home-manager --version
```

To install the first home-manager generation make sure to update the user variable in the file `flake.nix` on line **36** to your Linux username, then run the following command:

```bash
home-manager switch --flake .#user
```

### Cleanup existing files

The default home-manager configuration takes ownership of some files, namely: `~/.bashrc`, `~/.bash_profile`, `~/.profile` and `~/.config/nix/nix.conf`.
Remove or backup these files to be able to proceed with the home-manager switch operation:

```bash
rm -rf ~/.bashrc ~/.bash_profile ~/.config/nix/nix.conf
```

NOTE: If you don't want to manage your bashrc though home-manager disable the integration with `programs.bash.enable = false;`
Direnv integration will not work out of the box in this case.

Congratz, your first home-manager generation has been created.
Now you can start to install packages in a declarative and reproducible way!

We can now exit the bootstrap shell with `exit` to go back to your regular shell.
If all went well `home-manager` should still be present on your path and flakes are available.

To install more packages add them to the file `homes/packages.nix` and then run the `switch` command again.

## Updating packages

When installing new packages we are always fetching them from the locked nixpkgs revision specified in the file `flake.lock`.

To inspect what sources we have run: `nix flake metadata` to display all configured sources and their fingerprints + dates.

To update the source to the latest available version run the command:

```bash
nix flake update
```

This will update the source making it possible for us to install packages. To actually get the new packages run the switch command again:

```bash
home-manager switch --flake .#user
```

Think of the first command as `sudo apt-get update` and the second command as `sudo apt-get upgrade`.

## Direnv

The base home-manager config sets up direnv + nix-direnv for smarter and more ergonomic nix shell integration.
In essence you can automatically enter a dev shell for a given directory by moving into it.

To do this create a `.envrc` file in the directory in question with the following content:

```
use nix <nix_shell_file>
```

Afterwards run the `direnv allow` command to mark this directory as trusted.

For flake based dev shells use:

```
use flake .
```

in the same directory as the `flake.nix`.

## Shell templates

In the directory `shells` are some templates for common languages/toolchains.
They are just examples of shells I usually use.
Edit or take inspiration from them to suit your needs.

Do note that they are written for the old `nix-shell` style invocation.
To use them in a Flake copy the `pkgs.mkShell` block into a `flake.nix` file similar to the one in this repo.

Then invoke the shell with `nix develop .#<shell_name>`
