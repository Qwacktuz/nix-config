{
  perSystem = { pkgs, lib, ... }: {
    devShells = {
      go = pkgs.mkShell {
        packages = with pkgs; [
          go
          gopls
          golangci-lint
          golangci-lint-langserver
        ];
      };
      rust = pkgs.mkShell {
        packages = with pkgs; [
          cargo
          rustc
          rustfmt
          clippy
          rust-analyzer
        ];
      };
      jvm = pkgs.mkShell {
        packages = with pkgs; [
          temurin-bin
          kotlin
          gradle
          android-tools
        ];
      };
      python = pkgs.mkShell {
        packages = with pkgs; [
          python3
          uv
          pixi
        ];
      };
      web = pkgs.mkShell {
        packages = with pkgs; [
          nodejs
          typescript
          bun
          deno
          pnpm
        ];
      };
      infra = pkgs.mkShell {
        packages = with pkgs; [
          act
          infisical
          tenv
          ansible
          fluxcd
          awscli2
          packer
          kubectl
          kubectx
          yq
        ];
      };
      c = pkgs.mkShell {
        packages =
          with pkgs;
          [
            clang-tools
            cmake
            gnumake
            zig
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.gdb ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.lldb ];
      };
    };
  };
}
