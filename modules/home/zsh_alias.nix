{ ... }:
{
  # TODO: configure missing aliases & vim keybinds
  programs.zsh = {
    # idk why i put this here
    initContent = ''
      # Use vim key bindings
      bindkey -v
      # Overrides vim default redo 
      bindkey "^R" history-incremental-search-backward
      export PATH="/usr/bin/:$PATH"
    '';
    shellAliases = {
      # services
      # ts = "tailscale";
      # Installed through app store
      # tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      # ts = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      ts = "tailscale";
      n = "nvim";

      # utils
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      nano = "micro";
      code = "codium";
      diff = "delta --diff-so-fancy --side-by-side";
      less = "bat";
      y = "yazi";
      py = "python";
      ipy = "ipython";
      icat = "kitten icat";
      dsize = "du -hs";
      pdf = "tdf";
      open = "xdg-open";
      space = "ncdu";
      man = "BAT_THEME='default' batman";

      ls = "eza --icons ";
      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -ah --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      # nix
      cdnix = "cd ~/nixos-config && codium ~/nixos-config";
      ns = "nom-shell --run zsh";
      nd = "nom develop --command zsh";
      nb = "nom build";
      nix-switch = "nh os switch";
      nix-update = "nh os switch --update";
      nix-clean = "nh clean all --keep 5";
      nix-search = "nh search";
      nix-test = "nh os test";

      # python
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate";
    };
  };
}
