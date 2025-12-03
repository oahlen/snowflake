#!/usr/bin/env bash

# This script is only for demo purposes and can be ignored

cd "$HOME" || exit

git clone https://github.com/oahlen/snowflake.git
cd "$HOME/snowflake" || exit

sed -i 's/user = "user";/user = "arch";/' "$HOME/snowflake/homes/user.nix"
sed -i 's/sandbox = true;/sandbox = false;/' "$HOME/snowflake/homes/user.nix"

rm "$HOME/.bashrc"
rm "$HOME/.bash_profile"
rm "$HOME/.config/nix/nix.conf"

nix-shell --arg sandbox false
