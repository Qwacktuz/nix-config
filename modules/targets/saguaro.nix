{
  inputs,
  self,
  system,
  ...
}:
{
  flake.darwinModules.darwin."saguaro" = inputs.nix-darwin.lib.darinSystem {
    inherit system;

    imports = with self.modules; [
      darwin.kaktus
      darwin.mac-settings
      darwin.aerospace
      darwin.homebrew
      darwin.stylix
      # darwin.karabiner
      # darwin.sketchybar
      # darwin.sops

      generic.hm-integration # will call homeManager.kaktus
    ];
  };
}
