{ config, ... }:
{
  flake.modules.homeManager.ssh-client =
    { config, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # Prefer symlinking it out of store for on-the-go editing
      home.file.".ssh/config".source = create_symlink "${dotfiles}/ssh/config";
      programs.ssh = {
        enable = true;

        /*
          extraConfig = "
            # Added by OrbStack: 'orb' SSH host for Linux machines
            # This only works if it's at the top of ssh_config (before any Host blocks).
            # This won't be added again if you remove it.
            Include ~/.orbstack/ssh/config

            # ~/.ssh/config

            # -----------------------
            # Global defaults
            # -----------------------
            Host *
              ServerAliveInterval 60          # keep connections alive
              ServerAliveCountMax 3
              ForwardAgent no                 # disable agent forwarding by default
              ForwardX11 no
              IdentitiesOnly yes              # use only specified IdentityFile(s)
              AddKeysToAgent yes
              IgnoreUnknown UseKeychain # compatibility
              UseKeychain yes
              StrictHostKeyChecking accept-new
              UserKnownHostsFile ~/.ssh/known_hosts

            # -----------------------
            # prd-hel1-mc-01 through tailnet
            # -----------------------
              Host prd-hel1-mc-01
              HostName 100.125.91.49
              User deploy
              Port 22
              IdentityFile ~/.ssh/saguaro_id_ed25519
              SetEnv TERM=xterm-256color
              PreferredAuthentications publickey

            # -----------------------
            # Univsersity SSH access
            # -----------------------
            Host uio
              HostName login.uio.no
              User redacted-user
              IdentityFile ~/.ssh/uio_id_ed25519
              Compression yes
              SetEnv TERM=xterm-256color
            Host ifi
              HostName login.ifi.uio.no
              User redacted-user
              IdentityFile ~/.ssh/uio_id_ed25519
              ProxyJump uio
              Compression yes
              SetEnv TERM=xterm-256color

            # -----------------------
            # Personal laptop -> OpenWrt
            # -----------------------
            Host openwrt
              HostName private-host-5.invalid
              User root
              Port 22
              IdentityFile ~/.ssh/openwrt_id_ed25519
              PreferredAuthentications publickey

            # -----------------------
            # Personal laptop -> Proxmox Homelab pve1
            # -----------------------
            Host pve1
              HostName 10.10.0.10
              User root
              Port 22
              IdentityFile ~/.ssh/homelab_id_ed25519
              SetEnv TERM=xterm-256color
              PreferredAuthentications publickey

            # -----------------------
            # Proxmox homelab CT and VM
            # -----------------------
            Host ts-sync
              HostName 10.0.0.84
              User kaktus
              Port 22
              IdentityFile ~/.ssh/nixos-ts-sync_id_ed25519
              SetEnv TERM=xterm-256color
              PreferredAuthentications publickey
              Compression yes
              # TCPKeepAlive yes

            # From tailnet
            Host tailscale
              HostName 100.68.229.38
              User root
              Port 22
              IdentityFile ~/.ssh/tailscale_id_ed25519
              SetEnv TERM=xterm-256color
              PreferredAuthentications publickey
              Compression yes

            Host minecraft-nixos
              HostName 192.168.1.200
              User cactuz
              Port 22
              IdentityFile ~/.ssh/minecraft-nixos_id_ed25519
              PreferredAuthentications publickey
              Compression yes

            Host n8n
              HostName 192.168.1.78
              User root
              Port 22
              IdentityFile ~/.ssh/n8n_id_ed25519
              PreferredAuthentications publickey
              Compression yes

            Host gitea
              HostName 192.168.1.22
              User root
              Port 22
              IdentityFile ~/.ssh/gitea_id_ed25519
              PreferredAuthentications publickey
              Compression yes

            Host ghostfolio
              HostName 192.168.1.23
              User root
              Port 22
              IdentityFile ~/.ssh/ghostfolio_id_ed25519
              PreferredAuthentications publickey
              Compression yes

            Host ollama
              HostName 192.168.1.119
              User root
              Port 22
              IdentityFile ~/.ssh/ollama_id_ed25519
              PreferredAuthentications publickey
              Compression yes

            # -----------------------
            # Short alias that expands to multiple hosts (wildcard)
            # Matches hostnames like app-1.example.com, app-2.example.com
            # -----------------------
            #Host app-*.example.com
            #  User deploy
            #  IdentityFile ~/.ssh/id_ed25519_deploy
            #  ControlMaster auto
            #  ControlPath ~/.ssh/cm-%r@%h:%p
            #  ControlPersist 10m

            # -----------------------
            # Bastion / jump host example
            # Connect to private-host.example.local via jump.example.com
            # -----------------------
            #Host bastion
            #  HostName jump.example.com
            #  User jumpuser
            #  IdentityFile ~/.ssh/id_ed25519_bastion
            #  ForwardAgent yes

            #Host private-*
            #  HostName %h.example.local
            #  User internal
            #  IdentityFile ~/.ssh/id_ed25519_internal
            #  ProxyJump bastion
            #  ServerAliveInterval 30

            # -----------------------
            # GitHub and GitLab shortcuts
            # -----------------------
            Host github.com
              HostName github.com
              User git
              IdentityFile ~/.ssh/github_id_ed25519
              IdentityFile ~/.ssh/kaktus_id_ed25519_sk
              IdentityFile ~/.ssh/kaktus_id_ed25519_sk_backup
              IdentitiesOnly yes

            Host gitlab.com
              HostName gitlab.com
              User git
              IdentityFile ~/.ssh/gitlab_id_ed25519
              IdentitiesOnly yes

            # -----------------------
            # Windows/WSL or custom local host
            # -----------------------
            #Host local-wsl
            #  HostName 127.0.0.1
            #  Port 2222
            #  User dev
            #  IdentityFile ~/.ssh/id_ed25519_local

            # -----------------------
            # Example using ProxyCommand (older style) — fallback if ProxyJump unsupported
            # -----------------------
            #Host legacy-internal
            #  HostName legacy.internal
            #  User svc
            #  IdentityFile ~/.ssh/id_rsa_legacy
            #  ProxyCommand ssh -W %h:%p bastion

            # -----------------------
            # Useful comments:
            # - Use 'ssh -v <host>' to debug which IdentityFile is used.
            # - Run 'ssh-add ~/.ssh/id_xxx' to add keys to your agent if needed.
            # -----------------------
          ";
        */
      };
    };

  flake.modules.nixos.ssh-server =
    { lib, ... }:
    {
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
