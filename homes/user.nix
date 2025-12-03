{
  nixpkgs,
  pkgs,
  ...
}:
let
  # Change this to your user
  user = "user";
in
{
  # This is the state when Home-Manager was first installed, never change this after installed your first generation
  home.stateVersion = "25.05";

  # Enable Home-Manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # Disable news notification for home-manager
  news.display = "silent";

  # Nixpkgs settings
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix = {
    package = pkgs.nix;

    settings = {
      # Reduces space in nix-store by hard-linking identical files
      auto-optimise-store = true;

      # Sandbox is enabled by default and can be removed
      sandbox = true;

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

    # Force the same nixpkgs instance that bulilt this flake for ad hoc commands and shells
    keepOldNixPath = false;
    nixPath = [ "nixpkgs=${nixpkgs}" ];

    gc = {
      # Clean up after ourselves
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    # Import defined packages to install
    packages = import ./packages.nix pkgs;
  };

  # Enable dconf, needed by home-manager ...
  dconf.enable = true;

  # Let Home-Manager manage your user bash profile to allow automatic integration with direnv
  programs.bash.enable = true;

  # Enable direnv, this lets you automatically enter dev shells when changing directory
  programs.direnv = {
    enable = true;

    # Enables efficient caching of nix dev shells
    nix-direnv.enable = true;
  };
}
