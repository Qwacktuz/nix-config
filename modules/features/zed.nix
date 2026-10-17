{
  flake.modules.darwin.zed.homebrew.casks = [ "zed" ];

  flake.modules.homeManager.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.zed-editor;
    };
  };
}
