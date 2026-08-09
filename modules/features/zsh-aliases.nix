let
  zshAliases = {
    # TODO: configure missing aliases & vim keybinds
    programs.zsh = {
      # idk why i put this here
      initContent = ''
        # Use vim key bindings
        bindkey -v
        # Use fzf for history search
        bindkey "^R" fzf-history-widget
        bindkey -M vicmd "^R" fzf-history-widget
        export PATH="$HOME/.local/bin:$PATH"
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

        ls = "eza --icons=auto";
        l = "eza --icons=auto -a --group-directories-first -1"; # EZA_ICON_SPACING=2
        ll = "eza --icons=auto -ah --group-directories-first -1 --no-user --long";
        tree = "eza --icons=auto --tree --group-directories-first";

        # nix
        cdnix = "cd ~/nix-config && codium ~/nix-config";
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
  };
in
{
  flake.modules.homeManager.zsh-aliases = zshAliases;
  flake.modules.homeManager.zsh_alias = zshAliases;
}
