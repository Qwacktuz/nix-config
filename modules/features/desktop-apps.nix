{
  flake.modules.darwin.desktop-apps.homebrew = {
    casks = [
      "obsidian"
      "localsend"
      "stats"
      "iina"
      "keepassxc"
      "karabiner-elements"
      "lulu"
      "font-fontawesome"
      "codex"
    ];
  };

  flake.modules.homeManager.desktop-apps = { pkgs, lib, ... }: {
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        obsidian
        localsend
        keepassxc
      ]
    );
  };
}
