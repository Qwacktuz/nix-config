{ config, ... }:
let
  userName = config.userName;
in
{
  flake.modules = {
    nixos.${userName} = {
      users.users.${userName} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };

    darwin.${userName} = {
      system.primaryUser = userName;
    };

    homeManager.${userName} =
      { pkgs, lib, ... }:
      {
        home = {
          username = lib.mkDefault userName;
          homeDirectory = lib.mkDefault (
            if pkgs.stdenvNoCC.isDarwin then "/Users/${userName}" else "/home/${userName}"
          );
          stateVersion = lib.mkDefault "25.11";
        };
      };
  };
}
