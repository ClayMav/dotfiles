{ inputs, overlay-unstable, ... }:
let
  home-manager = import ./../modules/home-manager.nix;
in
[
  inputs.nix-homebrew.darwinModules.nix-homebrew
  (
    { ... }:
    {
      nixpkgs.overlays = [ overlay-unstable ];
    }
  )
  ./../modules/common.nix
  ./../modules/darwin-common.nix
  inputs.home-manager.darwinModules.home-manager
  home-manager
]
