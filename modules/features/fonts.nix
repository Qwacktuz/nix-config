{
  flake.modules.homeManager.fonts =
    { lib, ... }:
    {
      fonts.fontconfig = {
        enable = true;
        defaultFonts = lib.mkDefault {
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };
}
