{ self, config, ... }:
{
  flake.modules.darwin.core = {
    imports = with self.modules; [
      generic.core
      darwin.mac-settings
      darwin.${config.userName}
    ];
  };
}
