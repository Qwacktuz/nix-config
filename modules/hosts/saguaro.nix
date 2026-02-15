{ self, ... }:
{
  flake.modules.darwin.saguaro = {
    imports = with self.modules; [
      darwin.core

      darwin.aerospace
      darwin.homebrew
      darwin.stylix
      # darwin.karabiner
      # darwin.sketchybar
      # darwin.sops
    ];
  };
}
