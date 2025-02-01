{ pkgs, ... }@inputs: {
  users.users.clay = { home = "/Users/clay"; };
  homebrew.casks = [ "monokle" ];
  environment.systemPackages = with pkgs.unstable; [
    zoom-us
    slack
    awscli2
    kubernetes-helm
    pre-commit
  ];
  system.defaults.dock.persistent-apps = with pkgs.unstable; [
    "/System/Applications/Mail.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Notion.app"
    "${zoom-us}/Applications/zoom.us.app"
    "${slack}/Applications/Slack.app"
    "/Applications/Zen Browser.app"
    "/Applications/Cursor.app"
  ];
}
