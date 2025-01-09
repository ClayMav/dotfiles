{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [ "monokle" ];
  environment.systemPackages = with pkgs; [
    zoom-us
    slack
    awscli2
    kubernetes-helm
  ];
  system.defaults.dock.persistent-apps = [
    "/System/Applications/Mail.app"
    "/System/Applications/Calendar.app"
    "/Applications/Notion.app"
    "${pkgs.slack}/Applications/Slack.app"
    "${pkgs.zoom-us}/Applications/zoom.us.app"
    "/Applications/Brave Browser.app"
    "/Applications/Cursor.app"
  ];
}
