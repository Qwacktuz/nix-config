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
    let
      commonPackages = with pkgs; [
        neovim
        curl
        git
        zip
        devenv
      ];
      # debugger = if pkgs.stdenv.isDarwin then "lldb" else "gdb";
      # memcheck = if pkgs.stdenv.isLinux then "valgrind --leak-check=full" else "leaks --atExit --";
    in
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;

        programs.shfmt.enable = true;
        programs.shellcheck.enable = true;
        # programs.deno.enable = true;

        # Python linting and formatting
        programs.ruff.check = true;
        programs.ruff.format = true;

        # C formatting
        programs.clang-format.enable = true;

        #programs.shellcheck.options = [ "--severity=error" ];
        settings.formatter.shellcheck.excludes = [
          ".envrc"
          "dotfiles/sketchybar/**"
        ];
      };

      devenv.shells.default = {
        name = "nix-dev";

        packages = commonPackages;

        pre-commit.hooks.treefmt.enable = true;
        pre-commit.hooks.treefmt.package = config.treefmt.build.wrapper;

        # pre-commit.hooks = {
        #   nixfmt.enable = true;
        #   shellcheck.enable = true;
        #   shfmt.enable = true;
        # };

        enterShell = ''
          echo "❄️ Nix devshell loaded | 'napply' to rebuild | 'nfmt' to format | 'ncheck' to lint"
        '';

        scripts.napply.exec = "nh darwin switch .#saguaro";
        scripts.nfmt.exec = "${config.treefmt.build.wrapper}/bin/treefmt";
        scripts.ncheck.exec = "nix flake check";
      };

      #nix develop ~/.config/nix-config#c
      #   devenv.shells.c = {
      #     name = "c-dev";
      #
      #     # Best Practice: Use devenv's language modules to ensure standard C toolchains
      #     # (like stdenv.cc, clang-tools) are correctly hooked up without manual package definitions.
      #     languages.c.enable = true;
      #
      #     enterShell = ''
      #       echo "⚡️ C devshell loaded | 'cb' to build | 'cx' to run | 'cdb' to debug"
      #     '';
      #
      #     scripts.cb.exec = "cc -Wall -Wextra -g \"$@\" -o out";
      #     scripts.cx.exec = "cc -Wall -Wextra -g \"$@\" -o out && ./out";
      #     scripts.cdb.exec = "${debugger} ./out \"$@\"";
      #     scripts.cmem.exec = "${memcheck} ./out \"$@\"";
      #
      #     scripts."c-init".exec = ''
      #       if [ ! -f Makefile ]; then
      #         echo -e "all:\n\tcc -Wall -g main.c -o out\nclean:\n\trm -f out" > Makefile
      #         echo -e "#include <stdio.h>\n\nint main() {\n    printf(\"Hello World\\\\n\");\n    return 0;\n}" > main.c
      #         echo "Created main.c and Makefile"
      #       else
      #         echo "Makefile already exists."
      #       fi
      #     '';
      #
      #     packages =
      #       with pkgs;
      #       [
      #         cmake
      #         gnumake
      #         binutils
      #       ]
      #       ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      #         ltrace
      #         valgrind
      #         gdb
      #       ]
      #       ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ lldb ]
      #       ++ commonPackages;
      #   };
    };
}
