{
  lib,
  nixpkgs,
  pkgs,
  ...
}:
let
  # Change this to your user
  user = "user";
in
{
  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Disable news notification for home-manager
  news.display = "silent";

  # Nixpkgs settings
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix = {
    # We don't use channels ...
    channel.enable = false;

    settings = {
      # Reduces space in nix-store by hard-linking identical files
      auto-optimise-store = true;

      # Enables new nix commands and flakes
      experimental-features = "nix-command flakes";

      # Use old style directories, i.e. ~/.nix-profile
      use-xdg-base-directories = false;
    };

    # Don't automatically garbage collect our shells managed by direnv
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    gc = {
      # Clean up after ourselves
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    # Environment variables
    sessionVariables = {
      # Force the same nixpkgs instance that bulilt this flake for ad hoc commands and shells
      NIX_PATH = lib.mkForce "nixpkgs=${nixpkgs}";
    };

    # Import defined packages to install
    packages = import ./packages.nix pkgs;
  };

  # Enable dconf, needed by home-manager ...
  dconf.enable = true;

  # Enable direnv, this lets you automatically enter dev shells when changing directory
  programs.direnv = {
    enable = true;

    # Enables efficient caching of nix dev shells
    nix-direnv.enable = true;
  };
}
