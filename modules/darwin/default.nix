{
  inputs,
  self,
  system,
  ...
}:
{
  flake.darwinConfigurations."saguaro" = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      self.darwinModules.saguaro
    ];
  };
}
