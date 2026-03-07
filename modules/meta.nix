{ lib, config, ... }:
{
  options = {
    userName = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "kaktus";
      description = "User name for the configuration";
    };
    networkDomain = lib.mkOption {
      type = lib.types.singleLineStr;
      readOnly = true;
      default = "cactuz.dev";
      description = "Network domain name";
    };
    # dotfiles = lib.mkOption {
    #   type = lib.types.path;
    #   # This calculates the default based on the home config
    #   default = "${config.home.homeDirectory}/nix-config/dotfiles";
    #   description = "Location of the dotfiles repo";
    # };
    # create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    # create_symlink = lib.mkOption {
    #   type = lib.types.raw; # function
    #   readOnly = true;
    #   default = path: config.lib.file.mkOutOfStoreSymlink path;
    #   description = "Helper function to create out-of-store symlinks";
    # };
  };
}
