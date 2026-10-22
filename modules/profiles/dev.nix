{ config, ... }:
{
  flake.modules.darwin.profile-dev = {
    imports = with config.flake.modules.darwin; [
      zed
      vscodium
      jetbrains
    ];
    home-manager.users.${config.userName}.imports = [
      config.flake.modules.homeManager.profile-dev
    ];
    homebrew.casks = [
      "orbstack"
      "utm"
      "android-studio"
      "hashicorp/tap/hashicorp-vagrant"
      "raspberry-pi-imager"
      "royal-tsx"
      "omnissa-horizon-client"
      "orion"
      "helium-browser"
      "codex"
    ];
    homebrew.brews = [
      "vite-plus"
      "secretspec"
    ];
  };

  flake.modules.homeManager.profile-dev = { pkgs, lib, ... }: {
    imports = with config.flake.modules.homeManager; [
      vscodium
      zed
      jetbrains
      gpu-monitor
    ];
    home.packages =
      (with pkgs; [
        nil
        nixfmt
        treefmt
        shfmt
        devenv
        nix-diff
        just
        watchexec
        lazysql
        yq
        kubectx
        aoc-cli
        entr
        picocom
        nodejs
        lua5_1
        luarocks
        stdenv.cc
        tree-sitter
        github-copilot-cli
        codex
        antigravity-cli
        lazydocker
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
          with pkgs;
          [
            remmina
            rpi-imager
            scrcpy
            patchelf
            secretspec
          ]
        )
      )
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs;
        [
          macpm
          xcodes
          lima
          qemu
        ]
      );
    programs.docker-cli.enable = pkgs.stdenv.hostPlatform.isLinux;
    services.ollama.enable = lib.mkDefault false;
  };
}
