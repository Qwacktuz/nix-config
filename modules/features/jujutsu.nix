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
        jps = "jj git push";
        jft = "jj git fetch";
        jbm = "jj bookmark set main -r @-"; # move current jj bookmark (on main) to latest commit
        jpl = "jj git fetch && jj rebase -d main@origin";
      };
    };
}
