{ self, ... }:
{
  flake.modules.darwin.darwin-profile-base =
    { config, ... }:
    {
      imports = [ self.modules.darwin.networking ];

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      security.pam.services.sudo_local.touchIdAuth = true;
      security.pam.services.sudo_local.reattach = true;

      system = {
        startup.chime = false;

        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 7;

        keyboard = {
          enableKeyMapping = true;
        };

        defaults = {
          # Needs terminal to have 'full disk access' in macOS settings
          universalaccess.closeViewScrollWheelToggle = true;

          WindowManager = {
            StageManagerHideWidgets = true;
            StandardHideWidgets = true;
          };

          smb.NetBIOSName = config.networking.hostName;

          controlcenter = {
            BatteryShowPercentage = true;
          };

          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };

          screencapture = {
            location = "~/Pictures/screenshots";
            target = "clipboard";
          };

          dock = {
            autohide = true;
            mru-spaces = false; # disable reorganizing windows by recent
            expose-group-apps = true; # grouping in mission control
            static-only = true;

            tilesize = 50;

            # Disable all Hot Corners.
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
            FXPreferredViewStyle = "Clmv";
            FXRemoveOldTrashItems = true;
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
            ApplePressAndHoldEnabled = false;
            "com.apple.trackpad.scaling" = 1.0;
            "com.apple.mouse.tapBehavior" = 1;
          };
        };
      };
    };
}
