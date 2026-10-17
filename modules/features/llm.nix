{
  flake.modules.homeManager.llm =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        # lmstudio # marked as broken
        github-copilot-cli
        # claude-code
        # gemini-cli-bin
        codex
        antigravity-cli
        # opencode
      ];

      # Home Manager creates the service only when enabled.
      services.ollama.enable = lib.mkDefault false;
    };
}
