{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [ "monokle" ];
  environment.systemPackages = with pkgs.unstable; [
    zoom-us
    slack
    awscli2
    kubernetes-helm
  ];
  system.defaults.dock.persistent-apps = with pkgs.unstable; [
    "/System/Applications/Mail.app"
    "/System/Applications/Calendar.app"
    "/Applications/Notion.app"
    "${zoom-us}/Applications/zoom.us.app"
    "${slack}/Applications/Slack.app"
    "/Applications/Brave Browser.app"
    "/Applications/Cursor.app"
  ];
}
