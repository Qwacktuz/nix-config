{ inputs, config, ... }:
let
  inherit (config) userName;
  hmDefaults = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${userName}.imports = [ config.flake.modules.homeManager.${userName} ];
  };
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.darwin.${userName} = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager = hmDefaults;
  };

  flake.modules.nixos.${userName} = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = hmDefaults;
  };
}
