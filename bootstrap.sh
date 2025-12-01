#!/usr/bin/env bash

cd "$HOME" || exit

git clone https://github.com/oahlen/snowflake.git
cd "$HOME/snowflake" || exit

sed -i 's/user = "user";/user = "arch";/' "$HOME/snowflake/homes/user.nix"
sed -i 's/sanbox = false;/sandbox = true;/' "$HOME/snowflake/homes/user.nix"

rm "$HOME/.bashrc"
rm "$HOME/.bash_profile"
rm "$HOME/.config/nix/nix.conf"

nix-shell --arg sandbox false
