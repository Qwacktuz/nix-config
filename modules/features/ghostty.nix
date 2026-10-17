{
  flake.modules.darwin.ghostty.homebrew.casks = [ "ghostty" ];

  flake.modules.homeManager.ghostty =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf mkMerge;
      isDarwin = pkgs.stdenvNoCC.hostPlatform.isDarwin;
    in
    {
      programs.ghostty = {
        enable = true;

        package = if isDarwin then null else pkgs.ghostty;

        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;

        settings = mkMerge [
          {
            background-blur = true;
            background-opacity = 0.7;
            clipboard-paste-bracketed-safe = true;
            clipboard-paste-protection = true;
            clipboard-trim-trailing-spaces = true;
            cursor-color = "#F28FAD";
            cursor-opacity = 0.8;
            font-family = "JetBrainsMono Nerd Font";
            font-size = 14;
            maximize = false;
            mouse-hide-while-typing = true;
            shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo,path";
            theme = "Catppuccin Mocha";
            title-report = false;
            window-decoration = true;
            window-padding-x = 8;
            window-title-font-family = "JetBrainsMono Nerd Font";
          }

          (mkIf isDarwin {
            auto-update = "off";
            macos-auto-secure-input = true;
            macos-icon = "blueprint";
            macos-non-native-fullscreen = true;
            macos-option-as-alt = true;
            macos-secure-input-indication = true;
            macos-titlebar-proxy-icon = "hidden";
            macos-titlebar-style = "hidden";
            macos-window-shadow = false;
            quick-terminal-screen = "main";
            window-vsync = true;

            keybind = [
              "global:cmd+/=toggle_quick_terminal"
              "alt+a=text:å"
              "alt+'=text:æ"
              "alt+o=text:ø"
              "alt+shift+a=text:Å"
              "alt+shift+'=text:Æ"
              "alt+shift+o=text:Ø"
            ];
          })
        ];
      };
    };
}
