{ config, ... }:
{
  flake.modules.darwin.saguaro = {
    imports = with config.flake.modules.darwin; [
      profile-full
      config.flake.modules.darwin.${config.userName}
    ];

    networking.hostName = "saguaro";
    system.defaults.loginwindow.LoginwindowText = "Saguaro M4";
  };
}
