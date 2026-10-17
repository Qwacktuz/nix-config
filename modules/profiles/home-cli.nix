{ config, ... }:

{
  flake.modules.homeManager.profile-cli = {
    imports = with config.flake.modules.homeManager; [
      dotfiles
      cli-tools
      git
      jujutsu
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
