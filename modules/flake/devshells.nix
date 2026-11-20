{ inputs, lib, ... }:
{
  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # Keep devenv's own nixpkgs so its binary stays cached.
  flake-file.inputs.devenv = {
    url = "github:cachix/devenv";
    inputs.flake-parts.follows = "flake-parts";
  };

  imports = [
    inputs.devenv.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    let
      commonPackages = with pkgs; [
        neovim
        curl
        git
        zip
        devenv
        sops
        age
        ssh-to-age
        gitleaks
      ];
    in
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;

        programs.shfmt.enable = true;
        programs.shellcheck.enable = true;

        # Python linting and formatting
        programs.ruff.check = true;
        programs.ruff.format = true;

        # C formatting
        programs.clang-format.enable = true;

        settings.formatter.shellcheck.excludes = [
          ".envrc"
          "dotfiles/sketchybar/**"
        ];
      };

      devenv.shells.default = {
        name = "nix-dev";
        devenv.root = lib.mkOverride 900 (builtins.toString ../..);

        packages = commonPackages;

        # Unused; on Linux these outputs need extra inputs (mk-shell-bin, nix2container).
        containers = lib.mkForce { };

        git-hooks.hooks.treefmt.enable = true;
        git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;
        # Built-in hook: entry is the binary, args hold the subcommand.
        git-hooks.hooks.gitleaks = {
          enable = true;
          name = "Gitleaks staged secrets scan";
          package = pkgs.gitleaks;
          args = [
            "git"
            "--pre-commit"
            "--staged"
            "--redact"
            "--no-banner"
          ];
        };

        enterShell = ''
          echo "❄️ Nix devshell loaded | 'napply' to rebuild | 'nfmt' to format | 'ncheck' to lint"
        '';

        scripts.napply.exec = "nh ${if pkgs.stdenv.hostPlatform.isDarwin then "darwin" else "os"} switch";
        scripts.nfmt.exec = "${config.treefmt.build.wrapper}/bin/treefmt";
        scripts.ncheck.exec = "nix flake check";
      };
    };
}
