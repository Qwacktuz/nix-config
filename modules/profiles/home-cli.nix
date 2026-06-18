{ config, ... }:

{
  flake.modules.homeManager.profile-cli = {
    imports = with config.flake.modules.homeManager; [
      dotfiles
      zsh
      zsh-aliases
      direnv
      starship
      fzf
      bat
      btop
      micro
      fastfetch
      nh
      ssh-client
      fonts
    ];
  };
}
