{ config, ... }:

{
  flake.modules.homeManager.profile-dev = {
    imports = with config.flake.modules.homeManager; [
      dev-tools
      editor-runtime
      security-tools
      yubikey
      personal-tools
      languagetool
      llm
      vscodium
      zed
      jetbrains
    ];
  };
}
