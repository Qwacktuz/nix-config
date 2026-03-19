{ inputs, ... }:
{
  flake-file.inputs.treefmt-nix.url = "github:numtide/treefmt-nix";
  flake-file.inputs.devenv.url = "github:cachix/devenv";

  imports = [
    inputs.devenv.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;
        programs.shfmt.enable = true;
        programs.shellcheck.enable = true;
        programs.ruff.check = true;
        programs.ruff.format = true;
        programs.clang-format.enable = true;
        settings.formatter.shellcheck.excludes = [
          ".envrc"
          "dotfiles/sketchybar/**"
        ];
      };

      # The Flake-Parts integration now imports the root devenv.nix.
      # This ensures that both `devenv shell` and `nix develop` use the 
      # same environment definition.
      devenv.shells.default = {
        imports = [ ../devenv.nix ];

        # We keep the flake-specific treefmt wrapper here.
        # This will override the generic 'treefmt' script in devenv.nix.
        scripts.nfmt.exec = "${config.treefmt.build.wrapper}/bin/treefmt";
      };

      devenv.shells.c = {
        imports = [ ../devenv.nix ];
        name = "c-dev";
        languages.c.enable = true;

        enterShell = ''
          echo "⚡️ C devshell loaded | 'cb' to build | 'cx' to run | 'cdb' to debug"
        '';

        # Add the C-specific packages and tools back here.
        packages = with pkgs; [
          cmake
          gnumake
          binutils
        ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          ltrace
          valgrind
          gdb
        ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ lldb ];

        scripts.cb.exec = "cc -Wall -Wextra -g $1 -o out";
        scripts.cx.exec = "cc -Wall -Wextra -g $1 -o out && ./out";
        scripts.cdb.exec = "${if pkgs.stdenv.isDarwin then "lldb" else "gdb"} ./out";
      };
    };
}
