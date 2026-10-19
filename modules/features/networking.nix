{
  flake.modules.darwin.networking =
    { config, ... }:
    {
      networking = {
        computerName = config.networking.hostName;
        dns = [
          "9.9.9.9"
          "1.1.1.1"
          "8.8.8.8"
        ];
        applicationFirewall = {
          enable = true;
          enableStealthMode = true;
        };
        knownNetworkServices = [
          "Wi-Fi"
          "Thunderbolt Bridge"
        ];
      };
    };
}
