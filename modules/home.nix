{ config, pkgs, ... }@inputs: {
  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "24.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.clay = import ./modules/home.nix;
}
