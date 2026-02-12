{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.darwinModules.stylix ];

  stylix.enable = true;
  stylix.enableReleaseChecks = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  # doesn't work for macos wallpaper
  stylix.image = ./love_lain.jpg;

  #stylix.image = pkgs.fetchurl {
  #  url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
  #  hash = "sha256-enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  #};

  #stylix.fonts = {
  #};
}
