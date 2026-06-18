{ ... }:
{
  flake.modules.homeManager.micro = {
    programs.micro = {
      enable = true;
      settings = {
        "*.nix" = {
          "tabsize" = 2;
        };
        "*.ml" = {
          "tabsize" = 2;
        };
        "*.asm" = {
          "tabsize" = 2;
        };
        "ft:asm" = {
          "commenttype" = "; %s";
        };
        "makefile" = {
          "tabstospaces" = false;
        };
        "tabstospaces" = true;
        "tabsize" = 4;
        "mkparents" = true;
        "colorcolumn" = 80;
      };
    };
  };
}
