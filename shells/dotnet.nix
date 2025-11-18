{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
let
  # Add your desired SDK versions here
  combined = with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 ];
in
pkgs.mkShell {
  ASPNETCORE_ENVIRONMENT = "Development";
  DOTNET_ROOT = "${combined}/share/dotnet/";

  # Expose some system libraries to your project
  LD_LIBRARY_PATH =
    with pkgs;
    lib.makeLibraryPath [
      # For GUI based applications
      fontconfig
      libGL
      libxkbcommon
      wayland
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr

      # For certain tools like Microsoft sbom tool
      mono

      # Needed by GitVersion
      openssl
    ];

  packages = with pkgs; [
    # Final dotnet SDK bundle
    combined
    # .NET debugger
    netcoredbg
    # Omnisharp language server
    omnisharp-roslyn
    openssl
  ];
}
