{ ... }:
{
  flake.modules.homeManager.ssh-private-keys =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      keyFiles = [
        "debian-mgmt_id_ed25519"
        "eptbox-id_ed25519"
        "fishhook_id_ed25519"
        "fishhook_id_ed25519.pub"
        "ghostfolio_id_ed25519"
        "gitea_id_ed25519"
        "github_id_ed25519"
        "gitlab_id_ed25519"
        "homelab_id_ed25519"
        "kaktus_id_ed25519"
        "kaktus_id_ed25519.pub"
        "kaktus_id_ed25519_sk"
        "kaktus_id_ed25519_sk.pub"
        "kaktus_id_ed25519_sk_backup"
        "kaktus_id_ed25519_sk_backup.pub"
        "kali-ctf_id_ed25519"
        "mc-prod_id_ed25519"
        "mc-prod_id_ed25519.pub"
        "minecraft-nixos_id_ed25519"
        "n8n_id_ed25519"
        "ollama_id_ed25519"
        "openwrt_id_ed25519"
        "saguaro_id_ed25519"
        "saguaro_id_ed25519.pub"
        "tailscale_id_ed25519"
        "terraform-prov_id_ed25519"
        "terraform-prov_id_ed25519.pub"
        "uio_id_ed25519"
        "uio_id_ed25519.pub"
      ];
      sshDir = "${config.home.homeDirectory}/.ssh";
    in
    {
      sops.secrets = lib.genAttrs keyFiles (name: {
        sopsFile = ../../secrets/ssh.yaml;
        key = "keys/${name}";
        path = "${sshDir}/${name}";
        mode = "0600";
      });

      home.activation.sshPrivateKeyDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe' pkgs.coreutils "mkdir"} -p ${lib.escapeShellArg sshDir}
        run ${lib.getExe' pkgs.coreutils "chmod"} 700 ${lib.escapeShellArg sshDir}
      '';
    };
}
