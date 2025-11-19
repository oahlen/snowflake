# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  sandbox ? true,
}:
let
  pkgs = import ./util/nixpkgs.nix { };
in
{
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes\nsandbox = ${
      if sandbox then "true" else "false"
    }";

    packages = with pkgs; [
      git
      home-manager
      nix
    ];
  };
}
