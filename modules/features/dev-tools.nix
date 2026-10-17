{
  flake.modules.homeManager.dev-tools = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      nil
      nixfmt
      devenv
      sops
      age
      ssh-to-age
      nix-diff
      typst
      typship
      typstPackages.fontawesome
      glow
      just
      watchexec
      lazysql
      yq
      kubectx
    ];
  };
}
