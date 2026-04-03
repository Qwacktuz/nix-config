{ ... }:
{
  flake.modules.homeManager.llm =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # lmstudio # marked as broken
        claude-code
        gemini-cli-bin
        codex
        antigravity
        opencode
      ];

      # TODO: lib.mkIf config here
      services.ollama = {
        package = pkgs.ollama;
        enable = false;
        host = "127.0.0.1"; # default
        port = 11434; # default
      };
    };
}
