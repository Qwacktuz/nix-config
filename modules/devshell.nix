{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
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

      devShells.default = pkgs.mkShell {
        name = "flake-dev";

        packages = with pkgs; [
          # Scripts
          # Write shellscripts as workaround for direnv
          (writeShellScriptBin "napply" "nh darwin switch .#saguaro")
          (writeShellScriptBin "nclean" "nh clean all")
          (writeShellScriptBin "nfmt" "${config.treefmt.build.wrapper}/bin/treefmt")
          (writeShellScriptBin "ncheck" "nix flake check --all-systems")

          # Packages
          nh
          nil # Nix Language Server (LSP)
          sops # For editing your secrets
          age # Encryption needed for sops
          ssh-to-age # Helper for sops keys
          statix # Linter for Nix
          nix-diff
        ];

        # Environment variables and Aliases
        shellHook = ''
          # alias nix-apply="darwin-rebuild switch --flake .#saguaro"
          echo "🌵 Flake-dev shell loaded | 'napply' to rebuild | 'nfmt' to format | 'nclean' to remove old"
        '';
      };
    };

}
