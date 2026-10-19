{
  flake.modules.darwin.desktop-apps.homebrew = {
    casks = [
      "obsidian"
      "localsend"
      "stats"
      "iina"
      "keepassxc"
      # nix-darwin's module still uses the pre-v15 launch-agent layout (#1041).
      "karabiner-elements"
      "lulu"
      "font-fontawesome"
      "codex"
      "chatgpt"
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
