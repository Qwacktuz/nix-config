{
  flake.modules.homeManager.prismlauncher =
    { pkgs, lib, ... }:
    {
      programs.prismlauncher = {
        enable = true;

        #lib.optionals pkgs.stenv.isLinux()
        package = pkgs.prismlauncher.override {
          # Useful if specific mods require additional CLI binaries in PATH
          #additionalPrograms = [ pkgs.ffmpeg ];

          # Explicitly declare available JDKs passed to the wrapper
          jdks = with pkgs; [
            zulu25
            jdk21
            jdk17
            jdk8
          ];
        };
      };
    };
}
