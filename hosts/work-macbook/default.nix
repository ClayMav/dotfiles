{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [ "monokle" ];
  environment.systemPackages = [
    pkgs.zoom-us
    pkgs.slack
    pkgs.openvpn
    pkgs.awscli2
    pkgs.kubernetes-helm
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
