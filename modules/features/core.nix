{ config, inputs, ... }:
let
  coreModule =
    args@{ pkgs, lib, ... }:
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

      sops = {
        defaultSopsFile = ../../secrets/pubkeys.yaml;
        validateSopsFiles = true;
        age = {
          keyFile = null;
          generateKey = false;
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
        secrets =
          lib.genAttrs
            [
              "fishhook_id_ed25519"
              "kaktus_id_ed25519_sk"
              "kaktus_id_ed25519_sk_backup"
              "saguaro_id_ed25519"
            ]
            (_: {
              mode = "0400";
            });
        templates.authorized_keys = {
          path =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "/etc/ssh/nix_authorized_keys.d/${config.userName}"
            else
              "/etc/ssh/authorized_keys.d/${config.userName}";
          # Darwin's AuthorizedKeysCommand runs as _sshd.
          mode = "0444";
          content = ''
            ${args.config.sops.placeholder.kaktus_id_ed25519_sk_backup}
            ${args.config.sops.placeholder.kaktus_id_ed25519_sk}
          '';
        };
      };
    };
in
{
  flake.modules.nixos.core = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      coreModule
    ];
    # Remove the old /etc-managed key file before SOPS takes over its path.
    system.activationScripts.setupSecrets.deps = [ "etc" ];
  };
  flake.modules.darwin.core = {
    imports = [
      inputs.sops-nix.darwinModules.sops
      coreModule
    ];
  };
}
