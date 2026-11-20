{
  inputs,
  ...
}:
{
  # Flake level config
  perSystem =
    {
      system,
      lib,
      ...
    }:
    {
      # Overrides the default 'pkgs' argument for all perSystem modules
      # for example devshells, formatter, checks
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = lib.mkDefault true;
      };
    };
}
