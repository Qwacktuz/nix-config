{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.sops =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      home.packages = with pkgs; [
        sops
        age
        ssh-to-age
      ];
      home.sessionVariables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;

      sops = {
        defaultSopsFile = ../../secrets/home.yaml;
        validateSopsFiles = true;
        age = {
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          generateKey = false;
          sshKeyPaths = [ ];
        };
        secrets = {
          ssh_config = {
            mode = "0600";
            key = if pkgs.stdenv.hostPlatform.isDarwin then "ssh_config_proton" else "ssh_config";
          };
          obsidian_workspaces.mode = "0600";
        };
      };
    };
}
