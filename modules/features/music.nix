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
        # libc++ 22 exposes Boost iterator proxies to the templated comparator.
        # Use typed wrappers until nixpkgs includes the upstream workaround:
        # https://github.com/ncmpcpp/ncmpcpp/issues/663
        package =
          if pkgs.stdenv.hostPlatform.isDarwin then
            pkgs.ncmpcpp.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ [
                (pkgs.writeText "ncmpcpp-libcxx22.patch" ''
                  --- a/src/screens/sel_items_adder.cpp
                  +++ b/src/screens/sel_items_adder.cpp
                  @@ -257 +257,2 @@
                  -			LocaleBasedSorting(std::locale(), Config.ignore_leading_the));
                  +			[cmp = LocaleBasedSorting(std::locale(), Config.ignore_leading_the)]
                  +			(const Entry &a, const Entry &b) { return cmp(a, b); });
                  --- a/src/screens/tag_editor.cpp
                  +++ b/src/screens/tag_editor.cpp
                  @@ -292 +292,3 @@
                  -			LocaleBasedSorting(std::locale(), Config.ignore_leading_the));
                  +			[cmp = LocaleBasedSorting(std::locale(), Config.ignore_leading_the)]
                  +			(const std::pair<std::string, std::string> &a,
                  +			 const std::pair<std::string, std::string> &b) { return cmp(a, b); });
                '')
              ];
            })
          else
            pkgs.ncmpcpp;
        mpdMusicDir = musicDir;
        settings.visualizer_data_source = fifoPath;
      };
    };

}
