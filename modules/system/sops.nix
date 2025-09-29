{
  inputs,
  config,
  customConfig,
  ...
}:
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.users.users.${customConfig.username}.home}/.config/sops/age/keys.txt";

}
