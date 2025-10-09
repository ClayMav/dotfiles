{ pkgs, ... }@inputs:
{
  users.users.clay = {
    home = "/Users/clay";
  };
  homebrew.casks = [
    "monokle"
    "zoom"
    "slack"
    "visual-studio-code"
  ];
  environment.systemPackages = with pkgs.unstable; [
    awscli2
    kubernetes-helm
    pre-commit
    kubectl
  ];
  system.defaults.dock.persistent-apps = with pkgs.unstable; [
    "/Applications/Vivaldi.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Notion.app"
    "/Applications/Cursor.app"
    "/Applications/Sleep Aid.app"
    "/System/Applications/Mail.app"
    "/Applications/zoom.us.app"
    "/Applications/Slack.app"
    {
      spacer = {
        small = true;
      };
    }
  ];
}
