{
  flake.modules.homeManager.music =
    { config, ... }:
    let
      musicDir = "${config.home.homeDirectory}/Music";
      homeDir = config.home.homeDirectory;
    in
    {
      services.mpd = {
        enable = true;
        musicDirectory = musicDir;
        playlistDirectory = "${homeDir}/.mpd/playlists";
        dataDir = "${homeDir}/.mpd";
        dbFile = "${homeDir}/.mpd/mpd.db";
        enableSessionVariables = true;

        # FIXME: currently not working
        extraConfig = ''
          auto_update "yes"
          auto_update_depth "2"
          follow_outside_symlinks "yes"
          follow_inside_symlinks "yes"

          audio_output {
           type "osx"
           name "CoreAudio"
           mixer_type "software"
          }

          decoder {
           plugin "mp4ff"
           enabled "no"
          }

          # Visualizer
          audio_output {
           type "fifo"
           name "my_fifo"
           path "/tmp/mpd.fifo"
           format "44100:16:2"
           auto_resample "no"
           use_mmap "yes"
          }
        '';
      };

      programs.ncmpcpp = {
        enable = true;
        mpdMusicDir = musicDir;
      };
    };

}
