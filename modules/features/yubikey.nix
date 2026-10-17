{
  flake.modules.darwin.yubikey.homebrew.casks = [ "yubico-authenticator" ];

  flake.modules.homeManager.yubikey = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      yubico-piv-tool
      yubikey-manager
      opensc
    ];
  };
}
