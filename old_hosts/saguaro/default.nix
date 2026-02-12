{
  self,
  customConfig,
  ...
}:

let
  hostname = "saguaro";
in
{
  # docs: https://nix-darwin.github.io/nix-darwin/manual/index.html

  imports = [
    ./macos.nix
    #./mac_wallpaper.nix
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Rosetta compatibility
  # $ softwareupdate --install-rosetta --agree-to-license
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # https://macos-defaults.com/
  system.primaryUser = customConfig.username;
  system.defaults = {
    LaunchServices = {
      # Disable quarantine for downloaded applications.
      LSQuarantine = false;
    };

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

    NSGlobalDomain = {
      NSDocumentSaveNewDocumentsToCloud = false; # we dont use icloud
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false; # this setting on true drove me crazy
    };

  };

  system.keyboard = {
    # swapLeftCtrlAndFn = true; # Swap left control and function keys
    enableKeyMapping = true; # Enable key mapping
  };

  security.pam.services.sudo_local.touchIdAuth = true; # Enable sudo TouchID
  security.pam.services.sudo_local.reattach = true;

  system.defaults.smb.NetBIOSName = hostname;
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

}
