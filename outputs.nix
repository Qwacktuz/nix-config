{ ... }:
{
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # Define where to find inputs.nix
        ./modules/inputs.nix

        # This gets automaticlly loaded using flake-file dendritic template
        # (inputs.import-tree ./modules)
      ];
    };
}
