{ config, ... }:

{
  flake.modules.homeManager.profile-dev = {
    imports = with config.flake.modules.homeManager; [
      git
      languagetool
      llm
      vscodium
      zed
      jetbrains
      packages
    ];
  };
}
