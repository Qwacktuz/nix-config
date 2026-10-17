{
  flake.modules.homeManager.music =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      musicDir = "${config.home.homeDirectory}/Music";
      homeDir = config.home.homeDirectory;
      fifoPath = "${config.services.mpd.dataDir}/mpd.fifo";
    in
    {
      services.mpd = {
        enable = true;
        musicDirectory = musicDir;
        playlistDirectory = "${homeDir}/.mpd/playlists";
        dataDir = "${homeDir}/.mpd";
        dbFile = "${homeDir}/.mpd/mpd.db";
        enableSessionVariables = true;

        extraConfig = ''
          auto_update "${if pkgs.stdenv.hostPlatform.isLinux then "yes" else "no"}"
          auto_update_depth "2"
          follow_outside_symlinks "yes"
          follow_inside_symlinks "yes"

          # Visualizer
          audio_output {
           type "fifo"
           name "my_fifo"
           path "${fifoPath}"
           format "44100:16:2"
          }
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          audio_output {
           type "osx"
           name "CoreAudio"
           mixer_type "software"
          }
        ''
        + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          audio_output {
           type "pulse"
           name "PulseAudio"
           mixer_type "software"
          }
        '';
      };

      home.activation.mpdDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe' pkgs.coreutils "mkdir"} -p ${
          lib.escapeShellArgs (
            [
              musicDir
              config.services.mpd.dataDir
              config.services.mpd.playlistDirectory
            ]
            ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin "${homeDir}/Library/Logs/mpd"
          )
        }
      '';

      programs.ncmpcpp = {
        enable = true;
        mpdMusicDir = musicDir;
        settings.visualizer_data_source = fifoPath;
      };
    };

}
