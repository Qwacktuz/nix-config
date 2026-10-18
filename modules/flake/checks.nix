{ self, ... }:
{
  perSystem = { pkgs, lib, ... }: {
    checks.profile-policy = pkgs.writeText "profile-policy.json" (
      builtins.toJSON (import ../../checks/profile-policy.nix { inherit self lib; })
    );
    checks.secrets =
      pkgs.runCommand "check-repository-secrets"
        {
          nativeBuildInputs = [
            pkgs.gitleaks
            (pkgs.python3.withPackages (ps: [ ps.pyyaml ]))
          ];
        }
        ''
          gitleaks dir --redact --no-banner ${self}
          python ${self}/checks/secrets.py ${self}/secrets
          touch "$out"
        '';
  };
}
