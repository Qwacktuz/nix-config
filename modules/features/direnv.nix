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
          local devenv_direnvrc
          if ! devenv_direnvrc=$(devenv direnvrc); then
            log_error "could not load devenv direnvrc"
            return 1
          fi
          unset -f use_devenv
          eval "$devenv_direnvrc" || return 1
          if ! declare -F use_devenv >/dev/null; then
            log_error "devenv direnvrc did not define use_devenv"
            return 1
          fi
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
