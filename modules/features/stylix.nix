{ inputs, ... }:
{
  flake-file.inputs.stylix.url = "github:nix-community/stylix";

  flake.modules.darwin.stylix =
    { lib, ... }:
    {
      imports = lib.optionals (inputs ? stylix) [ inputs.stylix.darwinModules.stylix ];

      stylix.enable = true;
      stylix.enableReleaseChecks = false;
      stylix.base16Scheme = import ../../assets/themes/catppuccin-mocha.nix;
      # doesn't work for macos wallpaper
      stylix.image = ../../assets/wallpapers/love_lain.jpg;

      stylix.opacity.terminal = 0.7; # same as ghostty.nix

      #stylix.image = pkgs.fetchurl {
      #  url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      #  hash = "sha256-enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      #};

      #stylix.fonts = {
      #};
    };
}
