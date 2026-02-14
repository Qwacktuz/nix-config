{ config, ... }:
{
  flake.modules.homeManager.music =
    let
      # TODO: generalize for linux & darwin
      musicDirectory = "/Users/${config.userName}/Music";
    in
    {
      services.mpd = {
        enable = true;
        inherit musicDirectory;
      };

      programs.ncmpcpp = {
        enable = true;
        mpdMusicDir = musicDirectory;
      };
    };

}
