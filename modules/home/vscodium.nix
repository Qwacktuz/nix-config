{ ... }:
{
  flake.modules.homeManager.vscodium =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default.enableUpdateCheck = false; # No notifications about updates
        profiles.default.enableExtensionUpdateCheck = false; # Declarative updates
        profiles.default = {
          #userMcp = {} # TODO: model context protocol
          userSettings = {
            "editor.formatOnSave" = true;
            #"editor.fontSize" = 12;
            "editor.fontFamily" = lib.mkDefault "JetBrainsMono Nerd Font, DejaVu Sans Mono, monospace";
            "editor.fontLigatures" = true;
            "terminal.integrated.fontFamliy" = "JetBrainsMono Nerd Font";
            "vim.enableNeovim" = true;
            # Use the neovim config file
            #"vim.neovimUseConfigFile": true;

            # Apparance
            "catppuccin.bracketMode" = "neovim"; # rainbow is default
            "workbench.colorTheme" = "Stylix"; # Catppuccin Mocha if stylix isn't controlling this
            "workbench.iconTheme" = "catppuccin-mocha";

            # Make sure global telemetry is off
            "telemetry.telemetryLevel" = "off";

          };

          extensions = with pkgs.vscode-extensions; [
            # General
            vscodevim.vim
            jnoortheen.nix-ide
            yzhang.markdown-all-in-one
            ms-azuretools.vscode-docker

            # Python
            ms-toolsai.jupyter
            ms-python.python
            ms-python.black-formatter
            ms-python.isort
            ms-python.vscode-pylance
            ms-python.pylint # flake8

            # Theme
            catppuccin.catppuccin-vsc # Doesn't matter if stylix is in use
            catppuccin.catppuccin-vsc-icons
          ];
        };
      };
    };
}
