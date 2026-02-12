{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;

        programs.shfmt.enable = true;
        programs.shellcheck.enable = true;
        programs.deno.enable = true;

        # Python linting and formatting
        programs.ruff.check = true;
        programs.ruff.format = true;

        #programs.shellcheck.options = [ "--severity=error" ];
        settings.formatter.shellcheck.excludes = [
          ".envrc"
          "dotfiles/sketchybar/**"
        ];
      };

      devshells.default = {
        name = "flake-dev";
        env = [
          {
            name = "NIX_CONFIG";
            value = "experimental-features = nix-command flakes";
          }
          {
            name = "NIXPKGS_ALLOW_UNFREE";
            value = "1";
          }
        ];

        commands = [
          {
            name = "napply";
            help = "rebuild darwin flake";
            command = "nh darwin switch .#saguaro";
          }
          {
            name = "nfmt";
            help = "format files";
            command = "${config.treefmt.build.wrapper}/bin/treefmt";
          }
          {
            name = "ncheck";
            help = "check nix flake";
            command = "nix flake check --all-systems";
          }
        ];

        packages = with pkgs; [
          # Write shellscripts as workaround for direnv
          # (writeShellScriptBin "napply" "nh darwin switch .#saguaro")
          # (writeShellScriptBin "nclean" "nh clean all")
          # (writeShellScriptBin "nfmt" "${config.treefmt.build.wrapper}/bin/treefmt")
          # (writeShellScriptBin "ncheck" "nix flake check --all-systems")

          curl
          vim
          git

          nh
          nil # Nix Language Server (LSP)
          sops # For editing your secrets
          age # Encryption needed for sops
          ssh-to-age # Helper for sops keys
          statix # Linter for Nix
          nix-diff
        ];

        # Environment variables and Aliases
        motd = ''
          🌵 Flake-dev shell loaded | 'napply' to rebuild | 'nfmt' to format | 'ncheck' to lint
        '';
      };
    };

}
