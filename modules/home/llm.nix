{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #vllm
  # ];

  # TODO: lib.mkIf config here
  services.ollama = {
    package = pkgs.ollama;
    enable = true;
    host = "127.0.0.1"; # default
    port = 11434; # default
  };
}
