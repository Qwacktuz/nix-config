{
  flake.modules.homeManager.editor-runtime = { pkgs, lib, ... }: {
    home.packages =
      with pkgs;
      [
        nodejs
        lua5_1
        luarocks
        gcc
        ghostscript
        tectonic
        texliveSmall
        tree-sitter
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        patchelf
      ];
  };
}
