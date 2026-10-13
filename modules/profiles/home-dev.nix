{ config, ... }:

{
  flake.modules.homeManager.profile-dev = {
    imports = with config.flake.modules.homeManager; [
      git
      jujutsu
      languagetool
      llm
      vscodium
      zed
      jetbrains
      home-packages
    ];
  };
}
