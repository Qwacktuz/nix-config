{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # enable caching
    enableZshIntegration = true;
  };
}
