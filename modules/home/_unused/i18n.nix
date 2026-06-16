{ ... }:
{
  flake.modules.homeManager.i18n = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };
  };
}
