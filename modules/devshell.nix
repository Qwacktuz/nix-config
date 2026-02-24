{ inputs, ... }:
{
  flake-file.inputs.devshell.url = "github:numtide/devshell";
  flake-file.inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  imports = [
    inputs.devshell.flakeModule
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
      ];
      debugger = if pkgs.stdenv.isDarwin then "lldb" else "gdb";
      memcheck = if pkgs.stdenv.isLinux then "valgrind --leak-check=full" else "leaks --atExit --";
    in
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

        # C formatting
        programs.clang-format.enable = true;

        #programs.shellcheck.options = [ "--severity=error" ];
        settings.formatter.shellcheck.excludes = [
          ".envrc"
          "dotfiles/sketchybar/**"
        ];
      };

      devshells.default = {
        name = "nix-dev";

        motd = ''
          ❄️ Nix devshell loaded | 'napply' to rebuild | 'nfmt' to format | 'ncheck' to lint
        '';

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

        packages =
          with pkgs;
          [
            nh # nix helper
            nil # Nix Language Server (LSP)
            sops # For editing your secrets
            age # Encryption needed for sops
            ssh-to-age # Helper for sops keys
            statix # Linter for Nix
            nix-diff

            # Write shellscripts as workaround for direnv
            # (writeShellScriptBin "napply" "nh darwin switch .#saguaro")
            # (writeShellScriptBin "nclean" "nh clean all")
            # (writeShellScriptBin "nfmt" "${config.treefmt.build.wrapper}/bin/treefmt")
            # (writeShellScriptBin "ncheck" "nix flake check --all-systems")
          ]
          ++ commonPackages;
      };

      devshells.c = {
        name = "c-dev";

        motd = ''
          ⚡️ C devshell loaded | 'cb' to build | 'cx' to run | 'cdb' to debug
        '';

        commands = [
          {
            name = "cb";
            help = "Quick compile a file (Usage: cb main.c)";
            command = "cc -Wall -Wextra -g $1 -o out";
          }
          {
            name = "cx";
            help = "Compile and run (Usage: cx main.c)";
            command = "cc -Wall -Wextra -g $1 -o out && ./out";
          }
          {
            name = "cdb";
            help = "Debug the 'out' binary";
            command = "${debugger} ./out";
          }
          {
            name = "cmem";
            help = "Check for memory leaks (Valgrind on Linux / Leaks on Darwin)";
            command = "${memcheck} ./out";
          }
          {
            name = "c-init";
            help = "Create a basic Makefile and main.c";
            command = ''
              if [ ! -f Makefile ]; then
                echo -e "all:\n\tcc -Wall -g main.c -o out\nclean:\n\trm -f out" > Makefile
                echo -e "#include <stdio.h>\n\nint main() {\n    printf(\"Hello World\\\\n\");\n    return 0;\n}" > main.c
                echo "Created main.c and Makefile"
              else
                echo "Makefile already exists."
              fi
            '';
          }
        ];

        packages =
          with pkgs;
          [
            clang-tools
            stdenv.cc
            cmake
            gnumake
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            valgrind
            gdb
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ lldb ]
          ++ commonPackages;
      };
    };
}
