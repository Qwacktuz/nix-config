{ self, ... }:
{
  perSystem = { pkgs, lib, ... }: {
    checks.profile-policy = pkgs.writeText "profile-policy.json" (
      builtins.toJSON (import ../../checks/profile-policy.nix { inherit self lib; })
    );
  };
}
