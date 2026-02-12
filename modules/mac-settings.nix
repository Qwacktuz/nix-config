{ ... }:
let
  # TODO:: refactor into global
  hostname = "saguaro";
in
{
  flake.modules.darwin.mac-settings =
    { self', pkgs }:
    {
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # TODO: refactor into networking.nix (NB: this is darwin specific nix code)
      networking = {
        computerName = hostname;
        hostName = hostname;
        dns = [
          "194.242.2.4"
          "9.9.9.9"
          "1.1.1.1"
          "8.8.8.8"
        ];
        applicationFirewall = {
          enable = true;
          enableStealthMode = true;
        };
        knownNetworkServices = [
          "USB 10/100/1000 LAN"
          "Thunderbolt Brigde"
          "Wi-Fi"
        ];
      };

      security.pam.services.sudo_local.touchIdAuth = true; # Enable sudo TouchID
      security.pam.services.sudo_local.reattach = true;

      system = {

        # Set Git commit hash for darwin-version.
        configurationRevision = self'.rev or self'.dirtyRev or null;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 6;

        # Set this in users/kaktus.nix
        #primaryUser = customConfig.username;

        # Let karabiner elements handle this?
        keyboard = {
          # swapLeftCtrlAndFn = true; # Swap left control and function keys
          enableKeyMapping = true; # Enable key mapping
        };

        defaults = {
          smb.NetBIOSName = hostname;

          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };

          screencapture.location = "~/Pictures/screenshots";

          dock = {
            autohide = true;
            mru-spaces = false; # disable reorganizing windows by recent
            expose-group-apps = true; # grouping in mission control
            #autohide-delay = 1000.0;
            # Speed of the animation when hiding/showing the Dock
            #autohide-time-modifier = 0.0;

            # Size of the icons in the dock (default 64)
            tilesize = 50;

            # Hot Corners (wvous-*-corner)
            # 0 = no action, 1 = disabled, 2 = Mission Control, 3 = Application Windows, 4 = Desktop, 5 = Start Screen Saver, 6 = Disable Screen Saver, 7 = Dashboard, 10 = Put Display to Sleep, 11 = Launchpad, 12 = Notification Center
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
          };

          loginwindow.GuestEnabled = false;

          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = false;
            ShowStatusBar = true;
            _FXShowPosixPathInTitle = true;
            FXPreferredViewStyle = "Clmv"; # Nlsv
            FXEnableExtensionChangeWarning = false;
          };

          LaunchServices = {
            # Disable quarantine for downloaded applications.
            LSQuarantine = false;
          };

          NSGlobalDomain = {
            NSDocumentSaveNewDocumentsToCloud = false; # we dont use icloud
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            AppleInterfaceStyleSwitchesAutomatically = false;
            KeyRepeat = 2;
            ApplePressAndHoldEnabled = false; # this setting on true drove me crazy
          };

          CustomSystemPreferences = {
            NSGlobalDomain = {
              # 0: Caps Lock key toggles Caps Lock
              # 1: Caps Lock key switches between ABC
              #TISRomanSwitchState = 0;
              AppleMeasurementUnit = "Celsius";

              # prefer this set to auto
              AppleLocale = "nb-NO";
              AppleLanguages = [
                "en-US"
                "nb-NO"
              ];
            };
          };

          CustomUserPreferences = {
            "com.apple.finder" = {
              ShowHardDrivesOnDesktop = false;
              ShowRemovableMediaOnDesktop = false;
              ShowExternalHardDrivesOnDesktop = false;
              ShowMountedServersOnDesktop = false;

              # New window use the $HOME path
              NewWindowTarget = "PfHm";
              NewWindowTargetPath = "file://$HOME/";

              # Allow text selection in Quick Look
              QLEnableTextSelection = true;

              # Keep folders on top when sorting by name
              "_FXSortFoldersFirst" = true;

              # Auto-adjust column widths to filenames in "Columns" view
              "_FXEnableColumnAutoSizing" = 1;

              # Open folder in new window by: ⌘ + double-click
              #FinderSpawnTab = false;

              #DesktopViewSettings = {
              #  IconViewSettings = {
              #    arrangeBy = "grid"; # FIXME: doesnt work
              #  };
              #};

              # Expand some File Info panes
              # "FXInfoPanesExpanded" = {
              #   "General" = true;
              #   "OpenWith" = true;
              #   "Privileges" = true;
              # };
            };

            "com.apple.SoftwareUpdate" = {
              AutomaticCheckEnabled = true;
              # Download newly available updates in background
              AutomaticDownload = 1;
              # Install System data files & security updates
              CriticalUpdateInstall = 1;
            };

            "com.apple.TimeMachine" = {
              # Prevent Time Machine from prompting to use new hard drives as backup volume
              DoNotOfferNewDisksForBackup = true;
            };

            "com.apple.DiskUtility" = {
              # Enable the debug menu
              DUDebugMenuEnabled = true;
              advanced-image-options = true;
            };

            "com.apple.ActivityMonitor" = {
              # Show the main window when launching
              OpenMainWindow = true;
              # Visualize CPU usage in the Dock icon
              IconType = 5;
              # Show all processes
              ShowCategory = 0;
              # Sort results by CPU usage
              SortColumn = "CPUUsage";
              SortDirection = 0;
            };

            "com.apple.desktopservices" = {
              # Avoid creating .DS_Store files on network volumes
              DSDontWriteNetworkStores = true;
              # Avoid creating .DS_Store files on USB volumes
              DSDontWriteUSBStores = true;
            };

            "com.apple.appstore" = {
              # Enable the WebKit Developer Tools in the Mac App Store
              WebKitDeveloperExtras = true;
              # Enable Debug Menu in the Mac App Store
              ShowDebugMenu = true;
            };

          };
        };
      };
    };
}
