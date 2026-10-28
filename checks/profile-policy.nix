{ self, lib }:
let
  luna = self.darwinConfigurations.luna.config;
  saguaro = self.darwinConfigurations.saguaro.config;
  sol = self.darwinConfigurations.sol.config;
  fullHosts = [
    luna
    saguaro
  ];
  fishhook = self.nixosConfigurations.fishhook.config;
  cholla = self.nixosConfigurations.cholla.config;
  darwinHosts = map (host: host.config) (builtins.attrValues self.darwinConfigurations);
  home = host: host.home-manager.users.kaktus;
  casks = host: map (c: c.name) host.homebrew.casks;
  packages = host: map lib.getName (home host).home.packages;
  packageSet = ps: lib.sort builtins.lessThan (lib.unique (map (p: p.name) ps));
  brewNames = host: lib.sort builtins.lessThan (map (b: b.name) host.homebrew.brews);
  containsNone = forbidden: actual: lib.intersectLists forbidden actual == [ ];
  toolchains = [
    "go"
    "cargo"
    "rustc"
    "kotlin"
    "gradle"
    "python3"
    "pixi"
    "typescript"
    "bun"
    "deno"
    "pnpm"
  ];
  nativeApps = [
    "ghostty"
    "ghostty-bin"
    "brave-origin"
    "obsidian"
    "localsend"
    "vscodium"
    "zed-editor"
    "orbstack"
    "utm"
    "stats"
    "iina"
    "karabiner-elements"
    "idea"
    "idea-with-plugins"
    "pycharm"
    "pycharm-with-plugins"
    "webstorm"
    "webstorm-with-plugins"
    "spotify"
    "spicetify-catppuccin"
    "prismlauncher"
  ];
  validCask =
    name:
    if lib.hasInfix "/" name then
      name == "hashicorp/tap/hashicorp-vagrant"
      && builtins.pathExists "${self.inputs.hashicorp-tap}/Casks/hashicorp-vagrant.rb"
    else
      builtins.pathExists "${self.inputs.homebrew-cask}/Casks/${builtins.substring 0 1 name}/${name}.rb"
      || (
        lib.hasPrefix "font-" name
        && builtins.pathExists "${self.inputs.homebrew-cask}/Casks/font/font-${builtins.substring 5 1 name}/${name}.rb"
      );
  predictableBrew =
    host: !host.homebrew.onActivation.autoUpdate && !host.homebrew.onActivation.upgrade;
  runtimeSecrets =
    host:
    let
      hm = home host;
    in
    hm.sops.validateSopsFiles
    && !hm.sops.age.generateKey
    && hm.sops.age.sshKeyPaths == [ ]
    && hm.sops.age.keyFile == "${hm.xdg.configHome}/sops/age/keys.txt"
    && hm.sops.secrets.ssh_config.mode == "0600"
    && builtins.elem ''"${hm.sops.secrets.ssh_config.path}"'' hm.programs.ssh.includes
    && !(lib.hasInfix "/nix/store/" hm.sops.secrets.ssh_config.path)
    && hm.programs.git.settings.credential.helper != "store";
