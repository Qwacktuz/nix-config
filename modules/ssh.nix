{ lib, config, ... }:
{
  flake.modules.homeManager.ssh-client =
    { config, ... }:
    # let
    #   dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
    #   create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    # in
    let
      termEnv = {
        TERM = "xterm-256color";
      };

      rootHost = ip: key: {
        hostname = ip;
        user = "root";
        identityFile = [ key ];
        setEnv = termEnv;
      };

      userHost = user: ip: key: {
        hostname = ip;
        inherit user;
        identityFile = [ key ];
        setEnv = termEnv;
      };

      compressedHost = attrs: attrs // { compression = true; };
      lanRoot = ip: key: rootHost ip key;
      lanRootCompressed = ip: key: compressedHost (rootHost ip key);
    in
    {
      # Prefer symlinking it out of store for on-the-go editing
      # home.file.".ssh/config".source = create_symlink "${dotfiles}/ssh/config";

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        extraConfig = ''
          Include ~/.orbstack/ssh/config
        '';

        matchBlocks = {
          # Global defaults
          "*" = {
            serverAliveInterval = 60;
            serverAliveCountMax = 3;
            forwardAgent = false;
            forwardX11 = false;
            identitiesOnly = true;
            addKeysToAgent = "yes";
            controlMaster = "auto";
            controlPath = "~/.ssh/cm-%r@%h:%p";
            controlPersist = "10m";
            extraOptions = {
              tcpKeepAlive = "yes";
              ConnectTimeout = "10";
              StrictHostKeyChecking = "accept-new";
              IgnoreUnknown = "UseKeychain";
              UseKeychain = "yes";
              VisualHostKey = "yes";
              UserKnownHostsFile = "~/.ssh/known_hosts";
            };
          };

          # University
          uio = compressedHost (userHost "redacted-user" "login.uio.no" "~/.ssh/uio_id_ed25519");
          ifi = compressedHost ({
            hostname = "login.ifi.uio.no";
            user = "redacted-user";
            identityFile = [ "~/.ssh/uio_id_ed25519" ];
            proxyJump = "uio";
            setEnv = termEnv;
          });

          # Minecraft production (through tailscale)
          # prd-hel1-mc-01 = userHost "deploy" "100.125.91.49" "~/.ssh/saguaro_id_ed25519";

          # Local infrastructure
          openwrt = lanRoot "private-host-5.invalid" "~/.ssh/openwrt_id_ed25519";
          pve1 = lanRoot "10.10.0.10" "~/.ssh/homelab_id_ed25519";

          # Tailscale host
          tailscale = lanRootCompressed "100.68.229.38" "~/.ssh/tailscale_id_ed25519";

          # Homelab services
          ts-sync = lanRootCompressed "10.0.0.84" "~/.ssh/nixos-ts-sync_id_ed25519";
          n8n = lanRootCompressed "192.168.1.78" "~/.ssh/n8n_id_ed25519";
          gitea = lanRootCompressed "192.168.1.22" "~/.ssh/gitea_id_ed25519";
          ghostfolio = lanRootCompressed "192.168.1.23" "~/.ssh/ghostfolio_id_ed25519";
          ollama = lanRootCompressed "192.168.1.119" "~/.ssh/ollama_id_ed25519";

          minecraft-nixos = {
            hostname = "192.168.1.200";
            user = "cactuz";
            identityFile = [ "~/.ssh/minecraft-nixos_id_ed25519" ];
            compression = true;
          };

          # Git providers
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identitiesOnly = true;
            identityFile = [
              "~/.ssh/github_id_ed25519"
              "~/.ssh/kaktus_id_ed25519_sk"
              "~/.ssh/kaktus_id_ed25519_sk_backup"
            ];
          };

          "gitlab.com" = {
            hostname = "gitlab.com";
            user = "git";
            identitiesOnly = true;
            identityFile = [ "~/.ssh/gitlab_id_ed25519" ];
          };
        };
      };
    };

  flake.modules.nixos.ssh-server = {
    services.openssh = {
      ports = [ 22 ]; # security through not-obscurity
      enable = true;
      settings = {
        AllowUsers = lib.mkDefault [ config.userName ];
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
      };
    };
  };
}
