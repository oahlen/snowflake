{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      # Your desired python runtime
      python313
      # Python language server
      pyright
      # Python linter
      ruff
    ]
    # Add packages for the python 3.13 environment (similar to uv/venv)
    ++ (with pkgs.python313Packages; [
      # Python packages
      pandas
      numpy
    ]);
}
