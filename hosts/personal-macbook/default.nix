{ pkgs, commonDockApps, ... }@inputs:
{
  system.primaryUser = "clay";

  users.users.clay = {
    home = "/Users/clay";
  };

  homebrew.casks = [
    "discord"
    "google-drive"
    "parsec"
    "steam"
    "crossover"
    "whatsapp"
    "gcs"
    "garmin-express"
    "android-platform-tools"
  ];
  homebrew.masApps = {
    DaisyDisk = 411643860;
  };

  environment.systemPackages = with pkgs.unstable; [
    earthly
    envconsul
    consul
    vault-bin
    consul-template
    nomad
    pulumi-bin
    pulumiPackages.pulumi-nodejs
    stripe-cli
    terraform
    turso-cli
    rustup
    cargo-binstall
  ];

  system.defaults.dock.persistent-apps = commonDockApps ++ [
    "/Applications/Discord.app"
    {
      spacer = {
        small = true;
      };
    }
  ];
}
