{
  flake.modules.homeManager.btop =
    { ... }:
    {
      programs.btop = {
        enable = true;

        settings = {
          update_ms = 500;
          rounded_corners = true;
        };
      };

    };
}
