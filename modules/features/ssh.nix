{ lib, config, ... }:
{
  flake.modules.homeManager.ssh-client =
    { config, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        includes = [
          ''"${config.sops.secrets.ssh_config.path}"''
          "~/.orbstack/ssh/config"
        ];

        settings = {
          # Global defaults
          "*" = {
            ServerAliveInterval = 60;
            ServerAliveCountMax = 3;
            ForwardAgent = false;
            ForwardX11 = false;
            IdentitiesOnly = true;
            AddKeysToAgent = "yes";
            ControlMaster = "auto";
            ControlPath = "~/.ssh/cm-%r@%h:%p";
            ControlPersist = "10m";
            TCPKeepAlive = "yes";
            ConnectTimeout = "10";
            StrictHostKeyChecking = "accept-new";
            IgnoreUnknown = "UseKeychain";
            UseKeychain = "yes";
            VisualHostKey = "yes";
            UserKnownHostsFile = "~/.ssh/known_hosts";
          };

          # Git providers
          "github.com" = {
            HostName = "github.com";
            User = "git";
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/github_id_ed25519"
              "~/.ssh/kaktus_id_ed25519_sk"
              "~/.ssh/kaktus_id_ed25519_sk_backup"
            ];
          };

          "gitlab.com" = {
            HostName = "gitlab.com";
            User = "git";
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/gitlab_id_ed25519"
              "~/.ssh/kaktus_id_ed25519_sk"
              "~/.ssh/kaktus_id_ed25519_sk_backup"
            ];
          };
        };
      };
    };

  flake.modules.nixos.ssh-server = {
    services.openssh = {
      ports = [ 22 ]; # security through not-obscurity
      enable = true;
      settings = {
        AllowUsers = lib.mkDefault [
          config.userName
        ];
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = lib.mkDefault "no";
        X11Forwarding = false;
        PubkeyAuthentication = true;
        ChallengeResponseAuthentication = false;
        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
    };
  };
}
