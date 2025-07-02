{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [
    "monokle"
    "zoom"
    "slack"
  ];
  environment.systemPackages = with pkgs.unstable; [
    awscli2
    kubernetes-helm
    pre-commit
    kubectl
  ];
  system.defaults.dock.persistent-apps = with pkgs.unstable; [
    "/Applications/Spark Desktop.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Notion.app"
    "/Applications/zoom.us.app"
    "/Applications/Slack.app"
    "/Applications/Vivaldi.app"
    "/Applications/Cursor.app"
  ];
}
