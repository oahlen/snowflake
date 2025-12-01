# A nix flake consists of inputs and outputs:
#
# Inputs are usually some revision of nixpkgs + other fancy projects you might depend on
{
  description = "A basic flake to get you started on your Nix journey.";

  inputs = {
    # This is the unstable channel with the most up to date packages
    # There are also stable branches
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home-Manager lets you install nixpkgs on other distros. Also a powerful dotfiles manager
    home-manager = {
      url = "github:nix-community/home-manager";

      # This strange line tells home-manager to use the exact same nixpkgs as the one defined above
      # This is great since it guarantees that packages installed to your home environment and in specific shells are of the same version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs are usually contextual to the action you want to take, some examples:
  # * devShells: Entrypoints for nix development shells
  # * homeConfigurations: Entrypoint for building a specific home configuration including packages and dotfiles
  # * + many more ... the sky is the limit
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    {
      homeConfigurations =
        let
          # Function for creating a home-manager configuration using the pinned home-manager and nixpkgs revision
          makeHomeConfiguration =
            system: module:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};

              # Inherit the nixpkgs instance so that we can pinned it in NIX_PATH
              extraSpecialArgs = { inherit nixpkgs; };

              # The home-manager module to build
              modules = [ module ];
            };
        in
        {
          # Change to your user + hostname, we assume you are using the x86_64 architecture
          #
          # Some available architectures are:
          # * aarch64-darwin
          # * aarch64-linux
          # * x86_64-darwin
          # * x86_64-linux
          "user" = makeHomeConfiguration "x86_64-linux" ./homes/user.nix;
        };

      # This is the default dev shell for this flake, activated with `nix develop`
      devShells."x86_64-linux".default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        pkgs.mkShell {
          # Enable experimental features + flakes without having to specify the argument
          NIX_CONFIG = "experimental-features = nix-command flakes";

          # Put your desired packages here
          packages = with pkgs; [
            git
            nix
          ];
        };
    };
}
