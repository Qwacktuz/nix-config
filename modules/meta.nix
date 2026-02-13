{ lib, ... }:
{
  options = {
    userName = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "kaktus";
      description = "User name for the configuration";
    };
  };

}
