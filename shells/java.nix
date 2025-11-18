{
  pkgs ? import <nixpkgs> {
    config = { };
    overlays = [ ];
  },
}:
pkgs.mkShell {
  JAVA_HOME = "${pkgs.jdk.home}";

  LD_LIBRARY_PATH =
    with pkgs;
    lib.makeLibraryPath [
      openssl
    ];

  packages = with pkgs; [
    # Latest stable Java SDK, specify version number if another one is desired
    jdk
    # Java language server
    jdt-language-server
    maven # gradle
  ];
}
