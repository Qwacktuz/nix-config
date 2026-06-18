{ config, ... }:
let
  coreModule =
    { pkgs, lib, ... }:
    {
      # host level configs
      nixpkgs.config.allowUnfree = lib.mkDefault true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      fonts = {
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
      };

      # lib.mkdefault?
      # Same level values will be merged, or the highest value take presidence
      users.users.${config.userName}.openssh.authorizedKeys.keyFiles = [
        ../../pubkeys/kaktus_id_ed25519_sk_backup.pub
        ../../pubkeys/kaktus_id_ed25519_sk.pub
      ];
    };
in
{
  flake.modules.nixos.core = coreModule;
  flake.modules.darwin.core = coreModule;
}
