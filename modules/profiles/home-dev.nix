{ config, ... }:

{
  flake.modules.homeManager.profile-dev = {
    imports = with config.flake.modules.homeManager; [
      dev-tools
      editor-runtime
      yubikey
      llm
      vscodium
      zed
      jetbrains
      virtualization
    ];
  };
}
