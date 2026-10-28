{ inputs, lib, ... }:
{
  flake-file.inputs.treefmt-nix.url = "github:numtide/treefmt-nix";
  flake-file.inputs.devenv.url = "github:cachix/devenv";

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

        git-hooks.hooks.treefmt.enable = true;
        git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;
        git-hooks.hooks.gitleaks = {
          enable = true;
          name = "Gitleaks staged secrets scan";
          entry = "${pkgs.gitleaks}/bin/gitleaks git --pre-commit --staged --redact --no-banner";
          pass_filenames = false;
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
