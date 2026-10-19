{ lib, config, ... }:
{
  flake.modules.darwin.darwin-profile-base.homebrew = {
    brews = [ "proton-pass-cli" ];
    casks = [ "proton-pass" ];
  };

  flake.modules.homeManager.ssh-client =
    { config, pkgs, ... }:
    let
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      protonAgent = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";
      brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
    in
    {
      home.sessionVariables = lib.optionalAttrs isDarwin {
        SSH_AUTH_SOCK = protonAgent;
      };

      launchd.agents.proton-pass-ssh-agent = lib.mkIf isDarwin {
        enable = true;
        config = {
          ProgramArguments = [
            "${brewPrefix}/bin/pass-cli"
            "ssh-agent"
            "start"
            "--vault-name"
            "Dev"
            "--socket-path"
            protonAgent
            "--refresh-interval"
            "300"
          ];
          EnvironmentVariables = {
            HOME = config.home.homeDirectory;
            PATH = "${brewPrefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          };
          RunAtLoad = true;
          KeepAlive = true;
          ThrottleInterval = 60;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/proton-pass-ssh-agent.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/proton-pass-ssh-agent.error.log";
        };
      };

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
            AddKeysToAgent = if isDarwin then "no" else "yes";
            ControlMaster = "auto";
            ControlPath = "~/.ssh/cm-%r@%h:%p";
            ControlPersist = "10m";
            TCPKeepAlive = "yes";
            ConnectTimeout = "10";
            StrictHostKeyChecking = "accept-new";
            IgnoreUnknown = "UseKeychain";
            UseKeychain = if isDarwin then "no" else "yes";
            VisualHostKey = "yes";
            UserKnownHostsFile = "~/.ssh/known_hosts";
          } // lib.optionalAttrs isDarwin {
            IdentityAgent = protonAgent;
          };

          # Git providers
          "github.com" = {
            HostName = "github.com";
            User = "git";
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/github_id_ed25519${lib.optionalString isDarwin ".pub"}"
              "~/.ssh/kaktus_id_ed25519_sk"
              "~/.ssh/kaktus_id_ed25519_sk_backup"
            ];
          };

          "gitlab.com" = {
            HostName = "gitlab.com";
            User = "git";
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/gitlab_id_ed25519${lib.optionalString isDarwin ".pub"}"
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
