{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true; # enable caching
      enableZshIntegration = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
