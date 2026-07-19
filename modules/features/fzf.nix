{ ... }:
{
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      fileWidget.options = [
        "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
      ];
      changeDirWidget.command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      changeDirWidget.options = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };
  };
}
