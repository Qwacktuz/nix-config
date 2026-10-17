{ self, lib }:
let
  luna = self.darwinConfigurations.luna.config;
  saguaro = self.darwinConfigurations.saguaro.config;
  fishhook = self.nixosConfigurations.fishhook.config;
  home = host: host.home-manager.users.kaktus;
  casks = host: map (c: c.name) host.homebrew.casks;
  packages = host: map lib.getName (home host).home.packages;
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
    host:
    host.homebrew.onActivation.cleanup == "none"
    && !host.homebrew.onActivation.autoUpdate
    && !host.homebrew.onActivation.upgrade;
in
assert lib.assertMsg (lib.all validCask (casks saguaro))
  "Missing pinned casks: ${
    lib.concatStringsSep ", " (builtins.filter (name: !validCask name) (casks saguaro))
  }";
assert lib.assertMsg (lib.unique (casks luna) == casks luna) "Luna has duplicate cask owners";
assert lib.assertMsg (
  lib.unique (casks saguaro) == casks saguaro
) "Saguaro has duplicate cask owners";
assert lib.assertMsg (lib.all (name: builtins.elem name (casks saguaro)) (
  casks luna
)) "Saguaro must include the daily apps";
assert lib.assertMsg (
  predictableBrew luna && predictableBrew saguaro
) "Brew activation must not update, upgrade, or prune";
assert lib.assertMsg (
  !luna.services.tailscale.enable && !saguaro.services.tailscale.enable
) "Use one macOS Tailscale backend";
assert lib.assertMsg (
  builtins.elem "tailscale-app" (casks luna) && builtins.elem "orbstack" (casks luna)
) "Luna needs its selected VPN/container apps";
assert lib.assertMsg (containsNone [ "utm" "steam" "prismlauncher" "android-studio" ] (
  casks luna
)) "Optional apps leaked into Luna";
assert lib.assertMsg (
  luna.homebrew.masApps == { }
) "Luna bootstrap must not require an App Store login";
assert lib.assertMsg (containsNone (
  nativeApps
  ++ toolchains
  ++ [
    "qemu"
    "lima"
    "spotify"
    "tenacity"
  ]
) (packages luna)) "Luna has duplicate GUI ownership or optional/global toolchains";
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
  optionalCasks = lib.subtractLists (casks luna) (casks saguaro);
  lunaNixPackages = packages luna;
  serverNixPackages = packages fishhook;
}
