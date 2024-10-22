{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [ "discord" "google-drive" "parsec" "steam" "todoist" ];
  environment.systemPackages = [
    pkgs.delve
    pkgs.earthly
    pkgs.envconsul
    pkgs.consul
    pkgs.vault-bin
    pkgs.consul-template
    pkgs.go
    pkgs.discord
    pkgs.nomad
    # pkgs.pulumi
    pkgs.stripe-cli
    pkgs.terraform
    pkgs.turso-cli
    # pkgs.parsec
    # pkgs.steam
    # pkgs.todoist-electron
  ];
  system.defaults.dock.persistent-apps = [
    "/Applications/Notion.app"
    "/Applications/Brave Browser.app"
    "/Applications/Todoist.app"
    "/Applications/Cursor.app"
  ];
}
