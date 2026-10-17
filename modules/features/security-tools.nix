{
  flake.modules.homeManager.security-tools = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      shadowsocks-rust
      exiftool
      nmap
      inetutils
      zsteg
      hexedit
      scalpel
      foremost
      trivy
      tfsec
      syft
      grype
    ];
  };
}
