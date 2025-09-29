{ customConfig, ... }:
{
  system.defaults = {
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
}
