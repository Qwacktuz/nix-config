{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true; # enable caching
      enableZshIntegration = true;
      stdlib = ''
        use_devenv() {
          if ! command -v devenv >/dev/null 2>&1; then
            log_error "devenv is not installed"
            return 1
          fi
          # Load only for use_devenv projects: helper names overlap nix-direnv.
          eval "$(devenv direnvrc)"
          use_devenv "$@"
        }
      '';
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
