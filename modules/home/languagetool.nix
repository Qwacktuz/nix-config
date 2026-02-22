{ ... }:
{
  flake.modules.homeManager.langaugetool =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ltex-ls-plus # lsp
        languagetool
        fasttext
      ];

    };
}
