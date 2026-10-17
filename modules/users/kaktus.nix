{
  inputs,
  config,
  ...
}:
let
  inherit (config) userName;

  cliHmModules = with config.flake.modules.homeManager; [
    config.flake.modules.homeManager.${userName}
    profile-cli
  ];

  desktopHmModules = with config.flake.modules.homeManager; [
    profile-dev
    profile-desktop
  ];

  linuxHmExtras = with config.flake.modules.homeManager; [
    profile-linux
  ];

  darwinHmExtras = with config.flake.modules.homeManager; [
    profile-darwin
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
      users.${userName}.imports = cliHmModules ++ desktopHmModules ++ darwinHmExtras;
    };
  };

  flake.modules.nixos.user-kaktus-desktop = {
    imports = [
      config.flake.modules.nixos.user-kaktus
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = hmDefaults // {
      users.${userName}.imports = cliHmModules ++ desktopHmModules ++ linuxHmExtras;
    };
  };

  flake.modules.nixos.user-kaktus-server = {
    imports = [
      config.flake.modules.nixos.user-kaktus
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = hmDefaults // {
      users.${userName}.imports = cliHmModules ++ linuxHmExtras;
    };
  };

  flake.modules.nixos.${userName} = config.flake.modules.nixos.user-kaktus-desktop;
}
