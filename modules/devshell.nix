{ ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "saguaro-dev";

        packages = with pkgs; [
          nil # Nix Language Server (LSP)
          #nixd # nix lsp
          nixfmt
          #nixpkgs-fmt # Formatter
          # TODO: treefmt with nix
          #treefmt-nix
          #nixfmt-tree
          sops # For editing your secrets
          age # Encryption needed for sops
          ssh-to-age # Helper for sops keys
          statix # Linter for Nix
          nix-diff
          shfmt
        ];

        # Environment variables and Aliases
        shellHook = ''
          # alias nix-apply="darwin-rebuild switch --flake .#saguaro"
          alias nix-apply="nh darwin switch .#saguaro"

          alias clean="nh clean all"

          alias fmt="nixfmt ."

          echo "🌵 Saguaro System Shell active. Run 'apply' to rebuild, 'fmt' to format or 'clean' to remove old gens"
        '';
      };
    };

}
