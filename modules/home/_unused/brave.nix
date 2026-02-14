{ ... }:
{
  flake.modules.homeManager.brave =
    { pkgs, ... }:
    {
      # remember to turn of brave from eenvironment.systemPackages
      programs.chromium = {
        enable = true;
        package = pkgs.brave;

        # homepageLocation = "https://duckduckgo.com";
        extensions = [
          # sponsorblock
          "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx"
          # dark reader
          "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
          # keepassxc
          "oboonakemofpalcgghocfoadofidjkkk;https://clients2.google.com/service/update2/crx"
          # steamdb
          "kdbmhfkmnlmbkgbabkdealhhbfhlmmon;https://clients2.google.com/service/update2/crx"
          # i still don't care about cookies
          "edibdbjcniadpccecjdfdjjppcpchdlm;https://clients2.google.com/service/update2/crx"
          # consent-o-matic
          # "mdjildafknihdffpkfmmpnpoiajfjnjd;https://clients2.google.com/service/update2/crx"

          # Manifest v2
          # xbrowsersync
          "lcbjdhceifofjlpecfpeimnnphbcjgnc;https://clients2.google.com/service/update2/crx"
          # ublock origin
          "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"
        ];

        extraOpts = {
          "ExtensionManifestV2Availability" = 2;
        };

        # https://discourse.nixos.org/t/how-to-change-browser-specific-settings/32866/9
        commandLineArgs = [
          "--disable-features=AutofillSavePaymentMethods"
        ];
      };
    };
}
