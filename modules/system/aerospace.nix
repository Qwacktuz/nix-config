{ ... }:
{
  services.aerospace = {
    enable = true;

    # Remember to rebind cmd-ctrl-alt in nix-darwin
    settings = {
      after-startup-command = [ ];
      # Managed by darwin and not itself
      #start-at-login = true;

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      automatically-unhide-macos-hidden-apps = true;

      key-mapping = {
        preset = "qwerty";
      };

      gaps = {
        inner.horizontal = 5;
        inner.vertical = 4;
        outer.left = 4;
        outer.bottom = 3;
        outer.top = 3;
        outer.right = 4;
      };

      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}

      # swap cmd-ctrl-alt and control in systemsettings
      # use skhd since fn is a special needs hotkey that doesn't send a keycode to non apple devices
      # se docs for possible values
      #key-mapping.key-notation-to-key-code = {
      #  cmd-ctrl-alt = "";
      #};

      mode.main.binding = {
        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        cmd-ctrl-alt-slash = "layout tiles horizontal vertical";
        cmd-ctrl-alt-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        cmd-ctrl-alt-h = "focus left";
        cmd-ctrl-alt-j = "focus down";
        cmd-ctrl-alt-k = "focus up";
        cmd-ctrl-alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        cmd-ctrl-alt-shift-h = "move left";
        cmd-ctrl-alt-shift-j = "move down";
        cmd-ctrl-alt-shift-k = "move up";
        cmd-ctrl-alt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        cmd-ctrl-alt-minus = "resize smart -50";
        cmd-ctrl-alt-equal = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        cmd-ctrl-alt-1 = "workspace 1";
        cmd-ctrl-alt-2 = "workspace 2";
        cmd-ctrl-alt-3 = "workspace 3";
        cmd-ctrl-alt-4 = "workspace 4";
        cmd-ctrl-alt-5 = "workspace 5";
        cmd-ctrl-alt-6 = "workspace 6";
        cmd-ctrl-alt-7 = "workspace 7";
        cmd-ctrl-alt-8 = "workspace 8";
        cmd-ctrl-alt-9 = "workspace 9";
        cmd-ctrl-alt-a = "workspace A";
        cmd-ctrl-alt-b = "workspace B";
        cmd-ctrl-alt-c = "workspace C";
        cmd-ctrl-alt-d = "workspace D";
        cmd-ctrl-alt-e = "workspace E";
        cmd-ctrl-alt-f = "workspace F";
        cmd-ctrl-alt-g = "workspace G";
        cmd-ctrl-alt-i = "workspace I";
        cmd-ctrl-alt-m = "workspace M";
        cmd-ctrl-alt-n = "workspace N";
        cmd-ctrl-alt-o = "workspace O";
        cmd-ctrl-alt-p = "workspace P";
        cmd-ctrl-alt-q = "workspace Q";
        cmd-ctrl-alt-r = "workspace R";
        cmd-ctrl-alt-s = "workspace S";
        cmd-ctrl-alt-t = "workspace T";
        cmd-ctrl-alt-u = "workspace U";
        cmd-ctrl-alt-v = "workspace V";
        cmd-ctrl-alt-w = "workspace W";
        cmd-ctrl-alt-x = "workspace X";
        cmd-ctrl-alt-y = "workspace Y";
        cmd-ctrl-alt-z = "workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        cmd-ctrl-alt-shift-1 = "move-node-to-workspace 1";
        cmd-ctrl-alt-shift-2 = "move-node-to-workspace 2";
        cmd-ctrl-alt-shift-3 = "move-node-to-workspace 3";
        cmd-ctrl-alt-shift-4 = "move-node-to-workspace 4";
        cmd-ctrl-alt-shift-5 = "move-node-to-workspace 5";
        cmd-ctrl-alt-shift-6 = "move-node-to-workspace 6";
        cmd-ctrl-alt-shift-7 = "move-node-to-workspace 7";
        cmd-ctrl-alt-shift-8 = "move-node-to-workspace 8";
        cmd-ctrl-alt-shift-9 = "move-node-to-workspace 9";
        cmd-ctrl-alt-shift-a = "move-node-to-workspace A";
        cmd-ctrl-alt-shift-b = "move-node-to-workspace B";
        cmd-ctrl-alt-shift-c = "move-node-to-workspace C";
        cmd-ctrl-alt-shift-d = "move-node-to-workspace D";
        cmd-ctrl-alt-shift-e = "move-node-to-workspace E";
        cmd-ctrl-alt-shift-f = "move-node-to-workspace F";
        cmd-ctrl-alt-shift-g = "move-node-to-workspace G";
        cmd-ctrl-alt-shift-i = "move-node-to-workspace I";
        cmd-ctrl-alt-shift-m = "move-node-to-workspace M";
        cmd-ctrl-alt-shift-n = "move-node-to-workspace N";
        cmd-ctrl-alt-shift-o = "move-node-to-workspace O";
        cmd-ctrl-alt-shift-p = "move-node-to-workspace P";
        cmd-ctrl-alt-shift-q = "move-node-to-workspace Q";
        cmd-ctrl-alt-shift-r = "move-node-to-workspace R";
        cmd-ctrl-alt-shift-s = "move-node-to-workspace S";
        cmd-ctrl-alt-shift-t = "move-node-to-workspace T";
        cmd-ctrl-alt-shift-u = "move-node-to-workspace U";
        cmd-ctrl-alt-shift-v = "move-node-to-workspace V";
        cmd-ctrl-alt-shift-w = "move-node-to-workspace W";
        cmd-ctrl-alt-shift-x = "move-node-to-workspace X";
        cmd-ctrl-alt-shift-y = "move-node-to-workspace Y";
        cmd-ctrl-alt-shift-z = "move-node-to-workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        cmd-ctrl-alt-tab = "workspace-back-and-forth";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        cmd-ctrl-alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        cmd-ctrl-alt-shift-semicolon = "mode service";
      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        # s = [ "layout sticky tiling" "mode main" ];

        cmd-ctrl-alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        cmd-ctrl-alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        cmd-ctrl-alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        cmd-ctrl-alt-shift-l = [
          "join-with right"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [
          "volume set 0"
          "mode main"
        ];
      };
    };

  };
}
