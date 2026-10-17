{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true; # enable caching
      enableZshIntegration = true;
      stdlib = ''
        if command -v devenv >/dev/null 2>&1; then
          eval "$(devenv direnvrc)"
        fi
      '';
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
