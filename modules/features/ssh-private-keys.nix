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
      # Software private keys stay in Proton Pass; retain public selectors and FIDO handles.
      keyFiles = [
        "debian-mgmt_id_ed25519.pub"
        "eptbox-id_ed25519.pub"
        "fishhook_id_ed25519.pub"
        "ghostfolio_id_ed25519.pub"
        "gitea_id_ed25519.pub"
        "github_id_ed25519.pub"
        "gitlab_id_ed25519.pub"
        "homelab_id_ed25519.pub"
        "kaktus_id_ed25519.pub"
        "kaktus_id_ed25519_sk"
        "kaktus_id_ed25519_sk.pub"
        "kaktus_id_ed25519_sk_backup"
        "kaktus_id_ed25519_sk_backup.pub"
        "kali-ctf_id_ed25519.pub"
        "mc-prod_id_ed25519.pub"
        "minecraft-nixos_id_ed25519.pub"
        "n8n_id_ed25519.pub"
        "ollama_id_ed25519.pub"
        "openwrt_id_ed25519.pub"
        "saguaro_id_ed25519.pub"
        "tailscale_id_ed25519.pub"
        "terraform-prov_id_ed25519.pub"
        "uio_id_ed25519.pub"
      ];
      sshDir = "${config.home.homeDirectory}/.ssh";
      retiredKeys = map (lib.removeSuffix ".pub") (
        builtins.filter (name: lib.hasSuffix ".pub" name && !(lib.hasInfix "_sk" name)) keyFiles
      );
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

      home.activation.retireSopsSshPrivateKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        for name in ${lib.escapeShellArgs retiredKeys}; do
          path=${lib.escapeShellArg sshDir}/"$name"
          target=${lib.escapeShellArg "${config.xdg.configHome}/sops-nix/secrets"}/"$name"
          if [ -L "$path" ] && [ "$(${lib.getExe' pkgs.coreutils "readlink"} "$path")" = "$target" ]; then
            run ${lib.getExe' pkgs.coreutils "rm"} -- "$path"
          fi
        done
      '';
    };
}
