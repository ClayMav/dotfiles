{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-homebrew, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager }@inputs:
    let
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };

      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .
      darwinConfigurations = {
        "Clays-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          specialArgs = inputs;
          system = "aarch64-darwin";
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.clay = import ./modules/home.nix;
              home-manager.backupFileExtension = "backup";
            }
            ./modules/common.nix
            ./modules/darwin-common.nix
            ./hosts/work-macbook/default.nix
          ];
        };
        "MavBook-Pro" = nix-darwin.lib.darwinSystem {
          specialArgs = inputs;
          system = "aarch64-darwin";
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.clay = import ./modules/home.nix;
              home-manager.backupFileExtension = "backup";
            }
            ./modules/common.nix
            ./modules/darwin-common.nix
            ./hosts/personal-macbook/default.nix
          ];
        };
      };
    };
}
