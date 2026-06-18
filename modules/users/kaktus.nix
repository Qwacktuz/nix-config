{
  inputs,
  self,
  config,
  ...
}:
let
  inherit (config) userName;

  sharedHmModules = with self.modules.homeManager; [
    self.modules.homeManager.${userName}
    dotfiles

    zsh
    zsh_alias
    direnv
    starship
    fzf
    bat
    btop

    git
    micro
    fastfetch
    nh
    languagetool
    llm
    vscodium
    zed
    jetbrains

    packages
    ssh-client
    fonts
    syncthing
    music
  ];

  darwinHmExtras = with self.modules.homeManager; [
    darwin-packages
    spicetify
    prismlauncher
    virtualization
  ];

  hmDefaults = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.darwin.${userName} = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = hmDefaults // {
      # TODO: Move this to spicetify flake
      sharedModules = [
        { stylix.targets.spicetify.enable = false; }
      ];

      users.${userName}.imports = sharedHmModules ++ darwinHmExtras;
    };
  };

  flake.modules.nixos.${userName} = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = hmDefaults // {
      users.${userName}.imports = sharedHmModules;
    };
  };
}
