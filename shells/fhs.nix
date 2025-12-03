{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
let
  base = pkgs.appimageTools.defaultFhsEnvArgs;
in
# This shell puts you in an emulated FHS environment
# This is useful when running generic Linux binaries on NixOS that normally don't work
(pkgs.buildFHSEnv (
  base
  // {
    name = "fhs";
    targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
    profile = "export NIX_SHELL=FHS";
    runScript = "fish";
    extraOutputsToInstall = [ "dev" ];
  }
)).env
