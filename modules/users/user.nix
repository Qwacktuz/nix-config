{ config, ... }:
let
  inherit (config) userName;
  nixosUser = {
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = "/home/${userName}";
    };
  };

  darwinUser = {
    system.primaryUser = userName;
    users.users.${userName} = {
      home = "/Users/${userName}";
    };
  };

  homeManagerUser =
    { pkgs, lib, ... }:
    {
      home = {
        username = lib.mkDefault userName;
        homeDirectory = lib.mkDefault (
          if pkgs.stdenvNoCC.hostPlatform.isDarwin then "/Users/${userName}" else "/home/${userName}"
        );
        stateVersion = lib.mkDefault "26.05";
      };
    };
in
{
  flake.modules = {
    nixos.user-kaktus = nixosUser;
    nixos.${userName} = nixosUser;

    darwin.user-kaktus = darwinUser;
    darwin.${userName} = darwinUser;

    homeManager.user-kaktus = homeManagerUser;
    homeManager.${userName} = homeManagerUser;
  };
}
