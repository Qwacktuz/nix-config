{ ... }:
{
  flake.modules.homeManager.prismlauncher =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (prismlauncher.override {
          # EXAMPLE: add binary required by some mod
          # additionalPrograms = [ ffmpeg ];

          # Change Java runtimes available to Prism Launcher
          jdks = [
            jdk21
            jdk17
            jdk8
            graalvmPackages.graalvm-ce
            zulu25
            zulu
          ];
        })
      ];
    };
}
