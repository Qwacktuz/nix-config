{ customConfig, ... }:
let
  # TODO: generalize for linux & darwin
  musicDirectory = "/Users/${customConfig.username}/Music";
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
}
