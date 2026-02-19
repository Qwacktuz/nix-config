{ ... }:
{
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = false;
    };
  };
}
