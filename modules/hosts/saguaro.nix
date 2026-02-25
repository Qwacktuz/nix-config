{ self, ... }:
{
  flake.modules.darwin.saguaro = {
    imports = with self.modules; [
      darwin.core

      darwin.aerospace
      darwin.homebrew
      darwin.stylix
      # darwin.virtualization
      # darwin.karabiner
      # darwin.sketchybar
      # darwin.sops
    ];
  };
}
