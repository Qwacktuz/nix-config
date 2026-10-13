{ ... }:
{
  flake.modules.homeManager.brave =
    { pkgs, ... }:
    {
      # remember to turn of brave from eenvironment.systemPackages
      programs.chromium = {
        enable = true;
        package = pkgs.brave-origin;

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
        commandLineArgs = [
          "--disable-features=AutofillSavePaymentMethods"
        ];
      };
    };
}
