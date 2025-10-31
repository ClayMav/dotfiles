{ pkgs, commonDockApps, ... }@inputs:
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
  system.defaults.dock.persistent-apps = commonDockApps ++ [
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
