{ pkgs, ... }:
{
  # Have to do this since we are on macos
  environment.systemPackages = with pkgs; [
    ollama
    #vllm
  ];

  # TODO: lib.mkIf config here
  #services.ollama = {
  #  package = pkgs.ollama;
  #  enable = true;
  #  openFirewall = false;
  #  host = "127.0.0.1"; # default
  #  port = "11434"; # default
  #  home = "/var/lib/ollama"; # default – modules will live in ./modules

  #  # Optional: preload models, see https://ollama.com/library
  #  loadModels = [
  #    # 128K context
  #    "llama3.2:latest" # 3b appox 2GB
  #    "deepseek-r1:latest" # 8b appox 5GB
  #    "gpt-oss:latest" # 20b appox 14GB
  #  ];
  #};
}
