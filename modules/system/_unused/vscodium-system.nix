{ ... }:
{
  flake.modules.darwin.sketchybar =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
          vscode = vscodium; # vscode package to use
          vscodeExtensions = with vscode-extensions; [
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
            #ms-vscode-remote.remote-ssh
          ];
          # You can append additional extensions fetched directly from the VS Code marketplace
          # by using pkgs.vscode-utils.extensionsFromVscodeMarketplace with explicit metadata.
          #++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          #  {
          #    name = "dscodegpt";
          #    publisher = "DanielSanMedium";
          #    version = "3.4.10";
          #    hash = "sha256-zjaM9YME0wfBOwhJTacnQbQvw35QL5NvXIBAx5d/bjI=";
          #  }
          #];
        })
      ];
    };
}
