{
  flake.modules.homeManager.jujutsu =
    { pkgs, ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Qwacktuz";
            email = "104035252+Qwacktuz@users.noreply.github.com";
          };

          ui = {
            editor = "nvim";
            pager = "delta";
            default-command = "log";
            merge-editor = "vimdiff";
          };

          git.auto-local-bookmark = true;
        };

      };

      home.packages = with pkgs; [
        lazyjj
      ];

      programs.zsh.shellAliases = {
        j = "lazyjj";
        js = "jj status";
        jl = "jj log";
        jn = "jj new";
        jd = "jj describe";
        jb = "jj bookmark";
        jdf = "jj diff";
      };
    };
}
