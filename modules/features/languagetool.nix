{
  flake.modules.homeManager.languagetool =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ltex-ls-plus # lsp
        languagetool
        fasttext
      ];

    };
}
