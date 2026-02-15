{
  inputs,
  lib,
  config,
  ...
}:
{
  flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";

  flake.modules.darwin.sops = {
    imports = lib.optionals (inputs ? sops-nix) [ inputs.sops-nix.darwinModules.sops ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = false;

      age = {
        # Import host SSH keys as age keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        # Use age key already present in filesystem
        # keyFile = "${config.users.users.${config.userName}.home}/.config/sops/age/keys.txt";
        keyFile = "/var/lib/sops-nix/key.txt";

        # Generate new key if keyFile doesn't exist at the location above
        generateKey = true;
      };

      secrets = {
        "private_keys/kaktus" = {
          path = "/home/kaktus/.ssh/kaktus_id_ed25519";
        };
      };
    };
  };
}
