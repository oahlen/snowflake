# Do you want to build a snowflake?

This repository is aimed at gettting you started on your Nix journey

Some useful links:

* https://nixos.org - Main Nix homepage and where you find installation instructions
* https://search.nixos.org - Search for packages in nixpkgs
* https://nix.dev - Official Nix documentation and guides
* https://nix-community.github.io/home-manager/options.xhtml - Documentation of home-manager including what options you can set
* https://nixos.org/guides/nix-pills - A deeper dive in Nix if you want to learn more

## Getting started

Download and install Nix on your Linux distribution, if Nix is not packaged use the install script on the official [website](https://nixos.org).
Follow the official instructions and you should be able to run:

```bash
 nix --version
```

## Bootstrap your environment

This repo exposes a starter Flake template to be customized for your needs.
Flakes are as of now marked as an **experimental feature** but fear not, they are already widely adopted and will not go anywhere anytime soon.

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

To install the first home-manager generation make sure to update the user variable in the file `homes/user.nix` on line **8** to your Linux username, then run the following command:

```bash
home-manager switch --flake .#user
```

### Cleanup existing files

The default home-manager configuration takes ownership of some files, namely: `~/.bashrc`, `~/.bash_profile` and `~/.config/nix/nix.conf`.
Remove or backup these files to be able to proceed with the home-manager switch operation:

```bash
rm -rf ~/.bashrc ~/.bash_profile ~/.config/nix/nix.conf
```

Congratz, your first home-manager generation has been created.
Now you can start to install packages in a declarative and reproducible way!

We can now exit the bootstrap shell with `exit` to go back to your regular shell.
If all went well `home-manager` should still be present on your path and flakes are avaiable.

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
