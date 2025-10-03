{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self, ... }:
    let
      overlay-unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          # Empty for now
        };
      flake = {
        darwinConfigurations = {
          "Clays-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = inputs;
            system = "aarch64-darwin";
            modules =
              (import ./hosts/common.nix {
                inherit inputs overlay-unstable;
              })
              ++ [ ./hosts/work-macbook/default.nix ];
          };
          "MavBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = inputs;
            system = "aarch64-darwin";
            modules =
              (import ./hosts/common.nix {
                inherit inputs overlay-unstable;
              })
              ++ [ ./hosts/personal-macbook/default.nix ];
          };
        };
      };
    };
}
