{ self, ... }:
{
  flake.modules.darwin."saguaro" = {
    imports = with self.modules.darwin; [
      mac-settings
    ];
  };
}
