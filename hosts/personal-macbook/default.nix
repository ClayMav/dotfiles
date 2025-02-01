{ pkgs, ... }@inputs: {
  users.users.clay = { home = "/Users/clay"; };
  homebrew.casks = [ "discord" "google-drive" "parsec" "steam" "todoist" ];
  environment.systemPackages = with pkgs.unstable; [
    earthly
    envconsul
    consul
    vault-bin
    consul-template
    discord
    nomad
    pulumi
    stripe-cli
    terraform
    turso-cli
    rustup
    # parsec
    # steam
    # todoist-electron
  ];
  system.defaults.dock.persistent-apps = [
    "/Applications/Discord.app"
    "/Applications/Todoist.app"
    "/Applications/Notion.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Zen Browser.app"
    "/Applications/Cursor.app"
  ];
}
