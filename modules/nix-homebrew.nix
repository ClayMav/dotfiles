{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "clay";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
