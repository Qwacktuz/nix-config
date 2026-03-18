{ ... }:
{
  flake.modules.homeManager.music =
    { config, ... }:
    let
      musicDir = "${config.home.homeDirectory}/Music";
    in
    {
      services.mpd = {
        enable = true;
        musicDirectory = musicDir;
      };

      programs.ncmpcpp = {
        enable = true;
        mpdMusicDir = musicDir;
      };
    };

}
