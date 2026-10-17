{
  flake.modules.homeManager.cli-tools = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      eza
      fd
      ripgrep
      gtrash
      tldr
      ncdu
      jq
      file
      wget
      unzip
      xxd
      openssl
      killall
      htop
      man-pages
      hexdump
    ];
  };
}
