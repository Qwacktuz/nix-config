{ self, ... }:
{
  /*
    # Normal flake parts compatibilty (mapping to dendritic config)
    flake = {
      # nixosConfigurations = {
      #   saguaro = self.modules.saguaro;
      #   # or inherit (self.hosts) saguaro;
      # };

      # # 2. MacOS Machines
      # # Maps 'darwin-rebuild switch --flake .#macbook' -> self.darwin.macbook
      # darwinConfigurations = {
      #   macbook = self.darwin.macbook;
      # };

      # -- MODULES (Reusable Code) --
      nixosModules = {
        default = self.modules.nixos.core;
        desktop = self.modules.nixos.desktop;
      };

      darwinModules = {
        default = self.modules.darwin.core;
      };

      # 3. Home Manager Modules
      # Crucial if you write custom HM logic you want to reuse
      homeManagerModules = {
        default = self.modules.home.common;
        zsh-config = self.modules.home.zsh;
      };

      # -- GLOBAL RESOURCES --

      # 1. Overlays
      # As discussed previously
      overlays = {
        default = import ./overlays.nix { inherit (self) inputs; };
      };

      # 2. Templates
      # Useful if you want `nix flake init -t .#c` based on your devshell
      templates = {
        c-project = {
          path = ./templates/c;
          description = "Simple C environment";
        };
      };
    };
  */
}
