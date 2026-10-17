{
  flake.modules.homeManager.darwin-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      macpm
      xcodes
    ];
  };
}