in
assert lib.assertMsg (lib.all
  (
    host:
    host.sops.age.keyFile == null
    && !host.sops.age.generateKey
    && host.sops.age.sshKeyPaths == [ "/etc/ssh/ssh_host_ed25519_key" ]
    && host.users.users.kaktus.openssh.authorizedKeys.keyFiles == [ ]
    && host.sops.templates.authorized_keys.mode == "0444"
    && !(lib.hasInfix "/nix/store/" host.sops.templates.authorized_keys.path)
  )
  [
    luna
    saguaro
    sol
    fishhook
    cholla
  ]
) "Authorized public keys must be rendered by system SOPS outside the Nix store";
assert lib.assertMsg (lib.all runtimeSecrets [
  luna
  saguaro
  sol
  fishhook
  cholla
]) "Private configuration must decrypt at runtime outside the Nix store on every host";
assert lib.assertMsg (lib.all (
  host:
  containsNone [ "qbittorrent" "xournal++" "stolendata-mpv" ] (casks host)
  && lib.all (name: builtins.elem name (packages host)) [
    "qbittorrent"
    "xournalpp"
    "tenacity"
    "mpv-with-scripts"
  ]
) fullHosts) "Full profiles must retain the approved Nix GUI exceptions";
assert lib.assertMsg (lib.all (
  host: containsNone [ "qbittorrent" "xournal++" "stolendata-mpv" ] (casks host)
) darwinHosts) "Do not install disabled macOS casks";
assert lib.assertMsg (lib.all (
  host: lib.all validCask (casks host)
) darwinHosts) "Every macOS cask must exist in its pinned tap";
assert lib.assertMsg (lib.unique (casks luna) == casks luna) "Luna has duplicate cask owners";
assert lib.assertMsg (
  lib.unique (casks saguaro) == casks saguaro
) "Saguaro has duplicate cask owners";
assert lib.assertMsg (lib.unique (casks sol) == casks sol) "Sol has duplicate cask owners";
assert lib.assertMsg (lib.all (name: builtins.elem name (casks saguaro)) (
  casks luna
)) "Saguaro must include the daily apps";
assert lib.assertMsg (
  predictableBrew luna && predictableBrew saguaro
) "Brew activation must not update or upgrade";
assert lib.assertMsg (
  !luna.services.tailscale.enable && !saguaro.services.tailscale.enable
) "Use one macOS Tailscale backend";
assert lib.assertMsg (
  builtins.elem "tailscale-app" (casks luna) && builtins.elem "orbstack" (casks luna)
) "Luna needs its selected VPN/container apps";
assert lib.assertMsg (
  lib.sort builtins.lessThan (casks luna) == lib.sort builtins.lessThan (casks saguaro)
) "Luna and Saguaro must include the same daily and optional casks";
assert lib.assertMsg (
  luna.homebrew.masApps == saguaro.homebrew.masApps
) "Luna and Saguaro must include the same optional App Store apps";
assert lib.assertMsg (
  brewNames luna == brewNames saguaro
  && packageSet (home luna).home.packages == packageSet (home saguaro).home.packages
  && packageSet luna.environment.systemPackages == packageSet saguaro.environment.systemPackages
) "Luna and Saguaro must have identical formula, Home Manager, and system package sets";
assert lib.assertMsg (
  lib.all (name: builtins.elem name (casks sol)) [
    "brave-origin"
    "signal"
    "proton-pass"
    "ghostty"
    "spotify"
  ]
  && lib.all (name: builtins.elem name (casks luna)) (casks sol)
  && lib.all (name: builtins.elem name (packages luna)) (packages sol)
  && lib.all (name: builtins.elem name (brewNames luna)) (brewNames sol)
) "Sol must include the essential daily apps and remain a subset of full";
assert lib.assertMsg (
  containsNone [
    "steam"
    "parsec"
    "nvidia-geforce-now"
    "prismlauncher"
    "obs"
    "focusrite-control-2"
    "wacom-tablet"
    "burp-suite"
    "wireshark-app"
    "bit-slicer"
  ] (casks sol)
  && containsNone [
    "tenacity"
    "mpv-with-scripts"
    "xournalpp"
    "typst"
    "texlive"
    "nmap"
    "trivy"
    "tfsec"
    "syft"
    "grype"
    "foremost"
    "scalpel"
    "zsteg"
  ] (packages sol ++ map lib.getName sol.environment.systemPackages)
  && containsNone [ "binwalk" ] (brewNames sol)
  && lib.all (name: builtins.elem name (casks sol)) [
    "zed"
    "vscodium"
    "intellij-idea"
    "pycharm"
    "webstorm"
    "orbstack"
    "utm"
  ]
  && lib.all (name: builtins.elem name (packages sol)) [
    "lima"
    "qemu"
    "lazydocker"
  ]
  && (home sol).programs.vscodium.enable
  && (home sol).programs.zed-editor.enable
  && !(home sol).programs.docker-cli.enable
  && !(home sol).services.mpd.enable
) "Sol must select core and dev without gaming, creative, or specialist security tools";
assert lib.assertMsg (lib.all (
  host:
  containsNone (nativeApps ++ toolchains) (
    packages host ++ map lib.getName host.environment.systemPackages
  )
) darwinHosts) "A macOS host has duplicate GUI ownership or global project toolchains";
assert lib.assertMsg (lib.all (
  host:
  lib.all (name: builtins.elem name (casks host)) [
    "spotify"
    "karabiner-elements"
  ]
  && containsNone [ "mpv" ] (map (brew: brew.name) host.homebrew.brews)
  && !(home host).programs.spicetify.enable
  && !(home host).programs.prismlauncher.enable
  && !host.services.karabiner-elements.enable
) darwinHosts) "GUI apps without reliable nix-darwin integration must use Homebrew";
assert lib.assertMsg (lib.all (
  host:
  lib.all (name: builtins.elem name (casks host)) [
    "intellij-idea"
    "pycharm"
    "webstorm"
    "orbstack"
    "utm"
    "steam"
    "obs"
    "burp-suite"
  ]
  && lib.all (name: builtins.elem name (packages host)) [
    "lima"
    "qemu"
    "lazydocker"
  ]
) fullHosts) "Full must include development, VMs, gaming, creative, and security tools";
assert lib.assertMsg (lib.all (
  host:
  host.services.aerospace.enable
  && builtins.elem host.services.aerospace.package host.environment.systemPackages
  && containsNone [ "aerospace" "nikitabobko/tap/aerospace" ] (casks host)
  && containsNone [ "aerospace" ] (packages host)
  && lib.hasPrefix "${host.services.aerospace.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" host.launchd.user.agents.aerospace.command
) darwinHosts) "AeroSpace must be installed and configured by its native nix-darwin service";
assert lib.assertMsg (containsNone (
  nativeApps
  ++ toolchains
  ++ [
    "nvtop"
    "tenacity"
  ]
) (packages fishhook)) "Desktop or project tools leaked into the server profile";
assert lib.assertMsg (
  (home luna).programs.ghostty.package == null
  && (home luna).programs.zed-editor.package == null
  && (home luna).programs.vscodium.package == null
  && (home luna).programs.brave-origin.package == null
) "Home Manager must configure Brew-owned apps without installing them";
assert lib.assertMsg (
  (home luna).programs.nh.flake == "/Users/kaktus/nix-config"
  && (home fishhook).programs.nh.flake == "/home/kaktus/nix-config"
) "nh must use the target user's home directory";
assert lib.assertMsg (
  (home luna).programs.zsh.shellAliases.nix-switch == "nh darwin switch"
  && (home fishhook).programs.zsh.shellAliases.nix-switch == "nh os switch"
) "Rebuild aliases must select the target OS";
{
  result = "passed";
  lunaCasks = casks luna;
  # Retain the report field names; Sol now supplies the core + dev baseline.
  coreCasks = casks sol;
  optionalCasks = lib.subtractLists (casks sol) (casks luna);
  coreNixPackages = packages sol;
  lunaNixPackages = packages luna;
  serverNixPackages = packages fishhook;
}
