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
      self.modules.saguaro
      inputs.self.lib.mkDarwin "aarch64-darwin" "saguaro";
    ];

  };
}
