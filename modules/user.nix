{ config, ... }:
let
  inherit (config) userName;
in
{
  flake.modules = {
    nixos.${userName} = {
      users.users.${userName} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        home = "/home/${userName}";
      };
    };

    darwin.${userName} = {
      system.primaryUser = userName;
      users.users.${userName} = {
        home = "/Users/${userName}";
      };
    };

    homeManager.${userName} =
      { pkgs, lib, ... }:
      {
        home = {
          username = lib.mkDefault userName;
          homeDirectory = lib.mkDefault (
            if pkgs.stdenvNoCC.isDarwin then "/Users/${userName}" else "/home/${userName}"
          );
          stateVersion = lib.mkDefault "26.05";
        };
      };
  };
}
