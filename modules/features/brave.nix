{ ... }:
{
  flake.modules.darwin.brave.homebrew.casks = [ "brave-origin" ];

  flake.modules.homeManager.brave =
    { pkgs, lib, ... }:
    {
      programs.brave-origin = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.brave-origin;

        # homepageLocation = "https://duckduckgo.com";
        extensions = [
          # sponsorblock
          "mnjggcdmjocbbbhaepdhchncahnbgone"
          # dark reader
          "eimadpbcbfnmbkopoojfekhnkhdbieeh"
          # keepassxc
          "oboonakemofpalcgghocfoadofidjkkk"
          # steamdb
          "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"
          # i still don't care about cookies
          "edibdbjcniadpccecjdfdjjppcpchdlm"
          # consent-o-matic
          # "mdjildafknihdffpkfmmpnpoiajfjnjd;https://clients2.google.com/service/update2/crx"

          # Manifest v2
          # xbrowsersync
          # "lcbjdhceifofjlpecfpeimnnphbcjgnc;https://clients2.google.com/service/update2/crx"
          # ublock origin
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        ];

        # https://discourse.nixos.org/t/how-to-change-browser-specific-settings/32866/9
        commandLineArgs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          "--disable-features=AutofillSavePaymentMethods"
        ];
      };
    };
}
