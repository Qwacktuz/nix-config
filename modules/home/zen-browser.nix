{
  inputs,
  pkgs,
  config,
  customConfig,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  #inputs.zen-browser.packages."${system}".default.override {
  #  policies = {
  #      DisableTelemetry = true;
  #  };
  #}

  # TODO: browser bookmark setup
  programs.zen-browser = {
    enable = true;
    #nativeMessageHosts = [ pkgs.firefoxpwa ];
    languagePacks = [
      "en-US"
      "nb-NO"
    ];

    # FIXME: https://github.com/0xc000022070/zen-browser-flake/issues/104 (this is why you have two browsers installed)
    policies =
      let
        # extentions
        mkExtensionSettings = builtins.mapAttrs (
          _: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
            updates_disabled = true;
          }
        );
        #moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );
      in
      {
        #ExtensionSettings."*".installation_mode = "blocked"; # Block all extensions by default
        ExtensionSettings = mkExtensionSettings {
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "gdpr@cavi.au.dk" = "consent-o-matic";
          "skipredirect@sblask" = "skip-redirect";
          "{019b606a-6f61-4d01-af2a-cea528f606da}" = "xbrowsersync";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "keepassxc-browser@keepassxc.org" = "keepassxc-browser";
          "firefox-extension@steamdb.info" = "steam-database";
          #"{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        };

        #Preferences = mkLockedAttrs {
        #  "browser.tabs.warnOnClose" = false;
        #};
        SanitizeOnShutdown = {
          Cookies = true;
        };
        # TODO: fix declarative cookies to preserve on shutdown
        Cookies = {
          Allow = [
            "https://duckduckgo.com"
          ];
        };

        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };

    profiles.${customConfig.username} = {
      isDefault = true;

      search = {
        default = "ddg"; # duckduckgo
        force = true;
      };

      containersForce = true;
      containers = {
        Personal = {
          color = "green";
          icon = "fingerprint";
          id = 1;
        };
        School = {
          color = "purple";
          icon = "briefcase";
          id = 2;
        };
        Finance = {
          color = "yellow";
          icon = "dollar";
        };
      };

      spacesForce = true; # delete non-declarative spaces
      spaces =
        let
          containers = config.programs.zen-browser.profiles.${customConfig.username}.containers;
        in
        {
          # Start by generating a random UUID v4
          "UiO" = {
            id = "9268d2ef-73d9-4d6d-9e64-e829fcc99419";
            icon = "📚";
            container = containers."School".id;
            position = 1000;
          };
          "Banking" = {
            id = "a4cbeec6-1513-4424-9602-9c4190266d44";
            icon = "💸";
            container = containers."Finance".id;
            position = 2000;
          };
        };

    };
  };

  stylix.targets.zen-browser = {
    enable = true;
    profileNames = [ customConfig.username ];
  };

}
